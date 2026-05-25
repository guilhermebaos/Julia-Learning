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


@time z = a * x + y

@time z = a * x + y

@time z = a * x + y
