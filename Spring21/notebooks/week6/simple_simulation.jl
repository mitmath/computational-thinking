### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 3f8349ba-8be8-11eb-32b9-55388c7242aa
using Plots, Colors, PlutoUI

# ╔═╡ 5d3d4988-8be8-11eb-1de8-3b114233e526
function simulate(N,p)
	v = fill(0,N,N)
	time = 0 
	while any( v .== 0 )
		time += 1
		for i= 1:N, j=1:N
		     if rand()<p && v[i,j]==0
				   v[i,j] = time
			 end					    
		end
	end
	v
end

# ╔═╡ 5d3d7b56-8be8-11eb-1bb1-ddecbefefc49
md"""
N= $(@bind N Slider(2:20, show_value=true, default=8))
"""

# ╔═╡ 5d4409e4-8be8-11eb-2d06-03e4aa311fc0
md"""
p= $(@bind prob Slider(0:.01:1, show_value=true, default=.1))

t = $(@bind tt Slider(1:100, show_value=true, default=1))
"""

# ╔═╡ 5d414452-8be8-11eb-233e-2d81eaacbfb6
simulation = simulate(N, prob)

# ╔═╡ 5d460802-8be8-11eb-164e-71074e4e4b66
begin
	rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])
	circle(r,x,y) = (θ = LinRange(0,2π,500); (x.+r.*cos.(θ), y.+r.*sin.(θ)))
end

# ╔═╡ 5d44663c-8be8-11eb-0986-bfc7546ee2ab
begin
	
	
    w = .9
	h = .9
	c = [RGB(0,1,0),RGB(1,0,0),:purple][1 .+ (simulation .< tt) .+ (simulation .<  (tt.-1))] 
	
	plot()
	

	
	
	for i=1:N, j=1:N
		plot!( rectangle(w,h, i, j), c=:black)
		plot!( circle(.3,i+.45,j+.45), c=c[i,j], fill=true)
	end
	
	for i=1:N, j=1:N
		if simulation[i,j] < tt
	       annotate!(i+.45,j+.5,text("$(simulation[i,j])",font(7),:white))
		end
	end
	
	
	plot!(legend=false,ratio=1, axis=false, lims=(0.5,N+1.1), ticks=false,title="time = $(tt-1)  red count: $(sum(simulation.<tt))")
	

	
	
	
end

# ╔═╡ Cell order:
# ╠═3f8349ba-8be8-11eb-32b9-55388c7242aa
# ╠═5d3d4988-8be8-11eb-1de8-3b114233e526
# ╟─5d3d7b56-8be8-11eb-1bb1-ddecbefefc49
# ╟─5d414452-8be8-11eb-233e-2d81eaacbfb6
# ╟─5d4409e4-8be8-11eb-2d06-03e4aa311fc0
# ╠═5d44663c-8be8-11eb-0986-bfc7546ee2ab
# ╠═5d460802-8be8-11eb-164e-71074e4e4b66
