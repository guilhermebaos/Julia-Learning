using StaticArrays, BenchmarkTools

function lorenz!(du,u,p)
  α,σ,ρ,β = p
  @inbounds begin
    du[1] = u[1] + α*(σ*(u[2]-u[1]))
    du[2] = u[2] + α*(u[1]*(ρ-u[3]) - u[2])
    du[3] = u[3] + α*(u[1]*u[2] - β*u[3])
  end
end


function solve_system_save_iip!(u,f,u0,p,n)
  @inbounds u[1] = u0
  @inbounds for i in 1:length(u)-1
    f(u[i+1],u[i],p)
  end
  u
end

p = (0.02,10.0,28.0,8/3)
u = [Vector{Float64}(undef,3) for i in 1:1000]

@btime solve_system_save_iip!(u,lorenz!,[1.0,0.0,0.0],p,1000)



using Base.Threads
function lorenz_mt!(du,u,p)
  α,σ,ρ,β = p
  let du=du, u=u, p=p
    Threads.@threads for i in 1:3
      @inbounds begin
        if i == 1
          du[1] = u[1] + α*(σ*(u[2]-u[1]))
        elseif i == 2
          du[2] = u[2] + α*(u[1]*(ρ-u[3]) - u[2])
        else
          du[3] = u[3] + α*(u[1]*u[2] - β*u[3])
        end
        nothing
      end
    end
  end
  nothing
end

function solve_system_save_iip!(u,f,u0,p,n)
  @inbounds u[1] = u0
  @inbounds for i in 1:length(u)-1
    f(u[i+1],u[i],p)
  end
  u
end

p = (0.02,10.0,28.0,8/3)
u = [Vector{Float64}(undef,3) for i in 1:1000]
@btime solve_system_save_iip!(u,lorenz_mt!,[1.0,0.0,0.0],p,1000);






using Statistics

function compute_trajectory_mean(u0,p)
  u = Vector{typeof(@SVector([1.0,0.0,0.0]))}(undef,1000)
  solve_system_save!(u,lorenz,u0,p,1000);
  mean(u)
end
@btime compute_trajectory_mean(@SVector([1.0,0.0,0.0]),p)


u = Vector{typeof(@SVector([1.0,0.0,0.0]))}(undef,1000)
function compute_trajectory_mean2(u0,p)
  # u is automatically captured
  solve_system_save!(u,lorenz,u0,p,1000);
  mean(u)
end
@btime compute_trajectory_mean2(@SVector([1.0,0.0,0.0]),p)


const _u_cache = Vector{typeof(@SVector([1.0,0.0,0.0]))}(undef,1000)
function compute_trajectory_mean3(u0,p)
  # u is automatically captured
  solve_system_save!(_u_cache,lorenz,u0,p,1000);
  mean(_u_cache)
end
@btime compute_trajectory_mean3(@SVector([1.0,0.0,0.0]),p)


function _compute_trajectory_mean4(u,u0,p)
  solve_system_save!(u,lorenz,u0,p,1000);
  mean(u)
end
compute_trajectory_mean4(u0,p) = _compute_trajectory_mean4(_u_cache,u0,p)
@btime compute_trajectory_mean4(@SVector([1.0,0.0,0.0]),p)