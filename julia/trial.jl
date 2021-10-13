# tests
using NLsolve


function aux(i,j,x)
    return x[i,j]^2

end

function f!(F,x)
    for i in 1:2
        for j in 1:2
        F[i,j] =aux2(i,j,x)+ 1/x[i,j] + 1
        end
    end
end

initial_x = [-1.0 -1.0; -1.0 -1.0]
res = nlsolve(f3!, initial_x, autodiff =:forward)
