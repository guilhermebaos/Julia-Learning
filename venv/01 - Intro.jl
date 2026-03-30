# Change into the current directory
cd(@__DIR__)

# Activate the enviornment at the same level as this file
using Pkg
Pkg.activate(".")

# Imports
using ForwardDiff, FiniteDiff

# Define a function
f(x) = 2x^2 + x

ForwardDiff.derivative(f, 2.0)
FiniteDiff.finite_difference_derivative(f, 2.0)