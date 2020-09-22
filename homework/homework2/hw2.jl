### A Pluto.jl notebook ###
# v0.11.12

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
md"_homework 2, version 2.1_"

# ╔═╡ 85cfbd10-f384-11ea-31dc-b5693630a4c5
md"""

# **Homework 2**: _Dynamic programming_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 33e43c7c-f381-11ea-3abc-c942327456b1
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ ec66314e-f37f-11ea-0af4-31da0584e881
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 938185ec-f384-11ea-21dc-b56b7469f798
md"_Let's create a package environment:_"

# ╔═╡ 0d144802-f319-11ea-0028-cd97a776a3d0
#img = load(download("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg/300px-Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg"))
#img = load(download("https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg/477px-Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg"))
img = load(download("https://i.imgur.com/4SRnmkj.png"))

# ╔═╡ cc9fcdae-f314-11ea-1b9a-1f68b792f005
md"""
# Arrays: Slices and views

In the lecture (included below) we learned about what array views are. In this exercise we will add to that understanding and look at an important use of `view`s: to reduce the amount of memory allocations when reading sub-sequences within an array.

We will use the `BenchmarkTools` package to emperically understand the effects of using views.
"""

# ╔═╡ b49a21a6-f381-11ea-1a98-7f144c55c9b7
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/gTGJ80HayK0?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ b49e8cc8-f381-11ea-1056-91668ac6ae4e
md"""
## Shrinking an array

Below is a function called `remove_in_each_row(img, pixels)`. It takes a matrix `img` and a vector of integers, `pixels`, and shrinks the image by 1 pixel in width by removing the element `img[i, pixels[i]]` in every row. This function is one of the building blocks of the Image Seam algorithm we saw in the lecture.

Read it and convince yourself that it is correct.
"""

# ╔═╡ e799be82-f317-11ea-3ae4-6d13ece3fe10
function remove_in_each_row(img, column_numbers)
	@assert size(img, 1) == length(column_numbers) # same as the number of rows
	m, n = size(img)
	local img′ = similar(img, m, n-1) # create a similar image with one less column

	# The prime (′) in the variable name is written as \prime<TAB>
    # You cannot use apostrophe for this! (Apostrophe means the transpose of a matrix)

	for (i, j) in enumerate(column_numbers)
		img′[i, :] = vcat(img[i, 1:j-1], img[i, j+1:end])
	end
	img′
end

# ╔═╡ c075a8e6-f382-11ea-2263-cd9507324f4f
md"Let's use it to remove the pixels on the diagonal. These are the image dimensions before and after doing so:"

# ╔═╡ 9cced1a8-f326-11ea-0759-0b2f22e5a1db
(before=size(img), after=size(remove_in_each_row(img, 1:size(img, 1))))

# ╔═╡ 1d893998-f366-11ea-0828-512de0c44915
md"""
## **Exercise 1** - _Making it efficient_

We can use the `@benchmark` macro from the [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) package to benchmark fragments of Julia code. 

`@benchmark` takes an expression and runs it a number of times to obtain statistics about the run time and memory allocation. We generally take the minimum time as the most stable measurement of performance ([for reasons discussed in the paper on BenchmarkTools](http://www-math.mit.edu/~edelman/publications/robust_benchmarking.pdf))
"""

# ╔═╡ 59991872-f366-11ea-1036-afe313fb4ec1
md"""
First, as an example, let's benchmark the `remove_in_each_row` function we defined above by passing in our image and a some indices to remove.
"""

# ╔═╡ e501ea28-f326-11ea-252a-53949fd9ef57
performance_experiment_default = @benchmark remove_in_each_row(img, 1:size(img, 1))

# ╔═╡ f7915918-f366-11ea-2c46-2f4671ae8a22
md"""
#### Exercise 1.1

`vcat(x, y)` is used in julia to concatenate two arrays vertically. This actually creates a new array of size `length(x) + length(y)` and copies `x` and `y` into it.  We use it in `remove_in_each_row` to create rows which have one pixel less.

While using `vcat` might make it easy to write the first version of our function, it's strictly not necessary.

👉 In `remove_in_each_row_no_vcat` below, figure out a way to avoid the use of `vcat` and modify the function to avoid it.
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
performance_experiment_without_vcat = @benchmark remove_in_each_row_no_vcat(img, 1:size(img, 1))

# ╔═╡ 9e149cd2-f367-11ea-28ef-b9533e8a77bb
md"""
If you did it correctly, you should see that this benchmark shows the function running faster! And "memory estimate" should also show a smaller number, and so should "allocs estimate" which is the number of allocations done per call.
"""

# ╔═╡ ba1619d4-f389-11ea-2b3f-fd9ba71cf7e3
md"""
#### Exercise 1.2

👉 How many estimated allocations did this optimization reduce, and how can you explain most of them?
"""

# ╔═╡ e49235a4-f367-11ea-3913-f54a4a6b2d6b
no_vcat_observation = md"""
<Your answer here>
"""

# ╔═╡ 837c43a4-f368-11ea-00a3-990a45cb0cbd
md"""

#### Exercise 1.3 - `view`-based optimization

👉 In the below `remove_in_each_row_views` function, implement the same optimization to remove `vcat` and use `@view` or `@views` to avoid creating copies or slices of the `img` array.

Pluto will automatically time your change with `@benchmark` below.
"""

# ╔═╡ 90a22cc6-f327-11ea-1484-7fda90283797
function remove_in_each_row_views(img, column_numbers)
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

# ╔═╡ 3335e07c-f328-11ea-0e6c-8d38c8c0ad5b
performance_experiment_views = @benchmark begin
	remove_in_each_row_views(img, 1:size(img, 1))
end

# ╔═╡ 40d6f562-f329-11ea-2ee4-d7806a16ede3
md"Final tally:"

# ╔═╡ 4f0975d8-f329-11ea-3d10-59a503f8d6b2
(
	default = performance_experiment_default, 
	without_vcat = performance_experiment_without_vcat,
	views = performance_experiment_views,
)

# ╔═╡ dc63d32a-f387-11ea-37e2-6f3666a72e03
⧀(a, b) = minimum(a).allocs + size(img, 1) ÷ 2  < minimum(b).allocs;

# ╔═╡ 7eaa57d2-f368-11ea-1a70-c7c7e54bd0b1
md"""

#### Exercise 1.4

Nice! If you did your optimizations right, you should be able to get down the estimated allocations to a single digit number!

👉 How many allocations were avoided by adding the `@view` optimization over the `vcat` optimization? Why is this?
"""

# ╔═╡ fd819dac-f368-11ea-33bb-17148387546a
views_observation = md"""
<your answer here>
"""

# ╔═╡ 318a2256-f369-11ea-23a9-2f74c566549b
md"""
## _Brightness and Energy_
"""

# ╔═╡ 7a44ba52-f318-11ea-0406-4731c80c1007
md"""
First, we will define a `brightness` function for a pixel (a color) as the mean of the red, green and blue values.

You should use this function whenever the problem set asks you to deal with _brightness_ of a pixel.
"""

# ╔═╡ 6c7e4b54-f318-11ea-2055-d9f9c0199341
begin
	brightness(c::RGB) = mean((c.r, c.g, c.b))
	brightness(c::RGBA) = mean((c.r, c.g, c.b))
end

# ╔═╡ 74059d04-f319-11ea-29b4-85f5f8f5c610
Gray.(brightness.(img))

# ╔═╡ 0b9ead92-f318-11ea-3744-37150d649d43
md"""We provide you with a convolve function below.
"""

# ╔═╡ d184e9cc-f318-11ea-1a1e-994ab1330c1a
convolve(img, k) = imfilter(img, reflect(k)) # uses ImageFiltering.jl package
# behaves the same way as the `convolve` function used in Lecture 2
# You were asked to implement this in homework 1.

# ╔═╡ cdfb3508-f319-11ea-1486-c5c58a0b9177
float_to_color(x) = RGB(max(0, -x), max(0, x), 0)

# ╔═╡ 5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
md"""
finally we define the `energy` function which takes the Sobel gradients along x and y directions and computes the norm of the gradient for each pixel.
"""

# ╔═╡ 6f37b34c-f31a-11ea-2909-4f2079bf66ec
begin
	energy(∇x, ∇y) = sqrt.(∇x.^2 .+ ∇y.^2)
	function energy(img)
		∇y = convolve(brightness.(img), Kernel.sobel()[1])
		∇x = convolve(brightness.(img), Kernel.sobel()[2])
		energy(∇x, ∇y)
	end
end

# ╔═╡ 9fa0cd3a-f3e1-11ea-2f7e-bd73b8e3f302
float_to_color.(energy(img))

# ╔═╡ 87afabf8-f317-11ea-3cb3-29dced8e265a
md"""
## **Exercise 2** - _Building up to dynamic programming_

In this exercise and the following ones, we will use the computational problem of Seam carving. We will think through all the "gut reaction" solutions, and then finally end up with the dynamic programming solution that we saw in the lecture.

In the process we will understand the performance and accuracy of each iteration of our solution.

### How to implement the solutions:

For every variation of the algorithm, your job is to write a function which takes a matrix of energies, and an index for a pixel on the first row, and computes a "seam" starting at that pixel.

The function should return a vector of as many integers as there are rows in the input matrix where each number points out a pixel to delete from the corresponding row. (it acts as the input to `remove_in_each_row`).
"""

# ╔═╡ 8ba9f5fc-f31b-11ea-00fe-79ecece09c25
md"""
#### Exercise 2.1 - _The greedy approach_

The first approach discussed in the lecture (included below) is the _greedy approach_: you start from your top pixel, and at each step you just look at the three neighbors below. The next pixel in the seam is the neighbor with the lowest energy.

"""

# ╔═╡ f5a74dfc-f388-11ea-2577-b543d31576c6
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/rpB6zQNsbQU?start=777&end=833" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ c3543ea4-f393-11ea-39c8-37747f113b96
md"""
👉 Implement the greedy approach.
"""

# ╔═╡ 2f9cbea8-f3a1-11ea-20c6-01fd1464a592
random_seam(m, n, i) = reduce((a, b) -> [a..., clamp(last(a) + rand(-1:1), 1, n)], 1:m-1; init=[i])

# ╔═╡ abf20aa0-f31b-11ea-2548-9bea4fab4c37
function greedy_seam(energies, starting_pixel::Int)
	# you can delete the body of this function - it's just a placeholder.
	random_seam(size(energies)..., starting_pixel)
end

# ╔═╡ 5430d772-f397-11ea-2ed8-03ee06d02a22
md"Before we apply your function to our test image, let's try it out on a small matrix of energies (displayed here in grayscale), just like in the lecture snippet above (clicking on the video will take you to the right part of the video). Light pixels have high energy, dark pixels signify low energy."

# ╔═╡ f580527e-f397-11ea-055f-bb9ea8f12015
# try
# 	if length(Set(greedy_seam(greedy_test, 5))) == 1
# 		md"Right now you are seeing the placeholder function. (You haven't done the exercise yet!) This is a straight line from the starting pixel."
# 	end
# catch end

# ╔═╡ 7ddee6fc-f394-11ea-31fc-5bd665a65bef
greedy_test = Gray.(rand(Float64, (8,10)));

# ╔═╡ 6f52c1a2-f395-11ea-0c8a-138a77f03803
md"Starting pixel: $(@bind greedy_starting_pixel Slider(1:size(greedy_test, 2); show_value=true))"

# ╔═╡ 9945ae78-f395-11ea-1d78-cf6ad19606c8
md"_Let's try it on the bigger image!_"

# ╔═╡ 87efe4c2-f38d-11ea-39cc-bdfa11298317
md"Compute shrunk image: $(@bind shrink_greedy CheckBox())"

# ╔═╡ 52452d26-f36c-11ea-01a6-313114b4445d
md"""
#### Exercise 2.2 - _Recursion_

A common pattern in algorithm design is the idea of solving a problem as the combination of solutions to subproblems.

The classic example, is a [Fibonacci number](https://en.wikipedia.org/wiki/Fibonacci_number) generator.

The recursive implementation of Fibonacci looks something like this
"""

# ╔═╡ 2a98f268-f3b6-11ea-1eea-81c28256a19e
function fib(n)
    # base case (basis)
	if n == 0 || n == 1      # `||` means "or"
		return 1
	end

    # recursion (induction)
	return fib(n-1) + fib(n-2)
end

# ╔═╡ 32e9a944-f3b6-11ea-0e82-1dff6c2eef8d
md"""
Notice that you can call a function from within itself which may call itself and so on until a base case is reached. Then the program will combine the result from the base case up to the final result.

In the case of the Fibonacci function, we added the solutions to the subproblems `fib(n-1)`, `fib(n-2)` to produce `fib(n)`.

An analogy can be drawn to the process of mathematical induction in mathematics. And as with mathematical induction there are parts to constructing such a recursive algorithm:

- Defining a base case
- Defining an recursion i.e. finding a solution to the problem as a combination of solutions to smaller problems.

"""

# ╔═╡ 9101d5a0-f371-11ea-1c04-f3f43b96ca4a
md"""
👉 Define a `least_energy` function which returns:
1. the lowest possible total energy for a seam starting at the pixel at $(i, j)$;
2. the column to jump to on the next move (in row $i + 1$),
which is one of $j-1$, $j$ or $j+1$, up to boundary conditions.

Return these two values in a tuple.
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
	# combine results from recursive calls to `least_energy`.
end

# ╔═╡ a7f3d9f8-f3bb-11ea-0c1a-55bbb8408f09
md"""
This is so elegant, correct, but inefficient! If you **check this checkbox** $(@bind compute_access CheckBox()), you will see the number of accesses made to the energies array it took to compute the least energy from the pixel (1,7):
"""

# ╔═╡ 18e0fd8a-f3bc-11ea-0713-fbf74d5fa41a
md"Whoa!"

# ╔═╡ cbf29020-f3ba-11ea-2cb0-b92836f3d04b
begin
	struct AccessTrackerArray{T,N} <: AbstractArray{T, N}
		data::Array{T,N}
		accesses::Ref{Int}
	end
	track_access(x) = AccessTrackerArray(x, Ref(0))
	
	Base.IndexStyle(::Type{AccessTrackerArray}) = IndexLinear()
	
	Base.size(x::AccessTrackerArray) = size(x.data)
	Base.getindex(x::AccessTrackerArray, i::Int...) = (x.accesses[] += 1; x.data[i...])
	Base.setindex!(x::AccessTrackerArray, v, i...) = (x.accesses[] += 1; x.data[i...] = v;)
end

# ╔═╡ 8bc930f0-f372-11ea-06cb-79ced2834720
md"""
#### Exercise 2.3 - _Exhaustive search with recursion_

Now use the `least_energy` function you defined above to define the `recursive_seam` function which takes the energies matrix and a starting pixel, and computes the seam with the lowest energy from that starting pixel.

This will give you the method used in the lecture to perform [exhaustive search of all possible paths](https://youtu.be/rpB6zQNsbQU?t=839).
"""

# ╔═╡ 85033040-f372-11ea-2c31-bb3147de3c0d
function recursive_seam(energies, starting_pixel)
	m, n = size(energies)
	# Replace the following line with your code.
	[rand(1:starting_pixel) for i=1:m]
end

# ╔═╡ 1d55333c-f393-11ea-229a-5b1e9cabea6a
md"Compute shrunk image: $(@bind shrink_recursive CheckBox())"

# ╔═╡ c572f6ce-f372-11ea-3c9a-e3a21384edca
md"""
#### Exercise 2.4

- State clearly why this algorithm does an exhaustive search of all possible paths.
- How does the number of possible seam grow as n increases for a `m×n` image? (Big O notation is fine, or an approximation is fine).
"""

# ╔═╡ 6d993a5c-f373-11ea-0dde-c94e3bbd1552
exhaustive_observation = md"""
<your answer here>
"""

# ╔═╡ ea417c2a-f373-11ea-3bb0-b1b5754f2fac
md"""
## **Exercise 3** - _Memoization_

**Memoization** is the name given to the technique of storing results to expensive function calls that will be accessed more than once.

As stated in the video, the function `least_energy` is called repeatedly with the same arguments. In fact, we call it on the order of $3^n$ times, when there are only really $m \times n$ unique ways to call it!

Lets implement memoization on this function with first a [dictionary](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) for storage.
"""

# ╔═╡ 56a7f954-f374-11ea-0391-f79b75195f4d
md"""
#### Exercise 3.1 - _Dictionary as storage_

Let's make a memoized version of least_energy function which takes a dictionary and
first checks to see if the dictionary contains the key (i,j) if it does, returns the value stored in that place, if not, will compute it, and store it in the dictionary at key (i, j) and return the value it computed.


`memoized_least_energy(energies, starting_pixel, memory)`

This function must recursively call itself, and pass the same `memory` object it received as an argument.

You are expected to read and understand the [documentation on dictionaries](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) to find out how to:

1. Create a dictionary
2. Check if a key is stored in the dictionary
3. Access contents of the dictionary by a key.
"""

# ╔═╡ b1d09bc8-f320-11ea-26bb-0101c9a204e2
function memoized_least_energy(energies, i, j, memory)
	m, n = size(energies)
	
	# Replace the following line with your code.
	[starting_pixel for i=1:m]
end

# ╔═╡ 3e8b0868-f3bd-11ea-0c15-011bbd6ac051
function recursive_memoized_seam(energies, starting_pixel)
	memory = Dict{Tuple{Int,Int}, Float64}() # location => least energy.
	                                         # pass this every time you call memoized_least_energy.
	m, n = size(energies)
	
	# Replace the following line with your code.
	[rand(1:starting_pixel) for i=1:m]
end

# ╔═╡ 4e3bcf88-f3c5-11ea-3ada-2ff9213647b7
md"Compute shrunk image: $(@bind shrink_dict CheckBox())"

# ╔═╡ cf39fa2a-f374-11ea-0680-55817de1b837
md"""
### Exercise 3.2 - _Matrix as storage_

The dictionary-based memoization we tried above works well in general as there is no restriction on what type of keys can be used.

But in our particular case, we can use a matrix as a storage, since a matrix is naturally keyed by two integers.

Write a variation of `matrix_memoized_least_energy` and `matrix_memoized_seam` which use a matrix as storage.
"""

# ╔═╡ c8724b5e-f3bd-11ea-0034-b92af21ca12d
function matrix_memoized_least_energy(energies, i, j, memory)
	m, n = size(energies)
	
	# Replace the following line with your code.
	[starting_pixel for i=1:m]
end

# ╔═╡ be7d40e2-f320-11ea-1b56-dff2a0a16e8d
function matrix_memoized_seam(energies, starting_pixel)
	memory = zeros(size(energies)) # use this as storage -- intially it's all zeros
	m, n = size(energies)
	
	# Replace the following line with your code.
	[starting_pixel for i=1:m]
end

# ╔═╡ 507f3870-f3c5-11ea-11f6-ada3bb087634
md"Compute shrunk image: $(@bind shrink_matrix CheckBox())"

# ╔═╡ 24792456-f37b-11ea-07b2-4f4c8caea633
md"""
## **Exercise 4** - _Dynamic programming without recursion_ 

Now it's easy to see that the above algorithm is equivalent to one that populates the memory matrix in a for loop.

#### Exercise 4.1

👉 Write a function which takes the energies and returns the least energy matrix which has the least possible seam energy for each pixel. This was shown in the lecture, but attempt to write it on your own.
"""

# ╔═╡ ff055726-f320-11ea-32f6-2bf38d7dd310
function least_energy_matrix(energies)
	copy(energies)
end

# ╔═╡ 92e19f22-f37b-11ea-25f7-e321337e375e
md"""
#### Exercise 4.2

👉 Write a function which, when given the matrix returned by `least_energy_matrix` and a starting pixel (on the first row), computes the least energy seam from that pixel.
"""

# ╔═╡ 795eb2c4-f37b-11ea-01e1-1dbac3c80c13
function seam_from_precomputed_least_energy(energies, starting_pixel::Int)
	least_energies = least_energy_matrix(energies)
	m, n = size(least_energies)
	
	# Replace the following line with your code.
	[starting_pixel for i=1:m]
end

# ╔═╡ 51df0c98-f3c5-11ea-25b8-af41dc182bac
md"Compute shrunk image: $(@bind shrink_bottomup CheckBox())"

# ╔═╡ 0fbe2af6-f381-11ea-2f41-23cd1cf930d9
if student.kerberos_id === "jazz"
	md"""
!!! danger "Oops!"
    **Before you submit**, remember to fill in your name and kerberos ID at the top of this notebook!
	"""
end

# ╔═╡ 6b4d6584-f3be-11ea-131d-e5bdefcc791b
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ ef88c388-f388-11ea-3828-ff4db4d1874e
function mark_path(img, path)
	img′ = copy(img)
	m = size(img, 2)
	for (i, j) in enumerate(path)
		# To make it easier to see, we'll color not just
		# the pixels of the seam, but also those adjacent to it
		for j′ in j-1:j+1
			img′[i, clamp(j′, 1, m)] = RGB(1,0,1)
		end
	end
	img′
end

# ╔═╡ 437ba6ce-f37d-11ea-1010-5f6a6e282f9b
function shrink_n(img, n, min_seam, imgs=[]; show_lightning=true)
	n==0 && return push!(imgs, img)

	e = energy(img)
	seam_energy(seam) = sum(e[i, seam[i]]  for i in 1:size(img, 1))
	_, min_j = findmin(map(j->seam_energy(min_seam(e, j)), 1:size(e, 2)))
	min_seam_vec = min_seam(e, min_j)
	img′ = remove_in_each_row(img, min_seam_vec)
	if show_lightning
		push!(imgs, mark_path(img, min_seam_vec))
	else
		push!(imgs, img′)
	end
	shrink_n(img′, n-1, min_seam, imgs)
end

# ╔═╡ f6571d86-f388-11ea-0390-05592acb9195
if shrink_greedy
	greedy_carved = shrink_n(img, 200, greedy_seam)
	md"Shrink by: $(@bind greedy_n Slider(1:200; show_value=true))"
end

# ╔═╡ f626b222-f388-11ea-0d94-1736759b5f52
if shrink_greedy
	greedy_carved[greedy_n]
end

# ╔═╡ d88bc272-f392-11ea-0efd-15e0e2b2cd4e
if shrink_recursive
	recursive_carved = shrink_n(pika, 3, recursive_seam)
	md"Shrink by: $(@bind recursive_n Slider(1:3, show_value=true))"
end

# ╔═╡ e66ef06a-f392-11ea-30ab-7160e7723a17
if shrink_recursive
	recursive_carved[recursive_n]
end

# ╔═╡ 4e3ef866-f3c5-11ea-3fb0-27d1ca9a9a3f
if shrink_dict
	dict_carved = shrink_n(img, 200, recursive_memoized_seam)
	md"Shrink by: $(@bind dict_n Slider(1:200, show_value=true))"
end

# ╔═╡ 6e73b1da-f3c5-11ea-145f-6383effe8a89
if shrink_dict
	dict_carved[dict_n]
end

# ╔═╡ 50829af6-f3c5-11ea-04a8-0535edd3b0aa
if shrink_matrix
	matrix_carved = shrink_n(img, 200, matrix_memoized_seam)
	md"Shrink by: $(@bind matrix_n Slider(1:200, show_value=true))"
end

# ╔═╡ 9e56ecfa-f3c5-11ea-2e90-3b1839d12038
if shrink_matrix
	matrix_carved[matrix_n]
end

# ╔═╡ 51e28596-f3c5-11ea-2237-2b72bbfaa001
if shrink_bottomup
	bottomup_carved = shrink_n(img, 200, seam_from_precomputed_least_energy)
	md"Shrink by: $(@bind bottomup_n Slider(1:200, show_value=true))"
end

# ╔═╡ 0a10acd8-f3c6-11ea-3e2f-7530a0af8c7f
if shrink_bottomup
	bottomup_carved[bottomup_n]
end

# ╔═╡ ef26374a-f388-11ea-0b4e-67314a9a9094
function pencil(X)
	f(x) = RGB(1-x,1-x,1-x)
	map(f, X ./ maximum(X))
end

# ╔═╡ 6bdbcf4c-f321-11ea-0288-fb16ff1ec526
function decimate(img, n)
	img[1:n:end, 1:n:end]
end

# ╔═╡ ddba07dc-f3b7-11ea-353e-0f67713727fc
# Do not make this image bigger, it will be infeasible to compute.
pika = decimate(load(download("https://art.pixilart.com/901d53bcda6b27b.png")),150)

# ╔═╡ 73b52fd6-f3b9-11ea-14ed-ebfcab1ce6aa
size(pika)

# ╔═╡ fa8e2772-f3b6-11ea-30f7-699717693164
if compute_access
	tracked = track_access(energy(pika))
	least_energy(tracked, 1,7)
	tracked.accesses[]
end

# ╔═╡ ffc17f40-f380-11ea-30ee-0fe8563c0eb1
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 9f18efe2-f38e-11ea-0871-6d7760d0b2f6
hint(md"You can call the `least_energy` function recursively within itself to obtain the least energy of the adjacent cells and add the energy at the current cell to get the total energy.")

# ╔═╡ ffc40ab2-f380-11ea-2136-63542ff0f386
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ffceaed6-f380-11ea-3c63-8132d270b83f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 980b1104-f394-11ea-0948-21002f26ee25
function visualize_seam_algorithm(algorithm, test_img, starting_pixel)
	seam = algorithm(test_img, starting_pixel)
	
	display_img = RGB.(test_img)
	for (i, j) in enumerate(seam)
		try
			display_img[i, j] = RGB(0.9, 0.3, 0.6)
		catch ex
			if ex isa BoundsError
				return keep_working("")
			end
			# the solution might give an illegal index
		end
	end
	display_img
end;

# ╔═╡ 2a7e49b8-f395-11ea-0058-013e51baa554
visualize_seam_algorithm(greedy_seam, greedy_test, greedy_starting_pixel)

# ╔═╡ ffe326e0-f380-11ea-3619-61dd0592d409
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ fff5aedc-f380-11ea-2a08-99c230f8fa32
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ e3519118-f387-11ea-0c61-e1c2de1c24c1
if performance_experiment_without_vcat ⧀ performance_experiment_default
	correct()
else
	keep_working(md"We are still using (roughly) the same number of allocations as the default implementation.")
end

# ╔═╡ d4ea4222-f388-11ea-3c8d-db0d651f5282
if performance_experiment_views ⧀ performance_experiment_default
	if minimum(performance_experiment_views).allocs < 10
		correct()
	else
		keep_working(md"We are still using (roughly) the same number of allocations as the implementation without `vcat`.")
	end
else
	keep_working(md"We are still using (roughly) the same number of allocations as the default implementation.")
end

# ╔═╡ 00026442-f381-11ea-2b41-bde1fff66011
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 145c0f58-f384-11ea-2b71-09ae83f66da2
if !@isdefined(views_observation)
	not_defined(:views_observation)
end

# ╔═╡ d7a9c000-f383-11ea-1516-cf71102d8e94
if !@isdefined(views_observation)
	not_defined(:views_observation)
end

# ╔═╡ e0622780-f3b4-11ea-1f44-59fb9c5d2ebd
if !@isdefined(least_energy_matrix)
	not_defined(:least_energy_matrix)
end

# ╔═╡ 946b69a0-f3a2-11ea-2670-819a5dafe891
if !@isdefined(seam_from_precomputed_least_energy)
	not_defined(:seam_from_precomputed_least_energy)
end

# ╔═╡ fbf6b0fa-f3e0-11ea-2009-573a218e2460
function hbox(x, y, gap=16; sy=size(y), sx=size(x))
	w,h = (max(sx[1], sy[1]),
		   gap + sx[2] + sy[2])
	
	slate = fill(RGB(1,1,1), w,h)
	slate[1:size(x,1), 1:size(x,2)] .= RGB.(x)
	slate[1:size(y,1), size(x,2) + gap .+ (1:size(y,2))] .= RGB.(y)
	slate
end

# ╔═╡ f010933c-f318-11ea-22c5-4d2e64cd9629
begin
	hbox(
		float_to_color.(convolve(brightness.(img), Kernel.sobel()[1])),
		float_to_color.(convolve(brightness.(img), Kernel.sobel()[2])))
end

# ╔═╡ 256edf66-f3e1-11ea-206e-4f9b4f6d3a3d
vbox(x,y, gap=16) = hbox(x', y')'

# ╔═╡ 00115b6e-f381-11ea-0bc6-61ca119cb628
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ c086bd1e-f384-11ea-3b26-2da9e24360ca
bigbreak

# ╔═╡ 8d558c4c-f328-11ea-0055-730ead5d5c34
bigbreak

# ╔═╡ f7eba2b6-f388-11ea-06ad-0b861c764d61
bigbreak

# ╔═╡ 4f48c8b8-f39d-11ea-25d2-1fab031a514f
bigbreak

# ╔═╡ 48089a00-f321-11ea-1479-e74ba71df067
bigbreak

# ╔═╡ Cell order:
# ╟─e6b6760a-f37f-11ea-3ae1-65443ef5a81a
# ╟─ec66314e-f37f-11ea-0af4-31da0584e881
# ╟─85cfbd10-f384-11ea-31dc-b5693630a4c5
# ╠═33e43c7c-f381-11ea-3abc-c942327456b1
# ╟─938185ec-f384-11ea-21dc-b56b7469f798
# ╠═86e1ee96-f314-11ea-03f6-0f549b79e7c9
# ╠═a4937996-f314-11ea-2ff9-615c888afaa8
# ╠═0d144802-f319-11ea-0028-cd97a776a3d0
# ╟─cc9fcdae-f314-11ea-1b9a-1f68b792f005
# ╟─b49a21a6-f381-11ea-1a98-7f144c55c9b7
# ╟─b49e8cc8-f381-11ea-1056-91668ac6ae4e
# ╠═e799be82-f317-11ea-3ae4-6d13ece3fe10
# ╟─c075a8e6-f382-11ea-2263-cd9507324f4f
# ╠═9cced1a8-f326-11ea-0759-0b2f22e5a1db
# ╟─c086bd1e-f384-11ea-3b26-2da9e24360ca
# ╟─1d893998-f366-11ea-0828-512de0c44915
# ╟─59991872-f366-11ea-1036-afe313fb4ec1
# ╠═e501ea28-f326-11ea-252a-53949fd9ef57
# ╟─f7915918-f366-11ea-2c46-2f4671ae8a22
# ╠═37d4ea5c-f327-11ea-2cc5-e3774c232c2b
# ╠═67717d02-f327-11ea-0988-bfe661f57f77
# ╟─9e149cd2-f367-11ea-28ef-b9533e8a77bb
# ╟─e3519118-f387-11ea-0c61-e1c2de1c24c1
# ╟─ba1619d4-f389-11ea-2b3f-fd9ba71cf7e3
# ╠═e49235a4-f367-11ea-3913-f54a4a6b2d6b
# ╟─145c0f58-f384-11ea-2b71-09ae83f66da2
# ╟─837c43a4-f368-11ea-00a3-990a45cb0cbd
# ╠═90a22cc6-f327-11ea-1484-7fda90283797
# ╠═3335e07c-f328-11ea-0e6c-8d38c8c0ad5b
# ╟─d4ea4222-f388-11ea-3c8d-db0d651f5282
# ╟─40d6f562-f329-11ea-2ee4-d7806a16ede3
# ╟─4f0975d8-f329-11ea-3d10-59a503f8d6b2
# ╟─dc63d32a-f387-11ea-37e2-6f3666a72e03
# ╟─7eaa57d2-f368-11ea-1a70-c7c7e54bd0b1
# ╠═fd819dac-f368-11ea-33bb-17148387546a
# ╟─d7a9c000-f383-11ea-1516-cf71102d8e94
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
# ╠═9fa0cd3a-f3e1-11ea-2f7e-bd73b8e3f302
# ╟─f7eba2b6-f388-11ea-06ad-0b861c764d61
# ╟─87afabf8-f317-11ea-3cb3-29dced8e265a
# ╟─8ba9f5fc-f31b-11ea-00fe-79ecece09c25
# ╟─f5a74dfc-f388-11ea-2577-b543d31576c6
# ╟─c3543ea4-f393-11ea-39c8-37747f113b96
# ╟─2f9cbea8-f3a1-11ea-20c6-01fd1464a592
# ╠═abf20aa0-f31b-11ea-2548-9bea4fab4c37
# ╟─5430d772-f397-11ea-2ed8-03ee06d02a22
# ╟─f580527e-f397-11ea-055f-bb9ea8f12015
# ╟─6f52c1a2-f395-11ea-0c8a-138a77f03803
# ╟─2a7e49b8-f395-11ea-0058-013e51baa554
# ╟─7ddee6fc-f394-11ea-31fc-5bd665a65bef
# ╟─980b1104-f394-11ea-0948-21002f26ee25
# ╟─9945ae78-f395-11ea-1d78-cf6ad19606c8
# ╟─87efe4c2-f38d-11ea-39cc-bdfa11298317
# ╟─f6571d86-f388-11ea-0390-05592acb9195
# ╟─f626b222-f388-11ea-0d94-1736759b5f52
# ╟─52452d26-f36c-11ea-01a6-313114b4445d
# ╠═2a98f268-f3b6-11ea-1eea-81c28256a19e
# ╟─32e9a944-f3b6-11ea-0e82-1dff6c2eef8d
# ╟─9101d5a0-f371-11ea-1c04-f3f43b96ca4a
# ╠═ddba07dc-f3b7-11ea-353e-0f67713727fc
# ╠═73b52fd6-f3b9-11ea-14ed-ebfcab1ce6aa
# ╠═8ec27ef8-f320-11ea-2573-c97b7b908cb7
# ╟─9f18efe2-f38e-11ea-0871-6d7760d0b2f6
# ╟─a7f3d9f8-f3bb-11ea-0c1a-55bbb8408f09
# ╟─fa8e2772-f3b6-11ea-30f7-699717693164
# ╟─18e0fd8a-f3bc-11ea-0713-fbf74d5fa41a
# ╟─cbf29020-f3ba-11ea-2cb0-b92836f3d04b
# ╟─8bc930f0-f372-11ea-06cb-79ced2834720
# ╠═85033040-f372-11ea-2c31-bb3147de3c0d
# ╠═1d55333c-f393-11ea-229a-5b1e9cabea6a
# ╠═d88bc272-f392-11ea-0efd-15e0e2b2cd4e
# ╠═e66ef06a-f392-11ea-30ab-7160e7723a17
# ╟─c572f6ce-f372-11ea-3c9a-e3a21384edca
# ╠═6d993a5c-f373-11ea-0dde-c94e3bbd1552
# ╠═ea417c2a-f373-11ea-3bb0-b1b5754f2fac
# ╟─56a7f954-f374-11ea-0391-f79b75195f4d
# ╠═b1d09bc8-f320-11ea-26bb-0101c9a204e2
# ╠═3e8b0868-f3bd-11ea-0c15-011bbd6ac051
# ╠═4e3bcf88-f3c5-11ea-3ada-2ff9213647b7
# ╠═4e3ef866-f3c5-11ea-3fb0-27d1ca9a9a3f
# ╠═6e73b1da-f3c5-11ea-145f-6383effe8a89
# ╟─cf39fa2a-f374-11ea-0680-55817de1b837
# ╠═c8724b5e-f3bd-11ea-0034-b92af21ca12d
# ╠═be7d40e2-f320-11ea-1b56-dff2a0a16e8d
# ╟─507f3870-f3c5-11ea-11f6-ada3bb087634
# ╠═50829af6-f3c5-11ea-04a8-0535edd3b0aa
# ╠═9e56ecfa-f3c5-11ea-2e90-3b1839d12038
# ╟─4f48c8b8-f39d-11ea-25d2-1fab031a514f
# ╟─24792456-f37b-11ea-07b2-4f4c8caea633
# ╠═ff055726-f320-11ea-32f6-2bf38d7dd310
# ╟─e0622780-f3b4-11ea-1f44-59fb9c5d2ebd
# ╟─92e19f22-f37b-11ea-25f7-e321337e375e
# ╠═795eb2c4-f37b-11ea-01e1-1dbac3c80c13
# ╠═51df0c98-f3c5-11ea-25b8-af41dc182bac
# ╠═51e28596-f3c5-11ea-2237-2b72bbfaa001
# ╠═0a10acd8-f3c6-11ea-3e2f-7530a0af8c7f
# ╟─946b69a0-f3a2-11ea-2670-819a5dafe891
# ╟─0fbe2af6-f381-11ea-2f41-23cd1cf930d9
# ╟─48089a00-f321-11ea-1479-e74ba71df067
# ╟─6b4d6584-f3be-11ea-131d-e5bdefcc791b
# ╟─437ba6ce-f37d-11ea-1010-5f6a6e282f9b
# ╟─ef88c388-f388-11ea-3828-ff4db4d1874e
# ╟─ef26374a-f388-11ea-0b4e-67314a9a9094
# ╟─6bdbcf4c-f321-11ea-0288-fb16ff1ec526
# ╟─ffc17f40-f380-11ea-30ee-0fe8563c0eb1
# ╟─ffc40ab2-f380-11ea-2136-63542ff0f386
# ╟─ffceaed6-f380-11ea-3c63-8132d270b83f
# ╟─ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
# ╟─ffe326e0-f380-11ea-3619-61dd0592d409
# ╟─fff5aedc-f380-11ea-2a08-99c230f8fa32
# ╟─00026442-f381-11ea-2b41-bde1fff66011
# ╟─fbf6b0fa-f3e0-11ea-2009-573a218e2460
# ╟─256edf66-f3e1-11ea-206e-4f9b4f6d3a3d
# ╟─00115b6e-f381-11ea-0bc6-61ca119cb628
