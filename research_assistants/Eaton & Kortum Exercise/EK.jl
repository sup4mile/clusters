using Random, Distributions, Optim # JuMP, Ipopt

N = 3 # Number of countries
J = 250000 # Number of goods (needs to be big number and an integer type)
theta = 4 # Frechet shape parameter (governs comparative advantage)
T = ones(N, 1) * 1.5 # Frechet scale parameter (governs absolute advantage)
sigma = 2 # Substitution elasticity between goods
tau = ones(N, N) # Iceberg trade costs
L = ones(N, 1) # Size of labor force in each country

# Random.seed!(1) # Seed for the random number generator (to guarantee reproducibility; this is standard in research these days)

# Draw the J x N uniform r.v.:
u = rand(J, N)
# Define inverse Fréchet CDF:
function inv_Frechet(u, T, theta)
    return quantile.(Frechet(theta, T[1]), u)
end
# Initiate array of productivities:
z = Array{Float64}(undef, J, N)
# Evaluate the inv_Frechet function country-by-country:
for n in 1:N
    z[:, n] = inv_Frechet(u[:, n], T[n], theta)
end
# Initialize the 1 x (N-1) vector of wages:
wage = Array{Float64}(undef, 1, N-1)
#  The wage in country 1 is given by 'w1' and we normalize it to unity:
w1 = 1

# In this economy, goods indexed by the same j in [1,J] in all countries are perfect substitutes for one another. Countries select the lowest cost provider for each one of these J different goods.

# Initialize the arrays for the returns:
P = Array{Float64}(undef, N, 1)
pi = Array{Float64}(undef, N, N)

# Define a function to identify lowest-cost producer in each country for all J products across all other N countries (including the domestically produced good:
function lcp(tau,w1,w,z,T,theta,sigma,N)
    for n in 1:N
        w_tmp = [w1 w[:]']
        # In country 'n', find lowest cost producer for each j in {1,...,J}:
        p_all = tau[n, :]' .* w_tmp ./ z
        i = argmin(p_all, dims=2)
        # Compute local prices in country 'n':
        p_n = vec(p_all[i])
        # Compute the price index in country 'n':
        P[n] = only((ones(1, J) * (p_n .^ (1 - sigma))./J) .^ (1 / (1 - sigma))) # 'only' selects a single element from a collection; in this case, it converts the type from a 1 x 1 vector to a Float64 scalar 
        # Compute the expenditure shares:
        Phi_n = only(ones(1, N) * (T .* (w_tmp' .* tau[n, :]) .^ (-theta)))
        for m in 1:N
            pi[n, m] = (T[m] .* (w_tmp[m] .* tau[n, m])^(-theta)) ./ Phi_n
        end
    end
    return P, pi
end

function trade_balance(tau,w1,w,z,T,theta,sigma,N,L)
    # Compute the price indices and trade shares using the 'lcp' function defined above:
    P,pi = lcp(tau,w1,w,z,T,theta,sigma,N)
    # Compute total income for each country:
    inc = [w1 w[:]'] .* L
    tb = Array{Float64}(undef,1,N)
    for n in 1:N
        tb[1,n] = 0
        for i in 1:N
            tb[1,n] = tb[1,n] + pi[n,i] .* inc[i] - pi[i,n] .* inc[n]
        end
    end
    return tb[2:N]
end

function report_results(w1, sol, L, tau, z, T, theta, sigma, N)
    income =  [w1 sol[:]'].* L
    tb = trade_balance(tau, w1, sol[:]', z, T, theta, sigma, N, L)
    P, pi = lcp(tau, w1, sol, z, T, theta, sigma, N)
    welfare = [w1 sol[:]'] ./ P[:]'
    # Print results to screen:
    println("Equilibrium wages:\n", round.(sol[:]',digits=3))
    println("Trade shares:\n", round.(pi,digits=3))
    println("Trade balances in countries 2 and 3:\n", round.(tb,digits=3))
    println("Welfare (w/P):\n", round.(welfare, digits=3))
end

### a. ###

# Since we are minimizing the squared trade balances, we need an auxiliary function that sums the squares of the N-1 trade balances for countries 2,...,N.
function trade_balance_sq(tau,w1,w,z,T,theta,sigma,N,L)
    tbsq = sum(trade_balance(tau,w1,w,z,T,theta,sigma,N,L).^2)
    return tbsq
end

# Recall that we are solving for the wages in countries 2,...,N such that trade is balanced in these N-1 countries. When trade is indeed balance, then Walras Law immediately implies that the trade is balanced in country 1. This guarantees that the number of unknowns equals the number of equations in the system that we are solving.

# Our objective function 'trade_balance_sq' accepts several input arguments, only one of which is 'w'. To "feed" the objective function to the optimizer, we need to create an anonymous function that redefines 'trade_balance_sq' as a function of a single argument 'w'.
sol_a = optimize(w -> trade_balance_sq(tau,w1,w,z,T,theta,sigma,N,L), [1.1 1.1])
# Now we use the minimizer from the optimization step and "feed" it to the 'report_results' function as an input argument:
results_a = report_results(w1, Optim.minimizer(sol_a), L, tau, z, T, theta, sigma, N)

# Next, let's find the solution by way of a root-finding algorithm instead, which is available in the 'NLsolve' package.
root_a = nlsolve(w -> trade_balance(tau,w1,w,z,T,theta,sigma,N,L), [1.1 1.1])
# Results based on root-finding algorithm:
report_results(w1, root_a.zero, L, tau, z, T, theta, sigma, N)

### b. ###

# Update the matrix of iceberg costs:
tau = tau .* 1.1
# Make an adjustment for the fact that domestic trade is costless:
for n in 1:N
    tau[n,n]=1
end
# Use the result from question a. as the initial guess for the optimization in question b.:
sol_b = optimize(w -> trade_balance_sq(tau,w1,w,z,T,theta,sigma,N,L), Optim.minimizer(sol_a))
# Now we use the minimizer from the optimization step and "feed" it to the 'report_results' function as an input argument:
report_results(w1, Optim.minimizer(sol_b), L, tau, z, T, theta, sigma, N)
# Find the solution by way of a root-finding algorithm instead, which is available in the 'NLsolve' package.
root_b = nlsolve(w -> trade_balance(tau,w1,w,z,T,theta,sigma,N,L), root_a.zero)
# Results based on root-finding algorithm:
report_results(w1, root_b.zero, L, tau, z, T, theta, sigma, N)

### c. ###

tau = ones(N, N)
tau[1,3] = 1.3
tau[3,1] = tau[1,3]
tau[1,2] = 1.3
tau[2,1] = tau[1,2]

# Use the result from question a. as the initial guess for the optimization in question c.:
sol_c = optimize(w -> trade_balance_sq(tau,w1,w,z,T,theta,sigma,N,L), Optim.minimizer(sol_a))
# Now we use the minimizer from the optimization step and "feed" it to the 'report_results' function as an input argument:
report_results(w1, Optim.minimizer(sol_c), L, tau, z, T, theta, sigma, N)
# Find the solution by way of a root-finding algorithm instead, which is available in the 'NLsolve' package.
root_c = nlsolve(w -> trade_balance(tau,w1,w,z,T,theta,sigma,N,L), root_a.zero)
# Results based on root-finding algorithm:
report_results(w1, root_c.zero, L, tau, z, T, theta, sigma, N)

### d. ###

# Increase T in country 2 from its original value to 2:
T[2] = 2
# Update the productivities in country 2 accordingly:
z[:, 2] = inv_Frechet(u[:, 2], T[2], theta)

# Use the result from question c. as the initial guess for the optimization in question d.:
sol_d = optimize(w -> trade_balance_sq(tau,w1,w,z,T,theta,sigma,N,L), Optim.minimizer(sol_c))
# Now we use the minimizer from the optimization step and "feed" it to the 'report_results' function as an input argument:
report_results(w1, Optim.minimizer(sol_d), L, tau, z, T, theta, sigma, N)
# Find the solution by way of a root-finding algorithm instead, which is available in the 'NLsolve' package.
root_d = nlsolve(w -> trade_balance(tau,w1,w,z,T,theta,sigma,N,L), root_c.zero)
# Results based on root-finding algorithm:
report_results(w1, root_d.zero, L, tau, z, T, theta, sigma, N)

### e. ###

theta = 8
T[2] = T[1]
# Update the productivities in all N countries:
for n in 1:N
    z[:, n] = inv_Frechet(u[:, n], T[n], theta)
end

# Use the result from question c. as the initial guess for the optimization in question d.:
sol_e = optimize(w -> trade_balance_sq(tau,w1,w,z,T,theta,sigma,N,L), Optim.minimizer(sol_c))
# Now we use the minimizer from the optimization step and "feed" it to the 'report_results' function as an input argument:
report_results(w1, Optim.minimizer(sol_e), L, tau, z, T, theta, sigma, N)
# Find the solution by way of a root-finding algorithm instead, which is available in the 'NLsolve' package.
root_e = nlsolve(w -> trade_balance(tau,w1,w,z,T,theta,sigma,N,L), root_c.zero)
# Results based on root-finding algorithm:
report_results(w1, root_e.zero, L, tau, z, T, theta, sigma, N)