# Julia is dynamically typed, but specifying a type via ::type will make a variable statically typed.
# Specifying a type may make our code faster!

# We should avoid changing types, because that wastes computation and may cause loss of precision.


# Common types
x::Int64 = 1

y::Rational = 1//2

z::Float64 = 1.12


# Types are organized as a tree, hence we can see the parents or children of a given type
supertype(Number)
subtypes(Number)


# There are two kinds of types:
# Concrete types can be instantiated
# Abstract types cannot


# Concrete types do not have subtypes
# Hence concrete types always have abstract types as supertype
supertype(Int64)

# Abstract types can be used to check for multiple concrete types
(1)::Signed


# There are also two kinds of concrete types:
# Primitive/ basic types -> Hardcoded types.
# Complex/ composite types -> Group many other types to represent higher-level data structures.

# Primitve = Int8, UInt8, Float16, ..., BigFloat, BigInt, Bool, Char, String
# Complex = Rational (one Int for the numerator and another for denominator)

# We can use sizeof to see the size of an instance of a class (returns the size in bytes)
sizeof(Int128)
sizeof(Float64)

# We can also see the largest and smallest numbers we cna store with a given type
typemax(Int16)
typemin(Int16)


# We can define a function to list the subtypes of a particular type
function type_tree(type, level=0)
    println("\t" ^ level, type)
    for t in subtypes(type)
        type_tree(t, level+1)
    end
end

type_tree(Number)


# We can make custom types that also benefit from the speedup of native types
abstract type MyAbstractType end

# By default the new type is a child of the Any type
supertype(MyAbstractType)


# We can make a new type which is a subtype of an existing type
abstract type MyAbstractNum <: Number end

# We can now create a concrete type which is a subtype of our custom abstract type
# This type has two variables, a `foo` which can be of any type, and `bar` which is an Int
mutable struct MyConcreteNum <: MyAbstractNum
    foo
    bar::Int
end

# Instantiate
MyVar = MyConcreteNum("Hello", 10)

MyVar.foo
MyVar.bar

MyVar.bar = 5