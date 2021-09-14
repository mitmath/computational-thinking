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

# ╔═╡ 6b473b2d-4326-46b4-af38-07b61de287fc
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
	using LinearAlgebra
	using ForwardDiff
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

# ╔═╡ d49682ff-d529-4283-871b-f8ee50a4e6ee


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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ColorVectorSpace = "~0.9.6"
Colors = "~0.12.8"
FileIO = "~1.11.1"
ForwardDiff = "~0.10.19"
HypertextLiteral = "~0.9.0"
ImageIO = "~0.5.8"
ImageShow = "~0.3.2"
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

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

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

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "4866e381721b30fac8dda4c8cb1d9db45c8d2994"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.37.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "3ed8fa7178a10d1cd0f1ca524f249ba6937490c0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.0"

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

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "NaNMath", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "b5e930ac60b613ef3406da6d4f42c35d8dc51419"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.19"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "2c1cf4df419938ece72de17f368a021ee162762e"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.0"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "4d4c9c69972c6f4db99a70d71c5cc074dd2abbf1"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.3"

[[ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "595155739d361589b3d074386f77c107a8ada6f7"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.2"

[[ImageIO]]
deps = ["FileIO", "Netpbm", "OpenEXR", "PNGFiles", "TiffImages", "UUIDs"]
git-tree-sha1 = "13c826abd23931d909e4c5538643d9691f62a617"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.5.8"

[[ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "e439b5a4e8676da8a29da0b7d2b498f2db6dbce3"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.2"

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

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

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
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "34dc30f868e368f8a17b728a1238f3fcda43931a"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.3"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

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
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

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

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

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

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

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

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

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
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
