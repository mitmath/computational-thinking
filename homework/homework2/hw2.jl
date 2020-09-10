### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ 86e1ee96-f314-11ea-03f6-0f549b79e7c9
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ a4937996-f314-11ea-2ff9-615c888afaa8
begin
	Pkg.add([
			"Images",
			"ImageMagick",
			"Compose",
			"ImageFiltering",
			"TestImages",
			"Statistics",
			"PlutoUI",
			"BenchmarkTools"
			])

	using Images
	using TestImages
	using ImageFiltering
	using Statistics
	using PlutoUI
	using BenchmarkTools
end

# ╔═╡ e6b6760a-f37f-11ea-3ae1-65443ef5a81a
md"_homework 2, version 1_"

# ╔═╡ 33e43c7c-f381-11ea-3abc-c942327456b1
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ ec66314e-f37f-11ea-0af4-31da0584e881
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 0d144802-f319-11ea-0028-cd97a776a3d0
#img = load(download("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg/300px-Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg"))
#img = load(download("https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg/477px-Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg"))
img = load(download("http://www.museumsyndicate.com/images/1/2957.jpg"))

# ╔═╡ cc9fcdae-f314-11ea-1b9a-1f68b792f005
md"""
# Exercise 1: views

In the lecture (included below) we learned about what array views are. In this exercise we will add to that understanding and look at an important use of `view`s: to reduce the amount of memory allocations when reading sub-sequences within an array.

We will use the `BenchmarkTools` package to emperically understand the effects of using views.
"""

# ╔═╡ b49a21a6-f381-11ea-1a98-7f144c55c9b7
html"""
<iframe width="100%" height="500px" src="https://www.youtube.com/embed/gTGJ80HayK0?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ b49e8cc8-f381-11ea-1056-91668ac6ae4e
md"""
## Shrinking an array

Below is a function called `remove_in_each_row(img, pixels)`. It takes a matrix `img` and a vector of integers, `pixels`, and shrinks the image by 1 pixel in width by removing the element `img[i, pixels[i]]` in every row. This function is one of the building blocks of the Image Seam algorithm we saw in the lecture.

Read it and convince yourself that it is correct.
"""

# ╔═╡ 7af62c60-f381-11ea-077a-b581565a282c


# ╔═╡ e799be82-f317-11ea-3ae4-6d13ece3fe10
function remove_in_each_row(img, column_numbers)
	@assert size(img, 1) == length(column_numbers) # same as the number of rows
	m, n = size(img)
	local img′ = similar(img, m, n-1) # create a similar image with one less column

	@show(size(img′))

	for (i, j) in enumerate(column_numbers)
		img′[i, :] = vcat(img[i, 1:j-1], img[i, j+1:end])
	end
	img′
end

# ╔═╡ 9cced1a8-f326-11ea-0759-0b2f22e5a1db
size(img), size(remove_in_each_row(img, 1:size(img, 1))) # this removes the diagonal pixels!

# ╔═╡ 1d893998-f366-11ea-0828-512de0c44915
md"""
## Making it efficient

We can use the `@benchmark` macro from the [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) package. To benchmark fragments of Julia code. `@benchmark` takes an expression and runs it a number of times to obtain statistics about the run time and memory allocation. We generally take the minimum time as the most stable measurement of performance ([for reasons discussed in the paper on BenchmarkTools](http://www-math.mit.edu/~edelman/publications/robust_benchmarking.pdf))
"""

# ╔═╡ 59991872-f366-11ea-1036-afe313fb4ec1
md"""
First, as an example, let's benchmark the remove_in_each_row function we defined above by passing in our image and a some indices to remove.
"""

# ╔═╡ e501ea28-f326-11ea-252a-53949fd9ef57
default_benchmark = @benchmark remove_in_each_row(img, 1:size(img, 1))

# ╔═╡ 02195466-f327-11ea-0dd4-6bc6179c9fed
# Let's keep track of the result in a dictionary.
view_performance_experiments = Dict(
	"default" => default_benchmark,
);

# ╔═╡ f7915918-f366-11ea-2c46-2f4671ae8a22
md"""
## 1.1

`vcat(x, y)` is used in julia to concatenate two arrays vertically. This actually creates a new array of size `length(x) + length(y)` and copies `x` and `y` into it.  We use it in `remove_in_each_row` to create rows which have one less pixel.

While use of `vcat` might make it easy to write the first version of our function, it's strictly not necessary.

In `remove_in_each_row_no_vcat`, figure out a way to avoid the use of `vcat` and modify the function to avoid it.
"""

# ╔═╡ 37d4ea5c-f327-11ea-2cc5-e3774c232c2b
function remove_in_each_row_no_vcat(img, column_numbers)
	@assert size(img, 1) == length(column_numbers) # same as the number of rows
	m, n = size(img)
	local img′ = similar(img, m, n-1) # create a similar image with one less column

	for (i, j) in enumerate(column_numbers)
		# EDIT THE FOLLOWING LINE and split it into two lines
		# to avoid using `vcat`.
		img′[i, :] .= vcat(img[i, 1:j-1], img[i, j+1:end])
	end
	img′
end

# ╔═╡ 67717d02-f327-11ea-0988-bfe661f57f77
view_performance_experiments["without_vcat"] = @benchmark remove_in_each_row_no_vcat(img, 1:size(img, 1))

# ╔═╡ 9e149cd2-f367-11ea-28ef-b9533e8a77bb
md"""
If you did it correctly, you should see that this benchmark shows the function running faster! And "memory estimate" should also show a smaller number, and so should "allocs estimate" which is the number of allocations done per call.

## 1.2

How many estimated allocations did this optimization reduce, and how can you explain most of them?
"""

# ╔═╡ e49235a4-f367-11ea-3913-f54a4a6b2d6b
no_vcat_summary = md"""
<Your answer here>
"""

# ╔═╡ 837c43a4-f368-11ea-00a3-990a45cb0cbd
md"""

## 1.3 view-based optimization

In the below `remove_in_each_row_views` function, implement both the optimization to remove `vcat` and use `@view` or `@views` to avoid creating copies or slices of the `img` array.

Pluto will automatically time your change with `@benchmark` below.
"""

# ╔═╡ 90a22cc6-f327-11ea-1484-7fda90283797
function remove_in_each_row_views(img, column_numbers)
	@assert size(img, 1) == length(column_numbers) # same as the number of rows
	m, n = size(img)
	local img′ = similar(img, m, n-1) # create a similar image with one less column

	for (i, j) in enumerate(column_numbers)
		# EDIT THE FOLLOWING LINE and implement the above optimization
		# AND use `@view` or `@views` to stop creating copies of subarrays of `img`.
		img′[i, :] .= vcat(img[i, 1:j-1], img[i, j+1:end])
	end
	img′
end

# ╔═╡ 538e9324-f368-11ea-38aa-a37a082f8f79


# ╔═╡ 3335e07c-f328-11ea-0e6c-8d38c8c0ad5b
view_performance_experiments["views"] = @benchmark remove_in_each_row_views(img, 1:size(img, 1))

# ╔═╡ 40d6f562-f329-11ea-2ee4-d7806a16ede3
md"Final tally:"

# ╔═╡ 4f0975d8-f329-11ea-3d10-59a503f8d6b2
view_performance_experiments

# ╔═╡ 7eaa57d2-f368-11ea-1a70-c7c7e54bd0b1
md"""

## 1.4

Nice! If you did your optimizations right, you should be able to get down the etimated allocations to a single digit number!

How many allocations were avoided by adding the `@view` optimization over the `vcat` optimization? Why is this?

(do not edit the name of the variable below, you will trip up the auto grader)
"""

# ╔═╡ fd819dac-f368-11ea-33bb-17148387546a
views_result = md"""
<your answer here>
"""

# ╔═╡ 8d558c4c-f328-11ea-0055-730ead5d5c34


# ╔═╡ 318a2256-f369-11ea-23a9-2f74c566549b
md"""
## Brightness and Energy
"""

# ╔═╡ 7a44ba52-f318-11ea-0406-4731c80c1007
md"""
First, we will define a `brightness` function for a pixel (a color) as the mean of the red, green and blue values.

You should call this function whenever the problem set asks you to deal with brightness of a pixel.
"""

# ╔═╡ 6c7e4b54-f318-11ea-2055-d9f9c0199341
brightness(c::RGB) = mean((c.r, c.g, c.b))

# ╔═╡ 74059d04-f319-11ea-29b4-85f5f8f5c610
Gray.(brightness.(img))

# ╔═╡ 0b9ead92-f318-11ea-3744-37150d649d43
md"""
In the previous problem set, we computed wrote code to compute the convolution of an image with a kernel. Here we will use the implementation of the same from the Julia package [ImageFiltering.jl](https://juliaimages.org/ImageFiltering.jl/stable/#Demonstration-1). Convolution is called `imfilter` in this package ("filter" is a term used in the signal processing world for convolution, and other operations that are like convolution.)

`imfilter` takes a"""

# ╔═╡ d184e9cc-f318-11ea-1a1e-994ab1330c1a
convolve(img, k) = imfilter(img, reflect(k))

# ╔═╡ cdfb3508-f319-11ea-1486-c5c58a0b9177
float_to_color(x) = RGB(max(0, -x), max(0, x), 0)

# ╔═╡ f010933c-f318-11ea-22c5-4d2e64cd9629
begin
	img,
	float_to_color.(convolve(brightness.(img), Kernel.sobel()[1])),
	float_to_color.(convolve(brightness.(img), Kernel.sobel()[2]))
end

# ╔═╡ 5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
md"""
finally we define the `energy` function which takes the gradients along x and y directions and computes the norm
"""

# ╔═╡ 6f37b34c-f31a-11ea-2909-4f2079bf66ec
energy(∇x, ∇y) = sqrt.(∇x.^2 .+ ∇y.^2)

# ╔═╡ c349ad24-f31e-11ea-2ae8-c9e380c25f9d
@bind rm_columns Slider(1:100)

# ╔═╡ 64c78e00-f31f-11ea-1392-e315a79fdf56
md"""
removing $rm_columns columns
"""

# ╔═╡ 87afabf8-f317-11ea-3cb3-29dced8e265a
md"""
# Exercise 2: Building up to dynamic programming

In this exercise, we will use the image resizing example computational problem of Seam carving. We will think through all the "gut reaction" solutions, and then finally end up with the dynamic programming solution that we saw in the lecture.

In the process we will understand the performance and accuracy of each iteration of our solution.

### How to implement the solutions:

For every variation of the algorithm, your job is to write a function which takes a matrix of energies, and an index for a pixel on the first row, and computes a "seam" starting at that pixel.

The function should return a vector of as many integers as there are rows in the input matrix where each number points out a pixel to delete from the corresponding row. (it acts as the input to `remove_in_each_row`).
"""

# ╔═╡ 8ba9f5fc-f31b-11ea-00fe-79ecece09c25
md"""
## 2.1 The greedy approach

Implement the greedy approach [discussed in the lecture](https://youtu.be/rpB6zQNsbQU?t=777),
"""

# ╔═╡ abf20aa0-f31b-11ea-2548-9bea4fab4c37
function greedy_seam(energies, starting_pixel::Int)
	m, n = size(energies) # delete the body of this function it's just a placeholder.
	min.(1:m, n)
end

# ╔═╡ 52452d26-f36c-11ea-01a6-313114b4445d
md"""
## 2.2 Exhaustive search with recursion

A common trope in algorithm design is the possibility of solving a problem as the combination of solutions to subproblems.

An analogy can be drawn to the process of mathematical induction in mathematics. And as with mathematical induction there are parts to constructing such a recursive algorithm:

- Defining a base case
- Defining an induction step, i.e. finding a solution to the problem as a combination of solutions to smaller problems.

"""

# ╔═╡ 9101d5a0-f371-11ea-1c04-f3f43b96ca4a
md"""

### 2.2.1

Define `least_energy` function which returns
1. the lowest possible total energy for a seam starting at the pixel at (i, j).
2. the column to jump to on the next move (in row i+1),
which is one of j-1,j or j+1, up to	boundary conditions.

return these two values in a tuple.

You can call the `least_energy` function recursively within itself to obtain the least energy of the adjacent cells and add the energy at the current cell to get the total energy.
"""

# ╔═╡ 8ec27ef8-f320-11ea-2573-c97b7b908cb7
## returns lowest possible sum energy at pixel (i, j), and the column to jump to in row i+1.
function least_energy(energies, i, j)
	# base case
	# if i == something
	#    return energies[...] # no need for recursive computation in the base case!
	# end
	#
	# induction
	# combine results from smaller sub-problems
end

# ╔═╡ 8bc930f0-f372-11ea-06cb-79ced2834720
md"""
### 2.2.2

Now use the `least_energy` function you defined above to define `recursive_seam` function which takes the energies matrix and a starting pixel, and computes the seam with the lowest energy from that starting pixel.

This will give you the method used in the lecture to perform [exhaustive search of all possible paths](https://youtu.be/rpB6zQNsbQU?t=839).
"""

# ╔═╡ 85033040-f372-11ea-2c31-bb3147de3c0d
function recursive_seam(energies, starting_pixel)
	m, n = size(energies) # delete the body of this function it's just a placeholder.
	min.(1:m, n)
end

# ╔═╡ c572f6ce-f372-11ea-3c9a-e3a21384edca
md"""
### 2.2.3

- State clearly why this algorithm does an exhaustive search of all possible paths.
- How many such paths are there in an image of size `m×n`?
"""

# ╔═╡ 6d993a5c-f373-11ea-0dde-c94e3bbd1552
exhaustive_observation = md"""
<your answer here>
"""

# ╔═╡ ea417c2a-f373-11ea-3bb0-b1b5754f2fac
md"""
# 2.3 Memoization

Memoization is the name given to the technique of storing results to expensive function calls that will be accessed more than once.

As stated in the video, a the function `least_energy` is called with the same number of arguments. In fact, we call it on the order of $3^n$ times when there are only really $m×n$ unique ways to call it!

Lets implement memoization on this function with first a [dictionary](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) for storage and then a matrix.
"""

# ╔═╡ 56a7f954-f374-11ea-0391-f79b75195f4d
md"""
### 2.3.1 Dictionary as storage

First we will start a memoized version of
"""

# ╔═╡ b1d09bc8-f320-11ea-26bb-0101c9a204e2
function memoized_seam(energies, starting_pixel, memory=Dict{Int}())
	m, n = size(energies) # delete the body of this function it's just a placeholder.
	min.(1:m, n)
end

# ╔═╡ cf39fa2a-f374-11ea-0680-55817de1b837
md"""
### 2.3.2 Matrix as storage

While the dictionary works just as well, and more generally if we were stor
"""

# ╔═╡ be7d40e2-f320-11ea-1b56-dff2a0a16e8d
function matrix_memoized_seam(energies, starting_pixel, memory=copy(energies))
	m, n = size(energies) # delete the body of this function it's just a placeholder.
	min.(1:m, n)
end

# ╔═╡ 24792456-f37b-11ea-07b2-4f4c8caea633
md"""
### 2.4 Memoization without recursion -- final solution

Now it's easy to see that the above algorithm is equivalent to one that populates the memory matrix in a for loop.

### 2.4.1

Write a function which takes the energies and returns the least energy matrix which has the least possible seam energy for each pixel. This was shown in the lecture, but attempt to write it on your own.
"""

# ╔═╡ ff055726-f320-11ea-32f6-2bf38d7dd310
function least_energy_matrix(energies)
	copy(energies)
end

# ╔═╡ 92e19f22-f37b-11ea-25f7-e321337e375e
md"""
### 2.4.2

Write a function which when given the matrix returned by `least_energy_matrix` and a starting pixel (on the first row), computes the least energy seam from that pixel.
"""

# ╔═╡ 795eb2c4-f37b-11ea-01e1-1dbac3c80c13
function seam_from_precomputed_least_energy(least_energies, starting_pixel::Int)
	m, n = size(energies) # delete the body of this function it's just a placeholder.
	min.(1:m, n)
end

# ╔═╡ 437ba6ce-f37d-11ea-1010-5f6a6e282f9b
function shrink_n(img, n, min_seam)
	e = energy(img)
	_, min_j = findmin(j->min_seam(e, j), 1:size(e, 2))
	min_seam(img, min_j)
end

# ╔═╡ 0e706bc4-f321-11ea-1e9a-71352fbe2e95
md"""
- write a thing that shows them the result -- with a slider to repeatedly apply it.
- write a thing that plots the time taken
"""

# ╔═╡ 4240988e-f321-11ea-1e56-a90b3bf4d7ce
TestImages.shepp_logan(112)

# ╔═╡ 6bdbcf4c-f321-11ea-0288-fb16ff1ec526
function decimate(img, n)
	img[1:n:end, 1:n:end]
end

# ╔═╡ 0fbe2af6-f381-11ea-2f41-23cd1cf930d9
if student.kerberos_id === "jazz"
	md"""
!!! danger "Oops!"
    **Before you submit**, remember to fill in your name and kerberos ID at the top of this notebook!
	"""
end

# ╔═╡ ffc17f40-f380-11ea-30ee-0fe8563c0eb1
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ ffc40ab2-f380-11ea-2136-63542ff0f386
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ffceaed6-f380-11ea-3c63-8132d270b83f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ ffe326e0-f380-11ea-3619-61dd0592d409
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ fff5aedc-f380-11ea-2a08-99c230f8fa32
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 00026442-f381-11ea-2b41-bde1fff66011
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 00115b6e-f381-11ea-0bc6-61ca119cb628
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 48089a00-f321-11ea-1479-e74ba71df067
bigbreak

# ╔═╡ Cell order:
# ╟─e6b6760a-f37f-11ea-3ae1-65443ef5a81a
# ╟─ec66314e-f37f-11ea-0af4-31da0584e881
# ╠═33e43c7c-f381-11ea-3abc-c942327456b1
# ╠═86e1ee96-f314-11ea-03f6-0f549b79e7c9
# ╠═a4937996-f314-11ea-2ff9-615c888afaa8
# ╟─0d144802-f319-11ea-0028-cd97a776a3d0
# ╟─cc9fcdae-f314-11ea-1b9a-1f68b792f005
# ╟─b49a21a6-f381-11ea-1a98-7f144c55c9b7
# ╟─b49e8cc8-f381-11ea-1056-91668ac6ae4e
# ╠═7af62c60-f381-11ea-077a-b581565a282c
# ╠═e799be82-f317-11ea-3ae4-6d13ece3fe10
# ╠═9cced1a8-f326-11ea-0759-0b2f22e5a1db
# ╟─1d893998-f366-11ea-0828-512de0c44915
# ╟─59991872-f366-11ea-1036-afe313fb4ec1
# ╠═e501ea28-f326-11ea-252a-53949fd9ef57
# ╠═02195466-f327-11ea-0dd4-6bc6179c9fed
# ╟─f7915918-f366-11ea-2c46-2f4671ae8a22
# ╠═37d4ea5c-f327-11ea-2cc5-e3774c232c2b
# ╠═67717d02-f327-11ea-0988-bfe661f57f77
# ╟─9e149cd2-f367-11ea-28ef-b9533e8a77bb
# ╠═e49235a4-f367-11ea-3913-f54a4a6b2d6b
# ╟─837c43a4-f368-11ea-00a3-990a45cb0cbd
# ╠═90a22cc6-f327-11ea-1484-7fda90283797
# ╠═538e9324-f368-11ea-38aa-a37a082f8f79
# ╠═3335e07c-f328-11ea-0e6c-8d38c8c0ad5b
# ╟─40d6f562-f329-11ea-2ee4-d7806a16ede3
# ╠═4f0975d8-f329-11ea-3d10-59a503f8d6b2
# ╟─7eaa57d2-f368-11ea-1a70-c7c7e54bd0b1
# ╠═fd819dac-f368-11ea-33bb-17148387546a
# ╟─8d558c4c-f328-11ea-0055-730ead5d5c34
# ╟─318a2256-f369-11ea-23a9-2f74c566549b
# ╟─7a44ba52-f318-11ea-0406-4731c80c1007
# ╠═6c7e4b54-f318-11ea-2055-d9f9c0199341
# ╠═74059d04-f319-11ea-29b4-85f5f8f5c610
# ╟─0b9ead92-f318-11ea-3744-37150d649d43
# ╠═d184e9cc-f318-11ea-1a1e-994ab1330c1a
# ╠═cdfb3508-f319-11ea-1486-c5c58a0b9177
# ╠═f010933c-f318-11ea-22c5-4d2e64cd9629
# ╟─5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
# ╠═6f37b34c-f31a-11ea-2909-4f2079bf66ec
# ╠═c349ad24-f31e-11ea-2ae8-c9e380c25f9d
# ╟─64c78e00-f31f-11ea-1392-e315a79fdf56
# ╟─87afabf8-f317-11ea-3cb3-29dced8e265a
# ╟─8ba9f5fc-f31b-11ea-00fe-79ecece09c25
# ╠═abf20aa0-f31b-11ea-2548-9bea4fab4c37
# ╟─52452d26-f36c-11ea-01a6-313114b4445d
# ╟─9101d5a0-f371-11ea-1c04-f3f43b96ca4a
# ╠═8ec27ef8-f320-11ea-2573-c97b7b908cb7
# ╟─8bc930f0-f372-11ea-06cb-79ced2834720
# ╠═85033040-f372-11ea-2c31-bb3147de3c0d
# ╟─c572f6ce-f372-11ea-3c9a-e3a21384edca
# ╠═6d993a5c-f373-11ea-0dde-c94e3bbd1552
# ╟─ea417c2a-f373-11ea-3bb0-b1b5754f2fac
# ╟─56a7f954-f374-11ea-0391-f79b75195f4d
# ╠═b1d09bc8-f320-11ea-26bb-0101c9a204e2
# ╟─cf39fa2a-f374-11ea-0680-55817de1b837
# ╠═be7d40e2-f320-11ea-1b56-dff2a0a16e8d
# ╠═24792456-f37b-11ea-07b2-4f4c8caea633
# ╠═ff055726-f320-11ea-32f6-2bf38d7dd310
# ╟─92e19f22-f37b-11ea-25f7-e321337e375e
# ╠═795eb2c4-f37b-11ea-01e1-1dbac3c80c13
# ╠═437ba6ce-f37d-11ea-1010-5f6a6e282f9b
# ╠═0e706bc4-f321-11ea-1e9a-71352fbe2e95
# ╠═4240988e-f321-11ea-1e56-a90b3bf4d7ce
# ╠═6bdbcf4c-f321-11ea-0288-fb16ff1ec526
# ╟─0fbe2af6-f381-11ea-2f41-23cd1cf930d9
# ╟─48089a00-f321-11ea-1479-e74ba71df067
# ╟─ffc17f40-f380-11ea-30ee-0fe8563c0eb1
# ╟─ffc40ab2-f380-11ea-2136-63542ff0f386
# ╟─ffceaed6-f380-11ea-3c63-8132d270b83f
# ╟─ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
# ╟─ffe326e0-f380-11ea-3619-61dd0592d409
# ╟─fff5aedc-f380-11ea-2a08-99c230f8fa32
# ╟─00026442-f381-11ea-2b41-bde1fff66011
# ╟─00115b6e-f381-11ea-0bc6-61ca119cb628
