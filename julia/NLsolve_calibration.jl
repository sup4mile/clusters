using NLsolve

"""
Fixed parameters:
z_H[1,nc] = 1 # domestic agriculture productivity normalized to 1
z_F[ni] = k # foreign productivities

new variables:
z_H[2,nc] # domestic manufacturing productivity
z_H[3,nc] #domestic service productivity

Target:
1. total import/GDP ratio (one constraint)
2. agriculture, manufacture, service, others sectorial import/GDP ratio (four constraints)
"""




# model parameters
nc = 2 # number of counties
ni = 4 # number of industries
η = 0 # the spill-over effect
τ = 1 # trade frictions
ρ = 2 # the elasiticity of substitution within industry
σ = 1.7 # the elasiticity of substitution across industries
L = 1 # total mass of labor at home country
Lx = 1 # total mass of labor at foreign country
w_H = 1 # wage at home normalized to 1
Markup_H = 1/(ρ-1) # markup of firm
E_H = (Markup_H + 1) * w_H # expenditure

μ_lb = Matrix{Real}([0 0.5; 0 0.5; 0 0.5; 0 0.5])
# the entries before the semi-colon is industry 1 for all counties
μ_ub = Matrix{Real}([0.5 1; 0.5 1; 0.5 1; 0.5 1])


# calibration parameters
z_H1 = 1
z_Fk = 1

# need to fill in the blank
# target import share (change into matrix form )
r0 = 0.5 # total import share of GDP
target_ratio = Matrix(ones(Float64, ni, 1))
for i in 1:ni
    target_ratio[i] = 0.5
end
r1 = 0 # agriculture import/value added
r2 = 0 # manufacturing import/valued added
r3 = 0 # service import/value added
r4 = 0 # others import/value added

# calibration errors
# diff1= r1-actualr1


z_H = Matrix((ones(Float64, ni, nc))) # home productivity
z_F= z_Fk * Matrix(ones(Float64, ni, 1)) # foreign productivity

# productivity
function set_z_H(i,z)
    for j in 1:nc
        z_H[i,j]= z
    end
end

# change sectorial productivity
for i in 2:ni
    set_z_H(i,1)
end

# set domestic productivity in manufacturing and service


# Initial guess: labor & foreign wage
lv_ic_H = [1/(ni*nc) for i=1:ni, j = 1:nc]
lv_ic_Hx = [1/(ni*nc) for i=1:ni, j = 1:nc]
lv_if_F = [1/ni for i = 1:ni]
lv_if_Fx = [1/ni for i = 1:ni]
w_F = 1

"""
all prices are factory-gate prices;
all printed labor and production should have τ incorporated
"""



# auxiliary functions
function L_ic_H(i,j,l)
    return (μ_ub[i,j] - μ_lb[i,j]) * (l[i,j] + l[i,j+nc])
end

function E_F(l)
    return (E_H * l[1, 2*nc+3]) / w_H
end

function pv_ic_H(i,j,l)
    return E_H / (z_H[i,j] * L_ic_H(i,j,l) ^ η)
end

function pv_ic_Hx(i,j,l)
    return E_H / (z_H[i,j] * L_ic_H(i,j,l) ^ η)
end

function pv_if_F(i,l)
    return E_F(l) / z_F[i]
end

function pv_if_Fx(i,l)
    return  E_F(l) / z_F[i]
end

# industry_price_home matrix
function p_i_H(i,l) # calculate industry price index at home
    i = trunc(Int,i)
    H_sum = 0 # domestic price aggregation
    F_sum = (τ * pv_if_F(i,l))^(1-ρ) # foreign price aggregation
    for j in 1:nc
        H_sum += (μ_ub[i,j]-μ_lb[i,j]) * pv_ic_H(i,j,l)^(1-ρ)
    end
    sum = (H_sum + F_sum)^(1/(1-ρ))
    return sum
end

function p_i_F(i,l) # calculate industry price index at foreign
    i = trunc(Int, i)
    Hx_sum = 0
    Fx_sum = pv_if_Fx(i,l)^(1-ρ)
    for j in 1:nc
        Hx_sum += ((μ_ub[i,j] - μ_lb[i,j])*(τ * pv_ic_Hx(i,j,l))^(1-ρ))
    end
    sum = (Hx_sum + Fx_sum)^(1/(1-ρ))
    return sum
end

function p_H(l) # calculate final good price index at home
    sum = 0

    for i in 1:ni
        sum += (p_i_H(i,l))^(1-σ)
    end

    return sum^(1/(1-σ))
end

function p_F(l) # calculate final good price index at foreign
    sum = 0
    for i in 1:ni
        sum += (p_i_F(i,l))^(1-σ)
    end
    return sum^(1/(1-σ))
end

function yv_ic_H(i,j,l)
        i = trunc(Int, i)
        j = trunc(Int, j)
    return pv_ic_H(i,j,l)^(-ρ) * p_i_H(i,l)^(ρ-σ) * (p_H(l)^(σ-1)) * E_H
end

function yv_ic_Hx(i,j,l)
        i = trunc(Int, i)
        j = trunc(Int, j)
    return (τ * pv_ic_Hx(i,j,l))^(-ρ) * p_i_F(i,l)^(ρ-σ) * (p_F(l)^(σ-1)) * E_F(l)
end

function yv_if_F(i,l)
        i = trunc(Int, i)
    return (τ * pv_if_F(i,l))^(-ρ) * p_i_H(i,l)^(ρ-σ) * p_H(l)^(σ-1) * E_H
end

function yv_if_Fx(i,l)
        i = trunc(Int, i)
    return pv_if_Fx(i,l)^(-ρ) * p_i_F(i,l)^(ρ-σ) * p_F(l)^(σ-1) * E_F(l)
end

# balanced Trade
function ex(l)
    Hx_sum = 0
    Hx_i_sum = 0
    for i in 1:ni
        Hx_i_sum = 0
        for j in 1:nc
            Hx_i_sum += τ * (μ_ub[i,j] - μ_lb[i,j]) * pv_ic_Hx(i,j,l) * (yv_ic_Hx(i,j,l))
        end
        Hx_sum += Hx_i_sum
    end
    return Hx_sum
end

function imp(l)
    F_sum = 0
    for i in 1:ni
        F_sum +=  τ * pv_if_F(i,l) * yv_if_F(i,l)
    end
    return F_sum
end
"""
function import_ratio(i,l)
    gdp_H_sec = 0
    for j in 1:nc
        gdp_H_sec +=  (μ_ub[i,j] - μ_lb[i,j]) * (yv_ic_H(i,j,l) * pv_ic_H(i,j,l)+ yv_ic_Hx(i,j,l) * pv_ic_Hx(i,j,l))
    end
    return import_sec/gdp_H_sec
end
"""
function f!(F,l)
    for i in 1:ni
        # fixed point for lv_ic_H
        for j in 1:nc
            F[i,j] = (yv_ic_H(i,j,l)) / (z_H[i,j] * L_ic_H(i,j,l) ^ η) - l[i,j]
        end

        # fixed point for lv_ic_Hx
        for j in nc+1:2nc
            F[i,j] = (yv_ic_Hx(i,j-nc,l)) / (z_H[i,j-nc] * L_ic_H(i,j-nc,l) ^ η) - l[i,j]
        end

        # fixed point for lv_if_F
        # lv_if_F starts at col = 2nc+1
        F[i, 2nc+1] = (yv_if_F(i,l)) / z_F[i] - l[i,2nc+1]

        # fixed point for lv_if_Fx
        # lv_if_Fx starts at col = 2nc+2
        F[i, 2nc+2] = (yv_if_Fx(i,l)) / z_F[i] - l[i,2nc+2]


    end
    # fixed point for foreign wage
    # j = 2nc+3

    F[1,2nc+3] = ex(l) - imp(l) # trade balance condition
    F[1,3nc+3+1] = imp(l)/E_H -r0 # target total import GDP ratio

"""
    # agriculture productivity is 1 across counties
    for j in 2nc+3+1:3nc+3
        F[1,j] = l[1,j]-1
    end
    # sectorial productivity meet import target
    for i in 2:ni
        for j in 2nc+3+2:3nc+3
            F[i,2nc+3+1] = import_ratio(i,l) - target_ratio[i]
            F[i,j] = l[1,j]-l[i,j]
        end
    end
"""
    # unused constraints
    for i in 2:ni
        F[i, 2nc+3] = l[i, 2nc+3] - l[1, 2nc+3] # foreign wage
        f[i,3nc+3+1] = l[i,3nc+3+1] - l[1, 3nc+3+1] # foreign productivity
    end
end



# concat into one single matrix as NLsolve input
w_F_v = [w_F for i = 1:ni]
l_initial = hcat(lv_ic_H, lv_ic_Hx, lv_if_F, lv_if_Fx, w_F_v, z_H, z_F)

result = nlsolve(f!, l_initial, autodiff =:forward, iterations = 10000, method =:trust_region)
result.zero

# extract optimal labor from optimization result
lv_ic_H_opt = result.zero[1:ni, 1:nc]
lv_ic_Hx_opt = result.zero[1:ni, nc+1:2nc]
lv_if_F_opt = result.zero[1:ni, 2nc+1]
lv_if_Fx_opt = result.zero[1:ni, 2nc+2]
w_F_opt = result.zero[1, 2nc+3]

# initiatiation
L_ic_H_opt = Matrix{Any}(undef, ni, nc)

pv_ic_H_opt = Matrix{Any}(undef, ni, nc)
pv_ic_Hx_opt = Matrix{Any}(undef, ni, nc)
pv_if_F_opt = Matrix{Any}(undef, ni, 1)
pv_if_Fx_opt = Matrix{Any}(undef, ni, 1)
p_i_H_opt = Matrix{Any}(undef, ni, 1)
p_i_F_opt = Matrix{Any}(undef, ni, 1)
p_H_opt = 0.0
p_F_opt = 0.0
export_opt = 0
import_opt = 0

yv_ic_H_opt = Matrix{Any}(undef, ni, nc)
yv_ic_Hx_opt = Matrix{Any}(undef, ni, nc)
yv_if_F_opt = Matrix{Any}(undef, ni, 1)
yv_if_Fx_opt = Matrix{Any}(undef, ni, 1)
export_opt = ex(result.zero)
import_opt = imp(result.zero)

# calculate all auxiliary functions
for i in 1:ni
    for j in 1:nc
        L_ic_H_opt[i,j] = L_ic_H(i,j, result.zero)
        pv_ic_H_opt[i,j] = pv_ic_H(i,j, result.zero)
        pv_ic_Hx_opt[i,j] = pv_ic_Hx(i,j, result.zero)
        yv_ic_H_opt[i,j] = yv_ic_H(i,j,result.zero)
        yv_ic_Hx_opt[i,j] = yv_ic_Hx(i,j,result.zero)
    end
    pv_if_F_opt[i] = pv_if_F(i,result.zero)
    pv_if_Fx_opt[i] = pv_if_Fx(i,result.zero)
    p_i_H_opt[i] = p_i_H(i,result.zero)
    p_i_F_opt[i] = p_i_F(i,result.zero)
    yv_if_F_opt[i] = yv_if_F(i,result.zero)
    yv_if_Fx_opt[i] = yv_if_Fx(i,result.zero)
end
p_H_opt = p_H(result.zero)
p_F_opt = p_F(result.zero)


################################################################
# actual import to GDP share

import_sec = Matrix{Any}(undef, ni, 1)
gdp_H_sec = Matrix{Any}(undef, ni, 1)
import_gdp_ratio = Matrix{Any}(undef, ni, 1)


for i in 1:ni
    import_sec[i] = yv_if_F_opt[i] * pv_if_F_opt[i]
    gdp_H_sec[i] = 0
    for j in 1:nc
        gdp_H_sec[i] += (μ_ub[i,j] - μ_lb[i,j]) * (yv_ic_H_opt[i,j] * pv_ic_H_opt[i,j]+ yv_ic_Hx_opt[i,j] * pv_ic_Hx_opt[i,j])
    end
    import_gdp_ratio[i] = import_sec[i]/gdp_H_sec[i]
end
import_gdp_ratio
################################################################
# try function
# function import_ratio(i,l) #output the actual import ratio in the model for each industry
#     import_sec = yv_if_F(i,l)*pv_if_F(i,l)
#     gdp_H_sec = 0
#     for j in 1:nc
#         gdp_H_sec +=  (μ_ub[i,j] - μ_lb[i,j]) * (yv_ic_H(i,j,l) * pv_ic_H(i,j,l)+ yv_ic_Hx(i,j,l) * pv_ic_Hx(i,j,l))
#     end
#     return import_sec/gdp_H_sec
# end



################################################################
# print all relevant values
println()
println("level at optimum: ")
println("lv_ic_H: Labor at Home for Home production is ")
display(lv_ic_H_opt)
println("lv_ic_Hx: Labor at Home for Foreign production is ")
display(lv_ic_Hx_opt)
println("lv_if_F: Labor at Foreign for Home production is ", lv_if_F_opt)
println("lv_if_Fx: Labor at Foreign for Foreign production is ", lv_if_Fx_opt)
println("L_ic_H: Aggregate labor at Home is ")
display(L_ic_H_opt)

println("pv_ic_H: Price at Home for Home consumption is ")
display(pv_ic_H_opt)
println("pv_ic_Hx: Factory gate price at Home for Foreign consumption is ")
display(pv_ic_Hx_opt)
println("pv_if_F: Factory gate price at Foreign for Home consumption is ", pv_if_F_opt)
println("pv_if_Fx: Price at Foreign for Foreign consumption is ", pv_if_Fx_opt)
println("p_i_H: Price aggregation by industry at Home is ", p_i_H_opt)
println("p_i_F: Price aggregation by industry at Foreign is ", p_i_F_opt)
println("p_H: Price of final good at Home is $p_H_opt")
println("p_F: Price of final good at Foreign is $p_F_opt")

println("yv_ic_H: Production at Home for Home consumption is ")
display(yv_ic_H_opt)
println("yv_ic_Hx: Production at Home for Foreign consumption is ")
display(yv_ic_Hx_opt)
println("yv_if_F: Production at Foreign for Home consumption is ", yv_if_F_opt)
println("yv_if_Fx: Production at Foreign for Foreign consumption is ", yv_if_Fx_opt)

println("w_F: Foreign wage at optimal is $w_F_opt")
println("Total trade from Home to Foreign is $export_opt")
println("Total trade from Foreign to Home is $import_opt")
println("Import in each industry is $import_sec")
println("Import to GDP ratio is $import_gdp_ratio")
