### A Pluto.jl notebook ###
# v0.12.10

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

# ╔═╡ e9ad66b0-0d6b-11eb-26c0-27413c19dd32
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		"Plots",
		"PlutoUI",
		"LaTeXStrings",
	])
	using LaTeXStrings
	using Plots
	using PlutoUI
	
	md"#### Package dependencies"
end

# ╔═╡ 05031b60-1df4-11eb-2b61-956e526b3d4a
md"## Lecture 21: Snowball Earth, the ice-albedo feedback, and multiple equilibria"

# ╔═╡ a05bd3ce-1e06-11eb-1af2-65886cab38ef
md"![](https://static01.nyt.com/images/2019/12/17/science/02TB-SNOWBALLEARTH1/02TB-SNOWBALLEARTH1-superJumbo-v2.jpg?quality=90&auto=webp)
[Source (New York Times)](https://static01.nyt.com/images/2019/12/17/science/02TB-SNOWBALLEARTH1/02TB-SNOWBALLEARTH1-superJumbo-v2.jpg?quality=90&auto=webp)
"

# ╔═╡ a6b6ea46-2519-11eb-1134-8994582c5546
md"""
### 0) Review of Lecture 20

Recall from [Lecture 20 (Part I)](https://www.youtube.com/watch?v=Gi4ZZVS2GLA&t=15s) that the the **zero-dimensional energy balance equation** is

\begin{gather}
\color{brown}{C \frac{dT}{dt}}
\; \color{black}{=} \; \color{orange}{\frac{(1 - α)S}{4}}
\; \color{black}{-} \; \color{blue}{(A - BT)}
\; \color{black}{+} \; \color{grey}{a \ln \left( \frac{[\text{CO}₂]}{[\text{CO}₂]_{\text{PI}}} \right)},
\end{gather}
"""

# ╔═╡ 9d3a6312-2519-11eb-3550-89ea034bf119
html"""<img src="https://raw.githubusercontent.com/hdrake/hdrake.github.io/master/figures/planetary_energy_balance.png" height=230>"""

# ╔═╡ c50b6b24-2506-11eb-00e1-0f183526ed4e
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

# ╔═╡ 4f5f3038-1e06-11eb-16a2-b11035701fb8
md"""
### 1) Background: Snowball Earth

Geological evidence shows that the Neoproterozoic Era (550 to 1000 million years ago) is marked by two global glaciation events, in which Earth's surface was covered in ice and snow from the Equator to the poles (see review by [Pierrehumbert et al. 2011](https://www.annualreviews.org/doi/full/10.1146/annurev-earth-040809-152447)).
"""

# ╔═╡ 68364804-2517-11eb-00de-d1655dd7754b
html"""

<img src="https://news.cnrs.fr/sites/default/files/styles/asset_image_full/public/assets/images/frise_earths_glaciations_72dpi.jpg?itok=MgKrHlIV" height=400>
"""

# ╔═╡ 9c118f9a-1df0-11eb-22dd-b14428994076
html"""
<img src="https://upload.wikimedia.org/wikipedia/commons/d/df/Ice_albedo_feedback.jpg" height=350>
"""

# ╔═╡ 38346e6a-0d98-11eb-280b-f79787a3c788
md"""
We can represent the ice-albedo feedback crudely in our energy balance model by allowing the albedo to depend on temperature:

$\alpha(T) = \begin{cases}
\alpha_{i} & \mbox{if }\;\; T \leq -10\text{°C} &\text{(completely frozen)}\\
\alpha_{i} + (\alpha_{0}-\alpha_{i})\frac{T + 10}{20} & \mbox{if }\;\; -10\text{°C} \leq T \leq 10\text{°C} &\text{(partially frozen)}\\
\alpha_{0} &\mbox{if }\;\; T \geq 10\text{°C} &\text{(no ice)}
\end{cases}$
"""

# ╔═╡ 816f1d96-2508-11eb-0873-c3b564a31dea
md"""
##### 1.2) Adding the ice-albedo feedback to our simple climate model

First, we program albedo as a function of temperature.
"""

# ╔═╡ a8dcc0fc-1df8-11eb-21fd-1fdebe5dabfc
md"""
To add this function into our energy balance model from [Lecture 20 (Part I)](https://www.youtube.com/watch?v=Gi4ZZVS2GLA&t=15s) (which we've copied into the cell below), all we have to do is overwrite the definition of the `timestep!` method to specify that the temperature-dependent albedo should be updated based on the current state:
"""

# ╔═╡ 96ed2f9a-1e29-11eb-09f4-23df52152b2f
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

# ╔═╡ 016c1074-1df4-11eb-2da8-578e25d9456b
md"""##### 1.1) The ice-albedo feedback

In Lecture 20, we used a **constant** value $α =$ $(Model.hist.α) for Earth's planetary albedo, which is a reasonable thing to do for small climate variations relative to the present (such as the difference between the present-day and preindustrial climates). In the case of large variations, however, this approximation is not very reliable.

While oceans are dark and absorbant, $α_{ocean} \approx 0.05$, ice and snow are bright and reflective: $\alpha_{ice,\,snow} \approx 0.5$ to $0.9$. Thus, if much of the ocean's surface freezes over, we expect Earth's albedo to rise dramatically, causing more sunlight to be reflected to space, which in turn causes even more cooling and more of the ocean to freeze, etc. This *non-linear positive feedback effect* is referred to as the **ice-albedo feedback** (see illustration below).
"""

# ╔═╡ 262fc3c6-1df2-11eb-332d-c1c9561b3710
function α(T; α0=Model.α, αi=0.5, ΔT=10.)
	if T < -ΔT
		return αi
	elseif -ΔT <= T < ΔT
		return αi + (α0-αi)*(T+ΔT)/(2ΔT)
	elseif T >= ΔT
		return α0
	end
end

# ╔═╡ f7761e40-1e23-11eb-2741-cfebfaf434ec
begin
	T_example = -20.:1.:20.
	plot(size=(500, 230), ylims=(0.2, 0.6))
	plot!([-20, -10], [0.2, 0.2], fillrange=[0.6, 0.6], color=:lightblue, alpha=0.2, label=nothing)
	plot!([10, 20], [0.2, 0.2], fillrange=[0.6, 0.6], color=:red, alpha=0.12, label=nothing)
	plot!(T_example, α.(T_example), lw=3., label="α(T)", color=:black)
	plot!(ylabel="albedo α\n(planetary reflectivity)", xlabel="Temperature [°C]")
	annotate!(-15.5, 0.252, text("completely\nfrozen", 10, :darkblue))
	annotate!(15.5, 0.252, text("no ice", 10, :darkred))
	annotate!(-0.3, 0.252, text("partially frozen", 10, :darkgrey))
end

# ╔═╡ 872c8f2a-1df1-11eb-3cfc-3dd568926442
function Model.timestep!(ebm)
	ebm.α = α(ebm.T[end]) # Added this line
	append!(ebm.T, ebm.T[end] + ebm.Δt*Model.tendency(ebm));
	append!(ebm.t, ebm.t[end] + ebm.Δt);
end

# ╔═╡ 13f42334-1e27-11eb-11a0-f51af4574a6b
md"""### 2) Multiple Equilibria
**OR: the existence of "alternate Earths"**

Human civilization flourished over the last several thousand years in part because Earth's global climate has been remarkably stable and forgiving. The preindustrial combination of natural greenhouse effect and incoming solar radiation yielded temperatures between the freezing and boiling points of water across most of the planet, allowing ecoystems based on liquid water to thrive.

The climate system, however, is rife with non-linear effects like the **ice-albedo effect**, which reveal just how fragile our habitable planet is and just how unique our stable pre-industrial climate was.

We learned in Lecture 20 that in response to temperature fluctuations, *net-negative feedbacks* act to restore Earth's temperature back towards a single equilibrium state in which absorbed solar radiation is balanced by outgoing thermal radiation. Here, we explore how *non-linear positive feedbacks* can temporarily result in a *net-positive feedback* and modify Earth's state space.
"""

# ╔═╡ 03292b48-2503-11eb-1514-5d1923d1d9a2
md"""
##### 2.1) Exploring the non-linear ice-albedo feedback

In [Lecture 20 (Part II)](https://www.youtube.com/watch?v=D3jpfeQCISU), we learned how introducing non-linear terms in *ordinary differential equations* can lead to complex state spaces that allow for multiple fixed points (e.g. for $\dot{x} = \mu + x^{2}$).

Let's explore how this plays out with the non-linear ice-albedo feedback by varying the initial condition $T_{0} \equiv T(t=0)$ and allowing the system to evolve for 200 years.
"""

# ╔═╡ 7a1b3138-2503-11eb-1165-c399836b66a7
begin
	T0_slider = @bind T0_interact Slider(-60.:0.25:30., default=24., show_value=true)
	md""" T₀ = $(T0_slider) °C"""
end

# ╔═╡ 1be1cce0-251b-11eb-35f7-e15741b0a712
begin
	ebm_interact = Model.EBM(Float64(T0_interact), 0., 1., Model.CO2_const)
	Model.run!(ebm_interact, 200)
end

# ╔═╡ a954ce70-2510-11eb-0d8c-c7b3f0fb3a06
md"We can get an overview of the behavior by drawing a set of these curves all on the same graph:"

# ╔═╡ 94852946-1e25-11eb-3425-210be17c23cd
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

# ╔═╡ c81b4956-2510-11eb-388c-87e93923e45a
md"We see that for T₀ ⪆  $(round(T_un, digits=2)) °C, all of the curves seem to converge on the T = 14°C *equilibrium* (or *fixed point*) that we saw in Lecture 20. Curves that start below this value warm up and while curves that start above this value will cool down. For T₀ ⪅ $(round(T_un, digits=2)) °C, however, the temperatures converge on a much colder equilibrium around T = -40°C. This is the **Snowball Earth** equilibrium. These two states are referred to as **stable equilibria** because even if the state gets temporarily pushed slightly away from its equilibrium, it will eventually converge right back to its equilibrium.

So what happens is T₀ ≈ $(round(T_un, digits=2)) °C? For some exact temperature near there, there is indeed an equilibrim state: if you start with that temperature you will stay there forever. However, if the temperature starts off even *one one-hundredth of a degree* above or below this exact value, we see that temperatures eventually converge to one of the other two equilibria. Thus, we call this intermediate equilibrium an **unstable equilibrium**, because any *infinitesimal* push away will cause it to careen away towards another state. 
"

# ╔═╡ 67f43076-1fa5-11eb-093f-75e406d054c6
md"""
##### 2.2) Radiative stability analysis

We can understand why our model has two stable equilibria and one unstable equilibrium by applying concepts from dynamical systems theory.

Recall that, with fixed CO₂ concentrations, our energy balance model differential equation can be expressed as:

$C\frac{d\,T}{d\,t} = \text{ASR}(T) - \text{OTR}(T),$

where now the Absorbed Solar Radiation (ASR) is also temperature dependent because the albedo $α(T)$ is.

In particular, by plotting the right-hand-side tendency terms as a function of the state variable $T$, we can plot a stability diagram for our system that tells us whether the planet will warm ($C \frac{d\,T}{d\,t} > 0$) or cool ($C \frac{d\,T}{d\,t} < 0$).
"""

# ╔═╡ 83819644-1fa5-11eb-0152-a9fab2f1730c
begin
	T_samples = -60.:1.:30.
	OTR = Model.outgoing_thermal_radiation.(T_samples)
	ASR = [Model.absorbed_solar_radiation.(α=α(T_sample)) for T_sample in T_samples]
	imbalance = ASR .- OTR
end;

# ╔═╡ e7b5ea16-1fa5-11eb-192e-8d50120c805b
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

# ╔═╡ 58e9b802-1e11-11eb-3479-0f7eb69b2c3a
md"
### 3) Transitioning to and from Snowball Earth

##### 3.1) Turning up the Sun

Over the entire history of the Earth, the Sun is thought to have brightened by about 40%."

# ╔═╡ 846618ea-1f7e-11eb-15e8-6176acb9278b
html"""
<img src="https://rainbow.ldeo.columbia.edu/courses/s4021/ec98/fys.gif" alt="Plot showing increasing solar luminosity over time" height=300>
"""

# ╔═╡ 873befc2-1f7e-11eb-16af-fba7f1e52eeb
md"In the Neoproterozoic (~700 million years ago), the Sun was 93% as bright as it is today, such that the incoming solar radiation was $S =$ 1272 W/m², Earth's average temperature plunged to $T = -50$°C, and Earth's ice-covered surface had a high albedo (reflectivity) of $α_{i} = 0.5$.

##### 3.2) Did the increasing brightness of the Sun melt the Snowball?
If we start out in the Neoproterozoic climate and all we do is increase solar insolation to today's value of $S =$ 1368 W/m², can we warm the planet up to the pre-industrial temperature of $T=14$°C?
"

# ╔═╡ d423b466-1e2a-11eb-3bb0-77f8151cdeea
md"""*Extend upper-limit of insolation* $(@bind extend_S CheckBox(default=false))"""

# ╔═╡ e2e08386-1e22-11eb-1e02-059ce290e80f
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

# ╔═╡ 9474f8e4-1f80-11eb-3c9e-c54e662cc29c
if extend_S
	md"""
	##### Abrupt climate transitions
	
	In this model, temperature variations are fairly smooth unless temperatures rise above -10°C or fall below 10°C, in which case the *ice-albedo positive feedback* kicks in and causes an **abrupt climate transition**. While this is just a simple hypothetical model, these kinds of abrupt climate transitions show up all the time in the paleoclimate record and in more realistic climate model simulations.

	![](https://www.pnas.org/content/pnas/115/52/13288/F1.large.jpg)
	
	This simulation teaches us that we should not take the stability of our climate for granted and that pushing our present climate outside of its historical regime of stability could trigger catastrophic abrupt climate transitions.
	"""
end

# ╔═╡ 6eca000c-1f81-11eb-068e-01d06c1beeb9
md"""
##### 3.3) If not the Sun, how did Snowball Earth melt?

The leading theory is that a slow but steady outgassing of CO₂ from volcanoes eventually caused a strong enough greenhouse gas effect to offset the cooling effect of the frozen surface's high albedo and raise temperatures above the melting point $-10$°C.
"""

# ╔═╡ c0c26cf0-1fa4-11eb-2a1b-77a9d03b9c25
html"""
<img src="https://hartm242.files.wordpress.com/2011/03/snowball-earth.jpg" width=680>
"""

# ╔═╡ bda79af4-1fa4-11eb-17da-21b452f43d92
md"""
In **Homework 9**, you will extend the above model to include the effect of CO₂ and determine how much CO2 would need to be added to the snowball for it to melt.
"""

# ╔═╡ da4df78a-1e2c-11eb-1d4c-69b86e196526
md"""### 4) Towards realistic climate modelling

In this simple model, the preindustrial climate of $T=14$°C is so warm that there is no ice anywhere on the planet. Indeed, the only two valid stable climates are one with *no ice* or one with *ice everywhere*. 

So how did Earth's preindustrial climate, which was relatively stable for thousands of years, have substantial ice caps at the poles?

"""

# ╔═╡ 908b50a2-1f76-11eb-0eb5-11318be6896b
md"""
**The "Aquaplanet", a simple three-dimensional ocean-world climate model**

An "Aquaplanet" is a three-dimensional global climate simulation of a hypothetical planet covered entirely by a single global Ocean. While this is of course very different from Earth, where 27% of the planet is covered in land, the "Aquaplanet" exhibits many of the same characteristics as Earth and is much more realistic than our zero-dimensional climate model above.

The video below shows that the Aquaplanet simulation exhibits a third equilibrium state, with a *mostly-liquid ocean but ice caps at the poles*, in addition to the two we found in our zero-dimensional model.

In **Homework 10**, you will build a simple two-dimensional version of the aqua-planet and explore its stability.
"""

# ╔═╡ 507342e0-1f76-11eb-098a-0973155652e2
html"""
<iframe width="700" height="394" src="https://www.youtube-nocookie.com/embed/lYm_IyBHMUs" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ d6a7e652-1f7d-11eb-2a5f-13ff13b9850c
md"""
## Appendix
"""

# ╔═╡ d2f4d882-1e2c-11eb-206b-b9ef5031a1bb
md"#### Pluto Magic"

# ╔═╡ 1dc709e2-1de8-11eb-28da-fd7469ec50c2
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

# ╔═╡ a212680c-1fa2-11eb-1fb9-f910081c562a
as_svg(x) = PlutoUI.Show(MIME"image/svg+xml"(), repr(MIME"image/svg+xml"(), x))

# ╔═╡ 8e28ef88-1f88-11eb-2d5d-bff2f59ea998
md"""
#### Bifurcation diagram helper functions
"""

# ╔═╡ 61fc91ec-1df8-11eb-13c1-098c113b46ec
function restart_ebm!(ebm)
	ebm.T = [ebm.T[end]]
	ebm.t = [ebm.t[1]]
end

# ╔═╡ 9b39df12-1df9-11eb-2eb0-f138980be597
function plot_trajectory!(p, x, y; lw=8)
	n = size(x,1)
	plot!(x, y, color="black", alpha=collect(1/n:1/n:1.), linewidth=collect(0.:lw/n:lw), label=nothing)
	plot!((x[end], y[end]), color="black", marker=:c, markersize=lw/2*1.2, label=nothing, markerstrokecolor=nothing, markerstrokewidth=0.)
	return p
end;

# ╔═╡ b5849000-0d68-11eb-3beb-c575e8d0ce8e
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

# ╔═╡ 364e1d2a-1f78-11eb-177b-9dcec4b6da38
md"""
For insolations $S$ between $(Smin) W/m² and $(Smax_limited) W/m², temperatures always remain below -10°C and the planet remains completely frozen. What if we extend the upper limit on insolation so that the Sun becomes bright enough to start melting ice?
"""

# ╔═╡ b4357da4-1f9e-11eb-2925-55cd6f37be22
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

# ╔═╡ 90ae18dc-0db8-11eb-0d73-c3b7efaef9b0
begin
	Sneo = Model.S*0.93
	Tneo = -48.
	md"**Initial conditions**"
end

# ╔═╡ 5ca7ac14-1df9-11eb-13f3-e5c86333ef83
begin
	if extend_S
		solarSlider = @bind S Slider(Smin:2.:Smax, default=Sneo);
		md""" $(Smin) W/m² $(solarSlider) $(Smax) W/m²"""
	else
		solarSlider = @bind S Slider(Smin:2.:Smax_limited, default=Sneo);
		md""" $(Smin) W/m² $(solarSlider) $(Smax_limited) W/m²"""
	end
end

# ╔═╡ 0bbcdf5a-0dba-11eb-3e81-2b075d4f67ea
begin
	md"""
	*Move the slider below to change the brightness of the Sun (solar insolation):* S = $(S) [W/m²]
	"""
end

# ╔═╡ 7765f834-0db0-11eb-2c46-ef65f4a1fd1d
begin
	ebm = Model.EBM(Tneo, 0., 5., Model.CO2_const)
	ebm.S = Sneo
	
	ntraj = 10
	Ttraj = repeat([NaN], ntraj)
	Straj = repeat([NaN], ntraj)
	
	md"**Data structures for storing trajectories of recent climates**"
end

# ╔═╡ 0f222836-0d6c-11eb-2ee8-45545da73cfd
begin
	S
	warming_mask = (1:size(Svec)[1]) .< size(Svec)./2
	p = plot(xlims=(Smin, Smax_limited), ylims=(-55, 75), title="Earth's solar insolation bifurcation diagram")
	plot!([Model.S, Model.S], [-55, 75], color=:yellow, alpha=0.3, lw=8, label="Pre-industrial / present insolation")
	if extend_S
		plot!(p, xlims=(Smin, Smax))
		if show_cold
			plot!(Svec[warming_mask], Tvec[warming_mask], color=:blue,lw=3., alpha=0.5, label="cool branch")
		end
		if show_warm
			plot!(Svec[.!warming_mask], Tvec[.!warming_mask], color="red", lw=3., alpha=0.5, label="warm branch")
		end
		if show_unstable
			plot!(S_unstable, T_unstable, color=:darkgray, lw=3., alpha=0.4, ls=:dash, label="unstable branch")
		end
	end
	plot!(legend=:topleft)
	plot!(xlabel="solar insolation S [W/m²]", ylabel="Global temperature T [°C]")
	plot!([Model.S], [Model.T0], markershape=:circle, label="Our preindustrial climate", color=:orange, markersize=8)
	plot!([Model.S], [-38.3], markershape=:circle, label="Alternate preindustrial climate", color=:aqua, markersize=8)
	plot!([Sneo], [Tneo], markershape=:circle, label="neoproterozoic (700 Mya)", color=:lightblue, markersize=8)
	plot_trajectory!(p, reverse(Straj), reverse(Ttraj), lw=9)
	
	plot!([Smin, Smax], [-60, -60], fillrange=[-10., -10.], fillalpha=0.3, c=:lightblue, label=nothing)
	annotate!(Smin+12, -19, text("completely\nfrozen", 10, :darkblue, :left))
	
	plot!([Smin, Smax], [10, 10], fillrange=[80., 80.], fillalpha=0.09, c=:red, lw=0., label=nothing)
	annotate!(Smin+12, 15, text("no ice", 10, :darkred, :left))
end |> as_svg

# ╔═╡ 477732c4-0daf-11eb-1422-cf0f55cd835b
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

# ╔═╡ f4b24d20-251a-11eb-04cf-fd69abdcfd54
function add_labels!(p)
	plot!(p, xlabel="year", ylabel="temperature [°C]", legend=:bottomright, xlims=(-5,205), ylims=(-60, 30.))
	
	plot!(p, [-5, 200], [-60, -60], fillrange=[-10., -10.], fillalpha=0.3, c=:lightblue, label=nothing)
	annotate!(120, -20, text("completely frozen", 10, :darkblue))
	
	plot!(p, [-5, 200], [10, 10], fillrange=[30., 30.], fillalpha=0.09, c=:red, lw=0., label=nothing)
	annotate!(p, 120, 25, text("no ice", 10, :darkred))
end

# ╔═╡ af197a52-2503-11eb-1da1-d36bab6ef2d3
begin
	p_interact = plot(ebm_interact.t, ebm_interact.T, label=nothing, lw=3)
	plot!([0.], [T0_interact], label=nothing, markersize=4, markershape=:circle)
	
	add_labels!(p_interact)
end |> as_svg

# ╔═╡ Cell order:
# ╟─05031b60-1df4-11eb-2b61-956e526b3d4a
# ╟─a05bd3ce-1e06-11eb-1af2-65886cab38ef
# ╟─a6b6ea46-2519-11eb-1134-8994582c5546
# ╟─9d3a6312-2519-11eb-3550-89ea034bf119
# ╟─c50b6b24-2506-11eb-00e1-0f183526ed4e
# ╟─4f5f3038-1e06-11eb-16a2-b11035701fb8
# ╟─68364804-2517-11eb-00de-d1655dd7754b
# ╟─016c1074-1df4-11eb-2da8-578e25d9456b
# ╟─9c118f9a-1df0-11eb-22dd-b14428994076
# ╟─38346e6a-0d98-11eb-280b-f79787a3c788
# ╟─f7761e40-1e23-11eb-2741-cfebfaf434ec
# ╟─816f1d96-2508-11eb-0873-c3b564a31dea
# ╠═262fc3c6-1df2-11eb-332d-c1c9561b3710
# ╟─a8dcc0fc-1df8-11eb-21fd-1fdebe5dabfc
# ╟─96ed2f9a-1e29-11eb-09f4-23df52152b2f
# ╠═872c8f2a-1df1-11eb-3cfc-3dd568926442
# ╟─13f42334-1e27-11eb-11a0-f51af4574a6b
# ╟─03292b48-2503-11eb-1514-5d1923d1d9a2
# ╟─7a1b3138-2503-11eb-1165-c399836b66a7
# ╠═1be1cce0-251b-11eb-35f7-e15741b0a712
# ╟─af197a52-2503-11eb-1da1-d36bab6ef2d3
# ╟─a954ce70-2510-11eb-0d8c-c7b3f0fb3a06
# ╟─94852946-1e25-11eb-3425-210be17c23cd
# ╟─c81b4956-2510-11eb-388c-87e93923e45a
# ╟─67f43076-1fa5-11eb-093f-75e406d054c6
# ╠═83819644-1fa5-11eb-0152-a9fab2f1730c
# ╟─e7b5ea16-1fa5-11eb-192e-8d50120c805b
# ╟─58e9b802-1e11-11eb-3479-0f7eb69b2c3a
# ╟─846618ea-1f7e-11eb-15e8-6176acb9278b
# ╟─873befc2-1f7e-11eb-16af-fba7f1e52eeb
# ╟─0bbcdf5a-0dba-11eb-3e81-2b075d4f67ea
# ╟─5ca7ac14-1df9-11eb-13f3-e5c86333ef83
# ╟─0f222836-0d6c-11eb-2ee8-45545da73cfd
# ╟─364e1d2a-1f78-11eb-177b-9dcec4b6da38
# ╟─d423b466-1e2a-11eb-3bb0-77f8151cdeea
# ╟─e2e08386-1e22-11eb-1e02-059ce290e80f
# ╟─9474f8e4-1f80-11eb-3c9e-c54e662cc29c
# ╟─6eca000c-1f81-11eb-068e-01d06c1beeb9
# ╟─c0c26cf0-1fa4-11eb-2a1b-77a9d03b9c25
# ╟─bda79af4-1fa4-11eb-17da-21b452f43d92
# ╟─da4df78a-1e2c-11eb-1d4c-69b86e196526
# ╟─908b50a2-1f76-11eb-0eb5-11318be6896b
# ╟─507342e0-1f76-11eb-098a-0973155652e2
# ╟─d6a7e652-1f7d-11eb-2a5f-13ff13b9850c
# ╟─d2f4d882-1e2c-11eb-206b-b9ef5031a1bb
# ╟─1dc709e2-1de8-11eb-28da-fd7469ec50c2
# ╟─a212680c-1fa2-11eb-1fb9-f910081c562a
# ╟─8e28ef88-1f88-11eb-2d5d-bff2f59ea998
# ╠═61fc91ec-1df8-11eb-13c1-098c113b46ec
# ╠═7765f834-0db0-11eb-2c46-ef65f4a1fd1d
# ╠═477732c4-0daf-11eb-1422-cf0f55cd835b
# ╠═9b39df12-1df9-11eb-2eb0-f138980be597
# ╠═b5849000-0d68-11eb-3beb-c575e8d0ce8e
# ╠═b4357da4-1f9e-11eb-2925-55cd6f37be22
# ╠═90ae18dc-0db8-11eb-0d73-c3b7efaef9b0
# ╟─f4b24d20-251a-11eb-04cf-fd69abdcfd54
# ╠═e9ad66b0-0d6b-11eb-26c0-27413c19dd32
