using NLopt

include("agg_price_index.jl")

# Set path to working directory:
cd("/Users/simeonalder/Dropbox/Work/Research/GitHub/clusters/julia")
n_c = 3 # counties in rows
n_i = 3 # industries in columns
A = Array{Float64}(undef,2)
L = 1
ρ = 3
σ = 2
η = 0
μ_lb = Array{Float64}(undef,2)
μ_ub = Array{Float64}(undef,2)
# Populate the following arrays: 'A', 'μ_lb', 'μ_ub':
A = ones(n_c,n_i)
println("ρ=",σ)
for i in 1:10
    println("iteration ",i," of 10")
end
P_i = [.5 1 1.5]
P = Array{Float64}(undef,(3,3))
P[2,3] = agg_price_index(σ,P_i)
