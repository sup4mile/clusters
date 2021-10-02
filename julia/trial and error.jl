# tests
using JuMP, Ipopt
m = Model(optimizer_with_attributes(Ipopt.Optimizer, "max_iter" =>1000))

ni = 2

"""
Test
    Calling a JuMP variable in an user-defined function;
    NLexpression[i] = function output for each entry
Result: Fails
Error: /(::Int64,::VariableRef) is not defined.
Reflection
    the numerical value of JuMP variable/expression is not evaluated in a function
"""

@variable(m, x[i = 1:ni], start = 0)
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
