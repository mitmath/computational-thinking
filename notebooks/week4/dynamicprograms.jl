### A Pluto.jl notebook ###
# v0.14.5

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
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Images", version="0.22.4"), 
			Pkg.PackageSpec(name="ImageMagick", version="0.7"), 
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="Plots"), 
			Pkg.PackageSpec(name="Colors")
			])

	using Plots, PlutoUI, Colors, Images
end

# ╔═╡ c09f68a2-887e-11eb-2381-41aca305e8cc
html"""
<div style="
position: absolute;
width: calc(100% - 30px);
border: 50vw solid #282936;
border-top: 500px solid #282936;
border-bottom: none;
box-sizing: content-box;
left: calc(-50vw + 15px);
top: -500px;
height: 500px;
pointer-events: none;
"></div>

<div style="
height: 500px;
width: 100%;
background: #282936;
color: #fff;
padding-top: 68px;
">
<span style="
font-family: Vollkorn, serif;
font-weight: 700;
font-feature-settings: 'lnum', 'pnum';
"> <p style="
font-size: 1.5rem;
opacity: .8;
"><em>Section 1.7</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Intro to Dynamic Programming </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/KyBXJV1zFlo" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ a84fdba4-80db-11eb-13dc-3f440653b2b9
md"""
## Intro to Dynamic Programming 
"""

# ╔═╡ 938107f0-80ee-11eb-18cf-775802c43c2f
md"""
What is dynamic progamming? The word "programming" here is a rather archaic word (but still in  use) for an **optimization problem**, as used, for example, in the phrase 
"linear programming."  Probably the word "programming" should be abandoned in this context, but no doubt it is too late.
"""

# ╔═╡ eb043a90-8102-11eb-3b78-d590a23c83f4
md"""
### Summing over paths problem
"""

# ╔═╡ 5994117c-8102-11eb-1b05-671b7cf87a7e
md"""
Let's start by looking at the following problem. 
Let's create a random matrix and follow paths on it.
The paths start at one of the square on the top, and can only go downwards, either South-East, South, or South-West.

We will *add up* the numbers visited along each path. Our goal is to find the path that has the *smallest* sum. So this is indeed an optimization problem: we want to **minimize** the sum along these particular paths.
"""

# ╔═╡ b4558306-804a-11eb-2719-5fd37c6fa281
md"""
n = $(@bind n Slider(2:12, show_value = true, default=8))
"""

# ╔═╡ bc631086-804a-11eb-216e-c955e2115f55
M = rand( 0:9, n, n)

# ╔═╡ 4e4d333e-8102-11eb-0ba1-0f0183d0d3c2
md"""
One way to solve this problem is the naive algorithm where we enumerate *all* the paths, calculate the sum for each, and take the minimum.
However, as the matrix gets larger the total number of paths grows *exponentially*.
"""

# ╔═╡ 0f0e7456-8104-11eb-1d90-e9f0009e8789
md"""
[Possible research problem: Investigate the statistics of the sums over all possible paths.]
"""

# ╔═╡ 4f969032-80e9-11eb-1ada-d1aa64960967
md"""
## Fixing a single point on a path
"""

# ╔═╡ 28f18aa2-8104-11eb-0c01-dbd14c760ecf
md"""
Let's fix a given point $(i, j)$ and focus only on all those paths that pass through $(i, j)$.
"""

# ╔═╡ 37ebfa3e-80e5-11eb-166c-4ff3471ab12d
md"""
i= $(@bind fixi Scrubbable(1:n))
j= $(@bind fixj Scrubbable(1:n))
"""

# ╔═╡ 4d81a6f4-8104-11eb-1f06-5bb7a56c8406
md"""
Suppose we fix the point on the penultimate row (last but one). When we look at the paths below the fixed value, we're doing the same calculation over and over again. It doesn't seem sensible to keep re-doing these calculations. The same holds as we move the fixed point further upwards.

So instead of calculating by working "forwards", for each box we look at the minimum below it.
"""

# ╔═╡ d9265982-80ed-11eb-3a5f-27712a23506b
md"""
## The idea of *overlapping subproblems*
"""

# ╔═╡ ba4acb08-8104-11eb-1771-15bc5d8076fd
md"""
The key point in this problem is that there are *overlapping subproblems*: there are calculations that we don't need to repeat. 

The idea of dynamic programming is to remember the solution of those subproblems to get an exponential speed-up in the calculation speed.
"""

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
	md"There are $numpaths paths to check."
end

# ╔═╡ 5dd22d0e-80d6-11eb-0541-d77668309f6c
md"""
Path $( @bind whichpath Slider(1:numpaths, show_value=true) )
"""

# ╔═╡ 84bb1f5c-80e5-11eb-0e55-83068948870c
begin
	fixedpaths = [p for p∈paths  if p[fixi]==fixj]
	number_of_fixedpaths = length(fixedpaths)
	md"Number of fixed paths = $number_of_fixedpaths"
end

# ╔═╡ ee2d787c-80e5-11eb-1930-0fcbe253643f
@bind whichfixedpath Slider(1:number_of_fixedpaths)

# ╔═╡ e5367534-80e5-11eb-341d-7b3e6ca4f111
begin
	
	path = fixedpaths[whichfixedpath]
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
	
	annotate!((fixj+.5),n+2-(fixi+.5), M[fixi,fixj], :red)
	
	
	for i = 1:n-1
		i ≥ 	fixi ? c=:blue : c=:black
		plot!([ path[i+1]+.5, path[i]+.5  ],[n-i+.5, n-i+1.5], color=c,  linewidth=4)
	end
	
  xlabel!("")

	
	for i=1:n,j=1:n
		plot!(rectangle(.4,.4,i+.3,j+.3), opacity=1, color=RGB(0,1,0), linewidth=0,fillcolor=[RGBA(1,.85,.85,.2),:white][1+rem(i+j,2)])
	end
	plot!(title=thetitle)
	plot!(legend=false, aspectratio=1, xlims=(1,n+1), ylims=(1,n+1), axis=nothing)
end

# ╔═╡ 4e8c8052-8102-11eb-3e9f-01494b525ba0
md"""
### Summing Paths Demo
"""

# ╔═╡ bfa04a82-80d8-11eb-277a-f74429b09870
begin
	winnernum = argmin([sum( M[i,p[i]] for i=1:n) for p∈paths])
	winner = paths[winnernum]
	winnertotal = sum( M[i,winner[i]] for i=1:n);
end

# ╔═╡ 7191b674-80dc-11eb-24b3-518de83f465a
md"""
Our goal is to add the numbers on a path and find the minimal path.
The winner is number $winnernum.
"""

# ╔═╡ a7245c08-803f-11eb-0da9-2bed09872035
let
	
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
	
	# The winning path 
		for i = 1:n-1
		plot!([ winner[i+1]+.5, winner[i]+.5  ],[n-i+.5, n-i+1.5], color=RGB(1,.6,.6),  linewidth=4)
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
# ╟─c09f68a2-887e-11eb-2381-41aca305e8cc
# ╠═71b53b98-8038-11eb-0ea5-d953294e9f35
# ╟─a84fdba4-80db-11eb-13dc-3f440653b2b9
# ╟─938107f0-80ee-11eb-18cf-775802c43c2f
# ╟─eb043a90-8102-11eb-3b78-d590a23c83f4
# ╟─5994117c-8102-11eb-1b05-671b7cf87a7e
# ╟─b4558306-804a-11eb-2719-5fd37c6fa281
# ╟─bc631086-804a-11eb-216e-c955e2115f55
# ╟─d1c851ee-80d5-11eb-1ce4-357dfb1e638e
# ╟─7191b674-80dc-11eb-24b3-518de83f465a
# ╟─5dd22d0e-80d6-11eb-0541-d77668309f6c
# ╟─a7245c08-803f-11eb-0da9-2bed09872035
# ╟─4e4d333e-8102-11eb-0ba1-0f0183d0d3c2
# ╟─0f0e7456-8104-11eb-1d90-e9f0009e8789
# ╟─4f969032-80e9-11eb-1ada-d1aa64960967
# ╟─28f18aa2-8104-11eb-0c01-dbd14c760ecf
# ╟─37ebfa3e-80e5-11eb-166c-4ff3471ab12d
# ╟─84bb1f5c-80e5-11eb-0e55-83068948870c
# ╟─ee2d787c-80e5-11eb-1930-0fcbe253643f
# ╟─e5367534-80e5-11eb-341d-7b3e6ca4f111
# ╟─4d81a6f4-8104-11eb-1f06-5bb7a56c8406
# ╟─d9265982-80ed-11eb-3a5f-27712a23506b
# ╟─ba4acb08-8104-11eb-1771-15bc5d8076fd
# ╟─163bf8fe-80d0-11eb-2066-75439a533513
# ╟─4e8c8052-8102-11eb-3e9f-01494b525ba0
# ╠═bfa04a82-80d8-11eb-277a-f74429b09870
