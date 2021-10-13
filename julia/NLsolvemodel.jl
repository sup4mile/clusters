using NLsolve


# parameters
nc = 2 # number of counties
ni = 2 # number of industries
η = 0 # the spill-over effect
τ = 1 # trade frictions
ρ = 2 # the elasiticity of substitution within industry
σ = 1.9 # the elasiticity of substitution across industries
L = 1 # total mass of labor at home country
Lx = 1 # total mass of labor at foreign country
w_H = 1 # wage at home normalized to 1
Markup_H = 1/(ρ-1) # markup of firm
E_H = (Markup_H + 1) * w_H # expenditure

μ_lb = Matrix{Real}([0 0.5; 0 0.5])
# the entries before the semi-colon is industry 1 for all counties
μ_ub = Matrix{Real}([0.5 1; 0.5 1])

z_H = Matrix((ones(Float64, ni, nc))) # home productivity
z_F= Matrix(ones(Float64, ni, 1)) # foreign productivity

# labor initial guess
l_initial = [ [0.125 for i=1:ni, j = 1:2nc] [0.5 for i = 1:ni, j = (2nc+1):(2nc+2)] [0.5 for i = 1:ni]]


function L_ic_H(i,j,l)
    return (μ_ub[i,j] - μ_lb[i,j]) * (l[i,j] + l[i,j+nc])
end

# L_ic_H(1,1,l_initial)


# foreign wage
# E_F = E_H * w_F
function E_F(i,l)
    return E_H * l[i,2nc+3]
end

E_F(1,l_initial)


function pv_ic_H(i,j,l)
    return E_H * w_H / (z_H[i,j] * L_ic_H(i,j,l) ^ η)
end

pv_ic_H(1,1,l_initial)

function pv_ic_Hx(i,j,l)
    return E_H * w_H / (z_H[i,j] * L_ic_H(i,j,l) ^ η)
end

pv_ic_Hx(1,1,l_initial)

function pv_if_F(i,l)
    return E_F(i,l) / z_F[i]
end

# pv_if_F = (ρ/(ρ-1))*w_F / z_F
pv_if_F(1,l_initial)

function pv_if_Fx(i,l)
    return  E_F(i,l) / z_F[i]
end

pv_if_Fx(1,l_initial)


# industry_price_home matrix
function p_i_H(i,l) # calculate industry price index at home
    i = trunc(Int,i)
    H_sum = 0 # domestic price aggregation
    F_sum = τ * pv_if_F(i,l)^(1-ρ) # foreign price aggregation
    for j in 1:nc
        H_sum += (μ_ub[i,j]-μ_lb[i,j]) * pv_ic_H(i,j,l)^(1-ρ)
    end
    sum = (H_sum + F_sum)^(1/(1-ρ))
    return sum
end

p_i_H(1,l_initial)

function p_i_F(i,l) # calculate industry price index at foreign
    i = trunc(Int, i)
    Hx_sum = 0
    Fx_sum = (pv_if_Fx(i,l))^(1-ρ)
    for j in 1:nc
        Hx_sum += ((μ_ub[i,j] - μ_lb[i,j])*(τ * pv_ic_Hx(i,j,l))^(1-ρ))
    end
    sum = (Hx_sum + Fx_sum)^(1/(1-ρ))
    return sum
end

p_i_F(1,l_initial)

function p_H(i,l) # calculate final good price index at home
    sum = 0
    for i in 1:ni
        sum += (p_i_H(i,l))^(1-σ)
    end
    return sum^(1/(1-σ))
end

p_H(1,l_initial)

function p_F(i,l) # calculate final good price index at foreign
    sum = 0
    for i in 1:ni
        sum += (p_i_F(i,l))^(1-σ)
    end
    return sum^(1/(1-σ))
end

p_F(1,l_initial)


function yv_ic_H(i,j,l)
        i = trunc(Int, i)
        j = trunc(Int, j)
    return pv_ic_H(i,j,l)^(-ρ) * p_i_H(i,l)^(ρ-σ) * (p_H(i,l)^(σ-1)) * E_H
end

yv_ic_H(1,1,l_initial)

function yv_ic_Hx(i,j,l)
        i = trunc(Int, i)
        j = trunc(Int, j)
    return pv_ic_Hx(i,j,l)^(-ρ) * p_i_F(i,l)^(ρ-σ) * (p_F(i,l)^(σ-1)) * E_F(i,l)
end

yv_ic_Hx(1,2,l_initial)

yv_ic_H(2,2,l_initial)


function yv_if_F(i,l)
        i = trunc(Int, i)
    return pv_if_F(i,l)^(-ρ) * p_i_H(i,l)^(ρ-σ) * p_H(i,l)^(σ-1) * E_H
end

yv_if_F(2,l_initial)

function yv_if_Fx(i,l)
        i = trunc(Int, i)
    return pv_if_Fx(i,l)^(-ρ) * p_i_F(i,l)^(ρ-σ) * p_F(i,l)^(σ-1) * E_F(i,l)
end

yv_if_Fx(1,l_initial)




# balanced Trade
function ex(l)
    Hx_sum = 0
    Hx_i_sum = 0
    for i in 1:ni
        for j in 1:nc
            Hx_i_sum += (μ_ub[i,j] - μ_lb[i,j]) * (τ * pv_ic_Hx(i,j,l)) * (yv_ic_Hx(i,j,l))
        end
        Hx_sum += Hx_i_sum
    end
    return Hx_sum
end

ex(l_initial)

function imp(l)
    F_sum = 0
    for i in 1:ni
        F_sum +=  (τ * pv_if_F(i,l)) * (yv_if_F(i,l))
    end
    return F_sum
end

imp(l_initial)


function f!(F,l)
    for i in 1:ni
        for j in 1:nc
            F[i,j] = yv_ic_H(i,j,l) / (z_H[i,j] * L_ic_H(i,j,l) ^ η) - l[i,j]
        end


        for j in nc+1:2nc
            F[i,j] = yv_ic_Hx(i,j,l)/ (z_H[i,j] * L_ic_H(i,j,l) ^ η) - l[i,j]
        end

        # j = 2nc+1
        F[i, 2nc+1] = τ * yv_ic_F(i,l) / z_F[i] - l[i,2nc+1]

        # j = 2nc+2
        F[i, 2nc+2] = τ * yv_ic_Fx(i,l) / z_F[i] - l[i,2nc+2]

        # j = 2nc+3
        F[i,2nc+3] = ex(l) - im(l)
    end
end

nlsolve(f!, l_initial, autodiff =:forward)
