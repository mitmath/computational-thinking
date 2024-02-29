### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> chapter = 3
#> video = "https://www.youtube.com/watch?v=cdIgr_2nUvI"
#> image = "https://user-images.githubusercontent.com/6933510/136199703-5edb4791-f9c0-4872-b0a7-7c9b1b6502d5.png"
#> section = 6
#> order = 6
#> title = "Snowball Earth and hysteresis"
#> layout = "layout.jlhtml"
#> youtube_id = "cdIgr_2nUvI"
#> description = ""
#> tags = ["lecture", "module3", "dynamics", "track_math", "track_climate", "hysteresis", "equilibrium", "climate", "modeling", "differential equation", "ODE", "plotting", "feedback", "runaway", "nonlinear", "snowball earth"]

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

# ╔═╡ a0b3813e-adab-11eb-2983-616cf2bb6f5e
begin
    using DifferentialEquations, Plots, PlutoUI, LinearAlgebra
end

# ╔═╡ ef8d6690-720d-4772-a41f-b260d306b5b2
TableOfContents(depth=4)

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
	scatter(sign, -5:.1:5, legend=false, m=:c, ms=3, size=(600, 300))
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
	plot( P1 ,P2,layout=(1, 2))
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
sol = solve(  ODEProblem( f, y₀, (0, 10.0), a ));

# ╔═╡ f8ee2373-6af0-4d81-98fb-23bde10198ef
function plotit(y₀, a)
	
	sol = solve(  ODEProblem( f, y₀, (0, 10.0), a ));
	p = plot( sol , legend=false, background_color_inside=:black , ylims=(-7, 7), lw=3, c=:red)
	
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
	sol = solve(  ODEProblem( f, y₀, (t, t+Δt), a ))
	p=plot(sol)
	annotate!(10,-5,text("a=",7))
	
	
	
	for i= 1:32
		a += .25
		t += Δt
		y₀ = sol(t)
		sol = solve(  ODEProblem( f, y₀, (t, t+Δt), a ))
		
		if -1≤a ≤1
		  p=plot!(sol,xlims=(0, t), legend=false, fillrange=-5,fillcolor=:gray,alpha=.5)
		else
		  p=plot!(sol,xlims=(0, t), legend=false)
		end
		
		if i%4==0
			annotate!(t,-5,text( round(a,digits=1), 7, :blue))
		end
		
	
	end
	for i= 1:32
		a -= .25
		t += Δt
		y₀ = sol(t)
		sol = solve(  ODEProblem( f, y₀, (t, t+Δt), a ))
		
		if -1≤a≤1
		  p=plot!(sol,xlims=(0, t), legend=false, fillrange=-5,fillcolor=:gray,alpha=.5)
		else
		  p=plot!(sol,xlims=(0, t), legend=false)
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
		T::Array{Float64,1}
	
		t::Array{Float64,1}
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
	EBM(T::Array{Float64,1}, t::Array{Float64,1}, Δt::Float64, CO2::Function;
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
	p_equil = plot(xlabel="year", ylabel="temperature [°C]", legend=:bottomright, xlims=(0, 205), ylims=(-60, 30.))
	
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
	plot!(p_equil, [200], [T_un], markershape=:diamond, label="Impossible alternate climate (unstable branch)", color=:lightgrey, markersize=8, markerstrokecolor=:white, alpha=1.)
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
	
	p_stability = plot(p1_stability, p2_stability, layout=(1, 2), size=(680, 300))
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

<script src="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.0/src/lite-yt-embed.js" integrity="sha256-sDRYYtDc+jNi2rrJPUS5kGxXXMlmnOSCq5ek5tYAk/M=" crossorigin="anonymous" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.0/src/lite-yt-embed.css" integrity="sha256-lv6SEl7Dhri7d86yiHCTuSWFb9CYROQFewxZ7Je0n5k=" crossorigin="anonymous">

<lite-youtube videoid=lYm_IyBHMUs params="modestbranding=1&rel=0"></lite-youtube>
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
	plot!(p, xlabel="year", ylabel="temperature [°C]", legend=:bottomright, xlims=(-5, 205), ylims=(-60, 30.))
	
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DifferentialEquations = "~7.4.0"
Plots = "~1.33.0"
PlutoUI = "~0.7.48"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "65f29cc5caf574b71d028732c605e65d9365d956"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["ArrayInterfaceCore", "Compat", "IfElse", "LinearAlgebra", "Static"]
git-tree-sha1 = "d6173480145eb632d6571c148d94b9d3d773820e"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "6.0.23"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "732cddf5c7a3d4e7d4829012042221a724a30674"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.24"

[[deps.ArrayInterfaceGPUArrays]]
deps = ["Adapt", "ArrayInterfaceCore", "GPUArraysCore", "LinearAlgebra"]
git-tree-sha1 = "fc114f550b93d4c79632c2ada2924635aabfa5ed"
uuid = "6ba088a2-8465-4c0a-af30-387133b534db"
version = "0.2.2"

[[deps.ArrayInterfaceOffsetArrays]]
deps = ["ArrayInterface", "OffsetArrays", "Static"]
git-tree-sha1 = "c49f6bad95a30defff7c637731f00934c7289c50"
uuid = "015c0d05-e682-4f19-8f0a-679ce4c54826"
version = "0.1.6"

[[deps.ArrayInterfaceStaticArrays]]
deps = ["Adapt", "ArrayInterface", "ArrayInterfaceStaticArraysCore", "LinearAlgebra", "Static", "StaticArrays"]
git-tree-sha1 = "efb000a9f643f018d5154e56814e338b5746c560"
uuid = "b0d46f97-bff5-4637-a19a-dd75974142cd"
version = "0.1.4"

[[deps.ArrayInterfaceStaticArraysCore]]
deps = ["Adapt", "ArrayInterfaceCore", "LinearAlgebra", "StaticArraysCore"]
git-tree-sha1 = "93c8ba53d8d26e124a5a8d4ec914c3a16e6a0970"
uuid = "dd5226c6-a4d4-4bc7-8575-46859f9c95b9"
version = "0.1.3"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9a8017694c92ca097b23b3b43806be560af4c2ce"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "0.8.12"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "d37d493a1fc680257f424e656da06f4704c4444b"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.17.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "eaee37f76339077f86679787a71990c4e465477f"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.4"

[[deps.BoundaryValueDiffEq]]
deps = ["BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase", "SparseArrays"]
git-tree-sha1 = "2f80b70bd3ddd9aa3ec2d77604c1121bd115650e"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "2.9.0"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "Static"]
git-tree-sha1 = "9bdd5aceea9fa109073ace6b430a24839d79315e"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.27"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "5522c338564580adf5d58d91e43a55db0fa5fb39"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.10"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CommonSolve]]
git-tree-sha1 = "9441451ee712d1aec22edad62db1a9af3dc8d852"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.3"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "3ca828fe1b75fa84b021a7860bd039eaea84d2f2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.3.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fb21ddd70a051d882a1686a5a550990bbe371a95"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.4.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DataAPI]]
git-tree-sha1 = "46d2680e618f8abd007bce0c3026cb0c4a8f2032"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.12.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "UnPack"]
git-tree-sha1 = "b8aab9f89afbef5b7f50ea5030ccc1629e2a18c2"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.38.3"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffEqBase]]
deps = ["ArrayInterfaceCore", "ChainRulesCore", "DataStructures", "Distributions", "DocStringExtensions", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "MuladdMacro", "NonlinearSolve", "Parameters", "Printf", "RecursiveArrayTools", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "Static", "StaticArrays", "Statistics", "Tricks", "ZygoteRules"]
git-tree-sha1 = "1691af09e21555641fe762b28bda3dd927256765"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.105.2"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "LinearAlgebra", "Markdown", "NLsolve", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "485503846a90b59f3b79b39c2d818496bf50d197"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.24.3"

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "GPUArraysCore", "LinearAlgebra", "Markdown", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "ResettableStacks", "SciMLBase", "StaticArrays", "Statistics"]
git-tree-sha1 = "20db92edf39005ee64b5fbd374d6bc78cce25ad1"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.14.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "8b7a4d23e22f5d44883671da70865ca98f2ebf9d"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.12.0"

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqNoiseProcess", "JumpProcesses", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "ae4a1b8a789c1d6ef2c6f0165f3fa2c79b5eb036"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.4.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "04db820ebcfc1e053bd8cbb8d8bccf0ff3ead3f7"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.76"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EnumX]]
git-tree-sha1 = "e5333cd1e1c713ee21d07b6ed8b0d8853fabe650"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.3"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceGPUArrays", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "9837d3f3a904c7a7ab9337759c0093d3abea1d81"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.22.0"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "LinearAlgebra", "Polyester", "Static", "StrideArraysCore"]
git-tree-sha1 = "21cdeff41e5a1822c2acd7fc7934c5f450588e00"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.2.1"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastLapackInterface]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "14a6f7a21125f715d935fe8f83560ee833f7d79d"
uuid = "29a986be-02c6-4525-aec4-84b980013641"
version = "1.2.7"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "802bfc139833d2ba893dd9e62ba1767c88d708ae"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.5"

[[deps.FiniteDiff]]
deps = ["ArrayInterfaceCore", "LinearAlgebra", "Requires", "Setfield", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "5a2cff9b6b77b33b89f3d97a4d367747adce647e"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.15.0"

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

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "187198a4ed8ccd7b5d99c41b69c679269ea2b2d4"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.32"

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

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "a5e6e7f12607e90d71b09e6ce2c965e41b337968"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.1"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "6872f5ec8fd1a38880f027a26739d42dcda6691f"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.2"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "cf0a9940f250dc3cb6cc6c6821b4bf8a4286cf9c"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.66.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "ba2d094a88b6b287bd25cfa86f301e7693ffae2f"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.7.4"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "a97d47758e933cd5fe5ea181d178936a9fc60427"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.5.1"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "d076c069de9afda45e379f4be46f1f54bdf37ca9"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.9"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

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

[[deps.JumpProcesses]]
deps = ["ArrayInterfaceCore", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "535605173bbf752b37b80440d6baaad28db0fcea"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.2.2"

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "764164ed65c30738750965d55652db9c94c59bfe"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.4.0"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "92256444f81fb094ff5aa742ed10835a621aef75"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.8.4"

[[deps.KrylovKit]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "49b0c1dd5c292870577b8f58c51072bd558febb9"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.5.4"

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
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "ArrayInterfaceOffsetArrays", "ArrayInterfaceStaticArrays", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "73e2e40eb02d6ccd191a8a9f8cee20db8d5df010"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.11"

[[deps.LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

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
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterfaceCore", "DocStringExtensions", "FastLapackInterface", "GPUArraysCore", "IterativeSolvers", "KLU", "Krylov", "KrylovKit", "LinearAlgebra", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "SnoopPrecompile", "SparseArrays", "SuiteSparse", "UnPack"]
git-tree-sha1 = "9dc30911bb8697a489c298339536d5234d54ba96"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "1.27.1"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "ArrayInterfaceOffsetArrays", "ArrayInterfaceStaticArrays", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SIMDTypes", "SLEEFPirates", "SnoopPrecompile", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "9f6030ca92d1a816e931abb657219c9fc4991a96"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.136"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

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
version = "2022.2.1"

[[deps.MuladdMacro]]
git-tree-sha1 = "cac9cc5499c25554cba55cd3c30543cff5ca4fab"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.4"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.NonlinearSolve]]
deps = ["ArrayInterfaceCore", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "a754a21521c0ab48d37f44bbac1eefd1387bdcfc"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.22"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "f71d8950b724e9ff6110fc948dff5a329f901d64"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.8"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "3c3c4a401d267b04942545b1e964a20279587fd7"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "b9fe76d1a39807fdcf790b991981a922de0c3050"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.3"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.OrdinaryDiffEq]]
deps = ["Adapt", "ArrayInterface", "ArrayInterfaceCore", "ArrayInterfaceGPUArrays", "ArrayInterfaceStaticArrays", "ArrayInterfaceStaticArraysCore", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "NonlinearSolve", "Polyester", "PreallocationTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SnoopPrecompile", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "88b3bc390fe76e559bef97b6abe55e8d3a440a56"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.29.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "6c01a9b494f6d2a9fc180a08b182fcb06f0958a0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "6062b3b25ad3c58e817df0747fc51518b9110e5f"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.33.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

[[deps.PoissonRandom]]
deps = ["Random"]
git-tree-sha1 = "45f9da1ceee5078267eb273d065e8aa2f2515790"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.3"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "cb2ede4b9cc432c1cba4d4452a62ae1d2a4141bb"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.6.16"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "b42fb2292fbbaed36f25d33a15c8cc0b4f287fcf"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.10"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ForwardDiff"]
git-tree-sha1 = "3953d18698157e1d27a51678c89c88d53e071a42"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.4"

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
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "97aa253e65b784fd13e83774cadc95b38011d734"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.6.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "7a1a306b72cfa60634f03a911405f4e64d1b718b"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.0"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "d12e612bba40d189cead6ff857ddb67bd2e6a387"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "80aaeb2ec4d67f6c48b7cb1144f96455192655cf"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.8"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceStaticArraysCore", "ChainRulesCore", "DocStringExtensions", "FillArrays", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "StaticArraysCore", "Statistics", "Tables", "ZygoteRules"]
git-tree-sha1 = "fe25988dce8dd3b763cf39d0ca39b09db3571ff7"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.32.1"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "SnoopPrecompile", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "0a2dfb3358fcde3676beb75405e782faa8c9aded"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "22c5201127d7b243b9ee1de3b43c408879dff60f"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.3.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "50314d2ef65fce648975a8e80ae6d8409ebbf835"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.5"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "dd4195d308df24f33fb10dde7c22103ba88887fa"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.1"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "938c9ecffb28338a6b8b970bda0f3806a65e7906"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.36"

[[deps.SciMLBase]]
deps = ["ArrayInterfaceCore", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "Preferences", "RecipesBase", "RecursiveArrayTools", "RuntimeGeneratedFunctions", "StaticArraysCore", "Statistics", "Tables"]
git-tree-sha1 = "12e532838db2f2a435a84ab7c01003ceb45baa53"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.67.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

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

[[deps.SparseDiffTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceStaticArrays", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays", "VertexSafeGraphs"]
git-tree-sha1 = "472216c5af9f2f1fce02b760651fe024c75187bd"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "1.29.0"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "de4f0a4f049a4c87e4948c04acff37baf1be01a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.7.7"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "f86b3a049e5d05227b10e15dbb315c5b90f14988"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.9"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5783b877201a82fc0014cbf381e7e6eb130473a4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.0.1"

[[deps.SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "f4492f790434f405139eb3a291fdbb45997857c6"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.9.0"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "JumpProcesses", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "412bc8d2daffe21a3a340dc3111c69194e089fc4"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.55.0"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "ac730bd978bf35f9fe45daa0bd1f51e493e97eb4"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.3.15"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+0"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "Reexport", "SnoopPrecompile", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "fc2fb8af952ffd007dfda02c08eaf9abb6081652"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.10.3"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "04777432d74ec5bc91ca047c9e0e0fd7f81acdb6"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.1+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "f8629df51cab659d70d2e5618a430b4d3f37f2c3"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.0"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "SnoopPrecompile", "Static", "VectorizationBase"]
git-tree-sha1 = "fdddcf6b2c7751cd97de69c18157aacc18fbc660"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.14"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "ba9d398034a2ba78059391492730889c6e45cf15"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.54"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

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
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

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
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

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
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

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
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
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
# ╟─eb0307f1-c828-41f9-bc49-2aedd5b588e1
# ╠═ada47602-2cf6-4ef5-b1ba-0b1c6f81ad91
# ╟─5ebe385f-3542-4674-b419-fb54519aa945
# ╟─72e822ef-0256-4612-8b6d-654ba6f6a83f
# ╟─10815b22-b920-4cb7-a078-4d5ef457ebf2
# ╟─984f0489-7430-43b9-8926-9d7c32e7da63
# ╟─bf0dd94d-e861-478a-9bb0-d34d17405fcc
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
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
