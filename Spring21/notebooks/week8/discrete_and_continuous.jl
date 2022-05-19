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

# ╔═╡ d155ea12-9628-11eb-347f-7754a33fd403
using Plots, PlutoUI, HypertextLiteral, Graphs, GraphPlot, Printf, SpecialFunctions

# ╔═╡ 4ea0ccfa-9622-11eb-1cf0-e9ae2f927dd2
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
"><em>Section 2.7</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Discrete and Continuous </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/H6Dcx3YeTkE" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 01506de2-918a-11eb-2a4d-c554a6e54631
TableOfContents()

# ╔═╡ 877deb2c-702b-457b-a54b-f27c277928d4
md"""
## Julia concepts
- printing using css fancy stuff (not really julia)
## pedagogical concepts
- curiosity based learning
- bridging what is often two different communities
"""

# ╔═╡ ee349b52-9189-11eb-2b86-b5dc15ebe432
md"""
###  Discrete and Continuous
"""

# ╔═╡ 43e39a6c-918a-11eb-2408-93563b4fb8c1
md"""
An exact technical definition of discrete and continuous can be difficult,
Nonetheless the idea of discrete mathematics is associated with  finite or countably many values that are isolated.  The set {1,...,n} and the integers are both discrete sets.
"""

# ╔═╡ 719a4c8c-9615-11eb-3dd7-7fb786f7fa17
md"""
DISCRETE MATH OBJECTS (examples):


1. Finite Sets: [1,2,...,100] 

2. Infinite Discrete Sets: ``\mathbb{Z}`` = integers = ``\{\ldots,-2,-1,0,1,2,\ldots\}``

3. Graphs:
"""

# ╔═╡ 45ecee7e-970e-11eb-22fd-01f56876684e
gplot( barabasi_albert(150, 2) )

# ╔═╡ 52fa7f18-757a-4bf5-b851-32a1fca9c378


# ╔═╡ 61ffe0f2-9615-11eb-37d5-f9e30a31c111
md"""
By contrast, entire intervals or the whole real line is associated with continuous mathematics. 

In fact, mathematicians have worked painstakingly to define these terms, inventing fields such as point set topology that among other things can recognize the discrete, and analysis to rigorously work with the continuous. 
"""

# ╔═╡ 627f6db6-9617-11eb-0453-a1f9e341ecfe
md"""
**Continuous real line:**

![continuous](data:image/png;base64,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)
"""

# ╔═╡ 091a8a44-918c-11eb-2ee3-9be84a311afd
md"""
### Heard in the hallways: I only like discrete math.  I only like continuous math.
"""

# ╔═╡ 5c536430-9188-11eb-229c-e7feba62d257
md"""
### Indexing and Function Evaluation

Analogy: ``v_i`` (ith element of v) vs. $f(x)$  (evaluate f at x):

These are different, right?
In the one you are extracting an element, and in the other you are applying what in some high schools might be called a "function machine."

However, a moment's thought tells you that a vector is really a discrete function, in that the argument can take on the values i = 1,2,...,n and the evaluation is $v_i$. That's a function.

In fact, think of a range object such as 2:2:20.  You could think of this as just a shorthand for the vector [2,4,...,20] but in fact when you index into this "vector" like thing, you are indeed explicitly evaluating a function i.e. i->2i. 
"""

# ╔═╡ 1e8ea849-40b7-41fd-b17f-cd2d991d5c24
[2:2:20;]  # this expands the "iterator" into an ordinary vector

# ╔═╡ 679a39ee-99a5-4211-9adc-8296d499e37e
[2:2:20;][7] # Extracts an element from Memory (of course there is an address calculation)

# ╔═╡ 2c64f98d-dc84-4fa5-81ce-25b319ff9583
(2:2:20)[7] # Compute 2*7 (more or less)

# ╔═╡ 0a379cae-386d-4daa-ab6f-9d0424c1cdc1
begin
	f(x)=2x
	f(7)     # Compute 2*7
end

# ╔═╡ 890c0fa2-c247-4f14-84f6-2bed69d0f0c5
md"""
Any which way $v$ is a function "machine" whose input is $\{1,2,3,4,5,6,7,8,9,10\}$
"""

# ╔═╡ 68b60d09-acee-48d8-8bb1-7ab4faa6b785
gr()

# ╔═╡ 40095ad2-961f-11eb-1f23-83d1a381ace7
md"""
### Area
"""

# ╔═╡ ed71b026-9565-11eb-1058-d77efe114562
md"""
Area of a circle using regular polygons:
"""

# ╔═╡ 3b84bb0a-9566-11eb-1c1f-e30ca7330c09
md"""
n = $(@bind sides Slider(3:100, show_value=true, default=6))
"""

# ╔═╡ f20da096-9712-11eb-2a67-cd33f6ab8750
area(s) = (s/2) * sin(2π/s)

# ╔═╡ 02784976-9566-11eb-125c-a7f1f1bafd6b
begin
	θ = (0:.01:1)*2π
		plot( cos.(θ),sin.(θ), ratio=1, axis=false, legend=false, ticks=false, lw=4, color=:black, fill=false)
	plot!( cos.(θ),sin.(θ), ratio=1, axis=false, legend=false, ticks=false, lw=4, color=:white, fill=true, alpha=.6)
	
	
	ϕ = (0:sides)*2π/sides
	for i=1:sides
	   plot!( Shape( [0,cos(ϕ[i]),cos(ϕ[i+1])],[0,sin(ϕ[i]),sin(ϕ[i+1])]), fill=true,lw=0)
	end
	title!("Area = ($sides/2)sin(2π/$sides) ≈  $(area(sides)/π )  π")
end

# ╔═╡ 6fd93018-c33b-4682-91c3-7a20a41d9b03
area0 = area.( 2 .^ (2:10) ) # Area of polygons with # sides  = [4, 8, ..., 1024]

# ╔═╡ a306559f-e095-4f6d-94e8-b0be160e77fa
π

# ╔═╡ ea29e286-4b4a-4291-a093-cd942ba46e49
md"""
A carefully chosen convolution: [-1/3,4/3]
"""

# ╔═╡ 103c93ae-8175-4996-ab8f-5d537691defc
area1 = [ 4/3 * area0[i+1] .-  1/3 * area0[i] for i = 1:length(area0)-1 ]

# ╔═╡ 686904c9-1cc4-4476-860b-159e56471e38
function colorgoodbad(should_be, given)
	indexofmistake = something(
		findfirst(collect(should_be) .!== collect(given)),
		length(given)+1,
	)
	@htl("""
		<span style="color: inherit">$(given[1:indexofmistake-1])</span><span style="color: red">$(given[indexofmistake:end])</span>
		""")
end

# ╔═╡ bcfd1585-8161-43a2-8b19-ed654df2e0e1
colorgoodbad(string(float(π)) , string(22/7))

# ╔═╡ a76ac67b-27b9-4e2b-9fca-61480dca5264
area2 = [16/15 * area1[i+1] .-  1/15 * area1[i] for i = 1:length(area1)-1 ]

# ╔═╡ c742742a-765b-4eb5-bd65-dc0cd6328255
md"""
Another carefully chosen convolution: [-1/15,16/15], do you see the pattern?
"""

# ╔═╡ 5273fe09-fe38-4c88-b84a-51af17cff906
big(π)

# ╔═╡ 4dd03325-2498-4fe7-9212-f964081a0300
area3 = [64/63 * area2[i+1] .-  1/63 * area2[i] for i = 1:length(area2)-1 ]

# ╔═╡ 626242ea-544c-49fc-9884-c70dd6800902
area4 = [128/127 * area3[i+1] .-  1/127 * area3[i] for i = 1:length(area3)-1 ]

# ╔═╡ dbccc2d5-c2af-48c4-8726-a95c09da78ae
md"""
Why does this work?
"""

# ╔═╡ 82a407b6-0ecb-4011-a0f6-bc9e1f51393f
md"""
Area(s) = ``(s/2) \sin (2\pi/s) = \pi- \frac{2\pi^3}{3} s^{-2}  + \frac{2\pi^5}{15}s^{-4} -  \frac{4\pi^7}{315} s^{-6} + \ldots``    

as `` s \rightarrow \infty ``.
"""

# ╔═╡ 5947dc80-9714-11eb-389d-1510a1137a50
md"""
Area(s) = `` \pi  -  c_1 /s^2  + c_2 / s^4  - \ldots`` 

Area(2s) = `` \pi  -  c_1 /(4s^2)  + c_2 / (16s^4)  - \ldots`` 
"""

# ╔═╡ db8121ec-8546-4f1e-8153-cff5b4df39df
md"""
Think about taking (4/3) Area(2s) - (1/3) Area(s).

Now we have 
``\pi + c s^{-4}`` as the leading term so doubling the s approximately reduces the area error by 16, when before it was only 4. etc.
"""

# ╔═╡ d4f83a20-62cf-47f1-a622-d5c4c34e4813
areab(s) = (s/2) * sin(big(2)*big(π)/s)

# ╔═╡ 01631c38-9713-11eb-30bf-3d23cf0d3dc8
begin
	area0b = areab.(big.([2,4,8,16,32,62,128,256,512,1024,2048,4096,8192,16384,32768,65536]))
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area0b[end])))
end

# ╔═╡ 553bdb0a-9714-11eb-1646-413a969d6884
begin
	area1b = [ 4//3 * area0b[i+1] .-  1//3 * area0b[i] for i = 1:length(area0b)-1 ]
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area1b[end])))
end

# ╔═╡ fa3a8baf-d86d-45c3-b4ba-85198bd0677d
string(area1b[end])

# ╔═╡ 8bcd29e2-41db-4969-9932-3cc56edfdc18
colorgoodbad( (@sprintf "%.30f" big(π)) , (@sprintf "%.30f" big(area1b[end])))

# ╔═╡ 453f2585-157d-490a-9d1c-0b02939d0a11
begin
	area2b = [16//15 * area1b[i+1] .-  1//15 * area1b[i] for i = 1:length(area1b)-1 ]
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area2b[end])))
end

# ╔═╡ bc1efddd-c959-4407-9a86-ba73a64508a8
begin
	area3b = [64//63 * area2b[i+1] .-  1//63 * area2b[i] for i = 1:length(area2b)-1 ]
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area3b[end])))
end

# ╔═╡ 516b69d8-5d94-4b4d-9596-2db0dfbf4038
begin
	area4b = [256//255 * area3b[i+1] .-  1//255 * area3b[i] for i = 1:length(area3b)-1 ]
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area4b[end])))
end

# ╔═╡ cec13915-8adb-4627-b220-591377239997
begin
	area5b = [1024//1023 * area4b[i+1] .-  1//1023 * area4b[i] for i = 1:length(area4b)-1 ]
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area5b[end])))
end

# ╔═╡ 6d954628-6290-4867-8144-dd486551545d
begin
	area6b = [4096//4095 * area5b[i+1] .-  1//4095 * area5b[i] for i = 1:length(area5b)-1 ]
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area6b[end])))
end

# ╔═╡ 00478b2c-5dcc-44fc-a7be-a3dadf6300e7
begin
	area7b = [16384//16383 * area6b[i+1] .-  1//16383 * area6b[i] for i = 1:length(area6b)-1 ]
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area7b[end])))
end

# ╔═╡ 23d1186e-7d56-40bf-b208-c6e9a3ff120b
begin
	area8b = [65536//65535 * area7b[i+1] .-  1//65535 * area7b[i] for i = 1:length(area7b)-1 ]
	colorgoodbad( (@sprintf "%.80f" big(π)) , (@sprintf "%.80f" big(area8b[end])))
end

# ╔═╡ 37fc6e56-9714-11eb-1427-b75613800366
big(π)

# ╔═╡ 4a072870-961f-11eb-1215-17efa0013873
md"""
Area using inscribed squares
"""

# ╔═╡ de9066e2-d5eb-49e3-be71-edda8e8e31dd
@bind s Slider(2:40, show_value=true)

# ╔═╡ 4d4705d0-9568-11eb-085c-0fc556c4cfe7
let
	
    plot()
	for i=-s:s
		plot!([i/s,i/s],[-1,1],color=RGB(0,1,0),lw=1)
		plot!([-1,1],[i/s,i/s],color=RGB(0,1,0),lw=1)
	end
		P = plot!( cos.(θ),sin.(θ), ratio=1, axis=false, legend=false, ticks=false, lw=3, color=:black)
	plot!(P)
	
	h = 1/s
	a = 0
	
	
	xx=  floor(√2/2h)
	x = xx*h
	y=x
	plot!( Shape([-x, -x, x ,x],[-y, y ,y, -y]), color=RGB(1,0,0),alpha=.7)
	
	a = a+Int(2*xx)^2

	
	 for i=-s:(-xx-1), j=-s:(-1)
	   x = i*h
	    y = j*h
	   if (x^2+y^2≤1) & ( (x+h)^2+(y+h)^2 ≤1) & (x^2+(y+h)^2 ≤1) & ((x+h)^2+y^2 ≤1)
	 	 plot!( Shape([x, x, x+h ,x+h],[y, y+h ,y+h, y]), color=:blue)
		 plot!( Shape([-x-h, -x-h, -x ,-x],[y, y+h ,y+h, y]), color=:blue)
	     plot!( Shape([x, x, x+h ,x+h],[-y-h, -y ,-y, -y-h]), color=:blue)
		 plot!( Shape([-x-h, -x-h, -x ,-x],[-y-h, -y ,-y, -y-h]), color=:blue)
		 plot!( Shape([y, y+h ,y+h, y],[x, x, x+h ,x+h]), color=:blue)
		 plot!( Shape([-y-h, -y ,-y, -y-h],[x, x, x+h ,x+h]), color=:blue)
		 plot!( Shape([y, y+h ,y+h, y],[-x-h, -x-h, -x ,-x]), color=:blue)
		 plot!( Shape([-y-h, -y ,-y, -y-h],[-x-h, -x-h, -x ,-x]), color=:blue)
	 		a += 8
	 	end
	 end
	
	
	xlabel!("s  =  $s")
	
	title!( "$(a//s^2) =  $(a*h^2/π) π")
	plot!()
	
	
end

# ╔═╡ e6884c6c-9712-11eb-288b-f1a439b0aba3
md"""
Imagine you didn't have the idea of area
"""

# ╔═╡ 4f845436-9646-11eb-2445-c12746a9e556
begin
	N  = 1024
	h =  1/N
	v = randn(N)
end

# ╔═╡ 155241b0-9646-11eb-180e-89c8651536c6
@bind j Slider(1:9, show_value=true, default=6)

# ╔═╡ 31d56008-9646-11eb-1985-2b68af354773
J = N ÷ 2^j

# ╔═╡ 1761187e-9645-11eb-3778-b132f856696d
begin
	plot()	
	c = [0;cumsum(v)] .* √h
	plot!((0:N)./N,c)
	scatter!( (0:J:N)./N,   c[1:J:end],legend=false,m=:o,ms=5, color=:red, lw=5)	   
	plot!(ylims=(-2,2))
	xlabel!("time")
	ylabel!("position")
end

# ╔═╡ 1e18f95c-cd53-4ede-8d93-572c81f872da
md"""
A random walk is a discrete random function. It is defined at grid points.  Brownian motion is a continuous random function.  It is defined on an entire interval.
If one has an instance of a Brownian motion, you can say its exact value at, say, .7.
If one looks at the random variable that represents evaluation at .7 it is a normal distribution.
"""

# ╔═╡ c32e0f9c-918e-11eb-1cf9-a340786db24a
md"""
Alan's essay:

In what sense does the continuous even exist?  The fact of the matter is that there are limits that give the same answer no matter how you get there, and these limits
are important to us. For example, no matter how you cover an area, by little rectangles, the sum always converges to what we intuitively call area.
The normal distribution is interesting in that no matter which starting finite distribution we might take, if add n independent copies and normalize to variance 1 we get the same limit.  Again, there are so many ways to start, and yet we always end up with the same thing.  Continuous mathematics is full of so many examples, where discrete objects end up behaving the same.

Indeed what happens as discrete objects get larger and larger, their complexity gets out of control if one wants to keep track of every detail, but they get simpler in their aggregate behavior.
"""

# ╔═╡ 632eea46-9710-11eb-1abe-85da8d9c30a9
f(x,t) =  exp(-x^2/t)/√(π*t)

# ╔═╡ 9c519eca-9710-11eb-20dc-3f76801545d1
@bind t Slider(.01:.01:8, show_value=true)

# ╔═╡ 7c4b82c8-9710-11eb-101e-53616e278289
begin
	x = -3 : .01 : 3 
	plot( x, f.(x,t), ylims=(0,1), legend=false)
end

# ╔═╡ 021d7e9a-9711-11eb-063b-11441afa2e69
begin
	surface(-2:.05:2, .2:.01:1, f, alpha=.4, c=:Reds, legend=false)
	for t = .2 : .1 :1
		plot!(-2:.05:2, fill(t,length(-2:.05:2)),  f.(-2:.05:2,t), c=:black)
	end
	xlabel!("x")
	ylabel!("t")
	plot!()
end

# ╔═╡ 653a1cd6-9711-11eb-2284-770f00bebeec
plotly()

# ╔═╡ bb8dc4fe-918d-11eb-2bde-bb00c47a1c27
md"""
### Sum and a (Definite) Integral
"""

# ╔═╡ c4a3bf6c-918d-11eb-1d50-911f83b6df81
md"""
### Cumsum and an Indefinite Integral
"""

# ╔═╡ d99dc494-918d-11eb-2733-29ce93ba584e
md"""
### Discrete (Finite Differencing) Filters and Derivatives/Gradients
"""

# ╔═╡ 0fb84ff2-918e-11eb-150f-8dad121c87bc
md"""
### Discrete and continuous convolutions e.g. probability densities
"""

# ╔═╡ a7c5ef96-918d-11eb-0632-f94386eb64f2
md"""
### Discrete Random Walks and Brownian Motion
"""

# ╔═╡ 75672be6-918d-11eb-1e10-07fbcc72abbd
md"""
### Binomial Distribution and the Normal Distribution
"""

# ╔═╡ 906758c6-918d-11eb-08ae-b3c4f7870b4e
md"""
### Discrete and the Continuous Fourier Transform
"""

# ╔═╡ b972b218-970c-11eb-1949-535830e20990
P = [ binomial(n,k) for n=0:5,k=0:5]

# ╔═╡ 80682786-970d-11eb-223b-b5f762b19c24
P*P'

# ╔═╡ ed6d7404-970c-11eb-13ee-5f5a454d2222
begin
	A = (1 ./beta.( (1:6)', 0:5) ) ./ [1;1:5;]
	A[1,:] .= 1
	round.(Int,A)
end

# ╔═╡ 0e6cab25-70f8-46ab-a5ab-8542e232274e
function blue(s::String)
	HTML("<span style='color: hsl(200deg, 60%, 50%);'> $(s)  </span>")
end

# ╔═╡ 173b44ea-918c-11eb-116b-0bbaeffc3fe2
md"""
It is not unusual for students (and professors) to gravitate towards the discrete or the continuous.  We wish to point out, that the discrete and the continuous are so closely related, that it is worthwhile to be comfortable with both.  Up until fairly recently, much of computer science was often associated with discrete mathematics, while computational science and engineering was associated with physical systems, hence continuous mathematics.

$(blue("That is blurring these days:"))  The popularity of machine learning has brought continuous optimization ideas such as gradient descent into the world of computer science and the impact of the physical world on us all (e.g. climate change, pandemics) is motivating applications in computer science.  The newfound popularity of Data science and statistics is also mixing the discrete with the continuous.

 
"""

# ╔═╡ a3f005a8-9617-11eb-1503-75c31ec54f70
md"""
$(blue("Continuous math often lets you replace complicated large systems
		with lots of details with a simpler abstraction that is easier to work with."))
"""

# ╔═╡ 870cdf5f-f896-4060-9548-5d9c1749d100
md"""
$(blue("The combination of continuous and discrete is often more useful than either one alone."))
"""

# ╔═╡ d9dfe7c5-9211-4707-bb33-a3ff258e10f4
md"""
$(blue("Machine Learning, Pandemics, climate change, etc. show how critical continuous math is these days."))
"""

# ╔═╡ 7edb7c63-c71e-455b-bb78-ddd50475e271
blue("asdf")

# ╔═╡ c03d45f8-9188-11eb-2e11-0fafa39f253d
function pyramid(rows::Vector{<:Vector}; 
		horizontal=false,
		padding_x=8,
		padding_y=2,
	)
	
	style = (; padding = "$(padding_y)px $(padding_x)px")
	render_row(xs) = @htl("""<div><padder></padder>$([@htl("<span style=$(style)>$(x)</span>") for x in xs])<padder></padder></div>""")
	
	@htl("""
		<style>
		.pyramid {
			flex-direction: column;
			display: flex;
		    font-family: monospace;
		    font-size: 0.75rem;
		}
		.pyramid.horizontal {
			flex-direction: row;
		}
		.pyramid div {
			display: flex;
			flex-direction: row;
		}
		.pyramid.horizontal div {
			flex-direction: column;
		}
		.pyramid div>span:hover {
			background: rgb(255, 220, 220);
			font-weight: 900;
		}
		.pyramid div padder {
			flex: 1 1 auto;
		}
		.pyramid div span {
			text-align: center;
		}
		
		
		</style>
		<div class=$(["pyramid", (horizontal ? "horizontal" : "vertical")])>
		$(render_row.(rows))
		</div>
		
		""")
end

# ╔═╡ d2d1366b-9b6d-4e54-a0c4-7087f5f063c4
pyramid( [area0,area1], horizontal = true)

# ╔═╡ 6577e546-8f0b-413a-a8bb-b9c12803199d
pyramid([area0,area1,area2], horizontal = true)

# ╔═╡ 43d20d56-d56a-47a8-893e-f726c1a99651
pp(x) =  colorgoodbad( string(float(π)) , (@sprintf "%.15f" x) )

# ╔═╡ 893a56b0-f5d0-4f8d-ba15-1048180a7e53
pyramid([pp.(area0), pp.(area1), pp.(area2), pp.(area3), pp.(area4)], horizontal = true)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GraphPlot = "a2cc645c-3eea-5389-862e-a155d0052231"
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[compat]
GraphPlot = "~0.5.1"
Graphs = "~1.6.0"
HypertextLiteral = "~0.9.4"
Plots = "~1.29.0"
PlutoUI = "~0.7.38"
SpecialFunctions = "~2.1.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "63d1e802de0c4882c00aee5cb16f9dd4d6d7c59c"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.1"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "9a2695195199f4f20b94898c8a8ac72609e165a4"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.3"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.GraphPlot]]
deps = ["ArnoldiMethod", "ColorTypes", "Colors", "Compose", "DelimitedFiles", "Graphs", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "4b32dd7090567fbd59f4aacddd76c5734027a324"
uuid = "a2cc645c-3eea-5389-862e-a155d0052231"
version = "0.5.1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "57c021de207e234108a6f1454003120a1bf350c4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.6.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d457f881ea56bbfa18222642de51e0abf67b9027"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "e75d82493681dfd884a357952bbd7ab0608e1dc3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.7"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─4ea0ccfa-9622-11eb-1cf0-e9ae2f927dd2
# ╠═d155ea12-9628-11eb-347f-7754a33fd403
# ╠═01506de2-918a-11eb-2a4d-c554a6e54631
# ╟─877deb2c-702b-457b-a54b-f27c277928d4
# ╟─ee349b52-9189-11eb-2b86-b5dc15ebe432
# ╟─43e39a6c-918a-11eb-2408-93563b4fb8c1
# ╟─719a4c8c-9615-11eb-3dd7-7fb786f7fa17
# ╠═45ecee7e-970e-11eb-22fd-01f56876684e
# ╠═52fa7f18-757a-4bf5-b851-32a1fca9c378
# ╟─61ffe0f2-9615-11eb-37d5-f9e30a31c111
# ╟─627f6db6-9617-11eb-0453-a1f9e341ecfe
# ╟─091a8a44-918c-11eb-2ee3-9be84a311afd
# ╟─173b44ea-918c-11eb-116b-0bbaeffc3fe2
# ╟─a3f005a8-9617-11eb-1503-75c31ec54f70
# ╟─870cdf5f-f896-4060-9548-5d9c1749d100
# ╟─d9dfe7c5-9211-4707-bb33-a3ff258e10f4
# ╟─5c536430-9188-11eb-229c-e7feba62d257
# ╠═1e8ea849-40b7-41fd-b17f-cd2d991d5c24
# ╠═679a39ee-99a5-4211-9adc-8296d499e37e
# ╠═2c64f98d-dc84-4fa5-81ce-25b319ff9583
# ╠═0a379cae-386d-4daa-ab6f-9d0424c1cdc1
# ╟─890c0fa2-c247-4f14-84f6-2bed69d0f0c5
# ╠═68b60d09-acee-48d8-8bb1-7ab4faa6b785
# ╟─40095ad2-961f-11eb-1f23-83d1a381ace7
# ╟─ed71b026-9565-11eb-1058-d77efe114562
# ╟─3b84bb0a-9566-11eb-1c1f-e30ca7330c09
# ╟─02784976-9566-11eb-125c-a7f1f1bafd6b
# ╠═f20da096-9712-11eb-2a67-cd33f6ab8750
# ╠═6fd93018-c33b-4682-91c3-7a20a41d9b03
# ╠═a306559f-e095-4f6d-94e8-b0be160e77fa
# ╟─ea29e286-4b4a-4291-a093-cd942ba46e49
# ╠═103c93ae-8175-4996-ab8f-5d537691defc
# ╠═686904c9-1cc4-4476-860b-159e56471e38
# ╠═bcfd1585-8161-43a2-8b19-ed654df2e0e1
# ╠═d2d1366b-9b6d-4e54-a0c4-7087f5f063c4
# ╠═a76ac67b-27b9-4e2b-9fca-61480dca5264
# ╟─c742742a-765b-4eb5-bd65-dc0cd6328255
# ╠═6577e546-8f0b-413a-a8bb-b9c12803199d
# ╠═5273fe09-fe38-4c88-b84a-51af17cff906
# ╠═4dd03325-2498-4fe7-9212-f964081a0300
# ╠═626242ea-544c-49fc-9884-c70dd6800902
# ╠═893a56b0-f5d0-4f8d-ba15-1048180a7e53
# ╠═fa3a8baf-d86d-45c3-b4ba-85198bd0677d
# ╠═8bcd29e2-41db-4969-9932-3cc56edfdc18
# ╟─dbccc2d5-c2af-48c4-8726-a95c09da78ae
# ╟─82a407b6-0ecb-4011-a0f6-bc9e1f51393f
# ╟─5947dc80-9714-11eb-389d-1510a1137a50
# ╟─db8121ec-8546-4f1e-8153-cff5b4df39df
# ╠═d4f83a20-62cf-47f1-a622-d5c4c34e4813
# ╠═01631c38-9713-11eb-30bf-3d23cf0d3dc8
# ╠═553bdb0a-9714-11eb-1646-413a969d6884
# ╠═453f2585-157d-490a-9d1c-0b02939d0a11
# ╠═bc1efddd-c959-4407-9a86-ba73a64508a8
# ╠═516b69d8-5d94-4b4d-9596-2db0dfbf4038
# ╠═cec13915-8adb-4627-b220-591377239997
# ╠═6d954628-6290-4867-8144-dd486551545d
# ╠═00478b2c-5dcc-44fc-a7be-a3dadf6300e7
# ╠═23d1186e-7d56-40bf-b208-c6e9a3ff120b
# ╠═37fc6e56-9714-11eb-1427-b75613800366
# ╟─4a072870-961f-11eb-1215-17efa0013873
# ╠═de9066e2-d5eb-49e3-be71-edda8e8e31dd
# ╟─4d4705d0-9568-11eb-085c-0fc556c4cfe7
# ╟─e6884c6c-9712-11eb-288b-f1a439b0aba3
# ╠═4f845436-9646-11eb-2445-c12746a9e556
# ╠═155241b0-9646-11eb-180e-89c8651536c6
# ╠═31d56008-9646-11eb-1985-2b68af354773
# ╠═1761187e-9645-11eb-3778-b132f856696d
# ╟─1e18f95c-cd53-4ede-8d93-572c81f872da
# ╟─c32e0f9c-918e-11eb-1cf9-a340786db24a
# ╠═632eea46-9710-11eb-1abe-85da8d9c30a9
# ╠═9c519eca-9710-11eb-20dc-3f76801545d1
# ╠═7c4b82c8-9710-11eb-101e-53616e278289
# ╠═021d7e9a-9711-11eb-063b-11441afa2e69
# ╠═653a1cd6-9711-11eb-2284-770f00bebeec
# ╟─bb8dc4fe-918d-11eb-2bde-bb00c47a1c27
# ╟─c4a3bf6c-918d-11eb-1d50-911f83b6df81
# ╟─d99dc494-918d-11eb-2733-29ce93ba584e
# ╟─0fb84ff2-918e-11eb-150f-8dad121c87bc
# ╟─a7c5ef96-918d-11eb-0632-f94386eb64f2
# ╟─75672be6-918d-11eb-1e10-07fbcc72abbd
# ╟─906758c6-918d-11eb-08ae-b3c4f7870b4e
# ╠═b972b218-970c-11eb-1949-535830e20990
# ╠═80682786-970d-11eb-223b-b5f762b19c24
# ╠═ed6d7404-970c-11eb-13ee-5f5a454d2222
# ╠═0e6cab25-70f8-46ab-a5ab-8542e232274e
# ╠═7edb7c63-c71e-455b-bb78-ddd50475e271
# ╟─c03d45f8-9188-11eb-2e11-0fafa39f253d
# ╠═43d20d56-d56a-47a8-893e-f726c1a99651
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
