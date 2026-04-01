# Metaprogramming in Julia allows us to change code after it has been parsed but before it is executed

# Inserts a stopwatch before and after an prints the result
@time [cos(sin(i)) for i in 1:100000]

# Tells us which method would be use to evaluate the expression
@which 2+2


# To access a parsed but non-executed expression we can use : or quote end
code = quote
    for j in 1:5
        print(j, " ")
    end
end

eval(code)


# We can acess lines in our quoted code by looking at its arguments
for (n, command) in enumerate(code.args)
    println(n, ": ", command)
end


# We can use the $ to insert the result of a code into a quoted expression
temp = quote str = $(sin(1) + cos(1)); end


# A macro is a way to change an unvaluated piece of code

macro printcode(n)
    if typeof(n) == Expr
        println(n.args)
    end
    return n
end

# Just runs the code normaly
@printcode 3

# If we give it an expression then it prints it
@printcode temp


# We can use @macroexpand to see the code after the macro acts
@macroexpand @time [cos(sin(i)) for i in 1:100000]