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

# ╔═╡ 6b473b2d-4326-46b4-af38-07b61de287fc
begin
	using PlutoUI 
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using LinearAlgebra
	using ForwardDiff
	using NonlinearSolve
	using StaticArrays
	
	# Small patch to make images look more crisp:
	# https://github.com/JuliaImages/ImageShow.jl/pull/50
	Base.showable(::MIME"text/html", ::AbstractMatrix{<:Colorant}) = false
end

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
"><em>Section 1.5</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Transformations II: Composability, Linearity and Nonlinearity </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/VDPf3RjoCpY" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ b7895bd2-7634-11eb-211e-ef876d23bd88
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 230b0118-30b7-4035-ad31-520165a76fcc
md"""
#### Intializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 230cba36-9d0a-4726-9e55-7df2c6743968


# ╔═╡ 890d30b9-2cd0-4d3a-99f6-f7d3d7858fda
corgis_url = "https://user-images.githubusercontent.com/6933510/108605549-fb28e180-73b4-11eb-8520-7e29db0cc965.png"

# ╔═╡ 85fba8fb-a9ea-444d-831b-ec6489b58b4f
longcorgi_url = "https://user-images.githubusercontent.com/6933510/110868198-713faa80-82c8-11eb-8264-d69df4509f49.png"

# ╔═╡ 96766502-7a06-11eb-00cc-29849773dbcf
# img_original = load(download(corgis_url));
img_original = load(download(longcorgi_url));
# img_original = load(download(theteam_url));

# ╔═╡ 06beabc3-2aa7-4e78-9bae-dc4b37251aa2
theteam_url = "https://news.mit.edu/sites/default/files/styles/news_article__image_gallery/public/images/202004/edelman%2520philip%2520sanders.png?itok=ZcYu9NFeg"

# ╔═╡ 26dd0e98-7a75-11eb-2196-5d7bda201b19
md"""
After you select your image, we suggest moving this line above just above the top of your browser.

---------------
"""

# ╔═╡ e0b657ce-7a03-11eb-1f9d-f32168cb5394
md"""
#  The fun stuff: playing with transforms
"""

# ╔═╡ 005ca75a-7622-11eb-2ba4-9f450e71df1f
let

range = -1.5:.1:1.5
md"""
	
This is a "scrubbable" matrix: click on the number and drag to change!
	
**A =**  
	
``(``	
 $(@bind a Scrubbable( range; default=1.0))
 $(@bind b Scrubbable( range; default=0.0))
``)``

``(``
$(@bind c Scrubbable(range; default=0.0 ))
$(@bind d Scrubbable(range; default=1.0)) 
``)``  
	

	
"""
end

# ╔═╡ 23ade8ee-7a09-11eb-0e40-296c6b831d74
md"""
Grab a [linear](#a0afe3ae-76b9-11eb-2301-cde7260ddd7f) or [nonlinear](#a290d5e2-7a02-11eb-37db-41bf86b1f3b3) transform, or make up your own!
"""

# ╔═╡ 2efaa336-7630-11eb-0c17-a7d4a0141dac
md"""
zoom = $(@bind  z Scrubbable(.1:.1:3,  default=1))
"""

# ╔═╡ 7f28ac40-7914-11eb-1403-b7bec34aeb94
md"""
pan = [$(@bind panx Scrubbable(-1:.1:1, default=0)), 
$(@bind pany Scrubbable(-1:.1:1, default=0)) ]
"""

# ╔═╡ ce55beee-7643-11eb-04bc-b517703facff
md"""
α= $(@bind α Slider(-30:.1:30, show_value=true, default=0))
β= $(@bind β Slider(-10:.1:10, show_value=true, default = 5))
h= $(@bind h Slider(.1:.1:10, show_value=true, default = 5))
"""

# ╔═╡ b76a5bd6-802f-11eb-0951-1f1092dee8de
1+1

# ╔═╡ 5d33f6ea-7e9c-11eb-2fb3-dbb7cb07c60c
md"""
pixels = $(@bind pixels Slider(1:1000, default=800, show_value=true))
"""

# ╔═╡ 45dccdec-7912-11eb-01b4-a97e30344f39
md"""
Show grid lines $(@bind show_grid CheckBox(default=true))
ngrid = $(@bind ngrid Slider(5:5:20, show_value=true, default = 10))
"""

# ╔═╡ d2fb356e-7f32-11eb-177d-4f47d6c9e59b
md"""
Circular Frame $(@bind circular CheckBox(default=true))
radius = $(@bind r Slider(.1:.1:1, show_value=true, default = 1))
"""

# ╔═╡ 55b5fc92-7a76-11eb-3fba-854c65eb87f9
md"""
Above: The original image is placed in a [-1,1] x [-1 1] box and transformed.
"""

# ╔═╡ 85686412-7a75-11eb-3d83-9f2f8a3c5509
A = [a b ; c d];

# ╔═╡ a7df7346-79f8-11eb-1de6-71f027c46643
md"""
## Pedagogical note: Why the Module 1 application = image processing

Image processing is a great way to learn Julia, some linear algebra, and some nonlinear mathematics.  We don't presume the audience will become professional image processors, but we do believe that the principles learned transcend so many applications... and everybody loves playing with their own images!  
"""

# ╔═╡ 044e6128-79fe-11eb-18c1-395ae857dc73
md"""
# Last Lecture Leftovers
"""

# ╔═╡ 78d61e28-79f9-11eb-0605-e77d206cda84
md"""
## Interesting question about linear transformations
If a transformation takes lines into lines and preserves the origin, does it have to be linear?

Answer = **no**!

The example of a **perspective map** takes all lines into lines, but paralleograms generally do not become parallelograms. 
"""

# ╔═╡ aad4d6e4-79f9-11eb-0342-b900a41cfbaf
md"""
[A nice interactive demo of perspective maps](https://www.khanacademy.org/humanities/renaissance-reformation/early-renaissance1/beginners-renaissance-florence/a/linear-perspective-interactive) from Khan academy.
"""

# ╔═╡ d42aec08-76ad-11eb-361a-a1f2c90fd4ec
Resource("https://cdn.kastatic.org/ka-perseus-images/1b351a3653c1a12f713ec24f443a95516f916136.jpg")

# ╔═╡ d9115c1a-7aa0-11eb-38e4-d977c5a6b75b
md"""
**Challenge exercise**: Rewrite this using Julia and Pluto!
"""

# ╔═╡ e965cf5e-79fd-11eb-201d-695b54d08e54
md"""
## Julia style (a little advanced): Reminder about defining vector valued functions
"""

# ╔═╡ 1e11c1ec-79fe-11eb-1867-9da72b3f3bc4
md"""
Many people find it hard to read 


`f(v) = [ v[1]+v[2] , v[1]-v[2] ]  ` or 
`  f = v ->  [ v[1]+v[2] , v[1]-v[2] ]  `

and instead prefer

`f((x,y)) = [ x+y , x-y ] ` or
` f = ((x,y),) -> [ x+y , x-y ] `.

All four of these will take a 2-vector to a 2-vector in the same way for the purposes of this lecture, i.e. `f( [1,2] )` can be defined by any of the four forms.

The forms with the `->` are anonymous functions.  (They are still
considered anonymous, even though we then name them `f`.)
"""

# ╔═╡ 28ef451c-7aa1-11eb-340c-ab3a1193a3c4
md"""
## Functions with parameters
The anonymous form comes in handy when one wants a function to depend on a **parameter**.
For example:

`f(α) = ((x,y),) -> [x + αy, x - αy]`

allows you to apply the `f(7)` function to the input vector `[1, 2]` by running
`f(7)([1, 2])` .
"""

# ╔═╡ a0afe3ae-76b9-11eb-2301-cde7260ddd7f
md"""
# Linear transformations: a collection
"""

# ╔═╡ fc2deb7c-7aa1-11eb-019f-d3e3c80b9ff1
md"""
Here are a few useful linear transformations:
"""

# ╔═╡ d364f91a-76b9-11eb-1807-75e733940d53
begin
	 id((x, y)) = SA[x, y]
	
	 scalex(α) = ((x, y),) -> SA[α*x,  y]
	 scaley(α) = ((x, y),) -> SA[x,   α*y]
	 scale(α)  = ((x, y),) -> SA[α*x, α*y]
	
	 swap((x, y))  = SA[y, x]
	 flipy((x, y)) = SA[x, -y]
	
	 rotate(θ) = ((x, y),) -> SA[cos(θ)*x + sin(θ)*y, -sin(θ)*x + cos(θ)*y]
	 shear(α)  = ((x, y),) -> SA[x + α*y, y]
end

# ╔═╡ 58a30e54-7a08-11eb-1c57-dfef0000255f
# T⁻¹ = id
#  T⁻¹ = rotate(α)
  T⁻¹ = shear(α)
#   T⁻¹ = lin(A) # uses the scrubbable 
#   T⁻¹ = shear(α) ∘ shear(-α)
 # T⁻¹ = nonlin_shear(α)  
 #   T⁻¹ =   inverse(nonlin_shear(α))
#    T⁻¹ =  nonlin_shear(-α)
#  T⁻¹ =  xy 
# T⁻¹ = warp(α)
# T⁻¹ = ((x,y),)-> (x+α*y^2,y+α*x^2) # may be non-invertible

# T⁻¹ = ((x,y),)-> (x,y^2)  
# T⁻¹  = flipy ∘ ((x,y),) ->  ( (β*x - α*y)/(β - y)  , -h*y/ (β - y)   ) 

# ╔═╡ 080d87e0-7aa2-11eb-18f5-2fb6a7a5bcb4
md"""
In fact we can write down the *most general* linear transformation in one of two ways:
"""

# ╔═╡ 15283aba-7aa2-11eb-389c-e9f215bd03e2
begin
	lin(a, b, c, d) = ((x, y),) -> (a*x + b*y, c*x + d*y)
	
	lin(A) = v-> A * [v...]  # linear algebra version using matrix multiplication
end

# ╔═╡ 2612d2c2-7aa2-11eb-085a-1f27b6174995
md"""
The second version uses the matrix multiplication notation from linear algebra, which means exactly the same as the first version when 

$$A = \begin{bmatrix} a & b \\ c & d \end{bmatrix}$$
"""

# ╔═╡ a290d5e2-7a02-11eb-37db-41bf86b1f3b3
md"""
# Nonlinear transformations: a collection
"""

# ╔═╡ b4cdd412-7a02-11eb-149a-df1888a0f465
begin
  translate(α,β)  = ((x, y),) -> SA[x+α, y+β]   # affine, but not linear
	
  nonlin_shear(α) = ((x, y),) -> SA[x, y + α*x^2]
	
  warp(α)    = ((x, y),) -> rotate(α*√(x^2+y^2))(SA[x, y])
  xy((r, θ)) = SA[ r*cos(θ), r*sin(θ) ]
  rθ(x)      = SA[norm(x), atan(x[2],x[1]) ] 
  
  # exponentialish =  ((x,y),) -> [log(x+1.2), log(y+1.2)]
  # merc = ((x,y),) ->  [ log(x^2+y^2)/2 , atan(y,x) ] # (reim(log(complex(y,x)) ))
end

# ╔═╡ 704a87ec-7a1e-11eb-3964-e102357a4d1f
md"""
# Composition
"""

# ╔═╡ 4b0e8742-7a70-11eb-1e78-813f6ad005f4
let
	x = rand()
	
	( sin ∘ cos )(x) ≈ sin(cos(x))
end

# ╔═╡ 44792484-7a20-11eb-1c09-95b27b08bd34
md"""
## Composing functions in mathematics
[Wikipedia (math) ](https://en.wikipedia.org/wiki/Function_composition)

In math we talk about *composing* two functions to create a new function:
the function that takes $x$ to $\sin(\cos(x))$ is the **composition**
of the sine function and the cosine function.  

We humans tend to blur the distinction between the sine function
and the value of $\sin(x)$ at some point $x$.  The sine function
is a mathematical object by itself.  It's a thing that can be evaluated
at as many $x$'s as you like.  

If you look at the two sides of
` (sin ∘ cos )(x) ≈ sin(cos(x)) ` and see that they are exactly the same, it's time to ask yourself what's a key difference? On the left a function is built
` sin ∘ cos ` which is then evaluated at `x`.  On the right, that function
is never built.
"""



# ╔═╡ f650b788-7a70-11eb-0b20-779d2f18f111
md"""
## Composing functions in computer science
[wikipedia (cs)](https://en.wikipedia.org/wiki/Function_composition_(computer_science))

A key issue is a programming language is whether it's easy to name
the composition in that language.  In Julia one can create the function
`sin ∘ cos`  and one can readily check that ` (sin ∘ cos)(x) ` always yields the same value as `sin(cos(x))`.
"""

# ╔═╡ c852d398-7aa2-11eb-2ded-ab2e5236e9b2
md"""

## Composing functions in Julia
[Julia's  `∘` operator](https://docs.julialang.org/en/v1/manual/functions/#Function-composition-and-piping) 
follows the [mathematical typography](https://en.wikipedia.org/wiki/Function_composition#Typography) convention, as was
shown in the `sin ∘ cos` example above. We can type this symbol as `\circ<TAB>`.

"""

# ╔═╡ 061076c2-7aa3-11eb-0d04-b7cbc60e6cb2
md"""
## Composition of software at a higher level

The trend these days is to have higher-order composition of functionalities.
A good example would be that an optimization can wrap a highly complicated
program which might include all kinds of solvers, and still run successfully.
This might require the ability of the outer software to have some awareness
of the inner software.  It can be quite magical when two very different pieces of software "compose", i.e. work together.  Julia's language construction encourages composability.  We will discuss this more in a future lecture.

"""

# ╔═╡ 014c14a6-7a72-11eb-119b-f5cfc82085ca
md"""
### Find your own examples

Take some of the Linear and Nonlinear Transformations (see the Table of Contents) and find some inverses by placing them in the `T=` section of "The fun stuff" at the top of this notebook.
"""

# ╔═╡ 89f0bc54-76bb-11eb-271b-3190b4d8cbc0
md"""
Linear transformations can be written in math using matrix multiplication notation as 

$$\begin{pmatrix} a & b \\ c & d \end{pmatrix}
\begin{pmatrix} x \\ y \end{pmatrix}$$.
"""

# ╔═╡ f70f7ea8-76b9-11eb-3bd7-87d40a2861b1
md"""
By contrast, here are a few fun functions that cannot be written as matrix times
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
	warp₂(α) = ((x, y),) -> warp₂(α,x,y)([x,y])	
end

# ╔═╡ 56f1e4cc-7a03-11eb-187b-c5a917978eb9
warp3(α) = ((x, y),) -> rotate(α*√(x^2+y^2))([x,y])

# ╔═╡ 70dc4346-7a03-11eb-055e-111d2519a44c
warp3(1)([1,2])

# ╔═╡ 852592d6-76bd-11eb-1265-5f200e39113d
warp(1)([5,6])

# ╔═╡ 8e36f4a2-76bd-11eb-2fda-9d1424752812
warp₂(1.0)([5.0,6.0])

# ╔═╡ a8bf7128-7aa5-11eb-3ee9-953b0b5ccd01


# ╔═╡ ad700740-7a74-11eb-3369-15e5fd89194d
md"""
# Linear transformations: See a matrix, think beyond number arrays
"""

# ╔═╡ e051259a-7a74-11eb-12fc-99c5dc867fbd
md"""
Software writers and beginning linear algebra students see a matrix and see a lowly table of numbers.  We want you to see a *linear transformation* -- that's what professional mathematicians see.
"""

# ╔═╡ 1856ddae-7a78-11eb-3422-298e1103275b
md"""
What defines a linear transformation?  There are a few equivalent ways of giving a definition.
"""

# ╔═╡ 4b4fe818-7a78-11eb-2986-59e60063d346
md"""
**Linear transformation definitions:**
"""

# ╔═╡ 5d656494-7a78-11eb-12e8-d17856bd8c4d
md"""
- The intuitive definition:
   
   > The rectangles (gridlines) in the transformed image [above](#e0b657ce-7a03-11eb-1f9d-f32168cb5394) always become a lattice of congruent parallelograms.

- The easy operational (but devoid of intuition) definition: 

   > A transformation is linear if it is defined by $v \mapsto A*v$ (matrix times vector) for some fixed matrix $A$.

- The scaling and adding definition:

   > 1. If you scale and then transform or if you transform and then scale, the result is always the same:
   >
   > $T(cv)=c \, T(v)$ ( $v$ is any vector, and $c$ any number.)
   >
   > 2. If you add and then transform or vice versa the result is the same:
   >
   > $T(v_1+v_2) = T(v_1) + T(v_2).$ ($v_1,v_2$ are any vectors.)

- The mathematician's definition:

   > (A consolidation of the above definition.) $T$ is linear if
   >
   > $T(c_1 v_1 + c_2 v_2) = c_1 T(v_1) + c_2 T(v_2)$ for all numbers $c_1,c_2$ and vectors $v_1,v_2$.  (This can be extended to beyond 2 terms.)

"""

# ╔═╡ b0e6d1ac-7a7d-11eb-0a9e-1310dcb5957f
md"""
### The matrix
"""

# ╔═╡ 7e4ad37c-7a84-11eb-1490-25090e133a7c
Resource("https://upload.wikimedia.org/wikipedia/en/c/c1/The_Matrix_Poster.jpg")

# ╔═╡ 96f47252-7a84-11eb-3d18-e3ba79dd20c2
md"""
No not that matrix!
"""

# ╔═╡ ae5b3a32-7a84-11eb-04c0-337a74105a58
md"""
The matrix for a linear transformation $T$ is easy to write down: The first
column is $T([1, 0])$ and the second is $T([0,1])$. That's it!
"""

# ╔═╡ c9f2b61e-7a84-11eb-3841-33739a226ff9
md"""
Once we have those, the linearity relation

$$T([x,y]) = x \, T([1,0]) + y \, T([0,1]) = x \, \mathrm{(column\ 1)} + y \, \mathrm{(column\ 2)}$$

is exactly the definition of matrix times vector. Try it.
"""

# ╔═╡ 23d8a45c-7a85-11eb-3a68-ef11e6f58cac
md"""
### Matrix multiply:  You know how to do it, but  why?
"""

# ╔═╡ 4a96d516-7a85-11eb-181c-63a6b461790b
md"""
Did you ever ask yourself why matrix multiply has that somewhat complicated multiplying and adding going on?
"""

# ╔═╡ 8206e1ee-7a8a-11eb-1f26-054f6b100076
let
	 A = randn(2,2)
	 B = randn(2,2)
	 v = rand(2)
	
	(lin(A) ∘ lin(B))(v), lin(A * B)(v)
end

# ╔═╡ 7d803684-7a8a-11eb-33d2-89d5e2a05bcf
md"""
**Important:** The composition of the linear transformation is the linear transformation of the multiplied matrices!  There is only one definition of
matmul (matrix multiply) that realizes this fact.  

To see what it is exactly, remember the first column of `lin(A) ∘ lin(B)` should
be the result of computing the two matrix times vectors  $y=A*[1,0]$ then $z=A*y$,
and the second column is the same for $[0,1]$.

This is worth writing out if you have never done this.
"""

# ╔═╡ 17281256-7aa5-11eb-3144-b72777334326
md"""
Let's try doing that with random matrices:
"""

# ╔═╡ 05049fa0-7a8e-11eb-283b-cb4753c4aaf0
begin
	 
	P = randn(2, 2)
	Q = randn(2, 2)
	
	
	T₁ = lin(P) ∘ lin(Q)
	T₂ = lin(P*Q)
	
	lin(P*Q)((1, 0)), (lin(P)∘lin(Q))((1, 0))
end

# ╔═╡ 350f40f7-795f-4f33-89b8-ff9ba4819e1c
test_img = load(download(corgis_url));

# ╔═╡ 313cdcbd-5b11-41c8-9fcd-5aeaca3b8d24
test_pixels = 300;

# ╔═╡ 57848b42-7a8f-11eb-023a-cf247cb53819
md"""
`lin(P*Q)`
"""

# ╔═╡ 620ee7d8-7a8f-11eb-3888-356c27a2d591
md"""
`lin(P)∘lin(Q)`
"""

# ╔═╡ 04da7710-7a91-11eb-02a1-0b6e889150a2
md"""
# Coordinate transformations vs object transformations
"""

# ╔═╡ 155cd218-7a91-11eb-0b4c-bd028507e925
md"""
If you want to move an object to the right, the first thing you might think of is adding 1 to the $x$ coordinate of every point.  The other thing you could do is to subtract one from the first coordinate of the coordinate system.  The latter is an example of a coordinate transform.
"""

# ╔═╡ fd25da12-7a92-11eb-20c0-995e7c46b3bc
md"""
### Coordinate transform of an array $(i, j)$ vs points $(x, y)$
"""

# ╔═╡ 1ab2265e-7c1d-11eb-26df-39c4c7289243
md"""
The original image has (1,1) in the upper left corner as an array but is thought
of as existing in the entire plane.
"""

# ╔═╡ c1efc54a-7e9b-11eb-1e76-dbd0a66184a9
translate(-400,400)([1,1])

# ╔═╡ db4bc328-76bb-11eb-28dc-eb9df8892d01
md"""
# Inverses
"""

# ╔═╡ 0b8ed36c-7a1e-11eb-053c-63cf9ee0b16f
md"""
If $f$ is a function from 2-vectors to 2-vectors (say), we define the **inverse** of $f$, denoted
$f^{-1}$, to have the property that it "*undoes*" the effect of $f$, i.e.

$$f(f^{-1}(v))=v$$ 

and $f^{-1}(f(v))=v$.

This equation might be true for all $v$ or for some $v$ in a region.   
"""

# ╔═╡ 7a4e785e-7a71-11eb-07fb-cfba453a117b
md"""
## Example: Scaling up and down
"""

# ╔═╡ 9264508a-7a71-11eb-1b7c-bf6e62788115
let
	v = rand(2)
	T = rotate(30)∘rotate(-30 )
	T(v),  v 
end

# ╔═╡ e89339b2-7a71-11eb-0f97-971b2ed277d1
let	
	  T = scale(0.5) ∘ scale(2)
	
	  v = rand(2)
	  T(v) .≈ v 
end

# ╔═╡ 0957fd9a-7a72-11eb-0566-e93ef32fb626
md"""
We observe numerically that `scale(2)` and `scale(.5)` are mutually inverse transformations, i.e. each is the inverse of the other.
"""

# ╔═╡ c7cc412c-7aa5-11eb-2df1-d3d788047238
md"""
## Inverses: Solving equations
"""

# ╔═╡ ce620b8e-7aa5-11eb-370b-11e34b07d54d
md"""
What does an inverse really do?

Let's think about scaling again.
Suppose we scale an input vector $\mathbf{x}$ by 2 to get an output vector $\mathbf{x}$:

$$\mathbf{y} = 2 \mathbf{x}$$

Now suppose that you want to go backwards. If you are given $\mathbf{y}$, how do you find $\mathbf{x}$? In this particular case we see that $\mathbf{x} = \frac{1}{2} \mathbf{y}$.

If we have a *linear* transformation, we can write

$$\mathbf{y} = A \, \mathbf{x}$$

with a matrix $A$. 

If we are given $\mathbf{y}$ and want to go backwards to find the $\mathbf{x}$ from that, we need to *solve a system of linear equations*.


*Usually*, but *not always*, we can solve these equations to find a new matrix $B$ such that

$$\mathbf{x} = B \, \mathbf{y},$$

i.e. $B$ *undoes* the effect of $A$. Then we have


$$\mathbf{x} = (B \, A) * \mathbf{x},$$

so that $B * A$ must be the identity matrix. We call $B$ the *matrix inverse* of $A$, and write

$$B = A^{-1}.$$

For $2 \times 2$ matrices we can write down an explicit formula for the matrix inverse, but in general we will need a computer to run an algorithm to find the inverse.


"""

# ╔═╡ 4f51931c-7aac-11eb-13ba-4b8768ac376f
md"""
### Inverting Linear Transformations
"""

# ╔═╡ 5ce799f4-7aac-11eb-0629-ebd8a404e9d3
let
	v = rand(2)
	A = randn(2,2)
    (lin(inv(A)) ∘ lin(A))(v), v
end 

# ╔═╡ 9b456686-7aac-11eb-3aa5-25e6c3c86aff
let 
	 A = randn(2,2)
	 B = randn(2,2)
	 inv(A*B) ≈ inv(B) * inv(A)
end

# ╔═╡ c2b0a488-7aac-11eb-1d8b-edd6bd23d1fd
md"""
``A^{-1}
=
\begin{pmatrix} d & -b \\ -c & a  \end{pmatrix} / (ad-bc) \quad
``
if
``\ A \ =
\begin{pmatrix} a & b \\ c & d  \end{pmatrix} .
``
"""

# ╔═╡ 02d6b440-7aa7-11eb-1be0-b78dea91387f
md"""
### Inverting nonlinear transformations
"""

# ╔═╡ 0be9fb1e-7aa7-11eb-0116-c3e86ab82c77
md"""
What about if we have a *nonlinear* transformation $T$ -- can we invert it? In other words, if $\mathbf{y} = T(\mathbf{x})$, can we solve this to find $\mathbf{x}$ in terms of $\mathbf{y}$? 


In general this is a difficult question! Sometimes we can do so analytically, but usually we cannot.

Nonetheless, there are *numerical* methods that can sometimes solve these equations, for example the [Newton method](https://en.wikipedia.org/wiki/Newton%27s_method).

There are several implementations of such methods in Julia, e.g. in the [NonlinearSolve.jl package](https://github.com/JuliaComputing/NonlinearSolve.jl). We have used that to write a function `inverse` that tries to invert nonlinear transformations of our images.
"""

# ╔═╡ 7609d686-7aa7-11eb-310a-3550509504a1
md"""
# The Big Diagram of Transforming Images
"""

# ╔═╡ 1b9faf64-7aab-11eb-1396-6fb89be7c445
Resource("https://raw.githubusercontent.com/mitmath/18S191/Spring21/notebooks/week3/comm2.png")

# ╔═╡ 5f0568dc-7aad-11eb-162f-0d6e26f17d59
md"""
Note that we are defining the map with the inverse of T so we can go pixel by pixel in the result.
"""

# ╔═╡ 8d32fff4-7c1b-11eb-1fa1-6ff2d87bfb73
md"""
## Collisions
"""

# ╔═╡ 62a9201c-7938-11eb-144c-15690c06be94
begin
	function inverse(f, y, u0=@SVector[0.0, 0.0])
	    prob = NonlinearProblem{false}( (u, p) -> f(u, p) .- y, u0)
	    solver = solve(prob, NewtonRaphson(), tol = 1e-4)
	    return solver.u 
	end
	
	inverse(f) = y -> inverse( (u, p) -> f(SVector(u...)), y )
end

# ╔═╡ 5227afd0-7641-11eb-0065-918cb8538d55
md"""


Check out
[Linear Map Wikipedia](https://en.wikipedia.org/wiki/Linear_map)

[Transformation Matrix Wikipedia](https://en.wikipedia.org/wiki/Transformation_matrix)
"""

# ╔═╡ 4c93d784-763d-11eb-1f48-81d4d45d5ce0
md"""
## Why are we doing this backwards?

If one moves the colors forward rather than backwards you have trouble dealing
with the discrete pixels.  You may have gaps.  You may have multiple colors going
to the same pixel.

An interpolation scheme or a newton scheme could work for going forwards, but very likely care would be neeeded for a satisfying general result.
"""

# ╔═╡ c536dafb-4206-4689-ad6d-6935385d8fdf
md"""
# Appendix
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

# ╔═╡ b754bae2-762f-11eb-1c6a-01251495a9bb
begin
	white(c::RGB) = RGB(1,1,1)
	white(c::RGBA) = RGBA(1,1,1,0.75)
	black(c::RGB) = RGB(0,0,0)
	black(c::RGBA) = RGBA(0,0,0,0.75)
end

# ╔═╡ 7d0096ad-d89a-4ade-9679-6ee95f7d2044
begin
	function transform_xy_to_ij(img::AbstractMatrix, x::Float64, y::Float64)
	# convert coordinate system xy to ij 
	# center image, and use "white" when out of the boundary
		
		rows, cols = size(img)
		m = max(cols, rows)	
		
	    # function to take xy to ij
		xy_to_ij =  translate(rows/2, cols/2) ∘ swap ∘ flipy ∘ scale(m/2)
		
		# apply the function and "snap to grid"
		i, j = floor.(Int, xy_to_ij((x, y))) 
	
	end
	
	function getpixel(img,i::Int,j::Int; circular::Bool=false, r::Real=200)   
		#  grab image color or place default
		rows, cols = size(img)
		m = max(cols,rows)
		if circular
			c = (i-rows/2)^2 + (j-cols/2)^2 ≤ r*m^2/4
		else
			c = true
		end
		
		if 1 < i ≤ rows && 1 < j ≤ cols && c
			img[i, j]
		else
			# white(img[1, 1])
			black(img[1,1])
		end
		
	end
	
	
	# function getpixel(img,x::Float64,y::Float64)
	# 	i,j = transform_xy_to_ij(img,x,y)
	# 	getpixel(img,i,j)
	# end
	
	function transform_ij_to_xy(i::Int,j::Int,pixels)
	
	   ij_to_xy =  scale(2/pixels) ∘ flipy ∘ swap ∘ translate(-pixels/2,-pixels/2)
	   ij_to_xy([i,j])
	end

	    
end

# ╔═╡ da73d9f6-7a8d-11eb-2e6f-1b819bbb0185
begin
		[			    
			begin
			 x, y = transform_ij_to_xy(i,j, test_pixels)
			 X, Y =  T₁([x,y])
			 i, j = transform_xy_to_ij(test_img,X,Y)
			 getpixel(test_img,i,j)
			end	 
		
			for i = 1:test_pixels, j = 1:test_pixels
		]	
end

# ╔═╡ 30f522a0-7a8e-11eb-2181-8313760778ef
begin
		[			    
			begin
			 x, y = transform_ij_to_xy(i,j, test_pixels)
			 X, Y =  T₂([x,y])
			 i, j = transform_xy_to_ij(test_img,X,Y)
			 getpixel(test_img,i,j)
			end	 
		
			for i = 1:test_pixels, j = 1:test_pixels
		]	
end

# ╔═╡ bf1954d6-7e9a-11eb-216d-010bd761e470
transform_ij_to_xy(1,1,400)

# ╔═╡ 83d45d42-7406-11eb-2a9c-e75efe62b12c
function with_gridlines(img::Array{<:Any,2}; n = 10)
    n = 2n+1
	rows, cols = size(img)
	result = copy(img)
	# stroke = zero(eltype(img))#RGBA(RGB(1,1,1), 0.75)
	
	stroke = RGBA(1, 1, 1, 0.75)
	
	
	result[ floor.(Int, LinRange(1, rows, n)), : ] .= stroke
	# result[ ceil.(Int,LinRange(1, rows, n) ), : ] .= stroke
	result[ : , floor.(Int, LinRange(1, cols, n))] .= stroke
	# result[ : , ceil.(Int,LinRange(1, cols, n) )] .= stroke
	
	
    result[  rows ÷2    , :] .= RGBA(0,1,0,1)
	# result[  1+rows ÷2    , :] .= RGBA(0,1,0,1)
	result[ : ,  cols ÷2   ,] .= RGBA(1,0,0,1)
	# result[ : ,  1 + cols ÷2   ,] .= RGBA(1,0,0,1)
	return result
end

# ╔═╡ 55898e88-36a0-4f49-897f-e0850bd2b0df
img = if show_grid
	with_gridlines(img_original;n=ngrid)
else
	img_original
end;

# ╔═╡ ca28189e-7e9a-11eb-21d6-bd819f3e0d3a
begin
		[			    
			begin
			
			 x, y = transform_ij_to_xy(i,j, pixels)
			
			X, Y = ( translate(-panx,-pany)  )([x,y])
			 X, Y = ( T⁻¹∘scale(1/z)∘translate(-panx,-pany) )([x,y])
			 i, j = transform_xy_to_ij(img,X,Y)
			 getpixel(img,i,j; circular=circular, r=r)
			end	 
		
			for i = 1:pixels, j = 1:pixels
		]	
end

# ╔═╡ ccea7244-7f2f-11eb-1b7b-b9b8473a8c74
transform_xy_to_ij(img,0.0,0.0)


# ╔═╡ c2e0e032-7c4c-11eb-2b2a-27fe69c42a01
img;

# ╔═╡ c662e3d8-7c4c-11eb-0dcf-f9da2bd14baf
size(img)

# ╔═╡ d0e9a1e8-7c4c-11eb-056c-aff283c49c31
img[50,56]

# ╔═╡ 4d0de3d3-f006-4537-a7c8-81c65f16f861
white_background(x) = PlutoUI.ExperimentalLayout.Div([x]; style="background: white")

# ╔═╡ 7c68c7b6-7a9e-11eb-3f7f-99bb10aedd95
Resource("https://raw.githubusercontent.com/mitmath/18S191/Spring21/notebooks/week3/coord_transform.png") |> white_background

# ╔═╡ 80456168-7c1b-11eb-271c-83ef59a41102
Resource("https://raw.githubusercontent.com/mitmath/18S191/Spring21/notebooks/week3/collide.png") |> white_background

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
NonlinearSolve = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[compat]
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
FileIO = "~1.14.0"
ForwardDiff = "~0.10.28"
ImageIO = "~0.6.2"
ImageShow = "~0.3.4"
NonlinearSolve = "~0.3.16"
PlutoUI = "~0.7.38"
StaticArrays = "~1.4.4"
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

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "81f0cb60dc994ca17f68d9fb7c942a5ae70d9ee4"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.8"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "28bbdbf0354959db89358d1d79d421ff31ef0b5e"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.3"

[[CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[CPUSummary]]
deps = ["CpuId", "IfElse", "Static"]
git-tree-sha1 = "baaac45b4462b3b0be16726f38b789bf330fcb7a"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.21"

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

[[CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "f576084239e6bdf801007c80e27e2cc2cd963fe0"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.6"

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

[[CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

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

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

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

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "51c8f36c81badaa0e9ec405dcbabaf345ed18c84"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.11.1"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "7a380de46b0a1db85c59ebbce5788412a39e4cb7"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.28"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "18be5268cf415b5e27f34980ed25a7d34261aa83"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.7"

[[Hwloc]]
deps = ["Hwloc_jll"]
git-tree-sha1 = "92d99146066c5c6888d5a3abc871e6a214388b91"
uuid = "0e44f5e4-bd66-52a0-8798-143a42290a1d"
version = "2.0.0"

[[Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "303d70c961317c4c20fafaf5dbe0e6d610c38542"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.7.1+0"

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

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

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

[[IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

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

[[LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "b651f573812d6c36c22c944dd66ef3ab2283dfa1"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.6"

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

[[LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SLEEFPirates", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "4acc35e95bf18de5e9562d27735bef0950f2ed74"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.108"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

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

[[NonlinearSolve]]
deps = ["ArrayInterface", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "aeebff6a2a23506e5029fd2248a26aca98e477b3"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.16"

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

[[Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "8d95a735921204f5d551ac300b20d802a150433a"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.6.8"

[[PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "7e597df97e46ffb1c8adbaddfa56908a7a20194b"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.5"

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

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "ChainRulesCore", "DocStringExtensions", "FillArrays", "LinearAlgebra", "RecipesBase", "Requires", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "bfe14f127f3e7def02a6c2b1940b39d0dabaa3ef"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.26.3"

[[RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "a9a852c7ebb08e2a40e8c0ab9830a744fa283690"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.10"

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

[[SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "62c2da6eb66de8bb88081d20528647140d4daa0e"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.0"

[[SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "ac399b5b163b9140f9c310dfe9e9aaa225617ff6"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.32"

[[SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "5420ffd1d5ad49e2c8309efb7338cc2443487029"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.31.4"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

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

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "5309da1cdef03e95b73cd3251ac3a39f887da53e"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.4"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "Requires", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "70d9007ff05440058c0301985b2275edc2b2ce25"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.3.3"

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

[[ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "f8629df51cab659d70d2e5618a430b4d3f37f2c3"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.0"

[[TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "b8d08f55b02625770c09615d96927b3a8396925e"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.11"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "Hwloc", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "ff34c2f1d80ccb4f359df43ed65d6f90cb70b323"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.31"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

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
# ╟─972b2230-7634-11eb-028d-df7fc722ec70
# ╟─b7895bd2-7634-11eb-211e-ef876d23bd88
# ╟─230b0118-30b7-4035-ad31-520165a76fcc
# ╠═6b473b2d-4326-46b4-af38-07b61de287fc
# ╟─230cba36-9d0a-4726-9e55-7df2c6743968
# ╠═96766502-7a06-11eb-00cc-29849773dbcf
# ╟─890d30b9-2cd0-4d3a-99f6-f7d3d7858fda
# ╟─85fba8fb-a9ea-444d-831b-ec6489b58b4f
# ╟─06beabc3-2aa7-4e78-9bae-dc4b37251aa2
# ╟─26dd0e98-7a75-11eb-2196-5d7bda201b19
# ╟─e0b657ce-7a03-11eb-1f9d-f32168cb5394
# ╟─005ca75a-7622-11eb-2ba4-9f450e71df1f
# ╟─23ade8ee-7a09-11eb-0e40-296c6b831d74
# ╠═58a30e54-7a08-11eb-1c57-dfef0000255f
# ╟─2efaa336-7630-11eb-0c17-a7d4a0141dac
# ╟─7f28ac40-7914-11eb-1403-b7bec34aeb94
# ╟─ce55beee-7643-11eb-04bc-b517703facff
# ╠═b76a5bd6-802f-11eb-0951-1f1092dee8de
# ╟─5d33f6ea-7e9c-11eb-2fb3-dbb7cb07c60c
# ╟─45dccdec-7912-11eb-01b4-a97e30344f39
# ╟─d2fb356e-7f32-11eb-177d-4f47d6c9e59b
# ╠═ca28189e-7e9a-11eb-21d6-bd819f3e0d3a
# ╠═ccea7244-7f2f-11eb-1b7b-b9b8473a8c74
# ╟─55b5fc92-7a76-11eb-3fba-854c65eb87f9
# ╟─85686412-7a75-11eb-3d83-9f2f8a3c5509
# ╟─a7df7346-79f8-11eb-1de6-71f027c46643
# ╟─044e6128-79fe-11eb-18c1-395ae857dc73
# ╟─78d61e28-79f9-11eb-0605-e77d206cda84
# ╟─aad4d6e4-79f9-11eb-0342-b900a41cfbaf
# ╟─d42aec08-76ad-11eb-361a-a1f2c90fd4ec
# ╟─d9115c1a-7aa0-11eb-38e4-d977c5a6b75b
# ╟─e965cf5e-79fd-11eb-201d-695b54d08e54
# ╟─1e11c1ec-79fe-11eb-1867-9da72b3f3bc4
# ╟─28ef451c-7aa1-11eb-340c-ab3a1193a3c4
# ╟─a0afe3ae-76b9-11eb-2301-cde7260ddd7f
# ╟─fc2deb7c-7aa1-11eb-019f-d3e3c80b9ff1
# ╠═d364f91a-76b9-11eb-1807-75e733940d53
# ╟─080d87e0-7aa2-11eb-18f5-2fb6a7a5bcb4
# ╠═15283aba-7aa2-11eb-389c-e9f215bd03e2
# ╟─2612d2c2-7aa2-11eb-085a-1f27b6174995
# ╟─a290d5e2-7a02-11eb-37db-41bf86b1f3b3
# ╠═b4cdd412-7a02-11eb-149a-df1888a0f465
# ╟─704a87ec-7a1e-11eb-3964-e102357a4d1f
# ╠═4b0e8742-7a70-11eb-1e78-813f6ad005f4
# ╟─44792484-7a20-11eb-1c09-95b27b08bd34
# ╟─f650b788-7a70-11eb-0b20-779d2f18f111
# ╟─c852d398-7aa2-11eb-2ded-ab2e5236e9b2
# ╟─061076c2-7aa3-11eb-0d04-b7cbc60e6cb2
# ╟─014c14a6-7a72-11eb-119b-f5cfc82085ca
# ╟─89f0bc54-76bb-11eb-271b-3190b4d8cbc0
# ╟─f70f7ea8-76b9-11eb-3bd7-87d40a2861b1
# ╟─bf28c388-76bd-11eb-08a7-af2671218017
# ╠═5655d2a6-76bd-11eb-3042-5b2dd3f6f44e
# ╠═56f1e4cc-7a03-11eb-187b-c5a917978eb9
# ╠═70dc4346-7a03-11eb-055e-111d2519a44c
# ╠═852592d6-76bd-11eb-1265-5f200e39113d
# ╠═8e36f4a2-76bd-11eb-2fda-9d1424752812
# ╟─a8bf7128-7aa5-11eb-3ee9-953b0b5ccd01
# ╟─ad700740-7a74-11eb-3369-15e5fd89194d
# ╟─e051259a-7a74-11eb-12fc-99c5dc867fbd
# ╟─1856ddae-7a78-11eb-3422-298e1103275b
# ╟─4b4fe818-7a78-11eb-2986-59e60063d346
# ╟─5d656494-7a78-11eb-12e8-d17856bd8c4d
# ╟─b0e6d1ac-7a7d-11eb-0a9e-1310dcb5957f
# ╟─7e4ad37c-7a84-11eb-1490-25090e133a7c
# ╟─96f47252-7a84-11eb-3d18-e3ba79dd20c2
# ╟─ae5b3a32-7a84-11eb-04c0-337a74105a58
# ╟─c9f2b61e-7a84-11eb-3841-33739a226ff9
# ╟─23d8a45c-7a85-11eb-3a68-ef11e6f58cac
# ╟─4a96d516-7a85-11eb-181c-63a6b461790b
# ╠═8206e1ee-7a8a-11eb-1f26-054f6b100076
# ╟─7d803684-7a8a-11eb-33d2-89d5e2a05bcf
# ╟─17281256-7aa5-11eb-3144-b72777334326
# ╠═05049fa0-7a8e-11eb-283b-cb4753c4aaf0
# ╠═350f40f7-795f-4f33-89b8-ff9ba4819e1c
# ╠═313cdcbd-5b11-41c8-9fcd-5aeaca3b8d24
# ╟─57848b42-7a8f-11eb-023a-cf247cb53819
# ╟─da73d9f6-7a8d-11eb-2e6f-1b819bbb0185
# ╟─620ee7d8-7a8f-11eb-3888-356c27a2d591
# ╟─30f522a0-7a8e-11eb-2181-8313760778ef
# ╟─04da7710-7a91-11eb-02a1-0b6e889150a2
# ╠═c2e0e032-7c4c-11eb-2b2a-27fe69c42a01
# ╠═c662e3d8-7c4c-11eb-0dcf-f9da2bd14baf
# ╠═d0e9a1e8-7c4c-11eb-056c-aff283c49c31
# ╟─155cd218-7a91-11eb-0b4c-bd028507e925
# ╟─fd25da12-7a92-11eb-20c0-995e7c46b3bc
# ╟─1ab2265e-7c1d-11eb-26df-39c4c7289243
# ╟─7c68c7b6-7a9e-11eb-3f7f-99bb10aedd95
# ╠═7d0096ad-d89a-4ade-9679-6ee95f7d2044
# ╠═bf1954d6-7e9a-11eb-216d-010bd761e470
# ╠═c1efc54a-7e9b-11eb-1e76-dbd0a66184a9
# ╟─db4bc328-76bb-11eb-28dc-eb9df8892d01
# ╟─0b8ed36c-7a1e-11eb-053c-63cf9ee0b16f
# ╟─7a4e785e-7a71-11eb-07fb-cfba453a117b
# ╠═9264508a-7a71-11eb-1b7c-bf6e62788115
# ╠═e89339b2-7a71-11eb-0f97-971b2ed277d1
# ╟─0957fd9a-7a72-11eb-0566-e93ef32fb626
# ╟─c7cc412c-7aa5-11eb-2df1-d3d788047238
# ╟─ce620b8e-7aa5-11eb-370b-11e34b07d54d
# ╟─4f51931c-7aac-11eb-13ba-4b8768ac376f
# ╠═5ce799f4-7aac-11eb-0629-ebd8a404e9d3
# ╠═9b456686-7aac-11eb-3aa5-25e6c3c86aff
# ╟─c2b0a488-7aac-11eb-1d8b-edd6bd23d1fd
# ╟─02d6b440-7aa7-11eb-1be0-b78dea91387f
# ╟─0be9fb1e-7aa7-11eb-0116-c3e86ab82c77
# ╟─7609d686-7aa7-11eb-310a-3550509504a1
# ╟─1b9faf64-7aab-11eb-1396-6fb89be7c445
# ╟─5f0568dc-7aad-11eb-162f-0d6e26f17d59
# ╟─8d32fff4-7c1b-11eb-1fa1-6ff2d87bfb73
# ╠═80456168-7c1b-11eb-271c-83ef59a41102
# ╠═62a9201c-7938-11eb-144c-15690c06be94
# ╟─5227afd0-7641-11eb-0065-918cb8538d55
# ╟─4c93d784-763d-11eb-1f48-81d4d45d5ce0
# ╟─c536dafb-4206-4689-ad6d-6935385d8fdf
# ╟─fb509fb4-9608-421d-9c40-a4375f459b3f
# ╟─40655bcc-6d1e-4d1e-9726-41eab98d8472
# ╠═55898e88-36a0-4f49-897f-e0850bd2b0df
# ╠═b754bae2-762f-11eb-1c6a-01251495a9bb
# ╟─83d45d42-7406-11eb-2a9c-e75efe62b12c
# ╟─4d0de3d3-f006-4537-a7c8-81c65f16f861
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
