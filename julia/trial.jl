# tests
using NLsolve,

using Pkg
Pkg.add("Missings")
using Missings


function aux(k,i,j,x)
    if k == 1
        return x[k][i,j]^2
    else
        return x[k]^2
    end
end

# aux(1,1,1,initial_x)

function f2!(F,x)
    for i in 1:2
        for j in 1:2
                F[1][i,j] = aux(k,i,j,x)+ 1/x[1][i,j] + 1 - x[1][i,j]
                F[2] = aux(k,i,j,x)+ 1/x[2]+ 1 - x[2]
            end
        end
    end
end

initial_x = Array([[-1.0 for i = 1:2, j = 1:2],1.0])
initial_x[2]

nlsolve(f2!, initial_x; autodiff =:forward)



l_initial = [ [0.125 for i=1:ni, j = 1:2nc] [0.5 for i = 1:ni, j = (2nc+1):(2nc+2)] [0.5 for i = 1:ni]]


x = allowmissing([12; missing])
y = Matrix{Any}(undef, 2,1)

function f(i)
    return (x[i])^2
end

for i in 1:2
    y[i] = (f(i))
end

typeof(y)
print(y)
skipmissing(f(1))

2*x
