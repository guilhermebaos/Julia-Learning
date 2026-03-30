# Single expression function
func1(x::Number) = x * x
func2(x::Number, y::Number) = x * y


# Multiple expression function
# The return of the last expression will be the return of the function (but we should always use return)
function breakfast()
    maketoast()
    breacoffee()
end


# Default arguments are similar to Python, but we can write them in any position
function xyz(x, y, z = 0)
    print(x, y, z)
end

xyz(1, 1)


# We can use a semicolon instead to make the optional arguments be keyword arguments
# This allows the optional argument to be placed in any position, or omitted
function comp(a; b = 0)
    print(a + im * b)
end


comp(b= 10, 1)


function fvar(args...)
    println("You supplied $(length(args)) arguments")
    for arg in args
        @show arg
    end
end

fvar(1, 2, 3)


# We can also use elipsis to expand a tuple in a function call
fvar((1, 2, 3)...)


function fill5(x)
    x[:] .= 5
end

mylist = collect(1:10)

fill5(mylist)


# Anonymous functions
map(x -> x^2 + 2x - 1, [1, 2, 3, 4])

map((x, y) -> x^2 + y^2, [1, 2, 3, 4], [1, 2, 3, 4])


# Speed testing
@time map(sin, 1:10000000)
@time sin.(1:10000000)


# Reduce function
# Similar to map, but the function should take to inputs and return one
# This means that multiple application reduces an array down to a single numbers
reduce(+, 1:10)

# Return the longest string
# Notice that reduce starts in the front, and evaluates the function on each pair, in order!
reduce((a, b) -> length(a) > length(b) ? a : b, split("Let's find out what is the longest word in this sentence!"))


# Folding can start from left or right
reduce(-, 1:10)
foldl(-, 1:10)
foldr(-, 1:10)


# We can also use reduce to apply a function multiple times, via a dummy argument
# The init parameter is the initial value of the accumulator
reduce((x, y) -> sqrt(x), 1:4, init=256)


# We can compose functions using mathematics notation

# Sum and then square root
(sqrt ∘ +)(3, 5)

# Pipping means that we take the function's output and use it as input for the next step
1:10 |> sum |> sqrt


# We can define functions that work differentely for different kinds of functions
