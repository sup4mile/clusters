using Random, Distributions, Optim, NLsolve, SpecialFunctions
N = 3 # Number of countries
J = 1 # Number of goods (needs to be big number and an integer type) 
θ = fill(4.0, J) # Frechet shape parameter (governs comparative advantage)
T = ones(N*J, 1) * 1.5 # Frechet scale parameter (governs absolute advantage)
σ = 2 # Substitution elasticity between goods
τ = ones(N*J, N) # Iceberg trade costs
L = ones(N*J, 1) # Size of labor force in each country
Ldot = ones(N*J) 

wt = ones(N*J)
Lt = ones(N*J)
wdot = ones(N*J)
tradesharest0 = ones(N*J, N) * (1 / N)
Adot = ones(N*J)
kdot = ones(N*J, N)
function θindex(j)
    div(j-1, N) + 1  # Find the correct index for θ
end
# Caliendo et al., eq. (12):
function pdot(n, tradesharest0, wdot, kdot, Adot)
    j = θindex(n)
    (sum(tradesharest0[n, i] * (wdot[(i-1) * J + j] * kdot[n, i])^-θ[j] * Adot[(i-1) * J + j]^θ[j] for i in 1:N))^(-1 / θ[j])
end
pdotArray = ones(N*J)

for n in 1:N
    pdotArray[n] = pdot(n, tradesharest0, wdot, kdot, Adot)
end
# Caliendo et al., eq. (13):
function tradeSharest1(n, i, wdot, tradesharest0, Ldot, Adot, kdot)
    j = θindex(n)
    tradesharest0[n, i] * ((wdot[(i-1) * J + j] * kdot[n, i]) / pdot(n, tradesharest0, wdot, kdot, Adot))^-θ[j] * Adot[(i-1) * J + j]^θ[j]
end
TSt1 = ones(N*J, N)
for n in 1:N*J
    for i in 1:N
        TSt1[n, i] = tradeSharest1(n, i, wdot, tradesharest0, Ldot, Adot, kdot)
    end
end
# Caliendo et al., LHS of eq. (15):
function incomet1(n, wdot)
    wt[n]*(wdot[n])*L[n]*(Ldot[n])
end
# Caliendo et al., RHS of eq. (15):
function Xt1(n, wdot, tradesharest0, Ldot, Adot, kdot)
    sum(incomet1(n, wdot) * tradeSharest1(n, i, wdot, tradesharest0, Ldot, Adot, kdot) for i in 1:N)
end
###
# WHAT IS THIS EXPRESSION SOLVING FOR?
###
function f!(F, wdot)
    for n in 1:N*J
        j = div(n-1, N) + 1  # Find the correct index for j
        country = n % N 
        if country == 0
            country = N
        end
        F[n] = (wdot[n] * Ldot[n] * wt[n] * Lt[n] - sum(tradeSharest1((i-1) * J + j, country, wdot, tradesharest0, Ldot, Adot, kdot)
             * Xt1((i-1) * J + j, wdot, tradesharest0, Ldot, Adot, kdot) for i in 1:N))
    end
end
results = nlsolve(f!, [1.0; 1.1; 1.2; 1.15; 1.22; 1.21]) #solving for wages with country 1 set at 1.0
sol = ones(N*J)
for i = 1:N*J
    sol[i] = results.zero[i] #saving results in sol[i]
    wdot[i] = sol[i]
    println(sol[i])
end

for n in 1:N
    pdotArray[n] = pdot(n, tradesharest0, wdot, kdot, Adot)
end
println("real:")
for n in 1:N*J
    count = n % N 
    if count == 0
        count = N
    end
    re = wdot[n] / pdotArray[count]
    println(re)
end
println("pdots:")
for i = 1:N*J
    println(pdot(i, tradesharest0, wdot, kdot, Adot))
end
TSt1 = ones(N*J, N)
for n in 1:N*J
    for i in 1:N
        TSt1[n, i] = tradeSharest1(n, i, wdot, tradesharest0, Ldot, Adot, kdot)
    end
end
