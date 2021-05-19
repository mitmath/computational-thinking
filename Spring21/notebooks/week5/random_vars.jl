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
"><em>Section 2.2</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Sampling and Random Variables </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/7HrpoFZzITI" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

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
			
			Pkg.PackageSpec(name="StatsBase"), 
			
			
			Pkg.PackageSpec(name="Distributions") 

			])



	using Plots, PlutoUI, Colors, Images, StatsBase, Distributions
	using Statistics
	
end


# ╔═╡ 0a70bca4-8723-11eb-1bcf-e9abb9b1ab75
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 472a41d2-8724-11eb-31b3-0b81612f0083
md"""
## Julia: Useful tidbits 
"""

# ╔═╡ aeb99f72-8725-11eb-2efd-d3e44686be03
md"""
The package that each function comes from is shown in brackets, unless it comes from `Base`.
"""

# ╔═╡ 4f9bd326-8724-11eb-2c9b-db1ac9464f1e
md"""

- Julia `Base` library (no `using` required):

  - `if...else...end`
  - `Dict`: Julia's dictionary type
  - `÷` or `div`:  integer division (type `\div` + <tab>)

  - `sum(S)`: sum of elements in the collection `S`, e.g. an array
  - `count(S)`: count the number of true elements of a Boolean collection

  - `rand(S)`: random sampling from a collection `S` 


- `Statistics.jl` (pre-loaded standard library; just needs `using`)

  - `mean(S)`: calculate the mean of a collection `S`
  - `std(S)`:  calculate the standard deviation of a collection `S`



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

# ╔═╡ fae3d138-8743-11eb-1014-b3a2a9b49aba
typeof('a':'z')

# ╔═╡ 6cdea3ae-86b2-11eb-107a-17bea3f54bc9
rand()   # random number between 0 and 1

# ╔═╡ 1c769d58-8744-11eb-3bd3-ab11ea1503ed
rand

# ╔═╡ 297fdfa0-8744-11eb-1934-9fe31e8be534
methods(rand);

# ╔═╡ 776ec3f2-86b3-11eb-0216-9b71d07e99f3
md"""
We can take random objects from a collection of objects of *any* type, for example:
"""

# ╔═╡ 5fcf8d4e-8744-11eb-080e-cba749004b08
distinguishable_colors(10)

# ╔═╡ 4898106a-8744-11eb-128a-35fec741e6b8
typeof(distinguishable_colors(10))

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
rand(1:6, 10, 12)

# ╔═╡ 5a4e7fc4-86b3-11eb-3376-0941b79574aa
rand(distinguishable_colors(5), 10, 10)

# ╔═╡ c433104e-86b3-11eb-20bb-af608bb281cc
md"""
We can also use random images:
"""

# ╔═╡ 78dc94e2-8723-11eb-1ff2-bb7104b62033
penny_image = load(download("https://www.usacoinbook.com/us-coins/lincoln-memorial-cent.jpg"))

# ╔═╡ bb1465c4-8723-11eb-1abc-bdb5a7028cf2
begin
	head = penny_image[:, 1:end÷2]
	tail = penny_image[:, end÷2:end]
end;

# ╔═╡ e04f3828-8723-11eb-3452-09f821391ad0
rand( [head, tail], 5, 5)

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
tosses = rand( ["head", "tail"], 10000)

# ╔═╡ 9da4e6f4-8727-11eb-08cb-d55e3bbff0e4
toss_counts = countmap(tosses)

# ╔═╡ 9647840c-8745-11eb-33fc-898ae351ddfe
"tail" => 3

# ╔═╡ 9d782aa6-8745-11eb-034e-0f8b01be987b
typeof("tail" => 3)

# ╔═╡ a693582c-8745-11eb-261b-ef79e503420e
toss_counts["tail"]

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
	outcome = if rand(1:10) ≤ 7
		"heads"
	else      # could have elseif
		"tails"
	end
	
	return outcome
end

# ╔═╡ 7c099606-8746-11eb-37fe-c3befde06e9d
function simple_weighted_coin2()
	if rand(1:10) ≤ 7
		"heads"
	else      # could have elseif
		"tails"
	end
end

# ╔═╡ 97cb3dde-8746-11eb-0b00-690f20cb26dc
result = for i in 1:10
	
end

# ╔═╡ 9d8cdc8e-8746-11eb-2b9a-b30a52026f09
result == nothing

# ╔═╡ 81a30c9e-8746-11eb-38c8-9be4f6ba2e80
simple_weighted_coin2()

# ╔═╡ 2a81ba88-8729-11eb-3dcb-1db26e468066
md"""
(Note that `if` statements have a return value in Julia.)
"""

# ╔═╡ 5ea5838a-8729-11eb-1749-030533fb0656
md"""
How could we generalise this to an arbitrary probability $p ∈ [0, 1]$?

We can generate a uniform floating-point number between 0 and 1, and check if it is less than $p$. This is called a **Bernoulli trial**.
"""

# ╔═╡ c9f21046-8746-11eb-27c6-910807240fd1
rand()

# ╔═╡ 806e6aae-8729-11eb-19ea-33722c60edf0
rand() < 0.314159

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

# ╔═╡ 081e3796-8747-11eb-32ec-dfd998605737
bernoulli(0.7)

# ╔═╡ 008a40d2-872a-11eb-224d-5b3331f29c99
md"""
p = $(@bind p Slider(0.0:0.01:1.0, show_value=true, default=0.7))
"""

# ╔═╡ baed5908-8729-11eb-00e0-9f749406c30c
countmap( [bernoulli(p) for i in 1:1000] )

# ╔═╡ ed94eae8-86b3-11eb-3f1b-15c7a54903f5
md"""
## Bar charts and histograms
"""

# ╔═╡ f20504de-86b3-11eb-3125-3140e0e060b0
md"""
Once we have generated several random objects, it is natural to want to count **how many times** each one occurred.
"""

# ╔═╡ 7f1a3766-86b4-11eb-353f-b13acaf1503e
md"""
Let's roll a (fair) die 1000 times:
"""

# ╔═╡ 371838f8-86b4-11eb-1633-8d282e42a085
md"""
An obvious way to find the counts would be to run through the data looking for 1s, then run through again looking for 2s, etc.:
"""

# ╔═╡ 94688c1a-8747-11eb-13a3-eb36f731674c
rolls .== 1

# ╔═╡ ad701cdc-8747-11eb-3804-63a0fc881547
count(rolls .== 1)

# ╔═╡ 2405eb68-86b4-11eb-31b0-dff8e355d88e
counts = [count(rolls .== i) for i in 1:6]

# ╔═╡ 9e9d3556-86b5-11eb-3dfb-916e625da235
md"""
Note that this is *not* the most efficient algorithm!
"""

# ╔═╡ 90844738-8738-11eb-0604-3d23662152d9
md"""
We can plot **categorical data** using a **bar chart**, `bar` in Plots.jl. This counts each discrete item.
"""

# ╔═╡ 02d03642-86b4-11eb-365a-63ff61ddd3b5
rolls = rand(1:6, 100000)   # try modifying 100 by adding more zeros

# ╔═╡ 2d71fa88-86b5-11eb-0e55-35566c2246d7
begin
	bar(counts, alpha=0.5, leg=false, size=(500, 300))
	hline!([length(rolls) / 6], ls=:dash)
	title!("number of die rolls = $(length(rolls))")
	ylims!(0, length(rolls) / 3)
end

# ╔═╡ cb8a9762-86b1-11eb-0484-6b6cc8b1b14c
md"""
## Probability densities 

### Rolling multiple dice
"""

# ╔═╡ d0c9814e-86b1-11eb-2f29-1d041bccc649
roll_dice(n) = sum( rand(1:12, n) )

# ╔═╡ b81b1090-8735-11eb-3a52-2dca4d4ed472
experiment() = roll_dice(n) 

# experiment() = sum([randn()^2 for i in 1:n])

# ╔═╡ 7a16b674-86b7-11eb-3aa5-83712cdc8580
trials = 10^6

# ╔═╡ e8e811de-86b6-11eb-1cbf-6d4aeaee510a
data = [experiment() for t in 1:trials]

# ╔═╡ 2bfa712a-8738-11eb-3248-6f9bb93154e8
md"""
### Converging shape
"""

# ╔═╡ e4abcbf4-86b8-11eb-167a-d97c61e07837
data

# ╔═╡ 6c133ab6-86b7-11eb-15f6-7780da5afc31
md"""
n = $(@bind n Slider(1:50, show_value=true))
"""

# ╔═╡ 514f6be0-86b8-11eb-30c9-d1020f783afe
histogram(data, alpha=0.5, legend=false, bins=200, c=:lightsalmon1, title="n = $n")  
# c = RGB(0.1, 0.2, 0.3))

# ╔═╡ a15fc456-8738-11eb-25bd-b15c2b16d461
md"""
Here we have switched from a bar chart to a **histogram**, which counts the number of items falling into a given range or **bin**. When $n$ is small this tends to look like a bar chart, but it looks like a "smooth bar chart" as $n$ gets larger, due to the **aggregation**.
"""

# ╔═╡ dd753568-8736-11eb-1f20-1b81110ae807
md"""
Does the above histogram look like a bell to you?
"""

# ╔═╡ 8ab9001a-8737-11eb-1009-5717fbe83af7
begin
	bell = load(download("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmxRAIQt_L-X99A_4FoP3vsC-l_WHlC3TtAw&usqp=CAU"))
	
	bell[1:end*9÷10, :]
end

# ╔═╡ f8b2dd20-8737-11eb-1593-43659c693109
md"""
### Normalising the $y$-axis
"""

# ╔═╡ 89bb366a-8737-11eb-10a6-e754ee817f9a
md"""
Notice that the *shape* of the curve seems to converge to a bell-shaped curve, but the axes do not. What can we do about this?

We need to **normalise** so that the total shaded *area* is 1. We can use the histogram option `norm=true` to do so.
"""

# ╔═╡ 14f0a090-8737-11eb-0ccf-391249267401
histogram(data, alpha=0.5, legend=false, bins=50, norm=true,
			c=:lightsalmon1, title="n = $n", ylims=(0, 0.05))  


# ╔═╡ e305467e-8738-11eb-1213-eb11aaebe151
md"""
### Normalising the $x$ axis
"""

# ╔═╡ e8341288-8738-11eb-27ae-0795fa7e4a7e
md"""
As we changed $n$ above, the range of values on the $x$ axis also changed. We want to find a way to rescale $x$ at the same time so that both axes and shape stop changing as we increase $n$.

We need to make sure that the data is centred in the same place -- we will choose 0. And we need to make sure that the width is the same -- we will divide by the standard deviation.
"""

# ╔═╡ 07e8ae34-873b-11eb-1df2-175392ac4678
σ = std(data)

# ╔═╡ 77616afe-873a-11eb-3f11-1bc417f53138
mean(data), std(data)

# ╔═╡ 16023bea-8739-11eb-1e32-79f2d006b093
normalised_data = ( data .- mean(data) ) ./ std(data)   

# ╔═╡ bfc52118-873b-11eb-0fbb-952c60bc7cc2
histogram(normalised_data, bins=-5 - (1/(2σ)):(1/σ):5, norm=true,
	alpha=0.5, leg=false, ylim=(0, 0.41), size=(500, 300))

# ╔═╡ aa6126f8-873b-11eb-3b4a-0f96fe07b7fb
plot!(x -> exp(-x^2 / 2) / √(2π), lw=2, c=:red, alpha=0.5)

# ╔═╡ 308547c6-873d-11eb-3a42-833f8bf496ae
md"""
Note that in the limit, the data becomes *continuous*, no longer discrete. The probability of any particular value is 0 ! We then talk about a **probability density function**, $f(x)$; the integral of this function over the interval $[a, b]$ gives the probability of being in that interval.
"""

# ╔═╡ cb2fb68e-8749-11eb-29ea-9729ac0c63b4
md"""
### Options for plotting functions
"""

# ╔═╡ e0a1863e-8735-11eb-1182-1b3c59b1e05a
md"""
Other options for the `histogram` function options:
- `legend=false` turns off the legend (key), i.e. the plot labels
- `bins=50` specifies the number of **bins**; can also be a vector of bin edges
- `linetype=:stephist`: use steps instead of bars


- `alpha`: a general plot option specifying transparency (0=invisible; 1=opaque)
- `c` or `color`: a general plot option for the colour
- `lw`: line width (default=1)


There are several different ways to specify colours. [Here](http://juliagraphics.github.io/Colors.jl/stable/namedcolors/) is a list of named colours, but you can also specify `RGB(0.1, 0.2, 0.3)`.
"""

# ╔═╡ 900af0c8-86ba-11eb-2270-71b1869b9a1a
md"""
Note that `linetype=:stephist` will give a stepped version of the histogram:
"""

# ╔═╡ be6e4c00-873c-11eb-1413-5326aba54216
md"""
## Sampling from other distributions
"""

# ╔═╡ 9a1136c2-873c-11eb-124f-c3939972ce4a
md"""
dof = $(@bind dof Slider(1:50, show_value=true))  
"""

# ╔═╡ e01b6f70-873c-11eb-04a1-ad8e86578982
chisq_data = rand( Chisq(dof), 100000 )

# ╔═╡ b5251f76-873c-11eb-38cb-7db300c8fe3c
histogram( chisq_data, norm=true, bins=100, size=(500, 300), leg=false, alpha=0.5,
	xlims=(0, 10*√(dof)))


# ╔═╡ da62fd1c-873c-11eb-0758-e7cb48e964f1
histogram( [ sum( randn().^2 for _=1:dof )  for _ = 1:100000], norm=true,
	alpha=0.5, leg=false)


# ╔═╡ Cell order:
# ╟─3a4957ec-8723-11eb-22a0-8b35322596e2
# ╠═06d2666a-8723-11eb-1395-0febdf3dc2a4
# ╠═0a70bca4-8723-11eb-1bcf-e9abb9b1ab75
# ╟─472a41d2-8724-11eb-31b3-0b81612f0083
# ╟─aeb99f72-8725-11eb-2efd-d3e44686be03
# ╟─4f9bd326-8724-11eb-2c9b-db1ac9464f1e
# ╟─db2d25de-86b1-11eb-0c78-d1ee52e019ca
# ╟─e33fe4c8-86b1-11eb-1031-cf45717a3dc9
# ╠═f49191a2-86b1-11eb-3eab-b392ba058415
# ╠═1abda6c4-86b2-11eb-2aa3-4d1148bb52b7
# ╠═30b12f28-86b2-11eb-087b-8d50ec429b89
# ╠═4ce946c6-86b2-11eb-1820-0728798665ab
# ╠═fae3d138-8743-11eb-1014-b3a2a9b49aba
# ╠═6cdea3ae-86b2-11eb-107a-17bea3f54bc9
# ╠═1c769d58-8744-11eb-3bd3-ab11ea1503ed
# ╠═297fdfa0-8744-11eb-1934-9fe31e8be534
# ╟─776ec3f2-86b3-11eb-0216-9b71d07e99f3
# ╠═5fcf8d4e-8744-11eb-080e-cba749004b08
# ╠═4898106a-8744-11eb-128a-35fec741e6b8
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
# ╠═9647840c-8745-11eb-33fc-898ae351ddfe
# ╠═9d782aa6-8745-11eb-034e-0f8b01be987b
# ╠═a693582c-8745-11eb-261b-ef79e503420e
# ╟─c3255d7a-8727-11eb-0421-d99faf27c7b0
# ╠═e2037806-8727-11eb-3c36-1500f1dd545b
# ╟─28ff621c-8728-11eb-2ec0-2579cb313315
# ╟─57125768-8728-11eb-3c3b-1dd37e1ac189
# ╟─6a439c78-8728-11eb-1969-27a19d254704
# ╟─9f8ac08c-8728-11eb-10ad-f93ca225ce38
# ╠═062b400a-8729-11eb-16c5-235cef648edb
# ╠═7c099606-8746-11eb-37fe-c3befde06e9d
# ╠═97cb3dde-8746-11eb-0b00-690f20cb26dc
# ╠═9d8cdc8e-8746-11eb-2b9a-b30a52026f09
# ╠═81a30c9e-8746-11eb-38c8-9be4f6ba2e80
# ╟─2a81ba88-8729-11eb-3dcb-1db26e468066
# ╟─5ea5838a-8729-11eb-1749-030533fb0656
# ╠═c9f21046-8746-11eb-27c6-910807240fd1
# ╠═806e6aae-8729-11eb-19ea-33722c60edf0
# ╟─90642564-8729-11eb-3cd7-b3d41a1553b4
# ╟─9a426a20-8729-11eb-0c0f-31e1d4dc91bc
# ╠═a4870b14-8729-11eb-20ee-e531d4a7108d
# ╠═081e3796-8747-11eb-32ec-dfd998605737
# ╟─008a40d2-872a-11eb-224d-5b3331f29c99
# ╠═baed5908-8729-11eb-00e0-9f749406c30c
# ╟─ed94eae8-86b3-11eb-3f1b-15c7a54903f5
# ╟─f20504de-86b3-11eb-3125-3140e0e060b0
# ╟─7f1a3766-86b4-11eb-353f-b13acaf1503e
# ╟─371838f8-86b4-11eb-1633-8d282e42a085
# ╠═94688c1a-8747-11eb-13a3-eb36f731674c
# ╠═ad701cdc-8747-11eb-3804-63a0fc881547
# ╠═2405eb68-86b4-11eb-31b0-dff8e355d88e
# ╟─9e9d3556-86b5-11eb-3dfb-916e625da235
# ╟─90844738-8738-11eb-0604-3d23662152d9
# ╠═02d03642-86b4-11eb-365a-63ff61ddd3b5
# ╠═2d71fa88-86b5-11eb-0e55-35566c2246d7
# ╟─cb8a9762-86b1-11eb-0484-6b6cc8b1b14c
# ╠═d0c9814e-86b1-11eb-2f29-1d041bccc649
# ╠═b81b1090-8735-11eb-3a52-2dca4d4ed472
# ╠═7a16b674-86b7-11eb-3aa5-83712cdc8580
# ╠═e8e811de-86b6-11eb-1cbf-6d4aeaee510a
# ╟─2bfa712a-8738-11eb-3248-6f9bb93154e8
# ╠═e4abcbf4-86b8-11eb-167a-d97c61e07837
# ╟─6c133ab6-86b7-11eb-15f6-7780da5afc31
# ╠═514f6be0-86b8-11eb-30c9-d1020f783afe
# ╟─a15fc456-8738-11eb-25bd-b15c2b16d461
# ╟─dd753568-8736-11eb-1f20-1b81110ae807
# ╠═8ab9001a-8737-11eb-1009-5717fbe83af7
# ╟─f8b2dd20-8737-11eb-1593-43659c693109
# ╟─89bb366a-8737-11eb-10a6-e754ee817f9a
# ╠═14f0a090-8737-11eb-0ccf-391249267401
# ╟─e305467e-8738-11eb-1213-eb11aaebe151
# ╟─e8341288-8738-11eb-27ae-0795fa7e4a7e
# ╠═07e8ae34-873b-11eb-1df2-175392ac4678
# ╠═77616afe-873a-11eb-3f11-1bc417f53138
# ╠═16023bea-8739-11eb-1e32-79f2d006b093
# ╠═bfc52118-873b-11eb-0fbb-952c60bc7cc2
# ╠═aa6126f8-873b-11eb-3b4a-0f96fe07b7fb
# ╟─308547c6-873d-11eb-3a42-833f8bf496ae
# ╟─cb2fb68e-8749-11eb-29ea-9729ac0c63b4
# ╟─e0a1863e-8735-11eb-1182-1b3c59b1e05a
# ╟─900af0c8-86ba-11eb-2270-71b1869b9a1a
# ╟─be6e4c00-873c-11eb-1413-5326aba54216
# ╟─9a1136c2-873c-11eb-124f-c3939972ce4a
# ╠═e01b6f70-873c-11eb-04a1-ad8e86578982
# ╠═b5251f76-873c-11eb-38cb-7db300c8fe3c
# ╠═da62fd1c-873c-11eb-0758-e7cb48e964f1
