using Test
using NLsolvemodel

function square(x)
    return x*x
end

@test square(2) == 4
