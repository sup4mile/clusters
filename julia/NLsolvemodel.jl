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
w_F = 0


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

pv_if_F(1,l_initial)

function pv_if_Fx(i,l)
    return  E_F(i,l) / z_F[i]
end

pv_if_Fx(1,l_initial)


# industry_price_home matrix
function p_i_H(i) # calculate industry price index at home
    i = trunc(Int, i)
    H_sum = 0 # domestic price aggregation
    F_sum = (τ * pv_if_F[i])^(1-ρ) # foreign price aggregation
    for j in 1:nc
        H_sum += ((μ_ub[i,j] - μ_lb[i,j])*(pv_ic_H(i,j))^(1-ρ))
    end
    sum = (H_sum + F_sum)^(1/(1-ρ))
    return sum
end


function p_i_F(i) # calculate industry price index at foreign
    i = trunc(Int, i)
    Hx_sum = 0
    Fx_sum = (pv_if_Fx(i))^(1-ρ)
    for j in 1:nc
        Hx_sum += ((μ_ub[i,j] - μ_lb[i,j])*(τ * pv_ic_Hx(i,j))^(1-ρ))
    end
    sum = (Hx_sum + Fx_sum)^(1/(1-ρ))
    return sum
end

function p_H() # calculate final good price index at home
    sum = 0
    for i in 1:ni
        sum += (p_i_H(i))^(1-σ)
    end
    return sum^(1/(1-σ))
end

function p_F() # calculate final good price index at foreign
    sum = 0
    for i in 1:ni
        sum += (p_i_F(i))^(1-σ)
    end
    return sum^(1/(1-σ))
end

function yv_ic_H(i::Any, j::Any)
        i = trunc(Int, i)
        j = trunc(Int, j)
    return [pv_ic_H(i,j)^(-ρ)] * [p_i_H(i)^(ρ-σ)] * [(p_H()^(σ-1))] * E_H
end

function yv_ic_Hx(i::Any, j::Any)
        i = trunc(Int, i)
        j = trunc(Int, j)
    return [pv_ic_Hx(i,j)^(-ρ)] * [p_i_F(i)^(ρ-σ)] * [(p_F()^(σ-1))] * E_F
end

function yv_ic_F(i::Any)
        i = trunc(Int, i)
    return [pv_if_F(i)^(-ρ)] * [p_i_H(i)(ρ-σ)] * [(p_H()^(σ-1))] * E_H
end

function yv_ic_Fx(i::Any)
        i = trunc(Int, i)
    return [pv_if_Fx(i)^(-ρ)] * [p_i_F(i)^(ρ-σ)] * [(p_F()^(σ-1))] * E_F
end



# balanced Trade
function ex()
    Hx_sum = 0
    Hx_i_sum = 0
    for i in 1:ni
        for j in 1:nc
            Hx_i_sum += (μ_ub[i,j] - μ_lb[i,j]) * (τ * pv_ic_Hx(i,j)) * (yv_ic_Hx(i,j))
        end
        Hx_sum += Hx_i_sum
    end
    return Hx_sum
end

function im()
    F_sum = 0
    for i in i:ni
        F_sum +=  (τ * pv_if_F(i)) * (yv_if_F(i))
    end
    return Fx_sum
end


function f!(F,l)
    for i in 1:ni
        for j in 1:nc
            F[i,j] = yv_ic_H(i,j) / (z_H[i,j] * L_ic_H(i,j,l) ^ η) - l[i,j]
        end


        for j in nc+1:2nc
            F[i,j] = yv_ic_Hx(i,j)/ (z_H[i,j] * L_ic_H(i,j,l) ^ η) - l[ij]
        end

        # j = 2nc+1
        F[i, 2nc+1] = τ * yv_ic_F(i) / z_F[i] - l[i,2nc+1]

        # j = 2nc+2
        F[i, 2nc+2] = τ * yv_ic_Fx(i) / z_F[i] - l[i,2nc+2]

        # j = 2nc+3
        F[i,2nc+3] = ex() - im()
    end


    # place holder
    for i in 2:ni
        F[i,2nc+3] = 0
    end
end

nlsolve(f!, l_initial, autodiff =:forward)
