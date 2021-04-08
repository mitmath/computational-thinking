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

# ╔═╡ e46441c4-97bd-11eb-330c-97bd5ac41f9e
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
"><em>Section 2.6</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Random Walks II </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/pIAFHyLmwbM" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 85b45a43-d7bf-4597-a1a6-329b41dce20d
begin
    import Pkg
	
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="Plots", version="1"),
    ])
	
    using PlutoUI, Plots, LinearAlgebra, SparseArrays
end

# ╔═╡ 85c26eb4-c258-4a8b-9415-7b5f7ddff02a
TableOfContents(aside=true)

# ╔═╡ 2d48bfc6-9617-11eb-3a85-279bebd21332
md"""
# Julia concepts

- Customised display of objects
- Structured matrices in Julia
- `cumsum`
- Vectors of vectors
- Concatenation of vectors: `hcat`


- `heatmap` (Plots.jl)
- `surface` (Plots.jl)

"""

# ╔═╡ 30162386-039f-4cd7-9121-a3382be3c294
md"""
# Pascal's triangle

"""

# ╔═╡ 4e7b163e-dfd0-457e-b1f3-8807a4d8060a
md"""
Let's start by thinking about Pascal's triangle. (Note that [Pascal was not the first person to study these numbers](https://en.wikipedia.org/wiki/Pascal%27s_triangle).)
"""

# ╔═╡ e8ceab7b-45db-4393-bb8e-e000ecf78d2c
pascal(N) = [binomial(n, k) for n = 0:N, k=0:N]

# ╔═╡ 2d4dffb9-39e4-48de-9688-980b96814c9f
pascal(10)

# ╔═╡ 8ff66523-bc2e-4c53-975b-8ba4f99eb1c6
md"""
The non-zero entries are the **binomial coefficients**: the $k$th entry on the $n$th row is the coefficient of $x^k$ in the expansion $(1 + x)^n$, starting from $n=0$ in the first row and $k=0$ in the first column.
"""

# ╔═╡ 2868dd57-7164-4162-8c5d-30628dedeb7a
md"""
Note that there are 0s above the main diagonal -- in other words the matrix is **lower triangular**.

Julia has special types to represent some classes of structured matrices in the standard library `LinearAlgebra` package:
"""

# ╔═╡ f6009473-d3c1-444f-88ae-814f770e811b
L = LowerTriangular(pascal(10))

# ╔═╡ 9a368602-acd3-43fb-9dff-e407a4bab930
md"""
We see that the display is special: the known "**structural**" zeros are shown as dots, instead of numbers.
"""

# ╔═╡ 67517333-175f-48c4-a915-76658cbf1304
md"""
As we have already seen, Julia also has a sparse matrix type that we could use for this, in the `SparseArrays` standard library:
"""

# ╔═╡ d6832372-d336-4a54-bbcf-d0bb70e4de64
sparse(pascal(10))  

# ╔═╡ 35f14826-f1e4-4977-a31a-0f6148fe25ad
md"""
For fun, let's look at where the entries of Pascal's triangle are odd. We'll make a slider:
"""

# ╔═╡ 7468fc5d-7f35-45e2-b5fc-7e63b562bc8f
@bind n_pascal Slider(1:63, show_value=true, default=1)

# ╔═╡ 1ca8aa3b-b05d-40f6-a925-2f0248b79ca2
sparse(isodd.(pascal(n_pascal)))

# ╔═╡ 38d88b7c-3b4f-430b-8d3c-f672ab0c7a49
md"""
Note that the visual representation of a sparse matrix changes at a particular value of $n$. For larger values of $n$ the **sparsity pattern** is displayed using dots for non-zero values.
"""

# ╔═╡ f4c9b02b-738b-4de1-9e9d-05b1616bee0b
md"""
The pattern is quite striking!
"""

# ╔═╡ d1c47afa-ab7f-4543-a161-e3ceb6f11eb4
md"""
You may be interested to know that there is an alternative way to look at Pascal's triangle:
"""

# ╔═╡ bf78e00f-05d9-4a05-8512-4924ef9e25f7
[binomial(i + j, i) for i = 0:10, j = 0:10]

# ╔═╡ b948830f-ead1-4f36-a237-c998f2f7deb8
md"""
and that in fact this can be produced from the previous version using matrix multiplication!:
"""

# ╔═╡ 15223c51-8d31-4a50-a8ff-1cb7d35de454
pascal(10) * pascal(10)'

# ╔═╡ 0bd45c4a-3286-427a-a927-15869be2ebfe
md"""
## Convolutions build Pascal's triangle!
"""

# ╔═╡ 999fb608-fb1a-46cb-82ca-f3f31fe617e1
pascal(6)

# ╔═╡ 6509e69a-6e50-4816-a98f-67ba437383fb
md"""
Where do those binomial coefficients come from? That's not how we learnt to build Pascal's triangle at school!

We learned to build each number up by *summing two adjacent numbers from the previous row*. In the lower-triangular representation we we sum the number immediately above with the one to the left of it.
"""

# ╔═╡ e58976a9-1784-441e-bb76-3011538b8ad0
md"""
We can think of this as... a **convolution** with the vector $[1, 1]$ ! 
Recall that convolutions like this are used as **image filters**, where we want to apply the same *local* operation everywhere along a vector (i.e. one in which we modify a vector in a neighbourhood).
"""

# ╔═╡ 1efc2b68-9313-424f-9850-eb4496cc8486
md"""
# Random walks: Independent and identically-distributed random variables
"""

# ╔═╡ 6e93ffda-217b-4d46-86b5-534ddc1bae90
md"""
The discussion of Pascal's triangle and convolutions will surprisingly turn up below. For now let's go back to thinking about **random walks**.

Recall that in a random walk, at each tick of a clock we take a step in space, say left or right.

Each spatial step is random, so we can think of each step as being a **random variable** with a certain probability distribution, for example the random variable that takes the value $+1$ with probability $\frac{1}{2}$ and $-1$ also with probability $\frac{1}{2}$.

Often we will think about random walks in which each step is "the same". What do we mean by "the same"? We don't mean that the *outcome* is the same, but rather that each step has the same *probability distribution*, i.e. the same probability of taking each possible value. In other words, each step is given by *copies of the same random variable*. 

Steps are also *independent* of each other (the choice of step direction right now *does not affect* the choice at the next step). Hence the steps form a collection of **independent and identically-distributed random variables**, or IID random variables.
"""

# ╔═╡ 396d2490-3cb9-4f68-8fdf-9209d2010e02
md"""
## Random walks as a cumulative sum
"""

# ╔═╡ dc1c22e8-1c7b-43b7-8421-c2ca708931a5
md"""
Let's call the random variable that describes the $i$th *step* $X_i$. Then the overall position $S_n$ of the random walk at time $n$ is given by

$$S_n = X_1 + \cdots + X_n = \sum_{i=1}^n X_i.$$

(Here we have taken the initial position $S_0$ equal to 0. If the initial position is not zero, then this instead gives the **displacement** $S_n - S_0$ at time $n$.)


Recall that by the sum of two random variables we mean a new random variable whose outcomes are sums of the outcomes, with probabilities given by taking the possible pairs of outcomes giving each new outcome.
"""

# ╔═╡ e7a52b56-322c-4478-a670-dec1013c9bd8
md"""
## Cumulative sum
"""

# ╔═╡ 5f136388-5573-4814-a088-a66278acdbbe
md"""
We previously looked at sums like this. The difference now is that we are interested in the entire **trajectory**, i.e. the sequence $S_1$, $S_2$, $\ldots$, $S_n$, $\ldots$. The trajectory is given by **partial sums**:
"""

# ╔═╡ e440dc3b-bafd-4e0c-9fe8-13fce8eea22d
md"""
$$\begin{align}
S_1 & = X_1 \\
S_2 &= X_1 + X_2 \\
S_3 &= X_1 + X_2 + X_3
\end{align}$$

etc.
"""

# ╔═╡ 89d3e90d-3685-473d-aea4-0b7c5b80d7f7
md"""
Note that $S_{n+1}$ is *not* independent of $S_n$ (or the other $S_m$). E.g. if $S_{100}$ happens to be large, then $S_{101}$ will be about as large.

Thinking about types, as we did a couple of lectures ago, we would need to define a *new* type to represent a random walk, since we cannot generate consecutive values as independent samples.
"""

# ╔═╡ 203eea14-1c68-4a9f-ab18-9a2e5f408a79
md"""
How could we calculate a trajectory of a walk? Suppose we generate steps $X_i$, e.g.
"""

# ╔═╡ b6d4b045-a39f-4236-ace2-9f631e853d1b
steps = rand( (-1, +1), 10 )

# ╔═╡ e61b56be-d334-4c8f-aa8e-887bb27c058c
md"""
The whole trajectory is given by the **cumulative sum** also called "prefix sum" or "scan". Julia has the function `cumsum` to calculate this:
"""

# ╔═╡ 782f0b9a-3793-4abb-826b-9e14d6eae690
cumsum([1, 2, 3, 4])

# ╔═╡ 1764b56a-f297-4a4e-a931-31aa987ec785
md"""
So the trajectory is given by 
"""

# ╔═╡ 8082092b-b6bf-4619-8776-39fdd6c9b7c1
cumsum(steps)

# ╔═╡ 34c0b850-5e95-4eb9-8435-3aae8d124772
plot(cumsum(steps), m=:o, leg=false, size=(500, 300))

# ╔═╡ 4115f7cb-d45f-4cc2-86bf-316c074393f8
md"""
Note that in Julia this is just a convenience function; it will be no more performant than writing the `for` loop yourself (unlike in some other languages, where `for` loops are slow).
"""

# ╔═╡ 6bc2f20d-3d09-425b-a471-44090dc3161e
md"""
# Evolving probability distributions in time
"""

# ╔═╡ 98994cb9-45dc-48aa-b62d-2407f7184bee
md"""
So far we have looked at single trajectories of random walks. We can think of this as the equivalent of sampling using `rand`. 

Suppose that we run many trajectories of a random walk. At a given time $t$ we can ask where all of the walks are by taking a histogram of the $S_t^{(k)}$, where the superscript $^{(k)}$ denotes the $k$th trajectory out of the collection.

Doing so gives us the *probability distribution* of the random variable $S_t$.
Let's call $p_i^t := \mathbb{P}(S_t = i)$ the probability of being at site $i$ at time $t$. Then the probability distribution at time $t$ is given by the collection of all the $p_i^t$; we can group these into a vector $\mathbf{p}^t$.

Now we can ask what happens at the *next* time step $t+1$. Taking histograms again gives the probabilities $p_j^{t+1}$ and the vector $\mathbf{p}^t$ of all of them.

But $\mathbf{p}^{t+1}$ and $\mathbf{p}^{t}$ are related in some way, since we go from $S_t$ to $S_{t+1}$ by just taking a single step. 

Let's think about the case of a simple random walk in one dimension. To arrive at site $i$ at time $t+1$, we must have been in one of the *neighbouring* sites at time $t$ and jumped with probability $\frac{1}{2}$ in the direction of site $i$. Hence we have

$$p_i^{t+1} = \textstyle \frac{1}{2} (p_{i-1}^{t} + p_{i+1}^{t}).$$

This is sometimes called the **master equation** (even though that is rather a useless, non-descriptive name); it describes how the *probability distribution of the random walk evolves in time*.
"""

# ╔═╡ f11f8d7d-cd3f-4585-aab4-083b892c6d4c
md"""
## Implementing time evolution of probabilities

Let's write a function to **evolve** a probability vector to the next time step for a simple random walk:
"""

# ╔═╡ fb804fe2-58be-46c9-9200-ceb8863d052c
function evolve(p)
	p′ = similar(p)   # make a vector of the same length and type
	                  # to store the probability vector at the next time step
	
	for i in 2:length(p)-1   # iterate over the *bulk* of the system
		
		p′[i] = 0.5 * (p[i-1] + p[i+1])

	end
	
	# boundary conditions:
	p′[1] = 0
	p′[end] = 0
	
	return p′
end

# ╔═╡ 40e457b4-616c-4fab-9c8e-2e5063129597
md"""
Wait... Do you recognise this?

This is just a **convolution** again! The kernel is now $[\frac{1}{2}, 0, \frac{1}{2}]$. Apart from the extra $0$ and the $\frac{1}{2}$, this is the *same* as in Pascal's triangle... so probabilities in simple random walk behave like Pascal's triangle!
"""

# ╔═╡ 979c1fbd-c9f6-4e8b-a648-6a0210fc9e7f
md"""
Note that just as with images we have a problem at the edges of the system: We need to specify **boundary conditions** on the first and last cells. For now we have put 0s at the boundary, corresponding to probability *escaping* at the boundary: any probability that arrives at the boundary at a given time step does not stay in the system. We can think of the probability as analogous to a chemical moving through a system that leaves our system (and e.g. moves into the outside world) when it reaches an edge.
"""

# ╔═╡ 583e3a92-01e7-4b88-9be0-f1e3b3c95005
md"""
We also need to specify an *initial* condition $\mathbf{p}_0$. This tells us where our walker is at time $0$. Suppose that all walkers start at site $i=0$. We will place this in the middle of our vector. Then the *probability* of being at $0$ is 1 (certainty), while the probability at any other site is 0 (impossible):
"""

# ╔═╡ 0b26efab-4e93-4d53-9c4d-faea68d12174
function initial_condition(n)
	
	p₀ = zeros(n)
	p₀[n ÷ 2 + 1] = 1
	
	return p₀
end

# ╔═╡ b9ce5af1-84f7-4a2d-92c9-de2c5498a88d
md"""
Now let's evolve the probability vector in time by applying the `evolve` function repeatedly, starting from the initial probability distribution:
"""

# ╔═╡ b48e55b7-4b56-41aa-9796-674d04adf5df
function time_evolution(p0, N)
	ps = [p0]
	p = p0
	
	for i in 1:N
		p = evolve(p)
		push!(ps, copy(p))
	end
	
	return ps
end

# ╔═╡ 53a36c1a-0b8c-4099-8854-08d73c9f118e
md"""
Let's visualise this:
"""

# ╔═╡ 6b298184-32c6-412d-a900-b113d6bd3d53
begin
	grid_size = 101
	
	p0 = initial_condition(grid_size)
end

# ╔═╡ b84a7255-7b0a-4ba1-8c87-9f5d3fa32ef3
ps = time_evolution(p0, 100)

# ╔═╡ c430c4de-d9bf-44e1-aa40-6b823d718b04
md"""
Note that `ps` is a `Vector`, whose elements are each `Vector`s! I.e. we have a vector of vectors. This is often a convenient way to *build up* a matrix.
"""

# ╔═╡ 99717c6e-f713-49d5-8ee5-a08c4a464223
ps[2]

# ╔═╡ 242ea831-c421-4a76-b658-2a57fa924a4f
md"""
t = $(@bind tt Slider(1:length(ps), show_value=true, default=1))
"""

# ╔═╡ aeaef573-1e90-45f3-a7fe-31ec5e2808c4
bar(ps[tt], ylim=(0, 1), leg=false, size=(500, 300), alpha=0.5)

# ╔═╡ efe186da-3273-4767-aafc-fc8eae01dbd9
md"""
### Concatenating vectors into a matrix
"""

# ╔═╡ 61201091-b8b3-4776-9be9-4c23d5ba88ba
md"""
Now we want to visualise this in a different way, for which we must join up (**concatenate**) all the probability vectors into a matrix:
"""

# ╔═╡ 66c4aed3-a04b-4a09-b954-79e816d2a3f7
M = reduce(hcat, ps)'

# ╔═╡ b135f6be-5e82-4c72-af11-0eb0d4141dec
md"""
We can visualise the matrix with a **heat map**:
"""

# ╔═╡ e74e18e3-ad08-4a53-a803-cd53564dca65
heatmap(M, yflip=true)

# ╔═╡ ed02f00f-1bcd-43fa-a56c-7be9968614cc
md"""
We can also visualise this as a 3D surface:
"""

# ╔═╡ 8d453f89-4a4a-42d0-8a00-9b153a3f435e
plotly()

# ╔═╡ f7de29b5-2a51-45e4-a0a5-f7f602681303
surface(M)

# ╔═╡ 7e817bad-dc51-4c29-a4fc-f7a8bb3663ca
md"""
But this is not necessarily very clear, so let's draw it ourselves as stacked histograms:
"""

# ╔═╡ 403d607b-6171-431b-a058-0aad0909846f
gr()

# ╔═╡ 80e033c4-a862-443d-a198-932f5822a44e
ylabels = [-(grid_size÷2):grid_size÷2;]

# ╔═╡ c8c16c14-26b0-4f83-8135-4f862ed90686
begin
	plot(leg=false)
	
	for which in 1:15
		for i in 1:length(ps[which])
			plot!([which, which], [-grid_size÷2 + i, -grid_size÷2 + i], [0, ps[which][i] ], c=which, alpha=0.8, lw = 2)
		end
	end
	
	xlims!(1, 15)
	
	plot!()
end

# ╔═╡ 29612df6-203f-42bc-b53b-86af618d60ec
let
	color_list = [:red, RGB(0, 1, 0.1), :blue]
	xs = []
	ys = []
	zs = []
	cs = []
	cs2 = []
	
	for which in 1:15
		for i in 1:length(ps[which])
			push!(xs, which, which, NaN)
			push!(ys, ylabels[i], ylabels[i], NaN)
			push!(zs, 0, ps[which][i], NaN)
			# push!(zs, 0, 1, NaN)D
			push!(cs, color_list[mod1(which, 3)], color_list[mod1(which, 3)], color_list[mod1(which, 3)])
		end
		push!(cs2, which)
	end
				# plot(xs, ys, zs)
	
	plot(leg=false)
	
	plot!(1:15, [0; cumsum(sign.(randn(14)))], zeros(15), alpha=0.6, m=:o, lw=2, c=color_list)
	plot!(xs, ys, zs, c=cs, xlims=(1, 15), ylims=(-30, 30), zlims=(0, 1), lw=2.5, alpha=0.7, xticks=(1:15), yticks=(-20:10:20))
	
xlabel!("t")
	ylabel!("space")

end

# ╔═╡ Cell order:
# ╟─e46441c4-97bd-11eb-330c-97bd5ac41f9e
# ╠═85b45a43-d7bf-4597-a1a6-329b41dce20d
# ╠═85c26eb4-c258-4a8b-9415-7b5f7ddff02a
# ╟─2d48bfc6-9617-11eb-3a85-279bebd21332
# ╟─30162386-039f-4cd7-9121-a3382be3c294
# ╟─4e7b163e-dfd0-457e-b1f3-8807a4d8060a
# ╠═e8ceab7b-45db-4393-bb8e-e000ecf78d2c
# ╠═2d4dffb9-39e4-48de-9688-980b96814c9f
# ╟─8ff66523-bc2e-4c53-975b-8ba4f99eb1c6
# ╟─2868dd57-7164-4162-8c5d-30628dedeb7a
# ╠═f6009473-d3c1-444f-88ae-814f770e811b
# ╟─9a368602-acd3-43fb-9dff-e407a4bab930
# ╟─67517333-175f-48c4-a915-76658cbf1304
# ╠═d6832372-d336-4a54-bbcf-d0bb70e4de64
# ╟─35f14826-f1e4-4977-a31a-0f6148fe25ad
# ╠═7468fc5d-7f35-45e2-b5fc-7e63b562bc8f
# ╠═1ca8aa3b-b05d-40f6-a925-2f0248b79ca2
# ╟─38d88b7c-3b4f-430b-8d3c-f672ab0c7a49
# ╟─f4c9b02b-738b-4de1-9e9d-05b1616bee0b
# ╟─d1c47afa-ab7f-4543-a161-e3ceb6f11eb4
# ╠═bf78e00f-05d9-4a05-8512-4924ef9e25f7
# ╟─b948830f-ead1-4f36-a237-c998f2f7deb8
# ╠═15223c51-8d31-4a50-a8ff-1cb7d35de454
# ╟─0bd45c4a-3286-427a-a927-15869be2ebfe
# ╠═999fb608-fb1a-46cb-82ca-f3f31fe617e1
# ╟─6509e69a-6e50-4816-a98f-67ba437383fb
# ╟─e58976a9-1784-441e-bb76-3011538b8ad0
# ╟─1efc2b68-9313-424f-9850-eb4496cc8486
# ╟─6e93ffda-217b-4d46-86b5-534ddc1bae90
# ╟─396d2490-3cb9-4f68-8fdf-9209d2010e02
# ╟─dc1c22e8-1c7b-43b7-8421-c2ca708931a5
# ╟─e7a52b56-322c-4478-a670-dec1013c9bd8
# ╟─5f136388-5573-4814-a088-a66278acdbbe
# ╟─e440dc3b-bafd-4e0c-9fe8-13fce8eea22d
# ╟─89d3e90d-3685-473d-aea4-0b7c5b80d7f7
# ╟─203eea14-1c68-4a9f-ab18-9a2e5f408a79
# ╠═b6d4b045-a39f-4236-ace2-9f631e853d1b
# ╟─e61b56be-d334-4c8f-aa8e-887bb27c058c
# ╠═782f0b9a-3793-4abb-826b-9e14d6eae690
# ╟─1764b56a-f297-4a4e-a931-31aa987ec785
# ╠═8082092b-b6bf-4619-8776-39fdd6c9b7c1
# ╠═34c0b850-5e95-4eb9-8435-3aae8d124772
# ╟─4115f7cb-d45f-4cc2-86bf-316c074393f8
# ╟─6bc2f20d-3d09-425b-a471-44090dc3161e
# ╟─98994cb9-45dc-48aa-b62d-2407f7184bee
# ╟─f11f8d7d-cd3f-4585-aab4-083b892c6d4c
# ╠═fb804fe2-58be-46c9-9200-ceb8863d052c
# ╟─40e457b4-616c-4fab-9c8e-2e5063129597
# ╟─979c1fbd-c9f6-4e8b-a648-6a0210fc9e7f
# ╟─583e3a92-01e7-4b88-9be0-f1e3b3c95005
# ╠═0b26efab-4e93-4d53-9c4d-faea68d12174
# ╟─b9ce5af1-84f7-4a2d-92c9-de2c5498a88d
# ╠═b48e55b7-4b56-41aa-9796-674d04adf5df
# ╟─53a36c1a-0b8c-4099-8854-08d73c9f118e
# ╠═6b298184-32c6-412d-a900-b113d6bd3d53
# ╠═b84a7255-7b0a-4ba1-8c87-9f5d3fa32ef3
# ╟─c430c4de-d9bf-44e1-aa40-6b823d718b04
# ╠═99717c6e-f713-49d5-8ee5-a08c4a464223
# ╟─242ea831-c421-4a76-b658-2a57fa924a4f
# ╠═aeaef573-1e90-45f3-a7fe-31ec5e2808c4
# ╟─efe186da-3273-4767-aafc-fc8eae01dbd9
# ╟─61201091-b8b3-4776-9be9-4c23d5ba88ba
# ╠═66c4aed3-a04b-4a09-b954-79e816d2a3f7
# ╟─b135f6be-5e82-4c72-af11-0eb0d4141dec
# ╠═e74e18e3-ad08-4a53-a803-cd53564dca65
# ╟─ed02f00f-1bcd-43fa-a56c-7be9968614cc
# ╠═8d453f89-4a4a-42d0-8a00-9b153a3f435e
# ╠═f7de29b5-2a51-45e4-a0a5-f7f602681303
# ╟─7e817bad-dc51-4c29-a4fc-f7a8bb3663ca
# ╠═403d607b-6171-431b-a058-0aad0909846f
# ╠═80e033c4-a862-443d-a198-932f5822a44e
# ╟─c8c16c14-26b0-4f83-8135-4f862ed90686
# ╠═29612df6-203f-42bc-b53b-86af618d60ec
