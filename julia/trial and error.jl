# tests
using JuMP, Ipopt, NLsolve
# m = Model(optimizer_with_attributes(Ipopt.Optimizer, "max_iter" =>1000))

ni = 2
nc = 2

"""
Tests for NLsolve 1-d
"""
function f!(F, x)
    for i in 1:ni
        F[i] = x[i]^2 + 1/x[i] + 1
    end
end

results = nlsolve(f!, [-0.1; -0.1], autodiff = :forward)
println("converged=$(NLsolve.converged(results)) at root=$(results.zero)
in $(results.iterations) iterations and $(results.f_calls) function calls")
results

"""
Tests for NLsolve 2-d with reshape
"""
test = [1 2; 3 4]
test_v = reshape(test, 4, 1)
test_m = reshape(test_v, 2, 2)

initial_guess = [-0.1 -0.1; -0.1 -0.1]

function f!(F, initial_guess)
    x = reshape(initial_guess, ni, nc)
    for i in 1:ni
        for j in 1:nc
            F[i, j] = x[i, j]^2 + 1/x[i, j] + 1
        end
    end
    initial_guess = reshape(x, ni*nc, 1)
end
nlsolve(f!, initial_guess, autodiff = :forward)

"""
Tests for NLsolve 2-d without reshape
"""

initial_guess = [-0.1 -0.1; -0.1 -0.1]

function g!(F, initial_guess)
#    x = reshape(initial_guess, ni, nc)
    for i in 1:ni
        for j in 1:nc
            F[i, j] = initial_guess[i, j]^2 + 1/initial_guess[i, j] + 1
        end
    end
#    initial_guess = reshape(x, ni*nc, 1)
end
nlsolve(g!, initial_guess, autodiff = :forward)

"""
Test for NLsolve with an array of different object as input
Results: Fails
Error: MethodError: no constructors have been defined for Any
Reflection: different types of objects in initial guess lead to nondifferentiable function
    have to use 3-d array, but just use part of the array.
"""
x1 = Matrix{Float64}(undef, ni, nc)
x2 = Matrix{Float64}(undef, ni, 1)
x3 = 0.0

initial_guess = [[-0.1 -0.1; -0.1 -0.1], [-0.1; -0.1], -0.1]

function f!(F, initial_guess)
#    x = reshape(initial_guess, ni, nc)
    x1 = initial_guess[1]
    x2 = initial_guess[2]
    x3 = initial_guess[3]

# the first nc*ni constraints are for x1
    for i in 1:ni
        for j in 1:nc
            F[i+j] = x1[i, j]^2 + 1/x1[i, j] + 1
        end
    end

# the constraints [ni*nc+1, ni*nc+ni] are for x2
    for i in 1:initial_guess
        F[ni*nc + i] = x2[i]^2 + 1/x2[i] + 1
    end

# the last constraint is for x3
    F[ni*nc + ni + 1] = x2[i]^2 + 1/x2[i] + 1

    initial_guess = [x1, x2, x3]
end
nlsolve(f!, initial_guess, autodiff = :forward)



# Tests for JuMP

"""
Test
    Calling a JuMP variable in an user-defined function;
    NLexpression[i] = function output for each entry
Result: Fails
Error: /(::Int64,::VariableRef) is not defined.
Reflection
    the numerical value of JuMP variable/expression is not evaluated in a function
"""

@variable(m, x[i = 1:ni], start = 0
function calc_(i)
    i = trunc(Int64, i)
    return x[i]^2 + 1/x[i] + 1
end
register(m, :calc_, 1, calc_, autodiff = true)
@NLexpression(m, x_calc[i = 1:2], calc_(i))
@NLconstraint(m, [i = 1:ni], x[i] == x_calc[i])
optimize!(m)


"""
Test
    use NLexpression to define NLexpression
Result:
    Successfully starts Ipopt.
    Invalid number in NLP function or derivative detected.
Error: N/A
Reflection: ?

"""
@variable(m, x[i = 1:ni], start = 0)
@NLexpression(m, x_calc[i = 1:ni], x[i]^2 + 1/x[i] + 1)
@NLconstraint(m, [i = 1:ni], x[i] == x_calc[i])
optimize!(m)
# print(solution_summary(m))
# value()
termination_status(m)

"""
Test
    Try @expression
Result: Fails
Error: /(::Int64,::VariableRef) is not defined.
Reflection: @expression can't evaluate vector reference, neither
"""
@variable(m, x[i = 1:ni], start = 0)
function calc_(i)
    i = trunc(Int64, i)
    return x[i]^2 + 1/x[i] + 1
end
register(m, :calc_, 1, calc_, autodiff = true)
@expression(m, x_calc[i = 1:2], calc_(i))
@NLconstraint(m, [i = 1:ni], x[i] == x_calc[i])
optimize!(m)

"""
Test
    define scalar-output function for each dimension of x[]
Result: Fails
Error: /(::Int64,::VariableRef) is not defined.
Reflection: function doesn't recognize the value of JuMP variable
"""
@variable(m, x[i = 1:ni], start = 0)
x_calc = Array{Any}(undef, ni)

function x1_calc_()
    return x[1]^2 + 1/x[1] + 1
end
register(m, :x1_calc_, 0, x1_calc_, autodiff = true)
x_calc[1] = @NLexpression(m, x1_calc_())

function x2_calc_()
    return x[2]^2 + 1/x[2] + 1
end
register(m, :x2_calc_, 0, x2_calc_, autodiff = true)
x_calc[2] = @NLexpression(m, x2_calc_())

@NLconstraint(m, x[1] == x_calc[1])
@NLconstraint(m, x[2] == x_calc[2])
optimize!(m)

"""
Test
    Initiate variables & expressions outside of JuMP
Result:
    Successfully starts Ipopt
Error: /(::Int64,::VariableRef) is not defined.
Reflection: function doesn't recognize the value of JuMP variable
"""
x = Array{Any}(undef, ni)
x_calc = Array{Any}(undef, ni)

@variable(m, x[i = 1:ni], start = 0)

function x1_calc_()
    return x[1]^2 + 1/x[1] + 1
end
register(m, :x1_calc_, 0, x1_calc_, autodiff = true)
x_calc[1] = @NLexpression(m, x1_calc_())

function x2_calc_()
    return x[2]^2 + 1/x[2] + 1
end
register(m, :x2_calc_, 0, x2_calc_, autodiff = true)
x_calc[2] = @NLexpression(m, x2_calc_())

@NLconstraint(m, x[1] == x_calc[1])
@NLconstraint(m, x[2] == x_calc[2])
optimize!(m)

# function f_x1(x)
#     return x[1]
# end
# function f_x2(x)
#     return x[2]
# end
#
# register(m, :f_x1, 1, f_x1, autodiff = true)
# register(m, :f_x2, 1, f_x2, autodiff = true)
# @NLexpression(m, expr[i = 1:2], y[i] * f_x1(x))
# @NLexpression(m, expr[i = 1:2], y[i] * f_x2(x))
