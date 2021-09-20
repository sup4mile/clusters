nc = 2 # number of counties
ni = 2 # number of industries
L = 1 # total mass of labor at home country
Lx = 1 # total mass of labor at foreign country

# parameters
η = 0
ρ = 2
σ = 2

# 1. labor (initial guess)
lv_ci_H
lv_ci_Hx
lv_i_F
lv_i_Fx

# 2. aggregate labor
L_ic = (μ_ub - μ_lb)*(lv_ci_H + lv_ci_Hx)
# spill over: η = 0

# Wage:
w_H = 1
w_F:

# productivity
z_H:
z_F:

# expenditure
E_H = ρ/(1-ρ)
E_F =

# 3. prices
# firm level:
pv_ic_H = pv_ic_Hx = ρ/(1-ρ)*(w_H/(z_H*(L_ic^η))
pv_ic_Hx:
pv_if_F = pv_if_Fx = ρ/(1-ρ)*(w_F/z_F)
pv_if_Fx:

# p: price variables
# v: any variables with v means firm-level

# ic: county-industry level
# if: foreign-industry level

# H: domestic production for domestic consumption
# H: domestic production for foreign consumption
# F: foreign production for foreign consumption
# Fx: foreign production for domestic consumption

# 3.1 aggregate prices
p_i_H = {
    H_sum = 0
    Fx_sum = (τ*pv_if_Fx)^(1-ρ)
    for i in 1 : nc # should use i = 1 : nc in the price vector pv_ic_H and μ_ub μ_lb
        H_sum += ((μ_ub[] - μ_lb[])*(pv_ic_H[])^(1-ρ))
    end
    sum = (H_sum + Fx_sum)^(1/(1-ρ))
    return sum

}

p_i_F = {
    Hx_sum = 0
    F_sum = (pv_if_F)^(1-ρ)
    for i in 1 : nc # should use i = 1 : nc in the price vector pv_ic_H
        Hx_sum += ((μ_ub[] - μ_lb[])*(τ * pv_ic_Hx[])^(1-ρ))
    end
    sum = (Hx_sum + F_sum)^(1/(1-ρ))
    return sum

}

p_H = {
    sum = 0
    for i in 1:ni # should use i = 1 : ni in the price vector p_i_H
        sum += (p_i_H[])^(1-σ)
    end
    return sum^(1/(1-σ))

}

p_F = {
    sum = 0
    for i in 1:ni # should use i = 1 : ni in the price vector p_i_F
        sum += (p_i_F[])^(1-σ)
    end
    return sum^(1/(1-σ))

}


# 4. output
yv_ic_H =  [pv_ic_H^(-ρ)] * [p_i_H^(ρ-σ)] * [(p_H^(σ-1))] * E_H           # [(pv_ic_H/p_i_H)*ρ]*[(p_i_H/p_H)^σ]*(E_H/p_H)
yv_ic_Hx = [pv_ic_hx^(-ρ)] * [p_i_F^(ρ-σ)] * [(p_F^(σ-1))] * E_F
yv_if_F =  [pv_if_F^(-ρ)] * [p_i_F^(ρ-σ)] * [(p_F^(σ-1))] * E_F
yv_if_Fx = [pv_if_Fx^(-ρ)] * [p_i_H^(ρ-σ)] * [(p_H^(σ-1))] * E_H

y_iH:
y_iHx:
y_iF:
y_iFx:


Pi:
Pix:
Yi:
Yix:
Ei:
Eix:


# Trade balanced condition

Hx_sum = 0
Hx_i_sum = 0

function domestic_trd()
    Hx_sum = 0
    Hx_i_sum = 0
    for i in 1:ni

        for j in 1:nc
            Hx_i_sum += (μ_ub[] - μ_lb[]) * (τ * pv_ic_Hx[]) * (yv_ic_Hx[])
        end

        Hx_sum += Hx_i_sum

        return Hx_sum
    end
end

function foreign_trd():
    Fx_sum = 0
        for i in i:ni
            Fx_sum += (yv_if_Fx[]) * (τ * pv_if_Fx[])

            return Fx_sum
        end
end

# domestic_trd() = foreign_trd()
