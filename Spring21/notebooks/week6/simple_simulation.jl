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
using Plots, Colors, PlutoUI, StatsBase

# ╔═╡ 5d3d4988-8be8-11eb-1de8-3b114233e526
function simulate(N,p)
	v = fill(0,N,N)
	time = 0 
	while any( v .== 0 ) && time<100
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
p= $(@bind prob Slider(0.01:.01:1, show_value=true, default=.1))

t = $(@bind tt Slider(1:100, show_value=true, default=1))
"""

# ╔═╡ 5d414452-8be8-11eb-233e-2d81eaacbfb6
simulation = simulate(N, prob)

# ╔═╡ 82299e50-8bec-11eb-3591-6b02b1b2a7de
begin
	
	plot()
	cdf= [ count(simulation .≤ i) for i=0:100] 
	bar(cdf, c=:purple, legend=false, xlim=(0,tt),alpha=0.8)
end

# ╔═╡ 075669c8-8bef-11eb-288e-791816cc0d5b
begin
	newcdf = [ count(simulation .> i) for i=0:100] 
	bar!( newcdf, c=RGB(0,1,0), legend=false, xlim=(0,tt),alpha=0.8)
end

# ╔═╡ 482ebeb0-8bec-11eb-2aaf-b5522fa606d4
bar(countmap(simulation[:]), c=:red, legend=false, xlim=(0,tt+.5))

# ╔═╡ c1e720f4-8bf5-11eb-386b-b32d313a2996
@bind bernoulliwidth Slider(10:10:500, show_value=true)

# ╔═╡ 3b02051e-8bf4-11eb-011b-3b7131b245a6
HTML("""<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/ETH-BIB-Bernoulli%2C_Daniel_%281700-1782%29-Portrait-Portr_10971.tif_%28cropped%29.jpg/440px-ETH-BIB-Bernoulli%2C_Daniel_%281700-1782%29-Portrait-Portr_10971.tif_%28cropped%29.jpg" alt="" width=$(bernoulliwidth))>""")

# ╔═╡ 5f5a0caa-8bf6-11eb-1242-a91551de2922
begin
	b = "hello"
	HTML(b)
end

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
# ╠═5d3d7b56-8be8-11eb-1bb1-ddecbefefc49
# ╠═5d414452-8be8-11eb-233e-2d81eaacbfb6
# ╟─5d4409e4-8be8-11eb-2d06-03e4aa311fc0
# ╠═5d44663c-8be8-11eb-0986-bfc7546ee2ab
# ╠═82299e50-8bec-11eb-3591-6b02b1b2a7de
# ╠═075669c8-8bef-11eb-288e-791816cc0d5b
# ╠═482ebeb0-8bec-11eb-2aaf-b5522fa606d4
# ╠═c1e720f4-8bf5-11eb-386b-b32d313a2996
# ╠═3b02051e-8bf4-11eb-011b-3b7131b245a6
# ╠═5f5a0caa-8bf6-11eb-1242-a91551de2922
# ╠═5d460802-8be8-11eb-164e-71074e4e4b66
