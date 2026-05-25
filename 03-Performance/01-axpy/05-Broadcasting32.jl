# We will write the operation AXPY as fast as possible (a * X + Y)

# Imports
import Random

# Constants
const dim = 100_000_000
const a::Float32 = 1.5


# Use a set seed for comparison
Random.seed!(1)
x = rand(Float32, dim)
y = rand(Float32, dim)


@time z = a .* x .+ y

@time z = a .* x .+ y

@time z = a .* x .+ y
