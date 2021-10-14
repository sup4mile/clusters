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

# Initial guess: labor & foreign wage
lv_ic_H = [0.125 for i=1:ni, j = 1:nc]
lv_ic_Hx = [0.125 for i=1:ni, j = 1:nc]
lv_if_F = [0.5 for i = 1:ni]
lv_if_Fx = [0.5 for i = 1:ni]
w_F = 0.6

# concat into one single matrix as NLsolve input
w_F_v = [w_F for i = 1:ni]
l_initial = hcat(lv_ic_H, lv_ic_Hx, lv_if_F, lv_if_Fx, w_F_v)


function L_ic_H(i,j,l)
    return (μ_ub[i,j] - μ_lb[i,j]) * (l[i,j] + l[i,j+nc])
end

function E_F(i,l)
    return E_H * l[i,2nc+3]
end

function pv_ic_H(i,j,l)
    return E_H * w_H / (z_H[i,j] * L_ic_H(i,j,l) ^ η)
end

function pv_ic_Hx(i,j,l)
    return E_H * w_H / (z_H[i,j] * L_ic_H(i,j,l) ^ η)
end

function pv_if_F(i,l)
    return E_F(i,l) / z_F[i]
end

function pv_if_Fx(i,l)
    return  E_F(i,l) / z_F[i]
end

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
    return pv_ic_Hx(i,j,l)^(-ρ) * p_i_F(i,l)^(ρ-σ) * (p_F(l)^(σ-1)) * E_F(i,l)
end

function yv_if_F(i,l)
        i = trunc(Int, i)
    return pv_if_F(i,l)^(-ρ) * p_i_H(i,l)^(ρ-σ) * p_H(l)^(σ-1) * E_H
end

function yv_if_Fx(i,l)
        i = trunc(Int, i)
    return pv_if_Fx(i,l)^(-ρ) * p_i_F(i,l)^(ρ-σ) * p_F(l)^(σ-1) * E_F(i,l)
end

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

function imp(l)
    F_sum = 0
    for i in 1:ni
        F_sum +=  (τ * pv_if_F(i,l)) * (yv_if_F(i,l))
    end
    return F_sum
end

function f!(F,l)
    for i in 1:ni
        # fixed point for lv_ic_H
        for j in 1:nc
            F[i,j] = yv_ic_H(i,j,l) / (z_H[i,j] * L_ic_H(i,j,l) ^ η) - l[i,j]
        end

        # fixed point for lv_ic_Hx
        for j in nc+1:2nc
            F[i,j] = yv_ic_Hx(i,j-nc,l)/ (z_H[i,j-nc] * L_ic_H(i,j-nc,l) ^ η) - l[i,j]
        end

        # fixed point for lv_if_F
        # lv_if_F starts at col = 2nc+1
        F[i, 2nc+1] = τ * yv_if_F(i,l) / z_F[i] - l[i,2nc+1]

        # fixed point for lv_if_Fx
        # lv_if_Fx starts at col = 2nc+2
        F[i, 2nc+2] = τ * yv_if_Fx(i,l) / z_F[i] - l[i,2nc+2]

        # fixed point for foreign wage
        # j = 2nc+3
        F[i,2nc+3] = ex(l) - imp(l)
    end
end

result = nlsolve(f!, l_initial, autodiff =:forward)
result.zero
