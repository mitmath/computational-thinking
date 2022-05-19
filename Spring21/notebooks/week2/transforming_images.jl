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

# ╔═╡ 86f770fe-74a1-11eb-01f7-5b3ecf057124
begin
	using PlutoUI 
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using Unitful 
	using ImageFiltering
	using OffsetArrays
	using Plots

	# Small patch to make images look more crisp:
	# https://github.com/JuliaImages/ImageShow.jl/pull/50
	Base.showable(::MIME"text/html", ::AbstractMatrix{<:Colorant}) = false
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
"><em>Section 1.4</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Transformations with Images </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/uZYVjDDZW9A" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 8d389d80-74a1-11eb-3452-f38eff03483b
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 9f1a72da-7532-11eb-079c-b7baccc6614a
md"""
#### Intializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 4d332c7e-74f8-11eb-1f49-a518246d1db8
md"""
# Announcement: Lectures will be nearly an hour
"""

# ╔═╡ f7689472-74a8-11eb-32a1-8379ae5c88e1
rotabook = PlutoUI.Resource("https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1348902666l/1646354.jpg")

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
# Transforming Images
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
[The Face Inversion effect](https://en.wikipedia.org/wiki/Face_inversion_effect#:~:text=The%20face%20inversion%20effect%20is,same%20for%20non%2Dfacial%20objects.&text=The%20most%20supported%20explanation%20for,is%20the%20configural%20information%20hypothesis)
and also the [Thatcher Effect](https://en.wikipedia.org/wiki/Thatcher_effect#:~:text=The%20Thatcher%20effect%20or%20Thatcher,obvious%20in%20an%20upright%20face) seems related.

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

Some worth emphasizing are
1. Blur
2. Sharpen
3. Stylize -> Find Edges
3. Pixelate
4. Distort

Some of these transformations (e.g. Blur, Sharpen, Find Edges) are examples of 
convolutions which are very efficient, and show up these days in 
machine learning particularly in image recognition.
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
Thought Problem: Why are small kernels better than large kernels from a complexity viewpoint?
"""

# ╔═╡ c6e340ee-751e-11eb-3ca7-69595b3693b7
md"""
### Computer Science: Architectures: GPUs or Graphical Processing Units

Some important computations can be greatly accelerated through the use of specialized hardware such as the GPU processors that were originally designed as image renderers but it has turned out that these processors can be quite fast at other very regular computations.  Convolutions is a very GPU friendly operation due to its regular structure.
"""

# ╔═╡ 54448d18-7528-11eb-209a-9717affa0d02
 kernelize(M) = OffsetArray( M, -1:1, -1:1)	       

# ╔═╡ acbc563a-7528-11eb-3c38-75a5b66c9241
begin
	identity = [0 0 0 ; 0 1 0 ; 0 0 0]
	edge_detect = [0 -1 0; -1 4 -1; 0 -1 0] 
	sharpen = identity .+ edge_detect  # Superposition!
	box_blur = [1 1 1;1 1 1;1 1 1]/9
	∇x = [-1 0 1;-1 0 1;-1 0 1]/2 # centered deriv in x
	∇y = ∇x'
	
	kernels = [identity, edge_detect, sharpen, box_blur, ∇x, ∇y]
	kernel_keys =["identity", "edge_detect", "sharpen", "box_blur", "∇x", "∇y"]
	selections = kernel_keys .=> kernel_keys
	kernel_matrix = Dict(kernel_keys .=> kernels)
	md"$(@bind kernel_name Select(selections))"
end

# ╔═╡ 995392ee-752a-11eb-3394-0de331e24f40
kernel_matrix[kernel_name]

# ╔═╡ d22903d6-7529-11eb-2dcd-132cd27104c2
[imfilter( corgis, kernelize(kernel_matrix[kernel_name])) Gray.(1.5 .* abs.(imfilter( corgis, kernelize(kernel_matrix[kernel_name])))) ]

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

# ╔═╡ 34109062-7525-11eb-10b3-d59d3a6dfda6
round.(Kernel.gaussian(1), digits=3)

# ╔═╡ 9ab89a3a-7525-11eb-186d-29e4b61deb7f
md"""
We could have defined this ourselves with calls to the exponential function.
"""

# ╔═╡ 50034058-7525-11eb-345b-3334e71ac50e
begin
	G = [exp( -(i^2+j^2)/2) for i=-2:2, j=-2:2]
	round.(G ./ sum(G), digits=3)
end

# ╔═╡ c0aec7ae-7505-11eb-2822-a151aad48fc9
md"""
This is often known as Gausssian blur to emphasize the result of this operation.
[Adobe on Gaussian blur](https://www.adobe.com/creativecloud/photography/discover/gaussian-blur.html).
"""

# ╔═╡ 628aea22-7521-11eb-2edc-39ac62683aea
md"""
Focus around 5:23
"""

# ╔═╡ 99eeb11c-7524-11eb-2154-df7d84976445
@bind gparam Slider(0:9, show_value=true, default=1)

# ╔═╡ 2ddcfb90-7520-11eb-2df7-172d07118b7e
kernel = Kernel.gaussian(gparam)

# ╔═╡ d62496b0-7524-11eb-3410-7177e7c7f8eb
plotly()

# ╔═╡ 6aa8a76e-7524-11eb-22b5-015aab4191b0
surface([kernel;])

# ╔═╡ ee93eeb2-7524-11eb-342d-0343d8aebf59
md"""
Note: black lines are contours
"""

# ╔═╡ 662d73b6-74b3-11eb-333d-f1323a001000
md"""
### Computer Science: Data Structure: Offset Arrays
"""

# ╔═╡ d127303a-7521-11eb-3507-7341a416211f
kernel[0,0]

# ╔═╡ d4581b56-7522-11eb-2c15-991c0c790e67
kernel[-2,2]

# ╔═╡ 40c15c3a-7523-11eb-1f2a-bd90b127dad2
M = [ 1  2  3  4  5
	  6  7  8  9 10
	 11 12 13 14 15]

# ╔═╡ 08642690-7523-11eb-00dd-63d4cf6513dc
Z = OffsetArray(M, -1:1, -2:2)

# ╔═╡ deac4cf2-7523-11eb-2832-7b9d31389b08
the_indices = [ c.I for c ∈ CartesianIndices(Z)]

# ╔═╡ 32887dfa-7524-11eb-35cd-051eff594fa9
Z[1,-2]

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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ImageFiltering = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
OffsetArrays = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
FileIO = "~1.14.0"
ImageFiltering = "~0.7.1"
ImageIO = "~0.6.2"
ImageShow = "~0.3.4"
OffsetArrays = "~1.11.0"
Plots = "~1.29.0"
PlutoUI = "~0.7.38"
Unitful = "~1.11.0"
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

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

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

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

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

[[ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

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

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "505876577b5481e50d089c1c68899dfb6faebc62"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.6"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

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

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "15bd05c1c0d5dbb32a9a3d7e0ad2d50dd6167189"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.1"

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

[[IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

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

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

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

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

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

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

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

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "e595b205efd49508358f7dc670a940c790204629"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.0.0+0"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

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

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

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

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

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

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d457f881ea56bbfa18222642de51e0abf67b9027"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.0"

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

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

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
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "e75d82493681dfd884a357952bbd7ab0608e1dc3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.7"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

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

[[TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "b649200e887a487468b71821e2644382699f1b0f"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.11.0"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

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

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─febfa62a-74fa-11eb-2fe6-df7de43ef4b6
# ╟─8d389d80-74a1-11eb-3452-f38eff03483b
# ╟─9f1a72da-7532-11eb-079c-b7baccc6614a
# ╠═86f770fe-74a1-11eb-01f7-5b3ecf057124
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
# ╟─c6e340ee-751e-11eb-3ca7-69595b3693b7
# ╠═54448d18-7528-11eb-209a-9717affa0d02
# ╠═acbc563a-7528-11eb-3c38-75a5b66c9241
# ╠═995392ee-752a-11eb-3394-0de331e24f40
# ╠═d22903d6-7529-11eb-2dcd-132cd27104c2
# ╟─844ed844-74b3-11eb-2ee1-2de664b26bc6
# ╟─4ffe927c-74b4-11eb-23a7-a18d7e51c75b
# ╟─91109e5c-74b3-11eb-1f31-c50e436bc6e0
# ╠═34109062-7525-11eb-10b3-d59d3a6dfda6
# ╟─9ab89a3a-7525-11eb-186d-29e4b61deb7f
# ╠═50034058-7525-11eb-345b-3334e71ac50e
# ╟─c0aec7ae-7505-11eb-2822-a151aad48fc9
# ╟─628aea22-7521-11eb-2edc-39ac62683aea
# ╠═99eeb11c-7524-11eb-2154-df7d84976445
# ╠═2ddcfb90-7520-11eb-2df7-172d07118b7e
# ╠═d62496b0-7524-11eb-3410-7177e7c7f8eb
# ╠═6aa8a76e-7524-11eb-22b5-015aab4191b0
# ╟─ee93eeb2-7524-11eb-342d-0343d8aebf59
# ╟─662d73b6-74b3-11eb-333d-f1323a001000
# ╠═d127303a-7521-11eb-3507-7341a416211f
# ╠═d4581b56-7522-11eb-2c15-991c0c790e67
# ╠═40c15c3a-7523-11eb-1f2a-bd90b127dad2
# ╠═08642690-7523-11eb-00dd-63d4cf6513dc
# ╠═deac4cf2-7523-11eb-2832-7b9d31389b08
# ╠═32887dfa-7524-11eb-35cd-051eff594fa9
# ╟─0f765670-7506-11eb-2a37-931b15bb387f
# ╟─82737d28-7507-11eb-1e39-c7dc12e18882
# ╟─40d538b2-7506-11eb-116b-efeb16b3478d
# ╟─df060a88-7507-11eb-034b-5346d67a0e0d
# ╟─60c8db60-7506-11eb-1468-c989809c933a
# ╟─8ed0be60-7506-11eb-2769-5f7da1c66243
# ╟─b9d636da-7506-11eb-37a6-3116d47b2787
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
