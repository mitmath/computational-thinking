### A Pluto.jl notebook ###
# v0.12.7

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

# ╔═╡ 5bf00f46-17b9-11eb-2625-bf3f33c273e2
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		"Plots",
		"PlutoUI",
		"LaTeXStrings",
		"CSV",
		"HTTP",
		"DataFrames",
	])
	using LaTeXStrings
	using Plots
	using PlutoUI
	using CSV, HTTP, DataFrames
end

# ╔═╡ 576a92f4-209a-11eb-36f8-0b27b3ededa7
md"""
# MIT 18.S191 – Introduction to Computational Thinking
"""

# ╔═╡ b01a3292-209a-11eb-2515-27f4a0227242
md"## Module 4: Climate Modelling

**Guest instructor: Henri Drake (PhD student in MIT Course 12 – EAPS)**

#### Outline

- Lecture 20: Introduction to climate science by building a simple climate model
- Lecture 21: Non-linear feedbacks and climate dynamics in a simple climate model
- Lecture 22: Introduction to advection and diffusion
- Lecture 23: Advection and diffusion of heat by ocean currents
- Lecture 24: Navier-Stokes, geophysical turbulence, and chaos
- Lecture 25: State-of-the-art climate modelling: the software engineering landscape

**Learning goals:**
- Applied mathematics
  - Dynamical systems theory: stability, hysteresis, and chaos
  - Numerical methods for solving time-dependent PDEs
  - Advection, diffusion, and Navier-Stokes equations

- Computer Science
  - Developing software that is modular, robust, and collaborative
  - Modelling complex systems using hierarchies
  - Analogies between image processing & PDEs

- Climate Science
  - Fundamental climate physics: radiation, albedo, and the greenhouse effect
  - Basics of climate modelling, parameterization, and dynamical coupling
  - Ocean currents and geophysical turbulence
"

# ╔═╡ e428f43e-13a1-11eb-15a5-2f677335bdd9
md"""
## Lecture 20: A "zero-dimensional" energy balance model of Earth's climate

#### 1) Background: climate physics

The simplest climate model can be conceptualized as:
\begin{align}
\text{\color{brown}{change in heat content}} = & + \text{\color{orange}{absorbed solar radiation (energy from the Sun's rays)}} \newline
& - \text{\color{blue}{outgoing thermal radiation (i.e. blackbody cooling to space)}}
\newline
& + \text{\color{grey}{human-caused greenhouse effect (trapped outgoing radiation)}}
\end{align}

where each of these is interpreted as an average over the entire globe (hence "zero-dimensional").
"""

# ╔═╡ ef62c780-13a1-11eb-3895-ff3abe0fdf5d
html"""<img src="https://raw.githubusercontent.com/hdrake/hdrake.github.io/master/figures/planetary_energy_balance.png" height=225>"""

# ╔═╡ c30dd85a-177f-11eb-3bbf-2bde4399ebbe
md"To make this simple conceptual model quantitative, we need a mathematical formulation for each of these four processes."

# ╔═╡ 619e8dde-13a2-11eb-1ac4-f1ce7f27b724
md"""
##### 1.1 Absorbed solar radiation

At Earth's orbital distance from the Sun, the power of the Sun's rays that intercept the Earth is equal to
"""

# ╔═╡ 98c68d84-1785-11eb-17c3-dda87383ebca
S = 1368; # solar insolation [W/m^2]  (energy per unit time per unit area)

# ╔═╡ 6095cb6a-1786-11eb-3a5d-31718db7ad94
md"A small fraction"

# ╔═╡ e9a6a1da-1785-11eb-23f2-e7334e12d7ee
α = 0.3; # albedo, or planetary reflectivity [unitless]

# ╔═╡ 99b9f320-1785-11eb-14a8-03c323a1254b
md"""
of this incoming solar radiation is reflected back out to space (by reflective surfaces like white clouds, snow, and ice), with the remaining fraction $(1-\alpha)$ being absorbed.

Since the incoming solar rays are all approximately parallel this far from the Sun, the cross-sectional area of the Earth that intercepts them is just a disc of area $\pi R^{2}$. Since all of the other terms we will consider act on the entire surface area $4\pi R^{2}$ of the spherical Earth, the absorbed solar radiation *per unit surface area* (averaged over the entire globe) is reduced by a factor of 4.

![](https://www.open.edu/openlearn/ocw/pluginfile.php/101161/mod_oucontent/oucontent/890/639dcd57/ce3f1c3a/s250_3_002i.jpg)

The absorbed solar radiation per unit area is thus

$\textcolor{orange}{\text{absorbed solar radiation} \equiv \frac{S(1-\alpha)}{4}}$
"""

# ╔═╡ 9fd1be88-179d-11eb-15c3-fb779a666f45
absorbed_solar_radiation(; α=α, S=S) = S*(1 - α)/4; # [W/m^2]

# ╔═╡ d5293b24-177f-11eb-1135-4f6395003637
md"""##### 1.2) Outgoing thermal radiation

The outgoing thermal radiation term $\mathcal{G}(T)$ (or "blackbody cooling to space") represents the combined effects of *negative feedbacks that dampen warming*, such as **blackbody radiation**, and *positive feedbacks that amplify warming*, such as the **water vapor feedback**.

Since these physics are too complicated to deal with here, we *linearize* the model by considering only the first term of a Taylor Series expansion

$\mathcal{G}(T) \approx \mathcal{G}(T_{0}) + \mathcal{G}'(T_{0})(T-T_{0}) = \mathcal{G}'(T_{0})T + (\mathcal{G}(T_{0}) - \mathcal{G}'(T_{0})(T_{0}))$

around the pre-industrial equilibrium temperature
"""

# ╔═╡ 673a839a-1785-11eb-3382-6da7a94c917b
T0 = 14.; # preindustrial temperature [°C]

# ╔═╡ a5a56754-1786-11eb-157a-f5ac8c75044f
md"""To simplify the expression, we define:

\begin{align}
& A \equiv \mathcal{G}(T₀) - \mathcal{G}'(T₀)(T₀) & \\\\
& B \equiv -\mathcal{G}'(T₀) & \text{(the climate feedback parameter)},
\end{align}

which gives

$\color{blue}{\text{outgoing thermal radiation} \equiv \mathcal{G}(T) \approx A - BT}$
"""

# ╔═╡ 83421922-179d-11eb-0658-fd87f7adaed9
outgoing_thermal_radiation(T; A=A, B=B) = A - B*T;

# ╔═╡ 8b076962-179d-11eb-2c44-b5bf340e92ab
md"""The value of the *climate feedback parameter* used here,"""

# ╔═╡ bd01be7a-1786-11eb-047d-cbfaa63f93a2
B = -1.3; # climate feedback parameter [W/m^2/°C],

# ╔═╡ d6fb4d64-1786-11eb-3859-9dc874b99e17
md"""comes from a bottom-up estimate based on the best understanding of the various climate feedbacks (read more [here](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwikwbfrm9LsAhVjhuAKHQhZCm8QFjAEegQIAhAC&url=https%3A%2F%2Fclimateextremes.org.au%2Fwp-content%2Fuploads%2F2020%2F07%2FWCRP_ECS_Final_manuscript_2019RG000678R_FINAL_200720.pdf&usg=AOvVaw0hWIM3t4kJTovxoeobcRIN)).

**Note:** Since $B < 0$, this tells us that the overall climate feedback is *negative* (i.e. stabilizing). Positivefeedbacks cause $B$ to become less negative, reducing the efficiency with which Earth cools itself by radiating thermal energy to space, and thus amplifying warming. 

The value of $A$ is given by the definition of a preindustrial equilibrium, i.e. the fact that before human influence, Earth's energy budget was perfectly balanced:

$\text{\color{orange}{absorbed solar radiation}} = \text{\color{blue}{outgoing thermal radiation}}$

or

$\color{orange}{\frac{S(1-\alpha)}{4}} \;\color{black}{=}\; \color{blue}{A - BT_{0}}$

By rearanging this equation, we find that the value of $A$ is given by
"""

# ╔═╡ f258767c-1786-11eb-0a9b-ad9f0094a8a0
A = S*(1. - α)/4 + B*T0; # [W/m^2].

# ╔═╡ eaceee7e-177f-11eb-3d94-778732ca8768
md"""
##### 1.3) Human-caused greenhouse effect

Empirically, the greenhouse effect is known to be a logarithmic function of gaseous carbon dioxide (CO₂) concentrations

$\color{grey}{\text{human-caused greenhouse effect}\; = a \ln \left( \frac{[\text{CO}₂]}{[\text{CO}₂]_{\text{PI}}} \right),}$
"""

# ╔═╡ 19c127ce-179e-11eb-2500-bd1680754ba0
greenhouse_effect(CO2; a=a, CO2_PI=CO2_PI) = a*log(CO2/CO2_PI);

# ╔═╡ 14c4c8ac-179e-11eb-3c26-e51c3191532d
md"where"

# ╔═╡ 1be33ebe-1787-11eb-02f5-43802a30be01
a = 5.0; # CO2 forcing coefficient [W/m^2]

# ╔═╡ 91b1ff3a-179c-11eb-3fc1-2d991840a4a1
CO2_PI = 280.; # preindustrial CO2 concentration [parts per million; ppm];

# ╔═╡ 6cd7db88-2293-11eb-20a2-69fc5c87b82f
begin
	CO2_present = 420.
	CO2_range = 280*(2 .^(range(-1, stop=3,length=100)))
	plot(CO2_range, greenhouse_effect.(CO2_range), lw=2.5, label=nothing, color=:black)
	plot!([CO2_PI], [greenhouse_effect(CO2_PI)], marker=:., ms=6, linecolor=:white,
		color=:blue, lw=0, label="pre-industrial (PI)")
	plot!([CO2_present], [greenhouse_effect(CO2_present)], marker=:., ms=6, color=:red, linecolor=:white, lw=0, label="present day (2020)")
	plot!(xticks=[280, 280*2, 280*4, 280*8], legend=:bottomright, size=(400, 250))
	plot!(ylabel="Radiative forcing [W/m²]", xlabel="CO₂ concentration [ppm]")
end

# ╔═╡ d42ff276-177f-11eb-32e5-b5ce2c4cd42f
md"""
##### 1.4) Change in heat content

The heat content $CT$ is determined by the temperature $T$ (in Kelvin) and the heat capacity of the climate system. While we are interested in the temperature of the atmosphere, which has a very small heat capacity, its heat is closely coupled with that of the upper ocean, which has a much larger heat capacity of 
"""

# ╔═╡ 125df9ba-1787-11eb-1953-13449970b9f9
C = 51.; # atmosphere and upper-ocean heat capacity [J/m^2/°C]

# ╔═╡ fe1844d2-1787-11eb-067f-e9664c17df27
md"""
The *change in heat content over time* is thus simply given by $\frac{d(CT)}{dt}$. Since the heat capacity of sea water hardly changes with temperature, we can rewrite this in terms of the change in temperature with time as:

$\color{brown}{\text{change in heat content } =\; C \frac{dT}{dt}}$
"""

# ╔═╡ fbf1ba3e-0d65-11eb-20a7-55402d46d4ed
md"""

##### 1.5) "zero-dimensional" climate model equation

Combining all of these subcomponent models, we write the governing equation of the "zero-dimensional" energy balance climate model as the **Ordinary Differential Equation (ODE)**:

\begin{gather}
\color{brown}{C \frac{dT}{dt}}
\; \color{black}{=} \; \color{orange}{\frac{(1 - α)S}{4}}
\; \color{black}{-} \; \color{blue}{(A - BT)}
\; \color{black}{+} \; \color{grey}{a \ln \left( \frac{[\text{CO}₂]}{[\text{CO}₂]_{\text{PI}}} \right)},
\end{gather}

which determines the time evolution of Earth's globally-averaged surface temperature.
"""

# ╔═╡ 8d6d7fc6-1788-11eb-234d-59f27a1b79d2
md"""
#### 2) Numerical solution method and data structures

##### 2.1) Discretization

The energy balance model equation above can be **discretized** in time as

$C \frac{T(t+Δt) - T(t)}{\Delta t} = \frac{\left( 1-\alpha \right) S}{4} - (A - BT(t)) + a \ln \left( \frac{[\text{CO}₂](t)}{[\text{CO}₂]_{\text{PI}}} \right).$

Our **finite difference equation**, which results from a first-order truncation of the Taylor series expansion, approximates the exact **ordinary differential equation** above in the limit that $\Delta t \rightarrow 0$. In practice, we can keep decreasing $\Delta t$ until the solution converges within a tolerable error.

Hereafter, we use the subscript $n$ to denote the $n$-th timestep, where $T_{n+1} \equiv T(t_{n+1})$ denotes the temperature at the next timestep $t_{n+1} = t_{n} + \Delta t$.

By re-arranging the equation, we can solve for the temperature at the next timestep $n+1$ based on the known temperature at the present timestep $n$:

$T_{n+1} = T_{n} + \frac{\Delta t}{C} \left[ \frac{ \left( 1-\alpha \right) S}{4} - (A - BT_{n}) + a \ln \left( \frac{[\text{CO}₂]_{n}}{[\text{CO}₂]_{\text{PI}}} \right) \right]$

##### 2.2) Timestepping

More generally, we recognize this equation to be of the form:

$T_{n+1} = T_{n} + \Delta t * \text{tendency}(T_{n} \,; ...),$

which we implement below (don't forget to update the time as well, $t_{n+1} = t_{n} + \Delta t$), which takes in an instance of our anticipated energy balance model `EBM` type as its only argument.
"""

# ╔═╡ 5a51fac0-179c-11eb-0b65-859cc9232a3a
md"where the `tendency(ebm)` is the sum of the various physical forcing mechanisms and is a function of the present temperature $T_{n}$, as well as a number of other parameters."

# ╔═╡ 35dfe0d2-17b0-11eb-20dc-7d7f4c5568ae
tendency(ebm) = (1. /ebm.C) * (
	+ absorbed_solar_radiation(α=ebm.α, S=ebm.S)
	- outgoing_thermal_radiation(ebm.T[end], A=ebm.A, B=ebm.B)
	+ greenhouse_effect(ebm.CO2(ebm.t[end]), a=ebm.a, CO2_PI=ebm.CO2_PI)
);

# ╔═╡ 27aa62a0-17b0-11eb-2029-a3c797e769eb
function timestep!(ebm)
	append!(ebm.T, ebm.T[end] + ebm.Δt*tendency(ebm));
	append!(ebm.t, ebm.t[end] + ebm.Δt);
end;

# ╔═╡ 3a549f2a-17b0-11eb-1d80-4bc2abc3dba6
md"
##### 2.3) Data structure

We implement our custom `EBM` type as use a `mutable struct` because we want to be able to modify the model's parameters in between different simulations, or even as time goes on in a single simulation.

To save ourselves some time later on, we also make use of **multiple dispatch** to define methods of the EBM that take on default values for many of the parameters.
"

# ╔═╡ d0bf9b06-179c-11eb-0f1c-2fd535cb0e57
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

# ╔═╡ e81fc2f8-17b0-11eb-20f8-2f4e890dc867
md"
##### 2.4) Running simulations of the energy balance model
Let's define a function that runs an `EBM` simulation by timestepping forward until a given `end_year`."

# ╔═╡ e5902d52-17b0-11eb-1ba3-4be6c2bbc90f
begin
	function run!(ebm::EBM, end_year::Real)
		while ebm.t[end] < end_year
			timestep!(ebm)
		end
	end;
	
	run!(ebm) = run!(ebm, 200.) # run for 200 years by default
end

# ╔═╡ eba4ba20-22b2-11eb-3989-dde4f9c26702
md"For example, let us consider the case where CO₂ emissions increase by 1% year-over-year from the preindustrial value [CO₂ ] = $(CO2_PI) ppm, starting at T=T₀=14°C in year t=0 and with a timestep Δt = 1 year."

# ╔═╡ effbbd1c-22b2-11eb-2fe2-5df555bf5f2c
begin
	CO2_test(t) = CO2_PI .* (1 + 1/100).^t
	ebm_test = EBM(T0, 0., 1., CO2_test)
end

# ╔═╡ 073d8ba6-22b4-11eb-329f-c5d0c2a28562
md"*Run the cell below to see how the array of temperatures is appended with the temperature of the next timestep:*"

# ╔═╡ 84d10370-22b3-11eb-0acd-07e5b454c481
begin
	timestep!(ebm_test)
	ebm_test.T
end

# ╔═╡ 38346e6a-0d98-11eb-280b-f79787a3c788
md"""
#### 3) Energy balance model applications

##### 3.1) Why was Earth's preindustrial climate so stable?

Let us consider the simple case where CO₂ concentrations remain at their pre-industrial temperatures.
"""

# ╔═╡ e5b20bda-17a0-11eb-38de-6d4d72b4e56d
CO2_const(t) = CO2_PI; # constant CO2 concentrations

# ╔═╡ d85f2a90-17b0-11eb-007b-d39c79660dca
md"What happens if we perturb the pre-industrial temepratures away from their equilibrium value of T₀ = $(T0) °C?"

# ╔═╡ cadbddec-179e-11eb-3a1e-3502e2534937
begin	
	p_equil = plot(xlabel="year", ylabel="temperature [°C]")
	for T0_sample in (0.:2.:28.)
		ebm = EBM(T0_sample, 0., 1., CO2_const)
		run!(ebm, 200)
		
		plot!(p_equil, ebm.t, ebm.T, label=nothing, )
	end
	p_equil
end

# ╔═╡ e967605a-1de9-11eb-39d4-831533aed676
md"This figure shows that, no matter where we start out, the overall negative feedbacks ($B<0$) restore the temperature to the preindustrial equilibrum value of T₀ = $(T0) °C, over an exponential timescale of about 100 years."

# ╔═╡ 0c393822-1789-11eb-30b3-7ff90191d89e
md"""
##### 3.2) Historical global warming fueled by greenhouse gas emissions

Human greenhouse gas emissions have fundamentally altered Earth's energy balance, moving us away from the stable preindustrial climate of the past few thousand years.

Since human CO₂ emissions are the main driver of global warming, we expect that if we plug historical CO₂ increases into our model ("forcing" it), we should roughly reproduce the observed historical global warming.

The observed increase of CO2 concentrations can be fairly accurately modelled by the simple cubic formula below.
"""

# ╔═╡ b8527aa8-179e-11eb-3023-05bb5d40a1bd
begin
	CO2_hist(t) = CO2_PI * (1 .+ fractional_increase(t));
	fractional_increase(t) = ((t .- 1850.)/220).^3;

end;

# ╔═╡ 6cb04022-1e0c-11eb-026f-f74661459a9e
md"Feeding this CO₂ function into our model, we can run it forward from 1850 to 2020 to try and simulate the amount of global warming that observed over this historical period."

# ╔═╡ 0c3db0a0-1dec-11eb-3105-a75ada72d69d
md"To check how accurate this simple model is in reproducing observed warming over this period, click the checkbox below."

# ╔═╡ 70039d58-1deb-11eb-053d-b96c2001b182
md"*Click to reveal observations of global warming* $(@bind show_obs CheckBox(default=false))"

# ╔═╡ 1e9a7382-209e-11eb-0a1f-c54079d1fb11
begin
	Bmin = -4.; Bmax = -0.;
	Bslider = @bind Bvary Slider(Bmin: 0.1: Bmax, default=B);
	md""" $(Bmin) W/m²/K $(Bslider) $(Bmax) W/m²/K"""
end

# ╔═╡ 2ad598ce-209f-11eb-3aa7-d10c0c267470
md"""
*Move the slider below* to change the strength of **climate feedbacks**: B = $(Bvary) [W/m²/K] 
"""

# ╔═╡ e4029e6c-209f-11eb-3c0f-11ac0759a30f
begin
	Cmin = 10.; Cmax = 200.;
	Cslider = @bind Cvary Slider(Cmin: 0.1: Cmax, default=C);
	md""" $(Cmin)  J/m²/K $(Cslider) $(Cmax)  J/m²/K,"""
end

# ╔═╡ 6ad84f92-1e0c-11eb-066f-d1b8c28a2cb2
begin
	hist = EBM(T0, 1850., 1., CO2_hist,
		C=Cvary, B=Bvary, A=(S*(1. - α)/4 + Bvary*T0)
	)
	run!(hist, 2020.)
end

# ╔═╡ d36ca536-209f-11eb-0489-051bbb54410f
md"""
or the **oceans' heat capacity**: C = $(Cvary) [W/m²/K],
"""

# ╔═╡ caf982c0-1f73-11eb-2648-d3b71d230c6d
if show_obs
	md"""
	##### CO₂ emissions predict the trend, but what about the climate noise?
	
	Our model does a good job of predicting the long-term trend of increasing temperatures, but what about all of the noise in the observations? These are real signals due to **natural variability** of the Earth system, not artifacts due to instrumental noise.

	This natural noise arises due to the **turbulent and chaotic fluid dynamics** of the atmosphere and ocean, which we will explore further in Lecture 4 and are illustrated below.
	"""
end

# ╔═╡ 448db99e-1f74-11eb-3637-a1aec60e5a10
if show_obs
	html"""

	<div style="padding:0 0 0 0;position:relative;"><iframe width="700" height="394" src="https://www.youtube-nocookie.com/embed/oRsY_UviBPE" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
	"""
end

# ╔═╡ 0b7d6da2-1dee-11eb-279b-dfc5318338e5
if show_obs
	md"Now that we've convinced ourselves that the model accurately reproduces historical warming, we can use it to project how much warming we might expect due to *future* CO₂ emissions."
end

# ╔═╡ 3cd3b9bc-1789-11eb-3373-3f54fa426e28
md""" ##### 3.3) Best- and worst-case projections of future global warming

"""

# ╔═╡ 5fd0d45c-1dee-11eb-2fb9-355f29d3d3dd
md"""Consider two divergent hypothetical futures:
1. a **low-emissions** world in which emissions decrease such that CO2 concentrations stay below 500 ppm by 2100 (known in climate circles as "RCP8.5") and
2. a **high-emissions** world in which emissions continue increasing and CO2 concentrations soar upwards of 1200 ppm ("RCP2.6").
"""

# ╔═╡ b9ff4090-179e-11eb-2380-69c7a9a7a999
begin	
	CO2_RCP26(t) = CO2_PI * (1 .+ fractional_increase(t) .* min.(1., exp.(-((t .-1850.).-170)/100))) ;
	RCP26 = EBM(T0, 1850., 1., CO2_RCP26)
	run!(RCP26, 2100.)
	
	CO2_RCP85(t) = CO2_PI * (1 .+ fractional_increase(t) .* max.(1., exp.(((t .-1850.).-170)/100)));
	RCP85 = EBM(T0, 1850., 1., CO2_RCP85)
	run!(RCP85, 2100.)
end;

# ╔═╡ 8e45f67c-1def-11eb-32af-5b0feec3e56f
md"""
In the low-emissions scenario, the temperature increase stays below $ΔT = 2$ °C by 2100, while in the high-emissions scenario temperatures soar upwards of 3.5ºC above pre-industrial levels.
"""

# ╔═╡ 48aa58f0-1f85-11eb-3279-bfcfae88c6dc
md"Although the greenhouse effect due to human-caused CO₂ emissions is the dominant forcing behind historical and future-projected warming, modern climate modelling considers a fairly exhaustive list of other forcing factors (aerosols, other greenhouse gases, ozone, land-use changes, etc.). The video below shows a breakdown of these forcing factors in a state-of-the-art climate model simulation of the historical period."

# ╔═╡ d04e6a94-1f85-11eb-081c-ff22bc849191
html"""
<iframe width="700" height="394" src="https://www.youtube-nocookie.com/embed/E7kMr2OYKSU" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ 59526360-17b9-11eb-04eb-b9771e718149
md"## Appendix"

# ╔═╡ 255623ac-1f85-11eb-2cd1-058dd5bbcd7e
md"#### Data sources"

# ╔═╡ 8aa337b4-17b9-11eb-3790-95da62666b85
md"**Temperature data**"

# ╔═╡ 4d251386-17b5-11eb-369e-b3113d5c80c7
begin
	T_url = "https://data.giss.nasa.gov/gistemp/graphs/graph_data/Global_Mean_Estimates_based_on_Land_and_Ocean_Data/graph.txt";
	T_f = CSV.File(HTTP.get(T_url).body, header=false, datarow=6, delim="     ");
	T_df = DataFrame(T_f);
	first(T_df, 3)
end

# ╔═╡ 94d9dc06-17b9-11eb-3588-03e0ca9391c6
md"**CO₂ data**"

# ╔═╡ bf1611ae-17b6-11eb-371d-dda63ceb69c1
begin
	CO2_url = "https://scrippsco2.ucsd.edu/assets/data/atmospheric/stations/in_situ_co2/monthly/monthly_in_situ_co2_mlo.csv"
	
	CO2_url_2 = "https://www.ncei.noaa.gov/pub/data/paleo/icecore/antarctica/law/law2006.txt"
	CO2_f = CSV.File(HTTP.get(CO2_url).body, header=55, datarow=60);
	CO2_df = DataFrame(CO2_f);
	first(CO2_df, 3)
end

# ╔═╡ 32f2d79e-1f85-11eb-0ecf-cb589ce85c1e
md"#### Plotting functions"

# ╔═╡ 5d77e3a4-209f-11eb-09d6-a792d0c54aec
as_svg(x) = PlutoUI.Show(MIME"image/svg+xml"(), repr(MIME"image/svg+xml"(), x))

# ╔═╡ 391fdb60-17b7-11eb-3e58-4598f229f679
function plot_obs_CO2!(p)
	CO2_tmp = CO2_df[:,5]
	CO2_tmp[CO2_tmp .<= 0.] .= NaN
	plot!(p, CO2_df[:,4], CO2_tmp, color=:black, label="Keeling Curve (Mauna Loa observations)", legend=:topleft)
end

# ╔═╡ 7467143e-1f86-11eb-0be2-5f57b6b169ad
function plot_obs_T!(p)	
	plot!(p, parse.(Float64, T_df[:,1]), parse.(Float64, T_df[:,2]) .+ 14.15, color=:black, label="NASA Observations", legend=:topleft)
end

# ╔═╡ fcbe38c2-17ae-11eb-3edf-d1d5dbd0af08
begin
	function plot_CO2!(p, t, CO2; label=nothing)
		plot!(p, xlabel="year", ylabel="CO₂ concentration [ppm]")
		plot!(p, t, CO2(t), lw=2.5, label=label)
	end
	
	function plot_T!(p, t, T; label=nothing)
		plot!(p, xlabel="year", ylabel="temperature [°C]")
		plot!(p, t, T, lw=2.5, label=label)
	end
end

# ╔═╡ c394ec66-17a0-11eb-259f-6b57f8cd4ece
begin
	pCO2 = plot(title="Cause...", ylims=(270, 420), xlims=(1850, 2020)); 
	plot_CO2!(pCO2, hist.t, CO2_hist)
	plot_obs_CO2!(pCO2)
	
	pT = plot(title="... and effect", ylims=(13.6, 15.3), xlims=(1850, 2020));
	plot_T!(pT, hist.t, hist.T)
	
	if show_obs;
		plot_obs_T!(pT)
	end
	
	plot(pCO2, pT, size=(680, 300))
end |> as_svg

# ╔═╡ 461c15d2-17a2-11eb-32ed-97e2ebbc6c93
begin
	p1 = plot(title="Cause...", legend=:topleft);
	p2 = plot(title="... and effect"); p = plot(p1, p2, size=(680, 300))
	plot_CO2!(p1, RCP26.t, CO2_RCP26, label="Low emissions")
	plot_T!(p2, RCP26.t, RCP26.T)
	plot_CO2!(p1, RCP85.t, CO2_RCP85, label="High emissions")
	plot_T!(p2, RCP85.t, RCP85.T)
	plot!(p2, [1850, 2100], [T0+2., T0+2.],
		color=:black, linestyle=:dash, alpha=0.5, label="Paris Agreement threshold (2°C warming)")
	mi, i = findmin(abs.(RCP26.t .- 2020.))
	plot!(p1, [RCP26.t[i]], [CO2_RCP26(RCP26.t[i])], marker=:o, color=:darkred, label="You Are Here")
	p
end

# ╔═╡ 3d1c5fba-1f85-11eb-06e9-33c26a60b893
md"#### Package dependencies"

# ╔═╡ Cell order:
# ╟─576a92f4-209a-11eb-36f8-0b27b3ededa7
# ╟─b01a3292-209a-11eb-2515-27f4a0227242
# ╟─e428f43e-13a1-11eb-15a5-2f677335bdd9
# ╟─ef62c780-13a1-11eb-3895-ff3abe0fdf5d
# ╟─c30dd85a-177f-11eb-3bbf-2bde4399ebbe
# ╟─619e8dde-13a2-11eb-1ac4-f1ce7f27b724
# ╠═98c68d84-1785-11eb-17c3-dda87383ebca
# ╟─6095cb6a-1786-11eb-3a5d-31718db7ad94
# ╠═e9a6a1da-1785-11eb-23f2-e7334e12d7ee
# ╟─99b9f320-1785-11eb-14a8-03c323a1254b
# ╠═9fd1be88-179d-11eb-15c3-fb779a666f45
# ╟─d5293b24-177f-11eb-1135-4f6395003637
# ╠═673a839a-1785-11eb-3382-6da7a94c917b
# ╟─a5a56754-1786-11eb-157a-f5ac8c75044f
# ╠═83421922-179d-11eb-0658-fd87f7adaed9
# ╟─8b076962-179d-11eb-2c44-b5bf340e92ab
# ╠═bd01be7a-1786-11eb-047d-cbfaa63f93a2
# ╟─d6fb4d64-1786-11eb-3859-9dc874b99e17
# ╠═f258767c-1786-11eb-0a9b-ad9f0094a8a0
# ╟─eaceee7e-177f-11eb-3d94-778732ca8768
# ╠═19c127ce-179e-11eb-2500-bd1680754ba0
# ╟─14c4c8ac-179e-11eb-3c26-e51c3191532d
# ╠═1be33ebe-1787-11eb-02f5-43802a30be01
# ╠═91b1ff3a-179c-11eb-3fc1-2d991840a4a1
# ╟─6cd7db88-2293-11eb-20a2-69fc5c87b82f
# ╟─d42ff276-177f-11eb-32e5-b5ce2c4cd42f
# ╠═125df9ba-1787-11eb-1953-13449970b9f9
# ╟─fe1844d2-1787-11eb-067f-e9664c17df27
# ╟─fbf1ba3e-0d65-11eb-20a7-55402d46d4ed
# ╟─8d6d7fc6-1788-11eb-234d-59f27a1b79d2
# ╠═27aa62a0-17b0-11eb-2029-a3c797e769eb
# ╟─5a51fac0-179c-11eb-0b65-859cc9232a3a
# ╠═35dfe0d2-17b0-11eb-20dc-7d7f4c5568ae
# ╟─3a549f2a-17b0-11eb-1d80-4bc2abc3dba6
# ╠═d0bf9b06-179c-11eb-0f1c-2fd535cb0e57
# ╟─e81fc2f8-17b0-11eb-20f8-2f4e890dc867
# ╠═e5902d52-17b0-11eb-1ba3-4be6c2bbc90f
# ╟─eba4ba20-22b2-11eb-3989-dde4f9c26702
# ╠═effbbd1c-22b2-11eb-2fe2-5df555bf5f2c
# ╟─073d8ba6-22b4-11eb-329f-c5d0c2a28562
# ╠═84d10370-22b3-11eb-0acd-07e5b454c481
# ╟─38346e6a-0d98-11eb-280b-f79787a3c788
# ╠═e5b20bda-17a0-11eb-38de-6d4d72b4e56d
# ╟─d85f2a90-17b0-11eb-007b-d39c79660dca
# ╟─cadbddec-179e-11eb-3a1e-3502e2534937
# ╟─e967605a-1de9-11eb-39d4-831533aed676
# ╟─0c393822-1789-11eb-30b3-7ff90191d89e
# ╠═b8527aa8-179e-11eb-3023-05bb5d40a1bd
# ╟─6cb04022-1e0c-11eb-026f-f74661459a9e
# ╟─6ad84f92-1e0c-11eb-066f-d1b8c28a2cb2
# ╟─0c3db0a0-1dec-11eb-3105-a75ada72d69d
# ╟─70039d58-1deb-11eb-053d-b96c2001b182
# ╟─c394ec66-17a0-11eb-259f-6b57f8cd4ece
# ╟─2ad598ce-209f-11eb-3aa7-d10c0c267470
# ╟─1e9a7382-209e-11eb-0a1f-c54079d1fb11
# ╟─d36ca536-209f-11eb-0489-051bbb54410f
# ╟─e4029e6c-209f-11eb-3c0f-11ac0759a30f
# ╟─caf982c0-1f73-11eb-2648-d3b71d230c6d
# ╟─448db99e-1f74-11eb-3637-a1aec60e5a10
# ╟─0b7d6da2-1dee-11eb-279b-dfc5318338e5
# ╟─3cd3b9bc-1789-11eb-3373-3f54fa426e28
# ╟─5fd0d45c-1dee-11eb-2fb9-355f29d3d3dd
# ╠═b9ff4090-179e-11eb-2380-69c7a9a7a999
# ╟─8e45f67c-1def-11eb-32af-5b0feec3e56f
# ╟─461c15d2-17a2-11eb-32ed-97e2ebbc6c93
# ╟─48aa58f0-1f85-11eb-3279-bfcfae88c6dc
# ╟─d04e6a94-1f85-11eb-081c-ff22bc849191
# ╟─59526360-17b9-11eb-04eb-b9771e718149
# ╟─255623ac-1f85-11eb-2cd1-058dd5bbcd7e
# ╟─8aa337b4-17b9-11eb-3790-95da62666b85
# ╟─4d251386-17b5-11eb-369e-b3113d5c80c7
# ╟─94d9dc06-17b9-11eb-3588-03e0ca9391c6
# ╟─bf1611ae-17b6-11eb-371d-dda63ceb69c1
# ╟─32f2d79e-1f85-11eb-0ecf-cb589ce85c1e
# ╠═5d77e3a4-209f-11eb-09d6-a792d0c54aec
# ╠═391fdb60-17b7-11eb-3e58-4598f229f679
# ╠═7467143e-1f86-11eb-0be2-5f57b6b169ad
# ╠═fcbe38c2-17ae-11eb-3edf-d1d5dbd0af08
# ╟─3d1c5fba-1f85-11eb-06e9-33c26a60b893
# ╠═5bf00f46-17b9-11eb-2625-bf3f33c273e2
