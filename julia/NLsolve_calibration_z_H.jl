using NLsolve

#EXPERIMENT
import XLSX

xf = XLSX.readxlsx("../data/data/processed/Import_to_GDP_2019.xlsx")

#display(XLSX.sheetnames(xf))

sh = xf["2019final"]

#display(sh)

#display(sh["F2:F5"])

target_import_shares = sh["F2:F5"]
target_import_shares = [1.0 for num=1:4]
target_F = sh["F6"]
target_F = 1.0

#END OF EXPERIMENT



# no county level productivity

"""
Fixed parameters:
z_H[1] = 1 # domestic agriculture productivity normalized to 1
z_F[ni] = k # foreign productivities

new variables:
z_H[2] # domestic manufacturing productivity
z_H[3] #domestic service productivity

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

"""
# read in data
target_H = Matrix(ones(Float64, ni, 1))
for i in 1:ni
    target_H[i] = 0.5
end

target_F = 0

# make a column of keys

"""

# target_H = Matrix(ones(Float64, ni, 1))
# for i in 1:ni
#     target_H[i] = 0.4
# end
# #target_F = 0.4


target_H = target_import_shares

# calibration errors
# diff1= r1-actualr1


z_H = Matrix((ones(Float64, ni, nc))) # home productivity
z_F= z_Fk * Matrix(ones(Float64, ni, 1)) # foreign productivity


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
    return E_H / (z_H[i] * L_ic_H(i,j,l) ^ η)
end

function pv_ic_Hx(i,j,l)
    return E_H / (z_H[i] * L_ic_H(i,j,l) ^ η)
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

function import_ratio(i,l)
    import_sec = yv_if_F(i,l) * pv_if_F(i,l)
    gdp_H_sec = 0
    for j in 1:nc
        gdp_H_sec +=  (μ_ub[i,j] - μ_lb[i,j]) * (yv_ic_H(i,j,l) * pv_ic_H(i,j,l)+ yv_ic_Hx(i,j,l) * pv_ic_Hx(i,j,l))
    end
    return import_sec/gdp_H_sec
end


function f!(F,l)
    for i in 1:ni
        # fixed point for lv_ic_H
        for j in 1:nc
            F[i,j] = (yv_ic_H(i,j,l)) / (z_H[i] * L_ic_H(i,j,l) ^ η) - l[i,j]
        end

        # fixed point for lv_ic_Hx
        for j in nc+1:2nc
            F[i,j] = (yv_ic_Hx(i,j-nc,l)) / (z_H[i] * L_ic_H(i,j-nc,l) ^ η) - l[i,j]
        end

        # fixed point for lv_if_F
        # lv_if_F starts at col = 2nc+1
        F[i, 2nc+1] = (yv_if_F(i,l)) / z_F[i] - l[i,2nc+1]

        # fixed point for lv_if_Fx
        # lv_if_Fx starts at col = 2nc+2
        F[i, 2nc+2] = (yv_if_Fx(i,l)) / z_F[i] - l[i,2nc+2]

    end

    # trade balance condition
    F[1,2nc+3] = ex(l) - imp(l)
    # z_H[1] agriculture productivity at home normalized to 1
    F[1,2nc+4] = l[1,2nc+4] -1
    # target total import GDP ratio
    F[1,2nc+5] = imp(l)/E_H - target_F


    for i in 2:ni

        F[i, 2nc+3] = l[i, 2nc+3] - l[1, 2nc+3] # foreign wage

        F[i, 2nc+4] = import_ratio(i,l) - target_H[i]
        F[i, 2nc+5] = l[i, 2nc+5] - l[1, 2nc+5] # foreign productivity
    end
end

#Same as it was before the addition of endogenous productivity
function f!Basic(F,l)
    println(typeof(l))
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
    F[1,2nc+3] = ex(l) - imp(l)

    for i in 2:ni
        F[i,2nc+3] = l[i-1,2nc+3] - l[i, 2nc+3]
    end
    # labor sum to 1 constraint

end



# concat into one single matrix as NLsolve input
w_F_v = [w_F for i = 1:ni]
l_initial = hcat(lv_ic_H, lv_ic_Hx, lv_if_F, lv_if_Fx, w_F_v, z_H, z_F)


#function kindLikeF(x)
function F2(F,l)
    println("F2 iter: ", typeof(l))
    #set global productivities to x, which is producitivity guess
    #display(l)
    print("Displaying l:")
    display(l)
    #TODO transpose matrices
    
    l_copy = copy(l)
    #We put our Differentiating object back into a usable form (into a Matrix, that is)
    global z_H = [l_copy[i,j].value for i=1:ni, j=1:nc]
    print("z_H:")
    display(z_H)
    global z_F = [l_copy[i,j].value for i=1:ni, j=nc+1:nc+1]
    print("z_F:")
    display(z_F)

    p_initial = hcat(z_H, z_F)
    print("hcat(z_H, z_F):")
    display(p_initial)

    l_initial = hcat(lv_ic_H, lv_ic_Hx, lv_if_F, lv_if_Fx, w_F_v)
    display(l_initial)

    #numerically approximate labor for productivity guess
    result = nlsolve(f!Basic, l_initial, autodiff =:forward, iterations = 10000, method =:trust_region)
    
    #obtain normal for productivity guess by using real-world data vs incomeShare(productivity guess, labor approximation)
    #you won't calculate prod relative to expected prod. You don't have that data. Rather, you'll compare guess imports with
    #respect to real imports

    #define l based on result.zero, which really should be result.zero itself

    labor = result.zero
    #print("Labor:\n")
    #display(labor)
    #for each industry prod guess, there is industry import share guess
        #home
        #for each prod in range 1 to ni
        for i in 1:ni
            F[i] = import_ratio(i,labor) - target_H[i]
        end

        #foreign
        #for each prod in range ni+1 to ni*2
        for i in ni+1:ni*2
            F[i] = imp(labor)/E_H - target_F
        end
    
    #print("F:\n")
    #display(F)

    #print("(2) Displaying l:")
    #display(l)
end

#guess of productivities
prod_guess = 1.0
prod_guess_home =  Matrix((ones(Float64, ni, nc))) # home productivity
prod_guess_foreign = Matrix(ones(Float64, ni, 1)) # foreign productivity
prod_guess_all = hcat(prod_guess_home, prod_guess_foreign)
display(prod_guess_all)

old = false
if(old)
    l_initial = hcat(lv_ic_H, lv_ic_Hx, lv_if_F, lv_if_Fx, w_F_v)
    result = nlsolve(f!Basic, l_initial, autodiff =:forward, iterations =:10000, method =:trust_region)
else
    finalResult = nlsolve(F2, prod_guess_all, autodiff =:forward, iterations =:10000, method =:trust_region)
end



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

import_ratio_opt = Matrix{Any}(undef, ni, 1)
for i in 1:ni
    import_ratio_opt[i]=import_ratio(i,result.zero)
end



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
println("Import to GDP ratio by industry is $import_ratio_opt")
