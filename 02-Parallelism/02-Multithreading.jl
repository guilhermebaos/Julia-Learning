using Base.Threads
using BenchmarkTools


# Number of threads
nth = Threads.nthreads()


# Thread-Unsafe Summation
# The problem is that `acc` lives in the heap!
# The thread reads from the heap, sums 1, and writes to the heap (meaning we have race conditions)
acc = 0
@threads for i in 1:10_000
    global acc
    acc += 1
end

@show acc



# We use atomics to make the calculations thread-safe
# An atomic object can only be accessed by one thread at a time
acc = Atomic{Int64}(0)
@threads for i in 1:10_000
    atomic_add!(acc, 1)
end

@show acc



# Atomic operations are very specialized, and therefore fast
# Locks are a generalization of atomic operations, allowing a thread to block a piece of memory for itself

# Spin locking is non-reentrant.
# It is fast, but it does not allow for nested locking (we cannot lock the memory inside the first lock).
const acc_lock = Ref{Int64}(0)
const splock = SpinLock()
function f1()
    @threads for i in 1:10_000
        lock(splock)
        acc_lock[] += 1
        unlock(splock)
    end
end


# Spin locking is reentrant.
# We can have locks within locks, as needed.
const rsplock = ReentrantLock()
function f2()
    @threads for i in 1:10_000
        lock(rsplock)
        acc_lock[] += 1
        unlock(rsplock)
    end
end



# Atomic operations are faster and safer, because they are specialized.
acc2 = Atomic{Int64}(0)
function g()
  @threads for i in 1:10_000
      atomic_add!(acc2, 1)
  end
end


# Serial operations ends up being faster, because the compiler optimizes it!
# This shows that making code parallel can massively reduce compiler optimizations!!
const acc_s = Ref{Int64}(0)
function h()
  global acc_s
  for i in 1:10_000
      acc_s[] += 1
  end
end


@btime f1()
@btime f2()
@btime g()
@btime h()