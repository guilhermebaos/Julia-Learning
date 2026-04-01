# Imports
using BenchmarkTools

# When optimizing code we should always write it inside a function
# This is because Julia's JIT compiler can 


# Julia stores arrays in column major ordering
A = rand(100, 100)
B = rand(100, 100)
C = rand(100, 100)


# This goes through rows first, then columns
function inner_rows!(C, A, B)
  for i in 1:100, j in 1:100
    C[i,j] = A[i,j] + B[i,j]
  end
end
@btime inner_rows!(C, A, B)


# This goes through column first, then rows
# This version is much faster because we are using the same order as Julia stores its arrays!!
function inner_cols!(C, A, B)
  for j in 1:100, i in 1:100
    C[i,j] = A[i, j] + B[i, j]
  end
end
@btime inner_cols!(C, A, B)


# Variables with fixed size go to the stack, and are very quick to access
# Variables with variable size go to the heap, and are slower to access because the heap stores pointers to the data, which then has to be retrieved

# This distinction is very important for smaller variables, which can live close to the core the whole program!


# This function stores the sum in a array, which is stored in the heap
function inner_alloc!(C, A, B)
  for j in 1:100, i in 1:100
    val = [A[i,j] + B[i,j]]
    C[i,j] = val[1]
  end
end
@btime inner_alloc!(C, A, B)

# This function stores the sum in a variable of inferred type Float64 which has a fixed size, hence it stays in the stack
function inner_noalloc!(C, A, B)
  for j in 1:100, i in 1:100
    val = A[i,j] + B[i,j]
    C[i,j] = val[1]
  end
end
@btime inner_noalloc!(C, A, B)


# We can use fixed size arrays, which get assigned to the stack instead of the heap
using StaticArrays

# Same code as before, but we use use the @SVector macro to rewrite the code 
function inner_static!(C, A, B)
  for j in 1:100, i in 1:100
    val = @SVector [A[i,j] + B[i,j]]
    C[i,j] = val[1]
  end
end
@btime inner_static!(C, A, B)

# We need to remember that the heap allows for random access, while stacks have to access items in order
# This means static vectors should be in the stack only if they are small!

# That said, we can use Mutation to avoid heap allocation (we should use a ! at the end to say that a function modifies arguments)
# Therefore, we can use previously allocated memory again to avoid more memory allocation

# This function mutates the array C
function inner_noalloc!(C, A, B)
  for j in 1:100, i in 1:100
    val = A[i,j] + B[i,j]
    C[i,j] = val[1]
  end
end
@btime inner_noalloc!(C, A, B)

# This function creates a new array C (notice in the @time output we have some allocation)
function inner_alloc(A, B)
  C = similar(A)
  for j in 1:100, i in 1:100
    val = A[i,j] + B[i,j]
    C[i,j] = val[1]
  end
end
@btime inner_alloc(A, B)


# Loop fusion prevents the creation of temporary variables
# We can use . to broadcast many arguments into the same form, and also fuse operations!

# This is not fused
function unfused(A,B,C)
  tmp = A .+ B
  tmp .+ C
end
@btime unfused(A,B,C);


# This is fused
fused(A,B,C) = A .+ B .+ C
@btime fused(A,B,C);

# We can also use .() to call functions on vector arguments, which benefits from fusion
# In practice, the . collects all dotted operations in the expression and just-in-time compiles a function for that expression
