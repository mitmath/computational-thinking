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

# ╔═╡ cf82077a-81c2-11eb-1de2-09ed6c35d810
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Images", version="0.22.4"), 
			Pkg.PackageSpec(name="ImageMagick", version="0.7"), 
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="Plots", version="1.10"), 
			Pkg.PackageSpec(name="Colors", version="0.12"),
			Pkg.PackageSpec(name="ColorSchemes", version="3.10"),
			Pkg.PackageSpec(name="ForwardDiff"),
			Pkg.PackageSpec(name="LaTeXStrings"),

			])

	using PlutoUI
	using Colors, ColorSchemes, Images
	using Plots
	using LaTeXStrings
	
	using Statistics, LinearAlgebra  # standard libraries
end

# ╔═╡ 4c1ebac8-81b7-11eb-19fa-f704b4d84a21
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
"><em>Section 2.1</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Principal Component Analysis </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/iuKrM_NzxCk" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ c593a748-81b6-11eb-295a-a9800f9dec6d
PlutoUI.TableOfContents(aside=true)

# ╔═╡ deb2af50-8524-11eb-0dd4-9d799ff6d3e2
md"""
# Introduction: Understanding data

In this notebook we will start looking at more general kinds of **data**, not only images, and we'll try to extract some information from the image using statistical methods, namely [**principal component analysis**](https://en.wikipedia.org/wiki/Principal_component_analysis).  

This method tries to answer the questions "which 'directions' are the most important  in the data" and "can we [reduce the dimensionality](https://en.wikipedia.org/wiki/Dimensionality_reduction) (number of useful variables) of the data"? 

This can be viewed as another take on the question of finding and exploiting **structure** in data. It also leads towards ideas of **machine learning**.
"""

# ╔═╡ 2e50a070-853f-11eb-2045-b1cc43c29768
md"""
# Rank of a matrix
"""

# ╔═╡ ed7ff6b2-f863-11ea-1a59-eb242a8674e3
md"## Flags"

# ╔═╡ fed5845e-f863-11ea-2f95-c331d3c62647
md"Let's start off by recalling ideas about  **multiplication tables** or **outer products**:"

# ╔═╡ 0e1a6d80-f864-11ea-074a-5f7890180114
outer(v, w) = [x * y for x in v, y in w]

# ╔═╡ 2e497e30-f895-11ea-09f1-d7f2c1f61193
outer(1:10, 1:12)

# ╔═╡ cfdd04f8-815a-11eb-0409-79a2599c29ab
md"""
Each column is a multiple (in general not an integer multiple) of any other column; and each row is a multiple of any other row.

This is an example of a **structured matrix**, i.e. one in which we need to store *less information* to store the matrix than the full $(m \times n)$ table of numbers (even though no element is 0). For example, for an outer product we only need $m + n$ numbers, which is usually *much* less.
"""

# ╔═╡ ab3d55cc-f905-11ea-2f22-5398f3aca803
md"Some flags give simple examples of outer products, for example"

# ╔═╡ 13b6c108-f864-11ea-2447-2b0741f15c7b
flag = outer([1, 0.1, 2], ones(6))

# ╔═╡ e66b30a6-f914-11ea-2c0f-35282d45a30a
ones(6)

# ╔═╡ 71d1b12e-f895-11ea-39df-f5c18a7766c3
flag2 = outer([1, 0.1, 2], [1, 1, 1, 3, 3, 3])

# ╔═╡ 356267fa-815b-11eb-1c57-ad14fd6e91a7
md"""
Note that outer products are not always immediate to recognise just by looking at an image! But you should be able to recognise that there is some kind of structure.
"""

# ╔═╡ cdbe1d8e-f905-11ea-3884-efeeef386dda
md"## Matrix rank"

# ╔═╡ d9aa9af0-f865-11ea-379e-f16b452bd94c
md"""
If a matrix can be written exactly as a *single* multiplication table / outer product, we say that its **rank** is 1, and we call it a **rank-1** matrix. Similarly, if it can be written as the *sum* of *two* outer products, it has **rank 2**, etc.
"""

# ╔═╡ 2e8ae92a-f867-11ea-0219-1bdd9627c1ea
md"Let's see what a random rank-1 matrix looks like:"

# ╔═╡ 9ad13804-815c-11eb-0253-8f8baf15eee3
w = 300

# ╔═╡ 38adc490-f867-11ea-1de5-3b633aff7c97
image = outer([1; 0.4; rand(50)], rand(w));

# ╔═╡ 946fde3c-815b-11eb-3039-db4105bc43ab
md"""
It has a characteristic checkerboard or patchwork look.
"""

# ╔═╡ ab924210-815b-11eb-07fe-411db58fbc3a
md"""
Here's a random rank-2 matrix:
"""

# ╔═╡ b5094384-815b-11eb-06fd-1f40134c6fd8
md"""
We see that it starts to look less regular.
"""

# ╔═╡ cc4f3fee-815b-11eb-2982-9b797b806b45
md"""
#### Exercise: 

Make an interactive visualisation of a random rank-$n$ matrix where you can vary $n$.
"""

# ╔═╡ dc55775a-815b-11eb-15b7-7993190bffab
md"""
## Effect of noise
"""

# ╔═╡ 9cf23f9a-f864-11ea-3a08-af448aceefd8
md"""
Now what happens if we add a bit of **noise**, i.e. randomness, to a rank-1 matrix?
"""

# ╔═╡ a5b62530-f864-11ea-21e8-71ccfed487f8
noisy_image = image .+ 0.03 .* randn.();

# ╔═╡ c41df86c-f865-11ea-1253-4942bbdbe9d2
md"""The noisy image now has a rank larger than 1. But visually we can see that it is "close to" the original rank-1 matrix. 

Given this matrix, how could we discover that it is close to a structured, rank-1 matrix? We would like to be able to find this out and say that the matrix is close to a simple one."""

# ╔═╡ 7fca33ac-f864-11ea-2a8b-933eb382c172
md"## Images as data"

# ╔═╡ 283f5da4-f866-11ea-27d4-957ca2551b92
md"""

Now let's treat the image as a **data matrix**, so that each column of the image / matrix is a **vector** representing one observation of data. (In data science it is often the rows that correspond to observations.)

Let's try to visualize those vectors, taking just the first two rows of the image as the $x$ and $y$ coordinates of our data points:
"""

# ╔═╡ 54977286-f908-11ea-166d-d1df33f38454
image[1:2, 1:20]

# ╔═╡ 7b4e90b4-f866-11ea-26b3-95efde6c650b
begin 
	xx = image[1, :]
	yy = image[2, :]
end

# ╔═╡ f574ad7c-f866-11ea-0efa-d9d0602aa63b
md"# From images to data"

# ╔═╡ 8775b3fe-f866-11ea-3e6f-9732e39a3525
md"""
We would like to **visualise** this data with the `Plots.jl` package, passing it the $x$ and $y$ coordinates as arguments and plotting a point at each $(x_i, y_i)$ pair.
We obtain the following plot of the original rank-1 matrix and the noisy version:
"""

# ╔═╡ cb7e85e4-815c-11eb-3923-7b9537801bae
gr()

# ╔═╡ 1147cbda-f867-11ea-08fa-ef6ed2ae1e93
begin
	xs = noisy_image[1, :]
	ys = noisy_image[2, :]
	
	scatter(xs, ys, label="noisy", m=:., alpha=0.3, ms=4, ratio=1)

	scatter!(xx, yy, 
			leg=:topleft, label="rank-1", ms=3, alpha=0.3, 
			size=(500, 400), m=:square, c=:red,
			framestyle=:origin)

	
	
	
	title!("Plotting a rank-1 matrix gives a straight line!")
end

# ╔═╡ 8a611e36-f867-11ea-121f-317b7c145fe3
md"We see that the exact rank-1 matrix has columns that **lie along a line** through the origin in this representation, since they are just multiples of one another.

E.g. If $(x_1, y_1)$ and $(x_2, y_2)$ are two columns with $x_2 = cx_1$ and $y_2 = cy_1$, then $y_2 / x_2 = y_1 / x_1$, so they lie along the same line through the origin.

The approximate rank-1 matrix has columns that **lie *close to* the line**!"

# ╔═╡ f7371934-f867-11ea-3b53-d1566684585c
md"So, given the data, we want to look at it do see if it lies close to a line or not.
How can we do so in an *automatic* way?
"

# ╔═╡ 987c1f2e-f868-11ea-1125-0d8c02843ae4
md"""
## Measuring data cloud "size" -- using statistics
"""

# ╔═╡ 9e78b048-f868-11ea-192e-d903265d1eb5
md"Looking at this cloud of data points, a natural thing to do is to try to *measure* it: How wide is it, and how tall?"

# ╔═╡ 24df1f32-ec90-11ea-1f6d-03c1bfa5df8e
md"""For example, let's think about calculating the width of the cloud, i.e. the range of possible $x$-values of the data. For this purpose the $y$-values are actually irrelevant.
"""

# ╔═╡ b264f724-81bf-11eb-1052-295b81cde5fb
md"""
A natural idea would be to just scan the data and take the maximum and minimum values. However, real data often contains anomalously large values called **outliers**, which would dramatically affect this calculation. Instead we need to use a **statistical** method where we weight the data and average over all the data points. This process will hopefully be affected less by outliers, and will give a more representative idea of the size of the **bulk** of the data.
"""

# ╔═╡ 09991230-8526-11eb-04aa-fb904bd2036c
md"""
A first step in analysing data is often to **centre** it data around 0 by subtracting the mean, sometimes called "de-meaning":
"""

# ╔═╡ aec46a9b-f743-4cbd-97a7-3ef3cac78b12
begin
	xs_centered = xs .- mean(xs)
	ys_centered = ys .- mean(ys)
end

# ╔═╡ 1b8c743e-ec90-11ea-10aa-e3b94f768f82
scatter(xs_centered, ys_centered, ms=5, alpha=0.5, ratio=1, leg=false, framestyle=:origin)

# ╔═╡ eb867f18-852e-11eb-005f-e15b6d0d0d95
md"""
## Measuring a "width" of a data set
"""

# ╔═╡ f7079016-852e-11eb-3bc9-53fa0846276f
md"""
A natural way to measure the width of a data set could be to measure some kind of width *separately* in both the $x$ and $y$ directions, in other words by **projecting** the data onto one of the axes, while ignoring the other one. Let's start with the $x$ coordinates of the centred data and try to average them.
	
If we literally average them we will get $0$ (since we have subtracted the mean). We could ask "on average how far away from the origin is the data". This would give the [mean absolute deviation](https://en.wikipedia.org/wiki/Average_absolute_deviation):
"""

# ╔═╡ 870d3efa-f8fc-11ea-1593-1552511dcf86
begin
	scatter(xs_centered, ys_centered, ms=5, alpha=0.5, ratio=1, leg=false, framestyle=:origin)

	scatter!(xs_centered, zeros(size(xs_centered)), ms=5, alpha=0.1, ratio=1, leg=false, framestyle=:origin)

	for i in 1:length(xs_centered)
		plot!([(xs_centered[i], ys_centered[i]), (xs_centered[i], 0)], ls=:dash, c=:black, alpha=0.1)
	end

	plot!()
	
end

# ╔═╡ 4fb82f18-852f-11eb-278d-cf93571f4adc
mean(abs.(xs_centered))

# ╔═╡ 5fcf832c-852f-11eb-1354-792933a891a5
md"""
This is a perfectly good computational measure of distance. However, there is another measure which is easier to reason about theoretically / analytically:
"""

# ╔═╡ ef4a2a54-81bf-11eb-358b-0da2072f20c8
md"""
### Root-mean-square distance: Standard deviation
"""

# ╔═╡ f5358ce4-f86a-11ea-2989-b1f37be89183
md"""
The **standard deviation** is the **root-mean-square** distance of the centered data from the origin. 

In other words, we first *square* the distances (or displacements) from the origin, then take the mean of those, giving the **variance**. However, since we have squared the original distances, this gives a quantity with units "distance$^2$", so we need to take the square root to get back to a measurable length:
"""

# ╔═╡ 2c3721da-f86b-11ea-36cf-3fe4c6622dc6
begin 
	σ_x = √(mean(xs_centered.^2))   # root-mean-square distance from 0
	σ_y = √(mean(ys_centered.^2))
end

# ╔═╡ 03ab44c0-f8fd-11ea-2243-1f3580f98a65
md"This gives the following approximate extents (standard deviations) of the cloud:"

# ╔═╡ 6dec0db8-ec93-11ea-24ad-e17870ee64c2
begin
	scatter(xs_centered, ys_centered, ms=5, alpha=0.5, ratio=1, leg=false, 
			framestyle=:origin)

	vline!([-2*σ_x, 2*σ_x], ls=:dash, lw=2, c=:green)
	hline!([-2*σ_y, 2*σ_y], ls=:dash, lw=2, c=:blue)
	
	annotate!( 2σ_x * 0.93, 0.03, text(L"2\sigma_x",  14, :green))
	annotate!(-2σ_x * 0.88, 0.03, text(L"-2\sigma_x", 14, :green))
	
	annotate!(0.05,  2σ_y * 1.13, text(L"2\sigma_y",  14, :blue))
	annotate!(0.06, -2σ_y * 1.14, text(L"-2\sigma_y", 14, :blue))

end

# ╔═╡ 5fab2c32-f86b-11ea-2f27-ed5feaac1fa5
md"""
We expect most (around 95%) of the data to be contained within the interval $\mu \pm 2 \sigma$, where $\mu$ is the mean and $\sigma$ is the standard deviation. (This assumes that the data is **normally distributed**, which is not actually the case for the data generated above.)
"""

# ╔═╡ ae9a2900-ec93-11ea-1ae5-0748221328fc
md"## Correlated data"

# ╔═╡ b81c9db2-ec93-11ea-0dbd-4bd0951cb2cc
md"""
However, from the figure it is clear that $x$ and $y$ are not the "correct directions" to use for this data set. It would be more natural to think about other directions: the direction in which the data set is mainly pointing (roughly, the direction in which it's longest), together with the approximately perpendicular direction in which it is  narrowest.

We need to find *from the data* which directions these are, and the extent (width) of the data cloud in those directions.

However, we cannot obtain any information about those directions by looking *separately* at $x$-coordinates and $y$-coordinates, since within the same bounding boxes that we just calculated the data can be distributed in many different ways.

Rather, the information that we need is encoded in the *relationship* between the values of $x_i$ and $y_i$ *for the points in the data set*.

For our data set, when $x$ is large and negative, $y$ is also rather negative; when $x$ is 0, $y$ is near $0$, and when $x$ is large and positive, so is $y$. We say that $x$ and $y$ are **correlated** -- literally they are mutually ("co") related, such that knowing some information about one of them allows us to predict something about the other. 

For example, if I measure a new data point from the same process and I find that $x$ is around $0.25$ then I would expect $y$ to be within the range $0.05$ to $0.2$, and it would be very surprising if $y$ were -0.5.

"""

# ╔═╡ 80722856-f86d-11ea-363d-53fc5f6b8152
md"""
Although there are standard methods to calculate this correlation, we prefer to hone our **intuition** using computational thinking instead!
"""

# ╔═╡ b8fa6a1c-f86d-11ea-3d6b-2959d737254b
md"""
We want to think about different *directions*, so let's introduce an angle $\theta$ to describe the direction along which we are looking. We want to calculate the width of the cloud *along that direction*.

Effectively we are *changing coordinates* to a new coordinate, oriented along the line. To do this  requires more linear algebra than we are assuming in this course, but let's see what it looks like:
"""

# ╔═╡ 3547f296-f86f-11ea-1698-53d3c1a0bc30
md"## Rotating the axes"

# ╔═╡ 7a83101e-f871-11ea-1d87-4946162777b5
md"""By rotating the axes we can "look in different directions" and calculate the width of the data set "along that direction". What we are really doing is a perpendicular **projection** of the data onto that direction."""

# ╔═╡ e8276b4e-f86f-11ea-38be-218a72452b10
M = [xs_centered ys_centered]'

# ╔═╡ 1f373bd0-853f-11eb-0f8e-19cb7f376182
eigvals(cov(M')) .* 199

# ╔═╡ d71fdaea-f86f-11ea-1a1f-45e4d50926d3
imax = argmax(M[1, :])

# ╔═╡ 757c6808-f8fe-11ea-39bb-47e4da65113a
svdvals(M)

# ╔═╡ 1232e848-8540-11eb-089b-2185cc06f23a
M

# ╔═╡ 7cb04c9a-8358-11eb-1255-8d8c90916c37
gr()

# ╔═╡ cd9e05ee-f86f-11ea-0422-25f8329c7ef2
R(θ)= [cos(θ) sin(θ)
	  -sin(θ) cos(θ)]

# ╔═╡ 7eb51908-f906-11ea-19d2-e947d81cb743
md"In the following figure, we are rotating the axis (red arrow) around in the left panel. In the right panel we are viewing the data from the point of view of that new coordinate direction, in other words projecting onto that direction, effectively as if we rotated our head so the red vector was horizontal:"

# ╔═╡ 4f1980ea-f86f-11ea-3df2-35cca6c961f3
md"""
degrees = $(@bind degrees Slider(0:360, default=28, show_value=true)) 
"""

# ╔═╡ c9da6e64-8540-11eb-3984-47fdf8be0dac
md"""
## Rotating the data
"""

# ╔═╡ f70065aa-835a-11eb-00cb-ffa27bcb486e
θ = π * degrees / 180   # radians

# ╔═╡ 3b71142c-f86f-11ea-0d43-47011d00786c
p1 = begin
	
	scatter(M[1, :], M[2, :], ratio=1, leg=false, ms=2.5, alpha=0.5,
			framestyle=:origin)
	
	projected = ([cos(θ) sin(θ)] * M) .* [cos(θ) sin(θ)]'
	scatter!(projected[1, :], projected[2, :], m=:3, alpha=0.1, c=:green)
	
	
	lines_x = reduce(vcat, [M[1, i], projected[1, i], NaN] for i in 1:size(M, 2))
	lines_y = reduce(vcat, [M[2, i], projected[2, i], NaN] for i in 1:size(M, 2))
	
	
# 	for i in 1:size(M, 2)
# 		plot!([M[1, i], projected[1, i]], [M[2, i], projected[2, i]], ls=:dash, c=:black, alpha=0.1)
# 	end
	
	plot!(lines_x, lines_y, ls=:dash, c=:black, alpha=0.1)
	
	
	plot!([0.7 .* (-cos(θ), -sin(θ)), 0.7 .* (cos(θ), sin(θ))], lw=1, arrow=true, c=:red, alpha=0.3)
	xlims!(-0.7, 0.7)
	ylims!(-0.7, 0.7)
	
	scatter!([M[1, imax]], [M[2, imax]],  ms=3, alpha=1, c=:yellow)

	annotate!(0, 1.2, text("align arrow with cloud", :red, 10))
end;

# ╔═╡ 8b8e6b2e-8531-11eb-1ea6-637db25b28d5
p1

# ╔═╡ 88bbe1bc-f86f-11ea-3b6b-29175ddbea04
p2 = begin
	M2 = R(θ) * M
	
	scatter(M2[1, :], M2[2, :],ratio=1, leg=false, ms=2.5, alpha=0.3, framestyle=:origin, size=(500, 500))
	
	#plot!([(-0.6, 0), (0.6, 0)], lw=3, arrow=true, c=:red, xaxis=false, yaxis=false, xticks=[], yticks=[])
	
	#scatter!([M2[1, imax]], [M2[2, imax]], ms=3, alpha=1, c=:yellow)

	xlims!(-0.7, 0.7)
	ylims!(-0.7, 0.7)
	
	scatter!(M2[1, :], zeros(size(xs_centered)), ms=3, alpha=0.1, ratio=1, leg=false, framestyle=:origin, c=:green)

	
	lines2_x = reduce(vcat, [M2[1, i], M2[1, i], NaN] for i in 1:size(M2, 2))
	lines2_y = reduce(vcat, [M2[2, i], 0, NaN] for i in 1:size(M2, 2))
	
	# for i in 1:size(M2, 2)
	# 	plot!([(M2[1, i], M2[2, i]), (M2[1, i], 0)], ls=:dash, c=:black, alpha=0.1)
	# end
	
	plot!(lines2_x, lines2_y, ls=:dash, c=:black, alpha=0.1)
	
	σ = std(M2[1, :])
	vline!([-2σ, 2σ], ls=:dash, lw=2)
	
# 	plot!(0.5 * [-cos(θ), cos(θ)], 0.5 * [sin(θ), -sin(θ)], c=:black, alpha=0.5, lw=1, arrow=true)
# 	plot!(0.5 * [-sin(θ), sin(θ)], 0.5 * [-cos(θ), cos(θ)], c=:black, alpha=0.5, lw=1, arrow=true)
	
# 	plot!(0.5 * [cos(θ), -cos(θ)], 0.5 * [-sin(θ), sin(θ)], c=:black, alpha=0.5, lw=1, arrow=true)
# 	plot!(0.5 * [sin(θ), -sin(θ)], 0.5 * [cos(θ), -cos(θ)], c=:black, alpha=0.5, lw=1, arrow=true)
	
	title!("σ = $(round(σ, digits=4))")
	
	annotate!(2σ+0.05, 0.05, text("2σ", 10, :green))
	annotate!(-2σ-0.05, 0.05, text("-2σ", 10, :green))

end;

# ╔═╡ 2ffe7ed0-f870-11ea-06aa-390581500ca1
plot(p2)

# ╔═╡ a5cdad52-f906-11ea-0486-755a6403a367
md"""
We see that the extent of the data in the direction $\theta$ varies as $\theta$ changes. Let's plot the variance in direction $\theta$ as a function of $\theta$:
"""

# ╔═╡ 0115c974-f871-11ea-1204-054510848849
begin
	variance(θ) = var( (R(θ) * M)[1, :] )
	variance(θ::AbstractArray) = variance(θ[1])
end

# ╔═╡ 0935c870-f871-11ea-2a0b-b1b824379350
p3 = begin 
	plot(0:360, variance.(range(0, 2π, length=361)), leg=false, size=(400, 200))
	scatter!([degrees], [σ^2])
	xlabel!("θ")
	ylabel!("variance in direction θ")
end

# ╔═╡ 6646abe0-835b-11eb-328a-55ca22f89c7d
σs = svdvals(M)

# ╔═╡ 31e4b138-84e8-11eb-36a8-8b90746fbb0f
variances = σs.^2 ./ 199

# ╔═╡ ef850e8e-84e7-11eb-1cb0-870c3000841d
1 ./ σs

# ╔═╡ 031a2894-84e8-11eb-1381-9b9e86f2fa0a
M

# ╔═╡ e4af4d26-f877-11ea-1de3-a9f8d389138e
md"""The direction in which the variance is **maximised** gives the most important direction: It is the direction along which the data "points", or the direction which best distinguishes different data points. This is often called the first **principal component** in statistics, or the first **singular vector** in linear algebra. 

We can also now quantify *how close* the data is to lying along that single line, using the width in the *perpendicular* direction: if that width is "much smaller" than  the width in the first principal direction then the data is close to being rank 1.
"""

# ╔═╡ bf57f674-f906-11ea-08eb-9b50818a025b
md"The simplest way to maximise this function is to evaluate it everywhere and find one of the places where it takes the maximum value:"

# ╔═╡ 17e015fe-f8ff-11ea-17b4-a3aa072cd7b3
begin
	θs = 0:0.01:2π
	fs = variance.(θs)

	θmax = θs[argmax(fs)]
	θmin = θs[argmin(fs)]

	fmax = variance(θmax)
	fmin = variance(θmin)
end

# ╔═╡ 045b9b98-f8ff-11ea-0d49-5b209319e951
begin
	scatter(xs_centered, ys_centered, ms=5, alpha=0.3, ratio=1, leg=false, 
			framestyle=:origin)

	plot!([(0, 0), 2*sqrt(fmax) .* (cos(θmax), sin(θmax))], arrow=true, lw=3, c=:red)
	plot!([(0, 0), 2*sqrt(fmin) .* (cos(θmin), sin(θmin))], arrow=true, lw=3, c=:red)

end

# ╔═╡ cfec1ec4-f8ff-11ea-265d-ab4844f0f739
md"""
Note that the directions that maximise and minimise variance are perpendicular. This is always the case, as shown using the Singular-Value Decomposition (SVD) in linear algebra.

There are different ways to think about this procedure. We can think of it as effectively "fitting an ellipse" to the data, where the widths of the ellipse axes show the relative importance of each direction in the data.

Alternatively we can think of it as fitting a multivariate normal distribution by finding a suitable covariance matrix.
"""

# ╔═╡ e6e900b8-f904-11ea-2a0d-953b99785553
begin
	circle = [cos.(θs) sin.(θs)]'
	stretch = [2 * sqrt(fmax) 0
				0   		2 * sqrt(fmin)]
	ellipse = R(-θmax) * stretch * circle 
	
	plot!(ellipse[1, :], ellipse[2, :], series=:shape, alpha=0.4, fill=true, c=:orange)
end

# ╔═╡ 301f4d06-8162-11eb-1cd6-31dd8da164b6
md"""
Note also that an ellipse is the image of the unit circle under a *linear* transformation. We are effectively learning what the best linear transformation is that transforms the unit circle into our data cloud.
"""

# ╔═╡ aaff88e8-f877-11ea-1527-ff4d3db663db
md"## Higher dimensions"

# ╔═╡ aefa84de-f877-11ea-3e26-678008e9739e
md"""
Can we generalise this to dimensions higher than 2? 
Let's think about 3D. If we take columns of the first *three* rows of the original image, we have vectors in 3D.

If we plot these vectors in 3D, a rank-1 matrix will give a straight line in 3D, while a rank-2 matrix will give a **plane** in 3D. Rank-2 + noise gives a noisy cloud lying close to a plane.

Similarly to what we did above, we need to calculate the ellipsoid that best fits the data. The widths of the axes of the ellipsoid tell us how close to being a line or a plane (rank-1 or rank-2) the data is.
"""

# ╔═╡ 0bd9358e-f879-11ea-2c83-ed4e7bf9d903
md"In more than 3D we can no longer visualise the data, but the same idea applies. The calculations are done using the SVD.

If the widths of the ellipsoid in some directions are very small, we can ignore those directions and hence reduce the dimensionality of the data, by changing coordinates to the principal components."

# ╔═╡ 9960e1c2-85a0-11eb-3d68-cd3a07a9c0b5
md"""
## What is the Singular-Value Decomposition (SVD)?
"""

# ╔═╡ dc4cca88-85a0-11eb-2791-d7610a610e36
md"""
The **Singular-Value Decomposition (SVD)** is a way of writing any matrix in terms of simpler matrices. Thinking in terms of linear transformations, *any* linear transformation $T$ has the same effect as a sequence of three simple transformations:

T = rotation₂ ∘ stretch ∘ rotation₁

In terms of matrices, for *any* matrix $M$ it is possible to write

$$M = U \, \Sigma \, V^\text{T}$$

where $U$ and $V$ are **orthogonal** matrices, i.e. they satisfy $U U^\text{T} = I$ and $V V^\text{T} = I$, and $\Sigma$ is a diagonal matrix. 

Orthogonal matrices have determinant $\pm 1$, so they leave areas unchanged. They are rotations, possibly combined with reflections.

There are algorithms from numerical linear algebra to calculate this decomposition. In Julia we call the `svd` function, e.g.
"""

# ╔═╡ 453689c2-85a2-11eb-2cbc-7d6476b42f2f
let
	M = [2 1
		 1 1]
	
	svd(M)
end

# ╔═╡ 91b77acc-85a2-11eb-19bb-bd2bdd0c1a68
md"""
Let's look at the action of the matrix on the unit disc. To generate points in the unit disc we generate points in $[-1, 1]^2$ and *reject* those lying outside:
"""

# ╔═╡ f92c75f6-85a3-11eb-1689-23aeaa3daeb7
begin
	unit_disc = [ (-1.0 .+ 2.0 .* rand(2)) for i in 1:2000 ]
	unit_disc = reduce(hcat, [x for x in unit_disc if x[1]^2 + x[2]^2 < 1])
end

# ╔═╡ 03069da6-85a4-11eb-2ac5-87b767846550
scatter(unit_disc[1, :], unit_disc[2, :], ratio=1, leg=false, alpha=0.5, ms=3)

# ╔═╡ 1647a126-85a4-11eb-3923-5f5a6f703403
md"""
t = $(@bind tt Slider(0:0.01:1, show_value=true))
"""

# ╔═╡ 40b87cbe-85a4-11eb-30f8-cf7b5e79c19a
pp1 = begin
	scatter(unit_disc[1, :], unit_disc[2, :], ratio=1, leg=false, alpha=0.5, title="stretch + rotate")
	result =  [1 + tt  tt; tt  1] * unit_disc
	scatter!(result[1, :], result[2, :], alpha=0.2)

	ylims!(-3, 3)
	xlims!(-3, 3)
end;

# ╔═╡ 28a7d6dc-85a5-11eb-0e4b-b7e9b4c592ed
pp2 = begin
	UU, Sigma, VV = svd([1 + tt  tt; tt  1])
	scatter(unit_disc[1, :], unit_disc[2, :], ratio=1, leg=false, alpha=0.5, title="stretch")
	
	result2 = Diagonal(Sigma) * unit_disc
	
	scatter!(result2[1, :], result2[2, :], alpha=0.2)
	
	ylims!(-3, 3)
	xlims!(-3, 3)

end;


# ╔═╡ 6ec7f980-85a5-11eb-12fc-cb132db28d83
plot(pp2, pp1)

# ╔═╡ 92a2827e-84e9-11eb-1e85-6f49b1da7277
md"""
## Rotations in 300 dimensions
"""

# ╔═╡ e84adec2-84e8-11eb-2157-dd491588ccf0
md"""
We have been thinking of 300 points in 2 dimensions. Instead, we could think about 2 points **in 300 dimensions**. In some sense, this is what 
"transpose really does"!
"""

# ╔═╡ 571b88ac-85a6-11eb-2887-a368a19bce4d
md"""
The $V$ in the SVD is another rotation that we "cannot see" in the above pictures. In our case it is a rotation in 300 dimensions! But in fact we can visualise it as follows, where we multiply our data by a $300 \times 300$ orthogonal matrix!

We first take a random *anti-symmetric* matrix, i.e. one for which $M = -M^\text{t}$.
We then turn that into an orthogonal matrix by taking the so-called **matrix exponential**.
"""

# ╔═╡ 12010a58-84eb-11eb-106f-cb4e3e0c879b
begin
	dim = size(M, 2)
	anti_symmetric = randn(dim, dim)
	anti_symmetric -= anti_symmetric'
end

# ╔═╡ 696d2768-84eb-11eb-39e0-612e074a2c27
@bind t Slider(0:0.0002:1, show_value=true, default=0.0)

# ╔═╡ 7b7b5128-84eb-11eb-3974-9b4c08fab8bb
begin
	M_rotated = M * exp(t * anti_symmetric)
	scatter(M_rotated[1, :], M_rotated[2, :], leg=false, alpha=0.5, )
	scatter!(M[1, :], M[2, :], alpha=0.5)
	
	ylims!(-0.3, 0.3)
	xlims!(-0.6, 0.6)
end

# ╔═╡ 805b9616-85a7-11eb-22e8-db8ee67071ae
md"""
We see that the data rotates around in 300 dimensions, but always is projected to the *same* ellipse.
"""

# ╔═╡ 90656ce6-84fb-11eb-1aac-4bd7747613db
U, Σ, V = svd(M, full=true)

# ╔═╡ aec542a2-84fb-11eb-322c-27fc2c45f6ef
M18 = M * V 

# ╔═╡ b55dcfd2-84fb-11eb-1766-17dc8b7a17d0
scatter(M18[1, :], M18[2, :], alpha=0.5, leg=false, ratio=1, xlim=(-5,5))


# ╔═╡ 1cf3e098-f864-11ea-3f3a-c53017b73490
md"#### Appendix"

# ╔═╡ 2917943c-f864-11ea-3ee6-db952ca7cd67
begin
	show_image(M) = get.(Ref(ColorSchemes.rainbow), M ./ maximum(M))
	show_image(x::AbstractVector) = show_image(x')
end

# ╔═╡ 43bff19e-f864-11ea-2315-0f85b532a325
show_image(flag)

# ╔═╡ 79d2c6f4-f895-11ea-30c4-9d1102c99482
show_image(flag2)

# ╔═╡ b183b6ca-f864-11ea-0b34-4dd3f4f5e69d
show_image(image)

# ╔═╡ 74c04322-815b-11eb-2308-7b3d571cf613
begin
	
	image2 = outer([1; 0.4; rand(50)], rand(w)) + 
	         outer(rand(52), rand(w))
	
	show_image(image2)
end

# ╔═╡ f6713bec-815b-11eb-2fc4-6b0326a64b16
show_image(image)

# ╔═╡ 5471ddce-f867-11ea-2519-21981f5ea68b
show_image(noisy_image)

# ╔═╡ 1957f71c-f8eb-11ea-0dcf-339bfa7f96fc
show_image(image[1:2, 1:20])

# ╔═╡ 72bb11b0-f88f-11ea-0e55-b1108300f854
loss(M1, M2) = sum( (M1[i] - M2[i])^2 for i in 1:length(M1) if !ismissing(M2[i]) )

# ╔═╡ feeeb24a-f88f-11ea-287f-219e53615f32
function split_up(v, m, n)
	return v[1:m], v[m+1:m+n], v[m+n+1:2m+n], v[2m+n+1:2m+2n]
end

# ╔═╡ 0bcc8852-f890-11ea-3715-11cbead7f636
function ff(v, m, n)
	v1, w1, v2, w2 = split_up(v, m, n)
	
	loss(outer(v1, w1) + outer(v2, w2), M3)
end

# ╔═╡ 7040dc72-f893-11ea-3d22-4fbd452faa41
ff2(v) = ff(v, m, n)

# ╔═╡ 1dbcf15a-f890-11ea-008c-8935edfbdb1c
ff(rand(total), m, n)

# ╔═╡ Cell order:
# ╟─4c1ebac8-81b7-11eb-19fa-f704b4d84a21
# ╠═cf82077a-81c2-11eb-1de2-09ed6c35d810
# ╠═c593a748-81b6-11eb-295a-a9800f9dec6d
# ╟─deb2af50-8524-11eb-0dd4-9d799ff6d3e2
# ╟─2e50a070-853f-11eb-2045-b1cc43c29768
# ╟─ed7ff6b2-f863-11ea-1a59-eb242a8674e3
# ╟─fed5845e-f863-11ea-2f95-c331d3c62647
# ╠═0e1a6d80-f864-11ea-074a-5f7890180114
# ╠═2e497e30-f895-11ea-09f1-d7f2c1f61193
# ╟─cfdd04f8-815a-11eb-0409-79a2599c29ab
# ╟─ab3d55cc-f905-11ea-2f22-5398f3aca803
# ╠═13b6c108-f864-11ea-2447-2b0741f15c7b
# ╠═e66b30a6-f914-11ea-2c0f-35282d45a30a
# ╠═43bff19e-f864-11ea-2315-0f85b532a325
# ╠═71d1b12e-f895-11ea-39df-f5c18a7766c3
# ╠═79d2c6f4-f895-11ea-30c4-9d1102c99482
# ╟─356267fa-815b-11eb-1c57-ad14fd6e91a7
# ╟─cdbe1d8e-f905-11ea-3884-efeeef386dda
# ╟─d9aa9af0-f865-11ea-379e-f16b452bd94c
# ╟─2e8ae92a-f867-11ea-0219-1bdd9627c1ea
# ╠═9ad13804-815c-11eb-0253-8f8baf15eee3
# ╠═38adc490-f867-11ea-1de5-3b633aff7c97
# ╠═b183b6ca-f864-11ea-0b34-4dd3f4f5e69d
# ╟─946fde3c-815b-11eb-3039-db4105bc43ab
# ╟─ab924210-815b-11eb-07fe-411db58fbc3a
# ╠═74c04322-815b-11eb-2308-7b3d571cf613
# ╟─b5094384-815b-11eb-06fd-1f40134c6fd8
# ╟─cc4f3fee-815b-11eb-2982-9b797b806b45
# ╟─dc55775a-815b-11eb-15b7-7993190bffab
# ╟─9cf23f9a-f864-11ea-3a08-af448aceefd8
# ╠═a5b62530-f864-11ea-21e8-71ccfed487f8
# ╠═f6713bec-815b-11eb-2fc4-6b0326a64b16
# ╠═5471ddce-f867-11ea-2519-21981f5ea68b
# ╟─c41df86c-f865-11ea-1253-4942bbdbe9d2
# ╟─7fca33ac-f864-11ea-2a8b-933eb382c172
# ╟─283f5da4-f866-11ea-27d4-957ca2551b92
# ╠═1957f71c-f8eb-11ea-0dcf-339bfa7f96fc
# ╠═54977286-f908-11ea-166d-d1df33f38454
# ╠═7b4e90b4-f866-11ea-26b3-95efde6c650b
# ╟─f574ad7c-f866-11ea-0efa-d9d0602aa63b
# ╟─8775b3fe-f866-11ea-3e6f-9732e39a3525
# ╠═cb7e85e4-815c-11eb-3923-7b9537801bae
# ╠═1147cbda-f867-11ea-08fa-ef6ed2ae1e93
# ╟─8a611e36-f867-11ea-121f-317b7c145fe3
# ╟─f7371934-f867-11ea-3b53-d1566684585c
# ╟─987c1f2e-f868-11ea-1125-0d8c02843ae4
# ╟─9e78b048-f868-11ea-192e-d903265d1eb5
# ╟─24df1f32-ec90-11ea-1f6d-03c1bfa5df8e
# ╟─b264f724-81bf-11eb-1052-295b81cde5fb
# ╟─09991230-8526-11eb-04aa-fb904bd2036c
# ╠═aec46a9b-f743-4cbd-97a7-3ef3cac78b12
# ╠═1b8c743e-ec90-11ea-10aa-e3b94f768f82
# ╟─eb867f18-852e-11eb-005f-e15b6d0d0d95
# ╟─f7079016-852e-11eb-3bc9-53fa0846276f
# ╟─870d3efa-f8fc-11ea-1593-1552511dcf86
# ╠═4fb82f18-852f-11eb-278d-cf93571f4adc
# ╟─5fcf832c-852f-11eb-1354-792933a891a5
# ╟─ef4a2a54-81bf-11eb-358b-0da2072f20c8
# ╟─f5358ce4-f86a-11ea-2989-b1f37be89183
# ╠═2c3721da-f86b-11ea-36cf-3fe4c6622dc6
# ╟─03ab44c0-f8fd-11ea-2243-1f3580f98a65
# ╟─6dec0db8-ec93-11ea-24ad-e17870ee64c2
# ╟─5fab2c32-f86b-11ea-2f27-ed5feaac1fa5
# ╟─ae9a2900-ec93-11ea-1ae5-0748221328fc
# ╟─b81c9db2-ec93-11ea-0dbd-4bd0951cb2cc
# ╟─80722856-f86d-11ea-363d-53fc5f6b8152
# ╟─b8fa6a1c-f86d-11ea-3d6b-2959d737254b
# ╟─3547f296-f86f-11ea-1698-53d3c1a0bc30
# ╟─7a83101e-f871-11ea-1d87-4946162777b5
# ╠═e8276b4e-f86f-11ea-38be-218a72452b10
# ╠═1f373bd0-853f-11eb-0f8e-19cb7f376182
# ╠═31e4b138-84e8-11eb-36a8-8b90746fbb0f
# ╟─d71fdaea-f86f-11ea-1a1f-45e4d50926d3
# ╠═757c6808-f8fe-11ea-39bb-47e4da65113a
# ╠═1232e848-8540-11eb-089b-2185cc06f23a
# ╠═3b71142c-f86f-11ea-0d43-47011d00786c
# ╠═88bbe1bc-f86f-11ea-3b6b-29175ddbea04
# ╠═7cb04c9a-8358-11eb-1255-8d8c90916c37
# ╟─cd9e05ee-f86f-11ea-0422-25f8329c7ef2
# ╟─7eb51908-f906-11ea-19d2-e947d81cb743
# ╠═8b8e6b2e-8531-11eb-1ea6-637db25b28d5
# ╟─4f1980ea-f86f-11ea-3df2-35cca6c961f3
# ╟─c9da6e64-8540-11eb-3984-47fdf8be0dac
# ╠═f70065aa-835a-11eb-00cb-ffa27bcb486e
# ╠═2ffe7ed0-f870-11ea-06aa-390581500ca1
# ╟─a5cdad52-f906-11ea-0486-755a6403a367
# ╟─0115c974-f871-11ea-1204-054510848849
# ╠═0935c870-f871-11ea-2a0b-b1b824379350
# ╠═6646abe0-835b-11eb-328a-55ca22f89c7d
# ╠═ef850e8e-84e7-11eb-1cb0-870c3000841d
# ╠═031a2894-84e8-11eb-1381-9b9e86f2fa0a
# ╟─e4af4d26-f877-11ea-1de3-a9f8d389138e
# ╟─bf57f674-f906-11ea-08eb-9b50818a025b
# ╠═17e015fe-f8ff-11ea-17b4-a3aa072cd7b3
# ╟─045b9b98-f8ff-11ea-0d49-5b209319e951
# ╟─cfec1ec4-f8ff-11ea-265d-ab4844f0f739
# ╠═e6e900b8-f904-11ea-2a0d-953b99785553
# ╟─301f4d06-8162-11eb-1cd6-31dd8da164b6
# ╟─aaff88e8-f877-11ea-1527-ff4d3db663db
# ╟─aefa84de-f877-11ea-3e26-678008e9739e
# ╟─0bd9358e-f879-11ea-2c83-ed4e7bf9d903
# ╟─9960e1c2-85a0-11eb-3d68-cd3a07a9c0b5
# ╟─dc4cca88-85a0-11eb-2791-d7610a610e36
# ╠═453689c2-85a2-11eb-2cbc-7d6476b42f2f
# ╟─91b77acc-85a2-11eb-19bb-bd2bdd0c1a68
# ╠═f92c75f6-85a3-11eb-1689-23aeaa3daeb7
# ╠═03069da6-85a4-11eb-2ac5-87b767846550
# ╠═40b87cbe-85a4-11eb-30f8-cf7b5e79c19a
# ╠═28a7d6dc-85a5-11eb-0e4b-b7e9b4c592ed
# ╟─1647a126-85a4-11eb-3923-5f5a6f703403
# ╠═6ec7f980-85a5-11eb-12fc-cb132db28d83
# ╟─92a2827e-84e9-11eb-1e85-6f49b1da7277
# ╟─e84adec2-84e8-11eb-2157-dd491588ccf0
# ╟─571b88ac-85a6-11eb-2887-a368a19bce4d
# ╠═12010a58-84eb-11eb-106f-cb4e3e0c879b
# ╠═696d2768-84eb-11eb-39e0-612e074a2c27
# ╠═7b7b5128-84eb-11eb-3974-9b4c08fab8bb
# ╟─805b9616-85a7-11eb-22e8-db8ee67071ae
# ╠═90656ce6-84fb-11eb-1aac-4bd7747613db
# ╠═aec542a2-84fb-11eb-322c-27fc2c45f6ef
# ╠═b55dcfd2-84fb-11eb-1766-17dc8b7a17d0
# ╟─1cf3e098-f864-11ea-3f3a-c53017b73490
# ╠═2917943c-f864-11ea-3ee6-db952ca7cd67
# ╠═72bb11b0-f88f-11ea-0e55-b1108300f854
# ╠═feeeb24a-f88f-11ea-287f-219e53615f32
# ╠═0bcc8852-f890-11ea-3715-11cbead7f636
# ╠═7040dc72-f893-11ea-3d22-4fbd452faa41
# ╠═1dbcf15a-f890-11ea-008c-8935edfbdb1c
