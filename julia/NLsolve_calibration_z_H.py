import scipy.optimize
import numpy as np
from time import time

# This is meant to be a python version of our Julia code
# Its aim is to evaluate the potential differences
# between a Python solver and Julia solver, particularly
# with respect to time and to maintainability

# model parameters
nc = 2  # number of counties
ni = 4  # number of industries
spillover = 0  # spillover effect
friction = 1  # trade frictions
elastic_w = 2  # elasticity of susbtitution within industry
elastic_a = 1.7  # elasticity of susbtitution across industries
L_H = 1  # total labor at home country
L_F = 1  # total labor at foreign country
wage_H = 1  # wage at home normalized to 1
Markup_H = 1/(elastic_w-1)  # markup of firms in monopol. comp.
Expend_H = (Markup_H + 1) * wage_H  # expenditures at home


def set_default_params():
    # sets parameter values to default values
    # allows one to "revert" to defaults easily when desired
    # can be useful for testing
    nc = 2
    ni = 4
    spillover = 0
    friction = 1
    elastic_w = 2
    elastic_a = 1.7
    L_H = 1
    L_F = 1
    wage_H = 1
    Markup_H = 1/(elastic_w-1)
    Expend_H = (Markup_H + 1) * wage_H

# Helper functions go here

# Error functions go here
# In error functions, try splitting x into separate arrays
# That way, we don't need the really ugly indexing used in
# the Julia version


def initial_guess():
    # initial guess should have shape:
    #   num rows = num industries
    #   num cols =
    #               num Home counties producing for Home
    #               num Home counties producing for foreign
    #               1 Foreign producing for Home
    #               1 Foreign producing for Foreign
    #               1 Foreign wage
    guess_arrays = []

    labor_H_for_H = np.ndarray((ni, nc))
    labor_H_for_H.fill(L_H/(2*ni*nc))
    guess_arrays.append(labor_H_for_H)

    labor_H_for_F = np.ndarray((ni, nc))
    labor_H_for_F.fill(L_H/(2*ni*nc))
    guess_arrays.append(labor_H_for_F)

    labor_F_for_H = np.ndarray((ni, 1))
    labor_F_for_H.fill(L_F/(2*ni))
    guess_arrays.append(labor_F_for_H)

    labor_F_for_F = np.ndarray((ni, 1))
    labor_F_for_F.fill(L_F/(2*ni))
    guess_arrays.append(labor_F_for_F)

    wage_F = np.ndarray((ni, 1))
    wage_F.fill(1)
    guess_arrays.append(wage_F)

    return np.concatenate(guess_arrays, axis=1)


def time_initial_guess():
    print("Running an individual labor optimization:")
    print("Obtaining an initial guess for labor:")
    t1 = time()
    guess = initial_guess()
    t2 = time()
    print(initial_guess())
    print(f'Obtaining guess took {t2-t1} seconds')


if __name__ == "__main__":

    print()
    time_initial_guess()
    print()

    t1 = time()
    # run smaller verison

    # TODO this is just for reference
    # def G(x):
    #     return [x[0]**2 + x[1]**2 - 4, x[0]**2 + x[1]**2 - 4]

    # t1 = time()
    # x = scipy.optimize.anderson(G, [2, -1])
    # tf = time() - t1
    # print(x, tf)
    # TODO end of reference

    t2 = time()
    print(f'An individual labor optimization took: {t2-t1} seconds')
