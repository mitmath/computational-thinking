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
<iframe src="https://www.youtube.com/embed/" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ d155ea12-9628-11eb-347f-7754a33fd403
using Plots, PlutoUI, HypertextLiteralQ, LightGraphs, GraphPlot, Printf, SpecialFunctions

# ╔═╡ 01506de2-918a-11eb-2a4d-c554a6e54631
TableOfContents(title="📚 Table of Contents", aside=true)

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

# ╔═╡ 173b44ea-918c-11eb-116b-0bbaeffc3fe2
md"""
It is not unusual for students (and professors) to gravitate towards the discrete or the continuous.  We wish to point out, that the discrete and the continuous are so closely related, that it is worthwhile to be comfortable with both.  Up until fairly recently, much of computer science was often associated with discrete mathemtics, while computational science and engineering was associated with physical systems, hence continuous mathematics.

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
$(blue("Machine Learning, Epidemics, climate change, etc. show how critical continuous math is these days."))
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
(2:2:20)[7] # Compute 2*4 (more or less)

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

# ╔═╡ f20da096-9712-11eb-2a67-cd33f6ab8750
area(s) = (s/2) * sin(2π/s)

# ╔═╡ 6fd93018-c33b-4682-91c3-7a20a41d9b03
area0 = area.( 2 .^ (2:10) )

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
		<span style="color:black">$(given[1:indexofmistake-1])</span><span style="color: red">$(given[indexofmistake:end])</span>
		""")
end

# ╔═╡ bcfd1585-8161-43a2-8b19-ed654df2e0e1
colorgoodbad(string(float(π)) , string(22/7))

# ╔═╡ d2d1366b-9b6d-4e54-a0c4-7087f5f063c4
pyramid( [area0,area1], horizontal = true)

# ╔═╡ a76ac67b-27b9-4e2b-9fca-61480dca5264
area2 = [16/15 * area1[i+1] .-  1/15 * area1[i] for i = 1:length(area1)-1 ]

# ╔═╡ c742742a-765b-4eb5-bd65-dc0cd6328255
md"""
Another carefully chosen convolution: [-1/15,16/15], do you see the pattern?
"""

# ╔═╡ 6577e546-8f0b-413a-a8bb-b9c12803199d
pyramid([area0,area1,area2], horizontal = true)

# ╔═╡ 5273fe09-fe38-4c88-b84a-51af17cff906
big(π)

# ╔═╡ 4dd03325-2498-4fe7-9212-f964081a0300
area3 = [64/63 * area2[i+1] .-  1/63 * area2[i] for i = 1:length(area2)-1 ]

# ╔═╡ 626242ea-544c-49fc-9884-c70dd6800902
area4 = [128/127 * area3[i+1] .-  1/127 * area3[i] for i = 1:length(area3)-1 ]

# ╔═╡ 893a56b0-f5d0-4f8d-ba15-1048180a7e53
pyramid([pp.(area0), pp.(area1), pp.(area2), pp.(area3), pp.(area4)], horizontal = true)

# ╔═╡ dbccc2d5-c2af-48c4-8726-a95c09da78ae
md"""
Why does this work?
"""

# ╔═╡ 82a407b6-0ecb-4011-a0f6-bc9e1f51393f
md"""
Area(s) = ``(s/2) \sin (2\pi/2) = \pi- \frac{2\pi^3}{3} s^{-2}  + \frac{2\pi^5}{15}s^{-4} -  \frac{4\pi^7}{315} s^{-6} + \ldots``    

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
	area0b[end]
end

# ╔═╡ 553bdb0a-9714-11eb-1646-413a969d6884
begin
	area1b = [ 4//3 * area0b[i+1] .-  1//3 * area0b[i] for i = 1:length(area0b)-1 ]
	area1b[end]
end

# ╔═╡ 453f2585-157d-490a-9d1c-0b02939d0a11
begin
	area2b = [16//15 * area1b[i+1] .-  1//15 * area1b[i] for i = 1:length(area1b)-1 ]
	area2b[end]
end

# ╔═╡ bc1efddd-c959-4407-9a86-ba73a64508a8
begin
	area3b = [64//63 * area2b[i+1] .-  1//63 * area2b[i] for i = 1:length(area2b)-1 ]
	area3b[end]
end

# ╔═╡ 516b69d8-5d94-4b4d-9596-2db0dfbf4038
begin
	area4b = [256//255 * area3b[i+1] .-  1//255 * area3b[i] for i = 1:length(area3b)-1 ]
	area4b[end]
end

# ╔═╡ cec13915-8adb-4627-b220-591377239997
begin
	area5b = [1024//1023 * area4b[i+1] .-  1//1023 * area4b[i] for i = 1:length(area4b)-1 ]
	area5b[end]
end

# ╔═╡ 6d954628-6290-4867-8144-dd486551545d
begin
	area6b = [4096//4095 * area5b[i+1] .-  1//4095 * area5b[i] for i = 1:length(area5b)-1 ]
	area6b[end]
end

# ╔═╡ 00478b2c-5dcc-44fc-a7be-a3dadf6300e7
begin
	area7b = [16336//16335 * area6b[i+1] .-  1//16335 * area6b[i] for i = 1:length(area6b)-1 ]
	area7b[end]
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

# ╔═╡ 155241b0-9646-11eb-180e-89c8651536c6
@bind j Slider(1:9, show_value=true, default=6)

# ╔═╡ 4f845436-9646-11eb-2445-c12746a9e556
begin
	N  = 1024
	h =  1/N
	v = randn(N)
end

# ╔═╡ 31d56008-9646-11eb-1985-2b68af354773
J = N ÷ 2^j

# ╔═╡ 1761187e-9645-11eb-3778-b132f856696d
begin
	plot()	
	c = [0;cumsum(v)] .* √h
	plot!((0:N)./N,c)
	plot!( (0:J:N)./N,   c[1:J:end],legend=false,m=:o,ms=1, color=:red, lw=5)	   
	plot!(ylims=(-2,2))
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
	HTML("<span style='color:blue'> $(s)  </span>")
end

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

# ╔═╡ 43d20d56-d56a-47a8-893e-f726c1a99651
pp(x) =  colorgoodbad( string(float(π)) , (@sprintf "%.15f" x) )

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
# ╠═37fc6e56-9714-11eb-1427-b75613800366
# ╟─4a072870-961f-11eb-1215-17efa0013873
# ╠═de9066e2-d5eb-49e3-be71-edda8e8e31dd
# ╟─4d4705d0-9568-11eb-085c-0fc556c4cfe7
# ╠═155241b0-9646-11eb-180e-89c8651536c6
# ╠═4f845436-9646-11eb-2445-c12746a9e556
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
# ╟─c03d45f8-9188-11eb-2e11-0fafa39f253d
# ╟─43d20d56-d56a-47a8-893e-f726c1a99651
