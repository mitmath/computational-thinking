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

# ╔═╡ a0b3813e-adab-11eb-2983-616cf2bb6f5e
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="DifferentialEquations", version="6"),
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
    ])
    using DifferentialEquations, Plots, PlutoUI, LinearAlgebra
end

# ╔═╡ d84dbb08-b1a4-11eb-2d3b-0711fddd1347
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
"><em>Section 3.6</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Snowball Earth and hysteresis </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/cdIgr_2nUvI" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ ef8d6690-720d-4772-a41f-b260d306b5b2
TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)

# ╔═╡ 26e1879d-ab57-452a-a09f-49493e65b774
md"""
# Julia Concepts

- `sign(x)`  


"""

# ╔═╡ fd12468f-de16-47cc-8210-9266ca9548c2
md"""
## The sign or signum(latin for "sign") function
"""

# ╔═╡ 30969341-9079-4732-bf55-d6bba2c2c16c
md"""
`sign(x)` returns 0 if x is 0, or ±1 for positive/negative x.
"""

# ╔═╡ 5bf3fe83-d096-4df1-8476-0a6500b01868
begin
	scatter(sign, -5:.1:5, legend=false, m=:c, ms=3, size=(600,300))
	title!("The sign function is discontinuous at 0")
	xlabel!("x")
	ylabel!("sign(x)")
end

# ╔═╡ af7f36d9-adca-48b8-95bb-ac620e6f1b4f
sign(Inf)

# ╔═╡ 790add0f-c83f-4824-92ae-53159ce58f64
sign(-Inf)

# ╔═╡ 21210cfa-0366-4019-86f7-158fdd5f21ad
md"""
# Mathematics:multiple equilibria.  
## Using computation to explore hysteresis.
"""

# ╔═╡ 978e5fc0-ddd1-4e93-a243-a95d414123b9
md"""
The function  $f(y,a) = {\rm sign}(y) + a -y$ can be written

``f(y,a)= \left\{ \begin{array}{l} -1+a-y \ \ {\rm if} \ y<0  \ \ 
\textrm{(root at } a-1 \textrm{ if } a<1 )\\ 
\ \  \ 1+a-y \ \ {\rm if} \ y>0  
\ \ \textrm{(root at } a+1 \textrm{ if } a>-1 )
\end{array} \right.``

(we will ignore y=0).  Notice that for -1<a<1 there are two roots.
"""

# ╔═╡ 6139554e-c6c9-4252-9d64-042074f68391
begin
	f(y,a) =   sign(y)  + a -  y  
	f(y,a,t) = f(y,a) # just for the difeq solver
end

# ╔═╡ e115cbbc-9d49-4fa1-8701-fa48289a0916
md"""
The graph of `z=f(y,a)`  consists of two parallel half-planes. On the left below we intersect that graph with planes of constant `a`.  On the right, we have the intersection with `z=0`. 
"""

# ╔═╡ 991f14bb-fc4a-4505-a3be-5ced2fb148b6


# ╔═╡ 61960e99-2932-4a8f-9e87-f64a7a043489
md"""
a = $(@bind a Slider(-5:.1:5, show_value=true, default=0) )


"""

# ╔═╡ bd65e7f9-ecf2-43ac-b5a8-99b03866a5c8
begin
	plot( y->f(y,a, 0), -9, -eps(), xlabel="y" , ylabel="sign(y)-y+a", lw=3,color=:blue)
	plot!(y->f(y,a, 0), eps() ,9, lw=3, color=:blue)
	ylims!(-5,10)
	xlims!(-9,9)
	hline!([0], ls=:dash, color=:pink, legend=false)
   
	
	if a< 1
	 
	  annotate!( -2.2+a, -4, text(round(-1+a,digits=1), position=:right,11,:red))
	  scatter!([-1+a],[0],m=:circle,ms=10,color=:red)
	end
	if a>-1
	  
	  annotate!( 1+a, -4, text(round(1+a,digits=1), position=:right,11,:blue))
		 scatter!([1+a],[0],m=:circle,ms=10,color=:blue)
	end
	vline!([ 1+a], ls=:dash, color=:gray)
	 vline!([-1+a], ls=:dash, color=:gray)
	vline!([0],ls=:dash, color=:pink)
	P1 = title!(" Plot of f(y,a=$a) vs y")
	
	begin
	plot(a->a-1, -5:1, lw=2, c=:blue)
		 annotate!( a, 3+a, "a=$a")
	plot!(a->a+1, -1:5, lw=2,  c=:blue, legend=false)
	xlabel!("a")
	ylabel!("y")
	title!("Solution to f(y,a)=0") 
		
		if a<1
			annotate!(-4,  -.7+a,  text(round(-1+a,digits=1), position=:center,11,:red))
			hline!([-1+a],c=:gray,ls=:dash)
			scatter!([a],[-1+a],m=:circle,ms=10,color=:red)
		end
		if a> -1
						annotate!(-4,  1.3+a,  text(round(1+a,digits=1), position=:center,11,:blue))
			hline!([1+a],c=:gray,ls=:dash)
			scatter!([a],[1+a],m=:circle,ms=10,color=:blue)
		end
		ylims!(-5,5)
	P2 = annotate!(0,-4.7, text("Two roots if -1<a<1",6,:blue) )
		vline!([a],c=:gray,ls=:dash)
	plot( P1 ,P2,layout=(1,2))
end
end

# ╔═╡ 9acf9b8a-7fde-46c7-bf0c-c4dedc5a064b
md"""
The above are two section views of the surface z=f(y,a). Left: constant a.  Right: z =0.
"""

# ╔═╡ 9bc33f22-c065-4c1d-b06f-78c70415a111
# begin
# 	#s1=surface(-5:.1:-.1, -4:.1:4, f, legend=false )
# 	#s2=surface!(.00001:.1:4.1, -4:.1:4, f, legend=false )
# 	surface(-6:.05:4, -5:.05:4, f, legend=false, alpha=.5 )
	
# 	plot!(  [0,-6 ], [1, -5  ], [0,0], c=:red) 
# 	plot!(  [0,5 ], [-1, 4  ], [0,0], c=:red) 
# 	xlabel!("y")
# 	ylabel!("a")
	
# end

# ╔═╡ 6f61180d-6900-48fa-998d-36110e79d2dc
gr()

# ╔═╡ 5027e1f8-8c50-4538-949e-6c95c550016e
md"""
### Solution to y' = f(y,a) 
with y(0)=y₀
"""

# ╔═╡ 465f637c-0555-498b-a881-a2f6e5714cbb
md"""
y₀ = $(@bind y₀ Slider(-6:.1:6, show_value=true, default=2.0) )
"""

# ╔═╡ a09a0064-c6ab-4912-bc9f-96ab72b8bbca
sol = solve(  ODEProblem( f, y₀, (0,10.0), a ));

# ╔═╡ f8ee2373-6af0-4d81-98fb-23bde10198ef
function plotit(y₀, a)
	
	sol = solve(  ODEProblem( f, y₀, (0,10.0), a ));
	p = plot( sol , legend=false, background_color_inside=:black , ylims=(-7,7), lw=3, c=:red)
	
	# plot direction field:
		xs = Float64[]
		ys = Float64[]
		
	    lrx = LinRange( xlims(p)..., 30)
		for x in  lrx
			for y in LinRange( ylims(p)..., 30)
				v = [1, f(y, a ,x) ]
				v ./=  (100* (lrx[2]-lrx[1]))
	
				
				push!(xs, x - v[1], x + v[1], NaN)
				push!(ys, y - v[2], y + v[2], NaN)
			
			end
		end
	
	if a<1 hline!( [-1+a],c=:white,ls=:dash); end
	if a>-1  hline!( [1+a],c=:white,ls=:dash);end
	    hline!( [0 ],c=:pink,ls=:dash)
		plot!(xs, ys, alpha=0.7, c=:yellow)
	    ylabel!("y")
	    annotate!(-.5,y₀,text("y₀",color=:red))
	if a>-1
	   annotate!(5,1+a,text(round(1+a,digits=3),color=:white))
	end
	if a<1
	   annotate!(5,-1+a-.4,text(round(-1+a,digits=3),color=:white))
	end
    title!("Solution to y'=f(y,a)")
return(p)
end

# ╔═╡ a4686bca-90d6-4e02-961c-59f08fc37553
plotit(y₀, a)

# ╔═╡ a94b5160-f4bf-4ddc-9ee6-581ea20c8b90
md"""
### Hysteresis: Increasing then decreasing ``a``
Let's increase a by .25 from -4 to 4 then decrease from -4 to 4.
Every time we change a, we let 10 units of time evolve, enough
to reach the equilibriumf for that a, and watch the y values.

We see that when -1<a<1 it's possible to be at the "negative" equilibrium
or the "positive" equilibrium, depending on how you got there.
"""

# ╔═╡ fd882095-6cc4-4927-967c-6b02d5b1ad95
let
    Δt = 10
    t = 0.0
	y₀ =-5
	a = -4
	sol = solve(  ODEProblem( f, y₀, (t,t+Δt), a ))
	p=plot(sol)
	annotate!(10,-5,text("a=",7))
	
	
	
	for i= 1:32
		a += .25
		t += Δt
		y₀ = sol(t)
		sol = solve(  ODEProblem( f, y₀, (t,t+Δt), a ))
		
		if -1≤a ≤1
		  p=plot!(sol,xlims=(0,t), legend=false, fillrange=-5,fillcolor=:gray,alpha=.5)
		else
		  p=plot!(sol,xlims=(0,t), legend=false)
		end
		
		if i%4==0
			annotate!(t,-5,text( round(a,digits=1), 7, :blue))
		end
		
	
	end
	for i= 1:32
		a -= .25
		t += Δt
		y₀ = sol(t)
		sol = solve(  ODEProblem( f, y₀, (t,t+Δt), a ))
		
		if -1≤a≤1
		  p=plot!(sol,xlims=(0,t), legend=false, fillrange=-5,fillcolor=:gray,alpha=.5)
		else
		  p=plot!(sol,xlims=(0,t), legend=false)
		end
		
		if i%4==0
			annotate!(t,-5,text( round(a,digits=1), 7, :red))
		end
	end
	ylabel!("y")
	
	as_svg(plot!())
end

# ╔═╡ 10693e53-3741-4388-b3b1-eba739ec01d0
md"""
 The dependence of the state of a system on its history, what we observe above,
is known as *hysteresis* (Greek (ὑστέρησις) for lagging behind).
"""

# ╔═╡ 11b3fb9e-5922-4350-9424-51fba33502d4
md"""
# Application to Snowball Earth, the ice-albedo feedback
(from Henri Drake's lecture)
##  Review of the last climate lecture.

Recall from [Lecture 20 (Part I)](https://www.youtube.com/watch?v=Gi4ZZVS2GLA&t=15s) that the the **zero-dimensional energy balance equation** is

\begin{gather}
\color{brown}{C \frac{dT}{dt}}
\; \color{black}{=} \; \color{orange}{\frac{(1 - α)S}{4}}
\; \color{black}{-} \; \color{blue}{(A - BT)}
\; \color{black}{+} \; \color{grey}{a \ln \left( \frac{[\text{CO}₂]}{[\text{CO}₂]_{\text{PI}}} \right)},
\end{gather}
"""

# ╔═╡ b71fca45-9687-4a51-8e1c-1f413e83e58d
html"""<img src="https://raw.githubusercontent.com/hdrake/hdrake.github.io/master/figures/planetary_energy_balance.png" height=230>"""

# ╔═╡ d993a2fc-2319-4f64-8a17-904a57593da2
md"""
Today, we will ignore changes in CO₂, so that

$\ln \left( \frac{ [\text{CO}₂]_{\text{PI}} }{[\text{CO}₂]_{\text{PI}}} \right) = \ln(1) = 0$

and the model simplifies to

\begin{gather}
\color{brown}{C \frac{dT}{dt}}
\; \color{black}{=} \; \color{orange}{\frac{(1 - α)S}{4}}
\; \color{black}{-} \; \color{blue}{(A - BT)}.
\end{gather}


The dynamics of this **Ordinary Differential Equation (ODE)** are quite simple because it is *linear*: we can rewrite it in the form

$\dot{T} = f(T(t))$ where $f(x) = \alpha x + \beta$ is a *linear* function of x. A linear ODE permits only one stable solution, $\dot{T} = 0$, which in Lecture 20 we found was Earth's pre-industrial temperature $T_{0} = 14$°C. 

In this lecture, we show how a small modification that makes one term in our simple climate model non-linear completely changes its dynamics, allowing us to explain the existence of both "Snowball Earth" and the relatively warm pre-industrial climate that allowed humans to thrive.
"""

# ╔═╡ 4bdc0f0c-e696-4d87-b10c-8a0da9a0ee5b
md"""
## 1) Background: Snowball Earth

Geological evidence shows that the Neoproterozoic Era (550 to 1000 million years ago) is marked by two global glaciation events, in which Earth's surface was covered in ice and snow from the Equator to the poles (see review by [Pierrehumbert et al. 2011](https://www.annualreviews.org/doi/full/10.1146/annurev-earth-040809-152447)).
"""

# ╔═╡ 7b7b631e-2ba3-4ed3-bad0-ec6ecb70ad49
html"""

<img src="https://news.cnrs.fr/sites/default/files/styles/asset_image_full/public/assets/images/frise_earths_glaciations_72dpi.jpg?itok=MgKrHlIV" height=500>
"""

# ╔═╡ 70ec6ae9-601f-4862-96cb-f251d4b5a7fd
html"""
<img src="https://upload.wikimedia.org/wikipedia/commons/d/df/Ice_albedo_feedback.jpg" height=350>
"""

# ╔═╡ 2bafd1a4-32a3-4787-807f-0a5132d66c28
md"""
We can represent the ice-albedo feedback crudely in our energy balance model by allowing the albedo to depend on temperature:

$\alpha(T) = \begin{cases}
\alpha_{i} & \mbox{if }\;\; T \leq -10\text{°C} &\text{(completely frozen)}\\
\alpha_{i} + (\alpha_{0}-\alpha_{i})\frac{T + 10}{20} & \mbox{if }\;\; -10\text{°C} \leq T \leq 10\text{°C} &\text{(partially frozen)}\\
\alpha_{0} &\mbox{if }\;\; T \geq 10\text{°C} &\text{(no ice)}
\end{cases}$
"""

# ╔═╡ fca6c4ec-4d0c-4f97-b966-ce3a81a18710
md"""
### 1.2) Adding the ice-albedo feedback to our simple climate model

First, we program albedo as a function of temperature.
"""

# ╔═╡ cfde8137-cfcd-46de-9c26-8abb64b6b3a9
md"""
To add this function into our energy balance model from [Lecture 20 (Part I)](https://www.youtube.com/watch?v=Gi4ZZVS2GLA&t=15s) (which we've copied into the cell below), all we have to do is overwrite the definition of the `timestep!` method to specify that the temperature-dependent albedo should be updated based on the current state:
"""

# ╔═╡ 4351b05f-f9bf-4046-9f95-a0a56b1e8cc9
module Model

const S = 1368; # solar insolation [W/m^2]  (energy per unit time per unit area)
const α = 0.3; # albedo, or planetary reflectivity [unitless]
const B = -1.3; # climate feedback parameter [W/m^2/°C],
const T0 = 14.; # preindustrial temperature [°C]

absorbed_solar_radiation(; α=α, S=S) = S*(1 - α)/4; # [W/m^2]
outgoing_thermal_radiation(T; A=A, B=B) = A - B*T;

const A = S*(1. - α)/4 + B*T0; # [W/m^2].

greenhouse_effect(CO2; a=a, CO2_PI=CO2_PI) = a*log(CO2/CO2_PI);

const a = 5.0; # CO2 forcing coefficient [W/m^2]
const CO2_PI = 280.; # preindustrial CO2 concentration [parts per million; ppm];
CO2_const(t) = CO2_PI; # constant CO2 concentrations

const C = 51.; # atmosphere and upper-ocean heat capacity [J/m^2/°C]

function timestep!(ebm)
	append!(ebm.T, ebm.T[end] + ebm.Δt*tendency(ebm));
	append!(ebm.t, ebm.t[end] + ebm.Δt);
end;

tendency(ebm) = (1. /ebm.C) * (
	+ absorbed_solar_radiation(α=ebm.α, S=ebm.S)
	- outgoing_thermal_radiation(ebm.T[end], A=ebm.A, B=ebm.B)
	+ greenhouse_effect(ebm.CO2(ebm.t[end]), a=ebm.a, CO2_PI=ebm.CO2_PI)
);

begin
	mutable struct EBM
		T::Array{Float64, 1}
	
		t::Array{Float64, 1}
		Δt::Float64
	
		CO2::Function
	
		C::Float64
		a::Float64
		A::Float64
		B::Float64
		CO2_PI::Float64
	
		α::Float64
		S::Float64
	end;
	
	# Make constant parameters optional kwargs
	EBM(T::Array{Float64, 1}, t::Array{Float64, 1}, Δt::Float64, CO2::Function;
		C=C, a=a, A=A, B=B, CO2_PI=CO2_PI, α=α, S=S) = (
		EBM(T, t, Δt, CO2, C, a, A, B, CO2_PI, α, S)
	);
	
	# Construct from float inputs for convenience
	EBM(T0::Float64, t0::Float64, Δt::Float64, CO2::Function;
		C=C, a=a, A=A, B=B, CO2_PI=CO2_PI, α=α, S=S) = (
		EBM([T0], [t0], Δt, CO2;
			C=C, a=a, A=A, B=B, CO2_PI=CO2_PI, α=α, S=S);
	);
end;

begin
	function run!(ebm::EBM, end_year::Real)
		while ebm.t[end] < end_year
			timestep!(ebm)
		end
	end;
	
	run!(ebm) = run!(ebm, 200.) # run for 200 years by default
end


CO2_hist(t) = CO2_PI * (1 .+ fractional_increase(t));
fractional_increase(t) = ((t .- 1850.)/220).^3;

begin
	hist = EBM(T0, 1850., 1., CO2_hist,
		C=C, B=B, A=A
	)
	run!(hist, 2020.)
end

begin
	CO2_RCP26(t) = CO2_PI * (1 .+ fractional_increase(t) .* min.(1., exp.(-((t .-1850.).-170)/100))) ;
	RCP26 = EBM(T0, 1850., 1., CO2_RCP26)
	run!(RCP26, 2100.)
	
	CO2_RCP85(t) = CO2_PI * (1 .+ fractional_increase(t) .* max.(1., exp.(((t .-1850.).-170)/100)));
	RCP85 = EBM(T0, 1850., 1., CO2_RCP85)
	run!(RCP85, 2100.)
end

end

# ╔═╡ 066743eb-c890-40b9-9f6b-9f79b7ebcbd2
md"""### 1.1) The ice-albedo feedback

In Lecture 20, we used a **constant** value $α =$ $(Model.hist.α) for Earth's planetary albedo, which is a reasonable thing to do for small climate variations relative to the present (such as the difference between the present-day and preindustrial climates). In the case of large variations, however, this approximation is not very reliable.

While oceans are dark and absorbant, $α_{ocean} \approx 0.05$, ice and snow are bright and reflective: $\alpha_{ice,\,snow} \approx 0.5$ to $0.9$. Thus, if much of the ocean's surface freezes over, we expect Earth's albedo to rise dramatically, causing more sunlight to be reflected to space, which in turn causes even more cooling and more of the ocean to freeze, etc. This *non-linear positive feedback effect* is referred to as the **ice-albedo feedback** (see illustration below).
"""

# ╔═╡ b1fee17b-6522-4cf0-a614-5ff8aa8f8614
function α(T; α0=Model.α, αi=0.5, ΔT=10.)
	if T < -ΔT
		return αi
	elseif -ΔT <= T < ΔT
		return αi + (α0-αi)*(T+ΔT)/(2ΔT)
	elseif T >= ΔT
		return α0
	end
end

# ╔═╡ 40b5e447-0cfb-4f35-8f95-6aa29793e5ad
begin
	T_example = -20.:1.:20.
	plot(size=(600, 400), ylims=(0.2, 0.6))
	plot!([-20, -10], [0.2, 0.2], fillrange=[0.6, 0.6], color=:lightblue, alpha=0.2, label=nothing)
	plot!([10, 20], [0.2, 0.2], fillrange=[0.6, 0.6], color=:red, alpha=0.12, label=nothing)
	plot!(T_example, α.(T_example), lw=3., label="α(T)", color=:black)
	plot!(ylabel="albedo α\n(planetary reflectivity)", xlabel="Temperature [°C]")
	annotate!(-15.5, 0.252, text("completely\nfrozen", 10, :darkblue))
	annotate!(15.5, 0.252, text("no ice", 10, :darkred))
	annotate!(-0.3, 0.252, text("partially frozen", 10, :darkgrey))
	
end

# ╔═╡ e9942719-93cc-4203-8d37-8f91539104b1
function Model.timestep!(ebm)
	ebm.α = α(ebm.T[end]) # Added this line
	append!(ebm.T, ebm.T[end] + ebm.Δt*Model.tendency(ebm));
	append!(ebm.t, ebm.t[end] + ebm.Δt);
end

# ╔═╡ 0c1e3051-c491-4de7-a149-ce81c53f5841
md"""## 2) Multiple Equilibria
**OR: the existence of "alternate Earths"**

Human civilization flourished over the last several thousand years in part because Earth's global climate has been remarkably stable and forgiving. The preindustrial combination of natural greenhouse effect and incoming solar radiation yielded temperatures between the freezing and boiling points of water across most of the planet, allowing ecoystems based on liquid water to thrive.

The climate system, however, is rife with non-linear effects like the **ice-albedo effect**, which reveal just how fragile our habitable planet is and just how unique our stable pre-industrial climate was.

We learned in Lecture 20 that in response to temperature fluctuations, *net-negative feedbacks* act to restore Earth's temperature back towards a single equilibrium state in which absorbed solar radiation is balanced by outgoing thermal radiation. Here, we explore how *non-linear positive feedbacks* can temporarily result in a *net-positive feedback* and modify Earth's state space.
"""

# ╔═╡ d0d43dc3-4cda-4602-90c6-2d14a1e63871
md"""
### 2.1) Exploring the non-linear ice-albedo feedback

In [Lecture 20 (Part II)](https://www.youtube.com/watch?v=D3jpfeQCISU), we learned how introducing non-linear terms in *ordinary differential equations* can lead to complex state spaces that allow for multiple fixed points (e.g. for $\dot{x} = \mu + x^{2}$).

Let's explore how this plays out with the non-linear ice-albedo feedback by varying the initial condition $T_{0} \equiv T(t=0)$ and allowing the system to evolve for 200 years.
"""

# ╔═╡ 48431fc9-413f-4f72-8c6f-f48b42c29475
begin
	T0_slider = @bind T0_interact Slider(-60.:0.0025:30., default=24., show_value=true)
	md""" T₀ = $(T0_slider) °C"""
end

# ╔═╡ c719ff5f-421d-4d4d-87b7-34879ab188c5
begin
	ebm_interact = Model.EBM(Float64(T0_interact), 0., 1., Model.CO2_const)
	Model.run!(ebm_interact, 200)
end

# ╔═╡ 9b6edae8-fbf0-4979-9536-c0f782ba70a7
md"We can get an overview of the behavior by drawing a set of these curves all on the same graph:"

# ╔═╡ 81d823a6-5c92-496a-96f1-a0f4762f1f05
begin	
	p_equil = plot(xlabel="year", ylabel="temperature [°C]", legend=:bottomright, xlims=(0,205), ylims=(-60, 30.))
	
	plot!([0, 200], [-60, -60], fillrange=[-10., -10.], fillalpha=0.3, c=:lightblue, label=nothing)
	annotate!(120, -20, text("completely frozen", 10, :darkblue))
	
	plot!([0, 200], [10, 10], fillrange=[30., 30.], fillalpha=0.09, c=:red, lw=0., label=nothing)
	annotate!(120, 25, text("no ice", 10, :darkred))
	for T0_sample in (-60.:5.:30.)
		ebm = Model.EBM(T0_sample, 0., 1., Model.CO2_const)
		Model.run!(ebm, 200)
		
		plot!(p_equil, ebm.t, ebm.T, label=nothing)
	end
	
	T_un = 7.5472
	for δT in 1.e-2*[-2, -1., 0., 1., 2.]
		ebm_un = Model.EBM(T_un+δT, 0., 1., Model.CO2_const)
		Model.run!(ebm_un, 200)

		plot!(p_equil, ebm_un.t, ebm_un.T, label=nothing, linestyle=:dash)
	end
	
	plot!(p_equil, [200], [Model.T0], markershape=:circle, label="Our pre-industrial climate (stable ''warm'' branch)", color=:orange, markersize=8)
	plot!(p_equil, [200], [-38.3], markershape=:circle, label="Alternate universe pre-industrial climate (stable ''cold'' branch)", color=:aqua, markersize=8)
	plot!(p_equil, [200], [T_un], markershape=:diamond, label="Impossible alternate climate (unstable branch)", color=:lightgrey, markersize=8, markerstrokecolor=:white, alpha=1., markerstrokestyle=:dash)
	p_equil
end

# ╔═╡ 28924aef-9157-4490-afa5-7f232a5101f0
md"We see that for T₀ ⪆  $(round(T_un, digits=2)) °C, all of the curves seem to converge on the T = 14°C *equilibrium* (or *fixed point*) that we saw in Lecture 20. Curves that start below this value warm up and while curves that start above this value will cool down. For T₀ ⪅ $(round(T_un, digits=2)) °C, however, the temperatures converge on a much colder equilibrium around T = -40°C. This is the **Snowball Earth** equilibrium. These two states are referred to as **stable equilibria** because even if the state gets temporarily pushed slightly away from its equilibrium, it will eventually converge right back to its equilibrium.

So what happens is T₀ ≈ $(round(T_un, digits=2)) °C? For some exact temperature near there, there is indeed an equilibrim state: if you start with that temperature you will stay there forever. However, if the temperature starts off even *one one-hundredth of a degree* above or below this exact value, we see that temperatures eventually converge to one of the other two equilibria. Thus, we call this intermediate equilibrium an **unstable equilibrium**, because any *infinitesimal* push away will cause it to careen away towards another state. 
"

# ╔═╡ 5eb888e1-ba95-4aa1-97c0-784dc9d9e6d5
md"""
### 2.2) Radiative stability analysis

We can understand why our model has two stable equilibria and one unstable equilibrium by applying concepts from dynamical systems theory.

Recall that, with fixed CO₂ concentrations, our energy balance model differential equation can be expressed as:

$C\frac{d\,T}{d\,t} = \text{ASR}(T) - \text{OTR}(T),$

where now the Absorbed Solar Radiation (ASR) is also temperature dependent because the albedo $α(T)$ is.

In particular, by plotting the right-hand-side tendency terms as a function of the state variable $T$, we can plot a stability diagram for our system that tells us whether the planet will warm ($C \frac{d\,T}{d\,t} > 0$) or cool ($C \frac{d\,T}{d\,t} < 0$).
"""

# ╔═╡ 18922c20-62dc-4524-8300-bbab4db828a9
begin
	T_samples = -60.:1.:30.
	OTR = Model.outgoing_thermal_radiation.(T_samples)
	ASR = [Model.absorbed_solar_radiation.(α=α(T_sample)) for T_sample in T_samples]
	imbalance = ASR .- OTR
end;

# ╔═╡ 22328073-bb46-4ec2-9fdf-17c0daff5741
begin
	p1_stability = plot(legend=:topleft, ylabel="energy flux [W/m²]", xlabel="temperature [°C]")
	plot!(p1_stability, T_samples, OTR, label="Outgoing Thermal Radiation", color=:blue, lw=2.)
	plot!(p1_stability, T_samples, ASR, label="Absorbed Solar Radiation", color=:orange, lw=2.)
	
	p2_stability = plot(ylims=(-50, 45), ylabel="energy flux [W/m²]", xlabel="temperature [°C]")
	plot!([-60., 30.], [-100, -100], fillrange=[0, 0], color=:blue, alpha=0.1, label=nothing)
	plot!([-60., 30.], [100, 100], fillrange=[0, 0], color=:red, alpha=0.1, label=nothing)
	annotate!(-58, -40, text("cooling", :left, :darkblue))
	annotate!(-58, 38, text("warming", :left, :darkred))
	plot!(p2_stability, T_samples, imbalance, label="Radiative Imbalance\n(ASR - OTR)", color=:black, lw=2.)
	plot!([7.542], [0], markershape=:diamond, markersize=6, color=:lightgrey, markerstrokecolor=:darkgrey, label=nothing)
	plot!([Model.T0], [0], markershape=:circle, markersize=6, color=:orange, markerstrokecolor=:black, label=nothing)
	plot!([-38.3], [0], markershape=:circle, markersize=6, color=:aqua, markerstrokecolor=:black, label=nothing)
	
	p_stability = plot(p1_stability, p2_stability, layout=(1,2), size=(680, 300))
end

# ╔═╡ 9c4ac33a-ebbd-47db-9057-91624b0a2497
md"
## 3) Transitioning to and from Snowball Earth

### 3.1) Turning up the Sun

Over the entire history of the Earth, the Sun is thought to have brightened by about 40%."

# ╔═╡ 2798028c-d971-45e4-9484-bdec7e8dc048
html"""
<img src="https://rainbow.ldeo.columbia.edu/courses/s4021/ec98/fys.gif" alt="Plot showing increasing solar luminosity over time" height=300>
"""

# ╔═╡ 5fc03f0f-ae12-476f-93f8-6285ee7f5fc9
md"In the Neoproterozoic (~700 million years ago), the Sun was 93% as bright as it is today, such that the incoming solar radiation was $S =$ 1272 W/m², Earth's average temperature plunged to $T = -50$°C, and Earth's ice-covered surface had a high albedo (reflectivity) of $α_{i} = 0.5$.

### 3.2) Did the increasing brightness of the Sun melt the Snowball?
If we start out in the Neoproterozoic climate and all we do is increase solar insolation to today's value of $S =$ 1368 W/m², can we warm the planet up to the pre-industrial temperature of $T=14$°C?
"

# ╔═╡ 10815b22-b920-4cb7-a078-4d5ef457ebf2
md"""*Extend upper-limit of insolation* $(@bind extend_S CheckBox(default=false))"""

# ╔═╡ 984f0489-7430-43b9-8926-9d7c32e7da63
if extend_S
	md"""
	*"Cold" branch* $(@bind show_cold CheckBox(default=false))    |   
	*"Warm" branch* $(@bind show_warm CheckBox(default=false))    |   
	*Unstable branch* $(@bind show_unstable CheckBox(default=false))
	"""
else
	show_cold = true;
	nothing
end

# ╔═╡ bf0dd94d-e861-478a-9bb0-d34d17405fcc
if extend_S
	md"""
	##### Abrupt climate transitions
	
	In this model, temperature variations are fairly smooth unless temperatures rise above -10°C or fall below 10°C, in which case the *ice-albedo positive feedback* kicks in and causes an **abrupt climate transition**. While this is just a simple hypothetical model, these kinds of abrupt climate transitions show up all the time in the paleoclimate record and in more realistic climate model simulations.

	![](https://www.pnas.org/content/pnas/115/52/13288/F1.large.jpg)
	
	This simulation teaches us that we should not take the stability of our climate for granted and that pushing our present climate outside of its historical regime of stability could trigger catastrophic abrupt climate transitions.
	"""
end

# ╔═╡ 81088439-312a-4042-bcee-c021e5e3f6b7
md"""
### 3.3) If not the Sun, how did Snowball Earth melt?

The leading theory is that a slow but steady outgassing of CO₂ from volcanoes eventually caused a strong enough greenhouse gas effect to offset the cooling effect of the frozen surface's high albedo and raise temperatures above the melting point $-10$°C.
"""

# ╔═╡ 9d79d1ed-a538-4eda-bbe2-4b3858cc4e01
html"""
<img src="https://hartm242.files.wordpress.com/2011/03/snowball-earth.jpg" width=680>
"""

# ╔═╡ 5b574c5a-ce4b-4804-aa6c-58e0f7459520
md"""
In **Homework 9**, you will extend the above model to include the effect of CO₂ and determine how much CO2 would need to be added to the snowball for it to melt.
"""

# ╔═╡ 66c35971-30fb-4743-b65e-d2e527e15be7
md"""### 4) Towards realistic climate modelling

In this simple model, the preindustrial climate of $T=14$°C is so warm that there is no ice anywhere on the planet. Indeed, the only two valid stable climates are one with *no ice* or one with *ice everywhere*. 

So how did Earth's preindustrial climate, which was relatively stable for thousands of years, have substantial ice caps at the poles?

"""

# ╔═╡ b15da4ce-8fdf-4d75-9060-0cdf648c5355
md"""
**The "Aquaplanet", a simple three-dimensional ocean-world climate model**

An "Aquaplanet" is a three-dimensional global climate simulation of a hypothetical planet covered entirely by a single global Ocean. While this is of course very different from Earth, where 27% of the planet is covered in land, the "Aquaplanet" exhibits many of the same characteristics as Earth and is much more realistic than our zero-dimensional climate model above.

The video below shows that the Aquaplanet simulation exhibits a third equilibrium state, with a *mostly-liquid ocean but ice caps at the poles*, in addition to the two we found in our zero-dimensional model.

In **Homework 10** (2020 class), you will build a simple two-dimensional version of the aqua-planet and explore its stability.
"""

# ╔═╡ e3e0b838-19a9-4f9b-9026-0b546d3c416b
html"""
<iframe width="700" height="394" src="https://www.youtube-nocookie.com/embed/lYm_IyBHMUs" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ c2db5c70-b854-48b5-ba20-b64e2c7cf680
md"""
## Appendix
"""

# ╔═╡ 8eee86b6-f8e4-4016-a203-8e5e2a8b44e4
md"#### Pluto Magic"

# ╔═╡ 764a1d24-cfc2-4e28-90bb-fba264dc8956
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end



# ╔═╡ 3e84f2e2-f2d3-41ce-903f-5596096c55ba
md"""
#### Bifurcation diagram helper functions
"""

# ╔═╡ 6a96738f-4864-48b8-b345-570c895633cd
function restart_ebm!(ebm)
	ebm.T = [ebm.T[end]]
	ebm.t = [ebm.t[1]]
end

# ╔═╡ 80caaf52-062b-43c5-93c9-3bbdc2d61cec
function plot_trajectory!(p, x, y; lw=8)
	n = size(x,1)
	plot!(x, y, color="black", alpha=collect(1/n:1/n:1.), linewidth=collect(0.:lw/n:lw), label=nothing)
	plot!((x[end], y[end]), color="black", marker=:c, markersize=lw/2*1.2, label=nothing, markerstrokecolor=nothing, markerstrokewidth=0.)
	return p
end;

# ╔═╡ ff6b1d24-7870-4151-8928-213de7942c7d
begin
	Smin = 1200
	Smax = 1800
	Smax_limited = 1650
	Svec = Smin:1.:Smax
	Svec = vcat(Svec, reverse(Svec))
	Tvec = zeros(size(Svec))

	local T_restart = -100.
	for (i, S) = enumerate(Svec)
		ebm = Model.EBM(T_restart, 0., 5., Model.CO2_const);
		ebm.S = S
		Model.run!(ebm, 400.)
		T_restart = ebm.T[end]
		Tvec[i] = deepcopy(T_restart)
	end
	
	md"**Data structures for storing warm & cool branch climates**"
end

# ╔═╡ 72e822ef-0256-4612-8b6d-654ba6f6a83f
md"""
For insolations $S$ between $(Smin) W/m² and $(Smax_limited) W/m², temperatures always remain below -10°C and the planet remains completely frozen. What if we extend the upper limit on insolation so that the Sun becomes bright enough to start melting ice?
"""

# ╔═╡ ff687478-30a2-4d6e-9a62-859c61db6a34
begin
	T_unstable_branch(S, A, B, αi, α0) = (
		(A/B-S/(4B)*(1-0.5(αi+α0))) /
		(1+S*(αi-α0)/(80B))
	)
	S_unstable = Smin:2:Smax
	T_unstable = T_unstable_branch.(S_unstable, Model.A, Model.B, 0.5, 0.3)
	T_unstable[.~(0.3 .< α.(T_unstable) .< 0.5)] .= NaN
	md"**Unstable branch solution**"
end

# ╔═╡ b2e4513a-76aa-4a8c-8ad4-490533789c74
function add_labels!(p)
	plot!(p, xlabel="year", ylabel="temperature [°C]", legend=:bottomright, xlims=(-5,205), ylims=(-60, 30.))
	
	plot!(p, [-5, 200], [-60, -60], fillrange=[-10., -10.], fillalpha=0.3, c=:lightblue, label=nothing)
	annotate!(120, -20, text("completely frozen", 10, :darkblue))
	
	plot!(p, [-5, 200], [10, 10], fillrange=[30., 30.], fillalpha=0.09, c=:red, lw=0., label=nothing)
	annotate!(p, 120, 25, text("no ice", 10, :darkred))
end

# ╔═╡ 0b6bfab9-96e9-4d7a-a486-4582d7303244
begin
	p_interact = plot(ebm_interact.t, ebm_interact.T, label=nothing, lw=3)
	plot!([0.], [T0_interact], label=nothing, markersize=4, markershape=:circle)
	
	add_labels!(p_interact)
end |> as_svg

# ╔═╡ f5361e48-e613-4fed-8da3-5576feea776d
begin
	Sneo = Model.S*0.93
	Tneo = -48.
	md"**Initial conditions**"
end

# ╔═╡ ada47602-2cf6-4ef5-b1ba-0b1c6f81ad91
begin
	if extend_S
		solarSlider = @bind S Slider(Smin:2.:Smax, default=Sneo);
		md""" $(Smin) W/m² $(solarSlider) $(Smax) W/m²"""
	else
		solarSlider = @bind S Slider(Smin:2.:Smax_limited, default=Sneo);
		md""" $(Smin) W/m² $(solarSlider) $(Smax_limited) W/m²"""
	end
end

# ╔═╡ eb0307f1-c828-41f9-bc49-2aedd5b588e1
begin
	md"""
	*Move the slider below to change the brightness of the Sun (solar insolation):* S = $(S) [W/m²]
	"""
end

# ╔═╡ 0b654bc2-9f01-42e5-a21d-e047ccbe43e2
begin
	ebm = Model.EBM(Tneo, 0., 5., Model.CO2_const)
	ebm.S = Sneo
	
	ntraj = 10
	Ttraj = repeat([NaN], ntraj)
	Straj = repeat([NaN], ntraj)
	
	md"**Data structures for storing trajectories of recent climates**"
end

# ╔═╡ 5ebe385f-3542-4674-b419-fb54519aa945
begin
	S
	warming_mask = (1:size(Svec)[1]) .< size(Svec)./2
	p = plot(xlims=(Smin, Smax_limited), ylims=(-55, 75), title="Earth's solar insolation bifurcation diagram")
	# plot!([Model.S, Model.S], [-55, 75], color=:yellow, alpha=0.3, lw=8, label="Pre-industrial / present insolation")
	# if extend_S
	# 	plot!(p, xlims=(Smin, Smax))
	# 	if show_cold
	# 		plot!(Svec[warming_mask], Tvec[warming_mask], color=:blue,lw=3., alpha=0.5, label="cool branch")
	# 	end
	# 	if show_warm
	# 		plot!(Svec[.!warming_mask], Tvec[.!warming_mask], color="red", lw=3., alpha=0.5, label="warm branch")
	# 	end
	# 	if show_unstable
	# 		plot!(S_unstable, T_unstable, color=:darkgray, lw=3., alpha=0.4, ls=:dash, label="unstable branch")
	# 	end
	# end
	# plot!(legend=:topleft)
	# plot!(xlabel="solar insolation S [W/m²]", ylabel="Global temperature T [°C]")
	# plot!([Model.S], [Model.T0], markershape=:circle, label="Our preindustrial climate", color=:orange, markersize=8)
	# plot!([Model.S], [-38.3], markershape=:circle, label="Alternate preindustrial climate", color=:aqua, markersize=8)
	# plot!([Sneo], [Tneo], markershape=:circle, label="neoproterozoic (700 Mya)", color=:lightblue, markersize=8)
	plot_trajectory!(p, reverse(Straj), reverse(Ttraj), lw=9)
	
	plot!([Smin, Smax], [-60, -60], fillrange=[-10., -10.], fillalpha=0.3, c=:lightblue, label=nothing)
	annotate!(Smin+12, -19, text("completely\nfrozen", 10, :darkblue, :left))
	
	plot!([Smin, Smax], [10, 10], fillrange=[80., 80.], fillalpha=0.09, c=:red, lw=0., label=nothing)
	annotate!(Smin+12, 15, text("no ice", 10, :darkred, :left))
end |> as_svg

# ╔═╡ 7b21aa83-f4fc-48d2-81ac-c120dd421d73
begin
	S
	restart_ebm!(ebm)
	ebm.S = S
	Model.run!(ebm, 500)

	insert!(Straj, 1, copy(S))
	pop!(Straj)

	insert!(Ttraj, 1, copy(ebm.T[end]))
	pop!(Ttraj)
end;

# ╔═╡ Cell order:
# ╟─d84dbb08-b1a4-11eb-2d3b-0711fddd1347
# ╠═a0b3813e-adab-11eb-2983-616cf2bb6f5e
# ╠═ef8d6690-720d-4772-a41f-b260d306b5b2
# ╟─26e1879d-ab57-452a-a09f-49493e65b774
# ╟─fd12468f-de16-47cc-8210-9266ca9548c2
# ╟─30969341-9079-4732-bf55-d6bba2c2c16c
# ╟─5bf3fe83-d096-4df1-8476-0a6500b01868
# ╠═af7f36d9-adca-48b8-95bb-ac620e6f1b4f
# ╠═790add0f-c83f-4824-92ae-53159ce58f64
# ╟─21210cfa-0366-4019-86f7-158fdd5f21ad
# ╟─978e5fc0-ddd1-4e93-a243-a95d414123b9
# ╠═6139554e-c6c9-4252-9d64-042074f68391
# ╟─e115cbbc-9d49-4fa1-8701-fa48289a0916
# ╟─bd65e7f9-ecf2-43ac-b5a8-99b03866a5c8
# ╟─991f14bb-fc4a-4505-a3be-5ced2fb148b6
# ╟─61960e99-2932-4a8f-9e87-f64a7a043489
# ╟─9acf9b8a-7fde-46c7-bf0c-c4dedc5a064b
# ╟─9bc33f22-c065-4c1d-b06f-78c70415a111
# ╠═6f61180d-6900-48fa-998d-36110e79d2dc
# ╠═a09a0064-c6ab-4912-bc9f-96ab72b8bbca
# ╟─5027e1f8-8c50-4538-949e-6c95c550016e
# ╟─465f637c-0555-498b-a881-a2f6e5714cbb
# ╠═a4686bca-90d6-4e02-961c-59f08fc37553
# ╟─f8ee2373-6af0-4d81-98fb-23bde10198ef
# ╟─a94b5160-f4bf-4ddc-9ee6-581ea20c8b90
# ╟─fd882095-6cc4-4927-967c-6b02d5b1ad95
# ╟─10693e53-3741-4388-b3b1-eba739ec01d0
# ╟─11b3fb9e-5922-4350-9424-51fba33502d4
# ╟─b71fca45-9687-4a51-8e1c-1f413e83e58d
# ╟─d993a2fc-2319-4f64-8a17-904a57593da2
# ╟─4bdc0f0c-e696-4d87-b10c-8a0da9a0ee5b
# ╟─7b7b631e-2ba3-4ed3-bad0-ec6ecb70ad49
# ╟─066743eb-c890-40b9-9f6b-9f79b7ebcbd2
# ╟─70ec6ae9-601f-4862-96cb-f251d4b5a7fd
# ╟─2bafd1a4-32a3-4787-807f-0a5132d66c28
# ╠═40b5e447-0cfb-4f35-8f95-6aa29793e5ad
# ╟─fca6c4ec-4d0c-4f97-b966-ce3a81a18710
# ╠═b1fee17b-6522-4cf0-a614-5ff8aa8f8614
# ╟─cfde8137-cfcd-46de-9c26-8abb64b6b3a9
# ╟─4351b05f-f9bf-4046-9f95-a0a56b1e8cc9
# ╠═e9942719-93cc-4203-8d37-8f91539104b1
# ╟─0c1e3051-c491-4de7-a149-ce81c53f5841
# ╟─d0d43dc3-4cda-4602-90c6-2d14a1e63871
# ╟─48431fc9-413f-4f72-8c6f-f48b42c29475
# ╟─c719ff5f-421d-4d4d-87b7-34879ab188c5
# ╠═0b6bfab9-96e9-4d7a-a486-4582d7303244
# ╟─9b6edae8-fbf0-4979-9536-c0f782ba70a7
# ╠═81d823a6-5c92-496a-96f1-a0f4762f1f05
# ╟─28924aef-9157-4490-afa5-7f232a5101f0
# ╟─5eb888e1-ba95-4aa1-97c0-784dc9d9e6d5
# ╠═18922c20-62dc-4524-8300-bbab4db828a9
# ╠═22328073-bb46-4ec2-9fdf-17c0daff5741
# ╟─9c4ac33a-ebbd-47db-9057-91624b0a2497
# ╟─2798028c-d971-45e4-9484-bdec7e8dc048
# ╟─5fc03f0f-ae12-476f-93f8-6285ee7f5fc9
# ╠═eb0307f1-c828-41f9-bc49-2aedd5b588e1
# ╠═ada47602-2cf6-4ef5-b1ba-0b1c6f81ad91
# ╠═5ebe385f-3542-4674-b419-fb54519aa945
# ╟─72e822ef-0256-4612-8b6d-654ba6f6a83f
# ╟─10815b22-b920-4cb7-a078-4d5ef457ebf2
# ╠═984f0489-7430-43b9-8926-9d7c32e7da63
# ╠═bf0dd94d-e861-478a-9bb0-d34d17405fcc
# ╟─81088439-312a-4042-bcee-c021e5e3f6b7
# ╟─9d79d1ed-a538-4eda-bbe2-4b3858cc4e01
# ╟─5b574c5a-ce4b-4804-aa6c-58e0f7459520
# ╟─66c35971-30fb-4743-b65e-d2e527e15be7
# ╟─b15da4ce-8fdf-4d75-9060-0cdf648c5355
# ╟─e3e0b838-19a9-4f9b-9026-0b546d3c416b
# ╟─c2db5c70-b854-48b5-ba20-b64e2c7cf680
# ╟─8eee86b6-f8e4-4016-a203-8e5e2a8b44e4
# ╠═764a1d24-cfc2-4e28-90bb-fba264dc8956
# ╟─3e84f2e2-f2d3-41ce-903f-5596096c55ba
# ╠═6a96738f-4864-48b8-b345-570c895633cd
# ╠═0b654bc2-9f01-42e5-a21d-e047ccbe43e2
# ╠═7b21aa83-f4fc-48d2-81ac-c120dd421d73
# ╠═80caaf52-062b-43c5-93c9-3bbdc2d61cec
# ╠═ff6b1d24-7870-4151-8928-213de7942c7d
# ╠═ff687478-30a2-4d6e-9a62-859c61db6a34
# ╠═b2e4513a-76aa-4a8c-8ad4-490533789c74
# ╠═f5361e48-e613-4fed-8da3-5576feea776d
