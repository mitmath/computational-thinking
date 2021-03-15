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

# ╔═╡ a4937996-f314-11ea-2ff9-615c888afaa8
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Images", version="0.23"),
        Pkg.PackageSpec(name="ImageMagick", version="1"),
        Pkg.PackageSpec(name="TestImages", version="1"),
        Pkg.PackageSpec(name="ImageFiltering", version="0.6"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="BenchmarkTools", version="0.6"),
    ])
    using Images, TestImages, ImageFiltering, Statistics, PlutoUI, BenchmarkTools
end

# ╔═╡ e6b6760a-f37f-11ea-3ae1-65443ef5a81a
md"_homework 3, version 3_"

# ╔═╡ 85cfbd10-f384-11ea-31dc-b5693630a4c5
md"""

# **Homework 4**: _Dynamic programming_
`18.S191`, Spring 2021

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
md"""
#### Intializing packages
_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 0f271e1d-ae16-4eeb-a8a8-37951c70ba31
all_image_urls = [
	"https://wisetoast.com/wp-content/uploads/2015/10/The-Persistence-of-Memory-salvador-deli-painting.jpg" => "Salvador Dali — The Persistence of Memory (replica)",
	"https://i.imgur.com/4SRnmkj.png" => "Frida Kahlo — The Bride Frightened at Seeing Life Opened",
	"https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg/477px-Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg" => "Hilma Klint - The Swan No. 1",
	"https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg/300px-Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg" => "Piet Mondriaan - Composition with Red, Blue and Yellow",
	"https://user-images.githubusercontent.com/6933510/110993432-950df980-8377-11eb-82e7-b7ce4a0d04bc.png" => "Mario",
]

# ╔═╡ 6dabe5e2-c851-4a2e-8b07-aded451d8058
md"""
### Choose your image

 $(@bind image_url Select(all_image_urls))

Maximum image size: $(@bind max_height_str Select(string.([50,100,200,500]))) pixels. _(Using a large image might lead to long runtimes in the later exercises.)_
"""

# ╔═╡ 0d144802-f319-11ea-0028-cd97a776a3d0
img_original = load(download(image_url));

# ╔═╡ a5271c38-ba45-416b-94a4-ba608c25b897
max_height = parse(Int, max_height_str)

# ╔═╡ 365349c7-458b-4a6d-b067-5112cb3d091f
"Decimate an image such that its new height is at most `height`."
function decimate_to_height(img, height)
	factor = max(1, 1 + size(img, 1) ÷ height)
	img[1:factor:end, 1:factor:end]
end

# ╔═╡ ab276048-f34b-42dd-b6bf-0b83c6d99e6a
img = decimate_to_height(img_original, max_height)

# ╔═╡ b49e8cc8-f381-11ea-1056-91668ac6ae4e
md"""
## Cutting a seam

Below is a function called `remove_in_each_row(img, pixels)`. It takes a matrix `img` and a vector of integers, `pixels`, and shrinks the image by 1 pixel in width by removing the element `img[i, pixels[i]]` in every row. This function is one of the building blocks of the Image Seam algorithm we saw in the lecture.

Read it and convince yourself that it is correct.
"""

# ╔═╡ 90a22cc6-f327-11ea-1484-7fda90283797
function remove_in_each_row(img::Matrix, column_numbers::Vector)
	m, n = size(img)
	@assert m == length(column_numbers) # same as the number of rows

	local img′ = similar(img, m, n-1) # create a similar image with one column less

	for (i, j) in enumerate(column_numbers)
		img′[i, 1:j-1] .= @view img[i, 1:(j-1)]
		img′[i, j:end] .= @view img[i, (j+1):end]
	end
	img′
end

# ╔═╡ 5370bf57-1341-4926-b012-ba58780217b1
removal_test_image = Gray.(rand(4,4))

# ╔═╡ c075a8e6-f382-11ea-2263-cd9507324f4f
md"Let's use our function to remove the _diagonal_ from our image. Take a close look at the images to verify that we removed the diagonal. "

# ╔═╡ 52425e53-0583-45ab-b82b-ffba77d444c8
let
	seam = [1,2,3,4]
	remove_in_each_row(removal_test_image, seam)
end

# ╔═╡ a09aa706-6e35-4536-a16b-494b972e2c03
md"""
Removing the seam `[1,1,1,1]` is equivalent to removing the first column:
"""

# ╔═╡ 268546b2-c4d5-4aa5-a57f-275c7da1450c
let
	seam = [1,1,1,1]
	remove_in_each_row(removal_test_image, seam)
end

# ╔═╡ 6aeb2d1c-8585-4397-a05f-0b1e91baaf67
md"""
If we remove the same seam twice, we remove the first two rows:
"""

# ╔═╡ 2f945ca3-e7c5-4b14-b618-1f9da019cffd
let
	seam = [1,1,1,1]
	
	result1 = remove_in_each_row(removal_test_image, seam)
	result2 = remove_in_each_row(result1, seam)
	result2
end

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
	brightness(c::Gray) = gray(c)
end

# ╔═╡ 74059d04-f319-11ea-29b4-85f5f8f5c610
Gray.(brightness.(img))

# ╔═╡ 0b9ead92-f318-11ea-3744-37150d649d43
md"""We provide you with a convolve function below.
"""

# ╔═╡ d184e9cc-f318-11ea-1a1e-994ab1330c1a
convolve(img, k) = imfilter(img, reflect(k)) # uses ImageFiltering.jl package
# behaves the same way as the `convolve` function used in our lectures and homeworks

# ╔═╡ cdfb3508-f319-11ea-1486-c5c58a0b9177
float_to_color(x) = RGB(max(0, -x), max(0, x), 0)

# ╔═╡ 5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
md"""
finally we define the `energy` function which takes the Sobel gradients along x and y directions and computes the norm of the gradient for each pixel.
"""

# ╔═╡ e9402079-713e-4cfd-9b23-279bd1d540f6
energy(∇x, ∇y) = sqrt.(∇x.^2 .+ ∇y.^2)

# ╔═╡ 6f37b34c-f31a-11ea-2909-4f2079bf66ec
function energy(img)
	∇y = convolve(brightness.(img), Kernel.sobel()[1])
	∇x = convolve(brightness.(img), Kernel.sobel()[2])
	energy(∇x, ∇y)
end

# ╔═╡ 9fa0cd3a-f3e1-11ea-2f7e-bd73b8e3f302
float_to_color.(energy(img))

# ╔═╡ 87afabf8-f317-11ea-3cb3-29dced8e265a
md"""
## **Exercise 1** - _Building up to dynamic programming_

In this exercise and the following ones, we will use the computational problem of Seam carving. We will think through all the "gut reaction" solutions, and then finally end up with the dynamic programming solution that we saw in the lecture.

In the process we will understand the performance and accuracy of each iteration of our solution.

### How to implement the solutions:

For every variation of the algorithm, your job is to write a function which takes a matrix of energies, and an index for a pixel on the first row, and computes a "seam" starting at that pixel.

The function should return a vector of as many integers as there are rows in the input matrix where each number points out a pixel to delete from the corresponding row. (it acts as the input to `remove_in_each_row`).
"""

# ╔═╡ 8ba9f5fc-f31b-11ea-00fe-79ecece09c25
md"""
#### Exercise 1.1 - _The greedy approach_

The first approach discussed in the lecture (included below) is the _greedy approach_: you start from your top pixel, and at each step you just look at the three neighbors below. The next pixel in the seam is the neighbor with the lowest energy.

"""

# ╔═╡ f5a74dfc-f388-11ea-2577-b543d31576c6
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/rpB6zQNsbQU?start=777&end=833" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ 2f9cbea8-f3a1-11ea-20c6-01fd1464a592
random_seam(m, n, i) = reduce((a, b) -> [a..., clamp(last(a) + rand(-1:1), 1, n)], 1:m-1; init=[i])

# ╔═╡ c3543ea4-f393-11ea-39c8-37747f113b96
md"""
👉 Implement the greedy approach.
"""

# ╔═╡ abf20aa0-f31b-11ea-2548-9bea4fab4c37
function greedy_seam(energies, starting_pixel::Int)
	m,n = size(energies)
	# you can delete the body of this function - it's just a placeholder.
	random_seam(size(energies)..., starting_pixel)
end

# ╔═╡ 5430d772-f397-11ea-2ed8-03ee06d02a22
md"Before we apply your function to our test image, let's try it out on a small matrix of energies (displayed here in grayscale), just like in the lecture snippet above (clicking on the video will take you to the right part of the video). Light pixels have high energy, dark pixels signify low energy."

# ╔═╡ a4d14606-7e58-4770-8532-66b875c97b70
grant_example = [
	1 8 8 3 5 4
	7 8 1 0 8 4
	8 0 4 7 2 9
	9 0 0 5 9 4
	2 4 0 2 4 5
	2 4 2 5 3 0
] ./ 10

# ╔═╡ 6f52c1a2-f395-11ea-0c8a-138a77f03803
md"Starting pixel: $(@bind greedy_starting_pixel Slider(1:size(grant_example, 2); show_value=true, default=5))"

# ╔═╡ 5057652e-2f88-40f1-82f0-55b1b5bca6f6
greedy_seam_result = greedy_seam(grant_example, greedy_starting_pixel)

# ╔═╡ 2643b00d-2bac-4868-a832-5fb8ad7f173f
let
	s = sum(grant_example[i,j] for (i,j) in enumerate(greedy_seam_result))
	md"""
	**Total energy:** $(round(s,digits=1))
	"""
end

# ╔═╡ 38f70c35-2609-4599-879d-e032cd7dc49d
Gray.(grant_example)

# ╔═╡ 9945ae78-f395-11ea-1d78-cf6ad19606c8
md"_Let's try it on the bigger image!_"

# ╔═╡ 87efe4c2-f38d-11ea-39cc-bdfa11298317
begin
	# reactive references to uncheck the checkbox when the functions are updated
	greedy_seam, img, grant_example
	
	md"Compute shrunk image: $(@bind shrink_greedy CheckBox())"
end

# ╔═╡ 52452d26-f36c-11ea-01a6-313114b4445d
md"""
#### Exercise 1.2 - _Recursion_

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
	m, n = size(energies)
	
	## base case
	# if i == something
	#    return (energies[...], ...) # no need for recursive computation in the base case!
	# end
	
	## induction
	# combine results from recursive calls to `least_energy`.
end

# ╔═╡ ad524df7-29e2-4f0d-ad72-8ecdd57e4f02
least_energy(grant_example, 1, 4)

# ╔═╡ 1add9afd-5ff5-451d-ad81-57b0e929dfe8
grant_example

# ╔═╡ 447e54f8-d3db-4970-84ee-0708ab8a9244
md"""
#### Expected output
As shown in the lecture, the optimal seam from the point (1,4) should be:
"""

# ╔═╡ 8b8da8e7-d3b5-410e-b100-5538826c0fde
grant_example_optimal_seam = [4, 3, 2, 2, 3, 3]

# ╔═╡ e1074d35-58c4-43c0-a6cb-1413ed194e25
md"""
So we expect the output of `least_energy(grant_example, 1, 4)` to be:
"""

# ╔═╡ 281b950f-2331-4666-9e45-8fd117813f45
(
	sum(grant_example[i, grant_example_optimal_seam[i]] for i in 1:6),
	grant_example_optimal_seam[2]
)

# ╔═╡ a7f3d9f8-f3bb-11ea-0c1a-55bbb8408f09
md"""
This is elegant and correct, but inefficient! Let's look at the number of accesses made to the energies array needed to compute the least energy seam of a 10x10 image:
"""

# ╔═╡ 18e0fd8a-f3bc-11ea-0713-fbf74d5fa41a
md"Whoa! We will need to optimize this later!"

# ╔═╡ cbf29020-f3ba-11ea-2cb0-b92836f3d04b
begin
	struct AccessTrackerArray{T,N} <: AbstractArray{T, N}
		data::Array{T,N}
		accesses::Ref{Int}
	end
	
	Base.IndexStyle(::Type{AccessTrackerArray}) = IndexLinear()
	
	Base.size(x::AccessTrackerArray) = size(x.data)
	Base.getindex(x::AccessTrackerArray, i::Int...) = (x.accesses[] += 1; x.data[i...])
	Base.setindex!(x::AccessTrackerArray, v, i...) = (x.accesses[] += 1; x.data[i...] = v;)
	
	
	track_access(x) = AccessTrackerArray(x, Ref(0))
	function track_access(f::Function, x::Array)
		tracked = track_access(x)
		f(tracked)
		tracked.accesses[]
	end
end

# ╔═╡ fa8e2772-f3b6-11ea-30f7-699717693164
track_access(rand(10,10)) do tracked
	least_energy(tracked, 1, 5)
end

# ╔═╡ 8bc930f0-f372-11ea-06cb-79ced2834720
md"""
#### Exercise 1.3 - _Exhaustive search with recursion_

Now use the `least_energy` function you defined above to define the `recursive_seam` function which takes the energies matrix and a starting pixel, and computes the seam with the lowest energy from that starting pixel.

This will give you the method used in the lecture to perform [exhaustive search of all possible paths](https://youtu.be/rpB6zQNsbQU?t=839).
"""

# ╔═╡ 85033040-f372-11ea-2c31-bb3147de3c0d
function recursive_seam(energies, starting_pixel)
	m, n = size(energies)
	# Replace the following line with your code.
	[rand(1:starting_pixel) for i=1:m]
end

# ╔═╡ f92ac3e4-fa70-4bcf-bc50-a36792a8baaa
md"""
We won't use this function to shrink our larger image, because it is too inefficient. (Your notebook might get stuck!) But let's try it on the small example matrix from the lecture, to verify that we have found the optimal seam.
"""

# ╔═╡ 7ac5eb8d-9dba-4700-8f3a-1e0b2addc740
recursive_seam_test = recursive_seam(grant_example, 4)

# ╔═╡ c572f6ce-f372-11ea-3c9a-e3a21384edca
md"""
#### Exercise 1.4

- State clearly why this algorithm does an exhaustive search of all possible paths.
- How does the number of possible seam grow as n increases for a `m×n` image? (Big O notation is fine, or an approximation is fine).
"""

# ╔═╡ 6d993a5c-f373-11ea-0dde-c94e3bbd1552
exhaustive_observation = md"""
<your answer here>
"""

# ╔═╡ ea417c2a-f373-11ea-3bb0-b1b5754f2fac
md"""
## **Exercise 2** - _Memoization_

**Memoization** is the name given to the technique of storing results to expensive function calls that will be accessed more than once.

As stated in the video, the function `least_energy` is called repeatedly with the same arguments. In fact, we call it on the order of $3^n$ times, when there are only really $m \times n$ unique ways to call it!

Lets implement memoization on this function with first a [dictionary](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) for storage.
"""

# ╔═╡ 56a7f954-f374-11ea-0391-f79b75195f4d
md"""
#### Exercise 2.1 - _Dictionary as storage_

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
function memoized_least_energy(energies, i, j, memory::Dict)
	m, n = size(energies)
	
	# you should start by copying the code from 
	# your (not-memoized) least_energies function.
	
end

# ╔═╡ 1947f304-fa2c-4019-8584-01ef44ef2859
memoized_least_energy_test = memoized_least_energy(grant_example, 1, 4, Dict())

# ╔═╡ 8992172e-c5b6-463e-a06e-5fe42fb9b16b
md"""
Let's see how many matrix access we have now:
"""

# ╔═╡ b387f8e8-dced-473a-9434-5334829ecfd1
track_access(rand(10,10)) do tracked
	memoized_least_energy(tracked, 1, 5, Dict())
end

# ╔═╡ 3e8b0868-f3bd-11ea-0c15-011bbd6ac051
function memoized_recursive_seam(energies, starting_pixel)
	# we set up the the _memory_: note the key type (Tuple{Int,Int}) and
	# the value type (Tuple{Float64,Int}). 
	# If you need to memoize something else, you can just use Dict() without types.
	memory = Dict{Tuple{Int,Int},Tuple{Float64,Int}}()
	
	m, n = size(energies)
	
	# Replace the following line with your code.
	
	# you should start by copying the code from 
	# your (not-memoized) recursive_seam function.
end

# ╔═╡ d941c199-ed77-47dd-8b5a-e34b864f9a79
memoized_recursive_seam(grant_example, 4)

# ╔═╡ 726280f0-682f-4b05-bf5a-688554a96287
grant_example_optimal_seam

# ╔═╡ cf39fa2a-f374-11ea-0680-55817de1b837
md"""
### Exercise 2.2 - _Matrix as storage_ (optional)

The dictionary-based memoization we tried above works well in general as there is no restriction on what type of keys can be used.

But in our particular case, we can use a matrix as a storage, since a matrix is naturally keyed by two integers.

👉 Write a variant of `matrix_memoized_least_energy` and `matrix_memoized_seam` which use a matrix as storage. 
"""

# ╔═╡ c8724b5e-f3bd-11ea-0034-b92af21ca12d
function matrix_memoized_least_energy(energies, i, j, memory::Matrix)
	m, n = size(energies)
	
	# Replace the following line with your code.
end

# ╔═╡ be7d40e2-f320-11ea-1b56-dff2a0a16e8d
function matrix_memoized_seam(energies, starting_pixel)
	memory = Matrix{Union{Nothing, Tuple{Float64,Int}}}(nothing, size(energies))

	# use me instead of you use a different element type:
	# memory = Matrix{Any}(nothing, size(energies))
	
	
	m, n = size(energies)
	
	# Replace the following line with your code.
	[starting_pixel for i=1:m]
	
	
end

# ╔═╡ 507f3870-f3c5-11ea-11f6-ada3bb087634
begin
	matrix_memoized_seam, img
	
	md"Compute shrunk image: $(@bind shrink_matrix CheckBox())"
end

# ╔═╡ 24792456-f37b-11ea-07b2-4f4c8caea633
md"""
## **Exercise 3** - _Dynamic programming without recursion_ 

Now it's easy to see that the above algorithm is equivalent to one that populates the memory matrix in a for loop.

#### Exercise 3.1

👉 Write a function which takes the energies and returns the least energy matrix which has the least possible seam energy for each pixel. This was shown in the lecture, but attempt to write it on your own.
"""

# ╔═╡ ff055726-f320-11ea-32f6-2bf38d7dd310
function least_energy_matrix(energies)
	result = copy(energies)
	m,n = size(energies)
	
	# your code here
	
	
	return result
end

# ╔═╡ d3e69cf6-61b1-42fc-9abd-42d1ae7d61b2
img_brightness = brightness.(img);

# ╔═╡ 51731519-1831-46a3-a599-d6fc2f7e4224
le_test = least_energy_matrix(img_brightness)

# ╔═╡ e06d4e4a-146c-4dbd-b742-317f638a3bd8
spooky(A::Matrix{<:Real}) = map(sqrt.(A ./ maximum(A))) do x
	RGB(.8x, x, .8x)
end

# ╔═╡ 99efaf6a-0109-4b16-89b8-f8149b6b69c2
spooky(le_test)

# ╔═╡ 92e19f22-f37b-11ea-25f7-e321337e375e
md"""
#### Exercise 3.2

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
begin
	img, seam_from_precomputed_least_energy
	md"Compute shrunk image: $(@bind shrink_bottomup CheckBox())"
end

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
	img′ = RGB.(img) # also makes a copy
	m = size(img, 2)
	for (i, j) in enumerate(path)
		if size(img, 2) > 50
			# To make it easier to see, we'll color not just
			# the pixels of the seam, but also those adjacent to it
			for j′ in j-1:j+1
				img′[i, clamp(j′, 1, m)] = RGB(1,0,1)
			end
		else
			img′[i, j] = RGB(1,0,1)
		end
	end
	img′
end

# ╔═╡ 437ba6ce-f37d-11ea-1010-5f6a6e282f9b
function shrink_n(min_seam::Function, img::Matrix{<:Colorant}, n, imgs=[];
		show_lightning=true,
	)
	
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
	shrink_n(min_seam, img′, n-1, imgs; show_lightning=show_lightning)
end

# ╔═╡ f6571d86-f388-11ea-0390-05592acb9195
if shrink_greedy
	local n = min(200, size(img, 2))
	greedy_carved = shrink_n(greedy_seam, img, n)
	md"Shrink by: $(@bind greedy_n Slider(1:n; show_value=true))"
end

# ╔═╡ f626b222-f388-11ea-0d94-1736759b5f52
if shrink_greedy
	greedy_carved[greedy_n]
end

# ╔═╡ 4e3bcf88-f3c5-11ea-3ada-2ff9213647b7
begin
	# reactive references to uncheck the checkbox when the functions are updated
	img, memoized_recursive_seam, shrink_n
	
	md"Compute shrunk image: $(@bind shrink_dict CheckBox())"
end

# ╔═╡ 4e3ef866-f3c5-11ea-3fb0-27d1ca9a9a3f
if shrink_dict
	local n = min(20, size(img, 2))
	dict_carved = shrink_n(memoized_recursive_seam, img, n)
	md"Shrink by: $(@bind dict_n Slider(1:n, show_value=true))"
end

# ╔═╡ 6e73b1da-f3c5-11ea-145f-6383effe8a89
if shrink_dict
	dict_carved[dict_n]
end

# ╔═╡ 50829af6-f3c5-11ea-04a8-0535edd3b0aa
if shrink_matrix
	local n = min(20, size(img, 2))
	matrix_carved = shrink_n(matrix_memoized_seam, img, n)
	md"Shrink by: $(@bind matrix_n Slider(1:n, show_value=true))"
end

# ╔═╡ 9e56ecfa-f3c5-11ea-2e90-3b1839d12038
if shrink_matrix
	matrix_carved[matrix_n]
end

# ╔═╡ 51e28596-f3c5-11ea-2237-2b72bbfaa001
if shrink_bottomup
	local n = min(40, size(img, 2))
	bottomup_carved = shrink_n(seam_from_precomputed_least_energy, img, n)
	md"Shrink by: $(@bind bottomup_n Slider(1:n, show_value=true))"
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

# ╔═╡ ffc17f40-f380-11ea-30ee-0fe8563c0eb1
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 9f18efe2-f38e-11ea-0871-6d7760d0b2f6
hint(md"You can call the `least_energy` function recursively within itself to obtain the least energy of the adjacent cells and add the energy at the current cell to get the total energy.")

# ╔═╡ 6435994e-d470-4cf3-9f9d-d00df183873e
hint(md"We recommend using a matrix with element type `Union{Nothing, Tuple{Float64,Int}}`, initialized to all `nothing`s. You can check whether the value at `(i,j)` has been computed before using `memory[i,j] != nothing`.")

# ╔═╡ ffc40ab2-f380-11ea-2136-63542ff0f386
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ffceaed6-f380-11ea-3c63-8132d270b83f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 1413d047-099f-48c9-bbb0-ff0a3ddb4888
begin
	function visualize_seam_algorithm(test_energies, algorithm::Function, starting_pixel::Integer)
		seam = algorithm(test_energies, starting_pixel)
		visualize_seam_algorithm(test_energies, seam)
	end
	function visualize_seam_algorithm(test_energies, seam::Vector)
	display_img = RGB.(test_energies)
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
	end
end

# ╔═╡ 2a7e49b8-f395-11ea-0058-013e51baa554
visualize_seam_algorithm(grant_example, greedy_seam_result)

# ╔═╡ ffe326e0-f380-11ea-3619-61dd0592d409
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ fff5aedc-f380-11ea-2a08-99c230f8fa32
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 9ff0ce41-327f-4bf0-958d-309cd0c0b6e5
if recursive_seam_test == grant_example_optimal_seam
	correct()
else
	keep_working()
end

# ╔═╡ 344964a8-7c6b-4720-a624-47b03483263b
let
	result = track_access(rand(10,10)) do tracked
		memoized_least_energy(tracked, 1, 5, Dict())
		end
	if result == 0
		nothing
	elseif result < 200
		correct()
	else
		keep_working(md"That's still too many accesses! Did you forget to add a result to the `memory`?")
	end
end

# ╔═╡ c1ab3d5f-8e6c-4702-ad40-6c7f787f1c43
let
	aresult = track_access(rand(10,10)) do tracked
		memoized_recursive_seam(tracked, 5)
	end
	if aresult < 200
		if memoized_recursive_seam(grant_example, 4) == grant_example_optimal_seam
			correct()
		else
			keep_working(md"The returned seam is not correct. Did you implement the non-memoized version correctly?")
		end
	else
		keep_working(md"Careful! Your `memoized_recursive_seam` is still making too many memory accesses, you may not want to run the visualization below.")
	end
end

# ╔═╡ 00026442-f381-11ea-2b41-bde1fff66011
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 414dd91b-8d05-44f0-8bbd-b15981ce1210
if !@isdefined(least_energy)
	not_defined(:least_energy)
else
	let
		result1 = least_energy(grant_example, 6, 4)
		
		if !(result1 isa Tuple)
			keep_working(md"Your function should return a _tuple_, like `(1.2, 5)`.")
		elseif !(result1 isa Tuple{Float64,Int})
			keep_working(md"Your function should return a _tuple_, like `(1.2, 5)`.")
		else
			result = least_energy(grant_example, 1, 4)
			if !(result isa Tuple{Float64,Int})
				keep_working(md"Your function should return a _tuple_, like `(1.2, 5)`.")
			else
				a,b = result

				if a ≈ 0.3 && b == 4
					almost(md"Only search the (at most) three cells that are within reach.")
				elseif a ≈ 0.6 && b == 3
					correct()
				else
					keep_working()
				end
			end
		end
	end
end

# ╔═╡ e0622780-f3b4-11ea-1f44-59fb9c5d2ebd
if !@isdefined(least_energy_matrix)
	not_defined(:least_energy_matrix)
elseif !(le_test isa Matrix{<:Real})
	keep_working(md"`least_energy_matrix` should return a 2D array of Float64 values.")
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
hbox(
	float_to_color.(convolve(brightness.(img), Kernel.sobel()[1])),
	float_to_color.(convolve(brightness.(img), Kernel.sobel()[2])),
)

# ╔═╡ 256edf66-f3e1-11ea-206e-4f9b4f6d3a3d
vbox(x,y, gap=16) = hbox(x', y')'

# ╔═╡ 00115b6e-f381-11ea-0bc6-61ca119cb628
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ c086bd1e-f384-11ea-3b26-2da9e24360ca
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
# ╠═a4937996-f314-11ea-2ff9-615c888afaa8
# ╟─0f271e1d-ae16-4eeb-a8a8-37951c70ba31
# ╟─6dabe5e2-c851-4a2e-8b07-aded451d8058
# ╠═ab276048-f34b-42dd-b6bf-0b83c6d99e6a
# ╠═0d144802-f319-11ea-0028-cd97a776a3d0
# ╟─a5271c38-ba45-416b-94a4-ba608c25b897
# ╟─365349c7-458b-4a6d-b067-5112cb3d091f
# ╟─b49e8cc8-f381-11ea-1056-91668ac6ae4e
# ╠═90a22cc6-f327-11ea-1484-7fda90283797
# ╠═5370bf57-1341-4926-b012-ba58780217b1
# ╟─c075a8e6-f382-11ea-2263-cd9507324f4f
# ╠═52425e53-0583-45ab-b82b-ffba77d444c8
# ╟─a09aa706-6e35-4536-a16b-494b972e2c03
# ╠═268546b2-c4d5-4aa5-a57f-275c7da1450c
# ╟─6aeb2d1c-8585-4397-a05f-0b1e91baaf67
# ╠═2f945ca3-e7c5-4b14-b618-1f9da019cffd
# ╟─c086bd1e-f384-11ea-3b26-2da9e24360ca
# ╟─318a2256-f369-11ea-23a9-2f74c566549b
# ╟─7a44ba52-f318-11ea-0406-4731c80c1007
# ╠═6c7e4b54-f318-11ea-2055-d9f9c0199341
# ╠═74059d04-f319-11ea-29b4-85f5f8f5c610
# ╟─0b9ead92-f318-11ea-3744-37150d649d43
# ╠═d184e9cc-f318-11ea-1a1e-994ab1330c1a
# ╠═cdfb3508-f319-11ea-1486-c5c58a0b9177
# ╠═f010933c-f318-11ea-22c5-4d2e64cd9629
# ╟─5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
# ╠═e9402079-713e-4cfd-9b23-279bd1d540f6
# ╠═6f37b34c-f31a-11ea-2909-4f2079bf66ec
# ╠═9fa0cd3a-f3e1-11ea-2f7e-bd73b8e3f302
# ╟─f7eba2b6-f388-11ea-06ad-0b861c764d61
# ╟─87afabf8-f317-11ea-3cb3-29dced8e265a
# ╟─8ba9f5fc-f31b-11ea-00fe-79ecece09c25
# ╟─f5a74dfc-f388-11ea-2577-b543d31576c6
# ╟─2f9cbea8-f3a1-11ea-20c6-01fd1464a592
# ╟─c3543ea4-f393-11ea-39c8-37747f113b96
# ╠═abf20aa0-f31b-11ea-2548-9bea4fab4c37
# ╟─5430d772-f397-11ea-2ed8-03ee06d02a22
# ╟─6f52c1a2-f395-11ea-0c8a-138a77f03803
# ╠═5057652e-2f88-40f1-82f0-55b1b5bca6f6
# ╠═2a7e49b8-f395-11ea-0058-013e51baa554
# ╟─2643b00d-2bac-4868-a832-5fb8ad7f173f
# ╟─a4d14606-7e58-4770-8532-66b875c97b70
# ╠═38f70c35-2609-4599-879d-e032cd7dc49d
# ╟─1413d047-099f-48c9-bbb0-ff0a3ddb4888
# ╟─9945ae78-f395-11ea-1d78-cf6ad19606c8
# ╟─87efe4c2-f38d-11ea-39cc-bdfa11298317
# ╟─f6571d86-f388-11ea-0390-05592acb9195
# ╟─f626b222-f388-11ea-0d94-1736759b5f52
# ╟─52452d26-f36c-11ea-01a6-313114b4445d
# ╠═2a98f268-f3b6-11ea-1eea-81c28256a19e
# ╟─32e9a944-f3b6-11ea-0e82-1dff6c2eef8d
# ╟─9101d5a0-f371-11ea-1c04-f3f43b96ca4a
# ╠═8ec27ef8-f320-11ea-2573-c97b7b908cb7
# ╠═ad524df7-29e2-4f0d-ad72-8ecdd57e4f02
# ╠═1add9afd-5ff5-451d-ad81-57b0e929dfe8
# ╟─414dd91b-8d05-44f0-8bbd-b15981ce1210
# ╟─447e54f8-d3db-4970-84ee-0708ab8a9244
# ╠═8b8da8e7-d3b5-410e-b100-5538826c0fde
# ╟─e1074d35-58c4-43c0-a6cb-1413ed194e25
# ╠═281b950f-2331-4666-9e45-8fd117813f45
# ╟─9f18efe2-f38e-11ea-0871-6d7760d0b2f6
# ╟─a7f3d9f8-f3bb-11ea-0c1a-55bbb8408f09
# ╠═fa8e2772-f3b6-11ea-30f7-699717693164
# ╟─18e0fd8a-f3bc-11ea-0713-fbf74d5fa41a
# ╟─cbf29020-f3ba-11ea-2cb0-b92836f3d04b
# ╟─8bc930f0-f372-11ea-06cb-79ced2834720
# ╠═85033040-f372-11ea-2c31-bb3147de3c0d
# ╟─f92ac3e4-fa70-4bcf-bc50-a36792a8baaa
# ╠═7ac5eb8d-9dba-4700-8f3a-1e0b2addc740
# ╠═9ff0ce41-327f-4bf0-958d-309cd0c0b6e5
# ╟─c572f6ce-f372-11ea-3c9a-e3a21384edca
# ╠═6d993a5c-f373-11ea-0dde-c94e3bbd1552
# ╟─ea417c2a-f373-11ea-3bb0-b1b5754f2fac
# ╟─56a7f954-f374-11ea-0391-f79b75195f4d
# ╠═b1d09bc8-f320-11ea-26bb-0101c9a204e2
# ╠═1947f304-fa2c-4019-8584-01ef44ef2859
# ╟─8992172e-c5b6-463e-a06e-5fe42fb9b16b
# ╠═b387f8e8-dced-473a-9434-5334829ecfd1
# ╟─344964a8-7c6b-4720-a624-47b03483263b
# ╠═3e8b0868-f3bd-11ea-0c15-011bbd6ac051
# ╠═d941c199-ed77-47dd-8b5a-e34b864f9a79
# ╠═726280f0-682f-4b05-bf5a-688554a96287
# ╟─c1ab3d5f-8e6c-4702-ad40-6c7f787f1c43
# ╟─4e3bcf88-f3c5-11ea-3ada-2ff9213647b7
# ╟─4e3ef866-f3c5-11ea-3fb0-27d1ca9a9a3f
# ╟─6e73b1da-f3c5-11ea-145f-6383effe8a89
# ╟─cf39fa2a-f374-11ea-0680-55817de1b837
# ╠═c8724b5e-f3bd-11ea-0034-b92af21ca12d
# ╟─6435994e-d470-4cf3-9f9d-d00df183873e
# ╠═be7d40e2-f320-11ea-1b56-dff2a0a16e8d
# ╟─507f3870-f3c5-11ea-11f6-ada3bb087634
# ╟─50829af6-f3c5-11ea-04a8-0535edd3b0aa
# ╟─9e56ecfa-f3c5-11ea-2e90-3b1839d12038
# ╟─4f48c8b8-f39d-11ea-25d2-1fab031a514f
# ╟─24792456-f37b-11ea-07b2-4f4c8caea633
# ╠═ff055726-f320-11ea-32f6-2bf38d7dd310
# ╟─e0622780-f3b4-11ea-1f44-59fb9c5d2ebd
# ╠═51731519-1831-46a3-a599-d6fc2f7e4224
# ╠═99efaf6a-0109-4b16-89b8-f8149b6b69c2
# ╠═d3e69cf6-61b1-42fc-9abd-42d1ae7d61b2
# ╟─e06d4e4a-146c-4dbd-b742-317f638a3bd8
# ╟─92e19f22-f37b-11ea-25f7-e321337e375e
# ╠═795eb2c4-f37b-11ea-01e1-1dbac3c80c13
# ╟─51df0c98-f3c5-11ea-25b8-af41dc182bac
# ╟─51e28596-f3c5-11ea-2237-2b72bbfaa001
# ╟─0a10acd8-f3c6-11ea-3e2f-7530a0af8c7f
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
