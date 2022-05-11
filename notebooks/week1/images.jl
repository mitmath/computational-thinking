### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 74b008f6-ed6b-11ea-291f-b3791d6d1b35
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ e91d7926-ec6e-41e7-aba2-9dca333c8aa5
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
"><em>Section 1.1</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Images as Data and Arrays </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/3zTO3LEY-cM" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ d07fcdb0-7afc-4a25-b68a-49fd1e3405e7
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 9b49500c-0164-4556-a17b-7595e35c5ede
md"""
#### Intializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ ca1b507e-6017-11eb-34e6-6b85cd189002
md"""
# Images as examples of data  all around us
Welcome to the Computational Thinking using Julia for Real-World Problems, at MIT in Spring 2021!

The aim of this course is to bring together concepts from computer science and applied math with coding in the modern **Julia language**, and to see how to apply these techniques to study interesting applications (and of course to have fun).

We would be pleased if students who have been interested in computer science now become interested in computational science and those interested in scientific applications learn computer science they may not see elsewhere.
... and for all students, we wish to share the value of 
the Julia  language as the best of both worlds.
"""

# ╔═╡ e9ff96d8-6bc1-11eb-0f6a-234b9fae047e
md"""

## Alan's Essay: Are all programming languages the same? 

>Superficially, many programming languages are very similar.  "Showoffs" will compare functional programming vs imperative programming.  Others will compare compiled languages vs dynamic languages.  I will avoid such fancy terms in this little essay, preferring to provide this course's pedagogical viewpoint.
>
>Generally speaking beginning programmers should learn to create "arrays" write "for loops", "conditionals", "comparisons", express mathematical formulas, etc. So why Julia at a time when Python seems to be the language of teaching, and Java and C++ so prominent in the corporate world?
>
>As you might imagine, we believe Julia is special.   Oh you will still have the nitty gritty of when to use a bracket and a comma.  You might have strong opinions as to whether arrays should begin with 0 or 1 (joke: some say it's time to compromise and use ½.)  Getting past these irrelevant issues,  you will begin to experience one by one what makes Julia so very special.  For starters, a language that runs fast is more fun.  We can have you try things that would just be so slow in other languages it would be boring.  We also think you will start to notice how natural Julia is, how it feels like the mathematics, and how flexible it can be.  
>
>Getting to see the true value of fancy terms like multiple dispatch, strong typing, generic programming, and composable software will take a little longer, but stick with us, and you too will see why Julia is so very special.
"""

# ╔═╡ 9111db10-6bc3-11eb-38e5-cf3f58536914
md"""
## Computer Science and Computational Science Working Together
"""

# ╔═╡ fb8a99ac-6bc1-11eb-0835-3146734a1c99
md"""
Applications of computer science in the real world use **data**, i.e. information that we can **measure** in some way. Data take many different forms, for example:

- Numbers that change over time (**time series**): 
  - Stock price each second / minute / day
  - Weekly number of infections
  - Earth's global average temperature

- Video:
  - The view from a window of a self-driving car
  - A hurricane monitoring station
  - Ultrasound e.g. prenatal

- Images:
  - Diseased versus healthy tissue in a medical scan
  - Pictures of your favourite dog
"""

# ╔═╡ b795dcb4-6bc3-11eb-20ec-db2cc4b89bfb
md"""
#### Exercise: 
> Think of another two examples in each category. Can you think of other categories of data?
"""

# ╔═╡ 8691e434-6bc4-11eb-07d1-8169158484e6
md"""
Computational science can be summed up by a simplified workflow:
"""

# ╔═╡ 546db74c-6d4e-11eb-2e27-f5bed9dbd9ba
md"""
## data ⟶  input  ⟶ process ⟶ model ⟶ visualize ⟶ output
"""

# ╔═╡ 6385d174-6d4e-11eb-093b-6f6fafb79f84
md"""
$(html"<br>")
To use any data source, we need to **input** the data of interest, for example by downloading it, reading in the resulting file, and converting it into a form that we can use in the computer. Then we need to **process** it in some way to extract information of interest. We usually want to **visualize** the results, and we may want to **output** them, for example by saving to disc or putting them on a website.

We often want to make a mathematical or computational **model** that can help us to understand and predict the behavior of the system of interest.

> In this course we aim to show how programming, computer science and applied math combine to help us with these goals.
"""

# ╔═╡ 132f6596-6bc6-11eb-29f1-1b2478c929af
md"""
# Data: Images (as an example of data)
Let's start off by looking at **images** and how we can process them. 
Our goal is to process the data contained in an image in some way, which we will do by developing and coding certain **algorithms**.

Here is the the Fall 2020 version of this lecture (small variations) by 3-Blue-1-Brown (Grant Sanderson) for your reference.
"""

# ╔═╡ 635a03dd-abd7-49c8-a3d2-e68c7d83cc9b
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/DGojI9xcCfg" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 9eb6efd2-6018-11eb-2db8-c3ce41d9e337
md"""


If we open an image on our computer or the web and zoom in enough, we will see that it consists of many tiny squares, or **pixels** ("picture elements"). Each pixel is a block of one single colour, and the pixels are arranged in a two-dimensional square grid. 

You probably already know that these pixels are stored in a computer numerically
perhaps in some form of RGB (red,green,blue) format.  This is the computer's represenation of the data.   

Note that an image is already an **approximation** of the real world -- it is a two-dimensional, discrete representation of a three-dimensional reality.

"""

# ╔═╡ e37e4d40-6018-11eb-3e1d-093266c98507
md"""
# Input and Visualize: loading and viewing an Image (in Julia)
"""

# ╔═╡ e1c9742a-6018-11eb-23ba-d974e57f78f9
md"""
Let's use Julia to load  actual images and play around with them. We can download images from the internet, your own file, or your own webcam.
"""

# ╔═╡ 9b004f70-6bc9-11eb-128c-914eadfc9a0e
md"""
## Downloading an image from the internet or a local file
We can use the `Images.jl` package to load an image file in three steps.
"""

# ╔═╡ 62fa19da-64c6-11eb-0038-5d40a6890cf5
md"""
Step 1: (from internet) we specify the URL (web address) to download from:
$(html"<br>")
(note that Pluto places results before commands because some people believe
output is more interesting than code.  This takes some getting used to.)
"""

# ╔═╡ 34ee0954-601e-11eb-1912-97dc2937fd52
url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png" 

# ╔═╡ 9180fbcc-601e-11eb-0c22-c920dc7ee9a9
md"""
Step 2: Now we use the aptly-named `download` function to download the image file to our own computer. (Philip is Prof. Edelman's corgi.)
"""

# ╔═╡ 34ffc3d8-601e-11eb-161c-6f9a07c5fd78
philip_filename = download(url) # download to a local file. The filename is returned

# ╔═╡ abaaa980-601e-11eb-0f71-8ff02269b775
md"""
Step 3:
Using the `Images.jl` package (loaded at the start of this notebook; scroll up and take a look.) we can **load** the file, which automatically converts it into usable data. We'll store the result in a variable. (Remember the code is after the output.)
"""

# ╔═╡ aafe76a6-601e-11eb-1ff5-01885c5238da
philip = load(philip_filename)

# ╔═╡ e86ed944-ee05-11ea-3e0f-d70fc73b789c
md"_Hi there Philip_"

# ╔═╡ c99d2aa8-601e-11eb-3469-497a246db17c
md"""
We see that the Pluto notebook has recognised that we created an object representing an image, and automatically displayed the resulting image of Philip, the cute Welsh Pembroke corgi and co-professor of this course.
Poor Philip will undergo quite a few transformations as we go along!
"""

# ╔═╡ 11dff4ce-6bca-11eb-1056-c1345c796ed4
md"""
- Exercise : change the url.
- Exercise: download a file that is already on your own computer.
"""

# ╔═╡ efef3a32-6bc9-11eb-17e9-dd2171be9c21
md"""
## Capturing an Image from your own camera
"""

# ╔═╡ e94dcc62-6d4e-11eb-3d53-ff9878f0091e
md"""
Even more fun is to use your own webcam. Try pressing the enable button below. Then
press the camera to capture an image. Kind of fun to keep pressing the button as you move your hand etc.
"""

# ╔═╡ cef1a95a-64c6-11eb-15e7-636a3621d727
md"""
## Inspecting your data
"""

# ╔═╡ f26d9326-64c6-11eb-1166-5d82586422ed
md"""
### Image size
"""

# ╔═╡ 6f928b30-602c-11eb-1033-71d442feff93
md"""
The first thing we might want to know is the size of the image:
"""

# ╔═╡ 75c5c85a-602c-11eb-2fb1-f7e7f2c5d04b
philip_size = size(philip)

# ╔═╡ 77f93eb8-602c-11eb-1f38-efa56cc93ca5
md"""
Julia returns a pair of two numbers. Comparing these with the picture of the image, we see that the first number is the height, i.e. the vertical number of pixels, and the second is the width.
"""

# ╔═╡ 96b7d801-c427-4e27-ab1f-e2fd18fc24d0
philip_height = philip_size[1]

# ╔═╡ f08d02af-6e38-4ace-8b11-7af4930b64ea
philip_width = philip_size[2]

# ╔═╡ f9244264-64c6-11eb-23a6-cfa76f8aff6d
md"""
### Locations in an image: Indexing

Now suppose that we want to examine a piece of the image in more detail. We need some way of specifying which piece of the image we want. 

Thinking of the image as a grid of pixels, we need a way to tell the computer which pixel or group of pixels we want to refer to. 
Since the image is a two-dimensional grid, we can use two integers (whole numbers) to give the coordinates of a single pixel.  Specifying coordinates like this is called **indexing**: think of the index of a book, which tells you *on which page* an idea is discussed.

In Julia we use (square) brackets, `[` and `]` for indexing: 
"""

# ╔═╡ bd22d09a-64c7-11eb-146f-67733b8be241
a_pixel = philip[200, 100]

# ╔═╡ 28860d48-64c8-11eb-240f-e1232b3638df
md"""
We see that Julia knows to draw our pixel object for us a block of the relevant color.

When we index into an image like this, the first number indicates the *row* in the image, starting from the top, and the second the *column*, starting from the left. In Julia, the first row and column are numbered starting from 1, not from 0 as in some other programming languages.
"""

# ╔═╡ 4ef99715-4d8d-4f9d-bf0b-8df9907a14cf


# ╔═╡ a510fc33-406e-4fb5-be83-9e4b5578717c
md"""
We can also use variables as indices...
"""

# ╔═╡ 13844ebf-52c4-47e9-bda4-106a02fad9d7
md"""
...and these variables can be controlled by sliders!
"""

# ╔═╡ 08d61afb-c641-4aa9-b995-2552af89f3b8
@bind row_i Slider(1:size(philip)[1], show_value=true)

# ╔═╡ 6511a498-7ac9-445b-9c15-ec02d09783fe
@bind col_i Slider(1:size(philip)[2], show_value=true)

# ╔═╡ 94b77934-713e-11eb-18cf-c5dc5e7afc5b
row_i,col_i

# ╔═╡ ff762861-b186-4eb0-9582-0ce66ca10f60
philip[row_i, col_i]

# ╔═╡ c9ed950c-dcd9-4296-a431-ee0f36d5b557
md"""
### Locations in an image: Range indexing

We saw that we can use the **row number** and **column number** to index a _single pixel_ of our image. Next, we will use a **range of numbers** to index _multiple rows or columns_ at once, returning a subarray:
"""

# ╔═╡ f0796032-8105-4f6d-b5ee-3647b052f2f6
philip[550:650, 1:philip_width]

# ╔═╡ b9be8761-a9c9-49eb-ba1b-527d12097362
md"""
Here, we use `a:b` to mean "_all numbers between `a` and `b`_". For example:

"""

# ╔═╡ d515286b-4ad4-449b-8967-06b9b4c87684
collect(1:10)

# ╔═╡ eef8fbc8-8887-4628-8ba8-114575d6b91f
md"""

You can also use a `:` without start and end to mean "_every index_"
"""

# ╔═╡ 4e6a31d6-1ef8-4a69-b346-ad58cfc4d8a5
philip[550:650, :]

# ╔═╡ e11f0e47-02d9-48a6-9b1a-e313c18db129
md"""
Let's get a single row of pixels:
"""

# ╔═╡ 9e447eab-14b6-45d8-83ab-1f7f1f1c70d2
philip[550, :]

# ╔═╡ c926435c-c648-419c-9951-ac8a1d4f3b92
philip_head = philip[470:800, 140:410]

# ╔═╡ 32e7e51c-dd0d-483d-95cb-e6043f2b2975
md"""
#### Scroll in on Philip's nose!

Use the widgets below (slide left and right sides).
"""

# ╔═╡ 4b64e1f2-d0ca-4e22-a89d-1d9a16bd6788
@bind range_rows RangeSlider(1:size(philip_head)[1])

# ╔═╡ 85919db9-1444-4904-930f-ba572cff9460
@bind range_cols RangeSlider(1:size(philip_head)[2])

# ╔═╡ 2ac47b91-bbc3-49ae-9bf5-4def30ff46f4
nose = philip_head[range_rows, range_cols]

# ╔═╡ 5a0cc342-64c9-11eb-1211-f1b06d652497
md"""
# Process: Modifying an image

Now that we have access to image data, we can start to **process** that data to extract information and/or modify it in some way.

We might want to detect what type of objects are in the image, say to detect whether a patient has a certain disease. To achieve a high-level goal like this, we will need to perform mid-level operations, such as detecting edges that separate different objects based on their color. And, in turn, to carry that out we will need to do low-level operations like comparing colors of neighboring pixels and somehow deciding if they are "different".

"""

# ╔═╡ 4504577c-64c8-11eb-343b-3369b6d10d8b
md"""
## Representing colors

We can  use indexing to *modify* a pixel's color. To do so, we need a way to specify a new color.

Color turns out to be a complicated concept, having to do with the interaction of the physical properties of light with the physiological mechanisms and mental processes by which we detect it!

We will ignore this complexity by using a standard method of representing colours in the computer as an **RGB triple**, i.e. a triple of three numbers $(r, g, b)$, giving the amount of red, of green and of blue in a colour, respectively. These are numbers between 0 (none) and 1 (full). The final colour that we perceive is the result of "adding" the corresponding amount of light of each colour; the details are fascinating, but beyond the scope of this course!
"""

# ╔═╡ 40886d36-64c9-11eb-3c69-4b68673a6dde
md"""
We can create a new color in Julia as follows:
"""

# ╔═╡ 552235ec-64c9-11eb-1f7f-f76da2818cb3
RGB(1.0, 0.0, 0.0)

# ╔═╡ c2907d1a-47b1-4634-8669-a68022706861
begin
	md"""
	A pixel with $(@bind test_r Scrubbable(0:0.1:1; default=0.1)) red, $(@bind test_g Scrubbable(0:0.1:1; default=0.5)) green and $(@bind test_b Scrubbable(0:0.1:1; default=1.0)) blue looks like:
	"""
end
	

# ╔═╡ ff9eea3f-cab0-4030-8337-f519b94316c5
RGB(test_r, test_g, test_b)

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

# ╔═╡ 2ee543b2-64d6-11eb-3c39-c5660141787e
md"""

## Modifying a pixel

Let's start by seeing how to modify an image, e.g. in order to hide sensitive information.

We do this by assigning a new value to the color of a pixel:
"""

# ╔═╡ 53bad296-4c7b-471f-b481-0e9423a9288a
let
	temp = copy(philip_head)
	temp[100, 200] = RGB(1.0, 0.0, 0.0)
	temp
end

# ╔═╡ ab9af0f6-64c9-11eb-13d3-5dbdb75a69a7
md"""
## Groups of pixels

We probably want to examine and modify several pixels at once.
For example, we can extract a horizontal strip 1 pixel tall:
"""

# ╔═╡ e29b7954-64cb-11eb-2768-47de07766055
philip_head[50, 50:100]

# ╔═╡ 8e7c4866-64cc-11eb-0457-85be566a8966
md"""
Here, Julia is showing the strip as a collection of rectangles in a row.


"""

# ╔═╡ f2ad501a-64cb-11eb-1707-3365d05b300a
md"""
And then modify it:
"""

# ╔═╡ 4f03f651-56ed-4361-b954-e6848ac56089
let
	temp = copy(philip_head)
	temp[50, 50:100] .= RGB(1.0, 0.0, 0.0)
	temp
end

# ╔═╡ 2808339c-64cc-11eb-21d1-c76a9854aa5b
md"""
Similarly we can modify a whole rectangular block of pixels:
"""

# ╔═╡ 1bd53326-d705-4d1a-bf8f-5d7f2a4e696f
let
	temp = copy(philip_head)
	temp[50:100, 50:100] .= RGB(1.0, 0.0, 0.0)
	temp
end

# ╔═╡ a5f8bafe-edf0-11ea-0da3-3330861ae43a
md"""
#### Exercise 1.2

👉 Generate a vector of 100 zeros. Change the center 20 elements to 1.
"""

# ╔═╡ b6b65b94-edf0-11ea-3686-fbff0ff53d08
function create_bar()
	
	return missing
end

# ╔═╡ 693af19c-64cc-11eb-31f3-57ab2fbae597
md"""
## Reducing the size of an image
"""

# ╔═╡ 6361d102-64cc-11eb-31b7-fb631b632040
md"""
Maybe we would also like to reduce the size of this image, since it's rather large. For example, we could take every 10th row and every 10th column and make a new image from the result:
"""

# ╔═╡ ae542fe4-64cc-11eb-29fc-73b7a66314a9
reduced_image = philip[1:10:end, 1:10:end]

# ╔═╡ c29292b8-64cc-11eb-28db-b52c46e865e6
md"""
Note that the resulting image doesn't look very good, since we seem to have lost too much detail. 

#### Exercise

> Think about what we might do to reduce the size of an image without losing so much detail.
"""

# ╔═╡ 7b04331a-6bcb-11eb-34fa-1f5b151e5510
md"""
# Model: Creating synthetic images 

Think about your favorite Pixar movie (e.g. Monsters Inc.) Movie frames are images that are generated from complicated mathematical models.  Ray tracing (which may be covered in this class)
is a method for making images feel realistic.  
"""

# ╔═╡ 5319c03c-64cc-11eb-0743-a1612476e2d3
md"""
# Output: Saving an image to a file

Finally, we want to be able to save our new creation to a file. To do so, you can **right click** on a displayed image, or you can write it to a file. Fill in a path below:
"""

# ╔═╡ 3db09d92-64cc-11eb-0333-45193c0fd1fe
save("reduced_phil.png", reduced_image)

# ╔═╡ 61606acc-6bcc-11eb-2c80-69ceec9f9702
md"""
# $(html"<br>")   
"""

# ╔═╡ dd183eca-6018-11eb-2a83-2fcaeea62942
md"""
# Computer science: Arrays

An image is a concrete example of a fundamental concept in computer science, namely an **array**. 

Just as an image is a rectangular grid, where each grid cell contains a single color,
an array is a rectangular grid for storing data. Data is stored and retrieved using indexing, just as in the image examples: each cell in the grid can store a single "piece of data" of a given type.


## Dimension of an array

An array can be one-dimensional, like the strip of pixels above, two-dimensional, three-dimensional, and so on. The dimension tells us the number of indices that we need to specify a unique location in the grid.
The array object also needs to know the length of the data in each dimension.

## Names for different types of array

One-dimensional arrays are often called **vectors** (or, in some other languages, "lists") and two-dimensional arrays are **matrices**. Higher-dimensional arrays are  **tensors**.


## Arrays as data structures

An array is an example of a **data structure**, i.e. a way of arranging data such that we can access it. A key theme in computer science is that of designing different data structures that represent data in different ways.

Conceptually, we can think of an array as a block of data that has a position or location in space. This can be a useful way to arrange data if, for example, we want to represent the fact that values in nearby locations in array are somehow near to one another.

Images are a good example of this: neighbouring pixels often represent different pieces of the same object, for example the rug or floor, or Philip himself, in the photo. We thus expect neighbouring pixels to be of a similar color. On the other hand, if they are not, this is also useful information, since that may correspond to the edge of an object.

"""

# ╔═╡ 8ddcb286-602a-11eb-3ae0-07d3c77a0f8c
md"""
# Julia: constructing arrays

## Creating vectors and matrices
Julia has strong support for arrays of any dimension.

Vectors, or one-dimensional arrays, are written using square brackets and commas:
"""

# ╔═╡ f4b0aa23-2d76-4d88-b2a4-3807e88d27ce
[1, 20, "hello"]

# ╔═╡ 1b2b2b18-64d4-11eb-2d43-e31cb8bc25d1
[RGB(1, 0, 0), RGB(0, 1, 0), RGB(0, 0, 1)]

# ╔═╡ 2b0e6450-64d4-11eb-182b-ff1bd515b56f
md"""
Matrices, or two-dimensional arrays, also use square brackets, but with spaces and new lines instead of commas:
"""

# ╔═╡ 3b2b041a-64d4-11eb-31dd-47d7321ee909
[RGB(1, 0, 0)  RGB(0, 1, 0)
 RGB(0, 0, 1)  RGB(0.5, 0.5, 0.5)]

# ╔═╡ 0f35603a-64d4-11eb-3baf-4fef06d82daa
md"""

## Array comprehensions

It's clear that if we want to create an array with more than a few elements, it will be *very* tedious to do so by hand like this.
Rather, we want to *automate* the process of creating an array by following some pattern, for example to create a whole palette of colors!

Let's start with all the possible colors interpolating between black, `RGB(0, 0, 0)`, and red, `RGB(1, 0, 0)`.  Since only one of the values is changing, we can represent this as a vector, i.e. a one-dimensional array.

A neat method to do this is an **array comprehension**. Again we use square brackets  to create an array, but now we use a **variable** that varies over a given **range** values:
"""

# ╔═╡ e69b02c6-64d6-11eb-02f1-21c4fb5d1043
[RGB(x, 0, 0) for x in 0:0.1:1]

# ╔═╡ fce76132-64d6-11eb-259d-b130038bbae6
md"""
Here, `0:0.1:1` is a **range**; the first and last numbers are the start and end values, and the middle number is the size of the step.
"""

# ╔═╡ 17a69736-64d7-11eb-2c6c-eb5ebf51b285
md"""
In a similar way we can create two-dimensional matrices, by separating the two variables for each dimension with a comma (`,`):
"""

# ╔═╡ 291b04de-64d7-11eb-1ee0-d998dccb998c
[RGB(i, j, 0) for i in 0:0.1:1, j in 0:0.1:1]

# ╔═╡ 647fddf2-60ee-11eb-124d-5356c7014c3b
md"""
## Joining matrices

We often want to join vectors and matrices together. We can do so using an extension of the array creation syntax:
"""

# ╔═╡ 7d9ad134-60ee-11eb-1b2a-a7d63f3a7a2d
[philip_head  philip_head]

# ╔═╡ 8433b862-60ee-11eb-0cfc-add2b72997dc
[philip_head                   reverse(philip_head, dims=2)
 reverse(philip_head, dims=1)  rot180(philip_head)]

# ╔═╡ 5e52d12e-64d7-11eb-0905-c9038a404e24
md"""
# Pluto: Interactivity using sliders
"""

# ╔═╡ 6aba7e62-64d7-11eb-2c49-7944e9e2b94b
md"""
Suppose we want to see the effect of changing the number of colors in our vector or matrix. We could, of course, do so by manually fiddling with the range.

It would be nice if we could do so using a **user interface**, for example with a **slider**. Fortunately, the Pluto notebook allows us to do so!
"""

# ╔═╡ afc66dac-64d7-11eb-1ad0-7f62c20ffefb
md"""
We can define a slider using
"""

# ╔═╡ b37c9868-64d7-11eb-3033-a7b5d3065f7f
@bind number_reds Slider(1:100, show_value=true)

# ╔═╡ b1dfe122-64dc-11eb-1104-1b8852b2c4c5
md"""
[The `Slider` type is defined in the `PlutoUI.jl` package.]
"""

# ╔═╡ cfc55140-64d7-11eb-0ff6-e59c70d01d67
md"""
This creates a new variable called `number_reds`, whose value is the value shown by the slider. When we move the slider, the value of the variable gets updated. Since Pluto is a **reactive** notebook, other cells which use the value of this variable will *automatically be updated too*!
"""

# ╔═╡ fca72490-64d7-11eb-1464-f5e0582c4d18
md"""
Let's use this to make a slider for our one-dimensional collection of reds:
"""

# ╔═╡ 88933746-6028-11eb-32de-13eb6ff43e29
[RGB(red_value / number_reds, 0, 0) for red_value in 0:number_reds]

# ╔═╡ 1c539b02-64d8-11eb-3505-c9288357d139
md"""
When you move the slider, you should see the number of red color patches change!
"""

# ╔═╡ 10f6e6da-64d8-11eb-366f-11f16e73043b
md"""
What is going on here is that we are creating a vector in which `red_value` takes each value in turn from the range from `0` up to the current value of `number_reds`. If we change `number_reds`, then we create a new vector with that new number of red patches.
"""

# ╔═╡ 82a8314c-64d8-11eb-1acb-e33625381178
md"""
#### Exercise

> Make three sliders with variables `r`, `g` and `b`. Then make a single color patch with the RGB color given by those values.
"""

# ╔═╡ 576d5e3a-64d8-11eb-10c9-876be31f7830
md"""
We can do the same to create different size matrices, by creating two sliders, one for reds and one for greens. Try it out!
"""

# ╔═╡ ace86c8a-60ee-11eb-34ef-93c54abc7b1a
md"""
# Summary
"""

# ╔═╡ b08e57e4-60ee-11eb-0e1a-2f49c496668b
md"""
Let's summarize the main ideas from this notebook:
- Images are **arrays** of colors
- We can inspect and modify arrays using **indexing**
- We can create arrays directly or using **array comprehensions**
"""

# ╔═╡ 9025a5b4-6066-11eb-20e8-099e9b8f859e
md"""
----
"""

# ╔═╡ 5da8cbe8-eded-11ea-2e43-c5b7cc71e133
begin
	colored_line(x::Vector{<:Real}) = Gray.(Float64.((hcat(x)')))
	colored_line(x::Any) = nothing
end

# ╔═╡ d862fb16-edf1-11ea-36ec-615d521e6bc0
colored_line(create_bar())

# ╔═╡ e074560a-601b-11eb-340e-47acd64f03b2
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

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

# ╔═╡ e0a4fc10-601b-11eb-211d-03570aca2726
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

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

# ╔═╡ e0a6031c-601b-11eb-27a5-65140dd92897
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 45815734-ee0a-11ea-2982-595e1fc0e7b1
bigbreak

# ╔═╡ e0b15582-601b-11eb-26d6-bbf708933bc8
function camera_input(;max_size=150, default_url="https://i.imgur.com/SUmi94P.png")
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

# ╔═╡ d6742ea0-1106-4f3c-a5b8-a31a48d33f19
@bind webcam_data1 camera_input()

# ╔═╡ 2a94a2cf-b697-4b0b-afd0-af2e35af2bb1
@bind webcam_data camera_input()

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

# ╔═╡ 1d7375b7-7ea6-4d67-ab73-1c69d6b8b87f
myface1 = process_raw_camera_data(webcam_data1);

# ╔═╡ 6224c74b-8915-4983-abf0-30e6ba04a46d
[
	myface1              myface1[   :    , end:-1:1]
	myface1[end:-1:1, :] myface1[end:-1:1, end:-1:1]
]

# ╔═╡ 3e0ece65-b8a7-4be7-ae44-6d7210c2e15b
myface = process_raw_camera_data(webcam_data);

# ╔═╡ 4ee18bee-13e6-4478-b2ca-ab66100e57ec
[
	myface              myface[   :    , end:-1:1]
	myface[end:-1:1, :] myface[end:-1:1, end:-1:1]
]

# ╔═╡ 3ef77236-1867-4d02-8af2-ff4777fcd6d9
exercise_css = html"""
<style>

ct-exercise > h4 {
    background: #73789a;
    color: white;
    padding: 0rem 1.5rem;
    font-size: 1.2rem;
    border-radius: .6rem .6rem 0rem 0rem;
	margin-left: .5rem;
	display: inline-block;
}
ct-exercise > section {
	    background: #31b3ff1a;
    border-radius: 0rem 1rem 1rem 1rem;
    padding: .7rem;
    margin: .5rem;
    margin-top: 0rem;
    position: relative;
}


/*ct-exercise > section::before {
	content: "👉";
    display: block;
    position: absolute;
    left: 0px;
    top: 0px;
    background: #ffffff8c;
    border-radius: 100%;
    width: 1rem;
    height: 1rem;
    padding: .5rem .5rem;
    font-size: 1rem;
    line-height: 1rem;
    left: -1rem;
}*/


ct-answer {
	display: flex;
}
</style>

"""

# ╔═╡ 61b29e7d-5aba-4bc8-870b-c1c43919c236
exercise(x, number="") = 
@htl("""
	<ct-exercise class="exercise">
	<h4>Exercise <span>$(number)</span></h4>
	<section>$(x)
	</section>
	</ct-exercise>
	""")

# ╔═╡ a9fef6c9-e911-4d8c-b141-a4832b40a260
quick_question(x, number, options, correct) = let
	name = join(rand('a':'z',16))
@htl("""
	<ct-exercise class="quick-question">
	<h4>Quick Question <span>$(number)</span></h4>
	<section>$(x)
	<ct-answers>
	$(map(enumerate(options)) do (i, o)
		@htl("<ct-answer><input type=radio name=$(name) id=$(i) >$(o)</ct-answer>")
	end)
	</ct-answers>
	</section>
	</ct-exercise>
	""")
end

# ╔═╡ edf900be-601b-11eb-0456-3f7cfc5e876b
md"_Lecture 1, Spring 2021, version 0_"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
FileIO = "~1.14.0"
HypertextLiteral = "~0.9.4"
ImageIO = "~0.6.2"
ImageShow = "~0.3.4"
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "63d1e802de0c4882c00aee5cb16f9dd4d6d7c59c"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.1"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "539682309e12265fbe75de8d83560c307af975bd"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.2"

[[ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "25f7784b067f699ae4e4cb820465c174f7022972"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.4"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

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

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

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
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "aee446d0b3d5764e35289762f6a18e8ea041a592"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.11.0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

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

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

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
git-tree-sha1 = "e925a64b8585aa9f4e3047b8d2cdc3f0e79fd4e4"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.16"

[[PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

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
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─e91d7926-ec6e-41e7-aba2-9dca333c8aa5
# ╟─d07fcdb0-7afc-4a25-b68a-49fd1e3405e7
# ╟─9b49500c-0164-4556-a17b-7595e35c5ede
# ╠═74b008f6-ed6b-11ea-291f-b3791d6d1b35
# ╟─ca1b507e-6017-11eb-34e6-6b85cd189002
# ╟─e9ff96d8-6bc1-11eb-0f6a-234b9fae047e
# ╟─9111db10-6bc3-11eb-38e5-cf3f58536914
# ╟─fb8a99ac-6bc1-11eb-0835-3146734a1c99
# ╟─b795dcb4-6bc3-11eb-20ec-db2cc4b89bfb
# ╟─8691e434-6bc4-11eb-07d1-8169158484e6
# ╟─546db74c-6d4e-11eb-2e27-f5bed9dbd9ba
# ╟─6385d174-6d4e-11eb-093b-6f6fafb79f84
# ╟─132f6596-6bc6-11eb-29f1-1b2478c929af
# ╟─635a03dd-abd7-49c8-a3d2-e68c7d83cc9b
# ╟─9eb6efd2-6018-11eb-2db8-c3ce41d9e337
# ╟─e37e4d40-6018-11eb-3e1d-093266c98507
# ╟─e1c9742a-6018-11eb-23ba-d974e57f78f9
# ╟─9b004f70-6bc9-11eb-128c-914eadfc9a0e
# ╟─62fa19da-64c6-11eb-0038-5d40a6890cf5
# ╠═34ee0954-601e-11eb-1912-97dc2937fd52
# ╟─9180fbcc-601e-11eb-0c22-c920dc7ee9a9
# ╠═34ffc3d8-601e-11eb-161c-6f9a07c5fd78
# ╟─abaaa980-601e-11eb-0f71-8ff02269b775
# ╠═aafe76a6-601e-11eb-1ff5-01885c5238da
# ╟─e86ed944-ee05-11ea-3e0f-d70fc73b789c
# ╟─c99d2aa8-601e-11eb-3469-497a246db17c
# ╟─11dff4ce-6bca-11eb-1056-c1345c796ed4
# ╟─efef3a32-6bc9-11eb-17e9-dd2171be9c21
# ╟─e94dcc62-6d4e-11eb-3d53-ff9878f0091e
# ╟─d6742ea0-1106-4f3c-a5b8-a31a48d33f19
# ╠═1d7375b7-7ea6-4d67-ab73-1c69d6b8b87f
# ╠═6224c74b-8915-4983-abf0-30e6ba04a46d
# ╟─cef1a95a-64c6-11eb-15e7-636a3621d727
# ╟─f26d9326-64c6-11eb-1166-5d82586422ed
# ╟─6f928b30-602c-11eb-1033-71d442feff93
# ╠═75c5c85a-602c-11eb-2fb1-f7e7f2c5d04b
# ╟─77f93eb8-602c-11eb-1f38-efa56cc93ca5
# ╠═96b7d801-c427-4e27-ab1f-e2fd18fc24d0
# ╠═f08d02af-6e38-4ace-8b11-7af4930b64ea
# ╟─f9244264-64c6-11eb-23a6-cfa76f8aff6d
# ╠═bd22d09a-64c7-11eb-146f-67733b8be241
# ╟─28860d48-64c8-11eb-240f-e1232b3638df
# ╟─4ef99715-4d8d-4f9d-bf0b-8df9907a14cf
# ╟─a510fc33-406e-4fb5-be83-9e4b5578717c
# ╠═94b77934-713e-11eb-18cf-c5dc5e7afc5b
# ╠═ff762861-b186-4eb0-9582-0ce66ca10f60
# ╟─13844ebf-52c4-47e9-bda4-106a02fad9d7
# ╠═08d61afb-c641-4aa9-b995-2552af89f3b8
# ╠═6511a498-7ac9-445b-9c15-ec02d09783fe
# ╟─c9ed950c-dcd9-4296-a431-ee0f36d5b557
# ╠═f0796032-8105-4f6d-b5ee-3647b052f2f6
# ╟─b9be8761-a9c9-49eb-ba1b-527d12097362
# ╠═d515286b-4ad4-449b-8967-06b9b4c87684
# ╟─eef8fbc8-8887-4628-8ba8-114575d6b91f
# ╠═4e6a31d6-1ef8-4a69-b346-ad58cfc4d8a5
# ╟─e11f0e47-02d9-48a6-9b1a-e313c18db129
# ╠═9e447eab-14b6-45d8-83ab-1f7f1f1c70d2
# ╠═c926435c-c648-419c-9951-ac8a1d4f3b92
# ╟─32e7e51c-dd0d-483d-95cb-e6043f2b2975
# ╠═4b64e1f2-d0ca-4e22-a89d-1d9a16bd6788
# ╠═85919db9-1444-4904-930f-ba572cff9460
# ╠═2ac47b91-bbc3-49ae-9bf5-4def30ff46f4
# ╟─5a0cc342-64c9-11eb-1211-f1b06d652497
# ╟─4504577c-64c8-11eb-343b-3369b6d10d8b
# ╟─40886d36-64c9-11eb-3c69-4b68673a6dde
# ╠═552235ec-64c9-11eb-1f7f-f76da2818cb3
# ╟─c2907d1a-47b1-4634-8669-a68022706861
# ╠═ff9eea3f-cab0-4030-8337-f519b94316c5
# ╟─f6cc03a0-ee07-11ea-17d8-013991514d42
# ╠═63e8d636-ee0b-11ea-173d-bd3327347d55
# ╟─2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
# ╟─b8f26960-ee0a-11ea-05b9-3f4bc1099050
# ╠═5de3a22e-ee0b-11ea-230f-35df4ca3c96d
# ╠═4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
# ╠═6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
# ╟─846b1330-ee0b-11ea-3579-7d90fafd7290
# ╠═943103e2-ee0b-11ea-33aa-75a8a1529931
# ╟─2ee543b2-64d6-11eb-3c39-c5660141787e
# ╠═53bad296-4c7b-471f-b481-0e9423a9288a
# ╟─ab9af0f6-64c9-11eb-13d3-5dbdb75a69a7
# ╠═e29b7954-64cb-11eb-2768-47de07766055
# ╟─8e7c4866-64cc-11eb-0457-85be566a8966
# ╟─f2ad501a-64cb-11eb-1707-3365d05b300a
# ╠═4f03f651-56ed-4361-b954-e6848ac56089
# ╟─2808339c-64cc-11eb-21d1-c76a9854aa5b
# ╠═1bd53326-d705-4d1a-bf8f-5d7f2a4e696f
# ╟─a5f8bafe-edf0-11ea-0da3-3330861ae43a
# ╠═b6b65b94-edf0-11ea-3686-fbff0ff53d08
# ╟─d862fb16-edf1-11ea-36ec-615d521e6bc0
# ╟─e3394c8a-edf0-11ea-1bb8-619f7abb6881
# ╟─693af19c-64cc-11eb-31f3-57ab2fbae597
# ╟─6361d102-64cc-11eb-31b7-fb631b632040
# ╠═ae542fe4-64cc-11eb-29fc-73b7a66314a9
# ╟─c29292b8-64cc-11eb-28db-b52c46e865e6
# ╟─7b04331a-6bcb-11eb-34fa-1f5b151e5510
# ╟─5319c03c-64cc-11eb-0743-a1612476e2d3
# ╠═3db09d92-64cc-11eb-0333-45193c0fd1fe
# ╟─61606acc-6bcc-11eb-2c80-69ceec9f9702
# ╟─dd183eca-6018-11eb-2a83-2fcaeea62942
# ╟─8ddcb286-602a-11eb-3ae0-07d3c77a0f8c
# ╠═f4b0aa23-2d76-4d88-b2a4-3807e88d27ce
# ╠═1b2b2b18-64d4-11eb-2d43-e31cb8bc25d1
# ╟─2b0e6450-64d4-11eb-182b-ff1bd515b56f
# ╠═3b2b041a-64d4-11eb-31dd-47d7321ee909
# ╟─0f35603a-64d4-11eb-3baf-4fef06d82daa
# ╠═e69b02c6-64d6-11eb-02f1-21c4fb5d1043
# ╟─fce76132-64d6-11eb-259d-b130038bbae6
# ╟─17a69736-64d7-11eb-2c6c-eb5ebf51b285
# ╠═291b04de-64d7-11eb-1ee0-d998dccb998c
# ╟─647fddf2-60ee-11eb-124d-5356c7014c3b
# ╠═7d9ad134-60ee-11eb-1b2a-a7d63f3a7a2d
# ╠═8433b862-60ee-11eb-0cfc-add2b72997dc
# ╟─5e52d12e-64d7-11eb-0905-c9038a404e24
# ╟─6aba7e62-64d7-11eb-2c49-7944e9e2b94b
# ╟─afc66dac-64d7-11eb-1ad0-7f62c20ffefb
# ╠═b37c9868-64d7-11eb-3033-a7b5d3065f7f
# ╟─b1dfe122-64dc-11eb-1104-1b8852b2c4c5
# ╟─cfc55140-64d7-11eb-0ff6-e59c70d01d67
# ╟─fca72490-64d7-11eb-1464-f5e0582c4d18
# ╠═88933746-6028-11eb-32de-13eb6ff43e29
# ╟─1c539b02-64d8-11eb-3505-c9288357d139
# ╟─10f6e6da-64d8-11eb-366f-11f16e73043b
# ╟─82a8314c-64d8-11eb-1acb-e33625381178
# ╟─576d5e3a-64d8-11eb-10c9-876be31f7830
# ╠═2a94a2cf-b697-4b0b-afd0-af2e35af2bb1
# ╠═3e0ece65-b8a7-4be7-ae44-6d7210c2e15b
# ╠═4ee18bee-13e6-4478-b2ca-ab66100e57ec
# ╟─ace86c8a-60ee-11eb-34ef-93c54abc7b1a
# ╟─b08e57e4-60ee-11eb-0e1a-2f49c496668b
# ╟─9025a5b4-6066-11eb-20e8-099e9b8f859e
# ╟─45815734-ee0a-11ea-2982-595e1fc0e7b1
# ╟─5da8cbe8-eded-11ea-2e43-c5b7cc71e133
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
# ╟─3ef77236-1867-4d02-8af2-ff4777fcd6d9
# ╟─61b29e7d-5aba-4bc8-870b-c1c43919c236
# ╟─a9fef6c9-e911-4d8c-b141-a4832b40a260
# ╟─edf900be-601b-11eb-0456-3f7cfc5e876b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
