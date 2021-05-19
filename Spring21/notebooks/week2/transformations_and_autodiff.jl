### A Pluto.jl notebook ###
# v0.14.5

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

# ╔═╡ c09c8ba0-887e-11eb-07e3-71377ec0e708
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
"><em>Section 1.3</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Transformations & Autodiff </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/AAREeuaKCic" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ b7895bd2-7634-11eb-211e-ef876d23bd88
PlutoUI.TableOfContents(aside=true)

# ╔═╡ e6a09409-f262-453b-a434-bfd935306719
md"""
#### Intializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 6b473b2d-4326-46b4-af38-07b61de287fc
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		Pkg.PackageSpec(name="ImageIO", version="0.5"),
		Pkg.PackageSpec(name="ImageShow", version="0.2"),
		Pkg.PackageSpec(name="FileIO", version="1.6"),
		Pkg.PackageSpec(name="PNGFiles", version="0.3.6"),
		Pkg.PackageSpec(name="Colors", version="0.12"),
		Pkg.PackageSpec(name="ColorVectorSpace", version="0.8"),

		Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
		Pkg.PackageSpec(name="HypertextLiteral", version="0.5"), 
		Pkg.PackageSpec(name="ForwardDiff", version="0.10")
	])

	using Colors, ColorVectorSpace, ImageShow, FileIO
	using PlutoUI
	using HypertextLiteral
	using LinearAlgebra
	using ForwardDiff
end

# ╔═╡ d49682ff-d529-4283-871b-f8ee50a4e6ee
filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

# ╔═╡ 58a520ca-763b-11eb-21f4-3f27aafbc498
md"""
Last time, recall we defined linear combinations of images.  Remember we
* scaled an image by  multiplying by a constant
* combined images by adding the colors in each pixel possibly saturating
In general if we perform both of these operations, we get a linear combination.
"""

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
### 4.1.2 Automatic Differentiation of Univariates
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
begin
	md"""
	$(@bind e Slider(-6:-1, default=-1, show_value=true))
	"""
end

# ╔═╡ 8a99f186-76af-11eb-031b-f1c288993c7f
ϵ = 10.0^e

# ╔═╡ ca1dfb8a-76b0-11eb-1323-d100bdeedc2d
(sin(1+ϵ)-sin(1))/ϵ , cos(1), ForwardDiff.derivative(sin,1)

# ╔═╡ f7df6cda-76b1-11eb-11e4-8d0af0349651
md"""
### 4.1.3 Scalar Valued Multivariate Functions
"""

# ╔═╡ 63449b54-76b4-11eb-202f-3bda2f4cff4d
md"""
Sometimes we are interested in scalar valued functions of more than 1 variable.
This can be written in Julia as a function of many variables or a function of
a vector.
e.g. $f_5(x) = 5\sin(x_1*x_2) + 2x_2/4x_3$
"""

# ╔═╡ 8c6b0236-76b4-11eb-2acf-91da23bedf0e
begin
	f₅(v) = 5sin(v[1]*v[2]) + 2*v[2]/4v[3]
	f₅(x,y,z) = 5sin(x*y) + 2*y/4z
end

# ╔═╡ a397d526-76b5-11eb-3cce-4374e33324d1
f₅(1,2,3), f₅([1,2,3])

# ╔═╡ 4a57d898-76b6-11eb-15ea-7be43393922c
md"""
Better yet if you must write it the two ways ( you probably won't need to, but if you must), **don't copy code**, reuse code so if it changes in one place it changes everywhere.
"""

# ╔═╡ bf23ab30-76b5-11eb-1adb-3d74a52cddfd
begin
	f₆( x,y,z)  = 5sin(x*y) + 2*y/4z
	f₆( v ) = f₆(v[1],v[2],v[3])
end

# ╔═╡ d5d4ac48-76b6-11eb-1687-ed853c2db7c9
f₆(1,2,3), f₆([1,2,3])

# ╔═╡ 89b2d570-76ba-11eb-0389-813bbb33efea
md"""
There's one other julia idea that is a trick to make vector code more readable. If you give a tuple argument, the function works directly on vectors but is defined with readable letters.
"""

# ╔═╡ a8c28578-76ba-11eb-3f3f-af35ff0b6c74
f₇((x,y,z)) = 5sin(x*y) + 2*y/4z # more readable then 5sin(v[1]*v[2]) + 2*v[2]/4v[3]

# ╔═╡ d9e07084-76ba-11eb-18ac-c58b1bc972ba
f₇([1,2,3]) # this works with vector arguments, but not scalars (f₇(1,2,3) errros)

# ╔═╡ 42172fb6-76b7-11eb-0a11-b7e10c6881f5
md"""
You can see that the functions $f_5$  and $f_6$ has two julia methods, one with one variable, and one with three variables.
"""

# ╔═╡ 57b0cd3c-76b7-11eb-0ece-810f3a8ede00
methods(f₅)

# ╔═╡ 6d411cea-76b9-11eb-061b-87d472bc3bdd
md"""
### 4.1.4 Automatic Differentiation: Scalar valued multivariate functions
"""

# ╔═╡ bc2c6afc-76b7-11eb-0631-51f83cd73205
md"""
In many applications, including machine learning, one needs to take derivatives of the function in every argument direction.  This is known as the *gradient*.  Automatic differentiation works again:
"""

# ╔═╡ ef06cfd8-76b7-11eb-1530-1fcd7e5c5992
ForwardDiff.gradient(f₅,[1,2,3])

# ╔═╡ 051db7a0-76b8-11eb-14c7-531f42ef60b8
md"""
Remember
$f_5(x) = 5\sin(x_1*x_2) + 2x_2/4x_3$
"""

# ╔═╡ 5f1afd24-76b8-11eb-36ab-9bbb3d73b930
md"""
One can check numerically by adding a small change to each of the arguments.m
"""

# ╔═╡ 2705bf34-76b8-11eb-3aaa-d363085784ff
begin
	∂f₅∂x =  (f₅(1+ϵ, 2, 3  ) -f₅(1, 2, 3)) / ϵ
	∂f₅∂y =  (f₅(1, 2+ϵ, 3  ) -f₅(1, 2, 3)) / ϵ
	∂f₅∂z =  (f₅(1, 2,   3+ϵ) -f₅(1, 2, 3)) / ϵ
	∇f = [ ∂f₅∂x , ∂f₅∂y, ∂f₅∂z]
end

# ╔═╡ dfb9d74c-76b8-11eb-24ff-e521f1294a6f
md"""
Whether you are an expert at multivariable calculus, or you have never seen this before, I hope seeing it numerically makes the idea intuitive.
"""

# ╔═╡ 1049f458-76b9-11eb-1d2d-af0b22480121
md"""
**Important Remark**: In machine learning, and other optimization contexts, we want to minimize a scalar function of many parameters known as a "loss function."  Following the negative gradient is a standard technique for minimizing functions especially when there are many variables.  When there are only a few variables, there are better techniques.
"""

# ╔═╡ a0afe3ae-76b9-11eb-2301-cde7260ddd7f
md"""
### 4.1.5. Transformations: Vector Valued Multivariate Functions
"""

# ╔═╡ ac1ab224-76bb-11eb-13cb-0bd44bea1042
md"""
While scalar functions might technically be called a transformation, it is more common to use the term when both the input and output are multidimensional.  
"""

# ╔═╡ bcf92688-76b9-11eb-30fb-1f320a65f45a
md"""
Let us consider a few functions that take in a vector of size 2 and returns a vector of size 2.
"""

# ╔═╡ d364f91a-76b9-11eb-1807-75e733940d53
begin
	 idy((x,y)) = [x,y]
	 lin1((x,y)) =  [ 2x + 3y, -5x+4x ]
	 scalex(α) = ((x,y),) -> (α*x, y)
	 scaley(α) = ((x,y),) -> (x,   α*y)
	 rot(θ) = ((x,y),) -> [cos(θ)*x + sin(θ)*y, -sin(θ)*x + cos(θ)*y]
	 shear(α) = ((x,y),) -> [x+α*y,y]
	 genlin(a,b,c,d) = ((x,y),) -> [ a*x + b*y ; c*x + d*y ]
end

# ╔═╡ f25c6308-76b9-11eb-3563-1f0ef4cdf86a
rot(π/2)([4,5])

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

# ╔═╡ 78176284-76bc-11eb-3045-f584127f58b9
begin
	function warp(α)
		((x,y),)  -> begin
			r = √(x^2+y^2)
			θ=α*r
			rot(θ)([x,y])
		end
	end
	
	rθ(x) = ( norm(x), atan(x[2],x[1])) # maybe vectors are more readable here?
	
	xy((r,θ)) = ( r*cos(θ), r*sin(θ))
end

# ╔═╡ bf28c388-76bd-11eb-08a7-af2671218017
md"""
This may be a little fancy, but we see that warp is a rotation, but the
rotation depends on the point where it is applied.
"""

# ╔═╡ 5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
begin	
	warp₂(α,x,y) = rot(α*√(x^2+y^2))
	warp₂(α) = ((x,y),) -> warp₂(α,x,y)([x,y])	
end

# ╔═╡ 852592d6-76bd-11eb-1265-5f200e39113d
warp(1)([5,6])

# ╔═╡ 8e36f4a2-76bd-11eb-2fda-9d1424752812
warp₂(1.0)([5.0,6.0])

# ╔═╡ 09ed6d38-76be-11eb-255b-3fbf76c21097
md"""
### 4.1.6 Automatic Differentiation of Transformations
"""

# ╔═╡ 9786e2be-76be-11eb-3755-b5669c37aa64
ForwardDiff.jacobian( warp(3.0), [4,5] )

# ╔═╡ 963694d6-76be-11eb-1b27-d5d063964d24
md"""
What is this thing?
"""

# ╔═╡ b78ef2fe-76be-11eb-1f55-3d0874b298e8
begin
	∂w∂x = (warp(3.0)([4+ϵ, 5]) -   warp(3.0)([4,5]))/ϵ # This is a vector, right?
	∂w∂y = (warp(3.0)([4,   5+ϵ]) - warp(3.0)([4,5]))/ϵ # This too
	[∂w∂x ∂w∂y]
end

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

# ╔═╡ 2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

# ╔═╡ c0c90fec-0e55-4be3-8ea2-88b8705ee258
md"""
#### Choose an image:

$(@bind img_source Select(img_sources))
"""

# ╔═╡ ce55beee-7643-11eb-04bc-b517703facff
md"""
α= $(@bind α Slider(.1:.1:3, show_value=true))
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

# ╔═╡ ed3caab2-76bf-11eb-2544-21e8181adef5
#T = shear(1) # Pick a transformation
T = genlin(a,b,c,d)

# ╔═╡ 2efaa336-7630-11eb-0c17-a7d4a0141dac
md"""
center zoom = $(@bind z Slider(.1:.1:3, show_value=true, default=1))
"""

# ╔═╡ 488d732c-7631-11eb-38c3-e9a9165d5606
md"""
top left zoom =	$(@bind f Slider(.1:1:3, show_value=true, default=1))
"""

# ╔═╡ 60532aa0-740c-11eb-0402-af8ff117f042
md"Show grid lines $(@bind show_grid CheckBox(default=true))"

# ╔═╡ 8e0505be-359b-4459-9de3-f87ec7b60c23
[
	if det_A == 0
		RGB(1.0, 1.0, 1.0)
	else
		
		 # in_x, in_y = A \ [out_x, out_y]
         # in_x, in_y = xy( [out_x, out_y] )
		in_x, in_y =  T([out_x, out_y])
		trygetpixel(img, in_x, in_y)
	end
	
	for out_y in LinRange(f, -f, 500),
		out_x in LinRange(-f, f, 500)
]

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

# ╔═╡ b9dba026-76b3-11eb-1bfb-ffe9c43ced5d
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/vAp6nUMrKYg" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
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
	"https://user-images.githubusercontent.com/6933510/108883855-39690f80-7606-11eb-8eb1-e595c6c8d829.png" => "Arrows",
	"https://images.squarespace-cdn.com/content/v1/5cb62a904d546e33119fa495/1589302981165-HHQ2A4JI07C43294HVPD/ke17ZwdGBToddI8pDm48kA7bHnZXCqgRu4g0_U7hbNpZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PISCdr-3EAHMyS8K84wLA7X0UZoBreocI4zSJRMe1GOxcKMshLAGzx4R3EDFOm1kBS/fluffy+corgi?format=2500w" => "Long Corgi"
]

# ╔═╡ 4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
img_original = load(download(img_source));

# ╔═╡ 52a8009e-761c-11eb-2dc9-dbccdc5e7886
typeof(img_original)

# ╔═╡ 55898e88-36a0-4f49-897f-e0850bd2b0df
img = if show_grid
	with_gridlines(img_original)
else
	img_original
end;

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

# ╔═╡ b754bae2-762f-11eb-1c6a-01251495a9bb
begin
	white(c::RGB) = RGB(1,1,1)
	white(c::RGBA) = RGBA(1,1,1,0.75)
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

# ╔═╡ 0f63345c-8887-11eb-3ef9-37dabb46de75
<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/AAREeuaKCic" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>

# ╔═╡ Cell order:
# ╟─c09c8ba0-887e-11eb-07e3-71377ec0e708
# ╟─b7895bd2-7634-11eb-211e-ef876d23bd88
# ╟─e6a09409-f262-453b-a434-bfd935306719
# ╠═6b473b2d-4326-46b4-af38-07b61de287fc
# ╟─d49682ff-d529-4283-871b-f8ee50a4e6ee
# ╟─58a520ca-763b-11eb-21f4-3f27aafbc498
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
# ╟─632a1f8c-76ae-11eb-2088-15c3e3c0a210
# ╟─8a99f186-76af-11eb-031b-f1c288993c7f
# ╠═ca1dfb8a-76b0-11eb-1323-d100bdeedc2d
# ╟─f7df6cda-76b1-11eb-11e4-8d0af0349651
# ╟─63449b54-76b4-11eb-202f-3bda2f4cff4d
# ╠═8c6b0236-76b4-11eb-2acf-91da23bedf0e
# ╟─a397d526-76b5-11eb-3cce-4374e33324d1
# ╟─4a57d898-76b6-11eb-15ea-7be43393922c
# ╠═bf23ab30-76b5-11eb-1adb-3d74a52cddfd
# ╠═d5d4ac48-76b6-11eb-1687-ed853c2db7c9
# ╟─89b2d570-76ba-11eb-0389-813bbb33efea
# ╠═a8c28578-76ba-11eb-3f3f-af35ff0b6c74
# ╠═d9e07084-76ba-11eb-18ac-c58b1bc972ba
# ╟─42172fb6-76b7-11eb-0a11-b7e10c6881f5
# ╠═57b0cd3c-76b7-11eb-0ece-810f3a8ede00
# ╟─6d411cea-76b9-11eb-061b-87d472bc3bdd
# ╟─bc2c6afc-76b7-11eb-0631-51f83cd73205
# ╠═ef06cfd8-76b7-11eb-1530-1fcd7e5c5992
# ╟─051db7a0-76b8-11eb-14c7-531f42ef60b8
# ╟─5f1afd24-76b8-11eb-36ab-9bbb3d73b930
# ╠═2705bf34-76b8-11eb-3aaa-d363085784ff
# ╟─dfb9d74c-76b8-11eb-24ff-e521f1294a6f
# ╟─1049f458-76b9-11eb-1d2d-af0b22480121
# ╟─a0afe3ae-76b9-11eb-2301-cde7260ddd7f
# ╟─ac1ab224-76bb-11eb-13cb-0bd44bea1042
# ╟─bcf92688-76b9-11eb-30fb-1f320a65f45a
# ╠═d364f91a-76b9-11eb-1807-75e733940d53
# ╠═f25c6308-76b9-11eb-3563-1f0ef4cdf86a
# ╟─c9a148f0-76bb-11eb-0778-9d3e84369a19
# ╠═db4bc328-76bb-11eb-28dc-eb9df8892d01
# ╟─89f0bc54-76bb-11eb-271b-3190b4d8cbc0
# ╟─f70f7ea8-76b9-11eb-3bd7-87d40a2861b1
# ╠═78176284-76bc-11eb-3045-f584127f58b9
# ╟─bf28c388-76bd-11eb-08a7-af2671218017
# ╠═5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
# ╠═852592d6-76bd-11eb-1265-5f200e39113d
# ╠═8e36f4a2-76bd-11eb-2fda-9d1424752812
# ╟─09ed6d38-76be-11eb-255b-3fbf76c21097
# ╠═9786e2be-76be-11eb-3755-b5669c37aa64
# ╟─963694d6-76be-11eb-1b27-d5d063964d24
# ╠═b78ef2fe-76be-11eb-1f55-3d0874b298e8
# ╟─ad728ee6-7639-11eb-0b23-c37f1366fb4e
# ╟─4d4e6b32-763b-11eb-3021-8bc61ac07eea
# ╟─2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
# ╟─c0c90fec-0e55-4be3-8ea2-88b8705ee258
# ╟─ce55beee-7643-11eb-04bc-b517703facff
# ╟─005ca75a-7622-11eb-2ba4-9f450e71df1f
# ╠═ed3caab2-76bf-11eb-2544-21e8181adef5
# ╟─2efaa336-7630-11eb-0c17-a7d4a0141dac
# ╟─488d732c-7631-11eb-38c3-e9a9165d5606
# ╟─60532aa0-740c-11eb-0402-af8ff117f042
# ╠═8e0505be-359b-4459-9de3-f87ec7b60c23
# ╟─f085296d-48b1-4db6-bb87-db863bb54049
# ╟─d1757b2c-7400-11eb-1406-d937294d5388
# ╟─5227afd0-7641-11eb-0065-918cb8538d55
# ╟─2835e33a-7642-11eb-33fd-79fb8ad27fa7
# ╟─4c93d784-763d-11eb-1f48-81d4d45d5ce0
# ╟─559660cc-763d-11eb-1ed8-017b93ed4ecb
# ╟─a66eb6fe-76b3-11eb-1d50-659ec2bf7c44
# ╟─b9dba026-76b3-11eb-1bfb-ffe9c43ced5d
# ╟─62b28c02-763a-11eb-1418-c1e30555b1fa
# ╟─c536dafb-4206-4689-ad6d-6935385d8fdf
# ╟─fb509fb4-9608-421d-9c40-a4375f459b3f
# ╟─40655bcc-6d1e-4d1e-9726-41eab98d8472
# ╠═4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
# ╠═52a8009e-761c-11eb-2dc9-dbccdc5e7886
# ╠═55898e88-36a0-4f49-897f-e0850bd2b0df
# ╠═7d0096ad-d89a-4ade-9679-6ee95f7d2044
# ╠═b754bae2-762f-11eb-1c6a-01251495a9bb
# ╠═83d45d42-7406-11eb-2a9c-e75efe62b12c
# ╠═0f63345c-8887-11eb-3ef9-37dabb46de75
