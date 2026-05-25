# We will write the operation AXPY as fast as possible (a * X + Y)

# Imports
import Random

# Constants
dim = 100_000_000
a = 1.5


# Use a set seed for comparison
Random.seed!(1)
x = rand(dim)
y = rand(dim)

z = []

@time for i in 1:dim
    temp = a * x[i] + y[i]
    push!(z, temp)
end