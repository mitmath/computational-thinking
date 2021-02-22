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

# ╔═╡ 86f770fe-74a1-11eb-01f7-5b3ecf057124
begin
	using PlutoUI 
	using Images
	using Unitful 
	using ImageFiltering
end

# ╔═╡ febfa62a-74fa-11eb-2fe6-df7de43ef4b6
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
"><em>Section 1.3</em></p>
<p style="text-align: center; font-size: 2rem;">
<em>Transformations with Images<br></em>
</p>
</div>

<style>
body {
overflow-x: hidden;
}
</style>
"""

# ╔═╡ 8d389d80-74a1-11eb-3452-f38eff03483b
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 4d332c7e-74f8-11eb-1f49-a518246d1db8
md"""
# Announcement: Lectures will be nearly an hour
"""

# ╔═╡ f7689472-74a8-11eb-32a1-8379ae5c88e1
rotabook = load(download("https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1348902666l/1646354.jpg"))

# ╔═╡ 0f2f9004-74a8-11eb-01a2-973dbe80f166
md"""
##  **Never run overtime** (a microcentury with UnitFul)

Running overtime is the one unforgivable error a lecturer can make.
After fifty minutes (one microcentury as von Neumann used to say)
everybody's attention will turn elsewhere even if we are trying to prove
the Riemann hypothesis. One minute overtime can destroy the best of
lectures. (from "Indiscrete Thoughts" by Rota, Chpt 18, 10 Lessons I Wish I Had Been Taught)
"""

# ╔═╡ 962143a8-74a7-11eb-26c3-c10548f326ee
century = 100u"yr" #  a u"yr" is a special kind of string denoting a unit of a year

# ╔═╡ c2964c80-74f8-11eb-3a74-b1bdd9e4ae02
century * 2

# ╔═╡ caf488d8-74f8-11eb-0075-0586d66c23c1
century/200

# ╔═╡ 02dd4a02-74f9-11eb-3d1e-53d83cee8062
century^2

# ╔═╡ 10ef13d2-74f9-11eb-2849-fb9f83db6ae9
g = 9.8u"m"/u"s"^2

# ╔═╡ b76a56f4-74a9-11eb-1739-fbfc5e4958e8

uconvert(u"minute", century * 1e-6 ) # convert into minutes the value of a microcentury


# ╔═╡ 77fbf18a-74f9-11eb-1d9e-3f9d2097388f
PotentialEnergy = (10u"kg") * g * (50u"m")

# ╔═╡ bcb69db6-74f9-11eb-100a-29d1d23963ab
uconvert( u"J",PotentialEnergy)

# ╔═╡ fc70c4d2-74f8-11eb-33f5-539c278ed6b6
md"""
Adding units to numbers **just works** in Julia, and furthermore, does not slow down execution.  We are sneaking in an example of the power of generic programming and Julia's type system, some of the underlying technology that makes us love working with Julia.  More on this later in the book.  Meanwhile if this helps you do your problem sets in some other class, go for it.
"""

# ╔═╡ 2f7cde78-74a2-11eb-1e2f-81b5b2465819
md"""
# Reminder

**Try your own pictures everywhere!**
"""

# ╔═╡ e099815e-74a1-11eb-1541-033f6abe9f8e
md"""
# Chapter 2. Transforming Images
"""

# ╔═╡ e82a4dd8-74b0-11eb-1108-6b09e67a80c1
md"""
## 2.1. Downsampling / Upsampling
"""

# ╔═╡ 39552b7a-74fb-11eb-04e0-3981ada52c92
md"""
How can we pixelate a corgi? Found this cute picture online, but we'll pixelate
a real corgi.
"""

# ╔═╡ 14f2b85e-74ad-11eb-2682-d9de646aedf3
pixelated_corgi = load(download("https://i.redd.it/99lhfbnwpgd31.png"))

# ╔═╡ 516e73e2-74fb-11eb-213e-9dbd9472e0db
philip =  load(download("https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png"))

# ╔═╡ b5d0ef90-74fb-11eb-3126-792f954c7be7
@bind r Slider(1:40, show_value=true, default=40)

# ╔═╡ 754c3704-74fb-11eb-1199-2b9798d7251f
downsample_philip = philip[1:r:end, 1:r:end]

# ╔═╡ 9eb917ba-74fb-11eb-0527-15e981ce9c6a
upsample_philip = kron(downsample_philip, fill(1,r,r))

# ╔═╡ 486d3022-74ff-11eb-1865-e15436bd9aad
md"""
  Note the use of kron and fill. See [Wikipedia Kron](https://en.wikipedia.org/wiki/Kronecker_product)
"""

# ╔═╡ b9da7332-74ff-11eb-241b-fb87e77d646a
md"""
Exercise: Use the nose selection tool from Section 1.1 to pixelate a rectangle of an image.  Warning: you'll have to worry about sizes if not exact multiples.
"""

# ╔═╡ 339ccfca-74b1-11eb-0c35-774da6b189ed
md"""
## 2.2 Linear Combinations (Combining Images) 
"""

# ╔═╡ 8711c698-7500-11eb-2505-d35a4de169b4
md"""
One big idea in mathematics is the [linear combination](https://en.wikipedia.org/wiki/Linear_combination).
The idea combines 
- scaling an object 
- combining two or more objects
by combining scaled versions of multiple objects.
"""

# ╔═╡ 84350cb8-7501-11eb-095e-8f1a7e015f25
md"""
Let's scale some corgis.
"""

# ╔═╡ 91a1bca4-74aa-11eb-3917-1dfd73d0ad9c
corgis = load(download("https://user-images.githubusercontent.com/6933510/108605549-fb28e180-73b4-11eb-8520-7e29db0cc965.png"))

# ╔═╡ 8e698bdc-7501-11eb-1d2e-c336ccbde0b0
@bind c Slider(0:.1:3, show_value=true, default=1)

# ╔═╡ ab2bc924-7501-11eb-03ba-8dfc1ffe3f36
c .* corgis  # scaling the corgis changes intensity

# ╔═╡ e11d6300-7501-11eb-239a-135596309d20
md"""
 You might wonder about the **dot times** or **pointwise times**. You can
delete the dot, but it is recommended for clarity
and performance.  The dot emphasizes that the multiplication by c is happening
pixel by pixel or that the scalar is being "broadcast" to every pixel.
"""

# ╔═╡ 9a66c07e-7503-11eb-3127-7fce91b3a24a
md"""
Scaling too far saturates the image.  (Any r,g,b ≥ 1, saturates at 1.)
"""

# ╔═╡ 47d40406-7502-11eb-2f43-cd5c848f25a6
md"""
We need another image.  We could grab one from somewhere or we can just transform the one we have.  Let's do the latter and turn the corgis upsidedown.
"""

# ╔═╡ 9ce0b980-74aa-11eb-0678-01209451fb65
upsidedown_corgis = corgis[ end:-1:1 , :]

# ╔═╡ 68821bf4-7502-11eb-0d3c-03d7a00fdba4
md"""
Now let's scaled version of the two images to see what that does.
"""

# ╔═╡ 447e7c9e-74b1-11eb-27ea-71aa4338b11a
(.5 * upsidedown_corgis .+ .5 * corgis) 

# ╔═╡ c9dff6f4-7503-11eb-2715-0bf9d3ece9e1
md"""
### Convex Combinations
"""

# ╔═╡ d834103c-7503-11eb-1a94-1fbad43801ff
md"""
If all the coefficients are positive and add to 1, we say we have a **convex combination**.  Let's take α and (1-α) as the two coefficients adding to 1, and
scale the two corgi pictures with different α's, thereby giving different weights to the rightside-up and upside-down corgis.
"""

# ╔═╡ aa541288-74aa-11eb-1edc-ab6d7786f271
    @bind α Slider(0:.01:1 , show_value=true, default = 1.0)

# ╔═╡ c9dcac48-74aa-11eb-31a6-23357180c1c8
α .* corgis .+ (1-α) .* upsidedown_corgis

# ╔═╡ 30b1c1f0-7504-11eb-1be7-a9463caea809
md"""
The moment I did this with α = .5, I noticed my brain's tendency to see the 
rightsisde-up corgis even though both have equal weight.  For me maybe
around α = .39 which gives weight .61 to the upside-down corgis "feels" balanced
to me.  I think this is what the field of psychology called psychometrics 
tries to measure -- perhaps someone can tell me if there are studies of the
brain's tendency to use world experience to prefer rightside-up corgis,
and in particular to put a numerical value to this tendency.
"""

# ╔═╡ 1fe70e38-751b-11eb-25b8-c741e1726613
md"""
10 seconds with google and I found there is a thing about faces:
[The Face Inversion effect](https://en.wikipedia.org/wiki/Face_inversion_effect#:~:text=The%20face%20inversion%20effect%20is,same%20for%20non%2Dfacial%20objects.&text=The%20most%20supported%20explanation%20for,is%20the%20configural%20information%20hypothesis.)

... the article suggests objects don't suffer in the same way as faces,
so I put forth that the phenomenon applies to corgi faces as much as human faces,
suggesting maybe that corgi faces are processed in the **face processing** part of the brain,not the **object processing** part of the brain.

Corgis are human, after all, right?

(Note, this is 5 minutes of armchair science, not a professional opinion.)
"""

# ╔═╡ 215291ec-74a2-11eb-3476-0dab43fd5a5e
md"""
## 2.3 Fun with Photoshop (What does "filter" mean in this context?)
"""

# ╔═╡ 61db42c6-7505-11eb-1ddf-05e906234572
md"""
[Photshop Filter Reference](https://helpx.adobe.com/photoshop/using/filter-effects-reference.html)
"""

# ╔═╡ cdd4cffc-74b1-11eb-1aa4-e333cb8601d1
md"""
Let's play with photoshop if for no other reason, let's see what image transformations are available considered useful by the pros.
"""

# ╔═╡ 7489a570-74a3-11eb-1d0b-09d41604ffe1
md"""
## 2.4 Image Filtering (convolutions)
"""

# ╔═╡ 8a8e3f5e-74b2-11eb-3eed-e5468e573e45
md"""
Last semester Grant Sanderson (3Blue1Brown) lectured in this course.  This lecture on convolutions in image processing was popular.  Let's watch an excerpt (from 1:04 to 2:48).  (We pick a few exercepts, but we wouldn't blame you if you just wanted to
watch the whole video.)
"""

# ╔═╡ 5864294a-74a5-11eb-23ef-f38a582f2c2d
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/8rrHTtUzyZA?start=64&end=168" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ fa9c465e-74b2-11eb-2f3c-4be0e7f93bb5
md"""
### Definition of convolutions and kernels
"""

# ╔═╡ 4fab4616-74b0-11eb-0088-6b50237d7d54
md"""
[Wikipedia Page on Kernels]
(https://en.wikipedia.org/wiki/Kernel_(image_processing)#Details)
"""

# ╔═╡ 275bf7ac-74b3-11eb-32c3-cda1e4f1f8c2
md"""
### Computer Science: Complexity

The number of multiplications = (Number of Pixels in the Image) * (Number of Cells in the kernel)
"""

# ╔═╡ 537c54e4-74b3-11eb-341f-951b4a1e0b40
md"""
Thought Problem: Why are small kernels better than large kernels?
"""

# ╔═╡ 662d73b6-74b3-11eb-333d-f1323a001000
md"""
### Computer Science: Data Structure: Offset Arrays
"""

# ╔═╡ 844ed844-74b3-11eb-2ee1-2de664b26bc6
md"""
  ### Gaussian Filter
"""

# ╔═╡ 4ffe927c-74b4-11eb-23a7-a18d7e51c75b
md"""
In our next Grant Sanderson segment from Fall 2020 (4:35 to 7:00), we hear about
convolving images with a Gaussian kernel.  
"""

# ╔═╡ 91109e5c-74b3-11eb-1f31-c50e436bc6e0
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/8rrHTtUzyZA?start=275&end=420" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ c0aec7ae-7505-11eb-2822-a151aad48fc9
md"""
This is often known as Gausssian blur to emphasize the result of this operation.
[Adobe on Gaussian blur](https://www.adobe.com/creativecloud/photography/discover/gaussian-blur.html).
"""

# ╔═╡ 0f765670-7506-11eb-2a37-931b15bb387f
md"""
## 2.5. Discrete vs Continuous
"""

# ╔═╡ 82737d28-7507-11eb-1e39-c7dc12e18882
md"""
Some folks only like discrete objects, others continuous.  The computer makes clear what many mathematicians already know, that while different language has evolved to describe discrete objects vs continuous objects, often the underlying conceptual idea is similar or the same.  Here is one analogy:
"""

# ╔═╡ 40d538b2-7506-11eb-116b-efeb16b3478d
md"""
### Blurring Kernels :: Integrals  ≡ Sharpening Kernels :: Derivatives
"""

# ╔═╡ df060a88-7507-11eb-034b-5346d67a0e0d
md"""
Think about integrals vs derivatives in one dimension.
If you replace f(x) with g(x) = ∫ f(t) dt for x-r ≤ t ≤ x+r, that will blur or smooth out the features of f.  However if you take the derivative,you will emphasize the changes, i.e., you will sharpen or "edge-detect."
"""

# ╔═╡ 60c8db60-7506-11eb-1468-c989809c933a
md"""
## 2.6 Respect my Boundaries
"""

# ╔═╡ 8ed0be60-7506-11eb-2769-5f7da1c66243
md"""
Applying the convolution on a boundary requires special thought because it is literally an **edge case**.  Once again Grant said this so very well: (2:53-4:19)
"""

# ╔═╡ b9d636da-7506-11eb-37a6-3116d47b2787
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/8rrHTtUzyZA?start=173&end=259" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ Cell order:
# ╟─febfa62a-74fa-11eb-2fe6-df7de43ef4b6
# ╠═86f770fe-74a1-11eb-01f7-5b3ecf057124
# ╟─8d389d80-74a1-11eb-3452-f38eff03483b
# ╟─4d332c7e-74f8-11eb-1f49-a518246d1db8
# ╟─f7689472-74a8-11eb-32a1-8379ae5c88e1
# ╟─0f2f9004-74a8-11eb-01a2-973dbe80f166
# ╠═962143a8-74a7-11eb-26c3-c10548f326ee
# ╠═c2964c80-74f8-11eb-3a74-b1bdd9e4ae02
# ╠═caf488d8-74f8-11eb-0075-0586d66c23c1
# ╠═02dd4a02-74f9-11eb-3d1e-53d83cee8062
# ╠═10ef13d2-74f9-11eb-2849-fb9f83db6ae9
# ╠═b76a56f4-74a9-11eb-1739-fbfc5e4958e8
# ╠═77fbf18a-74f9-11eb-1d9e-3f9d2097388f
# ╠═bcb69db6-74f9-11eb-100a-29d1d23963ab
# ╟─fc70c4d2-74f8-11eb-33f5-539c278ed6b6
# ╟─2f7cde78-74a2-11eb-1e2f-81b5b2465819
# ╟─e099815e-74a1-11eb-1541-033f6abe9f8e
# ╟─e82a4dd8-74b0-11eb-1108-6b09e67a80c1
# ╟─39552b7a-74fb-11eb-04e0-3981ada52c92
# ╠═14f2b85e-74ad-11eb-2682-d9de646aedf3
# ╠═516e73e2-74fb-11eb-213e-9dbd9472e0db
# ╠═b5d0ef90-74fb-11eb-3126-792f954c7be7
# ╠═754c3704-74fb-11eb-1199-2b9798d7251f
# ╠═9eb917ba-74fb-11eb-0527-15e981ce9c6a
# ╟─486d3022-74ff-11eb-1865-e15436bd9aad
# ╟─b9da7332-74ff-11eb-241b-fb87e77d646a
# ╟─339ccfca-74b1-11eb-0c35-774da6b189ed
# ╟─8711c698-7500-11eb-2505-d35a4de169b4
# ╟─84350cb8-7501-11eb-095e-8f1a7e015f25
# ╠═91a1bca4-74aa-11eb-3917-1dfd73d0ad9c
# ╠═8e698bdc-7501-11eb-1d2e-c336ccbde0b0
# ╠═ab2bc924-7501-11eb-03ba-8dfc1ffe3f36
# ╟─e11d6300-7501-11eb-239a-135596309d20
# ╟─9a66c07e-7503-11eb-3127-7fce91b3a24a
# ╟─47d40406-7502-11eb-2f43-cd5c848f25a6
# ╠═9ce0b980-74aa-11eb-0678-01209451fb65
# ╟─68821bf4-7502-11eb-0d3c-03d7a00fdba4
# ╠═447e7c9e-74b1-11eb-27ea-71aa4338b11a
# ╟─c9dff6f4-7503-11eb-2715-0bf9d3ece9e1
# ╟─d834103c-7503-11eb-1a94-1fbad43801ff
# ╠═aa541288-74aa-11eb-1edc-ab6d7786f271
# ╠═c9dcac48-74aa-11eb-31a6-23357180c1c8
# ╟─30b1c1f0-7504-11eb-1be7-a9463caea809
# ╟─1fe70e38-751b-11eb-25b8-c741e1726613
# ╟─215291ec-74a2-11eb-3476-0dab43fd5a5e
# ╟─61db42c6-7505-11eb-1ddf-05e906234572
# ╟─cdd4cffc-74b1-11eb-1aa4-e333cb8601d1
# ╟─7489a570-74a3-11eb-1d0b-09d41604ffe1
# ╟─8a8e3f5e-74b2-11eb-3eed-e5468e573e45
# ╟─5864294a-74a5-11eb-23ef-f38a582f2c2d
# ╟─fa9c465e-74b2-11eb-2f3c-4be0e7f93bb5
# ╟─4fab4616-74b0-11eb-0088-6b50237d7d54
# ╟─275bf7ac-74b3-11eb-32c3-cda1e4f1f8c2
# ╟─537c54e4-74b3-11eb-341f-951b4a1e0b40
# ╟─662d73b6-74b3-11eb-333d-f1323a001000
# ╟─844ed844-74b3-11eb-2ee1-2de664b26bc6
# ╟─4ffe927c-74b4-11eb-23a7-a18d7e51c75b
# ╟─91109e5c-74b3-11eb-1f31-c50e436bc6e0
# ╟─c0aec7ae-7505-11eb-2822-a151aad48fc9
# ╟─0f765670-7506-11eb-2a37-931b15bb387f
# ╟─82737d28-7507-11eb-1e39-c7dc12e18882
# ╟─40d538b2-7506-11eb-116b-efeb16b3478d
# ╟─df060a88-7507-11eb-034b-5346d67a0e0d
# ╟─60c8db60-7506-11eb-1468-c989809c933a
# ╟─8ed0be60-7506-11eb-2769-5f7da1c66243
# ╟─b9d636da-7506-11eb-37a6-3116d47b2787
