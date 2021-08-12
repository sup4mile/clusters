using JuMP, Ipopt, JLD
model = Model(optimizer_with_attributes(Ipopt.Optimizer, "max_iter" => 100000))

# File name and path for JLD file with results:
fpath = pwd()
fname = "/results/previous_solution.jld"

# Enable (=1) / disable (=0) loading of previous solution:
load_previous = 1
# constants
nc = 2 # number of counties
ni = 2 # number of industries
L = 1 # total mass of labor at home country
Lx = 1 # total mass of labor at foreign country

# parameters
η = 0
ρ = 2
σ = 2
μ_lb = vec([0 0; 0.5 0.5])
μ_ub = vec([0.5 0.5; 1 1])
zH = vec(ones(Int64, nc, ni))
zF= vec(ones(Int64, ni))
τ = 1.1
E = ρ/(ρ-1)

# total indices
total_ind = 8(nc * ni) + 14ni
# ordering: p_ciH, p_ciHx, p_iF, p_iFx, y_ciH, y_ciHx, y_iH, y_iHx, y_iF, y_iFx
# l_ci_vH, l_ci_vHx, l_i_vF, l_i_vFx, s_ciH, s_ciHx
# Pi, Pix, Yi, Yix, Ei, Eix
# 24 inputs

# _ci_v for firm level
# _ci for county-industry level
if load_previous == 0
    # variables
    @variable(model, P, start = 0.5)
    @variable(model, Y, start = 0.5)
    @variable(model, Px, start = 0.5)
    @variable(model, Yx, start = 0.5)
    #@variable(model, E, start = 0.5)
    @variable(model, Ex, start = 0.5)
    @variable(model, wF, start = 1)
    @variable(model, x[1:total_ind] >= 0)
else
    d = load(fpath*fname)
    P_val = d["P_val"]
    @variable(model, P, start = P_val)
    Y_val = d["Y_val"]
    @variable(model, Y, start = Y_val)
    Px_val = d["Px_val"]
    @variable(model, Px, start = Px_val)
    Yx_val = d["Yx_val"]
    @variable(model, Yx, start = Yx_val)
    #@variable(model, E, start = 0.5)
    Ex_val = d["Ex_val"]
    @variable(model, Ex, start = Ex_val)
    wF_val = d["wF_val"]
    @variable(model, wF, start = wF_val)
    x_val = d["x_val"]
    @variables(model, begin
               x[i=1:total_ind] >= 0, (start = x_val[i])
           end)
end

# constraints and functions
# functions of Ps
function p_ciH_(i, x...)
    i = trunc(Int, i)
    m = ρ / (ρ - 1)
    return m * (zH[i] * x[6nc*ni+8ni+i]) ^ -1
end

function p_ciHx_(i, x...)
    i = trunc(Int, i)
    m = ρ / (ρ - 1)
    return m * (zH[i] * x[7nc*ni+8ni+i]) ^ -1
end

function p_iF_(i, wF, x...)
    i = trunc(Int, i)
    m = ρ / (ρ - 1)
    return m * wF * (zF[i]) ^ -1
end

function p_iFx_(i, wF, x...)
    i = trunc(Int, i)
    m = ρ / (ρ - 1)
    return m * wF * (zF[i]) ^ -1
end

function p_i_(i, x...)
    i = trunc(Int, i)
    wt = 1 - ρ
    Pi = 0
    PiH = 0
    for c in 1:nc
        j = nc * (i-1) + c
        PiH += (μ_ub[j] - μ_lb[j]) * (x[j] ^ wt)
    end
    Pi = (PiH + (τ*x[2nc*ni+i]) ^ wt) ^ (1/wt)
    return Pi
end

function p_ix_(i, x...)
    i = trunc(Int, i)
    wt = 1 - ρ
    Pi = 0
    PiH = 0
    for c in 1:nc
        j =  nc * (i-1) + c
        PiH += (μ_ub[j] - μ_lb[j]) * ((τ*x[nc*ni+j]) ^ wt)
    end
    Pi = (PiH  + x[2nc*ni+ni+i] ^ wt) ^ (1/wt)
    return Pi
end

function p_(x...)
    wt = 1 - σ
    p_agg = 0
    for i in 8nc*ni+8ni+1 : 8nc*ni+8ni+ni
        p_agg += x[i] ^ wt
    end
    p_agg = p_agg ^ (1/wt)
end

function px_(x...)
    wt = 1 - σ
    p_agg = 0
    for i in 8nc*ni+9ni+1 : 8nc*ni+9ni+ni
        p_agg += x[i] ^ wt
    end
    p_agg = p_agg ^ (1/wt)
end
########################################################

function y_ciH_(i, c, x...)
    i = trunc(Int, i)
    c = trunc(Int, c)
    j = nc * (i-1) + c
    return (x[j] ^ (-ρ)) * x[8nc*ni+12i+i] * (x[8nc*ni+8ni+i] ^ (ρ-1))
end

function y_ciHx_(i, c, x...)
    i = trunc(Int, i)
    c = trunc(Int, c)
    j = nc * (i-1) + c
    return ((τ*x[nc*ni + j]) ^ (-ρ)) * x[8nc*ni+13i+i] * (x[8nc*ni+9i+i] ^ (ρ-1))
end

function y_iH_(i, x...)
    i = trunc(Int, i)
    Hi = 0
    for c in 1:nc
        j = nc * (i-1) + c
        Hi += x[2nc*ni+2ni+j]
    end
    return Hi
end

function y_iHx_(i, x...)
    i = trunc(Int, i)
    Hi = 0
    for c in 1:nc
        j = nc * (i-1) + c
        Hi += x[3nc*ni+2ni+j]
    end
    return Hi
end

function y_iF_(i, x...)
    i = trunc(Int, i)
    j = 2nc*ni + i
    return ((τ*x[j]) ^ (-ρ)) * x[8nc*ni+12i+i] * (x[8nc*ni+8i+i] ^ (ρ-1))
end

function y_iFx_(i, x...)
    i = trunc(Int, i)
    j = 2nc*ni + ni + i
    return (x[j] ^ (-ρ)) * x[8nc*ni+13i+i] * (x[8nc*ni+9i+i] ^ (ρ-1))
end

function y_i_(i, P, E, x...)
    i = trunc(Int, i)
    return x[8nc*ni+8ni+i] ^ (-σ) * E * (P ^ (σ-1))
end

function y_ix_(i, Px, Ex, x...)
    i = trunc(Int, i)
    return x[8nc*ni+9ni+i] ^ (-σ) * Ex * (Px ^ (σ-1))
end

function y_(P,E)
    return E / P
end

function yx_(Px,Ex)
    return Ex / Px
end
########################################################

function l_ci_vH_(i, x...)
    i = trunc(Int, i)
    return x[2nc*ni+2ni+i] / zH[i] / x[6nc*ni+8ni+i]
end

function l_ci_vHx_(i, x...)
    i = trunc(Int, i)
    return x[3nc*ni+2ni+i] / zH[i] / x[7nc*ni+8ni+i]
end

function l_i_vF_(i, x...)
    i = trunc(Int, i)
    return x[4nc*ni+4ni+i] / zF[i]
end

function l_i_vFx_(i, x...)
    i = trunc(Int, i)
    return x[4nc*ni+5ni+i] / zF[i]
end

function l_sum_(x...)
    sum = 0
    for i in 1:nc*ni
        sum += (μ_ub[i] - μ_lb[i]) * x[4nc*ni+6ni+i]
    end
    for i in 1:nc*ni
        sum += (μ_ub[i] - μ_lb[i]) * x[5nc*ni+6ni+i]
    end
    return sum
end

function lx_sum_(x...)
    sum = 0
    for i in 1:ni
        sum += x[6nc*ni+6ni+i]
    end
    for i in 1:ni
        sum += x[6nc*ni+7ni+i]
    end
    return sum
end


########################################################

function s_ciH_(i, x...)
    i = trunc(Int, i)
    if x[4nc*ni+6ni+i] > 0
        return ((μ_ub[i] - μ_lb[i]) * (x[4nc*ni+6ni+i] + x[5nc*ni+6ni+i])) ^ η
    else
        return Float64(0)
    end
end

function s_ciHx_(i, x...)
    i = trunc(Int, i)
    if x[5nc*ni+6ni+i] > 0
        return ((μ_ub[i] - μ_lb[i]) * (x[4nc*ni+6ni+i] + x[5nc*ni+6ni+i])) ^ η
    else
        return Float64(0)
    end
end

#=function s_iF_(i, x...)
i = trunc(Int, i)
return ((μ_ub[i] - μ_lb[i]) * x[6nc*ni+8ni+i]) ^ η
end
=#

#=function s_iFx_(i, x...)
i = trunc(Int, i)
return ((μ_ub[i] - μ_lb[i]) * x[6nc*ni+9ni+i]) ^ η
end
=#

########################################################

function e_i_(i, x...)
    i = trunc(Int, i)
    return x[8nc*ni+8ni+i] * x[8nc*ni+10ni+i]
end

function e_ix_(i, x...)
    i = trunc(Int, i)
    return x[8nc*ni+9ni+i] * x[8nc*ni+11ni+i]
end

function wF_(Ex,Lx)
    return ((ρ-1)/ρ)*(Ex/Lx)
end

function TB_(x...)
    TB_agg = 0
    TB_Hx = 0
    for i in 1 : ni
        for c in 1:nc
            TB_Hx += x[ni*nc + nc*(i-1) + c] * x[3ni*nc + 2ni + nc*(i-1) + c]
        end
        TB_agg += TB_Hx - x[2ni*nc+i] * x[4ni*nc+4ni+i]
    end
    return TB_agg
end
# registration
register(model, :p_ciH_, 1 + total_ind, p_ciH_, autodiff = true)
register(model, :p_ciHx_, 1 + total_ind, p_ciHx_, autodiff = true)
register(model, :p_iF_, 2 + total_ind, p_iF_, autodiff = true)
register(model, :p_iFx_, 2 + total_ind, p_iFx_, autodiff = true)

register(model, :p_i_, 1 + total_ind, p_i_, autodiff = true)
register(model, :p_ix_, 1 + total_ind, p_ix_, autodiff = true)
register(model, :p_, total_ind, p_, autodiff = true)
register(model, :px_, total_ind, px_, autodiff = true)

register(model, :y_ciH_, 2 + total_ind, y_ciH_, autodiff = true)
register(model, :y_ciHx_, 2 + total_ind, y_ciHx_, autodiff = true)
register(model, :y_iH_, 1 + total_ind, y_iH_, autodiff = true)
register(model, :y_iHx_, 1 + total_ind, y_iHx_, autodiff = true)
register(model, :y_iF_, 1 + total_ind, y_iF_, autodiff = true)
register(model, :y_iFx_, 1 + total_ind, y_iFx_, autodiff = true)

register(model, :y_i_, 3 + total_ind, y_i_, autodiff = true)
register(model, :y_ix_, 3 + total_ind, y_ix_, autodiff = true)
register(model, :y_, 2, y_, autodiff = true)
register(model, :yx_, 2, yx_, autodiff = true)

register(model, :l_ci_vH_, 1 + total_ind, l_ci_vH_, autodiff = true)
register(model, :l_ci_vHx_, 1 + total_ind, l_ci_vHx_, autodiff = true)
#register(model, :l_i_vH_,  total_ind, l_i_vH_, autodiff = true)
#register(model, :l_i_vHx_, total_ind, l_i_vHx_, autodiff = true)
register(model, :l_i_vF_, 1 + total_ind, l_i_vF_, autodiff = true)
register(model, :l_i_vFx_, 1 + total_ind, l_i_vFx_, autodiff = true)
register(model, :l_sum_, total_ind, l_sum_, autodiff = true)
register(model, :lx_sum_, total_ind, lx_sum_, autodiff = true)

register(model, :s_ciH_, 1 + total_ind, s_ciH_, autodiff = true)
register(model, :s_ciHx_, 1 + total_ind, s_ciHx_, autodiff = true)


register(model, :e_i_, 1 + total_ind, e_i_, autodiff = true)
register(model, :e_ix_, 1 + total_ind, e_ix_, autodiff = true)
register(model, :wF_,  2, wF_, autodiff = true)
register(model, :TB_, total_ind, TB_, autodiff = true)
# constraints
@NLconstraint(model, consp1[i = 1:nc*ni], x[i] == p_ciH_(i, x...))
@NLconstraint(model, consp2[i = 1:nc*ni], x[nc*ni+i] == p_ciHx_(i, x...))
@NLconstraint(model, consp3[i = 1:ni], x[2nc*ni+i] == p_iF_(i, wF, x...))
@NLconstraint(model, consp4[i = 1:ni], x[2nc*ni+ni+i] == p_iFx_(i, wF, x...))
@NLconstraint(model, consp5[i = 1:ni], x[8nc*ni+8ni+i] == p_i_(i, x...))
@NLconstraint(model, consp6[i = 1:ni], x[8nc*ni+9ni+i] == p_ix_(i, x...))
@NLconstraint(model, consp7, P == p_(x...))
@NLconstraint(model, consp8, Px == px_(x...))

@NLconstraint(model, consy1[i = 1:ni, c = 1:nc], x[2nc*ni+2ni+nc*(i-1)+c] == y_ciH_(i, c, x...))
@NLconstraint(model, consy2[i = 1:ni, c = 1:nc], x[3nc*ni+2ni+nc*(i-1)+c] == y_ciHx_(i, c, x...))
@NLconstraint(model, consy3[i = 1:ni], x[4nc*ni+2ni+i] == y_iH_(i, x...))
@NLconstraint(model, consy4[i = 1:ni], x[4nc*ni+3ni+i] == y_iHx_(i, x...))
@NLconstraint(model, consy5[i = 1:ni], x[4nc*ni+4ni+i] == y_iF_(i, x...))
@NLconstraint(model, consy6[i = 1:ni], x[4nc*ni+5ni+i] == y_iFx_(i, x...))
@NLconstraint(model, consy7[i = 1:ni], x[8nc*ni+10ni+i] == y_i_(i, P, E, x...))
@NLconstraint(model, consy8[i = 1:ni], x[8nc*ni+11ni+i] == y_ix_(i, P, E, x...))
@NLconstraint(model, consy9, Y == y_(P, E))
@NLconstraint(model, consy10, Yx == yx_(Px, Ex))

@NLconstraint(model, consl1[i = 1:nc*ni], x[4nc*ni+6ni+i] == l_ci_vH_(i, x...))
@NLconstraint(model, consl2[i = 1:nc*ni], x[5nc*ni+6ni+i] == l_ci_vHx_(i, x...))
#@NLconstraint(model, consl3[i = 1:ni], x[6nc*ni+6ni+i] == l_i_vH_( x...))
#@NLconstraint(model, consl4[i = 1:ni], x[6nc*ni+7ni+i] == l_i_vHx_( x...))
@NLconstraint(model, consl5[i = 1:ni], x[6nc*ni+6ni+i] == l_i_vF_(i, x...))
@NLconstraint(model, consl6[i = 1:ni], x[6nc*ni+7ni+i] == l_i_vFx_(i, x...))

@NLconstraint(model, conss1[i = 1:nc*ni], x[6nc*ni+8ni+i] == s_ciH_(i, x...))
@NLconstraint(model, conss2[i = 1:nc*ni], x[7nc*ni+8ni+i] == s_ciHx_(i, x...))
#@NLconstraint(model, conss3[i = 1:ni], x[8nc*ni+10ni+i] == s_iF_(i, x...))
#@NLconstraint(model, conss4[i = 1:ni], x[8nc*ni+11ni+i] == s_iFx_(i, x...))
@NLconstraint(model, conse1[i = 1:ni], x[8nc*ni+12ni+i] == e_i_(i, x...))
@NLconstraint(model, conse2[i = 1:ni], x[8nc*ni+13ni+i] == e_ix_(i, x...))

#@NLconstraint(model, consel1, L == l_sum_(x...))
#@NLconstraint(model, consel2, Lx == lx_sum_(x...))
@NLconstraint(model, consel3, wF == wF_(Ex,Lx))
@NLconstraint(model, consetb, 0 == TB_( x...))

optimize!(model)


# declaration
p_ciH = Vector{Any}(undef, nc*ni)
p_ciHx = Vector{Any}(undef, nc*ni)
p_iF = Vector{Any}(undef, ni)
p_iFx = Vector{Any}(undef, ni)
y_ciH = Vector{Any}(undef, nc*ni)
y_ciHx = Vector{Any}(undef, nc*ni)
y_iH = Vector{Any}(undef, ni)
y_iHx = Vector{Any}(undef, ni)
y_iF = Vector{Any}(undef, ni)
y_iFx = Vector{Any}(undef, ni)

l_ci_vH = Vector{Any}(undef, nc*ni)
l_ci_vHx = Vector{Any}(undef, nc*ni)
#l_i_vH = Vector{Any}(undef, ni)
#l_i_vHx = Vector{Any}(undef, ni)
l_i_vF = Vector{Any}(undef, ni)
l_i_vFx = Vector{Any}(undef, ni)
s_ciH = Vector{Any}(undef, nc*ni)
s_ciHx = Vector{Any}(undef, nc*ni)
#s_iF = Vector{Any}(undef, ni)
#s_iFx = Vector{Any}(undef, ni)

Pi = Vector{Any}(undef, ni)
Pix = Vector{Any}(undef, ni)
Yi = Vector{Any}(undef, ni)
Yix = Vector{Any}(undef, ni)
Ei = Vector{Any}(undef, ni)
Eix = Vector{Any}(undef, ni)

for i in 1:nc*ni
    p_ciH[i] = value(x[i])
    p_ciHx[i] = value(x[nc*ni + i])
    y_ciH[i] = value(x[2nc*ni + 2ni + i])
    y_ciHx[i] = value(x[3nc*ni + 2ni + i])
    l_ci_vH[i] = value(x[4nc*ni + 6ni + i])
    l_ci_vHx[i] = value(x[5nc*ni + 6ni + i])
    s_ciH[i] = value(x[6nc*ni + 8ni + i])
    s_ciHx[i] = value(x[7nc*ni + 8ni + i])
end

for i in 1:ni
    p_iF[i] = value(x[2nc*ni + i])
    p_iFx[i] = value(x[2nc*ni + ni + i])
    y_iH[i] = value(x[4nc*ni + 2ni + i])
    y_iHx[i] = value(x[4nc*ni + 3ni + i])
    y_iF[i] = value(x[4nc*ni + 4ni + i])
    y_iFx[i] = value(x[4nc*ni + 5ni + i])
    #l_i_vH[i] = value(x[6nc*ni + 6ni + i])
    #l_i_vHx[i] = value(x[6nc*ni + 7ni + i])
    l_i_vF[i] = value(x[6nc*ni + 6ni + i])
    l_i_vFx[i] = value(x[6nc*ni + 7ni + i])

    Pi[i] = value(x[8nc*ni + 8ni + i])
    Pix[i] = value(x[8nc*ni + 9ni + i])
    Yi[i] = value(x[8nc*ni + 10ni + i])
    Yix[i] = value(x[8nc*ni + 11ni + i])
    Ei[i] = value(x[8nc*ni + 12ni + i])
    Eix[i] = value(x[8nc*ni + 13ni + i])
end

println()
println("level at optimum: ")
println("p_ciH = ", p_ciH)
println("p_ciHx = ", p_ciHx)
println("p_iF = ", p_iF)
println("p_iFx = ", p_iFx)
println("y_ciH = ", y_ciH)
println("y_ciHx = ", y_ciHx)
println("y_iH = ", y_iH)
println("y_iHx = ", y_iHx)
println("y_iF = ", y_iF)
println("y_iFx = ", y_iFx)

println("l_ci_vH = ", l_ci_vH)
println("l_ci_vHx = ", l_ci_vHx)
#println("l_i_vH = ", l_i_vH)
#println("l_i_vHx = ", l_i_vHx)
println("l_i_vF = ", l_i_vF)
println("l_i_vFx = ", l_i_vFx)
println("s_ciH = ", s_ciH)
println("s_ciHx = ", s_ciHx)

println("agg level: ")
println("P = ", value(P))
println("Px = ", value(Px))
println("Y = ", value(Y))
println("Yx = ", value(Yx))
println("E = ", value(E))
println("Ex = ", value(Ex))
println("wF = ", value(wF))

# Save Julia workspace:
save(fpath*fname,"P_val",value(P),"Y_val",value(Y),"Px_val",value(Px),"Yx_val",value(Yx),"Ex_val",value(Ex),"wF_val",value(wF),"x_val",value.(x))
# total value of trade over gdp
# import quantities
# check different values of productivities
# value of imports in industries
