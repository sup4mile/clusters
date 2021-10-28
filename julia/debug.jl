Juno.@enter split("Hello, world", isspace)

Juno.@run split("Hello there, world", isspace)

# tests
using NLsolve

function aux(i,j,x)
        return x[i,j]^2
end

# aux(1,1,1,initial_x)


function f!(F,x)
    for i in 1:2
        for j in 1:2
            F[i,j] = aux(i,j,x)+ 1/x[i,j] + 1 - x[i,j]
        end
    end
end

initial_x = Array([-1.0 for i = 1:2, j = 1:2])

Juno.@enter nlsolve(f!, initial_x; method =:anderson, autodiff =:forward, store_trace = true, show_trace = true)
result

converged(result)


#
# l_initial = [ [0.125 for i=1:ni, j = 1:2nc] [0.5 for i = 1:ni, j = (2nc+1):(2nc+2)] [0.5 for i = 1:ni]]
#
#
# x = allowmissing([12; missing])
# y = Matrix{Any}(undef, 2,1)
#
# function f(i)
#     return (x[i])^2
# end
#
# for i in 1:2
#     y[i] = (f(i))
# end
#
# typeof(y)
# print(y)
# skipmissing(f(1))
