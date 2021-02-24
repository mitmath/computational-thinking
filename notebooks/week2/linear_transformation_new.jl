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
			])

	using Images
	using PlutoUI
	using HypertextLiteral
	using LinearAlgebra
end

# ╔═╡ 6399bbd0-7645-11eb-3af4-ffcae99be6d4
using ForwardDiff

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
"><em>Section 1.4</em></p>
<p style="text-align: center; font-size: 2rem;">
<em>Linear and Nonlinear Transformations</em>
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

# ╔═╡ 58a520ca-763b-11eb-21f4-3f27aafbc498
md"""
Last time, recall we defined linear combinations of images.  Remember we
* scaled an image by  multiplying by a constant
* combined images by adding the colors in each pixel possibly saturating
In general if we perform both of these operations, we get a linear combination.
"""

# ╔═╡ acecb4e0-763b-11eb-1a48-73a4ed908a20


# ╔═╡ 2cca0638-7635-11eb-3b60-db3fabe6f536
md"""
# 4.1 Functions in Math and Julia
"""

# ╔═╡ c8a3b5b4-76ac-11eb-14f0-abb7a33b104d
md"""
### 4.1.1 Univariate Functions
"""

# ╔═╡ db56bcda-76aa-11eb-2447-5d9076789244
md"""
In high school you learned about univariate functions e.g. 
* $f₁(x)=x^2$
* $f₂(x)=\sin(x)$
* $f₃(x)=x^\alpha$

In Julia, functions can be written in short form, anonymous form, or long form.
"""

# ╔═╡ 539aeec8-76ab-11eb-32a3-95c6672a0ea9
# short form
f₁(x) = x^2 # subscript unicode:   \_1 + <tab>   

# ╔═╡ 81a00b78-76ab-11eb-072a-6b96847c2ce4
f₁(5)

# ╔═╡ 2369fb18-76ab-11eb-1189-85309c8f925b
# anonymous form
x->sin(x)

# ╔═╡ 98498f84-76ab-11eb-23cf-857c776a9163
(x->sin(x))(π/2)

# ╔═╡ c6c860a6-76ab-11eb-1dec-1b2f179a0fa9
# long form
function f₃(x,α=3) # default parameter
	return x^α  # the "return" is optional
end

# ╔═╡ f07fbc6c-76ab-11eb-3382-87c7d65b4078
 f₃(5)

# ╔═╡ f4fa8c1a-76ab-11eb-302d-bd410432e3cf
f₃(5,2)

# ╔═╡ b3faf4d8-76ac-11eb-0be9-7dda3d37aba0
md"""
Keywords
"""

# ╔═╡ 71c074f0-76ac-11eb-2164-c36381212bff
f₄(x;α) = x^α

# ╔═╡ 87b99c8a-76ac-11eb-1c94-8f1ffe3be593
f₄(2, α=5)

# ╔═╡ 504076fc-76ac-11eb-30c3-bfa75c991cb2
md"""
See [Julia's function documentation](https://docs.julialang.org/en/v1/manual/functions/) for more.
"""

# ╔═╡ f1dd24d8-76ac-11eb-1de7-a763a1b95668
md"""
### 4.1.2 Automatic Differentiation
"""

# ╔═╡ fe01da74-76ac-11eb-12e3-8320340b6139
md"""
Automatic differentiation is a key enabling technology for machine learning and so much of scientific computing.  It derives the answer in a manner that is interestingly different from the symbolic differentiation of elementary calculus classes and the numerical differentiation of simple finite differences.  See the video at the end of this lecture.
"""

# ╔═╡ d42aec08-76ad-11eb-361a-a1f2c90fd4ec
ForwardDiff.derivative(f₁, 5)

# ╔═╡ 06437040-76ae-11eb-0b1c-23a6470f41c8
ForwardDiff.derivative( x->f₃(x,3), 5)

# ╔═╡ 28cd454c-76ae-11eb-0d1e-a56995100d59
md"""
Notice the use of anonymous functions to fix the parameter α=3
"""

# ╔═╡ 38b51946-76ae-11eb-2c8a-e19b30bf42cb
md"""
In case you have forgotten what a derivative is, we remind you with a simple finite difference approximation:
"""

# ╔═╡ 632a1f8c-76ae-11eb-2088-15c3e3c0a210
md"""
``\log_{10}ϵ=``
$(@bind ϵ Slider((-1:-1:-6), show_value=true))
"""

# ╔═╡ 8a99f186-76af-11eb-031b-f1c288993c7f
ϵ

# ╔═╡ ad728ee6-7639-11eb-0b23-c37f1366fb4e
md"""
You have very likely learned how to multiply matrices times vectors.  I'll bet you think of a matrix as a table of numbers, and a vector as a column of numbers, and if you are well practiced, you know just when to multiply and just when to add.
Congratulations, you now can do what computers excel at.

**But what does it all mean?**
"""

# ╔═╡ 0b4b1a7e-763a-11eb-0564-ff4651915311
md"""
What about 3 dimensions?
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

# ╔═╡ 4d4e6b32-763b-11eb-3021-8bc61ac07eea
md"""
Matrices are often thought of as containers of numbers in a rectangular array, and hence one thinks of manipulating these tables like a spreadsheet, but actually the deeper meaning is that it is a transformation.
"""

# ╔═╡ 69627546-763f-11eb-29a3-5b176eae0b82


# ╔═╡ 3b6f34f0-7640-11eb-20d3-0fb0c7b266e3
md"""
show this visually
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

# ╔═╡ ce55beee-7643-11eb-04bc-b517703facff
@bind α Slider(.1:.1:3, show_value=true)

# ╔═╡ f2b121a6-7637-11eb-3c85-11a0be6f0c13
begin
	id((x,y)) = (x,y)
	shear((x,y)) = (x+y,y)
	rotate((x,y)) = (θ=π/6; (cos(θ)*x + sin(θ)*y, -sin(θ)*x + cos(θ)*y))
	scalex((x,y)) = (.5*x,y)
	scaley((x,y)) = (x,.3*y)
	warp((x,y)) = ( r = √(x^2+y^2); θ=α*r; (cos(θ)*x + sin(θ)*y, -sin(θ)*x + cos(θ)*y))
end

# ╔═╡ 56689460-7645-11eb-02f4-c1cc1c188ee7


# ╔═╡ de5766ec-7645-11eb-2430-77feb1ab2769


# ╔═╡ 6af30328-7645-11eb-1c6e-2507c138353c
warp( [1,2] )

# ╔═╡ 903d5b6c-7645-11eb-0bca-bbe6d89cbb87
begin
	 warpvector(x) = [ warp(x)...]
	ForwardDiff.jacobian( warpvector, [1,2] )
end

# ╔═╡ 60532aa0-740c-11eb-0402-af8ff117f042
md"Show grid lines $(@bind show_grid CheckBox(default=true))"

# ╔═╡ b0e5ebac-7631-11eb-0d7a-9b822cdb7011
rθ(x) = ( norm(x), atan(x[2],x[1]))

# ╔═╡ 766522d0-7632-11eb-17ce-4987172a198e
xy((r,θ)) = ( r*cos(θ), r*sin(θ))

# ╔═╡ 3de8d816-7637-11eb-1d0e-2d7ad17b7dc5
begin
	functions = [ warp, id , shear, rotate, rθ, xy, scalex, scaley]
	function_keys = ["warp", "id", "shear", "rotate", "rθ", "xy","scalex","scaley"]
	lookup_element = Dict(function_keys .=> functions)
	
	md"""
	#### Choose a function
	$(@bind the_key Select(function_keys))
	"""
end

# ╔═╡ 3b57547c-7639-11eb-0fe7-333b90c1eeff
h = lookup_element[the_key]

# ╔═╡ 965f7a0e-7637-11eb-25fa-dd75fccae46a
lookup_element[the_key]([6,7])

# ╔═╡ 082a1caa-7638-11eb-10e1-83a26e89cc10
lookup_element[the_key]((6,7))

# ╔═╡ 2efaa336-7630-11eb-0c17-a7d4a0141dac
@bind z Slider(.1:.1:3, show_value=true)

# ╔═╡ 488d732c-7631-11eb-38c3-e9a9165d5606
	@bind f Slider(.1:1:3, show_value=true)


# ╔═╡ 005ca75a-7622-11eb-2ba4-9f450e71df1f
let

range = -1.5:.1:1.5
md"""
This is a "scrubbable matrix" -- click on the number and drag to change.	
	
``(``	
a= $(@bind a Scrubbable( range; default=1.0))
b= $(@bind b Scrubbable( range; default=0.0))
``)``

``(``
c= $(@bind c Scrubbable(range; default=0.0 ))
d= $(@bind d Scrubbable(range; default=1.0))
``)``
	
	**Re-run this cell to reset to identity transformation**
"""
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

# ╔═╡ c536dafb-4206-4689-ad6d-6935385d8fdf
md"""
## Appendix
"""

# ╔═╡ fb509fb4-9608-421d-9c40-a4375f459b3f
det_A = det(A)

# ╔═╡ 40655bcc-6d1e-4d1e-9726-41eab98d8472
img_sources = [
	"https://user-images.githubusercontent.com/6933510/108605549-fb28e180-73b4-11eb-8520-7e29db0cc965.png" => "Corgis",
	"https://user-images.githubusercontent.com/6933510/108883855-39690f80-7606-11eb-8eb1-e595c6c8d829.png" => "Arrows",
	"https://images.squarespace-cdn.com/content/v1/5cb62a904d546e33119fa495/1589302981165-HHQ2A4JI07C43294HVPD/ke17ZwdGBToddI8pDm48kA7bHnZXCqgRu4g0_U7hbNpZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PISCdr-3EAHMyS8K84wLA7X0UZoBreocI4zSJRMe1GOxcKMshLAGzx4R3EDFOm1kBS/fluffy+corgi?format=2500w" => "Alan"
]

# ╔═╡ c0c90fec-0e55-4be3-8ea2-88b8705ee258
md"""
#### Choose an image:

$(@bind img_source Select(img_sources))
"""

# ╔═╡ 4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
img_original = load(download(img_source));

# ╔═╡ 52a8009e-761c-11eb-2dc9-dbccdc5e7886
typeof(img_original)

# ╔═╡ b754bae2-762f-11eb-1c6a-01251495a9bb
begin
	white(c::RGB) = RGB(1,1,1)
	white(c::RGBA) = RGBA(1,1,1,0.75)
end

# ╔═╡ 7d0096ad-d89a-4ade-9679-6ee95f7d2044
function trygetpixel(img::AbstractMatrix, x::Float64, y::Float64)
	rows, cols = size(img)
	
	"The linear map [-1,1] ↦ [0,1]"
	f = t -> (t - -1.0)/(1.0 - -1.0)
	
	i = floor(Int, rows *  f(-y) / z)
	j = floor(Int, cols *  f(x * (rows / cols))  / z)
 
	if 1 < i ≤ rows && 1 < j ≤ cols
		img[i,j]
	else
		white(img[1,1])

	end
end

# ╔═╡ 83d45d42-7406-11eb-2a9c-e75efe62b12c
function with_gridlines(img::Array{<:Any,2}; n=16)
	
	sep_i = size(img, 1) ÷ n
	sep_j = size(img, 2) ÷ n
	
	result = copy(img)
	# stroke = zero(eltype(img))#RGBA(RGB(1,1,1), 0.75)
	
	stroke = RGBA(1, 1, 1, 0.75)
	
	result[1:sep_i:end, :] .= stroke
	result[:, 1:sep_j:end] .= stroke

	# a second time, to create a line 2 pixels wide
	result[2:sep_i:end, :] .= stroke
	result[:, 2:sep_j:end] .= stroke
	
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

# ╔═╡ 8d8ac24a-761d-11eb-1e93-9563dd88e74b
height, width = size(img)

# ╔═╡ 8e0505be-359b-4459-9de3-f87ec7b60c23
[
	if det_A == 0
		RGB(1.0, 1.0, 1.0)
	else
		
		 # in_x, in_y = A \ [out_x, out_y]
         # in_x, in_y = xy( [out_x, out_y] )
		in_x, in_y =  h([out_x, out_y])
		trygetpixel(img, in_x, in_y)
	end
	
	for out_y in LinRange(f, -f, 500),
		out_x in LinRange(-f, f, 500)
]

# ╔═╡ d4f20fa0-763e-11eb-22ea-9915a81c6884
img

# ╔═╡ Cell order:
# ╟─972b2230-7634-11eb-028d-df7fc722ec70
# ╟─b7895bd2-7634-11eb-211e-ef876d23bd88
# ╠═6b473b2d-4326-46b4-af38-07b61de287fc
# ╠═58a520ca-763b-11eb-21f4-3f27aafbc498
# ╠═acecb4e0-763b-11eb-1a48-73a4ed908a20
# ╟─2cca0638-7635-11eb-3b60-db3fabe6f536
# ╟─c8a3b5b4-76ac-11eb-14f0-abb7a33b104d
# ╟─db56bcda-76aa-11eb-2447-5d9076789244
# ╠═539aeec8-76ab-11eb-32a3-95c6672a0ea9
# ╠═81a00b78-76ab-11eb-072a-6b96847c2ce4
# ╠═2369fb18-76ab-11eb-1189-85309c8f925b
# ╠═98498f84-76ab-11eb-23cf-857c776a9163
# ╠═c6c860a6-76ab-11eb-1dec-1b2f179a0fa9
# ╠═f07fbc6c-76ab-11eb-3382-87c7d65b4078
# ╠═f4fa8c1a-76ab-11eb-302d-bd410432e3cf
# ╟─b3faf4d8-76ac-11eb-0be9-7dda3d37aba0
# ╠═71c074f0-76ac-11eb-2164-c36381212bff
# ╠═87b99c8a-76ac-11eb-1c94-8f1ffe3be593
# ╟─504076fc-76ac-11eb-30c3-bfa75c991cb2
# ╟─f1dd24d8-76ac-11eb-1de7-a763a1b95668
# ╟─fe01da74-76ac-11eb-12e3-8320340b6139
# ╠═d42aec08-76ad-11eb-361a-a1f2c90fd4ec
# ╠═06437040-76ae-11eb-0b1c-23a6470f41c8
# ╟─28cd454c-76ae-11eb-0d1e-a56995100d59
# ╟─38b51946-76ae-11eb-2c8a-e19b30bf42cb
# ╠═632a1f8c-76ae-11eb-2088-15c3e3c0a210
# ╠═8a99f186-76af-11eb-031b-f1c288993c7f
# ╠═ad728ee6-7639-11eb-0b23-c37f1366fb4e
# ╠═0b4b1a7e-763a-11eb-0564-ff4651915311
# ╠═62b28c02-763a-11eb-1418-c1e30555b1fa
# ╠═4d4e6b32-763b-11eb-3021-8bc61ac07eea
# ╠═69627546-763f-11eb-29a3-5b176eae0b82
# ╠═3b6f34f0-7640-11eb-20d3-0fb0c7b266e3
# ╠═4c93d784-763d-11eb-1f48-81d4d45d5ce0
# ╠═559660cc-763d-11eb-1ed8-017b93ed4ecb
# ╟─2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
# ╠═c0c90fec-0e55-4be3-8ea2-88b8705ee258
# ╠═f2b121a6-7637-11eb-3c85-11a0be6f0c13
# ╠═ce55beee-7643-11eb-04bc-b517703facff
# ╠═3de8d816-7637-11eb-1d0e-2d7ad17b7dc5
# ╠═3b57547c-7639-11eb-0fe7-333b90c1eeff
# ╠═965f7a0e-7637-11eb-25fa-dd75fccae46a
# ╠═082a1caa-7638-11eb-10e1-83a26e89cc10
# ╠═56689460-7645-11eb-02f4-c1cc1c188ee7
# ╠═de5766ec-7645-11eb-2430-77feb1ab2769
# ╠═6399bbd0-7645-11eb-3af4-ffcae99be6d4
# ╠═6af30328-7645-11eb-1c6e-2507c138353c
# ╠═903d5b6c-7645-11eb-0bca-bbe6d89cbb87
# ╟─60532aa0-740c-11eb-0402-af8ff117f042
# ╠═8d8ac24a-761d-11eb-1e93-9563dd88e74b
# ╠═8e0505be-359b-4459-9de3-f87ec7b60c23
# ╠═d4f20fa0-763e-11eb-22ea-9915a81c6884
# ╠═b0e5ebac-7631-11eb-0d7a-9b822cdb7011
# ╠═766522d0-7632-11eb-17ce-4987172a198e
# ╠═2efaa336-7630-11eb-0c17-a7d4a0141dac
# ╠═488d732c-7631-11eb-38c3-e9a9165d5606
# ╟─005ca75a-7622-11eb-2ba4-9f450e71df1f
# ╟─f085296d-48b1-4db6-bb87-db863bb54049
# ╟─d1757b2c-7400-11eb-1406-d937294d5388
# ╠═5227afd0-7641-11eb-0065-918cb8538d55
# ╠═2835e33a-7642-11eb-33fd-79fb8ad27fa7
# ╟─c536dafb-4206-4689-ad6d-6935385d8fdf
# ╟─fb509fb4-9608-421d-9c40-a4375f459b3f
# ╠═40655bcc-6d1e-4d1e-9726-41eab98d8472
# ╠═4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
# ╠═52a8009e-761c-11eb-2dc9-dbccdc5e7886
# ╠═55898e88-36a0-4f49-897f-e0850bd2b0df
# ╠═7d0096ad-d89a-4ade-9679-6ee95f7d2044
# ╠═b754bae2-762f-11eb-1c6a-01251495a9bb
# ╠═83d45d42-7406-11eb-2a9c-e75efe62b12c
