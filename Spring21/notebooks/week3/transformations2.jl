### A Pluto.jl notebook ###
# v0.14.0

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
		Pkg.PackageSpec(name="ForwardDiff", version="0.10"),
		Pkg.PackageSpec(name="NonlinearSolve", version="0.3"),
		Pkg.PackageSpec(name="StaticArrays"),
	])

	using PlutoUI 
	using Colors, ColorVectorSpace, ImageShow, FileIO
	using PlutoUI
	using HypertextLiteral
	using LinearAlgebra
	using ForwardDiff
	using NonlinearSolve
	using StaticArrays
end

# ╔═╡ 230cba36-9d0a-4726-9e55-7df2c6743968
filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

# ╔═╡ 2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

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
"><em>Section 5 </em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Transformations II: Composability,  Linearity and Nonlinearity </em>
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

# ╔═╡ bbbf0788-7ace-11eb-0b2d-4701b4b466e8
md"# Lecture Video"

# ╔═╡ ba8877ac-7ace-11eb-2a06-b50f7b1cdf0b
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/VDPf3RjoCpY" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 230b0118-30b7-4035-ad31-520165a76fcc
md"""
#### Intializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

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
	 id((x,y)) = SA[x, y]
	
	 scalex(α) = ((x, y),) -> SA[α*x,  y]
	 scaley(α) = ((x, y),) -> SA[x,   α*y]
	 scale(α)  = ((x, y),) -> SA[α*x, α*y]
	
	 swap((x,y))  = SA[y, x]
	 flipy((x,y)) = SA[x, -y]
	
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

#T⁻¹ = ((x,y),)-> (x,y^2)  
# T⁻¹  = flipy ∘ ((x,y),) ->  ( (β*x - α*y)/(β - y)  , -h*y/ (β - y)   ) 

# ╔═╡ 080d87e0-7aa2-11eb-18f5-2fb6a7a5bcb4
md"""
In fact we can write down the *most general* linear transformation in one of two ways:
"""

# ╔═╡ 15283aba-7aa2-11eb-389c-e9f215bd03e2
begin
	lin(a, b, c, d) = ((x, y),) -> ( a*x + b*y, c*x + d*y )
	
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
	
	(lin(A) ∘ lin(B))(v) , lin(A * B)(v)
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

# ╔═╡ 7c68c7b6-7a9e-11eb-3f7f-99bb10aedd95
Resource("https://raw.githubusercontent.com/mitmath/18S191/Spring21/notebooks/week3/coord_transform.png")

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
	T(v) ,  v 
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
    (lin(inv(A)) ∘ lin(A))(v) , v
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

# ╔═╡ 80456168-7c1b-11eb-271c-83ef59a41102
Resource("https://raw.githubusercontent.com/mitmath/18S191/Spring21/notebooks/week3/collide.png")

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
		i,j = floor.(Int, xy_to_ij((x, y))) 
	
	end
	
	function getpixel(img,i::Int,j::Int; circular::Bool=false, r::Real=200)   
		#  grab image color or place default
		rows,cols = size(img)
		m = max(cols,rows)
		if circular
			c = (i-rows/2)^2 + (j-cols/2)^2 ≤ r*m^2/4
		else
			c = true
		end
		
		if 1 < i ≤ rows && 1 < j ≤ cols && c
			img[i, j]
		else
			#white(img[1, 1])
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
			 x,y = transform_ij_to_xy(i,j, test_pixels)
			 X,Y =  T₁([x,y])
			 i,j = transform_xy_to_ij(test_img,X,Y)
			 getpixel(test_img,i,j)
			end	 
		
			for i = 1:test_pixels, j = 1:test_pixels
		]	
end

# ╔═╡ 30f522a0-7a8e-11eb-2181-8313760778ef
begin
		[			    
			begin
			 x,y = transform_ij_to_xy(i,j, test_pixels)
			 X,Y =  T₂([x,y])
			 i,j = transform_xy_to_ij(test_img,X,Y)
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
	
	
	result[ floor.(Int,LinRange(1, rows, n) ), : ] .= stroke
	#result[ ceil.(Int,LinRange(1, rows, n) ), : ] .= stroke
	result[ : , floor.(Int,LinRange(1, cols, n) )] .= stroke
	#result[ : , ceil.(Int,LinRange(1, cols, n) )] .= stroke
	
	
    result[  rows ÷2    , :] .= RGBA(0,1,0,1)
	#result[  1+rows ÷2    , :] .= RGBA(0,1,0,1)
	result[ : ,  cols ÷2   ,] .= RGBA(1,0,0,1)
	#result[ : ,  1 + cols ÷2   ,] .= RGBA(1,0,0,1)
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
			
			 x,y = transform_ij_to_xy(i,j, pixels)
			
			X,Y = ( translate(-panx,-pany)  )([x,y])
			 X,Y = ( T⁻¹∘scale(1/z)∘translate(-panx,-pany) )([x,y])
			 i,j = transform_xy_to_ij(img,X,Y)
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

# ╔═╡ Cell order:
# ╟─972b2230-7634-11eb-028d-df7fc722ec70
# ╟─b7895bd2-7634-11eb-211e-ef876d23bd88
# ╟─bbbf0788-7ace-11eb-0b2d-4701b4b466e8
# ╟─ba8877ac-7ace-11eb-2a06-b50f7b1cdf0b
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
# ╟─80456168-7c1b-11eb-271c-83ef59a41102
# ╠═62a9201c-7938-11eb-144c-15690c06be94
# ╟─5227afd0-7641-11eb-0065-918cb8538d55
# ╟─4c93d784-763d-11eb-1f48-81d4d45d5ce0
# ╟─c536dafb-4206-4689-ad6d-6935385d8fdf
# ╟─fb509fb4-9608-421d-9c40-a4375f459b3f
# ╠═40655bcc-6d1e-4d1e-9726-41eab98d8472
# ╠═55898e88-36a0-4f49-897f-e0850bd2b0df
# ╠═b754bae2-762f-11eb-1c6a-01251495a9bb
# ╠═83d45d42-7406-11eb-2a9c-e75efe62b12c
# ╟─2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
