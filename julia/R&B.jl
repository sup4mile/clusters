# this .jl file tests the implementation of matrix indexes
using JuMP, JLD, Ipopt

m = Model(optimizer_with_attributes(Ipopt.Optimizer, "max_iter" =>100000))

# # File name and path for JLD file with results:
# fpath = pwd()
# fname = "/results/previous_solution.jld"

# Enable (=1) / disable (=0) loading of previous solution:
load_previous = 0

# parameters
nc = 2 # number of counties
ni = 2 # number of industries
η = 0 # the spill-over effect
ρ = 2 # the elasiticity of substitution within industry
σ = 2 # the elasiticity of substitution across industries
L = 1 # total mass of labor at home country
Lx = 1 # total mass of labor at foreign country
w_H = 1 # wage at home normalized to 1
Markup_H = 1/(ρ-1) # markup of firm
E_H = (Markup_H + 1) * w_H # expenditure

μ_lb = Matrix{Float64}([0 0.5; 0 0.5])
# the entries before the semi-colon is industry 1 for all counties
μ_ub = Matrix{Float64}([0.5 1; 0.5 1])

z_H = Matrix((ones(Int64, ni, nc))) # home productivity
z_F= Matrix(ones(Int64, ni, 1)) # foreign productivity


#@variable(model, initial guesses, start = 0.5)
@variable(m, lv_ic_H[1:ni, 1:nc] >= 0, start = 0.125)
@variable(m, lv_ic_Hx[1:ni, 1:nc], start = 0.125)
@variable(m, lv_if_F[1:ni], start = 0.5)
@variable(m, lv_if_Fx[1:ni], start = 0.5)
@variable(m, w_F >= 0, start = 1)

# Initial guesses
# # firm_labor_home initial guess
# lv_ic_H = Matrix{Any}(undef, ni, nc) # home production home consumption
# # industry 1 county 2 has index [1,2]; row is industry and col is county
# lv_ic_Hx = Matrix{Any}(undef, ni, nc) # home production foreign consumption
# # firm_labor_foreign initial guess
# lv_if_Fx = Matrix{Any}(undef, ni, 1) # foreign production foreign consumption
# lv_if_F = Matrix{Any}(undef, ni, 1) # foreign production home consumption

# for test, manually input guesses
lv_ic_H = [0.125 0.125; 0.125 0.125]
lv_ic_Hx = [0.125 0.125; 0.125 0.125]
lv_if_F = [0.5 0.5]
lv_if_Fx = [0.5 0.5]

# foreign_wage iniital guess
w_F = 0


# NLExpressions
# expenditure_foreign
@NLexpression(m, E_F, E_H * w_F)

# aggregate_labor matrix
@NLexpression(m, L_ic_H[i = 1:ni, j = 1:nc],
    (μ_ub[i,j] - μ_lb[i,j]) * (lv_ic_H[i,j] + lv_ic_Hx[i,j]))

# firm_price matrix
@NLexpression(m, pv_ic_H[i = 1:ni, j = 1:nc],
    E_H * w_H / (z_H[i,j] * (L_ic_H[i,j] ^ η))
) # firm_price home production home consumption
@NLexpression(m, pv_ic_Hx[i = 1:ni, j = 1:nc],
    pv_ic_H[i,j]) # firm_price home production foreign consumption
@NLexpression(m, pv_if_F[i = 1:ni],
    E_F / z_F[i]) # firm_price foreign production home consumption
@NLexpression(m, pv_if_Fx[i = 1:ni],
    pv_if_F[i]) # firm_price foreign production foreign consumption

# industry_price_home matrix
function p_i_H_(i, x...) # calculate industry price index at home
    i = trunc(Int, i)
    H_sum = 0 # domestic price aggregation
    F_sum = (τ * pv_if_F[i])^(1-ρ) # foreign price aggregation
    for j in 1:nc
        H_sum += ((μ_ub[i,j] - μ_lb[i,j])*(pv_ic_H[i,j])^(1-ρ))
    end
    sum = (H_sum + F_sum)^(1/(1-ρ))
    return sum
end
register(m, :p_i_H_, dimension, p_i_H_, autodiff = true)
@NLexpression(m, p_i_H[i in 1:ni], p_i_H_(i))

function p_i_F_(i, x...) # calculate industry price index at foreign
    i = trunc(Int, i)
    Hx_sum = 0
    Fx_sum = (pv_if_Fx[i])^(1-ρ)
    for j in 1:nc
        Hx_sum += ((μ_ub[i,j] - μ_lb[i,j])*(τ * pv_ic_Hx[i,j])^(1-ρ))
    end
    sum = (Hx_sum + Fx_sum)^(1/(1-ρ))
    return sum
end
register(m, :p_i_F_, dimension, p_i_F_, autodiff = true)
@NLexpression(m, p_i_F[i in 1:ni], p_i_F_(i))

# aggregate price index
function p_H_(x...) # calculate final good price index at home
    sum = 0
    for i in 1:ni
        sum += (p_i_H[i])^(1-σ)
    end
    return sum^(1/(1-σ))
end
register(m, :p_H_, dimension, p_H_, autodiff = true)
@NLexpression(m, p_H, p_H_())

function p_F_(x...) # calculate final good price index at foreign
    sum = 0
    for i in 1:ni
        sum += (p_i_F[i])^(1-σ)
    end
    return sum^(1/(1-σ))
end
register(m, :p_F_, dimension, p_F_, autodiff = true)
@NLexpression(m, p_F, p_F_())

# firm_output_home Matrix
@NLexpression(m, yv_ic_H[i in 1:ni, j in 1:nc],
    [pv_ic_H[i,j]^(-ρ)] * [p_i_H[i]^(ρ-σ)] * [(p_H^(σ-1))] * E_H)
    # firm_home production for home consumption
@NLexpression(m, yv_ic_Hx[i in 1:ni, j in 1:nc],
    [pv_ic_Hx[i,j]^(-ρ)] * [p_i_F[i]^(ρ-σ)] * [(p_F^(σ-1))] * E_F)
    # firm_home production for foreign consumption
@NLexpression(m, pv_if_F[i in 1:ni],
    [pv_if_F[i]^(-ρ)] * [p_i_H[i]^(ρ-σ)] * [(p_H^(σ-1))] * E_H)
    # firm_foreign production for home consumption
@NLexpression(m, yv_if_Fx[i in 1:ni],
    [pv_if_Fx[i]^(-ρ)] * [p_i_F[i]^(ρ-σ)] * [(p_F^(σ-1))] * E_F)
    # firm_foreign production for foreign consumption

# labor inverse demand
@NLexpression(m, lv_ic_H_calc[i in 1:ni, j in 1:nc],
    yv_ic_H[i,j] / (z_H[i] * (L_ic_H[i,j]) ^ η))
@NLexpression(m, lv_ic_Hx_calc[i in 1:ni, j in 1:nc],
    yv_ic_Hx[i,j] / (z_H[i] * (L_ic_Hx[i,j]) ^ η))
@NLexpression(m, lv_if_F_calc[i in 1:ni],
    τ * yv_ic_F[i,j] / z_F[i])
@NLexpression(m, lv_if_Fx_calc[i in 1:ni],
    τ * yv_ic_Fx[i] / z_F[i])

# balanced Trade
function export_(pv_ic_Hx, yv_ic_Hx, x...)
    Hx_sum = 0
    Hx_i_sum = 0
    for i in 1:ni
        for j in 1:nc
            Hx_i_sum += (μ_ub[i, j] - μ_lb[i, j]) * (τ * pv_ic_Hx[i, j]) * (yv_ic_Hx[i, j])
        end
            Hx_sum += Hx_i_sum
        end
    return Hx_sum
end

function import_(pv_if_F, yv_if_F, x...)
    F_sum = 0
    for i in i:ni
        F_sum +=  (τ * pv_if_F[i]) * (yv_if_F[i])
    end
    return Fx_sum
end

register(m, :import_, dimension, import_, autodiff = true )
register(m, :export_, dimension, export_, autodiff = true)
@NLexpression(m, import_, import_())
@NLexpression(m, export_, export_())



# Optimization problem
# labor supply = labor demand
@NLconstraint(m, [i = 1:ni], [j = 1:nc], lv_ic_H[i,j] == lv_ic_H_calc[i,j])
@NLconstraint(m, [i = 1:ni], [j = 1:nc], lv_ic_Hx[i,j] == lv_ic_Hx_calc[i,j])
@NLconstraint(m, [i = 1:ni], lv_if_F[i] == lv_if_F_calc[i])
@NLconstraint(m, [i = 1:ni], lv_if_Fx[i] == lv_if_Fx_calc[i])
# trade balance condition
@NLconstraint(m, import_ == export_ ) # domestic = foreign


# run optimization
optimize!(m)

# print results
print(solution_summary(m))
value()

# some values are not in JuMP but needs to be printed


# save values




# # test index
# function L_ic_H_(lv_ic_H, lv_ic_Hx, x...)
#     L_ic = Matrix{Any}(undef, ni, nc)
#
#     for i in 1:ni
#         for j in 1:nc
#             temp1 = μ_ub[i, j]
#             temp2 = μ_lb[i, j]
#             temp3 = lv_ic_H[i, j]
#             temp4 = lv_ic_Hx[i, j]
#             println("μ_ub is $temp1")
#             println("μ_lb is $temp2")
#             println("lv_ic_H is $temp3")
#             println("lv_ic_Hx is $temp4")
#
#             L_ic[i, j] = (μ_ub[i, j] - μ_lb[i,j]) * (lv_ic_H[i, j] + lv_ic_Hx[i, j])
#
#             temp5 = L_ic[i, j]
#             println("L_ic[i,j] is $temp5")
#         end
#     end
#
#     return L_ic
# end
# # test functions
# a = Array([0.4 0.4; 0.6 0.6]) # home employment
# b = Array([0.6 0.6; 0.4 0.4]) # export employment
# total = L_ic_H_(a, b)
# print(total)
