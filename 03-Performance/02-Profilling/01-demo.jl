function myfunc()
    A = rand(200, 200, 200)
    return maximum(A)
end


# Time Function

@time myfunc()

