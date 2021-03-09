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

# ╔═╡ 71b53b98-8038-11eb-0ea5-d953294e9f35
using Plots, PlutoUI, Colors, Images

# ╔═╡ a84fdba4-80db-11eb-13dc-3f440653b2b9
md"""
## Summing Paths Demo
"""

# ╔═╡ b4558306-804a-11eb-2719-5fd37c6fa281
@bind n Slider(2:12, show_value = true, default=8)

# ╔═╡ bc631086-804a-11eb-216e-c955e2115f55
M = rand( 0:9, n, n)

# ╔═╡ a5fbf282-8042-11eb-2371-35cabfcbb16c
@bind x Slider(1:4, show_value = true)

# ╔═╡ 163bf8fe-80d0-11eb-2066-75439a533513
begin
	struct Paths
	    m::Int
	    n::Int
	end
	
	Base.iterate(p::Paths) = fill(1,p.m), fill(1,p.m) #start the iteration with 1's
	
	Base.IteratorSize(::Type{Paths}) = SizeUnknown()
	
	function Base.iterate(p::Paths, state)
		if state ≠ fill(p.n,p.m) # end when each row has an n
	      newstate = next(state,p.n)
	      return newstate, newstate
	    end
	end
	
	
	function next(path,n)
	    k = length(path)
		# start from the end and find the first element that can be updated by adding 1
	    while  k≥2 && ( path[k]==n || path[k]+1 > path[k-1]+1 )
	        k -= 1
	    end   
	    path[k] +=1 #add the one then reset the following elements
	    for j = k+1 : length(path)
	        path[j] = max(path[j-1]-1,1)
	    end
	    return(path)
	end
	
	function allpaths(m,n)
     v=Vector{Int}[]
	 paths = Paths(m,n)
     for p ∈ paths
        push!(v,copy(p))
    end
    v
	end
end

# ╔═╡ d1c851ee-80d5-11eb-1ce4-357dfb1e638e
begin
	paths = allpaths(n,n)
	numpaths = length(paths)
	"There are $numpaths paths to check."
end

# ╔═╡ 5dd22d0e-80d6-11eb-0541-d77668309f6c
md"""
Path $( @bind whichpath Slider(1:numpaths, show_value=true) )
"""

# ╔═╡ bfa04a82-80d8-11eb-277a-f74429b09870
begin
	i = argmax([sum( M[i,p[i]] for i=1:n) for p∈paths])
	winner = paths[i]
	winnertotal = sum( M[i,winner[i]] for i=1:n);
end

# ╔═╡ a7245c08-803f-11eb-0da9-2bed09872035
begin
	
	path = paths[whichpath]
	values = [ M[i,path[i]] for i=1:n]
	nv = length(values)
	thetitle = join([" $(values[i]) +" for i=1:nv-1 ]) * " $(values[end]) = $(sum(values))";
	
	
	rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])
	plot()
	for i=1:n, j=1:n
	   plot!(rectangle(1,1,i,j), opacity=.2, color=[:red,:white][1+rem(i+j,2) ])
	   
	end
	for i=1:n, j=1:n
	  annotate!((j+.5),n+2-(i+.5), M[i,j])
	end
	
		for i = 1:n-1
		plot!([ winner[i+1]+.5, winner[i]+.5  ],[n-i+.5, n-i+1.5], color=:pink,  linewidth=4)
	end
	
	
	for i = 1:n-1
		plot!([ path[i+1]+.5, path[i]+.5  ],[n-i+.5, n-i+1.5], color=:black,  linewidth=4)
	end
	
	plot!(xlabel="winner total = $winnertotal", xguidefontcolor=RGB(1,.5,.5))

	
	for i=1:n,j=1:n
		plot!(rectangle(.4,.4,i+.3,j+.3), opacity=1, color=RGB(0,1,0), linewidth=0,fillcolor=[RGBA(1,.85,.85,.2),:white][1+rem(i+j,2)])
	end
	plot!(title=thetitle)
	plot!(legend=false, aspectratio=1, xlims=(1,n+1), ylims=(1,n+1), axis=nothing)
end

# ╔═╡ Cell order:
# ╟─71b53b98-8038-11eb-0ea5-d953294e9f35
# ╟─a84fdba4-80db-11eb-13dc-3f440653b2b9
# ╟─b4558306-804a-11eb-2719-5fd37c6fa281
# ╟─bc631086-804a-11eb-216e-c955e2115f55
# ╟─d1c851ee-80d5-11eb-1ce4-357dfb1e638e
# ╟─5dd22d0e-80d6-11eb-0541-d77668309f6c
# ╟─a7245c08-803f-11eb-0da9-2bed09872035
# ╟─a5fbf282-8042-11eb-2371-35cabfcbb16c
# ╠═163bf8fe-80d0-11eb-2066-75439a533513
# ╠═bfa04a82-80d8-11eb-277a-f74429b09870
