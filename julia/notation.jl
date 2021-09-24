nc = 2 # number of counties
ni = 2 # number of industries
L = 1 # total mass of labor at home country
Lx = 1 # total mass of labor at foreign country

# parameters
η = 0
ρ = 2
σ = 2

# naming rules
    # p: price variables
    # v: any variables with v means firm-level

    # ic: county-industry level
    # if: foreign-industry level

    # H: domestic production for domestic consumption
    # H: domestic production for foreign consumption
    # F: foreign production for foreign consumption
    # Fx: foreign production for domestic consumption


#########################################################
# 1. labor (initial guess) (4)
lv_ci_H # nc*ni array
lv_ci_Hx
lv_i_F
lv_i_Fx


@variable(model, lv_ci_H, start = 0.5)
@variable(model, lv_ci_Hx, start = 0.5)
@variable(model, lv_ci_F, start = 0.5)
@variable(model, lv_ci_Fx, start = 0.5)

# productivity
z_H = vec(ones(Int64, nc, ni)) # productivity
z_F= vec(ones(Int64, ni))

    # inverse demand function of labor (4)
function lv_ci_H()
    return yv_ic_H*((z_H*L_ic_H^η)^(-1))
end

function lv_ci_Hx()
    return τ*yv_ic_Hx*((z_H*L_ic_H^η)^(-1))
end

function lv_ci_F()
    return τ*yv_ic_F*(z_F^(-1))
end

function lv_ci_Fx()
    return yv_ic_Fx*(z_F^(-1))
end


# Wage:
w_H = 1
@variable(model, w_F, start = 0.5)


# 2. aggregate labor (2)
function L_ic_H()

    return (μ_ub - μ_lb)*(lv_ci_H + lv_ci_Hx)
end
# spill over: η = 0

# foreign aggregate labor


#########################################################
# expenditure
E_H = ρ/(1-ρ)
E_F = #???

# 3. prices (8)
# firm level:
function pv_ic_H()

     return (ρ/(1-ρ))*(w_H/(z_H*(L_ic^η))
end


    # pv_ic_Hx = pv_ic_H
function pv_ic_Hx()

     return (ρ/(1-ρ))*(w_H/(z_H*(L_ic^η))
end

function pv_if_F()

    return ρ/(1-ρ)*(w_F/z_F)
end

    # pv_if_Fx = pv_if_F
function pv_if_Fx()

    return ρ/(1-ρ)*(w_F/z_F)
end


# 3.1 aggregate prices
function p_i_H()
    H_sum = 0
    Fx_sum = (τ*pv_if_Fx)^(1-ρ)
    for i in 1 : nc # should use i = 1 : nc in the price vector pv_ic_H and μ_ub μ_lb
        H_sum += ((μ_ub[] - μ_lb[])*(pv_ic_H[])^(1-ρ))
    end
    sum = (H_sum + Fx_sum)^(1/(1-ρ))
    return sum
end

function p_i_F()
    Hx_sum = 0
    F_sum = (pv_if_F)^(1-ρ)
    for i in 1 : nc # should use i = 1 : nc in the price vector pv_ic_H
        Hx_sum += ((μ_ub[] - μ_lb[])*(τ * pv_ic_Hx[])^(1-ρ))
    end
    sum = (Hx_sum + F_sum)^(1/(1-ρ))
    return sum
end

function p_H()
    sum = 0
    for i in 1:ni # should use i = 1 : ni in the price vector p_i_H
        sum += (p_i_H[])^(1-σ)
    end
    return sum^(1/(1-σ))
end

function p_F()
    sum = 0
    for i in 1:ni # should use i = 1 : ni in the price vector p_i_F
        sum += (p_i_F[])^(1-σ)
    end
    return sum^(1/(1-σ))
end


#########################################################
# 4. output (8)
yv_ic_H =  [pv_ic_H^(-ρ)] * [p_i_H^(ρ-σ)] * [(p_H^(σ-1))] * E_H           # [(pv_ic_H/p_i_H)*ρ]*[(p_i_H/p_H)^σ]*(E_H/p_H)
yv_ic_Hx = [pv_ic_hx^(-ρ)] * [p_i_F^(ρ-σ)] * [(p_F^(σ-1))] * E_F
yv_if_F =  [pv_if_F^(-ρ)] * [p_i_F^(ρ-σ)] * [(p_F^(σ-1))] * E_F
yv_if_Fx = [pv_if_Fx^(-ρ)] * [p_i_H^(ρ-σ)] * [(p_H^(σ-1))] * E_H


# 4.1 aggregate output - industry level (4)
y_iH:
y_iHx:
y_iF:
y_iFx:

# 4.2 aggregate output - national level (2)

Yi:
Yix:

Ei:
Eix:


#########################################################
# Trade balanced condition (1)

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

#########################################################
# JuMP optimizer structure

using JuMP, Ipopt


m = Model(with_optimizer(# the optimizer))
@variable (# model name, usually m, variable name, start = initial value)
@variable (# do this for every variable)
@NLJuMP.optimizee(# if your objective function is nonlinear)
@NLconstraint(#if your constraint is nonlinear)
JuMP.optimize!(#model name)

# To create arrays of variables we append brackets to the variable name. For example:
@variable(m,x[1:M,1:N]>=0) # M by N array of variables
# Finally, bounds can depend on variable indices:
@variable(m,x[i=1:10]>=i)
