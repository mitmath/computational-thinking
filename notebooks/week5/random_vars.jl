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

# ╔═╡ 06d2666a-8723-11eb-1395-0febdf3dc2a4
begin

	import Pkg

	Pkg.activate(mktempdir())

	Pkg.add([

			Pkg.PackageSpec(name="Images", version="0.22.4"), 

			Pkg.PackageSpec(name="ImageMagick", version="0.7"), 

			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 

			Pkg.PackageSpec(name="Plots"), 

			Pkg.PackageSpec(name="Colors"), 
			
			Pkg.PackageSpec(name="StatsBase")


			])



	using Plots, PlutoUI, Colors, Images, StatsBase

end


# ╔═╡ 3a4957ec-8723-11eb-22a0-8b35322596e2
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
height: 400px;
pointer-events: none;
"></div>

<div style="
height: 400px;
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
"><em>Chapter 2.2</em></p>
<p style="text-align: center; font-size: 2rem;">
<em>Random variables</em>
</p>
</div>

<style>
body {
overflow-x: hidden;
}
</style>
"""

# ╔═╡ 0a70bca4-8723-11eb-1bcf-e9abb9b1ab75
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 472a41d2-8724-11eb-31b3-0b81612f0083
md"""
## Useful Julia tidbits 
"""

# ╔═╡ aeb99f72-8725-11eb-2efd-d3e44686be03
md"""
The package that each function comes from is shown in brackets, unless it comes from `Base`.
"""

# ╔═╡ 4f9bd326-8724-11eb-2c9b-db1ac9464f1e
md"""

- `if...else...end`

- `Dict`: Julia's dictionary type



- `rand(S)`: random sampling from a collection `S` 

- `StatsBase.jl`:
  - `countmap`


- `Plots.jl`:

  - `histogram(x)`: Plot a histogram of data vector `x` [Plots]

  - `bar(d)`: Plot a bar graph of categorical data [Plots]


- `Colors.jl`:
  - `distinguishable_colors(n)`: Make `n` distinguishable colours [Colors]

"""

# ╔═╡ db2d25de-86b1-11eb-0c78-d1ee52e019ca
md"""
## Random sampling with `rand`
"""

# ╔═╡ e33fe4c8-86b1-11eb-1031-cf45717a3dc9
md"""
The `rand` function in Julia is quite versatile: it tries to generate, or **sample**, a random object from the argument that you pass in:
"""

# ╔═╡ f49191a2-86b1-11eb-3eab-b392ba058415
rand(1:6)

# ╔═╡ 1abda6c4-86b2-11eb-2aa3-4d1148bb52b7
rand([2, 3, 5, 7, 11])

# ╔═╡ 30b12f28-86b2-11eb-087b-8d50ec429b89
rand("MIT")

# ╔═╡ 4ce946c6-86b2-11eb-1820-0728798665ab
rand('a':'z')

# ╔═╡ 6cdea3ae-86b2-11eb-107a-17bea3f54bc9
rand()   # random number between 0 and 1

# ╔═╡ 776ec3f2-86b3-11eb-0216-9b71d07e99f3
md"""
We can take random objects from a collection of objects of *any* type, for example:
"""

# ╔═╡ 0926366a-86b2-11eb-0f6d-31ae6981598c
rand(distinguishable_colors(3))   # from Colors.jl package

# ╔═╡ 7c8d7b72-86b2-11eb-2dd5-4f77bc5fb8ff
md"""
### Several random objects
"""

# ╔═╡ 2090b7f2-86b3-11eb-2a99-ed98800e1d63
md"""
To sample several random objects from the same collection, we could write an array comprehension:
"""

# ╔═╡ a7dff55c-86b2-11eb-330f-3d6279347095
[rand(1:6) for i in 1:10]

# ╔═╡ 2db33022-86b3-11eb-17dd-13c534ac9892
md"""
But in fact, just adding another argument to `rand` does the trick:
"""

# ╔═╡ 0de6f23e-86b2-11eb-39ff-318bbc4ecbcf
rand(1:6, 10)

# ╔═╡ 36c3da4a-86b3-11eb-0b2f-fffdde06fcd2
md"""
In fact, you can also generate not only random vectors, but also random matrices:
"""

# ╔═╡ 940c2bf6-86b2-11eb-0a5e-011abdd6352b
rand(1:6, 10, 10)

# ╔═╡ 5a4e7fc4-86b3-11eb-3376-0941b79574aa
rand(distinguishable_colors(5), 10, 10)

# ╔═╡ c433104e-86b3-11eb-20bb-af608bb281cc
md"""
We can also use random images:
"""

# ╔═╡ 78dc94e2-8723-11eb-1ff2-bb7104b62033
penny_image = load(download("https://www.usacoinbook.com/us-coins/lincoln-memorial-cent.jpg"));

# ╔═╡ bb1465c4-8723-11eb-1abc-bdb5a7028cf2
begin
	head = penny_image[:, 1:end÷2]
	tail = penny_image[:, end÷2:end]
end;

# ╔═╡ e04f3828-8723-11eb-3452-09f821391ad0
rand([head, tail], 5, 5)

# ╔═╡ b7793f7a-8726-11eb-11d8-cd928f1a3645
md"""
## Uniform sampling
"""

# ╔═╡ ba80cc78-8726-11eb-2f33-e364f19295d8
md"""
So far, each use of `rand` has done **uniform sampling**, i.e. each possible object as the *same* probability.

Let's *count* heads and tails using the `countmap` function from the `StatsBase.jl` package:
"""

# ╔═╡ 8fe715e4-8727-11eb-2e7f-15b723bb8d9d
tosses = rand(["head", "tail"], 10)

# ╔═╡ 9da4e6f4-8727-11eb-08cb-d55e3bbff0e4
toss_counts = countmap(tosses)

# ╔═╡ c3255d7a-8727-11eb-0421-d99faf27c7b0
md"""

We see that `countmap` returns a **dictionary** (`Dict`), which maps **keys** to **values**; we will say more about dictionaries in another chapter.
"""

# ╔═╡ e2037806-8727-11eb-3c36-1500f1dd545b
prob_tail = toss_counts["tail"] / length(tosses)

# ╔═╡ 28ff621c-8728-11eb-2ec0-2579cb313315
md"""
As we increase the number of tosses, we "expect" the probability to get closer to $1/2$.
"""

# ╔═╡ 57125768-8728-11eb-3c3b-1dd37e1ac189
md"""
## Tossing a weighted coin
"""

# ╔═╡ 6a439c78-8728-11eb-1969-27a19d254704
md"""
How could we model a coin that is **weighted**, so that it is more likely to come up heads? We want to assign a probability $p = 0.7$ to heads, and $q = 0.3$ to tails.
"""

# ╔═╡ 9f8ac08c-8728-11eb-10ad-f93ca225ce38
md"""
One way would be to generate random integers between 1 and 10 and assign heads to a subset of the possible results with the desired probability, e.g. 1:7 get heads, and 8:10 get tails:
"""

# ╔═╡ 062b400a-8729-11eb-16c5-235cef648edb
function simple_weighted_coin()
	if rand(1:10) ≤ 7
		"heads"
	else
		"tails"
	end
end

# ╔═╡ 2a81ba88-8729-11eb-3dcb-1db26e468066
md"""
(Note that `if` statements have a return value in Julia.)
"""

# ╔═╡ 5ea5838a-8729-11eb-1749-030533fb0656
md"""
How could we generalise this to an arbitrary probability $p ∈ [0, 1]$?

We can generate a uniform floating-point number between 0 and 1, and check if it is less than $p$. This is called a **Bernoulli trial**.
"""

# ╔═╡ 806e6aae-8729-11eb-19ea-33722c60edf0
rand() < 0.7

# ╔═╡ 90642564-8729-11eb-3cd7-b3d41a1553b4
md"""
Note that comparisons also return a value in Julia. Here we have switched from heads/tails to true/false as the output.
"""

# ╔═╡ 9a426a20-8729-11eb-0c0f-31e1d4dc91bc
md"""
Let's make that into a function:
"""

# ╔═╡ a4870b14-8729-11eb-20ee-e531d4a7108d
bernoulli(p) = rand() < p

# ╔═╡ 008a40d2-872a-11eb-224d-5b3331f29c99
md"""
p = $(@bind p Slider(0.0:0.01:1.0, show_value=true, default=0.7))
"""

# ╔═╡ baed5908-8729-11eb-00e0-9f749406c30c
countmap( [bernoulli(p) for i in 1:1000] )

# ╔═╡ e667ffc6-8729-11eb-3db5-5f999a0d88a7


# ╔═╡ ed94eae8-86b3-11eb-3f1b-15c7a54903f5
md"""
## Histograms
"""

# ╔═╡ f20504de-86b3-11eb-3125-3140e0e060b0
md"""
Once we have generated several random objects, it is natural to want to count **how many times** each one occurred.
"""

# ╔═╡ 7f1a3766-86b4-11eb-353f-b13acaf1503e
md"""
Let's roll a die 1000 times:
"""

# ╔═╡ 02d03642-86b4-11eb-365a-63ff61ddd3b5
rolls = rand(0:5, 1000)

# ╔═╡ 36bd8cb2-86b6-11eb-35da-85cd489f335c
begin
	labels = ["alan", "david"]
	names = rand(labels, 100)
end

# ╔═╡ 654519a8-86b6-11eb-0747-3b96e1ab3c2f


# ╔═╡ 371838f8-86b4-11eb-1633-8d282e42a085
md"""
An obvious way to find the counts would be to run through the data looking for 1s, then run through again looking for 2s, etc.:
"""

# ╔═╡ 2405eb68-86b4-11eb-31b0-dff8e355d88e
counts = [count(rolls .== i) for i in 0:5]

# ╔═╡ 9e9d3556-86b5-11eb-3dfb-916e625da235
md"""
Note that this is *not* the most efficient algorithm!
"""

# ╔═╡ 2d71fa88-86b5-11eb-0e55-35566c2246d7
bar(0:5, counts, alpha=0.5, leg=false)

# ╔═╡ 46f68072-86b6-11eb-070f-e3ff32fcd0d4
bar(countmap(names))

# ╔═╡ 7ca4fee2-86b6-11eb-2869-27bc861a9703
countmap(names)

# ╔═╡ 757e6290-86b4-11eb-0bf8-4ffaa324ef57
histogram(rolls, leg=false, alpha=0.5, bar_edges=true, bins=0.5:6.5, bar_width=0.5)

# ╔═╡ 5ca782b4-86b5-11eb-23d1-c53c0cc023a4


# ╔═╡ cb8a9762-86b1-11eb-0484-6b6cc8b1b14c
md"""
## Rolling a die
"""

# ╔═╡ d0c9814e-86b1-11eb-2f29-1d041bccc649
die() = rand(1:6)

# ╔═╡ d985491e-86b6-11eb-348a-d3414cda8732
# experiment(generator, n) = sum(generator() for i in 1:n)

# ╔═╡ 7a16b674-86b7-11eb-3aa5-83712cdc8580
trials = 1000

# ╔═╡ 6c133ab6-86b7-11eb-15f6-7780da5afc31
md"""
n = $(@bind n Slider(1:10, show_value=true))
"""

# ╔═╡ d5a09650-86b1-11eb-32eb-217468e35939
# experiment() = sum([die() for i in 1:n])
experiment() = sum([randn()^2 for i in 1:n])

# ╔═╡ e8e811de-86b6-11eb-1cbf-6d4aeaee510a
data = [experiment() for t in 1:trials]

# ╔═╡ 426a1ff4-86b7-11eb-2d83-8900263aed09
# bar(countmap(data), bar_width=0.5, alpha=0.5, leg=false)

# ╔═╡ e4abcbf4-86b8-11eb-167a-d97c61e07837
data

# ╔═╡ 514f6be0-86b8-11eb-30c9-d1020f783afe
begin
	d = countmap(data)
	
	ks = keys(d)
	vs = values(d)
end

# ╔═╡ 6f6f3a1a-86b8-11eb-3173-d1eec5945c9e


# ╔═╡ 5a5849a4-86b9-11eb-0e1e-1f20d42486d5
30 * 0.14 * 0.5

# ╔═╡ 4744ac8c-86b8-11eb-2b1d-dfa2ab767cf0
histogram(data, alpha=0.5, leg=false, norm=true, bins=9.5:60.5, c=:green)

# ╔═╡ 900af0c8-86ba-11eb-2270-71b1869b9a1a
md"""
Note that `linetype=:stephist` will give a stepped version of the histogram:
"""

# ╔═╡ 975c0592-86ba-11eb-2eeb-c13cde26ed39
histogram(data, alpha=0.5, leg=false, norm=true, bins=9.5:60.5, c=:green, linetype=:stephist)

# ╔═╡ 6187ef50-86b8-11eb-1c27-8f7316bf909f
Dict(k => (v / sum(values(d))) for (k, v) in d)

# ╔═╡ 7de7128e-86b8-11eb-09a0-e3dae7a55503
bar(Dict(ks .=> (vs ./ sum(vs))), bar_width=0.5)

# ╔═╡ 93993648-86b8-11eb-1013-5f21990e821a
plot!(x -> exp(-x^2 / 2) / √(2π))

# ╔═╡ a9b32188-86b7-11eb-022f-6d227e38a823
ks

# ╔═╡ eb2d311e-86ba-11eb-3dc6-ad6fc2580499
sample([1, 2], Weights([0.75, 0.25]))

# ╔═╡ Cell order:
# ╟─3a4957ec-8723-11eb-22a0-8b35322596e2
# ╟─06d2666a-8723-11eb-1395-0febdf3dc2a4
# ╟─0a70bca4-8723-11eb-1bcf-e9abb9b1ab75
# ╟─472a41d2-8724-11eb-31b3-0b81612f0083
# ╟─aeb99f72-8725-11eb-2efd-d3e44686be03
# ╟─4f9bd326-8724-11eb-2c9b-db1ac9464f1e
# ╟─db2d25de-86b1-11eb-0c78-d1ee52e019ca
# ╟─e33fe4c8-86b1-11eb-1031-cf45717a3dc9
# ╠═f49191a2-86b1-11eb-3eab-b392ba058415
# ╠═1abda6c4-86b2-11eb-2aa3-4d1148bb52b7
# ╠═30b12f28-86b2-11eb-087b-8d50ec429b89
# ╠═4ce946c6-86b2-11eb-1820-0728798665ab
# ╠═6cdea3ae-86b2-11eb-107a-17bea3f54bc9
# ╟─776ec3f2-86b3-11eb-0216-9b71d07e99f3
# ╠═0926366a-86b2-11eb-0f6d-31ae6981598c
# ╟─7c8d7b72-86b2-11eb-2dd5-4f77bc5fb8ff
# ╟─2090b7f2-86b3-11eb-2a99-ed98800e1d63
# ╠═a7dff55c-86b2-11eb-330f-3d6279347095
# ╟─2db33022-86b3-11eb-17dd-13c534ac9892
# ╠═0de6f23e-86b2-11eb-39ff-318bbc4ecbcf
# ╟─36c3da4a-86b3-11eb-0b2f-fffdde06fcd2
# ╠═940c2bf6-86b2-11eb-0a5e-011abdd6352b
# ╠═5a4e7fc4-86b3-11eb-3376-0941b79574aa
# ╟─c433104e-86b3-11eb-20bb-af608bb281cc
# ╠═78dc94e2-8723-11eb-1ff2-bb7104b62033
# ╠═bb1465c4-8723-11eb-1abc-bdb5a7028cf2
# ╠═e04f3828-8723-11eb-3452-09f821391ad0
# ╟─b7793f7a-8726-11eb-11d8-cd928f1a3645
# ╟─ba80cc78-8726-11eb-2f33-e364f19295d8
# ╠═8fe715e4-8727-11eb-2e7f-15b723bb8d9d
# ╠═9da4e6f4-8727-11eb-08cb-d55e3bbff0e4
# ╟─c3255d7a-8727-11eb-0421-d99faf27c7b0
# ╠═e2037806-8727-11eb-3c36-1500f1dd545b
# ╟─28ff621c-8728-11eb-2ec0-2579cb313315
# ╟─57125768-8728-11eb-3c3b-1dd37e1ac189
# ╟─6a439c78-8728-11eb-1969-27a19d254704
# ╟─9f8ac08c-8728-11eb-10ad-f93ca225ce38
# ╠═062b400a-8729-11eb-16c5-235cef648edb
# ╟─2a81ba88-8729-11eb-3dcb-1db26e468066
# ╟─5ea5838a-8729-11eb-1749-030533fb0656
# ╠═806e6aae-8729-11eb-19ea-33722c60edf0
# ╟─90642564-8729-11eb-3cd7-b3d41a1553b4
# ╟─9a426a20-8729-11eb-0c0f-31e1d4dc91bc
# ╠═a4870b14-8729-11eb-20ee-e531d4a7108d
# ╟─008a40d2-872a-11eb-224d-5b3331f29c99
# ╠═baed5908-8729-11eb-00e0-9f749406c30c
# ╟─e667ffc6-8729-11eb-3db5-5f999a0d88a7
# ╟─ed94eae8-86b3-11eb-3f1b-15c7a54903f5
# ╟─f20504de-86b3-11eb-3125-3140e0e060b0
# ╟─7f1a3766-86b4-11eb-353f-b13acaf1503e
# ╠═02d03642-86b4-11eb-365a-63ff61ddd3b5
# ╠═36bd8cb2-86b6-11eb-35da-85cd489f335c
# ╟─654519a8-86b6-11eb-0747-3b96e1ab3c2f
# ╟─371838f8-86b4-11eb-1633-8d282e42a085
# ╠═2405eb68-86b4-11eb-31b0-dff8e355d88e
# ╟─9e9d3556-86b5-11eb-3dfb-916e625da235
# ╠═2d71fa88-86b5-11eb-0e55-35566c2246d7
# ╠═46f68072-86b6-11eb-070f-e3ff32fcd0d4
# ╠═7ca4fee2-86b6-11eb-2869-27bc861a9703
# ╠═757e6290-86b4-11eb-0bf8-4ffaa324ef57
# ╟─5ca782b4-86b5-11eb-23d1-c53c0cc023a4
# ╟─cb8a9762-86b1-11eb-0484-6b6cc8b1b14c
# ╠═d0c9814e-86b1-11eb-2f29-1d041bccc649
# ╠═d5a09650-86b1-11eb-32eb-217468e35939
# ╠═d985491e-86b6-11eb-348a-d3414cda8732
# ╠═7a16b674-86b7-11eb-3aa5-83712cdc8580
# ╠═e8e811de-86b6-11eb-1cbf-6d4aeaee510a
# ╟─6c133ab6-86b7-11eb-15f6-7780da5afc31
# ╠═426a1ff4-86b7-11eb-2d83-8900263aed09
# ╠═e4abcbf4-86b8-11eb-167a-d97c61e07837
# ╠═514f6be0-86b8-11eb-30c9-d1020f783afe
# ╟─6f6f3a1a-86b8-11eb-3173-d1eec5945c9e
# ╠═5a5849a4-86b9-11eb-0e1e-1f20d42486d5
# ╠═4744ac8c-86b8-11eb-2b1d-dfa2ab767cf0
# ╟─900af0c8-86ba-11eb-2270-71b1869b9a1a
# ╠═975c0592-86ba-11eb-2eeb-c13cde26ed39
# ╠═6187ef50-86b8-11eb-1c27-8f7316bf909f
# ╠═7de7128e-86b8-11eb-09a0-e3dae7a55503
# ╠═93993648-86b8-11eb-1013-5f21990e821a
# ╠═a9b32188-86b7-11eb-022f-6d227e38a823
# ╠═eb2d311e-86ba-11eb-3dc6-ad6fc2580499
