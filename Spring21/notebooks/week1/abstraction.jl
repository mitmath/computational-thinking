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

# ╔═╡ da1d65a0-ec42-11ea-0141-334c9eeeb035
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI", "Images", "ImageMagick"])
	using PlutoUI
	using Images
end

# ╔═╡ 5ef51c3a-70a7-11eb-2023-31113399a57f
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
"><em>Section 1.2</em></p>
<p style="text-align: center; font-size: 2rem;">
<em>Introduction to Abstraction</em>
</p>
</div>

<style>
body {
overflow-x: hidden;
}
</style>
"""


# ╔═╡ 60ae819a-70a7-11eb-31d4-750c7f5dc6ca
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 4a63c446-7acd-11eb-13d9-eb04606d801b
md"# Lecture Video"

# ╔═╡ 5619f15a-7acd-11eb-09cf-1f339dd92e0e
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/3zTO3LEY-cM" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 792c6a62-ec41-11ea-01f3-73e7eee23cc7
md"""
#### Intializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ ef1bfa16-70ea-11eb-189c-a54db292cd6f
md"
## Introduction

The goal of this section is to introduce you to the notion of abstraction. You can think of abstraction as an opposite to specialization. We will illustrate this by looking at the following example.

### What is _one_?

Before we get lost talking about the foundations of number theory, I will present you with a few examples that represent one to me. 
"

# ╔═╡ 6fcac482-70ee-11eb-0b80-ff41c708053b
md"Each of the items in this list is a specific, or **_specialized_** representation of _one_:
1. as an integer
1. as a float
1. as a string
1. as a rational number
1. as a cute picture
1. as an 2x2 identity matrix
1. as a singular dog

Of course, these are just a few examples of _one_. People have been representing _one_ for ages in different langauges, scripts, artistic expression, etc.

The difference between these ones to me is clear. In fact, I just articulated it to you. Now, let's turn to how a computer sees _one_ differently based on what I type.
"

# ╔═╡ 9ebc079a-70f0-11eb-07d9-f9e80f3f4584
md"So to a computer, all of these are different types."

# ╔═╡ 15f7f90a-70f0-11eb-0d41-63677e4023f4
md"### What is a collection of _one_s?

Now, I want to make a collection of ones for some reason. Below is a way for you to experiment building this collection with different _one_s. As you do this experiment, I want you to look at what stays in the same in the Julia output, and what doesn't."

# ╔═╡ f6886d90-70ed-11eb-07c4-471ee267e7c1
md"""
Before we even look at the output, I am amazed that this code even ran. Are you telling me that the computer doesn't care which _one_ I am using in my array?

Yes! That's exactly what abstraction is. By stepping back, we can now think and operate at a level that doesn't care about which _specific_ one I am using. This is what we mean by **abstraction is the opposite of specialization**.

The information that Julia gives back is quite informative. Here is an example of the first line of the output for a few different types: 

```
array = 3x4 Array{Int64, 2}
array = 3x4 Array{Float64, 2}
array = 3x4 Array{Rational{Int64}, 2}
```

Notice that for all of these, we have the same `3x4 Array{***, 2}`. 
"""

# ╔═╡ 3c1a3cf8-70f8-11eb-3c18-375207f321eb
md"""
## First Taste of Abstraction

Now, I want to do something to a collection of ones, that doesn't care about which one I'm using. So I'm going to write a function that takes in my collection, and add a corgi whereever I desire.
"""

# ╔═╡ 19f4ddb0-ec44-11ea-20b9-5d97fb2b1cf4
function insert(new, A, i, j)
	B = copy(A)
	B[i,j] = new
	return B
end

# ╔═╡ 424f5f10-ec44-11ea-076d-f3cba4435e0c
begin	
	A = fill(0, 3, 4)
	md"""
	$(@bind i Slider(1: size(A,1), show_value=true))  
	$(@bind j Slider(1: size(A,2), show_value=true))
	"""
end

# ╔═╡ 71ac08ea-7145-11eb-237d-5506adfb9533
begin
	one_number_array = fill(1,3,4)
	insert(5, one_number_array, i, j)
end

# ╔═╡ ee43d808-70fa-11eb-0cc6-337279f41494
md"This is still amazing. I wrote one function that just cares about how to insert an object into an array, without knowing anything about what's inside, and it worked for two completely different arrays, _collections of ones of **any kind**_."

# ╔═╡ 263a8a0a-70ee-11eb-236d-c941ba63dff3
md"
## Conclusion
The key idea here is that a computer language should allow you to do operations that make sense. Often times, an operation can make sense for many different objects. So we can abstract away the specifics of the object in our implementation. It should let you step back from there.
"

# ╔═╡ 52461588-ea1a-4e7d-aec2-3de388d31656
md"""
## Appendix
"""

# ╔═╡ 1a2a9000-ec43-11ea-3f39-8312ea286a92
begin
	oneimage = load(download("https://gallery.yopriceville.com/var/albums/Free-Clipart-Pictures/Decorative-Numbers/Cute_Number_One_PNG_Clipart_Image.png?m=1437447301"))
	corgi = load(download("https://i.barkpost.com/wp-content/uploads/2015/01/corgi2.jpg?q=70&fit=crop&crop=entropy&w=808&h=500"))
	nothing
end


# ╔═╡ 0504ac94-70ee-11eb-1c4e-977d9e7d35c9
one = [
	1,
	1.0,
	"one",
	1//1,
	oneimage,
	[1 0; 0 1],
	corgi,
]

# ╔═╡ 0b1668ba-ec42-11ea-3e50-ed97c5b17ced
computer_ones = typeof.(one)

# ╔═╡ b2239b96-70ef-11eb-0b85-21ecab25dc9f
begin
	one_keys = ["1", "1.0", "one", "1//1", "Cute One", "2x2 Identity", "One Corgi"] 
	selections = one_keys .=> one_keys
	lookup_element = Dict(one_keys .=> one)
	md"$(@bind element_key Select(selections))"
end

# ╔═╡ 4251f668-70aa-11eb-3d89-35f8d53b7d9b
# your chosen one
element = lookup_element[element_key]

# ╔═╡ f1568d10-ec41-11ea-3dd2-a9cb273ce5b8
#its type
typeof(element)

# ╔═╡ ab02d850-ec41-11ea-10b2-a1b600b12658
# a 3x4 array of this one.
array = fill(element,3,4)

# ╔═╡ 5363a400-ec44-11ea-284e-d13a8872551c
begin
	one_image_array = fill(oneimage,3,4)
	insert(corgi, one_image_array, i, j)
end

# ╔═╡ Cell order:
# ╟─5ef51c3a-70a7-11eb-2023-31113399a57f
# ╟─60ae819a-70a7-11eb-31d4-750c7f5dc6ca
# ╟─4a63c446-7acd-11eb-13d9-eb04606d801b
# ╟─5619f15a-7acd-11eb-09cf-1f339dd92e0e
# ╟─792c6a62-ec41-11ea-01f3-73e7eee23cc7
# ╟─ef1bfa16-70ea-11eb-189c-a54db292cd6f
# ╠═0504ac94-70ee-11eb-1c4e-977d9e7d35c9
# ╟─6fcac482-70ee-11eb-0b80-ff41c708053b
# ╠═0b1668ba-ec42-11ea-3e50-ed97c5b17ced
# ╟─9ebc079a-70f0-11eb-07d9-f9e80f3f4584
# ╟─15f7f90a-70f0-11eb-0d41-63677e4023f4
# ╠═b2239b96-70ef-11eb-0b85-21ecab25dc9f
# ╠═4251f668-70aa-11eb-3d89-35f8d53b7d9b
# ╠═f1568d10-ec41-11ea-3dd2-a9cb273ce5b8
# ╠═ab02d850-ec41-11ea-10b2-a1b600b12658
# ╟─f6886d90-70ed-11eb-07c4-471ee267e7c1
# ╟─3c1a3cf8-70f8-11eb-3c18-375207f321eb
# ╠═19f4ddb0-ec44-11ea-20b9-5d97fb2b1cf4
# ╠═424f5f10-ec44-11ea-076d-f3cba4435e0c
# ╠═5363a400-ec44-11ea-284e-d13a8872551c
# ╠═71ac08ea-7145-11eb-237d-5506adfb9533
# ╟─ee43d808-70fa-11eb-0cc6-337279f41494
# ╟─263a8a0a-70ee-11eb-236d-c941ba63dff3
# ╟─52461588-ea1a-4e7d-aec2-3de388d31656
# ╠═da1d65a0-ec42-11ea-0141-334c9eeeb035
# ╠═1a2a9000-ec43-11ea-3f39-8312ea286a92
