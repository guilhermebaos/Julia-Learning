#=
This is a multi-line comment!
=#


# Assign a value
x, y, z = 13, "AH", true

# Do operations
x += 10 + x^2

# View the type of a variale
typeof(x)

# Change the data type dynamically
x = "String!"

# We can use \theta+TAB to obtain unicode characters 
θ = 12

# Can even use  \beta+TAB+\_0 to get subscripts, same for superscripts
θ₀ = 0

# There are some useful pre-defined constants
π 
ℯ 


# We can swap variables in one-line! No need for a temporary variable
a, b = 1, 2
a, b = b, a


# We can type explicitly using ::
num::Int64 = 13


function sum2float(x::Float64, y::Float64)
    return x + y
end

sum2float(12.0, 12.0)


# Validate if an expression has a given type via (expression)::testType
# If validation fails, we get an error
((7 + 8) * 2)::Int64


# Constants can be declared using const
const parameter::Int64 = 10


# We can redefine constants using the const keyword, but is not advisable
const parameter = 11

