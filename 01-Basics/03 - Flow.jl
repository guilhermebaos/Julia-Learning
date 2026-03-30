# Ternary Operator
x::Int64 = 1

x > 3 ? "Yes" : "No"


# Boolean expressions are lazy, meaning that expressions are evaluated only if it may change the truth value

# Expression y in (x && y) is not evaluated if first is false
isodd(1) && @warn("That's odd!")
isodd(2) && @warn("That's even!")

# Expression y in (x || y) is not evaluated if first is true
isodd(1) || @warn("That's odd!")
isodd(2) || @warn("That's even!")



# Conditionals are same as Python, with the notation:
# if elseif else end


# Loops
for i in 0:10:100
    print(i, " ")
end

for color in ["red", "gree", "blue"]
    print(color, " ")
end

for letter in "Julia"
    print(letter, " ")
end

for i in Dict("A" => 1, "B" => 2)
    print(i, " ")
end


# Looping through arrays is slightly different
a = reshape(1:100, (10, 10))

# Notice that we go through the first column, then the second column, and so on
for num in a
    print(num, " ")
end



# Variables are not usable outside of the loop
for i in 1:10
    @show i
end

i


for i in 1:10
    # We use this keyword to define a variable inside the loop that can be used outside it
    global howfar

    if i % 4 == 0
        howfar = i
    end
end

@show howfar



# Moreover, variables do not persist from one loop iteration to the next!
for i in 1:10
    if ! @isdefined AH
        print("AH is not defined! ")
    end
    AH = i
    @show AH
end