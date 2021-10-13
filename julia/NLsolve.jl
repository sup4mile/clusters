using NLsolve

# notes on nlsolve
# a function name ending with a ! indicates that it will mutate or destroy the value of one or more of its arguments

# https://docs.julialang.org/en/v1/manual/arrays/
# concatenation
    # [A; B; C; ...]	vcat	shorthand for `cat(A...; dims=1)
    # [A B C ...]	hcat	shorthand for `cat(A...; dims=2)
    # [A B; C D; ...]	hvcat	simultaneous vertical and horizontal concatenation
# comprehension
# A = [ F(x,y,...) for x=rx, y=ry, ... ]

# trial 1
# simple nonlinear system of equationswith roots (0,1) and (1,2)
# run successfully, initial guesses need to be in float, not integer

function f!(F,x)
    F[1] = x[1]-x[2]+1
    F[2] = x[1]^2 -x[2] +1
end

initial_x = [-1.0, 1.0]

nlsolve(f!, initial_x, autodiff =:forward)

# trial 2
# add a parameter
# result: if parameter with fixed values, define it outside of f!(), and call inside the f!()

α = 2
function f_2!(F,x)
    F[1] = x[1]-x[2]+α
    F[2] = x[1]^2 -x[2] +α
end


initial_x = [-1.0, 1.0]

nlsolve(f_2!, initial_x, autodiff =:forward)


# trial 3
# add another axuliary function and variable into the model
# result: worked

α = 2
function f_3!(F,x)
    z = x[1]-x[2]
    F[1] = z + α
    F[2] = x[1]^2 -x[2] +α
end

initial_x = [-1.0, 1.0]

nlsolve(f_3!, initial_x, autodiff =:forward)

# trial 4
# write z as a funtion
# result: write aux function outside, after optimization, call z with the zeros to get the value of the z() function
α = 2
function z(x)
    return z = x[1] - x[2]
end

function f_4!(F,x)
    F[1] = z(x) + α
    F[2] = x[1]^2 -x[2] +α
end
initial_x = [-1.0, 1.0]
res = nlsolve(f_4!, initial_x, autodiff =:forward)

res.zero
z(res.zero)

# Trial 5
# take matrix as an input
# one way: define the function corresponding to each matrix input outside the objective function
    # call the defined function fn() inside the objective function in the form F[1] = func()
α = 2
# aux function
function z(x,i)
    return z = x[1,i] - x[1,i]
end

# objective function
function f(x,i)
    if i == 1
        return z(x,i)+α
    end
    if i == 2
        return x[1,i]^2-x[1,i] +α
    end
end

function f_5!(F,x)
    #labor equation ni*nc F[1:ni*nc] = f(i=ni*nc, x(i))
    for i in 1:2
        F[i] = f(x,i)
    end

end
initial_x = [-1.0 1.0]
res = nlsolve(f_5!, initial_x, autodiff =:forward)

res.zero
z(res.zero)



function reshp(matrix)
