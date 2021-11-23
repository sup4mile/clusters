# import scipy
# import scipy.optimize
# import numpy
# from numpy import zeros


# # x = [0, 0]
# # x[0]**2 + x[1]**2 - 4
# # print(x.shape)


# def F(x):
#     x[0][0] = 1
#     x[0][1] = 1
#     x[1][0] = 1
#     x[1][1] =
#     # for r in range(len(x)):
#     #     x[r] = 2
#     #     #x[r][0]**2 + x[r][1]**2 - 4
#     # # return x[0]**2 + x[1]**2 - 4
#     # # return zeros((2, 2), float)


# guess = zeros((2, 2), float)

# print(guess.shape)

# x = scipy.optimize.newton_krylov(F, guess)

# # x
# import pyomo.environ as aml

# m = aml.ConcreteModel()
# m.x = aml.Var([0, 1])

# m.obj = aml.Objective(expr=m.x[0]**2 + m.x[1]**2 - 4)

# solver = aml.SolverFactory('ipopt')
# solver.solve(m)

# #!/usr/bin/env python
# # <examples/doc_model1.py>
# from numpy import sqrt, pi, exp, linspace, loadtxt
# from lmfit import Model

# import matplotlib.pyplot as plt

# data = loadtxt('model1d_gauss.dat')
# x = data[:, 0]
# y = data[:, 1]


# def gaussian(x, amp, cen, wid):
#     "1-d gaussian: gaussian(x, amp, cen, wid)"
#     return (amp/(sqrt(2*pi)*wid)) * exp(-(x-cen)**2 / (2*wid**2))


# gmod = Model(gaussian)
# result = gmod.fit(y, x=x, amp=5, cen=5, wid=1)

# print(result.fit_report())

# plt.plot(x, y,         'bo')
# plt.plot(x, result.init_fit, 'k--')
# plt.plot(x, result.best_fit, 'r-')
# plt.show()
# # <end examples/doc_model1.py>
import scipy.optimize
import numpy as np
from time import time


def F(x):
    return np.cos(x) + x[::-1] - [1, 2, 3, 4]


x = scipy.optimize.broyden1(F, [1, 1, 1, 1], f_tol=1e-14)
# print(x)


def G(x):
    return [x[0]**2 + x[1]**2 - 4, x[0]**2 + x[1]**2 - 4]


t1 = time()
x = scipy.optimize.anderson(G, [2, -1])
tf = time() - t1
print(x, tf)
