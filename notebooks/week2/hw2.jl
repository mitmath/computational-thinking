### A Pluto.jl notebook ###
# v0.16.0

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

# ╔═╡ 65780f00-ed6b-11ea-1ecf-8b35523a7ac0
begin
	import ImageMagick
	using Images
	using PlutoUI
	using HypertextLiteral
	using OffsetArrays
end

# ╔═╡ 83eb9ca0-ed68-11ea-0bc5-99a09c68f867
md"_homework 2, version 1_"

# ╔═╡ ac8ff080-ed61-11ea-3650-d9df06123e1f
md"""

# **Homework 2** - _convolutions_
`18.S191`, Spring 2021

`Due Date`: **Friday Mar 5, 2021 at 11:59pm EST**

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 911ccbce-ed68-11ea-3606-0384e7580d7c
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "SOLUTIONS", kerberos_id = "SOLUTIONS")

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 8ef13896-ed68-11ea-160b-3550eeabbd7d
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 5f95e01a-ee0a-11ea-030c-9dba276aba92
md"_Let's create a package environment:_"

# ╔═╡ e08781fa-ed61-11ea-13ae-91a49b5eb74a
md"""

## **Exercise 1** - _Convolutions in 1D_

As we have seen in the lectures, we can produce cool effects using the mathematical technique of **convolutions**. We input one image $M$ and get a new image $M'$ back. 

Conceptually we think of $M$ as a matrix. In practice, in Julia it will be a `Matrix` of color objects, and we may need to take that into account. Ideally, however, we should write a **generic** function that will work for any type of data contained in the matrix.

A convolution works on a small **window** of an image, i.e. a region centered around a given point $(i, j)$. We will suppose that the window is a square region with odd side length $2\ell + 1$, running from $-\ell, \ldots, 0, \ldots, \ell$.

The result of the convolution over a given window, centred at the point $(i, j)$ is a *single number*; this number is the value that we will use for $M'_{i, j}$.
(Note that neighbouring windows overlap.)

To get started, in Exercise 1 we'll restrict ourselves to convolutions in 1D.
So a window is just a 1D region from $-\ell$ to $\ell$.

"""

# ╔═╡ 80108d80-ee09-11ea-0368-31546eb0d3cc
md"""
#### Exercise 1.1

Let's create a vector `v` of random numbers of length `n=100`.
"""

# ╔═╡ 7fcd6230-ee09-11ea-314f-a542d00d582e
n = 60

# ╔═╡ 7fdb34dc-ee09-11ea-366b-ffe10d1aa845
v = rand(n)

# ╔═╡ 7fe9153e-ee09-11ea-15b3-6f24fcc20734
md"_Feel free to experiment with different values!_

Let's use the function `colored_line` to view this 1D number array as a 1D image.
"

# ╔═╡ ff70782e-e8d2-4281-9b24-d45c925f55e2
begin
	colored_line(x::Vector) = hcat(Gray.(Float64.(x)))'
	colored_line(x::Any) = nothing
end

# ╔═╡ 01070e28-ee0f-11ea-1928-a7919d452bdd
colored_line(v)

# ╔═╡ 7522f81e-ee1c-11ea-35af-a17eb257ff1a
md"👉 Try changing `n` and `v` around. Notice that you can run the cell `v = rand(n)` again to regenerate new random values."

# ╔═╡ 801d90c0-ee09-11ea-28d6-61b806de26dc
md"""
#### Exercise 1.2
We need to decide how to handle the **boundary conditions**, i.e. what happens if we try to access a position in the vector `v` beyond `1:n`.  The simplest solution is to assume that $v_{i}$ is 0 outside the original vector; however, this may lead to strange boundary effects.
    
A better solution is to use the *closest* value that is inside the vector. Effectively we are extending the vector and copying the extreme values into the extended positions. (Indeed, this is one way we could implement this; these extra positions are called **ghost cells**.)

👉 Write a function `extend(v, i)` that checks whether the position $i$ is inside `1:n`. If so, return the $(HTML("<br>")) ``i``th component of `v`; otherwise, return the nearest end value.
"""

# ╔═╡ 802bec56-ee09-11ea-043e-51cf1db02a34
function extend(v::AbstractVector, i)
	
	return missing
end

# ╔═╡ b7f3994c-ee1b-11ea-211a-d144db8eafc2
md"_Some test cases:_"

# ╔═╡ 3492b164-7065-48e8-978b-6c96b965d376
example_vector = [0.8, 0.2, 0.1, 0.7, 0.6, 0.4]

# ╔═╡ 02123165-2a0a-49a8-b7a9-458955523511
colored_line(example_vector)

# ╔═╡ 806e5766-ee0f-11ea-1efc-d753cd83d086
md"- Extended with 0:"

# ╔═╡ 38da843a-ee0f-11ea-01df-bfa8b1317d36
colored_line([0, 0, example_vector..., 0, 0])

# ╔═╡ 9bde9f92-ee0f-11ea-27f8-ffef5fce2b3c
md"- Extended with your `extend` function:"

# ╔═╡ 431ba330-0f72-416a-92e9-55f51ff3bcd1
md"""
#### Exercise 1.3
👉 Write (or copy) the `mean` function from Homework 1, which takes a vector and returns the mean.

"""

# ╔═╡ 5fdc5d0d-a52c-476e-b3b5-3b6364b706e4
function mean(v)
	
	return missing
end

# ╔═╡ e84c9cc2-e6e1-46f1-bf4e-9605da5e6f4a
md"""

👉 Write a function `box_blur(v, l)` that blurs a vector `v` with a window of length `l` by averaging the elements within a window from $-\ell$ to $\ell$. This is called a **box blur**. Use your function `extend` to handle the boundaries correctly.

Return a vector of the same size as `v`.
"""

# ╔═╡ 807e5662-ee09-11ea-3005-21fdcc36b023
function box_blur(v::AbstractArray, l)
	
	return missing
end

# ╔═╡ 4f08ebe8-b781-4a32-a218-5ecd8338561d
colored_line(box_blur(example_vector, 1))

# ╔═╡ 808deca8-ee09-11ea-0ee3-1586fa1ce282
let
	try
		test_v = rand(n)
		original = copy(test_v)
		box_blur(test_v, 5)
		if test_v != original
			md"""
			!!! danger "Oopsie!"
			    It looks like your function _modifies_ `v`. Can you write it without doing so? Maybe you can use `copy`.
			"""
		end
	catch
	end
end

# ╔═╡ 809f5330-ee09-11ea-0e5b-415044b6ac1f
md"""
#### Exercise 1.4
👉 Apply the box blur to your vector `v`. Show the original and the new vector by creating two cells that call `colored_line`. Make the parameter $\ell$ interactive, and call it `l_box` instead of `l` to avoid a naming conflict.
"""

# ╔═╡ e555a7e6-f11a-43ac-8218-6d832f0ce251


# ╔═╡ 302f0842-453f-47bd-a74c-7942d8c96485


# ╔═╡ 7d80a1ea-a0a9-41b2-9cfe-a334717ab2f4


# ╔═╡ 80ab64f4-ee09-11ea-29b4-498112ed0799
md"""
#### Exercise 1.5
The box blur is a simple example of a **convolution**, i.e. a linear function of a window around each point, given by 

$$v'_{i} = \sum_{m}  \, v_{i - m} \, k_{m},$$

where $k$ is a vector called a **kernel**.
    
Again, we need to take care about what happens if $v_{i -m }$ falls off the end of the vector.
    
👉 Write a function `convolve(v, k)` that performs this convolution. You need to think of the vector $k$ as being *centred* on the position $i$. So $m$ in the above formula runs between $-\ell$ and $\ell$, where $2\ell + 1$ is the length of the vector $k$. 

   You will either need to do the necessary manipulation of indices by hand, or use the `OffsetArrays.jl` package.
"""

# ╔═╡ 28e20950-ee0c-11ea-0e0a-b5f2e570b56e
function convolve(v::AbstractVector, k)
	
	return missing
end

# ╔═╡ cf73f9f8-ee12-11ea-39ae-0107e9107ef5
md"_Edit the cell above, or create a new cell with your own test cases!_"

# ╔═╡ fa463b71-5aa4-44a3-a67b-6b0776236243
md"""
#### Exercise 1.6

👉 Define a function `box_blur_kernel(l)` which returns a _kernel_ (i.e. a vector) which, when used as the kernel in `convolve`, will reproduce a box blur of length `l`.
"""

# ╔═╡ 8a7d3cfd-6f19-43f0-ae16-d5a236f148e7
function box_blur_kernel(l)
	
	return missing
end

# ╔═╡ a34d1ad8-3776-4bc4-93e5-72cfffc54f15
@bind box_kernel_l Slider(1:5)

# ╔═╡ 971a801d-9c46-417a-ad31-1144894fb4e1
box_blur_kernel_test = box_blur_kernel(box_kernel_l)

# ╔═╡ 5f13b1a5-8c7d-47c9-b96a-a09faf38fe5e
md"""
Let's apply your kernel to our test vector `v` (first cell), and compare the result to our previous box blur function (second cell). The two should be identical.
"""

# ╔═╡ bbe1a562-8d97-4112-a88a-c45c260f574d
let
	result = box_blur(v, box_kernel_l)
	colored_line(result)
end

# ╔═╡ 03f91a22-1c3e-4c42-9d78-1ee36851a120
md"""
#### Exercise 1.7
👉 Write a function `gaussian_kernel`.

The definition of a Gaussian in 1D is

$$G(x) = \frac{1}{\sqrt{2\pi \sigma^2}} \exp \left( \frac{-x^2}{2\sigma^2} \right),$$

or as a Julia function:
"""

# ╔═╡ 48530f0d-49b4-4aec-8109-d69f1ef7f0ee
md"""
Write a function `gauss` that takes `σ` as a keyword argument and implements this function.
"""

# ╔═╡ beb62fda-38a6-4528-a176-cfb726f4b5bd
gauss(x::Real; σ=1) = 1 / sqrt(2π*σ^2) * exp(-x^2 / (2 * σ^2))

# ╔═╡ f0d55cec-2e81-4cbb-b166-2cf4f2a0f43f
md"""
We need to **sample** (i.e. evaluate) this at each pixel in an interval of length $2n+1$,
and then **normalize** so that the sum of the resulting kernel is 1.
"""

# ╔═╡ 1c8b4658-ee0c-11ea-2ede-9b9ed7d3125e
function gaussian_kernel_1D(n; σ = 1)
	
	return missing
end

# ╔═╡ a6149507-d5ba-45c1-896a-3487070d36ec
colored_line(gaussian_kernel_1D(4; σ=1))

# ╔═╡ f8bd22b8-ee14-11ea-04aa-ab16fd01826e
md"""
You can edit the cell above to test your kernel function!

Let's try applying it in a convolution.
"""

# ╔═╡ 2a9dd06a-ee13-11ea-3f84-67bb309c77a8
@bind gaussian_kernel_size_1D Slider(0:6)

# ╔═╡ ce24e486-df27-4780-bc57-d3bf7bee83bb
function create_bar()
	x = zeros(100)
	x[41:60] .= 1
	x
end

# ╔═╡ b01858b6-edf3-11ea-0826-938d33c19a43
md"""
 
   
## **Exercise 2** - _Convolutions in 2D_
    
Now let's move to 2D images. The convolution is then given by a **kernel matrix** $K$:
    
$$M'_{i, j} = \sum_{k, l}  \, M_{i- k, j - l} \, K_{k, l},$$
    
where the sum is over the possible values of $k$ and $l$ in the window. Again we think of the window as being *centered* at $(i, j)$.

A common notation for this operation is $\star$:

```math
M' = M \star K
```
"""

# ╔═╡ 7c1bc062-ee15-11ea-30b1-1b1e76520f13
md"""
#### Exercise 2.1
👉 Write a new method for `extend` that takes a matrix `M` and indices `i` and `j`, and returns the closest element of the matrix.
"""

# ╔═╡ 7c2ec6c6-ee15-11ea-2d7d-0d9401a5e5d1
function extend(M::AbstractMatrix, i, j)
	
	return missing
end

# ╔═╡ 803905b2-ee09-11ea-2d52-e77ff79693b0
extend([5,6,7], 1)

# ╔═╡ 80479d98-ee09-11ea-169e-d166eef65874
extend([5,6,7], -8)

# ╔═╡ 805691ce-ee09-11ea-053d-6d2e299ee123
extend([5,6,7], 10)

# ╔═╡ 45c4da9a-ee0f-11ea-2c5b-1f6704559137
if extend(v,1) === missing
	missing
else
	colored_line([extend(example_vector, i) for i in -1:length(example_vector)+2])
end

# ╔═╡ 9afc4dca-ee16-11ea-354f-1d827aaa61d2
md"_Let's test it!_"

# ╔═╡ cf6b05e2-ee16-11ea-3317-8919565cb56e
small_image = Gray.(rand(5,5))

# ╔═╡ e3616062-ee27-11ea-04a9-b9ec60842a64
md"- Extended with `0`:"

# ╔═╡ e5b6cd34-ee27-11ea-0d60-bd4796540b18
[get(small_image, (i, j), Gray(0)) for (i,j) in Iterators.product(-1:7,-1:7)]

# ╔═╡ b4e98589-f221-4922-b11e-364d72d0788e


# ╔═╡ d06ea762-ee27-11ea-2e9c-1bcff86a3fe0
md"- Extended with your `extend` function:"

# ╔═╡ e1dc0622-ee16-11ea-274a-3b6ec9e15ab5
[extend(small_image, i, j) for (i,j) in Iterators.product(-1:7,-1:7)]

# ╔═╡ 4bbea325-35f8-4a51-bd66-153aba4aed96
md"""
### Extending Philip
"""

# ╔═╡ c4f5a867-74ba-4106-91d4-195f6ae644d0
url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png" 

# ╔═╡ c825ebe2-511b-43ba-afdf-6226dbac48d2
philip_filename = download(url) # download to a local file. The filename is returned

# ╔═╡ 2701ab0c-b91d-47fe-b36b-4e0036ecd4aa
philip = load(philip_filename);

# ╔═╡ 84a48984-9adb-40ab-a1f1-1ab7b76c9a19
philip_head = philip[470:800, 140:410];

# ╔═╡ 3cd535e4-ee26-11ea-2482-fb4ad43dda19
[
	extend(philip_head, i, j) for 
		i in -50:size(philip_head,1)+51,
		j in -50:size(philip_head,2)+51
]

# ╔═╡ 7c41f0ca-ee15-11ea-05fb-d97a836659af
md"""
#### Exercise 2.2
👉 Implement a new method `convolve(M, K)` that applies a convolution to a 2D array `M`, using a 2D kernel `K`. Use your new method `extend` from the last exercise.
"""

# ╔═╡ 8b96e0bc-ee15-11ea-11cd-cfecea7075a0
function convolve(M::AbstractMatrix, K::AbstractMatrix)
	
	return missing
end

# ╔═╡ 93284f92-ee12-11ea-0342-833b1a30625c
test_convolution = let
	v = [1, 10, 100, 1000, 10000]
	k = [1, 1, 0]
	convolve(v, k)
end

# ╔═╡ 5eea882c-ee13-11ea-0d56-af81ecd30a4a
colored_line(test_convolution)

# ╔═╡ 338b1c3f-f071-4f80-86c0-a82c17349828
let
	result = convolve(v, box_blur_kernel_test)
	colored_line(result)
end

# ╔═╡ 38eb92f6-ee13-11ea-14d7-a503ac04302e
test_gauss_1D_a = let
	k = gaussian_kernel_1D(gaussian_kernel_size_1D)
	
	if k !== missing
		convolve(v, k)
	end
end

# ╔═╡ b424e2aa-ee14-11ea-33fa-35491e0b9c9d
colored_line(test_gauss_1D_a)

# ╔═╡ 24c21c7c-ee14-11ea-1512-677980db1288
test_gauss_1D_b = let
	v = create_bar()
	k = gaussian_kernel_1D(gaussian_kernel_size_1D)
	
	if k !== missing
		convolve(v, k)
	end
end

# ╔═╡ bc1c20a4-ee14-11ea-3525-63c9fa78f089
colored_line(test_gauss_1D_b)

# ╔═╡ 5a5135c6-ee1e-11ea-05dc-eb0c683c2ce5
md"_Let's test it out! 🎃_"

# ╔═╡ 577c6daa-ee1e-11ea-1275-b7abc7a27d73
test_image_with_border = [get(small_image, (i, j), Gray(0)) for (i,j) in Iterators.product(-1:7,-1:7)]

# ╔═╡ 275a99c8-ee1e-11ea-0a76-93e3618c9588
K_test = [
	0   0  0
	1/2 0  1/2
	0   0  0
]

# ╔═╡ 42dfa206-ee1e-11ea-1fcd-21671042064c
convolve(test_image_with_border, K_test)

# ╔═╡ 6e53c2e6-ee1e-11ea-21bd-c9c05381be07
md"_Edit_ `K_test` _to create your own test case!_"

# ╔═╡ e7f8b41a-ee25-11ea-287a-e75d33fbd98b
convolve(philip_head, K_test)

# ╔═╡ 8a335044-ee19-11ea-0255-b9391246d231
md"""
---

You can create all sorts of effects by choosing the kernel in a smart way. Today, we will implement two special kernels, to produce a **Gaussian blur** and a **Sobel edge detection** filter.

Make sure that you have watched the lecture about convolutions!
"""

# ╔═╡ 79eb0775-3582-446b-996a-0b64301394d0
md"""
#### Exercise 2.3
The 2D Gaussian kernel will be defined using

$$G(x,y)=\frac{1}{2\pi \sigma^2}\exp\left(\frac{-(x^2+y^2)}{2\sigma^2}\right)$$

How can you express this mathematically using the 1D Gaussian function that we defined before?
"""

# ╔═╡ f4d9fd6f-0f1b-4dec-ae68-e61550cee790
gauss(x, y; σ=1) = 2π*σ^2 * gauss(x; σ=σ) * gauss(y; σ=σ)

# ╔═╡ 7c50ea80-ee15-11ea-328f-6b4e4ff20b7e
md"""
👉 Write a function that applies a **Gaussian blur** to an image. Use your previous functions, and add cells to write helper functions as needed!
"""

# ╔═╡ aad67fd0-ee15-11ea-00d4-274ec3cda3a3
function with_gaussian_blur(image; σ=3, l=5)
	
	return missing
end

# ╔═╡ 8ae59674-ee18-11ea-3815-f50713d0fa08
md"_Let's make it interactive. 💫_"

# ╔═╡ 96146b16-79ea-401f-b8ba-e05663a18bd8
@bind face_σ Slider(0.1:0.1:10; show_value=true)

# ╔═╡ 2cc745ce-e145-4428-af3b-926fba271b67
@bind face_l Slider(0:20; show_value=true)

# ╔═╡ d5ffc6ab-156b-4d43-ac3d-1947d0176e7f
md"""
When you set `face_σ` to a low number (e.g. `2.0`), what effect does `face_l` have? And vice versa?
"""

# ╔═╡ 7c6642a6-ee15-11ea-0526-a1aac4286cdd
md"""
#### Exercise 2.4
👉 Create a **Sobel edge detection filter**.

Here, we will need to create two filters that separately detect edges in the horizontal and vertical directions, given by the following kernels:

```math
G_x = \begin{bmatrix}
1 & 0 & -1 \\
2 & 0 & -2 \\
1 & 0 & -1 \\
\end{bmatrix};
\qquad
G_y = \begin{bmatrix}
1 & 2 & 1 \\
0 & 0 & 0 \\
-1 & -2 & -1 \\
\end{bmatrix} 
```

We can think of these filterrs as derivatives in the $x$ and $y$ directions, as we discussed in lectures.

Then we combine them by finding the magnitude of the **gradient** (in the sense of multivariate calculus) by defining

$$G_\text{total} = \sqrt{G_x^2 + G_y^2},$$

where each operation applies *element-wise* on the matrices.

Use your previous functions, and add cells to write helper functions as needed!
"""

# ╔═╡ 9eeb876c-ee15-11ea-1794-d3ea79f47b75
function with_sobel_edge_detect(image)
	
	return missing
end

# ╔═╡ 8ffe16ce-ee20-11ea-18bd-15640f94b839
if student.kerberos_id === "jazz"
	md"""
!!! danger "Oops!"
    **Before you submit**, remember to fill in your name and kerberos ID at the top of this notebook!
	"""
end

# ╔═╡ 2d9f3ae4-9e4c-49ce-aab0-5f87aba85c3e
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 5516c800-edee-11ea-12cf-3f8c082ef0ef
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ ea435e58-ee11-11ea-3785-01af8dd72360
hint(md"Have a look at the lecture notes to see examples of adding interactivity with a slider. You can read the Interactivity and the PlutoUI sample notebooks to learn more, you can find them in Pluto's main menu. _(Right click the Pluto logo in the top left -> Open in new tab)_.")

# ╔═╡ 32a07f1d-93cd-4bf3-bac1-91afa6bb88a6
md"""
You can use the `÷` operator (you type `\div<TAB>` to get it with autocomplete) to do _integer division_. For example:

```julia
8 / 6 ≈ 1.3333333 # a floating point number!

8 // 6 == 4 // 3  # a fraction!

8 ÷ 6 == 1        # an integer!
```
""" |> hint

# ╔═╡ 649df270-ee24-11ea-397e-79c4355e38db
hint(md"`num_rows, num_columns = size(M)`")

# ╔═╡ 0cabed84-ee1e-11ea-11c1-7d8a4b4ad1af
hint(md"`num_rows, num_columns = size(K)`")

# ╔═╡ 9def5f32-ee15-11ea-1f74-f7e6690f2efa
hint(md"Can we just copy the 1D code? What is different in 2D?")

# ╔═╡ 57360a7a-edee-11ea-0c28-91463ece500d
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ dcb8324c-edee-11ea-17ff-375ff5078f43
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 58af703c-edee-11ea-2963-f52e78fc2412
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ f3d00a9a-edf3-11ea-07b3-1db5c6d0b3cf
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next exercise."]

# ╔═╡ 5aa9dfb2-edee-11ea-3754-c368fb40637c
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ f0c3e99d-9eb9-459e-917a-c2338af6683c
let
	result = gaussian_kernel_1D(5)
	
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif !(result isa AbstractVector)
		keep_working(md"The returned object is not a `Vector`.")
	elseif size(result) != (11,)
		hint(md"The returned vector has the wrong dimensions.")
	elseif !(sum(result) ≈ 1.0)
		keep_working(md"You need to _normalize_ the result.")
	elseif gaussian_kernel_1D(3; σ=1) == gaussian_kernel_1D(3; σ=2)
		keep_working(md"Use the keyword argument `σ` in your function.")
	else
		correct()
	end
end

# ╔═╡ 74d44e22-edee-11ea-09a0-69aa0aba3281
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ bcf98dfc-ee1b-11ea-21d0-c14439500971
if !@isdefined(extend)
	not_defined(:extend)
else
	let
		result = extend([6,7],-10)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 6 || extend([6,7],10) != 7
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 7ffd14f8-ee1d-11ea-0343-b54fb0333aea
if !@isdefined(convolve)
	not_defined(:convolve)
else
	let
		x = [1, 10, 100]
		result = convolve(x, [0, 1, 1])
		shouldbe = [11, 110, 200]
		shouldbe2 = [2, 11, 110]

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa AbstractVector)
			keep_working(md"The returned object is not a `Vector`.")
		elseif size(result) != size(x)
			keep_working(md"The returned vector has the wrong dimensions.")
		elseif result != shouldbe && result != shouldbe2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ d93fa3f6-c361-4dfd-a2ea-f38e682bcd6a
if !@isdefined(box_blur_kernel)
	not_defined(:box_blur_kernel)
else
	let
		result = box_blur_kernel(2)
		
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa AbstractVector)
			keep_working(md"The returned object is not a `Vector`.")
		elseif size(result) != (5,)
			hint(md"The returned vector has the wrong dimensions.")
		else
			
			x = [1, 10, 100]
			result1 = box_blur(x, 2)
			result2 = convolve(x, result)
			
			if result1 ≈ result2
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ efd1ceb4-ee1c-11ea-350e-f7e3ea059024
if !@isdefined(extend)
	not_defined(:extend)
else
	let
		input = [42 37; 1 0]
		result = extend(input, -2, -2)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 42 || extend(input, -1, 3) != 37
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 115ded8c-ee0a-11ea-3493-89487315feb7
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 54056a02-ee0a-11ea-101f-47feb6623bec
bigbreak

# ╔═╡ a3067222-a83a-47b8-91c3-24ad78dd65c5
bigbreak

# ╔═╡ 27847dc4-ee0a-11ea-0651-ebbbb3cfd58c
bigbreak

# ╔═╡ 0001f782-ee0e-11ea-1fb4-2b5ef3d241e2
bigbreak

# ╔═╡ 5842895a-ee10-11ea-119d-81e4c4c8c53b
bigbreak

# ╔═╡ dfb7c6be-ee0d-11ea-194e-9758857f7b20
function camera_input(;max_size=200, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)

	const span = currentScript.parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end

# ╔═╡ 94c0798e-ee18-11ea-3212-1533753eabb6
@bind gauss_raw_camera_data camera_input(;max_size=100)

# ╔═╡ 1a0324de-ee19-11ea-1d4d-db37f4136ad3
@bind sobel_raw_camera_data camera_input(;max_size=200)

# ╔═╡ e15ad330-ee0d-11ea-25b6-1b1b3f3d7888

function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ f461f5f2-ee18-11ea-3d03-95f57f9bf09e
gauss_camera_image = process_raw_camera_data(gauss_raw_camera_data);

# ╔═╡ a75701c4-ee18-11ea-2863-d3042e71a68b
with_gaussian_blur(gauss_camera_image; σ=face_σ, l=face_l)

# ╔═╡ 1ff6b5cc-ee19-11ea-2ca8-7f00c204f587
sobel_camera_image = Gray.(process_raw_camera_data(sobel_raw_camera_data));

# ╔═╡ 1bf94c00-ee19-11ea-0e3c-e12bc68d8e28
Gray.(with_sobel_edge_detect(sobel_camera_image))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageMagick = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
OffsetArrays = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.0"
ImageMagick = "~1.2.1"
Images = "~0.24.1"
OffsetArrays = "~1.10.6"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "d84c956c4c0548b4caf0e4e96cf5b6494b5b1529"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.1.32"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "a4d07a1c313392a77042855df46c5f534076fab9"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.0"

[[AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "d127d5e4d86c7680b20c35d40b503c74b9a39b5e"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.4"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4ce9393e871aca86cc457d9f66976c3da6902ea7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.4.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "a66a8e024807c4b3d186eb1cab2aff3505271f8e"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.6"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "4866e381721b30fac8dda4c8cb1d9db45c8d2994"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.37.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "6d1c23e740a586955645500bbec662476204a52c"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.1"

[[CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[DataAPI]]
git-tree-sha1 = "bec2532f8adb82005476c141ec23e921fc20971b"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.8.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "9f46deb4d4ee4494ffb5a40a27a2aced67bdd838"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.4"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "8041575f021cba5a099a456b4163c9a08b566a02"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.0"

[[FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "70a0cfd9b1c86b0209e38fbfe6d8231fd606eeaf"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.1"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "463cb335fa22c4ebacfd1faba5fde14edb80d96c"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.5"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3676abafff7e4ff07bbd2c42b3d8201f31653dcc"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.9+8"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "3c041d2ac0a52a12a27af2782b34900d9c3ee68c"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.11.1"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "2c1cf4df419938ece72de17f368a021ee162762e"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.0"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[IdentityRanges]]
deps = ["OffsetArrays"]
git-tree-sha1 = "be8fcd695c4da16a1d6d0cd213cb88090a150e3b"
uuid = "bbac6d45-d8f3-5730-bfe4-7a449cd117ca"
version = "0.3.1"

[[IfElse]]
git-tree-sha1 = "28e837ff3e7a6c3cdb252ce49fb412c8eb3caeef"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.0"

[[ImageAxes]]
deps = ["AxisArrays", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "794ad1d922c432082bc1aaa9fa8ffbd1fe74e621"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.9"

[[ImageContrastAdjustment]]
deps = ["ColorVectorSpace", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "2e6084db6cccab11fe0bc3e4130bd3d117092ed9"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.7"

[[ImageCore]]
deps = ["AbstractFFTs", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "db645f20b59f060d8cfae696bc9538d13fd86416"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.8.22"

[[ImageDistances]]
deps = ["ColorVectorSpace", "Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "6378c34a3c3a216235210d19b9f495ecfff2f85f"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.13"

[[ImageFiltering]]
deps = ["CatIndices", "ColorVectorSpace", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageCore", "LinearAlgebra", "OffsetArrays", "Requires", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "bf96839133212d3eff4a1c3a80c57abc7cfbf0ce"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.6.21"

[[ImageIO]]
deps = ["FileIO", "Netpbm", "OpenEXR", "PNGFiles", "TiffImages", "UUIDs"]
git-tree-sha1 = "13c826abd23931d909e4c5538643d9691f62a617"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.5.8"

[[ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[ImageMagick_jll]]
deps = ["JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1c0a2295cca535fabaf2029062912591e9b61987"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.10-12+3"

[[ImageMetadata]]
deps = ["AxisArrays", "ColorVectorSpace", "ImageAxes", "ImageCore", "IndirectArrays"]
git-tree-sha1 = "ae76038347dc4edcdb06b541595268fca65b6a42"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.5"

[[ImageMorphology]]
deps = ["ColorVectorSpace", "ImageCore", "LinearAlgebra", "TiledIteration"]
git-tree-sha1 = "68e7cbcd7dfaa3c2f74b0a8ab3066f5de8f2b71d"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.2.11"

[[ImageQualityIndexes]]
deps = ["ColorVectorSpace", "ImageCore", "ImageDistances", "ImageFiltering", "OffsetArrays", "Statistics"]
git-tree-sha1 = "1198f85fa2481a3bb94bf937495ba1916f12b533"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.2.2"

[[ImageShow]]
deps = ["Base64", "FileIO", "ImageCore", "OffsetArrays", "Requires", "StackViews"]
git-tree-sha1 = "832abfd709fa436a562db47fd8e81377f72b01f9"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.1"

[[ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "IdentityRanges", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "e4cc551e4295a5c96545bb3083058c24b78d4cf0"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.8.13"

[[Images]]
deps = ["AxisArrays", "Base64", "ColorVectorSpace", "FileIO", "Graphics", "ImageAxes", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageShow", "ImageTransformations", "IndirectArrays", "OffsetArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "8b714d5e11c91a0d945717430ec20f9251af4bd2"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.24.1"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[IndirectArrays]]
git-tree-sha1 = "c2a145a145dc03a7620af1444e0264ef907bd44f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "0.5.1"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "61aa005707ea2cebf47c8d780da8dc9bc4e0c512"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.4"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "34dc30f868e368f8a17b728a1238f3fcda43931a"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.3"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "c253236b0ed414624b083e6b72bfe891fbd2c7af"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2021.1.1+1"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[Netpbm]]
deps = ["ColorVectorSpace", "FileIO", "ImageCore"]
git-tree-sha1 = "09589171688f0039f13ebe0fdcc7288f50228b52"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.1"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "c870a0d713b51e4b49be6432eff0e26a4325afee"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.6"

[[OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "e14c485f6beee0c7a8dcf6128bf70b85f1fe201e"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.9"

[[PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "646eed6f6a5d8df6708f15ea7e02a7a2c4fe4800"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.10"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "2276ac65f1e236e0a6ea70baff3f62ad4c625345"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[Ratios]]
deps = ["Requires"]
git-tree-sha1 = "7dff99fbc740e2f8228c6878e2aad6d7c2678098"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Rotations]]
deps = ["LinearAlgebra", "StaticArrays", "Statistics"]
git-tree-sha1 = "2ed8d8a16d703f900168822d83699b8c3c1a5cd8"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.0.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "LogExpFunctions", "OpenSpecFun_jll"]
git-tree-sha1 = "a322a9493e49c5f3a10b50df3aedaf1cdb3244b7"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.6.1"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "a8f30abc7c64a39d389680b74e749cf33f872a70"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.3.3"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TiffImages]]
deps = ["ColorTypes", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "OrderedCollections", "PkgVersion", "ProgressMeter"]
git-tree-sha1 = "632a8d4dbbad6627a4d2d21b1c6ebcaeebb1e1ed"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.4.2"

[[TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "52c5f816857bfb3291c7d25420b1f4aca0a74d18"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "59e2ad8fd1591ea019a5259bd012d7aee15f995c"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─83eb9ca0-ed68-11ea-0bc5-99a09c68f867
# ╟─8ef13896-ed68-11ea-160b-3550eeabbd7d
# ╟─ac8ff080-ed61-11ea-3650-d9df06123e1f
# ╠═911ccbce-ed68-11ea-3606-0384e7580d7c
# ╟─5f95e01a-ee0a-11ea-030c-9dba276aba92
# ╠═65780f00-ed6b-11ea-1ecf-8b35523a7ac0
# ╟─54056a02-ee0a-11ea-101f-47feb6623bec
# ╟─e08781fa-ed61-11ea-13ae-91a49b5eb74a
# ╟─a3067222-a83a-47b8-91c3-24ad78dd65c5
# ╟─80108d80-ee09-11ea-0368-31546eb0d3cc
# ╠═7fcd6230-ee09-11ea-314f-a542d00d582e
# ╠═7fdb34dc-ee09-11ea-366b-ffe10d1aa845
# ╟─7fe9153e-ee09-11ea-15b3-6f24fcc20734
# ╠═01070e28-ee0f-11ea-1928-a7919d452bdd
# ╟─ff70782e-e8d2-4281-9b24-d45c925f55e2
# ╟─7522f81e-ee1c-11ea-35af-a17eb257ff1a
# ╟─801d90c0-ee09-11ea-28d6-61b806de26dc
# ╠═802bec56-ee09-11ea-043e-51cf1db02a34
# ╟─b7f3994c-ee1b-11ea-211a-d144db8eafc2
# ╠═803905b2-ee09-11ea-2d52-e77ff79693b0
# ╠═80479d98-ee09-11ea-169e-d166eef65874
# ╠═805691ce-ee09-11ea-053d-6d2e299ee123
# ╟─bcf98dfc-ee1b-11ea-21d0-c14439500971
# ╠═3492b164-7065-48e8-978b-6c96b965d376
# ╠═02123165-2a0a-49a8-b7a9-458955523511
# ╟─806e5766-ee0f-11ea-1efc-d753cd83d086
# ╠═38da843a-ee0f-11ea-01df-bfa8b1317d36
# ╟─9bde9f92-ee0f-11ea-27f8-ffef5fce2b3c
# ╟─45c4da9a-ee0f-11ea-2c5b-1f6704559137
# ╟─431ba330-0f72-416a-92e9-55f51ff3bcd1
# ╠═5fdc5d0d-a52c-476e-b3b5-3b6364b706e4
# ╟─e84c9cc2-e6e1-46f1-bf4e-9605da5e6f4a
# ╠═807e5662-ee09-11ea-3005-21fdcc36b023
# ╠═4f08ebe8-b781-4a32-a218-5ecd8338561d
# ╟─808deca8-ee09-11ea-0ee3-1586fa1ce282
# ╟─809f5330-ee09-11ea-0e5b-415044b6ac1f
# ╠═e555a7e6-f11a-43ac-8218-6d832f0ce251
# ╠═302f0842-453f-47bd-a74c-7942d8c96485
# ╠═7d80a1ea-a0a9-41b2-9cfe-a334717ab2f4
# ╟─ea435e58-ee11-11ea-3785-01af8dd72360
# ╟─80ab64f4-ee09-11ea-29b4-498112ed0799
# ╠═28e20950-ee0c-11ea-0e0a-b5f2e570b56e
# ╟─32a07f1d-93cd-4bf3-bac1-91afa6bb88a6
# ╟─5eea882c-ee13-11ea-0d56-af81ecd30a4a
# ╠═93284f92-ee12-11ea-0342-833b1a30625c
# ╟─cf73f9f8-ee12-11ea-39ae-0107e9107ef5
# ╟─7ffd14f8-ee1d-11ea-0343-b54fb0333aea
# ╟─fa463b71-5aa4-44a3-a67b-6b0776236243
# ╠═8a7d3cfd-6f19-43f0-ae16-d5a236f148e7
# ╟─a34d1ad8-3776-4bc4-93e5-72cfffc54f15
# ╠═971a801d-9c46-417a-ad31-1144894fb4e1
# ╟─5f13b1a5-8c7d-47c9-b96a-a09faf38fe5e
# ╠═338b1c3f-f071-4f80-86c0-a82c17349828
# ╠═bbe1a562-8d97-4112-a88a-c45c260f574d
# ╟─d93fa3f6-c361-4dfd-a2ea-f38e682bcd6a
# ╟─03f91a22-1c3e-4c42-9d78-1ee36851a120
# ╟─48530f0d-49b4-4aec-8109-d69f1ef7f0ee
# ╠═beb62fda-38a6-4528-a176-cfb726f4b5bd
# ╟─f0d55cec-2e81-4cbb-b166-2cf4f2a0f43f
# ╠═1c8b4658-ee0c-11ea-2ede-9b9ed7d3125e
# ╟─f0c3e99d-9eb9-459e-917a-c2338af6683c
# ╠═a6149507-d5ba-45c1-896a-3487070d36ec
# ╟─f8bd22b8-ee14-11ea-04aa-ab16fd01826e
# ╠═2a9dd06a-ee13-11ea-3f84-67bb309c77a8
# ╠═b424e2aa-ee14-11ea-33fa-35491e0b9c9d
# ╠═38eb92f6-ee13-11ea-14d7-a503ac04302e
# ╠═bc1c20a4-ee14-11ea-3525-63c9fa78f089
# ╠═24c21c7c-ee14-11ea-1512-677980db1288
# ╟─ce24e486-df27-4780-bc57-d3bf7bee83bb
# ╟─27847dc4-ee0a-11ea-0651-ebbbb3cfd58c
# ╟─b01858b6-edf3-11ea-0826-938d33c19a43
# ╟─7c1bc062-ee15-11ea-30b1-1b1e76520f13
# ╠═7c2ec6c6-ee15-11ea-2d7d-0d9401a5e5d1
# ╟─649df270-ee24-11ea-397e-79c4355e38db
# ╟─9afc4dca-ee16-11ea-354f-1d827aaa61d2
# ╠═cf6b05e2-ee16-11ea-3317-8919565cb56e
# ╟─e3616062-ee27-11ea-04a9-b9ec60842a64
# ╟─e5b6cd34-ee27-11ea-0d60-bd4796540b18
# ╟─b4e98589-f221-4922-b11e-364d72d0788e
# ╟─d06ea762-ee27-11ea-2e9c-1bcff86a3fe0
# ╟─e1dc0622-ee16-11ea-274a-3b6ec9e15ab5
# ╟─efd1ceb4-ee1c-11ea-350e-f7e3ea059024
# ╟─4bbea325-35f8-4a51-bd66-153aba4aed96
# ╠═c4f5a867-74ba-4106-91d4-195f6ae644d0
# ╠═c825ebe2-511b-43ba-afdf-6226dbac48d2
# ╠═2701ab0c-b91d-47fe-b36b-4e0036ecd4aa
# ╠═84a48984-9adb-40ab-a1f1-1ab7b76c9a19
# ╠═3cd535e4-ee26-11ea-2482-fb4ad43dda19
# ╟─7c41f0ca-ee15-11ea-05fb-d97a836659af
# ╠═8b96e0bc-ee15-11ea-11cd-cfecea7075a0
# ╟─0cabed84-ee1e-11ea-11c1-7d8a4b4ad1af
# ╟─5a5135c6-ee1e-11ea-05dc-eb0c683c2ce5
# ╟─577c6daa-ee1e-11ea-1275-b7abc7a27d73
# ╠═275a99c8-ee1e-11ea-0a76-93e3618c9588
# ╠═42dfa206-ee1e-11ea-1fcd-21671042064c
# ╟─6e53c2e6-ee1e-11ea-21bd-c9c05381be07
# ╠═e7f8b41a-ee25-11ea-287a-e75d33fbd98b
# ╟─8a335044-ee19-11ea-0255-b9391246d231
# ╟─79eb0775-3582-446b-996a-0b64301394d0
# ╠═f4d9fd6f-0f1b-4dec-ae68-e61550cee790
# ╟─7c50ea80-ee15-11ea-328f-6b4e4ff20b7e
# ╠═aad67fd0-ee15-11ea-00d4-274ec3cda3a3
# ╟─9def5f32-ee15-11ea-1f74-f7e6690f2efa
# ╟─8ae59674-ee18-11ea-3815-f50713d0fa08
# ╟─94c0798e-ee18-11ea-3212-1533753eabb6
# ╠═a75701c4-ee18-11ea-2863-d3042e71a68b
# ╠═96146b16-79ea-401f-b8ba-e05663a18bd8
# ╠═2cc745ce-e145-4428-af3b-926fba271b67
# ╟─d5ffc6ab-156b-4d43-ac3d-1947d0176e7f
# ╟─f461f5f2-ee18-11ea-3d03-95f57f9bf09e
# ╟─7c6642a6-ee15-11ea-0526-a1aac4286cdd
# ╠═9eeb876c-ee15-11ea-1794-d3ea79f47b75
# ╠═1a0324de-ee19-11ea-1d4d-db37f4136ad3
# ╠═1bf94c00-ee19-11ea-0e3c-e12bc68d8e28
# ╟─1ff6b5cc-ee19-11ea-2ca8-7f00c204f587
# ╟─0001f782-ee0e-11ea-1fb4-2b5ef3d241e2
# ╟─8ffe16ce-ee20-11ea-18bd-15640f94b839
# ╟─5842895a-ee10-11ea-119d-81e4c4c8c53b
# ╟─2d9f3ae4-9e4c-49ce-aab0-5f87aba85c3e
# ╟─5516c800-edee-11ea-12cf-3f8c082ef0ef
# ╟─57360a7a-edee-11ea-0c28-91463ece500d
# ╟─dcb8324c-edee-11ea-17ff-375ff5078f43
# ╟─58af703c-edee-11ea-2963-f52e78fc2412
# ╟─f3d00a9a-edf3-11ea-07b3-1db5c6d0b3cf
# ╟─5aa9dfb2-edee-11ea-3754-c368fb40637c
# ╟─74d44e22-edee-11ea-09a0-69aa0aba3281
# ╟─115ded8c-ee0a-11ea-3493-89487315feb7
# ╟─dfb7c6be-ee0d-11ea-194e-9758857f7b20
# ╟─e15ad330-ee0d-11ea-25b6-1b1b3f3d7888
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
