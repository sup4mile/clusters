# #install libraries if necessary (i.e. uncomment and run this code)
# # import Pkg
# Pkg.add("JuMP")
# Pkg.add("Ipopt")
# # Pkg.add("XLSX")

# # Set working directory
# cd("C:\Users\ricks\Dropbox\PC (2)\Desktop\University of Wisconsin-Madison\Research\RA with Alder\clusters")

#We import our data for import shares
import XLSX
xf = XLSX.readxlsx("../data/processed/Import_to_GDP_2019.xlsx")
sh = xf["2019final"]
target_import_shares_H = sh["F2:F5"]
target_import_shares_F = 1;
;

# do importing work in this tab
using JuMP
using Ipopt

# debug = false

# set up global params
global nc = 5 # number of counties
global ni = 4 # number of industries
global η = 0 # the spill-over effect
global τ = 1 # trade frictions
global ρ = 2.5 # the elasiticity of substitution within industry
global σ = 1.7 # the elasiticity of substitution across industries
global L_H = 1 # total mass of labor at home country
global L_F = 1 # total mass of labor at foreign country
global w_H = 1
global Markup_H = 1/(ρ-1) # markup of firm
global E_H = (Markup_H + 1) * w_H # expenditure

company_sizes_H = [1/nc for i=1:ni, c=1:nc]
#takes on the role of μ_lb and μ_ub below
#represents the size of a company relative to the population in the county? range (0,1)
# The variables below have solid mathematical reason for being here, but don't seem practical
# to me from a programming perspective. It seems they merely define the relative size of a
# company; this can be represented with 1 number instead of 2.
# μ_lb = Matrix{Real}([0 0.5; 0 0.5])
# # the entries before the semi-colon is industry 1 for all counties
# μ_ub = Matrix{Real}([0.5 1; 0.5 1])
;

#MAKE JuMP MODEL

# debug = false #changes debug for this cell

#Make model and its vars
model = Model(Ipopt.Optimizer)
set_silent(model)
industries = 1:ni
counties = 1:nc

#labor for each industry-county (home production for home consumption), denoted lhh
@variable(model, lhh[industries, counties] >= 0)

#labor for each industry-county (home production for foreign consumption), denoted lhf
@variable(model, lhf[industries, counties] >= 0)

#labor for each industry (foreign production for home consumption), denoted lfh
@variable(model, lfh[industries] >= 0)

#labor for each industry (foreign production for foreign consumption), denoted lff
@variable(model, lff[industries] >= 0)

#productivity for each industry-county (home production for both markets), denoted z_H
@variable(model, z_H[industries, counties] >= 0)
for i in 1:nc
    fix(z_H[1, i], 1; force = true)
end



#productivity for each industry (foreign production for both markets), denoted z_F
#@variable(model, z_F[industries] >= 0)
@variable(model, z_F_v >=0) # a single variable representing foreign productivity
z_F = @NLexpression(model, [i=industries], z_F_v)
#TODO: why agriculture at home? If we're equalising producitivity for all industries abroad,
#why not make abroad 1? Do we care about how THEY compare to US?
#Also, if productivity is equalised, we do not need z_F as it is now. We can just use z_F_v

#wage at Home, normalised to 1
#@NLparameter(model, w_H == 1)
#wage at Foreign, some positive number relative to w_H
@variable(model, w_F >= 0)

#Here we make expressions that mirror functions from IC_NLsolve.jl

L_ic_H = @NLexpression(model, [i=industries, c=counties], company_sizes_H[i,c] * (lhh[i,c] + lhf[i,c]))

E_F = @NLexpression(model, E_H * w_F)

pv_ic_H = @NLexpression(model, [i=industries, c=counties], E_H * w_H  / (z_H[i,c] * L_ic_H[i,c] ^ η))
pv_ic_Hx = @NLexpression(model, [i=industries, c=counties], E_H * w_H / (z_H[i,c] * L_ic_H[i,c] ^ η))
pv_if_F = @NLexpression(model, [i=industries], E_F / z_F[i])
pv_if_Fx = @NLexpression(model, [i=industries], E_F / z_F[i])

H_sum = @NLexpression(model, [i=industries], sum((company_sizes_H[i,c] * pv_ic_H[i,c]^(1-ρ)) for c=counties))
F_sum = @NLexpression(model, [i=industries], τ * pv_if_F[i]^(1-ρ))
p_i_H = @NLexpression(model, [i=industries], (H_sum[i] + F_sum[i])^(1/(1-ρ)))

Hx_sum = @NLexpression(model, [i=industries], sum((company_sizes_H[i,c] * (τ * pv_ic_Hx[i,c])^(1-ρ)) for c=counties))
Fx_sum = @NLexpression(model, [i=industries], (pv_if_Fx[i])^(1-ρ))
p_i_F = @NLexpression(model, [i=industries], (Hx_sum[i] + Fx_sum[i])^(1/(1-ρ)))


p_H_sum = @NLexpression(model, sum((p_i_H[i])^(1-σ) for i=industries))
p_H = @NLexpression(model, p_H_sum^(1/(1-σ)))

p_F_sum = @NLexpression(model, sum((p_i_F[i])^(1-σ) for i=industries))
p_F = @NLexpression(model, p_F_sum^(1/(1-σ)))

yv_ic_H = @NLexpression(model, [i=industries, c=counties], pv_ic_H[i,c]^(-ρ) * p_i_H[i]^(ρ-σ) * (p_H^(σ-1)) * E_H)
yv_ic_Hx = @NLexpression(model, [i=industries, c=counties], (τ * pv_ic_Hx[i,c])^(-ρ) * p_i_F[i]^(ρ-σ) * (p_F^(σ-1)) * E_F)
yv_if_F = @NLexpression(model, [i=industries], (τ * pv_if_F[i])^(-ρ) * p_i_H[i]^(ρ-σ) * p_H^(σ-1) * E_H)
yv_if_Fx = @NLexpression(model, [i=industries], pv_if_Fx[i]^(-ρ) * p_i_F[i]^(ρ-σ) * p_F^(σ-1) * E_F)

exports = @NLexpression(model, sum((company_sizes_H[i,c]) * (pv_ic_Hx[i,c]) * (yv_ic_Hx[i,c]) for i=industries, c=counties))
imports = @NLexpression(model, sum((pv_if_F[i]) * (yv_if_F[i]) for i=industries))

pred_import_share_H = @NLexpression(model, [i=industries], (yv_if_F[i] * pv_if_F[i]) / sum((company_sizes_H[i,c]) * (yv_ic_H[i,c] * pv_ic_H[i,c] + yv_ic_Hx[i,c] * pv_ic_Hx[i,c]) for c=counties))

#These last lines mirror our original model_difference() function
pred_lhh_ic = @NLexpression(model, [i=industries, c=counties], yv_ic_H[i,c] / (z_H[i,c] * L_ic_H[i,c] ^ η))
pred_lhf_ic = @NLexpression(model, [i=industries, c=counties], yv_ic_Hx[i,c] / (z_H[i,c] * L_ic_H[i,c] ^ η))
pred_lfh_i = @NLexpression(model, [i=industries], yv_if_F[i] / z_F[i])
pred_lff_i = @NLexpression(model, [i=industries], yv_if_Fx[i] / z_F[i])

#The following code is to be used for testing a new "constraint" solving method
constraint_method = true

if constraint_method #We use the constraint method proposed during meeting
    @NLconstraint(model, [i=industries, c=counties], lhh[i,c] == pred_lhh_ic[i,c])
    @NLconstraint(model, [i=industries, c=counties], lhf[i,c] == pred_lhf_ic[i,c])
    @NLconstraint(model, [i=industries], lfh[i] == pred_lfh_i[i])
    @NLconstraint(model, [i=industries], lff[i] == pred_lff_i[i])

    model_difference = @NLexpression(model, 1)

else #We use the squared-difference minimisation method (initial Martin implementation)
    diff_lhh_ic = @NLexpression(model, [i=industries, c=counties], pred_lhh_ic[i,c] - lhh[i,c])
    diff_lhf_ic = @NLexpression(model, [i=industries, c=counties], pred_lhf_ic[i,c] - lhf[i,c])
    diff_lfh_i = @NLexpression(model, [i=industries], pred_lfh_i[i] - lfh[i])
    diff_lff_i = @NLexpression(model, [i=industries], pred_lff_i[i] - lff[i])

    diff_lhh = @NLexpression(model, sum(diff_lhh_ic[i,c]^2 for i=industries, c=counties))
    diff_lhf = @NLexpression(model, sum(diff_lhf_ic[i,c]^2 for i=industries, c=counties))
    diff_lfh = @NLexpression(model, sum(diff_lfh_i[i]^2 for i=industries))
    diff_lff = @NLexpression(model, sum(diff_lff_i[i]^2 for i=industries))

    model_difference = @NLexpression(model, diff_lhh + diff_lhf + diff_lfh + diff_lff)
end
;

#Set constraints for our model

#Constraint: labor must never be negative. This is achieved in the variable declarations.

#Constraint: labors in a country must add to the country's initial allotment of labor
@constraint(model, sum(lhh)+sum(lhf) == (ni*L_H))
#TODO is there an initial allotment of people per county? This may need to be added to
#also, why ni and not nc? ALSO, why multiply by a number at all?

@constraint(model, sum(lfh)+sum(lff) == L_F)

#Constraint: imports must equal predicted exports (or the other way around, it doesn't matter)
@NLconstraint(model, imports == exports)

#Constraint: import ratio for industry i at Home == target import ratio for i at H (from data)
# the predicted ratio is import_ratio(i,l):
@NLconstraint(model, [i=industries], pred_import_share_H[i] == target_import_shares_H[i])

#Lastly, we pass our root expression to our model as a non-linear objective.
#Our objective needs to be non-linear to allow for our operations.
#Objective function: minimize(| x - predicted(x) |) <-- i.e. we attempt to reach a fixed-point solution
@NLobjective(model, Min, model_difference) #<-- this is the non-test objective to use
#@NLobjective(model, Min, model_difference)
#@objective(model, Min, model_difference(lhh, lhf, lfh, lff))

# Run the model
optimize!(model)
@show solution_summary(model)
print("<< lhh >>\n")
@show value.(lhh)
print("\n")
print("<< lhf >>\n")
@show value.(lhf)
print("\n")
print("<< lfh >>\n")
@show value.(lfh)
print("\n")
print("<< lff >>\n")
@show value.(lff)
print("\n")
print("<< z_H >>\n")
@show value.(z_H)
print("\n")
print("<< z_F >>\n")
@show value.(z_F)
print("\n")
print("<< w_F >>\n")
@show value.(w_F)
print("\n")

; #eliminate unnecessary output
