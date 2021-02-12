"""
finally put this into a function, so that constants and parameters can be
changed easily and do robust change/check.
"""

using JuMP, Ipopt
model = Model(Ipopt.Optimizer)

# constants
nc = 2 # number of counties
ni = 2 # number of industries
L = 1 # total mass of labor

# parameters
η = 0
ρ = 3
σ = 2
μ_lb = vec([0 0; 0.5 0.5])
μ_ub = vec([0.5 0.5; 1 1])
z = vec(ones(Int64, nc, ni))

# total indices
total_ind = 4(nc * ni) + 3ni
# ordering: p_ci, y_ci, l_ci_v, s_ci, Pi, Yi, Ei
# _ci_v for firm level
# _ci for county-industry level

# variables
@variable(model, P, start = 0.5)
@variable(model, Y, start = 0.5)
@variable(model, E, start = 0.5)
@variable(model, x[1:total_ind] >= 0)

# constraints and functions
function p_ci_(i, x...)
    i = trunc(Int, i)
    m = ρ / (ρ - 1)
    return m * (z[i] * x[3nc*ni+i]) ^ -1
end

function p_i_(i, x...)
    i = trunc(Int, i)
    wt = 1 - ρ
    Pi = 0
    for c in 1:nc
        j = nc * (i-1) + c
        Pi += (μ_ub[j] - μ_lb[j]) * (x[j] ^ wt)
    end
    return Pi ^ (1/wt)
end

function p_(x...)
    wt = 1 - σ
    p_agg = 0
    for i in 4nc*ni+1 : 4nc*ni+ni
        p_agg += x[i] ^ wt
    end
    p_agg = p_agg ^ (1/wt)
end

function y_ci_(i, c, x...)
    i = trunc(Int, i)
    c = trunc(Int, c)
    j = nc * (i-1) + c
    return (x[j] ^ (-ρ)) * x[4nc*ni + 2ni + i] * (x[4nc*ni + i] ^ (ρ-1))
end

function y_i_(i, P, E, x...)
    i = trunc(Int, i)
    return x[4nc*ni+i] ^ (-σ) * E * (P ^ (σ-1))
end

function y_(P,E)
    return E / P
end

function l_ci_v_(i, x...)
    i = trunc(Int, i)
    return x[nc*ni + i] / z[i] / x[3nc*ni + i]
end

#=
function l_ci_(i, c, x...)
    i = trunc(Int, i)
    c = trunc(Int, c)
    j = nc * (i-1) + c
    return (μ_ub[j] - μ_lb[j]) * x[2nc*ni + j]
end
=#

function l_sum_(x...)
    sum = 0
    for i in 1:nc*ni
        sum += (μ_ub[i] - μ_lb[i]) * x[2nc*ni + i]
    end
    return sum
end

function s_ci_(i, x...)
    i = trunc(Int, i)
    return ((μ_ub[i] - μ_lb[i]) * x[2nc*ni + i]) ^ η
end

function e_i_(i, x...)
    i = trunc(Int, i)
    return x[4nc*ni + i] * x[4nc*ni + ni + i]
end

# relationship between P,Y,E fully determined in y_ hence no need for e_

# registration
register(model, :p_ci_, 1 + total_ind, p_ci_, autodiff = true)
register(model, :p_i_, 1 + total_ind, p_i_, autodiff = true)
register(model, :p_, total_ind, p_, autodiff = true)
register(model, :y_ci_, 2 + total_ind, y_ci_, autodiff = true)
register(model, :y_i_, 3 + total_ind, y_i_, autodiff = true)
register(model, :y_, 2, y_, autodiff = true)
register(model, :l_ci_v_, 1 + total_ind, l_ci_v_, autodiff = true)
register(model, :l_sum_, total_ind, l_sum_, autodiff = true)
register(model, :s_ci_, 1 + total_ind, s_ci_, autodiff = true)
register(model, :e_i_, 1 + total_ind, e_i_, autodiff = true)

# constraints
@NLconstraint(model, consp1[i = 1:nc*ni], x[i] == p_ci_(i, x...))
@NLconstraint(model, consp2[i = 1:ni], x[4nc*ni+i] == p_i_(i, x...))
@NLconstraint(model, consp3, P == p_(x...))

@NLconstraint(model, consy1[i = 1:ni, c = 1:nc], x[nc*ni + nc*(i-1) + c] == y_ci_(i, c, x...))
@NLconstraint(model, consy2[i = 1:ni], x[4nc*ni+ni+i] == y_i_(i, P, E, x...))
@NLconstraint(model, consy3, Y == y_(P, E))

@NLconstraint(model, consl1[i = 1:nc*ni], x[2nc*ni+i] == l_ci_v_(i, x...))
@constraint(model, consl2, L == l_sum_(x...))

@NLconstraint(model, conss1[i = 1:nc*ni], x[3nc*ni+i] == s_ci_(i, x...))

@NLconstraint(model, conse1[i = 1:ni], x[4nc*ni+2ni+i] == e_i_(i, x...))

@NLobjective(model, Min, 1)

optimize!(model)

# declaration
p_ci = Vector{Any}(undef, nc*ni)
y_ci = Vector{Any}(undef, nc*ni)
l_ci_v = Vector{Any}(undef, nc*ni)
l_ci = Vector{Any}(undef, nc*ni)
s_ci = Vector{Any}(undef, nc*ni)

Pi = Vector{Any}(undef, ni)
Yi = Vector{Any}(undef, ni)
Ei = Vector{Any}(undef, ni)

for i in 1:nc*ni
    p_ci[i] = value(x[i])
end

for i in 1:nc*ni
    y_ci[i] = value(x[nc*ni + i])
end

for i in 1:nc*ni
    l_ci_v[i] = value(x[2nc*ni + i])
end

for i in 1:nc*ni
    l_ci[i] = (μ_ub[i] - μ_lb[i]) * l_ci_v[i]
end

for i in 1:nc*ni
    s_ci[i] = value(x[3nc*ni + i])
end

for i in 1:ni
    Pi[i] = value(x[4nc*ni + i])
end

for i in 1:ni
    Yi[i] = value(x[4nc*ni + ni + i])
end

for i in 1:ni
    Ei[i] = value(x[4nc*ni + 2ni + i])
end

println()
println("level at optimum: ")
println("p_ci = ", p_ci)
println("y_ci = ", y_ci)
println("l_ci_v = ", l_ci_v)
println("l_ci = ", l_ci)
println("s_ci = ", s_ci)

println("agg level: ")
println("P = ", value(P))
println("Y = ", value(Y))
println("E = ", value(E))
