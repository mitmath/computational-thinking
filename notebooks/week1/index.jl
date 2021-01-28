### A Pluto.jl notebook ###
# v0.12.19

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

# ╔═╡ e91d7926-ec6e-41e7-aba2-9dca333c8aa5
html"""

<div style="margin: 5rem 0;">
<h3> <em>Chapter 1</em> </h3>
<h1 style="text-align: center; "><em>Working with images<br>and arrays</em></h1>
</div>

"""

# ╔═╡ ca1b507e-6017-11eb-34e6-6b85cd189002
md"""
# Introduction
Welcome to the Computational Thinking using Julia for Real-World Problems, at MIT in Spring 2021!

The aim of this course is to bring together concepts from computer science and applied math with coding in the modern **Julia language**, and to see how to apply these techniques to study interesting applications.

## Data are all around us
Applications of computer science in the real world use **data**, i.e. information that we can capture and **measure** in some way. Data take many forms, for example:

- Time series: 
  - Your favourite song broadcast over web "radio"
  - Stock price each second / minute / day
  - Weekly number of infections

- Video:
  - The view from a window of a self-driving car
  - A hurricane monitoring station
  - A news report about the latest political situation

- Images:
  - Diseased versus healthy tissue in a medical scan
  - Deep space via the Hubble telescope
  - Your social media account labelling your friends in your photos

In each case we will need to know how to **input** the data of interest, by downloading it, reading in the resulting file, and converting it into a form that we can use, usually numbers or text. We will also want to be able to **output** it, by visualising it in some way.

And we will need to write algorithms to **process** the data to extract the information we need, or use machine learning to "automatically" extract some date.
"""

# ╔═╡ 127daf08-601b-11eb-28c1-2139c8d1a65a
md"""

## Images 

Let's start off by looking at **images** and how we can process them. 
Although our goal is to understand how to manipulate an image in precisely the way we want to by coding algorithms, we'll take advantage of the fact that Julia already has various tools to do more mundane tasks, such as converting an image input file from its particular format into numerical data that we can use.
"""

# ╔═╡ 9eb6efd2-6018-11eb-2db8-c3ce41d9e337
md"""
## What is an image? 

If we open an image on our computer or the web and zoom in enough, we will see that it consists of many tiny squares, or **pixels** ("picture elements"). Each pixel is a block of one single colour, and the pixels are arranged in a two-dimensional square grid. 

Note that an image is already an **approximation** of the real world -- it is a two-dimensional, discrete representation of a three-dimensional reality.

"""

# ╔═╡ dd183eca-6018-11eb-2a83-2fcaeea62942
md"""
### CS: Arrays

In the computer we need to **store** the number or numbers that make up the data itself, namely some representation of the colour of each pixel, and also **represent** the fact that we have a two-dimensional grid containing colours, for example what size it is, where the data lives in memory, and how it is arrranged in memory.

A two-dimensional grid is called a **two-dimensional array** in computer science, also called a **matrix** (which is the name in mathmematics). In general, an **array** means a collection of data, stored in a block in the computer's memory.

We think of the location of one piece of data as an integer $(x, y)$ coordinate pair, for example $(2, 5)$. We will need a way to **access** the current value stored at that position in the array, and to **modify** it to a new value. 


### Representing colours

Colour is a complicated concept, having to to with the interaction of the physical properties of light with the physiological mechanisms and mental procsses by which we detect it.

We will ignore this complexity by using a standard method of representing colours in the computer as an **RGB triple** of three numbers $(r, g, b)$, giving the amount of red, of green and of blue in a colour. The final colour that we perceive is the result of "adding" the corresponding amount light of each colour; the details are fascinating, but beyond the scope of this course!
"""

# ╔═╡ e37e4d40-6018-11eb-3e1d-093266c98507
md"""
## Julia: Reading in an image file
"""

# ╔═╡ e1c9742a-6018-11eb-23ba-d974e57f78f9
md"""
To make the above concepts concrete, let's use Julia to load in an actual image and play around with it.

We'll use the `Images.jl` package to load an image from the web.

First we define a **string** containing the URL (web address). String "literals" are written using double quotes, `"..."`:
"""

# ╔═╡ 34ee0954-601e-11eb-1912-97dc2937fd52
url = "https://i.imgur.com/VGPeJ6s.jpg"   # defines a variable called `url`

# ╔═╡ 9180fbcc-601e-11eb-0c22-c920dc7ee9a9
md"""
Now let's download the image file to our local machine using the `download` function:
"""

# ╔═╡ 34ffc3d8-601e-11eb-161c-6f9a07c5fd78
download(url, "philip.jpg")  # download to a local file

# ╔═╡ abaaa980-601e-11eb-0f71-8ff02269b775
md"""
Using the `Images.jl` package we can **load** the file, which automatically converts it into usable data. We'll store the result in a variable:
"""

# ╔═╡ aafe76a6-601e-11eb-1ff5-01885c5238da
image = load("philip.jpg")

# ╔═╡ c99d2aa8-601e-11eb-3469-497a246db17c
md"""
Without us doing anything extra, we see that the Pluto notebook that we are using has recognised that we have an image object, and has automatically displayed the resulting image of Philip, the cute Welsh Pembroke corgi and co-professor of this course.
Poor Philip will undergo quite a few transformations as we go along!
"""

# ╔═╡ 6f928b30-602c-11eb-1033-71d442feff93
md"""
The first thing we might want to know is the size of the image:
"""

# ╔═╡ 75c5c85a-602c-11eb-2fb1-f7e7f2c5d04b
size(image)

# ╔═╡ 77f93eb8-602c-11eb-1f38-efa56cc93ca5
md"""
Julia returns a **tuple** (ordered pair) of two numbers. Comparing these with the picture of the image, we see that the first number is the height, i.e. the vertical number of pixels, and the second is the width.
"""

# ╔═╡ d51b24ea-6026-11eb-1040-9751bc5d0144
md"""
## Julia: types
"""

# ╔═╡ df2c1606-6026-11eb-3fa6-db4da33f5ee7
md"""
The image we have just loaded is represented as a collection of numbers. How do we know what those numbers represent? Julia gives us some information about what an object represents via the **type** of the object. This is a label that tells us how to interpret the data stored in the object. Let's ask for the type of the image object:
"""

# ╔═╡ 1b682d12-6027-11eb-0e29-ad3ba8eea2b5
typeof(image)

# ╔═╡ 1e6d9058-6027-11eb-1fe3-0730aff1479a
md"""
We see that `image` is the name of an object of type `Array{...,2}`, which is a 2D array, as expected. [On Julia 1.6 and later, this will display `Matrix{...}` instead.]

The types inside the **(curly) braces**(`{` and `}`) tell us the type of the objects  stored inside the matrix -- in our case, they are `RGB` objects. `N0f8`, in turn, denotes the way that the numbers themselves are stored inside `RGB` objects. [In fact, they are fixed-point numbers with 8 bits, normalised to the range 0 to 1.]
"""

# ╔═╡ 754f1d18-6027-11eb-1f1c-cbcbfd080094
md"""
## Julia: Indexing into an array
"""

# ╔═╡ 794d1802-6027-11eb-161a-9d520ba94a1b
md"""
Let's drill down into the data by extracting one single pixel using **indexing**; in Julia we index using **(square) brackets** (`[` and `]`):
"""

# ╔═╡ 88128656-6027-11eb-1b70-2f5fb92415d6
pixel = image[1000, 1500]

# ╔═╡ a2966c1c-6028-11eb-0d7f-cb4848097e2a
md"""
We see that in Julia an image is *just* a matrix of colour objects, and Pluto automatically knows how to display those.
"""

# ╔═╡ 89e91286-6029-11eb-20b4-ff3d4fd97e98
md"""
## Julia: Colours
"""

# ╔═╡ 9995ba72-6029-11eb-332a-3766a6d9725b
md"""
What is stored inside the `pixel` object? We can find out by typing `pixel.<TAB>`.
This gives a list of possible **completions**, which in this case are the names of the attributes of the object, i.e. the data stored inside it. Try this out in a new cell!
"""

# ╔═╡ b33f54e2-6029-11eb-36e7-63d2196873cf
md"""
We see that there are variables `r`, `g` and `b` stored inside. We can extract them using `pixel.r`, etc.:
"""

# ╔═╡ c11deb6c-6029-11eb-18ea-bb28465d7c4f
pixel.r

# ╔═╡ ca7c83e6-6029-11eb-0d2a-4b6c6b0ea2cc
md"""
We can convert this fixed-point number to a normal floating-point number using
"""

# ╔═╡ c2701070-6029-11eb-1431-a7ecf55471a8
Float64(pixel.r)

# ╔═╡ b9f135fe-60eb-11eb-20e9-eb899fc3ee13


# ╔═╡ 38a2bd3c-6029-11eb-1615-f3943cf4e466
md"""
We can make a colour object by treating the type `RGB` [from the `Colors.jl` package] as a function that takes three inputs, and passing in three floating-point numbers between 0 and 1:
"""

# ╔═╡ 4ccc3e8c-6029-11eb-2c91-bf915dc56e2b
RGB(0.1, 0.3, 0.5)

# ╔═╡ c6bfc07c-60eb-11eb-139e-f9571daace71
md"""
## Pluto: Interactivity using `@bind`
"""

# ╔═╡ 54c06316-6029-11eb-3e7b-9f9bda9465db
md"""
The Pluto notebook allows us to create sliders to manipulate the value of variables, by writing e.g.

	@bind v Slider(0:0.1:1)

to map the value of the variable `v` to a slider in the given range. [`@bind` is defined in the `PlutoUI.jl` package.]

Let's use this for the constituent parts of a colour:
"""

# ╔═╡ f99eefce-6029-11eb-221f-75110c1a1162
md"""
`rr` = $(@bind rr Slider(0:0.01:1, show_value=true))    
; `gg` = $(@bind gg Slider(0:0.01:1, show_value=true))    
; `bb` = $(@bind bb Slider(0:0.01:1, show_value=true))   
"""

# ╔═╡ f5ae3026-6029-11eb-2316-dff58f4c8df5
RGB(rr, gg, bb)

# ╔═╡ 8ddcb286-602a-11eb-3ae0-07d3c77a0f8c
md"""
## Julia: Array comprehensions

Now that we can make single colours, how about a whole palette of colours!
Let's start with all the possible colours interpolating between black, `RGB(0, 0, 0)`, and red, `RGB(1, 0, 0)`. 

We need a way to generate a **`Vector`**, i.e. a 1-dimensional array, of colours, where the red component varies from 0 to 1.  One way to do so is with an **array comprehension**. Again, square brackets correspond to an array; now we are creating one:
"""

# ╔═╡ f2ecfff8-602a-11eb-129f-29e28a17a773
@bind num_reds Slider(1:100, show_value=true)

# ╔═╡ 88933746-6028-11eb-32de-13eb6ff43e29
[RGB(i/num_reds, 0, 0) for i in 0:num_reds]

# ╔═╡ 35542e8c-6028-11eb-3d4f-0feb1ddbf6c6
md"""
Similarly way we can also create a two-dimensional matrix using an array comprehension, separating the variables using a comma (`,`):
"""

# ╔═╡ 43c7c7dc-602b-11eb-10f7-098609493a6e
md"""
red = $(@bind num_reds2 Slider(1:100, show_value=true, default=10))
; blue = $(@bind num_blues2 Slider(1:100, show_value=true, default=10))
"""

# ╔═╡ 6dcca0a2-602b-11eb-15b2-53292368c1b4
[RGB(i/num_reds2, j/num_blues2, 0) for i in 0:num_reds2, j in 0:num_blues2]

# ╔═╡ d5ac1146-6027-11eb-1254-3309a68dc47c
md"""
## Julia: Extracting subarrays with ranges
"""

# ╔═╡ 0f1339f8-602c-11eb-2c28-1f9ce4be8bf2
md"""
Let's go back to our image. We already know how to index into the array to extract one pixel. What if we wanted a block of pixels? To do that we index using a **range** object, where we specify the start and finish of the range as `start:finish`, separated by a colon:
"""

# ╔═╡ 44f8c36c-602c-11eb-073d-e5cd4605308b
image[1000:1200, 1500:1800]

# ╔═╡ 5b33bef2-602c-11eb-0fc0-9b7fc9758452
md"""
We see that indeed we have a **subarray**, that is the corresponding small piece of the total image.
"""

# ╔═╡ d86aedb2-60ec-11eb-160c-afebe6dd8f63
md"""
Suppose that instead of a subregion we instead decided that the image was too large and we wanted to reduce its size. It is, in general, impossible to do so without throwing away some of the information in the original image.

The simplest thing to do is to just pick out, say, every 10th row and column. We can do this using an extra argument in the middle of a range, which is a **step size**:
"""

# ╔═╡ 362ddfe0-60ed-11eb-2d05-2d1dbd9ea509
reduced_image = image[1:10:end, 1:10:end]

# ╔═╡ 544dec90-60ed-11eb-2c61-ffc2a7491391
md"""
Note that we can also use `end` instead of having to write explicitly the size of the array in each direction.
"""

# ╔═╡ 22974f50-6065-11eb-0027-f1ebdc3fbeda
md"""
## Julia: What is a range object?
"""

# ╔═╡ 328157d0-6065-11eb-12fb-b5e412332129
md"""
What does a range like `2:10` mean? It represents the (ordered) collection of all the integers (whole numbers) from 2 to 10. But it's not so easy to get Julia to tell us that:
"""

# ╔═╡ 5b0c5b76-6065-11eb-191c-ed9a0b1ba7e0
my_range = 2:10

# ╔═╡ a9cda1fc-6065-11eb-36f3-516ddf6549c0
md"""
In fact, to see the numbers spelled out we need to make an array instead, for example using an array comprehension:
"""

# ╔═╡ b985c8e0-6065-11eb-17e7-214233185691
[i for i in 2:10]

# ╔═╡ bd6d2372-6065-11eb-1da1-f3b5185da3d7
md"""
or using by converting the range into an `Array`, which in this case gives us a one-dimensional vector:
"""

# ╔═╡ c66edb0c-6065-11eb-2e64-911c45e36ba9
v = Array(2:10)

# ╔═╡ 96c50f64-60ec-11eb-3e11-2792214f9e19
typeof(v)

# ╔═╡ 688dbf24-6065-11eb-08f0-a59fa2b71bef
md"""
In fact, ranges are special: this range *does not store* the values from 2 to 10 -- rather, *only* the start and end points are stored, and arithmetic is used to *calculate* the intermediate values!  Nonetheless, we can still **index** into the range using brackets:
"""

# ╔═╡ 608cc414-6065-11eb-28f4-f33c12d5b1b8
my_range[1]

# ╔═╡ e75a2e94-6065-11eb-0f4d-e380e32fd333
my_range[4]

# ╔═╡ e9f8d152-6065-11eb-0324-551b0c536814
md"""
So we see that ranges *behave like* arrays, even though they are not arrays in the standard sense, since they don't store their data in a block in memory. In Julia, anything that *behaves like* an array is treated like an array; such objects are called **abstract arrays**. From the point of view of a user who looks at the object just via indexing, they *do not know* how the data is actually stored inside the object.
"""

# ╔═╡ c40435c2-60ec-11eb-26f9-4983b35b6853
md"""
## Modifying an array
"""

# ╔═╡ 8c03360e-60ed-11eb-30b8-87f9efcb9656
md"""
We can modify a single entry in an array by treating it as a variable and assigning it a new value using `=`:
"""

# ╔═╡ 95aab790-60ed-11eb-036f-c1b694312a42
reduced_image[100, 200] = RGB(0, 0, 0)

# ╔═╡ 9ce0272a-60ed-11eb-2e7b-6f06c69d7c29
md"""
If we want to modify a whole subregion, this doesn't work:
"""

# ╔═╡ f3ff32d0-60ed-11eb-07bc-f992cd3da9e8
image[10:20, 30:40] = RGB(0, 0, 0)

# ╔═╡ c13418d4-60ed-11eb-311c-55b5c28893bf
md"""
As the error message says, it makes no sense to modify an array by trying to assign a *single* value to a whole subregion. Rather, we want to assign that value to *each* element in the subregion. Julia uses the syntax `.=` to do this; we can read the `.` as "elementwise" or "pointwise", or "vectorised", meaning that the operation is carried out for *each* element:
"""

# ╔═╡ bc9082c2-60ed-11eb-2b3a-3b8cb3e11428
reduced_image[200:300, 100:150] .= RGB(1, 0, 0);

# ╔═╡ 3ac7ffa8-60ee-11eb-21da-910b06e87557
md"""
[Note that writing a semi-colon, `;`, at the end of a line suppresses (does not show) the output. In general, Julia always returns and displays the output of the last operation.]
"""

# ╔═╡ 15da808c-60ee-11eb-350c-07d3f7d2b641
reduced_image

# ╔═╡ 5b8f7626-60ee-11eb-160a-e9079209dec7
md"""
## Julia: Joining (concatenating) matrices
"""

# ╔═╡ 647fddf2-60ee-11eb-124d-5356c7014c3b
md"""
We can join (concatenate) matrices together into a larger matrix:
"""

# ╔═╡ 7d9ad134-60ee-11eb-1b2a-a7d63f3a7a2d
[reduced_image  reduced_image]

# ╔═╡ 8433b862-60ee-11eb-0cfc-add2b72997dc
[reduced_image  reverse(reduced_image, dims=2)]

# ╔═╡ ace86c8a-60ee-11eb-34ef-93c54abc7b1a
md"""
## Summary
"""

# ╔═╡ b08e57e4-60ee-11eb-0e1a-2f49c496668b
md"""
Here is a summary of the main ideas from today's notebook:
- Images are **arrays** of colours
- Colours are **objects** containing three numbers
- We can see into and modify arrays using **indexing**
- We can make arrays quickly with **array comprehensions**
- Ranges **behave like** arrays, but store data in a different way
"""

# ╔═╡ 9025a5b4-6066-11eb-20e8-099e9b8f859e
md"""
----
"""

# ╔═╡ 635a03dd-abd7-49c8-a3d2-e68c7d83cc9b
html"""
<div style="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/DGojI9xcCfg" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ a9e60a8d-f194-4efa-8108-4092e429564c
md"""
#### Is Julia fun???

$(@bind choice Radio(["Yes", "No", "Maybe"]))

"""

# ╔═╡ 3cd25438-989a-41e1-ba55-691d1992849b
md"""




First grant video chunks:

- overview of images
- input and output for image data




- data representation #1: image == arrays
- Julia: 
- data representation #2: what is colour?




"""

# ╔═╡ c8e1b044-891d-45d0-9946-253804470943


# ╔═╡ 57ddff1a-d414-4bd2-8799-5b42a878cb68
md"## Computer Science: Arrays"

# ╔═╡ 540ccfcc-ee0a-11ea-15dc-4f8120063397
md"""
## **Part 1** - _Manipulating vectors (1D images)_

A `Vector` is a 1D array. We can think of that as a 1D image.

"""

# ╔═╡ 467856dc-eded-11ea-0f83-13d939021ef3
example_vector = [0.5, 0.4, 0.3, 0.2, 0.1, 0.0, 0.7, 0.0, 0.7, 0.9]

# ╔═╡ ad6a33b0-eded-11ea-324c-cfabfd658b56
md"#### Exerise 1.1
👉 Make a random vector `random_vect` of length 10 using the `rand` function.
"

# ╔═╡ f51333a6-eded-11ea-34e6-bfbb3a69bcb0
random_vect = missing # replace this with your code!

# ╔═╡ cf738088-eded-11ea-2915-61735c2aa990
md"👉 Make a function `mean` using a `for` loop, which computes the mean/average of a vector of numbers."

# ╔═╡ 0ffa8354-edee-11ea-2883-9d5bfea4a236
function mean(x)
	
	return missing
end

# ╔═╡ 1f104ce4-ee0e-11ea-2029-1d9c817175af
mean([1, 2, 3])

# ╔═╡ 1f229ca4-edee-11ea-2c56-bb00cc6ea53c
md"👉 Define `m` to be the mean of `random_vect`."

# ╔═╡ 2a391708-edee-11ea-124e-d14698171b68
m = missing

# ╔═╡ e2863d4c-edef-11ea-1d67-332ddca03cc4
md"""👉 Write a function `demean`, which takes a vector `x` and subtracts the mean from each value in `x`."""

# ╔═╡ ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
function demean(x)
	
	return missing
end

# ╔═╡ 29e10640-edf0-11ea-0398-17dbf4242de3
md"Let's check that the mean of the `demean(random_vect)` is 0:

_Due to floating-point round-off error it may *not* be *exactly* 0._"

# ╔═╡ 6f67657e-ee1a-11ea-0c2f-3d567bcfa6ea
if ismissing(random_vect)
	md"""
	!!! info
	    The following cells error because `random_vect` is not yet defined. Have you done the first exercise?
	"""
end

# ╔═╡ 73ef1d50-edf0-11ea-343c-d71706874c82
copy_of_random_vect = copy(random_vect); # in case demean modifies `x`

# ╔═╡ 38155b5a-edf0-11ea-3e3f-7163da7433fb
mean(demean(copy_of_random_vect))

# ╔═╡ a5f8bafe-edf0-11ea-0da3-3330861ae43a
md"""
#### Exercise 1.2

👉 Generate a vector of 100 zeros. Change the center 20 elements to 1.
"""

# ╔═╡ b6b65b94-edf0-11ea-3686-fbff0ff53d08
function create_bar()
	
	return missing
end

# ╔═╡ 22f28dae-edf2-11ea-25b5-11c369ae1253
md"""
#### Exercise 1.3

👉 Write a function that turns a `Vector` of `Vector`s into a `Matrix`.
"""

# ╔═╡ 8c19fb72-ed6c-11ea-2728-3fa9219eddc4
function vecvec_to_matrix(vecvec)
	
	return missing
end

# ╔═╡ c4761a7e-edf2-11ea-1e75-118e73dadbed
vecvec_to_matrix([[1,2], [3,4]])

# ╔═╡ 393667ca-edf2-11ea-09c5-c5d292d5e896
md"""


👉 Write a function that turns a `Matrix` into a`Vector` of `Vector`s .
"""

# ╔═╡ 9f1c6d04-ed6c-11ea-007b-75e7e780703d
function matrix_to_vecvec(matrix)
	
	return missing
end

# ╔═╡ 70955aca-ed6e-11ea-2330-89b4d20b1795
matrix_to_vecvec([6 7; 8 9])

# ╔═╡ 5da8cbe8-eded-11ea-2e43-c5b7cc71e133
begin
	colored_line(x::Vector{<:Real}) = Gray.(Float64.((hcat(x)')))
	colored_line(x::Any) = nothing
end

# ╔═╡ 56ced344-eded-11ea-3e81-3936e9ad5777
colored_line(example_vector)

# ╔═╡ b18e2c54-edf1-11ea-0cbf-85946d64b6a2
colored_line(random_vect)

# ╔═╡ d862fb16-edf1-11ea-36ec-615d521e6bc0
colored_line(create_bar())

# ╔═╡ bd540d08-8d17-4bc2-ad0d-1fd65f25fe5d
md"""
This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 911ccbce-ed68-11ea-3606-0384e7580d7c
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 5f95e01a-ee0a-11ea-030c-9dba276aba92
md"_Let's create a package environment:_"

# ╔═╡ 65780f00-ed6b-11ea-1ecf-8b35523a7ac0
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 74b008f6-ed6b-11ea-291f-b3791d6d1b35
begin
	Pkg.add(["Images", "ImageMagick", "Colors"])
	using Images
	using Colors
end

# ╔═╡ 6b30dc38-ed6b-11ea-10f3-ab3f121bf4b8
begin
	Pkg.add("PlutoUI")
	using PlutoUI
end

# ╔═╡ d07fcdb0-7afc-4a25-b68a-49fd1e3405e7
PlutoUI.TableOfContents(aside=false)

# ╔═╡ 67461396-ee0a-11ea-3679-f31d46baa9b4
md"_We set up Images.jl again:_"

# ╔═╡ e083b3e8-ed61-11ea-2ec9-217820b0a1b4
md"""
## **Part 2** - _Manipulating images_

In this exercise we will get familiar with matrices (2D arrays) in Julia, by manipulating images.
Recall that in Julia images are matrices of `RGB` color objects.

Let's load a picture of Philip again.
"""

# ╔═╡ c5484572-ee05-11ea-0424-f37295c3072d
philip_file = download("https://i.imgur.com/VGPeJ6s.jpg")

# ╔═╡ e86ed944-ee05-11ea-3e0f-d70fc73b789c
md"_Hi there Philip_"

# ╔═╡ c54ccdea-ee05-11ea-0365-23aaf053b7d7
md"""
#### Exercise 2.1
👉 Write a function **`mean_colors`** that accepts an object called `image`. It should calculate the mean (average) amounts of red, green and blue in the image and return a tuple `(r, g, b)` of those means.
"""

# ╔═╡ f6898df6-ee07-11ea-2838-fde9bc739c11
function mean_colors(image)
	
	return missing
end

# ╔═╡ d75ec078-ee0d-11ea-3723-71fb8eecb040


# ╔═╡ f68d4a36-ee07-11ea-0832-0360530f102e
md"""
#### Exercise 2.2
👉 Look up the documentation on the `floor` function. Use it to write a function `quantize(x::Number)` that takes in a value $x$ (which you can assume is between 0 and 1) and "quantizes" it into bins of width 0.1. For example, check that 0.267 gets mapped to 0.2.
"""

# ╔═╡ f6991a50-ee07-11ea-0bc4-1d68eb028e6a
begin
	function quantize(x::Number)
		
		return missing
	end
	
	function quantize(color::AbstractRGB)
		# you will write me in a later exercise!
		return missing
	end
	
	function quantize(image::AbstractMatrix)
		# you will write me in a later exercise!
		return missing
	end
end

# ╔═╡ f6a655f8-ee07-11ea-13b6-43ca404ddfc7
quantize(0.267), quantize(0.91)

# ╔═╡ f6b218c0-ee07-11ea-2adb-1968c4fd473a
md"""
#### Exercise 2.3
👉 Write the second **method** of the function `quantize`, i.e. a new *version* of the function with the *same* name. This method will accept a color object called `color`, of the type `AbstractRGB`. 

_Write the function in the same cell as `quantize(x::Number)` from the last exercise. 👆_
    
Here, `::AbstractRGB` is a **type annotation**. This ensures that this version of the function will be chosen when passing in an object whose type is a **subtype** of the `AbstractRGB` abstract type. For example, both the `RGB` and `RGBX` types satisfy this.

The method you write should return a new `RGB` object, in which each component ($r$, $g$ and $b$) are quantized.
"""

# ╔═╡ f6bf64da-ee07-11ea-3efb-05af01b14f67
md"""
#### Exercise 2.4
👉 Write a method `quantize(image::AbstractMatrix)` that quantizes an image by quantizing each pixel in the image. (You may assume that the matrix is a matrix of color objects.)

_Write the function in the same cell as `quantize(x::Number)` from the last exercise. 👆_
"""

# ╔═╡ 25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
md"Let's apply your method!"

# ╔═╡ f6cc03a0-ee07-11ea-17d8-013991514d42
md"""
#### Exercise 2.5
👉 Write a function `invert` that inverts a color, i.e. sends $(r, g, b)$ to $(1 - r, 1-g, 1-b)$.
"""

# ╔═╡ 63e8d636-ee0b-11ea-173d-bd3327347d55
function invert(color::AbstractRGB)
	
	return missing
end

# ╔═╡ 2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
md"Let's invert some colors:"

# ╔═╡ b8f26960-ee0a-11ea-05b9-3f4bc1099050
black = RGB(0.0, 0.0, 0.0)

# ╔═╡ 5de3a22e-ee0b-11ea-230f-35df4ca3c96d
invert(black)

# ╔═╡ 4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
red = RGB(0.8, 0.1, 0.1)

# ╔═╡ 6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
invert(red)

# ╔═╡ 846b1330-ee0b-11ea-3579-7d90fafd7290
md"Can you invert the picture of Philip?"

# ╔═╡ 943103e2-ee0b-11ea-33aa-75a8a1529931
philip_inverted = missing

# ╔═╡ f6d6c71a-ee07-11ea-2b63-d759af80707b
md"""
#### Exercise 2.6
👉 Write a function `noisify(x::Number, s)` to add randomness of intensity $s$ to a value $x$, i.e. to add a random value between $-s$ and $+s$ to $x$. If the result falls outside the range $(0, 1)$ you should "clamp" it to that range. (Note that Julia has a `clamp` function, but you should write your own function `myclamp(x)`.)
"""

# ╔═╡ f6e2cb2a-ee07-11ea-06ee-1b77e34c1e91
begin
	function noisify(x::Number, s)

		return missing
	end
	
	function noisify(color::AbstractRGB, s)
		# you will write me in a later exercise!
		return missing
	end
	
	function noisify(image::AbstractMatrix, s)
		# you will write me in a later exercise!
		return missing
	end
end

# ╔═╡ f6fc1312-ee07-11ea-39a0-299b67aee3d8
md"""
👉  Write the second method `noisify(c::AbstractRGB, s)` to add random noise of intensity $s$ to each of the $(r, g, b)$ values in a colour. 

_Write the function in the same cell as `noisify(x::Number)` from the last exercise. 👆_
"""

# ╔═╡ 774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
@bind color_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ 7e4aeb70-ee1b-11ea-100f-1952ba66f80f
noisify(red, color_noise)

# ╔═╡ 6a05f568-ee1b-11ea-3b6c-83b6ada3680f


# ╔═╡ f70823d2-ee07-11ea-2bb3-01425212aaf9
md"""
👉 Write the third method `noisify(image::AbstractMatrix, s)` to noisify each pixel of an image.

_Write the function in the same cell as `noisify(x::Number)` from the last exercise. 👆_
"""

# ╔═╡ e70a84d4-ee0c-11ea-0640-bf78653ba102
@bind philip_noise Slider(0:0.01:8, show_value=true)

# ╔═╡ 9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2


# ╔═╡ f714699e-ee07-11ea-08b6-5f5169861b57
md"""
👉 For which noise intensity does it become unrecognisable? 

You may need noise intensities larger than 1. Why?

"""

# ╔═╡ bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
answer_about_noise_intensity = md"""
The image is unrecognisable with intensity ...
"""

# ╔═╡ e074560a-601b-11eb-340e-47acd64f03b2
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ b1d5ca28-edf6-11ea-269e-75a9fb549f1d
hint(md"You can find out more about any function (like `rand`) by creating a new cell and typing:
	
```
?rand
```

Once the Live Docs are open, you can select any code to learn more about it. It might be useful to leave it open all the time, and get documentation while you type code.")

# ╔═╡ f6ef2c2e-ee07-11ea-13a8-2512e7d94426
hint(md"The `rand` function generates (uniform) random floating-point numbers between $0$ and $1$.")

# ╔═╡ e0776548-601b-11eb-2563-57ba2cf1d5d1
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ e083bef6-601b-11eb-2134-e3063d5c4253
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ e08ecb84-601b-11eb-0e25-152ed3a262f7
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ e09036a4-601b-11eb-1a8b-ef70105ab91c
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ e09af1a2-601b-11eb-14c8-57a46546f6ce
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ f2108acd-67e9-491a-91ef-776d67bf44da
if choice === "Yes"
	correct()
else
	keep_working()
end

# ╔═╡ e0a4fc10-601b-11eb-211d-03570aca2726
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 397941fc-edee-11ea-33f2-5d46c759fbf7
if !@isdefined(random_vect)
	not_defined(:random_vect)
elseif ismissing(random_vect)
	still_missing()
elseif !(random_vect isa Vector)
	keep_working(md"`random_vect` should be a `Vector`.")
elseif length(random_vect) != 10
	keep_working(md"`random_vect` does not have the correct size.")
else
	correct()
end

# ╔═╡ 38dc80a0-edef-11ea-10e9-615255a4588c
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		result = mean([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 2b1ccaca-edee-11ea-34b0-c51659f844d0
if !@isdefined(m)
	not_defined(:m)
elseif ismissing(m)
	still_missing()
elseif !(m isa Number)
	keep_working(md"`m` should be a number.")
elseif m != mean(random_vect)
	keep_working()
else
	correct()
end

# ╔═╡ e3394c8a-edf0-11ea-1bb8-619f7abb6881
if !@isdefined(create_bar)
	not_defined(:create_bar)
else
	let
		result = create_bar()
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa Vector) || length(result) != 100
			keep_working(md"The result should be a `Vector` with 100 elements.")
		elseif result[[1,50,100]] != [0,1,0]
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ adfbe9b2-ed6c-11ea-09ac-675262f420df
if !@isdefined(vecvec_to_matrix)
	not_defined(:vecvec_to_matrix)
else
	let
		input = [[6,7],[8,9]]

		result = vecvec_to_matrix(input)
		shouldbe = [6 7; 8 9]

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa Matrix)
			keep_working(md"The result should be a `Matrix`")
		elseif result != shouldbe && result != shouldbe'
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ e06b7fbc-edf2-11ea-1708-fb32599dded3
if !@isdefined(matrix_to_vecvec)
	not_defined(:matrix_to_vecvec)
else
	let
		input = [6 7 8; 8 9 10]
		result = matrix_to_vecvec(input)
		shouldbe = [[6,7,8],[8,9,10]]
		shouldbe2 = [[6,8], [7,9], [8,10]]

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != shouldbe && result != shouldbe2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 4d0158d0-ee0d-11ea-17c3-c169d4284acb
if !@isdefined(mean_colors)
	not_defined(:mean_colors)
else
	let
		input = reshape([RGB(1.0, 1.0, 1.0), RGB(1.0, 1.0, 0.0)], (2,1))
		
		result = mean_colors(input)
		shouldbe = (1.0, 1.0, 0.5)
		shouldbe2 = RGB(shouldbe...)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result == shouldbe) && !(result == shouldbe2)
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
if !@isdefined(quantize)
	not_defined(:quantize)
else
	let
		result = quantize(.3)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != .3
			if quantize(0.35) == .3
				almost(md"What should quantize(`0.2`) be?")
			else
				keep_working()
			end
		else
			correct()
		end
	end
end

# ╔═╡ e0a6031c-601b-11eb-27a5-65140dd92897
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 45815734-ee0a-11ea-2982-595e1fc0e7b1
bigbreak

# ╔═╡ 54056a02-ee0a-11ea-101f-47feb6623bec
bigbreak

# ╔═╡ e0b15582-601b-11eb-26d6-bbf708933bc8
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

# ╔═╡ e891fce0-601b-11eb-383b-bde5b128822e
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

# ╔═╡ 81510a30-ee0e-11ea-0062-8b3327428f9d


# ╔═╡ edf900be-601b-11eb-0456-3f7cfc5e876b
md"_Lecture 1, Spring 2021, version 0_"

# ╔═╡ e3b03628-ee05-11ea-23b6-27c7b0210532
decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]

# ╔═╡ c8ecfe5c-ee05-11ea-322b-4b2714898831
philip = let
	original = Images.load(philip_file)
	decimate(original, 8)
end

# ╔═╡ 5be9b144-ee0d-11ea-2a8d-8775de265a1d
mean_colors(philip)

# ╔═╡ 9751586e-ee0c-11ea-0cbb-b7eda92977c9
quantize(philip)

# ╔═╡ ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
noisify(philip, philip_noise)

# ╔═╡ ef56f47a-601b-11eb-0c3f-7904034396f1
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ Cell order:
# ╟─e91d7926-ec6e-41e7-aba2-9dca333c8aa5
# ╟─d07fcdb0-7afc-4a25-b68a-49fd1e3405e7
# ╟─ca1b507e-6017-11eb-34e6-6b85cd189002
# ╟─127daf08-601b-11eb-28c1-2139c8d1a65a
# ╟─9eb6efd2-6018-11eb-2db8-c3ce41d9e337
# ╟─dd183eca-6018-11eb-2a83-2fcaeea62942
# ╟─e37e4d40-6018-11eb-3e1d-093266c98507
# ╟─e1c9742a-6018-11eb-23ba-d974e57f78f9
# ╠═34ee0954-601e-11eb-1912-97dc2937fd52
# ╟─9180fbcc-601e-11eb-0c22-c920dc7ee9a9
# ╠═34ffc3d8-601e-11eb-161c-6f9a07c5fd78
# ╟─abaaa980-601e-11eb-0f71-8ff02269b775
# ╠═aafe76a6-601e-11eb-1ff5-01885c5238da
# ╠═c99d2aa8-601e-11eb-3469-497a246db17c
# ╠═6f928b30-602c-11eb-1033-71d442feff93
# ╠═75c5c85a-602c-11eb-2fb1-f7e7f2c5d04b
# ╟─77f93eb8-602c-11eb-1f38-efa56cc93ca5
# ╟─d51b24ea-6026-11eb-1040-9751bc5d0144
# ╟─df2c1606-6026-11eb-3fa6-db4da33f5ee7
# ╠═1b682d12-6027-11eb-0e29-ad3ba8eea2b5
# ╟─1e6d9058-6027-11eb-1fe3-0730aff1479a
# ╟─754f1d18-6027-11eb-1f1c-cbcbfd080094
# ╟─794d1802-6027-11eb-161a-9d520ba94a1b
# ╠═88128656-6027-11eb-1b70-2f5fb92415d6
# ╟─a2966c1c-6028-11eb-0d7f-cb4848097e2a
# ╟─89e91286-6029-11eb-20b4-ff3d4fd97e98
# ╟─9995ba72-6029-11eb-332a-3766a6d9725b
# ╟─b33f54e2-6029-11eb-36e7-63d2196873cf
# ╠═c11deb6c-6029-11eb-18ea-bb28465d7c4f
# ╟─ca7c83e6-6029-11eb-0d2a-4b6c6b0ea2cc
# ╠═c2701070-6029-11eb-1431-a7ecf55471a8
# ╠═b9f135fe-60eb-11eb-20e9-eb899fc3ee13
# ╟─38a2bd3c-6029-11eb-1615-f3943cf4e466
# ╠═4ccc3e8c-6029-11eb-2c91-bf915dc56e2b
# ╟─c6bfc07c-60eb-11eb-139e-f9571daace71
# ╟─54c06316-6029-11eb-3e7b-9f9bda9465db
# ╟─f99eefce-6029-11eb-221f-75110c1a1162
# ╠═f5ae3026-6029-11eb-2316-dff58f4c8df5
# ╟─8ddcb286-602a-11eb-3ae0-07d3c77a0f8c
# ╠═f2ecfff8-602a-11eb-129f-29e28a17a773
# ╠═88933746-6028-11eb-32de-13eb6ff43e29
# ╟─35542e8c-6028-11eb-3d4f-0feb1ddbf6c6
# ╠═43c7c7dc-602b-11eb-10f7-098609493a6e
# ╠═6dcca0a2-602b-11eb-15b2-53292368c1b4
# ╟─d5ac1146-6027-11eb-1254-3309a68dc47c
# ╟─0f1339f8-602c-11eb-2c28-1f9ce4be8bf2
# ╠═44f8c36c-602c-11eb-073d-e5cd4605308b
# ╟─5b33bef2-602c-11eb-0fc0-9b7fc9758452
# ╟─d86aedb2-60ec-11eb-160c-afebe6dd8f63
# ╠═362ddfe0-60ed-11eb-2d05-2d1dbd9ea509
# ╟─544dec90-60ed-11eb-2c61-ffc2a7491391
# ╟─22974f50-6065-11eb-0027-f1ebdc3fbeda
# ╟─328157d0-6065-11eb-12fb-b5e412332129
# ╠═5b0c5b76-6065-11eb-191c-ed9a0b1ba7e0
# ╟─a9cda1fc-6065-11eb-36f3-516ddf6549c0
# ╠═b985c8e0-6065-11eb-17e7-214233185691
# ╟─bd6d2372-6065-11eb-1da1-f3b5185da3d7
# ╠═c66edb0c-6065-11eb-2e64-911c45e36ba9
# ╠═96c50f64-60ec-11eb-3e11-2792214f9e19
# ╟─688dbf24-6065-11eb-08f0-a59fa2b71bef
# ╠═608cc414-6065-11eb-28f4-f33c12d5b1b8
# ╠═e75a2e94-6065-11eb-0f4d-e380e32fd333
# ╟─e9f8d152-6065-11eb-0324-551b0c536814
# ╟─c40435c2-60ec-11eb-26f9-4983b35b6853
# ╟─8c03360e-60ed-11eb-30b8-87f9efcb9656
# ╠═95aab790-60ed-11eb-036f-c1b694312a42
# ╟─9ce0272a-60ed-11eb-2e7b-6f06c69d7c29
# ╠═f3ff32d0-60ed-11eb-07bc-f992cd3da9e8
# ╟─c13418d4-60ed-11eb-311c-55b5c28893bf
# ╠═bc9082c2-60ed-11eb-2b3a-3b8cb3e11428
# ╟─3ac7ffa8-60ee-11eb-21da-910b06e87557
# ╠═15da808c-60ee-11eb-350c-07d3f7d2b641
# ╟─5b8f7626-60ee-11eb-160a-e9079209dec7
# ╟─647fddf2-60ee-11eb-124d-5356c7014c3b
# ╠═7d9ad134-60ee-11eb-1b2a-a7d63f3a7a2d
# ╠═8433b862-60ee-11eb-0cfc-add2b72997dc
# ╟─ace86c8a-60ee-11eb-34ef-93c54abc7b1a
# ╠═b08e57e4-60ee-11eb-0e1a-2f49c496668b
# ╟─9025a5b4-6066-11eb-20e8-099e9b8f859e
# ╟─635a03dd-abd7-49c8-a3d2-e68c7d83cc9b
# ╟─a9e60a8d-f194-4efa-8108-4092e429564c
# ╟─f2108acd-67e9-491a-91ef-776d67bf44da
# ╠═3cd25438-989a-41e1-ba55-691d1992849b
# ╠═c8e1b044-891d-45d0-9946-253804470943
# ╠═57ddff1a-d414-4bd2-8799-5b42a878cb68
# ╟─540ccfcc-ee0a-11ea-15dc-4f8120063397
# ╟─467856dc-eded-11ea-0f83-13d939021ef3
# ╠═56ced344-eded-11ea-3e81-3936e9ad5777
# ╟─ad6a33b0-eded-11ea-324c-cfabfd658b56
# ╠═f51333a6-eded-11ea-34e6-bfbb3a69bcb0
# ╟─b18e2c54-edf1-11ea-0cbf-85946d64b6a2
# ╟─397941fc-edee-11ea-33f2-5d46c759fbf7
# ╟─b1d5ca28-edf6-11ea-269e-75a9fb549f1d
# ╟─cf738088-eded-11ea-2915-61735c2aa990
# ╠═0ffa8354-edee-11ea-2883-9d5bfea4a236
# ╠═1f104ce4-ee0e-11ea-2029-1d9c817175af
# ╟─38dc80a0-edef-11ea-10e9-615255a4588c
# ╟─1f229ca4-edee-11ea-2c56-bb00cc6ea53c
# ╠═2a391708-edee-11ea-124e-d14698171b68
# ╟─2b1ccaca-edee-11ea-34b0-c51659f844d0
# ╟─e2863d4c-edef-11ea-1d67-332ddca03cc4
# ╠═ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
# ╟─29e10640-edf0-11ea-0398-17dbf4242de3
# ╟─6f67657e-ee1a-11ea-0c2f-3d567bcfa6ea
# ╠═38155b5a-edf0-11ea-3e3f-7163da7433fb
# ╠═73ef1d50-edf0-11ea-343c-d71706874c82
# ╟─a5f8bafe-edf0-11ea-0da3-3330861ae43a
# ╠═b6b65b94-edf0-11ea-3686-fbff0ff53d08
# ╟─d862fb16-edf1-11ea-36ec-615d521e6bc0
# ╟─e3394c8a-edf0-11ea-1bb8-619f7abb6881
# ╟─22f28dae-edf2-11ea-25b5-11c369ae1253
# ╠═8c19fb72-ed6c-11ea-2728-3fa9219eddc4
# ╠═c4761a7e-edf2-11ea-1e75-118e73dadbed
# ╟─adfbe9b2-ed6c-11ea-09ac-675262f420df
# ╟─393667ca-edf2-11ea-09c5-c5d292d5e896
# ╠═9f1c6d04-ed6c-11ea-007b-75e7e780703d
# ╠═70955aca-ed6e-11ea-2330-89b4d20b1795
# ╟─e06b7fbc-edf2-11ea-1708-fb32599dded3
# ╟─5da8cbe8-eded-11ea-2e43-c5b7cc71e133
# ╟─45815734-ee0a-11ea-2982-595e1fc0e7b1
# ╟─bd540d08-8d17-4bc2-ad0d-1fd65f25fe5d
# ╠═911ccbce-ed68-11ea-3606-0384e7580d7c
# ╟─5f95e01a-ee0a-11ea-030c-9dba276aba92
# ╠═65780f00-ed6b-11ea-1ecf-8b35523a7ac0
# ╟─67461396-ee0a-11ea-3679-f31d46baa9b4
# ╠═74b008f6-ed6b-11ea-291f-b3791d6d1b35
# ╟─54056a02-ee0a-11ea-101f-47feb6623bec
# ╟─e083b3e8-ed61-11ea-2ec9-217820b0a1b4
# ╠═c5484572-ee05-11ea-0424-f37295c3072d
# ╠═c8ecfe5c-ee05-11ea-322b-4b2714898831
# ╟─e86ed944-ee05-11ea-3e0f-d70fc73b789c
# ╟─c54ccdea-ee05-11ea-0365-23aaf053b7d7
# ╠═f6898df6-ee07-11ea-2838-fde9bc739c11
# ╠═5be9b144-ee0d-11ea-2a8d-8775de265a1d
# ╟─4d0158d0-ee0d-11ea-17c3-c169d4284acb
# ╠═d75ec078-ee0d-11ea-3723-71fb8eecb040
# ╟─f68d4a36-ee07-11ea-0832-0360530f102e
# ╠═f6991a50-ee07-11ea-0bc4-1d68eb028e6a
# ╠═f6a655f8-ee07-11ea-13b6-43ca404ddfc7
# ╟─c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
# ╟─f6b218c0-ee07-11ea-2adb-1968c4fd473a
# ╟─f6bf64da-ee07-11ea-3efb-05af01b14f67
# ╟─25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
# ╠═9751586e-ee0c-11ea-0cbb-b7eda92977c9
# ╟─f6cc03a0-ee07-11ea-17d8-013991514d42
# ╠═63e8d636-ee0b-11ea-173d-bd3327347d55
# ╟─2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
# ╟─b8f26960-ee0a-11ea-05b9-3f4bc1099050
# ╠═5de3a22e-ee0b-11ea-230f-35df4ca3c96d
# ╠═4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
# ╠═6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
# ╟─846b1330-ee0b-11ea-3579-7d90fafd7290
# ╠═943103e2-ee0b-11ea-33aa-75a8a1529931
# ╟─f6d6c71a-ee07-11ea-2b63-d759af80707b
# ╠═f6e2cb2a-ee07-11ea-06ee-1b77e34c1e91
# ╟─f6ef2c2e-ee07-11ea-13a8-2512e7d94426
# ╟─f6fc1312-ee07-11ea-39a0-299b67aee3d8
# ╟─774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
# ╠═7e4aeb70-ee1b-11ea-100f-1952ba66f80f
# ╟─6a05f568-ee1b-11ea-3b6c-83b6ada3680f
# ╟─f70823d2-ee07-11ea-2bb3-01425212aaf9
# ╠═e70a84d4-ee0c-11ea-0640-bf78653ba102
# ╠═ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
# ╟─9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2
# ╟─f714699e-ee07-11ea-08b6-5f5169861b57
# ╠═bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
# ╟─e074560a-601b-11eb-340e-47acd64f03b2
# ╟─e0776548-601b-11eb-2563-57ba2cf1d5d1
# ╟─e083bef6-601b-11eb-2134-e3063d5c4253
# ╟─e08ecb84-601b-11eb-0e25-152ed3a262f7
# ╟─e09036a4-601b-11eb-1a8b-ef70105ab91c
# ╟─e09af1a2-601b-11eb-14c8-57a46546f6ce
# ╟─e0a4fc10-601b-11eb-211d-03570aca2726
# ╠═e0a6031c-601b-11eb-27a5-65140dd92897
# ╟─e0b15582-601b-11eb-26d6-bbf708933bc8
# ╟─e891fce0-601b-11eb-383b-bde5b128822e
# ╟─81510a30-ee0e-11ea-0062-8b3327428f9d
# ╠═6b30dc38-ed6b-11ea-10f3-ab3f121bf4b8
# ╟─edf900be-601b-11eb-0456-3f7cfc5e876b
# ╠═e3b03628-ee05-11ea-23b6-27c7b0210532
# ╟─ef56f47a-601b-11eb-0c3f-7904034396f1
