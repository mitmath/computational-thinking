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
end

# ╔═╡ 5da7b076-91b4-11eb-3eba-b3f5849efabb
with_terminal() do
	@btime step1()
	@btime step2()
	@btime step3()
	@btime step4()
end

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
	x = 0
	xs = [x]
	
	for i in 1:N
		x += step1()
		push!(xs, x)
	end
	
	return xs
end

# ╔═╡ 51abfe6e-9239-11eb-362a-259570250663
begin
	plot()
	
	for i in 1:10
		plot!(walk1D(100), leg=false, size=(500, 300), lw=2, alpha=0.5)
	end
	
	plot!()
end

# ╔═╡ b847b5ca-9239-11eb-02fe-db4d9625bc5f
md"""
# Making it more general: Random walks using types
"""

# ╔═╡ c2deb090-9239-11eb-0739-a74379c15ce6
md"""
Now suppose we want to think about more general random walks, for example moving around in 2D. Then we need to *generalise* the above function.
		
Based on our experience from last time, you should suspect that a good way to do this is with *types*. We will define 
"""

# ╔═╡ d420d492-91d9-11eb-056d-33cc8f0aed74
abstract type Walker end

# ╔═╡ ad2d4dd8-91d5-11eb-27af-6f0c6e61a86a
struct Walker1D <: Walker
	pos::Int
end

# ╔═╡ d0f81f28-91d9-11eb-2e79-61461ef5b132
position(w::Walker) = w.pos

# ╔═╡ b8f2c508-91d5-11eb-31b5-61810f171270
step(w::Walker1D) = rand( (-1, +1) )

# ╔═╡ 3c3971e2-91da-11eb-384c-01c627318bdc
update(w::W, step) where {W <: Walker} = W(position(w) + step)

# ╔═╡ cb0ef266-91d5-11eb-314b-0545c0c817d0
function trajectory(w::W, N) where {W}   # W is a type parameter
	ws = [position(w)]

	for i in 1:N
		pos = position(w)
		w = update(w, step(w))
		
		push!(ws, position(w))
	end
	
	return ws
end

# ╔═╡ 048fac02-91da-11eb-0d26-4f258b4cd043
trajectory(Walker1D(0), 10)

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
traj = trajectory(Walker2D(0, 0), 10^N)

# ╔═╡ 57972a32-91e5-11eb-1d62-fbc22c494db9
md"""
## Random walks as sum of random variables
"""

# ╔═╡ 63122dd0-91e5-11eb-34c3-b1b5c87809b8
md"""
We can connect up with the discussion from last lecture about the sum of random variables: The position $S_n$ of a random walk at time $n$ is a random variable that is the sum of $n$ random variables (which are often independent and id

$$S_n = X_1 + \cdots + X_n$$

where $X_i$ is the random variable modelling the $i$th step of the walk.

Often each $X_i$ will be independent random variables of the same type, in which case we talk about an **independent and identically distributed** (IID) collection.

In principle we could use the method from last lecture to model this, but there is a difficulty since we are interested in all intermediate steps: The values $S_{n-1}$ and $S_n$, for example, are *not* independent (even though the $X_i$ are). For example, if $S_{n-1}$ is large, then $S_n$ is also about as large, so they are highly correlated.
"""

# ╔═╡ bd013582-91e7-11eb-2d79-e18e45f6d639
md"""
## Cumulative sum
"""

# ╔═╡ c092ab72-91e7-11eb-2bd1-13c8c8bb30e4
md"""
Suppose we generate steps $X_i$, e.g.
"""

# ╔═╡ cfb0f9ba-91e7-11eb-26b5-5f0f59d03cff
steps = rand( (-1, +1), 10 )

# ╔═╡ d6edb326-91e7-11eb-03b1-d93e3bc83ca6
md"""
The trajectory, or sample path, of the random walk, is the collection of positions over time. These are the **partial sums**

$$\begin{align}
S_1 & = X_1 \\
S_2 &= X_1 + X_2 \\
S_3 &= X_1 + X_2 + X_3
\end{align}$$

etc.
"""

# ╔═╡ 4ef42cec-91e8-11eb-2976-0950ffe5de6c
md"""
We can calculate all of these values using the `cumsum` ("cumulative sum", also called "prefix sum" or "scan") function:
"""

# ╔═╡ ace8658e-91e8-11eb-0b9d-4b759635e417
cumsum(steps)

# ╔═╡ b049ff58-91e8-11eb-203b-4f4b5ee5f01f
md"""
Let's plot this:
"""

# ╔═╡ b6775d3a-91e8-11eb-0187-618cb538d142
plot(cumsum(steps), m=:o, leg=false, size=(500, 300))

# ╔═╡ 8b1441b6-91e4-11eb-16b2-d7eadd3fd69c
md"""
# Trajectories vs evolving probability distributions
"""

# ╔═╡ d1315f94-91e4-11eb-1076-81156e24d2f1
md"""
So far we have looked at single trajectories of random walks. We can think of this as the equivalent of sampling using `rand`. Suppose that we were to (conceptually) run millions or billions of trajectories of our random walk. At each *time* step, we can ask for the probability distribution in *space*, averaged over all those walks. 
Note that we now have *two* variables. We could do this by literally running many walks and computing histograms. Instead we can look at how probabilities move around.

Let's call $p_i^t$ the probability of being at site $i$ at time $t$. We can then ask what the probability of being at site $i$ at time $t+1$. It must have been in one of the neighbouring sites at time $t$, so

$$p_i^{t+1} = \textstyle \frac{1}{2} (p_{i-1}^{t} + p_{i+1}^{t}).$$

This is sometimes called the **master equation** (even though that is rather a useless, non-descriptive name). It describes how the probability distribution 
"""

# ╔═╡ 97c958c2-91eb-11eb-17cb-410acc7f3e49
md"""
At time $t$ we have a whole probability distribution, which we can think of as a vector $\mathbf{p}^t$.

Let's write a function to **evolve** the vector to the next time step.
"""

# ╔═╡ b7a98dba-91eb-11eb-3c78-074aa835b5fb
function evolve(p)
	p′ = similar(p)   # make a vector of the same length and type
	                  # to store the probability vector at the next time step
	
	for i in 2:length(p)-1
		p′[i] = 0.5 * (p[i-1] + p[i+1])
	end
	
	p′[1] = 0
	p′[end] = 0
	
	return p′
	
end

# ╔═╡ f7f17c0c-91eb-11eb-3fa5-3bd90bb7044e
md"""
Wait... Do you recognise this?

We have seen this before! This is just a **convolution**, like the blurring kernel from image processing (except that in our particular model `p[i]` itself does not contribute to the value of `new_p[i]`.)
"""

# ╔═╡ f0aed302-91eb-11eb-13fb-d9418ef327a8
md"""
Note that just as we did with images, we have a problem at the edges of the system. We need to specify **boundary conditions**. For now we have put 0s at the boundary. This corresponds to probability *escaping* at the boundary: any probability that arrives at the boundary (i.e. the first or last cell) at a given time step does not stay in the system. We can think of the probability as analogous to a chemical that disappears 
"""

# ╔═╡ c1062e00-922b-11eb-1f31-ddbd03f8f986
md"""
We also need to specify an *initial* condition $\mathbf{p}_0$. This tells us where our walker is at time $0$. Suppose that all walkers start at $0$. We will place this in the middle of our vector. Then the probability at that location is 1, while the probability elsewhere is 0:
"""

# ╔═╡ 547188ea-9233-11eb-1a89-5ff9468b31f7
function initial_condition(n)
	
	p0 = zeros(n)
	p0[n ÷ 2 + 1] = 1
	
	return p0
end

# ╔═╡ 2920abfe-91ec-11eb-19bc-935fa1ba0a96
md"""
Now let's try and visualise the time evolution.
"""

# ╔═╡ 3fadf88c-9236-11eb-19fa-d191ac5a6191
function time_evolution(p0, N)
	ps = [p0]
	p = p0
	
	for i in 1:N
		p = evolve(p)
		push!(ps, copy(p))
	end
	
	return ps
end

# ╔═╡ 58653a70-9236-11eb-3dae-47adc2a77cb4
p0 = initial_condition(101)

# ╔═╡ 5d02f21e-9236-11eb-26ea-6593aa80a2eb
ps = time_evolution(p0, 100)

# ╔═╡ 863caf0a-9236-11eb-1013-ab7d83f3fc0c
ps[2]

# ╔═╡ b803406e-9236-11eb-3aad-056b7f2c9b4b
md"""
t = $(@bind tt Slider(1:length(ps), show_value=true, default=1))
"""

# ╔═╡ cc7aaeea-9236-11eb-3fad-2b5ad3962ec1
plot(ps[tt], ylim=(0, 1), leg=false, size=(500, 300))

# ╔═╡ dabb5766-9236-11eb-3be9-9b33ba5af68a
ps[t

# ╔═╡ 6cde6ef4-9236-11eb-219a-4d20adaf9988
M = reduce(hcat, ps)'

# ╔═╡ 7e8c1a2a-9236-11eb-20e9-57f6601f5472
heatmap(M, yflip=true)

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
# ╠═5da7b076-91b4-11eb-3eba-b3f5849efabb
# ╟─ea9e77e2-91b1-11eb-185d-cd006db11f60
# ╟─12b4d528-9239-11eb-2824-8ddb5e2ba892
# ╠═2f525796-9239-11eb-1865-9b01eadcf548
# ╠═51abfe6e-9239-11eb-362a-259570250663
# ╟─b847b5ca-9239-11eb-02fe-db4d9625bc5f
# ╠═c2deb090-9239-11eb-0739-a74379c15ce6
# ╠═d420d492-91d9-11eb-056d-33cc8f0aed74
# ╠═ad2d4dd8-91d5-11eb-27af-6f0c6e61a86a
# ╠═d0f81f28-91d9-11eb-2e79-61461ef5b132
# ╠═b8f2c508-91d5-11eb-31b5-61810f171270
# ╠═3c3971e2-91da-11eb-384c-01c627318bdc
# ╠═cb0ef266-91d5-11eb-314b-0545c0c817d0
# ╠═048fac02-91da-11eb-0d26-4f258b4cd043
# ╠═23b84ce2-91da-11eb-01f8-c308ac4d1c7a
# ╠═537f952a-91da-11eb-33cf-6be2fd3bc45c
# ╠═5b972296-91da-11eb-29b1-074f3926181e
# ╠═3ad5a93c-91db-11eb-3227-c96bf8fd2206
# ╠═74182fe0-91da-11eb-219a-01f13b86406d
# ╟─57972a32-91e5-11eb-1d62-fbc22c494db9
# ╟─63122dd0-91e5-11eb-34c3-b1b5c87809b8
# ╟─bd013582-91e7-11eb-2d79-e18e45f6d639
# ╟─c092ab72-91e7-11eb-2bd1-13c8c8bb30e4
# ╠═cfb0f9ba-91e7-11eb-26b5-5f0f59d03cff
# ╟─d6edb326-91e7-11eb-03b1-d93e3bc83ca6
# ╟─4ef42cec-91e8-11eb-2976-0950ffe5de6c
# ╠═ace8658e-91e8-11eb-0b9d-4b759635e417
# ╟─b049ff58-91e8-11eb-203b-4f4b5ee5f01f
# ╠═b6775d3a-91e8-11eb-0187-618cb538d142
# ╟─8b1441b6-91e4-11eb-16b2-d7eadd3fd69c
# ╟─d1315f94-91e4-11eb-1076-81156e24d2f1
# ╟─97c958c2-91eb-11eb-17cb-410acc7f3e49
# ╠═b7a98dba-91eb-11eb-3c78-074aa835b5fb
# ╟─f7f17c0c-91eb-11eb-3fa5-3bd90bb7044e
# ╟─f0aed302-91eb-11eb-13fb-d9418ef327a8
# ╟─c1062e00-922b-11eb-1f31-ddbd03f8f986
# ╠═547188ea-9233-11eb-1a89-5ff9468b31f7
# ╟─2920abfe-91ec-11eb-19bc-935fa1ba0a96
# ╠═3fadf88c-9236-11eb-19fa-d191ac5a6191
# ╠═58653a70-9236-11eb-3dae-47adc2a77cb4
# ╠═5d02f21e-9236-11eb-26ea-6593aa80a2eb
# ╠═863caf0a-9236-11eb-1013-ab7d83f3fc0c
# ╟─b803406e-9236-11eb-3aad-056b7f2c9b4b
# ╠═cc7aaeea-9236-11eb-3fad-2b5ad3962ec1
# ╠═dabb5766-9236-11eb-3be9-9b33ba5af68a
# ╠═6cde6ef4-9236-11eb-219a-4d20adaf9988
# ╠═7e8c1a2a-9236-11eb-20e9-57f6601f5472
