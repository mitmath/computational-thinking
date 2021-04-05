### A Pluto.jl notebook ###
# v0.14.0

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

# ╔═╡ 3649f170-923a-11eb-321c-cf95849cc044
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
"><em>Section 2.5</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Random Walks </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/14hHtGJ4s-g" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 97e807b2-9237-11eb-31ef-6fe0d4cc94d3
begin
    import Pkg
    Pkg.activate(mktempdir())
  
    Pkg.add([
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="BenchmarkTools", version="0.6"),
    ])
	
    using Plots, PlutoUI, BenchmarkTools
end

# ╔═╡ 5f0d7a44-91e0-11eb-10ae-d73156f965e6
TableOfContents(aside=true)

# ╔═╡ 9647147a-91ab-11eb-066f-9bc190368fb2
md"""
# Julia concepts

- Benchmarking: BenchmarkTools.jl
- Plotting in a loop
- Generic programming
- Mutable vs immutable structs
- Functions with types as parameters: `where`
- Vectors of vectors
- Aliasing of memory 
- `cumsum`
"""

# ╔═╡ ff1aca1e-91e7-11eb-343e-0f89d9570b06
md"""
# Motivation: Dynamics of hard discs
"""

# ╔═╡ 66a2f510-9232-11eb-3be9-131febc0039f
md"""
Brown observed **Brownian motion** in 1827: Large particles like sand or pollen in water move around seemingly at random. Einstein explained this in 1905 as repeated impacts with water molecules.

We can visualise that with a simulation of hard discs bouncing off one another. Even though the dynamics is not random -- each disc follows Newton's laws -- if we just look at a single one of them it *looks* random.
"""

# ╔═╡ bd3170e6-91ae-11eb-06f8-ebb6b2e7869f
md"""
## Visualising random walks
"""

# ╔═╡ a304c842-91df-11eb-3fac-6dd63087f6de
md"""
A **random walk** models random motion in time and space. At each time step an object moves in a random direction.

Let's visualise the result in 2 dimensions.
"""

# ╔═╡ 798507d6-91db-11eb-2e4a-3ba02f12ba65
md"""
N = $(@bind N Slider(1:6, show_value=true, default=1))
"""

# ╔═╡ 3504168a-91de-11eb-181d-1d580d5dc071
md"""
t = $(@bind t Slider(1:10^N, show_value=true, default=1))
"""

# ╔═╡ 4c8d8294-91db-11eb-353d-c3696c615b3d
begin
	plot(traj[1:t], ratio=1, leg=false, alpha=0.5, lw=2)
	scatter!([ traj[1], traj[t] ], c=[:red, :green])
	
	xlims!(minimum(first.(traj)) - 1, maximum(first.(traj)) + 1)
	ylims!(minimum(last.(traj)) - 1, maximum(last.(traj)) + 1)
	
end

# ╔═╡ b62c4af8-9232-11eb-2f66-dd27dcb87d20
md"""
We see that the dynamics closely resembles, at least qualitatively, that of the hard disc.
"""

# ╔═╡ 905379ce-91ad-11eb-295d-8354ecf5c5b1
md"""
# Why use random walks?

#### Why should we model with random processes?

- Either we need to get a lot of data to precisely characterise a system, or we assume it's random

- It may well be that *can* have all the details, but by making a simplifying assumption we actually gain more *understanding*.


#### Examples:


- Stock price going up and down


- Pollutants getting dispersed in the air


- Neutral genes moving through a population


"""

# ╔═╡ 5c4f0f26-91ad-11eb-033b-2bd221f0bdba
md"""
# Simple random walk

The simplest version is called **simple random walk**: one object jumps on the integers: at each time step it jumps left or right. 

Each such step is a new random variable, taking values $\pm 1$ at each step, each with probability $1/2$ (in the simplest case). 
We can think of this as a scaling of a Bernoulli random variable.

In order to simulate this, we need to know how to generate the jumps.
"""

# ╔═╡ da98b676-91e0-11eb-0d97-57b8a8aadf2a
md"""
## Julia: Benchmarking
"""

# ╔═╡ e0b607c0-91e0-11eb-10aa-53ec33570e59
md"""
There are various ways we could generate random values $\pm 1$. Let's use this as an opportunity to learn about **benchmarking** in Julia, i.e. measuring run time to compare performance. In this case we will do "micro-benchmarks", which try to compare tiny pieces of code which we intend to run many millions of times, so that small differences in run time can be significant.

The `BenchmarkTools.jl` package provides relatively easy-to-use tools for measuring this, by running the code many times and calculating statistics. The `@btime` macro is a simple way to estimate actual running time. Each option should be enclosed in a function.
"""

# ╔═╡ fa1635d4-91e3-11eb-31bd-cf61c502ad35
md"""
Here are a few different ways we could generate random steps:
"""

# ╔═╡ f7f9e4c6-91e3-11eb-1a56-8b98f0b09b46
begin
	step1() = rand( (-1, +1) )
	
	step2() = 2 * (rand() < 0.5) - 1
	
	step3() = 2 * rand(Bool) - 1
	
	step4() = sign(randn())
	
	step5() = rand( [-1, +1] )
end

# ╔═╡ 0bc813ca-924e-11eb-3032-0bdda2feef9b
typeof( (-1, +1) )

# ╔═╡ 166f2a0a-924e-11eb-0aca-41f27d038e6d
typeof( [-1, +1] )

# ╔═╡ 55a7a334-9245-11eb-2114-7d2bc503e133
md"""
1ns = 10^(-9) seconds;  1 one-billionth of a second
"""

# ╔═╡ 5da7b076-91b4-11eb-3eba-b3f5849efabb
with_terminal() do
	@btime step1()
	@btime step2()
	@btime step3()
	@btime step4()
	@btime step5()
end

# ╔═╡ 654ff3ae-924e-11eb-1671-699a2c07a3ba
@benchmark step6()

# ╔═╡ ea9e77e2-91b1-11eb-185d-cd006db11f60
md"""
## Trajectory of a random walk
"""

# ╔═╡ 12b4d528-9239-11eb-2824-8ddb5e2ba892
md"""
We can now calculate the **trajectory** of a 1D random walk as it takes several steps.
It starts at an initial position, for example, 0, and takes consecutive steps:
"""

# ╔═╡ 2f525796-9239-11eb-1865-9b01eadcf548
function walk1D(N)
	x = 0  # specific to 1D
	xs = [x]
	
	for i in 1:N
		x += step()   # specific to 1D
		push!(xs, x)
	end
	
	return xs
end

# ╔═╡ 6bacbbe0-9250-11eb-3494-8151538ef0fd
md"""
Let's try to generalise this by making it less specific to 1D. We will turn the 1D-specific pieces into functions:
"""

# ╔═╡ eacd4d3e-9246-11eb-04f4-7dd11f7e6bd5
function walk(N)
	x = initialise()  
	xs = [x]
	
	for i in 1:N
		x += step()   
		push!(xs, x)
	end
	
	return xs
end

# ╔═╡ f67634e8-9246-11eb-0fb3-852ba4d2931e
begin
	initialise() = 0
	step() = rand( (-1, +1) )
end

# ╔═╡ 84251d00-9250-11eb-177b-d5e2de2af37f
md"""
Now we can write those functions in 2D too:
"""

# ╔═╡ 3fa5d34e-9247-11eb-26ad-2f7dfafcd08a
const directions = [ [1, 0], [0, 1], [-1, 0], [0, -1] ]

# ╔═╡ 465e63c2-9247-11eb-0a33-59c50e6a1677
typeof(directions)

# ╔═╡ 169b6f04-9247-11eb-3282-491b39bd47c7
begin
	initialise2D() = [0, 0]
	step2D() = rand( directions )
end

# ╔═╡ 3e995fe8-9247-11eb-1411-75bf7ed9148f
step2D()

# ╔═╡ 9388ffdc-9250-11eb-3435-bd1f05d53f93
md"""
We could copy and paste the code to make a 2D version:
"""

# ╔═╡ 2ba7bc54-9247-11eb-0527-d5ea94b27193
function walk2D(N)
	x = initialise2D()  
	xs = [x]
	
	for i in 1:N
		x += step2D()   
		push!(xs, x)
	end
	
	return xs
end

# ╔═╡ 3137a1f2-9247-11eb-1138-dfab4b1b31bc
walk2D(10)

# ╔═╡ c879dd0a-9247-11eb-11c6-a93aa0e7e523
function walk(initialise, step, N)
	x = initialise()  
	xs = [x]
	
	for i in 1:N
		x += step()   
		push!(xs, x)
	end
	
	return xs
end

# ╔═╡ 0fc47f94-9248-11eb-318c-85400bd20ae7
(1, 2) .+ (3, 4)

# ╔═╡ e03bc28c-9247-11eb-141c-2f7e18935d40
walk(initialise2D, step2D, 10)

# ╔═╡ f932a922-9247-11eb-18c8-af63230649f7
walk(initialise, step, 10)

# ╔═╡ f3b21c40-9246-11eb-1873-1bcc82d68e23
walk(10)

# ╔═╡ 11962a42-9246-11eb-0f2f-1f702ecb9c4f
xs = walk1D(10)

# ╔═╡ 51abfe6e-9239-11eb-362a-259570250663
begin
	plot()
	
	for i in 1:100
		plot!(walk1D(1000), leg=false, size=(500, 300), lw=2, alpha=0.5)
	end
	
	xlabel!("t")
	ylabel!("x position in space")
	
	plot!()
end

# ╔═╡ b847b5ca-9239-11eb-02fe-db4d9625bc5f
md"""
# Making it more general: Random walks using types
"""

# ╔═╡ c2deb090-9239-11eb-0739-a74379c15ce6
md"""
Now suppose we want to think about more general random walks, for example moving around in 2D. Then we need to *generalise* the above function.
		
Based on our experience from last time, you should suspect that a good way to do this is with *types*. We will define types representing 1D and 2D walkers, and a trajectory function that will work for *any* walker.

"""

# ╔═╡ 689f8404-923b-11eb-2c5c-d5a2d80be6b3
md"""
### Mutable vs immutable structs
"""

# ╔═╡ 6c579eec-923b-11eb-32c5-6754b60c2ae8
md"""
A walker has a position that changes in time. There are two possible ways that we could implement this. Either we modify the position inside the object (mutable), or we create a new walker object each time with the new position (immutable). 

While mutable types may be conceptually easier, immutable types often have performance benefits, so we show here how to use them.

"""

# ╔═╡ d420d492-91d9-11eb-056d-33cc8f0aed74
abstract type Walker end

# ╔═╡ ad2d4dd8-91d5-11eb-27af-6f0c6e61a86a
begin
	struct Walker1D <: Walker
		pos::Int64
	end
	
	Walker1D() = Walker1D(0)
end

# ╔═╡ d0f81f28-91d9-11eb-2e79-61461ef5b132
position(w::Walker) = w.pos

# ╔═╡ b8f2c508-91d5-11eb-31b5-61810f171270
step(w::Walker1D) = rand( (-1, +1) )

# ╔═╡ 664080a2-9248-11eb-01b5-69fc4aeb90da
w = Walker1D()

# ╔═╡ 6fd96dfe-9248-11eb-2389-d788d0f89e3b
step(w)

# ╔═╡ 8825c3e4-9248-11eb-1073-f572e764908a
w.pos = -1

# ╔═╡ a9b408ea-9248-11eb-2c0c-37167450b91c
mutable struct MutableWalker <: Walker
	pos::Int64
end

# ╔═╡ b00926e4-9248-11eb-110f-91438c826090
w2 = MutableWalker(0)

# ╔═╡ b664e708-9248-11eb-36a8-a99b23fa2975
w2.pos = -1

# ╔═╡ b9a57a9a-9248-11eb-128b-21f779e564b8
w2

# ╔═╡ c6a38dea-9248-11eb-1784-07153b0febec
w

# ╔═╡ c8aed310-9248-11eb-2686-7758ae5afb7d
w3 = Walker1D(1)

# ╔═╡ be40585c-923b-11eb-0cbc-85599c23ef81
md"""
### Functions with type parameters
"""

# ╔═╡ c5af5aac-923b-11eb-09f3-a3d4e5b7cfa8
md"""
To do this requires the ability to generate a new object of a given type, so that information needs to be available to the function.
"""

# ╔═╡ d77cf668-923b-11eb-141d-d3d4ee24136d
md"""
Here we make a type in which we can have access to the *type* `W` of the walker:
"""

# ╔═╡ 3c3971e2-91da-11eb-384c-01c627318bdc
update(w::W, step) where {W <: Walker} = W(position(w) + step)

# ╔═╡ d5744a6e-9249-11eb-1bcd-cdef0cc3d459
md"""
If we have *mutable* objects we could just write
"""

# ╔═╡ ff85fb56-9249-11eb-10ec-e9c249e3cf14
function update!(w_mutable, step)
	
	current_pos = w_mutable.pos 
	new_pos = current_pos + step
	
	w_mutable.pos = new_pos
end

# ╔═╡ bacca794-9249-11eb-1ed4-87a6a6baba5b
md"""
The function calls the constructor of the type `W` to make a new object of that type.
"""

# ╔═╡ 2edea8c2-9249-11eb-03df-a90755310a97
md"""
`W` here is `Walker1D` or `Walker2D` type
"""

# ╔═╡ 3aadaeda-9249-11eb-0683-05fa5f1dc3eb
w  # a walker at position 0

# ╔═╡ 3f0317ce-9249-11eb-0cc2-47f007fefcdf
update(w, -1)

# ╔═╡ 49e05bd4-9249-11eb-35a3-6df516b6ee3a
w

# ╔═╡ 5117fa2e-9249-11eb-2158-4126ddec2c55
md"""
Now I would like to do `w = update(w, -1)`
"""

# ╔═╡ 7f544166-9249-11eb-08ab-c35e8ca632d3
w2D = Walker2D(0, 0)

# ╔═╡ a08e6ca0-9249-11eb-3947-3f3a29e29814
update(w2D, [-1, -1])

# ╔═╡ a9fe6236-9249-11eb-152c-b57af2c002e2
w2D

# ╔═╡ fe7fb84a-923b-11eb-0b54-0b3278bb009b
md"""
This says that we are defining a function that acts on an object `ww` of type `W`, but we are restricting it (using the `where` clause) to apply only to types that are subtypes of `Walker`.
		
We then use the constructor of the type `W` to make a new object *of that type* with the new position.
"""

# ╔═╡ cb0ef266-91d5-11eb-314b-0545c0c817d0
function walk(w::W, N) where {W <: Walker}   # W is a type parameter
	ws = [position(w)]  # "getter" function

	for i in 1:N
		pos = position(w)
		w = update(w, step(w))   # reassigning the variable w to a new object
		
		push!(ws, position(w))
	end
	
	return ws
end

# ╔═╡ 048fac02-91da-11eb-0d26-4f258b4cd043
walk(Walker1D(0), 10)

# ╔═╡ 8c75aeee-9242-11eb-16b2-8fc1c243b794
md"""
Now let's make a 2D one.
"""

# ╔═╡ 23b84ce2-91da-11eb-01f8-c308ac4d1c7a
struct Walker2D <: Walker
	x::Int
	y::Int
end

# ╔═╡ 537f952a-91da-11eb-33cf-6be2fd3bc45c
position(w::Walker2D) = (w.x, w.y)

# ╔═╡ 5b972296-91da-11eb-29b1-074f3926181e
step(w::Walker2D) = rand( [ [1, 0], [0, 1], [-1, 0], [0, -1] ] )

# ╔═╡ 3ad5a93c-91db-11eb-3227-c96bf8fd2206
update(w::Walker2D, step::Vector) = Walker2D(w.x + step[1], w.y + step[2])

# ╔═╡ 74182fe0-91da-11eb-219a-01f13b86406d
traj = walk(Walker2D(0, 0), 10^N)

# ╔═╡ Cell order:
# ╟─3649f170-923a-11eb-321c-cf95849cc044
# ╠═97e807b2-9237-11eb-31ef-6fe0d4cc94d3
# ╠═5f0d7a44-91e0-11eb-10ae-d73156f965e6
# ╟─9647147a-91ab-11eb-066f-9bc190368fb2
# ╟─ff1aca1e-91e7-11eb-343e-0f89d9570b06
# ╟─66a2f510-9232-11eb-3be9-131febc0039f
# ╟─bd3170e6-91ae-11eb-06f8-ebb6b2e7869f
# ╟─a304c842-91df-11eb-3fac-6dd63087f6de
# ╟─798507d6-91db-11eb-2e4a-3ba02f12ba65
# ╟─3504168a-91de-11eb-181d-1d580d5dc071
# ╟─4c8d8294-91db-11eb-353d-c3696c615b3d
# ╟─b62c4af8-9232-11eb-2f66-dd27dcb87d20
# ╟─905379ce-91ad-11eb-295d-8354ecf5c5b1
# ╟─5c4f0f26-91ad-11eb-033b-2bd221f0bdba
# ╟─da98b676-91e0-11eb-0d97-57b8a8aadf2a
# ╟─e0b607c0-91e0-11eb-10aa-53ec33570e59
# ╟─fa1635d4-91e3-11eb-31bd-cf61c502ad35
# ╠═f7f9e4c6-91e3-11eb-1a56-8b98f0b09b46
# ╠═0bc813ca-924e-11eb-3032-0bdda2feef9b
# ╠═166f2a0a-924e-11eb-0aca-41f27d038e6d
# ╟─55a7a334-9245-11eb-2114-7d2bc503e133
# ╠═5da7b076-91b4-11eb-3eba-b3f5849efabb
# ╠═654ff3ae-924e-11eb-1671-699a2c07a3ba
# ╟─ea9e77e2-91b1-11eb-185d-cd006db11f60
# ╟─12b4d528-9239-11eb-2824-8ddb5e2ba892
# ╠═2f525796-9239-11eb-1865-9b01eadcf548
# ╟─6bacbbe0-9250-11eb-3494-8151538ef0fd
# ╠═eacd4d3e-9246-11eb-04f4-7dd11f7e6bd5
# ╠═f67634e8-9246-11eb-0fb3-852ba4d2931e
# ╟─84251d00-9250-11eb-177b-d5e2de2af37f
# ╠═3fa5d34e-9247-11eb-26ad-2f7dfafcd08a
# ╠═465e63c2-9247-11eb-0a33-59c50e6a1677
# ╠═169b6f04-9247-11eb-3282-491b39bd47c7
# ╠═3e995fe8-9247-11eb-1411-75bf7ed9148f
# ╟─9388ffdc-9250-11eb-3435-bd1f05d53f93
# ╠═2ba7bc54-9247-11eb-0527-d5ea94b27193
# ╠═3137a1f2-9247-11eb-1138-dfab4b1b31bc
# ╠═c879dd0a-9247-11eb-11c6-a93aa0e7e523
# ╠═0fc47f94-9248-11eb-318c-85400bd20ae7
# ╠═e03bc28c-9247-11eb-141c-2f7e18935d40
# ╠═f932a922-9247-11eb-18c8-af63230649f7
# ╠═f3b21c40-9246-11eb-1873-1bcc82d68e23
# ╠═11962a42-9246-11eb-0f2f-1f702ecb9c4f
# ╠═51abfe6e-9239-11eb-362a-259570250663
# ╟─b847b5ca-9239-11eb-02fe-db4d9625bc5f
# ╟─c2deb090-9239-11eb-0739-a74379c15ce6
# ╟─689f8404-923b-11eb-2c5c-d5a2d80be6b3
# ╟─6c579eec-923b-11eb-32c5-6754b60c2ae8
# ╠═d420d492-91d9-11eb-056d-33cc8f0aed74
# ╠═ad2d4dd8-91d5-11eb-27af-6f0c6e61a86a
# ╠═d0f81f28-91d9-11eb-2e79-61461ef5b132
# ╠═b8f2c508-91d5-11eb-31b5-61810f171270
# ╠═664080a2-9248-11eb-01b5-69fc4aeb90da
# ╠═6fd96dfe-9248-11eb-2389-d788d0f89e3b
# ╠═8825c3e4-9248-11eb-1073-f572e764908a
# ╠═a9b408ea-9248-11eb-2c0c-37167450b91c
# ╠═b00926e4-9248-11eb-110f-91438c826090
# ╠═b664e708-9248-11eb-36a8-a99b23fa2975
# ╠═b9a57a9a-9248-11eb-128b-21f779e564b8
# ╠═c6a38dea-9248-11eb-1784-07153b0febec
# ╠═c8aed310-9248-11eb-2686-7758ae5afb7d
# ╟─be40585c-923b-11eb-0cbc-85599c23ef81
# ╟─c5af5aac-923b-11eb-09f3-a3d4e5b7cfa8
# ╟─d77cf668-923b-11eb-141d-d3d4ee24136d
# ╠═3c3971e2-91da-11eb-384c-01c627318bdc
# ╟─d5744a6e-9249-11eb-1bcd-cdef0cc3d459
# ╠═ff85fb56-9249-11eb-10ec-e9c249e3cf14
# ╟─bacca794-9249-11eb-1ed4-87a6a6baba5b
# ╟─2edea8c2-9249-11eb-03df-a90755310a97
# ╠═3aadaeda-9249-11eb-0683-05fa5f1dc3eb
# ╠═3f0317ce-9249-11eb-0cc2-47f007fefcdf
# ╠═49e05bd4-9249-11eb-35a3-6df516b6ee3a
# ╟─5117fa2e-9249-11eb-2158-4126ddec2c55
# ╠═7f544166-9249-11eb-08ab-c35e8ca632d3
# ╠═a08e6ca0-9249-11eb-3947-3f3a29e29814
# ╠═a9fe6236-9249-11eb-152c-b57af2c002e2
# ╟─fe7fb84a-923b-11eb-0b54-0b3278bb009b
# ╠═cb0ef266-91d5-11eb-314b-0545c0c817d0
# ╠═048fac02-91da-11eb-0d26-4f258b4cd043
# ╟─8c75aeee-9242-11eb-16b2-8fc1c243b794
# ╠═23b84ce2-91da-11eb-01f8-c308ac4d1c7a
# ╠═537f952a-91da-11eb-33cf-6be2fd3bc45c
# ╠═5b972296-91da-11eb-29b1-074f3926181e
# ╠═3ad5a93c-91db-11eb-3227-c96bf8fd2206
# ╠═74182fe0-91da-11eb-219a-01f13b86406d
