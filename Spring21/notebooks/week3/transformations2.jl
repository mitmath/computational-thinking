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

# ╔═╡ 2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

# ╔═╡ 6b473b2d-4326-46b4-af38-07b61de287fc
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Images", version="0.22.4"), 
			Pkg.PackageSpec(name="ImageMagick", version="0.7"), 
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="HypertextLiteral", version="0.5"), 
			Pkg.PackageSpec(name="ForwardDiff"),
			Pkg.PackageSpec(name="NonlinearSolve"),
			Pkg.PackageSpec(name="StaticArrays")
			])

	using Images
	using PlutoUI
	using HypertextLiteral
	using LinearAlgebra
	using ForwardDiff
	using NonlinearSolve
	using StaticArrays
end

# ╔═╡ 4c7c9fa4-76c1-11eb-0ac8-e3a0e7bc902b


# ╔═╡ 972b2230-7634-11eb-028d-df7fc722ec70
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
"><em>Section 1.4 cont </em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Transformations2, Composability,  Linearity/Nonlinearity </em>
</p>
</div>

<style>
body {
overflow-x: hidden;
}
</style>
"""


# ╔═╡ b7895bd2-7634-11eb-211e-ef876d23bd88
PlutoUI.TableOfContents(aside=true)

# ╔═╡ e0b657ce-7a03-11eb-1f9d-f32168cb5394
md"""
# The fun stuff.
"""

# ╔═╡ 45dccdec-7912-11eb-01b4-a97e30344f39
md"Show grid lines $(@bind show_grid CheckBox(default=true))"

# ╔═╡ ef3f9cb0-7a03-11eb-177f-65f281148496
begin
	
corgis = "https://user-images.githubusercontent.com/6933510/108605549-fb28e180-73b4-11eb-8520-7e29db0cc965.png"
longcorgi = "https://images.squarespace-cdn.com/content/v1/5cb62a904d546e33119fa495/1589302981165-HHQ2A4JI07C43294HVPD/ke17ZwdGBToddI8pDm48kA7bHnZXCqgRu4g0_U7hbNpZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PISCdr-3EAHMyS8K84wLA7X0UZoBreocI4zSJRMe1GOxcKMshLAGzx4R3EDFOm1kBS/fluffy+corgi?format=2500w";
	
end

# ╔═╡ 96766502-7a06-11eb-00cc-29849773dbcf

img_original = load(download(corgis)); 
#img_original = load(download(longcorgi));
#img_original = #load(download("https://news.mit.edu/sites/default/files/styles/news_article__image_gallery/public/images/202004/edelman%2520philip%2520sanders.png?itok=ZcYu9NFeg "));


# ╔═╡ ce55beee-7643-11eb-04bc-b517703facff
md"""
α= $(@bind α Slider(-3:.1:3, show_value=true))
"""

# ╔═╡ 23ade8ee-7a09-11eb-0e40-296c6b831d74
md"""
Grab a linear or nonlinear transform (see TOC) or make up your own
"""

# ╔═╡ a7df7346-79f8-11eb-1de6-71f027c46643
md"""
# Pedagogical Note: Why the Module 1 application = image processing.

Image processing is a great way to learn Julia, some linear algebra, and some nonlinear mathematics.  We don't presume the audience will become professional image processors, but we do believe that the principles learned transcend so many applications. ... and everybody loves playing with their own images.  
"""

# ╔═╡ 044e6128-79fe-11eb-18c1-395ae857dc73
md"""
# Last Lecture Leftovers
"""

# ╔═╡ 78d61e28-79f9-11eb-0605-e77d206cda84
md"""
## Interesting question about linear transformations.
If a transformation takes lines into lines and preserves the origin is it linear?
Answer = no.

The example of a **perspective map** takes all lines into lines, but paralleograms generally do not become parallelograms. 
"""

# ╔═╡ aad4d6e4-79f9-11eb-0342-b900a41cfbaf
md"""
[A nice interactive demo of perspective maps](https://www.khanacademy.org/humanities/renaissance-reformation/early-renaissance1/beginners-renaissance-florence/a/linear-perspective-interactive) from Khan academy.
"""

# ╔═╡ d42aec08-76ad-11eb-361a-a1f2c90fd4ec
load(download("https://cdn.kastatic.org/ka-perseus-images/1b351a3653c1a12f713ec24f443a95516f916136.jpg"))

# ╔═╡ e965cf5e-79fd-11eb-201d-695b54d08e54
md"""
## Julia style (a little advanced): Reminder about defining vector valued functions
"""

# ╔═╡ 1e11c1ec-79fe-11eb-1867-9da72b3f3bc4
md"""
Many people find it hard to read 


`f(v) = [ v[1]+v[2] , v[1]-v[2] ]  ` or 
`  f = v ->  [ v[1]+v[2] , v[1]-v[2] ]  `

favoring instead

`f((x,y)) = [ x+y , x-y ] ` or
` f = ((x,y),) -> [ x+y , x-y ] `.

All four of these will take a 2-vector to a 2-vector in the same way for the purposes of this lecture, i.e. f( [1,2] ) can be defined by any of the four forms.

The forms with the `->` are anonymous forms.  (They are still
considered anonymous even though we name them `f`.)

**The anonymous form** comes in handy when one wants a function to depend on a parameter.

For example 

`f(α) = ((x,y),) -> [ x + αy, x - αy]`

allows you to apply the f(7) function to [1,2] by running
` f(7)([1,2]) ` .

"""

# ╔═╡ a0afe3ae-76b9-11eb-2301-cde7260ddd7f
md"""
# Linear Transformations (A collection)
"""

# ╔═╡ d364f91a-76b9-11eb-1807-75e733940d53
begin
	 id((x,y)) = [x,y]
	 scalex(α) = ((x,y),) -> [α*x, y]
	 scaley(α) = ((x,y),) -> [x,   α*y]
	 scale(α) = ((x,y),)  -> [α*x, α*y]
	 translate(α,β) = ((x,y),) -> [x+α, y+β]
	 swap((x,y)) = [y,x]
	 flipy((x,y)) = [x,-y]
	 rotate(θ) = ((x,y),) -> [cos(θ)*x + sin(θ)*y, -sin(θ)*x + cos(θ)*y]
	 shear(α) = ((x,y),) -> [x+α*y,y]
	 ## General linear
	 lin(a,b,c,d) = ((x,y),) -> [ a*x + b*y ; c*x + d*y ]
	 lin(A) = v-> A*[v...]  # abbreviation for the above		 	
end

# ╔═╡ a290d5e2-7a02-11eb-37db-41bf86b1f3b3
md"""
# Nonlinear Transformations (A collection)
"""

# ╔═╡ b4cdd412-7a02-11eb-149a-df1888a0f465
begin
  nonlin_shear(α) = ((x,y),) -> [x+α*y^2,y+α*x^2]
  warp(α) = ((x,y),) -> rotate(α*√(x^2+y^2))([x,y])
  xy((r,θ)) = [ r*cos(θ), r*sin(θ) ]
  rθ(x) = ( norm(x), atan(x[2],x[1])) # maybe vectors are more readable here?
  # exponentialish =  ((x,y),) -> [log(x+1.2), log(y+1.2)]
  # merc = ((x,y),) ->  [ log(x^2+y^2)/2 , atan(y,x) ] # (reim(log(complex(y,x)) ))
end

# ╔═╡ 58a30e54-7a08-11eb-1c57-dfef0000255f
# T = shear(α)
T = nonlin_shear(α)
# T = warp(α)


# ╔═╡ c9a148f0-76bb-11eb-0778-9d3e84369a19
md"""
We bet you have noticed that these functions could all have been defined with matrices. Indeed the general case can be written
"""

# ╔═╡ db4bc328-76bb-11eb-28dc-eb9df8892d01
# [a b;c d] * [x,y]

# ╔═╡ 89f0bc54-76bb-11eb-271b-3190b4d8cbc0
md"""
or in math `` \begin{pmatrix} a & b \\ c & d \end{pmatrix}
\begin{pmatrix} x \\ y \end{pmatrix}`` .
"""

# ╔═╡ f70f7ea8-76b9-11eb-3bd7-87d40a2861b1
md"""
By contrast here are a few fun functions that can not be written as matrix times
vector.  What characterizes the matrix ones from the non-matrix ones?
"""

# ╔═╡ bf28c388-76bd-11eb-08a7-af2671218017
md"""
This may be a little fancy, but we see that warp is a rotation, but the
rotation depends on the point where it is applied.
"""

# ╔═╡ 5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
begin	
	warp₂(α,x,y) = rotate(α*√(x^2+y^2))
	warp₂(α) = ((x,y),) -> warp₂(α,x,y)([x,y])	
end

# ╔═╡ 56f1e4cc-7a03-11eb-187b-c5a917978eb9
warp3(α) = ((x,y),) -> rotate(α*√(x^2+y^2))([x,y])

# ╔═╡ 70dc4346-7a03-11eb-055e-111d2519a44c
warp3(1)([1,2])

# ╔═╡ 852592d6-76bd-11eb-1265-5f200e39113d
warp(1)([5,6])

# ╔═╡ 8e36f4a2-76bd-11eb-2fda-9d1424752812
warp₂(1.0)([5.0,6.0])

# ╔═╡ ad728ee6-7639-11eb-0b23-c37f1366fb4e
md"""
## 4.2 But what is a transformation, really? 
You have very likely learned how to multiply matrices times vectors.  I'll bet you think of a matrix as a table of numbers, and a vector as a column of numbers, and if you are well practiced, you know just when to multiply and just when to add.
Congratulations, you now can do what computers excel at.

"""

# ╔═╡ 4d4e6b32-763b-11eb-3021-8bc61ac07eea
md"""
Matrices are often thought of as containers of numbers in a rectangular array, and hence one thinks of manipulating these tables like a spreadsheet, but actually the deeper meaning is that it is a transformation.
"""

# ╔═╡ 005ca75a-7622-11eb-2ba4-9f450e71df1f
let

range = -1.5:.1:1.5
md"""
This is a "scrubbable matrix" -- click on the number and drag to change.	
	
``(``	
 $(@bind a Scrubbable( range; default=1.0))
 $(@bind b Scrubbable( range; default=0.0))
``)``

``(``
$(@bind c Scrubbable(range; default=0.0 ))
$(@bind d Scrubbable(range; default=1.0))
``)``
	
	**Re-run this cell to reset to identity transformation**
"""
end

# ╔═╡ 2efaa336-7630-11eb-0c17-a7d4a0141dac
md"""
zoom = $(@bind  z Scrubbable(.1:.1:3,  default=1))
"""

# ╔═╡ 7f28ac40-7914-11eb-1403-b7bec34aeb94
md"""
pan = [$(@bind panx Scrubbable(-1:.1:1, default=0)), 
$(@bind pany Scrubbable(-1:.1:1, default=0)) ]
"""

# ╔═╡ 0897814e-793e-11eb-1483-354b81310eba
begin
	C = randn(2,2)
	B = randn(2,2)
end

# ╔═╡ ed3caab2-76bf-11eb-2544-21e8181adef5
# T =   id ∘   scalexy(1/z)  ∘ translate(-panx,-pany)  # Pick a transformation
# first shear, then scale, then pan because it is all backwards
#T = shear(2)
#T = 	nlshear(α)   ∘ scalexy(1/z)
#T =id
#T = lin(B) ∘ lin(C) ∘  scalexy(1/z)
#T =   rotate(α) ∘ (((x,y),) -> (log(x+1.2), log(y+1.2) ) )
#T = rotate(α) #∘ merc


# ╔═╡ e6f3611a-793e-11eb-185f-4757d5a8c2ac
#U =  lin(B*C) ∘  scalexy(1/z)

# ╔═╡ 67324636-7938-11eb-1afd-e7d5afa41954


# ╔═╡ 62a9201c-7938-11eb-144c-15690c06be94
begin
	function inverse(f, y, u0=@SVector[0.0, 0.0])
	    prob = NonlinearProblem{false}( (u, p) -> f(u, p) .- y, u0)
	    solver = solve(prob, NewtonRaphson(), tol = 1e-9)
	    return solver.u 
	end
	
	#inverse(f) = y -> inverse( (u, p) -> f(SVector(u...)), y )
	inverse(f) = y -> inverse( (u, p) -> f(SVector(u[1],u[2])), y )
end

# ╔═╡ f085296d-48b1-4db6-bb87-db863bb54049
A = [
	a b
	c d
	]

# ╔═╡ d1757b2c-7400-11eb-1406-d937294d5388
md"**_Det(A)_ = $a * $d - $c * $b =  $(det(A))**"

# ╔═╡ 5227afd0-7641-11eb-0065-918cb8538d55
md"""
We never seem to see this in linear algebra classes do we?

Check out
[Linear Map Wikipedia](https://en.wikipedia.org/wiki/Linear_map)

[Transformation Matrix Wikipedia](https://en.wikipedia.org/wiki/Transformation_matrix)
"""

# ╔═╡ 2835e33a-7642-11eb-33fd-79fb8ad27fa7
md"""
Geometry of determinant, how areas scale.
"""

# ╔═╡ 4c93d784-763d-11eb-1f48-81d4d45d5ce0
md"""
## Why are we doing this backwards?
"""

# ╔═╡ 559660cc-763d-11eb-1ed8-017b93ed4ecb
md"""
Computer Science
Solving 2 equations in 2 unknowns, and higher dimensional analogs.

THe top 500 supercomputers, and how many equations in how many unknowns are being solved today.
"""

# ╔═╡ a66eb6fe-76b3-11eb-1d50-659ec2bf7c44
md"""
### 4.4 Automatic Differentiation in 10 mins(ok 11)
"""

# ╔═╡ 62b28c02-763a-11eb-1418-c1e30555b1fa
md"""
What about more than 3 dimensions?

Oh I've heard it all, 
* there is no such thing as more than 3 dimensions. 
* The fourth dimension is time, isn't it?  
* I have trouble visualizing 3 dimensions, let alone contemplating 4.  

... but mathematicians have no trouble with n spatial dimensions, and they do not (usually) worry about silly questions like whether these exist.
"""

# ╔═╡ c536dafb-4206-4689-ad6d-6935385d8fdf
md"""
## Appendix
"""

# ╔═╡ fb509fb4-9608-421d-9c40-a4375f459b3f
det_A = det(A)

# ╔═╡ 40655bcc-6d1e-4d1e-9726-41eab98d8472
img_sources = [
	"https://user-images.githubusercontent.com/6933510/108605549-fb28e180-73b4-11eb-8520-7e29db0cc965.png" => "Corgis",
	"https://images.squarespace-cdn.com/content/v1/5cb62a904d546e33119fa495/1589302981165-HHQ2A4JI07C43294HVPD/ke17ZwdGBToddI8pDm48kA7bHnZXCqgRu4g0_U7hbNpZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PISCdr-3EAHMyS8K84wLA7X0UZoBreocI4zSJRMe1GOxcKMshLAGzx4R3EDFOm1kBS/fluffy+corgi?format=2500w" => "Long Corgi",
"https://previews.123rf.com/images/camptoloma/camptoloma2002/camptoloma200200020/140962183-pembroke-welsh-corgi-portrait-sitting-gray-background.jpg"=>"Portrait Corgi",
	"https://www.eaieducation.com/images/products/506618_L.jpg"=>"Graph Paper"
]

# ╔═╡ c0c90fec-0e55-4be3-8ea2-88b8705ee258
md"""
#### Choose an image:

$(@bind img_source Select(img_sources))
"""

# ╔═╡ 4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
#img_original = load(download(img_source));

# ╔═╡ 52a8009e-761c-11eb-2dc9-dbccdc5e7886
typeof(img_original)

# ╔═╡ b754bae2-762f-11eb-1c6a-01251495a9bb
begin
	white(c::RGB) = RGB(1,1,1)
	white(c::RGBA) = RGBA(1,1,1,0.75)
end

# ╔═╡ 7d0096ad-d89a-4ade-9679-6ee95f7d2044
function trygetpixel(img::AbstractMatrix, x::Float64, y::Float64)
# convert coordinate system xy to ij and translate (0,0) to (rows/2,cols/2)
	
	rows, cols = size(img)
	m = max(cols, rows)	
		    
	
	xy_to_ij =  translate(rows/2,cols/2) ∘  swap ∘  flipy ∘ scale(m/2)
	i,j = floor.(Int, xy_to_ij([x,y]))
	
	
# 	i = floor(Int,  (rows - m*y)/2  ) 
# 	j = floor(Int,  (cols + m*x)/2  )
 
	if 1 < i ≤ rows && 1 < j ≤ cols
		img[i,j]
	else
		white(img[1,1])

	end
end

# ╔═╡ 83d45d42-7406-11eb-2a9c-e75efe62b12c
function with_gridlines(img::Array{<:Any,2}; n=20)
	
	sep_i = size(img, 1) ÷ n
	sep_j = size(img, 2) ÷ n
	
	result = copy(img)
	# stroke = zero(eltype(img))#RGBA(RGB(1,1,1), 0.75)
	
	stroke = RGBA(1, 1, 1, 0.75)
	
	result[1:sep_i:end, :] .= stroke
	result[:, 1:sep_j:end] .= stroke

	# a second time, to create a line 2 pixels wide
	#result[2:sep_i:end, :] .= stroke
	#result[:, 2:sep_j:end] .= stroke
	
	 result[  sep_i * (n ÷2) .+ [1,2]    , :] .= RGBA(0,1,0,1)
	result[ : ,  sep_j * (n ÷2) .+ [1,2]    ,] .= RGBA(1,0,0,1)
	return result
end

# ╔═╡ 55898e88-36a0-4f49-897f-e0850bd2b0df
img = if show_grid
	with_gridlines(img_original)
else
	img_original
end;

# ╔═╡ f213ce72-7a06-11eb-0c81-f1cb6067fd30
[
	begin
		in_x, in_y =  T([out_x, out_y]) # apply T inverse
		trygetpixel(img, in_x, in_y)
	end
	
	
	for out_y in LinRange(1, -1, 800),
		out_x in LinRange(-1, 1, 800)
]

# ╔═╡ 7222a0f2-7a07-11eb-3560-3511fab319a2
img

# ╔═╡ 8e0505be-359b-4459-9de3-f87ec7b60c23
#[
	[
	if det_A == 0
		RGB(1.0, 1.0, 1.0)
	else
		
		 # in_x, in_y = A \ [out_x, out_y]
         # in_x, in_y = xy( [out_x, out_y] )
		in_x, in_y =  T([out_x, out_y]) # apply T inverse
		trygetpixel(img, in_x, in_y)
	end
	
	
	for out_y in LinRange(1, -1, 400),
		out_x in LinRange(-1, 1, 400)
]
# [
# 	if det_A == 0
# 		RGB(1.0, 1.0, 1.0)
# 	else
		
# 		 # in_x, in_y = A \ [out_x, out_y]
#          # in_x, in_y = xy( [out_x, out_y] )
# 		in_x, in_y =  U([out_x, out_y]) # apply T inverse
# 		trygetpixel(img, in_x, in_y)
# 	end
	
	
# 	for out_y in LinRange(1, -1, 400),
# 		out_x in LinRange(-1, 1, 400)
# ]]

# ╔═╡ 94520610-787f-11eb-278d-c1a092e5429e
size(img)

# ╔═╡ Cell order:
# ╟─4c7c9fa4-76c1-11eb-0ac8-e3a0e7bc902b
# ╟─972b2230-7634-11eb-028d-df7fc722ec70
# ╟─6b473b2d-4326-46b4-af38-07b61de287fc
# ╟─b7895bd2-7634-11eb-211e-ef876d23bd88
# ╟─e0b657ce-7a03-11eb-1f9d-f32168cb5394
# ╟─45dccdec-7912-11eb-01b4-a97e30344f39
# ╟─ef3f9cb0-7a03-11eb-177f-65f281148496
# ╠═96766502-7a06-11eb-00cc-29849773dbcf
# ╟─ce55beee-7643-11eb-04bc-b517703facff
# ╟─23ade8ee-7a09-11eb-0e40-296c6b831d74
# ╠═58a30e54-7a08-11eb-1c57-dfef0000255f
# ╟─f213ce72-7a06-11eb-0c81-f1cb6067fd30
# ╠═7222a0f2-7a07-11eb-3560-3511fab319a2
# ╟─a7df7346-79f8-11eb-1de6-71f027c46643
# ╟─044e6128-79fe-11eb-18c1-395ae857dc73
# ╟─78d61e28-79f9-11eb-0605-e77d206cda84
# ╟─aad4d6e4-79f9-11eb-0342-b900a41cfbaf
# ╟─d42aec08-76ad-11eb-361a-a1f2c90fd4ec
# ╟─e965cf5e-79fd-11eb-201d-695b54d08e54
# ╟─1e11c1ec-79fe-11eb-1867-9da72b3f3bc4
# ╟─a0afe3ae-76b9-11eb-2301-cde7260ddd7f
# ╠═d364f91a-76b9-11eb-1807-75e733940d53
# ╟─a290d5e2-7a02-11eb-37db-41bf86b1f3b3
# ╠═b4cdd412-7a02-11eb-149a-df1888a0f465
# ╟─c9a148f0-76bb-11eb-0778-9d3e84369a19
# ╠═db4bc328-76bb-11eb-28dc-eb9df8892d01
# ╠═89f0bc54-76bb-11eb-271b-3190b4d8cbc0
# ╟─f70f7ea8-76b9-11eb-3bd7-87d40a2861b1
# ╟─bf28c388-76bd-11eb-08a7-af2671218017
# ╠═5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
# ╠═56f1e4cc-7a03-11eb-187b-c5a917978eb9
# ╠═70dc4346-7a03-11eb-055e-111d2519a44c
# ╠═852592d6-76bd-11eb-1265-5f200e39113d
# ╠═8e36f4a2-76bd-11eb-2fda-9d1424752812
# ╟─ad728ee6-7639-11eb-0b23-c37f1366fb4e
# ╟─4d4e6b32-763b-11eb-3021-8bc61ac07eea
# ╟─2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
# ╠═c0c90fec-0e55-4be3-8ea2-88b8705ee258
# ╟─005ca75a-7622-11eb-2ba4-9f450e71df1f
# ╠═2efaa336-7630-11eb-0c17-a7d4a0141dac
# ╠═7f28ac40-7914-11eb-1403-b7bec34aeb94
# ╠═0897814e-793e-11eb-1483-354b81310eba
# ╠═ed3caab2-76bf-11eb-2544-21e8181adef5
# ╠═e6f3611a-793e-11eb-185f-4757d5a8c2ac
# ╠═8e0505be-359b-4459-9de3-f87ec7b60c23
# ╠═7d0096ad-d89a-4ade-9679-6ee95f7d2044
# ╠═67324636-7938-11eb-1afd-e7d5afa41954
# ╠═62a9201c-7938-11eb-144c-15690c06be94
# ╠═94520610-787f-11eb-278d-c1a092e5429e
# ╟─f085296d-48b1-4db6-bb87-db863bb54049
# ╟─d1757b2c-7400-11eb-1406-d937294d5388
# ╟─5227afd0-7641-11eb-0065-918cb8538d55
# ╟─2835e33a-7642-11eb-33fd-79fb8ad27fa7
# ╟─4c93d784-763d-11eb-1f48-81d4d45d5ce0
# ╟─559660cc-763d-11eb-1ed8-017b93ed4ecb
# ╟─a66eb6fe-76b3-11eb-1d50-659ec2bf7c44
# ╟─62b28c02-763a-11eb-1418-c1e30555b1fa
# ╟─c536dafb-4206-4689-ad6d-6935385d8fdf
# ╟─fb509fb4-9608-421d-9c40-a4375f459b3f
# ╠═40655bcc-6d1e-4d1e-9726-41eab98d8472
# ╠═4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
# ╠═52a8009e-761c-11eb-2dc9-dbccdc5e7886
# ╠═55898e88-36a0-4f49-897f-e0850bd2b0df
# ╠═b754bae2-762f-11eb-1c6a-01251495a9bb
# ╠═83d45d42-7406-11eb-2a9c-e75efe62b12c
