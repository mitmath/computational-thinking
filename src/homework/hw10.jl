### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> chapter = 3
#> section = 7.5
#> order = 7.5
#> homework_number = 10
#> title = "Climate modeling I"
#> layout = "layout.jlhtml"
#> tags = ["homework", "module3", "track_climate", "track_julia", "track_data", "track_math", "climate", "plotting", "interactive", "modeling", "climate model", "economics", "bifurcation", "probability"]
#> description = "Play around with an energy balance model of the climate system, to explore the effect of doubling CO₂, and to examine the 'snowball earth' phenomenon."

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

# ╔═╡ 1e06178a-1fbf-11eb-32b3-61769a79b7c0
begin
	using LaTeXStrings
	using Plots
	using PlutoUI
	using Random, Distributions
end

# ╔═╡ 169727be-2433-11eb-07ae-ab7976b5be90
md"_homework 10, version 3_"

# ╔═╡ 21524c08-2433-11eb-0c55-47b1bdc9e459
md"""

# **Homework 10**: _Climate modeling I_
`18.S191`, Fall 2023
"""

# ╔═╡ 253f4da0-2433-11eb-1e48-4906059607d3
md"""
#### Initializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 87e68a4a-2433-11eb-3e9d-21675850ed71
html"""
<iframe width="100%" height="300" src="https://www.youtube.com/embed/Gi4ZZVS2GLA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ fe3304f8-2668-11eb-066d-fdacadce5a19
md"""
_Before working on the homework, make sure that you have watched the first lecture on climate modeling 👆. We have included the important functions from this lecture notebook in the next cell. Feel free to have a look!_
"""

# ╔═╡ 930d7154-1fbf-11eb-1c3a-b1970d291811
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
	EBM(T::Array{Float64,1}, t::Array{Float64,1}, Δt::Real, CO2::Function;
		C=C, a=a, A=A, B=B, CO2_PI=CO2_PI, α=α, S=S) = (
		EBM(T, t, Δt, CO2, C, a, A, B, CO2_PI, α, S)
	);
	
	# Construct from float inputs for convenience
	EBM(T0::Real, t0::Real, Δt::Real, CO2::Function;
		C=C, a=a, A=A, B=B, CO2_PI=CO2_PI, α=α, S=S) = (
		EBM(Float64[T0], Float64[t0], Δt, CO2;
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
	CO2_RCP26(t) = CO2_PI * (1 .+ fractional_increase(t) .* min.(1., exp.(-((t .-1850.).-170)/100))) ;
	RCP26 = EBM(T0, 1850., 1., CO2_RCP26)
	run!(RCP26, 2100.)
	
	CO2_RCP85(t) = CO2_PI * (1 .+ fractional_increase(t) .* max.(1., exp.(((t .-1850.).-170)/100)));
	RCP85 = EBM(T0, 1850., 1., CO2_RCP85)
	run!(RCP85, 2100.)
end

end

# ╔═╡ 1312525c-1fc0-11eb-2756-5bc3101d2260
md"""## **Exercise 1** - _policy goals under uncertainty_
A recent ground-breaking [review paper](https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2019RG000678) produced the most comprehensive and up-to-date estimate of the *climate feedback parameter*, which they find to be

$B \approx \mathcal{N}(-1.3, 0.4),$

i.e. our knowledge of the real value is normally distributed with a mean value $\overline{B} = -1.3$ W/m²/K and a standard deviation $\sigma = 0.4$ W/m²/K. These values are not very intuitive, so let us convert them into more policy-relevant numbers.

**Definition:** *Equilibrium climate sensitivity (ECS)* is defined as the amount of warming $\Delta T$ caused by a doubling of CO₂ (e.g. from the pre-industrial value 280 ppm to 560 ppm), at equilibrium.

At equilibrium, the energy balance model equation is:

$0 = \frac{S(1 - α)}{4} - (A - BT_{eq}) + a \ln\left( \frac{2\;\text{CO}₂_{\text{PI}}}{\text{CO}₂_{\text{PI}}} \right)$

From this, we subtract the preindustrial energy balance, which is given by:

$0 = \frac{S(1-α)}{4} - (A - BT_{0}),$

The result of this subtraction, after rearranging, is our definition of $\text{ECS}$:

$\text{ECS} \equiv T_{eq} - T_{0} = -\frac{a\ln(2)}{B}$
"""

# ╔═╡ 7f961bc0-1fc5-11eb-1f18-612aeff0d8df
md"""The plot below provides an example of an "abrupt 2 × CO₂" experiment, a classic experimental treatment method in climate modelling which is used in practice to estimate ECS for a particular model. (Note: in complicated climate models the values of the parameters $a$ and $B$ are not specified *a priori*, but *emerge* as outputs of the simulation.)

The simulation begins at the preindustrial equilibrium, i.e. a temperature $T_{0} = 14$°C is in balance with the pre-industrial CO₂ concentration of 280 ppm until CO₂ is abruptly doubled from 280 ppm to 560 ppm. The climate responds by warming rapidly, and after a few hundred years approaches the equilibrium climate sensitivity value, by definition.
"""

# ╔═╡ fa7e6f7e-2434-11eb-1e61-1b1858bb0988
md"""
``B = `` $(@bind B_slider Slider(-2.5:.001:0; show_value=true, default=-1.3))
"""

# ╔═╡ 16348b6a-1fc2-11eb-0b9c-65df528db2a1
md"""
##### Exercise 1.1 - _Develop understanding for feedbacks and climate sensitivity_
"""

# ╔═╡ e296c6e8-259c-11eb-1385-53f757f4d585
md"""
👉 Change the value of $B$ using the slider above. What does it mean for a climate system to have a more negative value of $B$? Explain why we call $B$ the _climate feedback parameter_.
"""

# ╔═╡ a86f13de-259d-11eb-3f46-1f6fb40020ce
observations_from_changing_B = md"""
Hello world!
"""

# ╔═╡ 3d66bd30-259d-11eb-2694-471fb3a4a7be
md"""
👉 What happens when $B$ is greater than or equal to zero?
"""

# ╔═╡ 5f82dec8-259e-11eb-2f4f-4d661f44ef41
observations_from_nonnegative_B = md"""
Hello world!
"""

# ╔═╡ 56b68356-2601-11eb-39a9-5f4b8e580b87
md"Reveal answer: $(@bind reveal_nonnegative_B_answer CheckBox())"

# ╔═╡ 7d815988-1fc7-11eb-322a-4509e7128ce3
if reveal_nonnegative_B_answer
	md"""
This is known as the "runaway greenhouse effect", where warming self-amplifies so strongly through *positive feedbacks* that the warming continues forever (or until the oceans boil away and there is no longer a reservoir or water to support a *water vapor feedback*. This is thought to explain Venus' extremely hot and hostile climate, but as you can see is extremely unlikely to occur on present-day Earth.
"""
end

# ╔═╡ aed8f00e-266b-11eb-156d-8bb09de0dc2b
md"""
👉 Create a graph to visualize ECS as a function of B. 
"""

# ╔═╡ b9f882d8-266b-11eb-2998-75d6539088c7


# ╔═╡ 269200ec-259f-11eb-353b-0b73523ef71a
md"""
#### Exercise 1.2 - _Doubling CO₂_

To compute ECS, we doubled the CO₂ in our atmosphere. This factor 2 is not entirely arbitrary: without substantial effort to reduce CO₂ emissions, we are expected to **at least** double the CO₂ in our atmosphere by 2100. 

Right now, our CO₂ concentration is 415 ppm -- $(round(415 / 280, digits=3)) times the pre-industrial value of 280 ppm from 1850. 

The CO₂ concentrations in the _future_ depend on human action. There are several models for future concentrations, which are formed by assuming different _policy scenarios_. A baseline model is RCP8.5 - a "worst-case" high-emissions scenario. In our notebook, this model is given as a function of ``t``.
"""

# ╔═╡ 2dfab366-25a1-11eb-15c9-b3dd9cd6b96c
md"""
👉 In what year are we expected to have doubled the CO₂ concentration, under policy scenario RCP8.5?
"""

# ╔═╡ 50ea30ba-25a1-11eb-05d8-b3d579f85652
expected_double_CO2_year = let
	
	
	missing
end

# ╔═╡ bade1372-25a1-11eb-35f4-4b43d4e8d156
md"""
#### Exercise 1.3 - _Uncertainty in B_

The climate feedback parameter ``B`` is not something that we can control– it is an emergent property of the global climate system. Unfortunately, ``B`` is also difficult to quantify empirically (the relevant processes are difficult or impossible to observe directly), so there remains uncertainty as to its exact value.

A value of ``B`` close to zero means that an increase in CO₂ concentrations will have a larger impact on global warming, and that more action is needed to stay below a maximum temperature. In answering such policy-related question, we need to take the uncertainty in ``B`` into account. In this exercise, we will do so using a Monte Carlo simulation: we generate a sample of values for ``B``, and use these values in our analysis.
"""

# ╔═╡ 02232964-2603-11eb-2c4c-c7b7e5fed7d1
B̅ = -1.3; σ = 0.4

# ╔═╡ c4398f9c-1fc4-11eb-0bbb-37f066c6027d
ECS(; B=B̅, a=Model.a) = -a*log(2.)./B;

# ╔═╡ 25f92dec-1fc4-11eb-055d-f34deea81d0e
let
	double_CO2(t) = if t >= 0
		2*Model.CO2_PI
	else
		Model.CO2_PI
	end
	
	# the definition of A depends on B, so we recalculate:
	A = Model.S*(1. - Model.α)/4 + B_slider*Model.T0
	# create the model
	ebm_ECS = Model.EBM(14., -100., 1., double_CO2, A=A, B=B_slider);
	Model.run!(ebm_ECS, 300)
	
	ecs = ECS(B=B_slider)
	
	p = plot(
		size=(500, 250), legend=:bottomright, 
		title="Transient response to instant doubling of CO₂", 
		ylabel="temperature change [°C]", xlabel="years after doubling",
		ylim=(-.5, (isfinite(ecs) && ecs < 4) ? 4 : 10),
	)
	
	plot!(p, [ebm_ECS.t[1], ebm_ECS.t[end]], ecs .* [1,1], 
		ls=:dash, color=:darkred, label="ECS")
	
	plot!(p, ebm_ECS.t, ebm_ECS.T .- ebm_ECS.T[1], 
		label="ΔT(t) = T(t) - T₀")
end |> as_svg

# ╔═╡ 736ed1b6-1fc2-11eb-359e-a1be0a188670
B_samples = let
	B_distribution = Normal(B̅, σ)
	Nsamples = 5000
	
	samples = rand(B_distribution, Nsamples)
	# we only sample negative values of B
	filter(x -> x < 0, samples)
end

# ╔═╡ 49cb5174-1fc3-11eb-3670-c3868c9b0255
histogram(B_samples, size=(600, 250), label=nothing, xlabel="B [W/m²/K]", ylabel="samples")

# ╔═╡ f3abc83c-1fc7-11eb-1aa8-01ce67c8bdde
md"""
👉 Generate a probability distribution for the ECS based on the probability distribution function for $B$ above. Plot a histogram.
"""

# ╔═╡ 3d72ab3a-2689-11eb-360d-9b3d829b78a9
ECS_samples = missing

# ╔═╡ b6d7a362-1fc8-11eb-03bc-89464b55c6fc
md"**Answer:**"

# ╔═╡ 1f148d9a-1fc8-11eb-158e-9d784e390b24


# ╔═╡ cf8dca6c-1fc8-11eb-1f89-099e6ba53c22
md"It looks like the ECS distribution is **not normally distributed**, even though $B$ is. 

👉 How does $\overline{\text{ECS}(B)}$ compare to $\text{ECS}(\overline{B})$? What is the probability that $\text{ECS}(B)$ lies above $\text{ECS}(\overline{B})$?
"

# ╔═╡ 02173c7a-2695-11eb-251c-65efb5b4a45f


# ╔═╡ 440271b6-25e8-11eb-26ce-1b80aa176aca
md"👉 Does accounting for uncertainty in feedbacks make our expectation of global warming better (less implied warming) or worse (more implied warming)?"

# ╔═╡ cf276892-25e7-11eb-38f0-03f75c90dd9e
observations_from_the_order_of_averaging = md"""
Hello world!
"""

# ╔═╡ 5b5f25f0-266c-11eb-25d4-17e411c850c9
md"""
#### Exercise 1.5 - _Running the model_

In the lecture notebook we introduced a _mutable struct_ `EBM` (_energy balance model_), which contains:
- the parameters of our climate simulation (`C`, `a`, `A`, `B`, `CO2_PI`, `α`, `S`, see details below)
- a function `CO2`, which maps a time `t` to the concentrations at that year. For example, we use the function `t -> 280` to simulate a model with concentrations fixed at 280 ppm.

`EBM` also contains the simulation results, in two arrays:
- `T` is the array of temperatures (°C, `Float64`).
- `t` is the array of timestamps (years, `Float64`), of the same size as `T`.
"""

# ╔═╡ 3f823490-266d-11eb-1ba4-d5a23975c335
html"""
<style>
.hello td {
	font-family: sans-serif; font-size: .8em;
	max-width: 300px
}

soft {
	opacity: .5;
}
</style>


<p>Properties of an <code>EBM</code> obect:</p>
<table class="hello">
<thead>

<tr><th>Name</th><th>Description</th></tr>
</thead>
<tbody>
<tr><th><code>A</code></th><td>Linearized outgoing thermal radiation: offset <soft>[W/m²]</soft></td></tr>
<tr><th><code>B</code></th><td>Linearized outgoing thermal radiation: slope. <em>or: </em><b>climate feedback parameter</b> <soft>[W/m²/°C]</soft></td></tr>
<tr><th><code>α</code></th><td>Planet albedo, 0.0-1.0 <soft>[unitless]</soft></td></tr>
<tr><th><code>S</code></th><td>Solar insulation <soft>[W/m²]</soft></td></tr>
<tr><th><code>C</code></th><td>Atmosphere and upper-ocean heat capacity <soft>[J/m²/°C]</soft></td></tr>
<tr><th><code>a</code></th><td>CO₂ forcing effect <soft>[W/m²]</soft></td></tr>
<tr><th><code>CO2_PI</code></th><td>Pre-industrial CO₂ concentration <soft>[ppm]</soft></td></tr>
</tbody>
</table>

"""

# ╔═╡ 971f401e-266c-11eb-3104-171ae299ef70
md"""

You can set up an instance of `EBM` like so:
"""

# ╔═╡ 746aa5bc-266c-11eb-14c9-63ccc313f5de
empty_ebm = Model.EBM(
	14.0, # initial temperature
	1850, # initial year
	1, # Δt
	t -> 280.0, # CO2 function
)

# ╔═╡ a919d584-2670-11eb-1cf9-2327c8135d6d
md"""
Have a look inside this object. We see that `T` and `t` are initialized to a 1-element array.

Let's run our model:
"""

# ╔═╡ bfb07a0a-2670-11eb-3938-772499c637b1
simulated_model = let
	ebm = Model.EBM(14.0, 1850, 1, t -> 280.0)
	Model.run!(ebm, 2020)
	ebm
end

# ╔═╡ 12cbbab0-2671-11eb-2b1f-038c206e84ce
md"""
Again, look inside `simulated_model` and notice that `T` and `t` have accumulated the simulation results.

In this simulation, we used `T0 = 14` and `CO2 = t -> 280`, which is why `T` is constant during our simulation. These parameters are the default, pre-industrial values, and our model is based on this equilibrium.

👉 Run a simulation with policy scenario RCP8.5, and plot the computed temperature graph. What is the global temperature in the year 2100?
"""

# ╔═╡ 9596c2dc-2671-11eb-36b9-c1af7e5f1089
simulated_rcp85_model = let
	
	missing
end

# ╔═╡ f94a1d56-2671-11eb-2cdc-810a9c7a8a5f


# ╔═╡ 4b091fac-2672-11eb-0db8-75457788d85e
md"""
Additional parameters can be set using keyword arguments. For example:

```julia
Model.EBM(14, 1850, 1, t -> 280.0; B=-2.0)
```
Creates the same model as before, but with `B = -2.0`.
"""

# ╔═╡ 9cdc5f84-2671-11eb-3c78-e3495bc64d33
md"""
👉 Write a function `temperature_response` that takes a function `CO2` and an optional value `B` as parameters, and returns the temperature at 2100 according to our model.
"""

# ╔═╡ f688f9f2-2671-11eb-1d71-a57c9817433f
function temperature_response(CO2::Function, B::Float64=-1.3)
	
	return missing
end

# ╔═╡ 049a866e-2672-11eb-29f7-bfea7ad8f572
temperature_response(t -> 280)

# ╔═╡ 09901de6-2672-11eb-3d50-05b176b729e7
temperature_response(Model.CO2_RCP85)

# ╔═╡ aea0d0b4-2672-11eb-231e-395c863827d3
temperature_response(Model.CO2_RCP85, -1.0)

# ╔═╡ 9c32db5c-1fc9-11eb-029a-d5d554de1067
md"""#### Exercise 1.6 - _Application to policy relevant questions_

We talked about two _emissions scenarios_: RCP2.6 (strong mitigation - controlled CO2 concentrations) and RCP8.5 (no mitigation - high CO2 concentrations). These are given by the following functions:
"""

# ╔═╡ ee1be5dc-252b-11eb-0865-291aa823b9e9
t = 1850:2100

# ╔═╡ e10a9b70-25a0-11eb-2aed-17ed8221c208
plot(t, Model.CO2_RCP85.(t), 
	ylim=(0, 1200), ylabel="CO2 concentration [ppm]")

# ╔═╡ 40f1e7d8-252d-11eb-0549-49ca4e806e16
@bind t_scenario_test Slider(t; show_value=true, default=1850)

# ╔═╡ 19957754-252d-11eb-1e0a-930b5208f5ac
Model.CO2_RCP26(t_scenario_test), Model.CO2_RCP85(t_scenario_test)

# ╔═╡ 06c5139e-252d-11eb-2645-8b324b24c405
md"""
We are interested in how the **uncertainty in our input** $B$ (the climate feedback parameter) *propagates* through our model to determine the **uncertainty in our output** $T(t)$, for a given emissions scenario. The goal of this exercise is to answer the following by using *Monte Carlo Simulation* for *uncertainty propagation*:

> 👉 What is the probability that we see more than 2°C of warming by 2100 under the low-emissions scenario RCP2.6? What about under the high-emissions scenario RCP8.5?

"""

# ╔═╡ f2e55166-25ff-11eb-0297-796e97c62b07


# ╔═╡ 1ea81214-1fca-11eb-2442-7b0b448b49d6
md"""
## **Exercise 2** - _How did Snowball Earth melt?_

In lecture 21 (see below), we discovered that increases in the brightness of the Sun are not sufficient to explain how Snowball Earth eventually melted.
"""

# ╔═╡ a0ef04b0-25e9-11eb-1110-cde93601f712
html"""
<script src="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.0/src/lite-yt-embed.js" integrity="sha256-sDRYYtDc+jNi2rrJPUS5kGxXXMlmnOSCq5ek5tYAk/M=" crossorigin="anonymous" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.0/src/lite-yt-embed.css" integrity="sha256-lv6SEl7Dhri7d86yiHCTuSWFb9CYROQFewxZ7Je0n5k=" crossorigin="anonymous">

<lite-youtube videoid=Y68tnH0FIzc params="modestbranding=1&rel=0"></lite-youtube>
"""

# ╔═╡ 3e310cf8-25ec-11eb-07da-cb4a2c71ae34
md"""
We talked about a second theory -- a large increase in CO₂ (by volcanoes) could have caused a strong enough greenhouse effect to melt the Snowball. If we imagine that the CO₂ then decreased (e.g. by getting sequestered by the now liquid ocean), we might be able to explain how we transitioned from a hostile Snowball Earth to today's habitable "Waterball" Earth.

In this exercise, you will estimate how much CO₂ would be needed to melt the Snowball and visualize a possible trajectory for Earth's climate over the past 700 million years by making an interactive *bifurcation diagram*.

#### Exercise 2.1

In the [lecture notebook](https://github.com/hdrake/simplEarth/blob/master/2_ebm_multiple_equilibria.jl) (video above), we had a bifurcation diagram of $S$ (solar insolation) vs $T$ (temperature). We increased $S$, watched our point move right in the diagram until we found the tipping point. This time we will do the same, but we vary the CO₂ concentration, and keep $S$ fixed at its default (present day) value.
"""

# ╔═╡ d6d1b312-2543-11eb-1cb2-e5b801686ffb
md"""
Below we have an empty diagram, which is already set up with a CO₂ vs $T$ diagram, with a logarithmic horizontal axis. Now it's your turn! We have written some pointers below to help you, but feel free to do it your own way.
"""

# ╔═╡ 3cbc95ba-2685-11eb-3810-3bf38aa33231
md"""
We used two helper functions:
"""

# ╔═╡ 68b2a560-2536-11eb-0cc4-27793b4d6a70
function add_cold_hot_areas!(p)
	
	left, right = xlims(p)
	
	plot!(p, 
		[left, right], [-60, -60], 
		fillrange=[-10., -10.], fillalpha=0.3, c=:lightblue, label=nothing
	)
	annotate!(p, 
		left+12, -19, 
		text("completely\nfrozen", 10, :darkblue, :left)
	)
	
	plot!(p, 
		[left, right], [10, 10], 
		fillrange=[80., 80.], fillalpha=0.09, c=:red, lw=0., label=nothing
	)
	annotate!(p,
		left+12, 15, 
		text("no ice", 10, :darkred, :left)
	)
end

# ╔═╡ 0e19f82e-2685-11eb-2e99-0d094c1aa520
function add_reference_points!(p)
	plot!(p, 
		[Model.CO2_PI, Model.CO2_PI], [-55, 75], 
		color=:grey, alpha=0.3, lw=8, 
		label="Pre-industrial CO2"
	)
	plot!(p, 
		[Model.CO2_PI], [Model.T0], 
		shape=:circle, color=:orange, markersize=8,
		label="Our preindustrial climate"
	)
	plot!(p,
		[Model.CO2_PI], [-38.3], 
		shape=:circle, color=:aqua, markersize=8,
		label="Alternate preindustrial climate"
	)
end

# ╔═╡ 1eabe908-268b-11eb-329b-b35160ec951e
md"""
👉 Create a slider for `CO2` between `CO2min` and `CO2max`. Just like the horizontal axis of our plot, we want the slider to be _logarithmic_. 
"""

# ╔═╡ 1d388372-2695-11eb-3068-7b28a2ccb9ac


# ╔═╡ 4c9173ac-2685-11eb-2129-99071821ebeb
md"""
👉 Write a function `step_model!` that takes an existing `ebm` and `new_CO2`, which performs a step of our interactive process:
- Reset the model by setting the `ebm.t` and `ebm.T` arrays to a single element. _Which value?_
- Assign a new function to `ebm.CO2`. _What function?_
- Run the model.
"""

# ╔═╡ 736515ba-2685-11eb-38cb-65bfcf8d1b8d
function step_model!(ebm::Model.EBM, CO2::Real)
	
	# your code here
	
	return ebm
end

# ╔═╡ 8b06b944-268c-11eb-0bfc-8d4dd21e1f02
md"""
👉 Inside the plot cell, call the function `step_model!`.
"""

# ╔═╡ 09ce27ca-268c-11eb-0cdd-c9801db876f8
md"""
##### Parameters
"""

# ╔═╡ 298deff4-2676-11eb-2595-e7e22f613ea1
CO2min = 10

# ╔═╡ 2bbf5a70-2676-11eb-1085-7130d4a30443
CO2max = 1_000_000

# ╔═╡ de95efae-2675-11eb-0909-73afcd68fd42
Tneo = -48

# ╔═╡ 06d28052-2531-11eb-39e2-e9613ab0401c
ebm = Model.EBM(Tneo, 0., 5., Model.CO2_const)

# ╔═╡ 378aed18-252b-11eb-0b37-a3b511af2cb5
let
	p = plot(
		xlims=(CO2min, CO2max), ylims=(-55, 75), 
		xaxis=:log,
		xlabel="CO2 concentration [ppm]", 
		ylabel="Global temperature T [°C]",
		title="Earth's CO2 concentration bifurcation diagram",
		legend=:topleft
	)
	
	add_cold_hot_areas!(p)
	add_reference_points!(p)
	
	# your code here 
	
	plot!(p, 
		[ebm.CO2(ebm.t[end])], [ebm.T[end]],
		label=nothing,
		color=:black,
		shape=:circle,
	)
	
end |> as_svg

# ╔═╡ c78e02b4-268a-11eb-0af7-f7c7620fcc34
md"""
The albedo feedback is implemented by the methods below:
"""

# ╔═╡ d7801e88-2530-11eb-0b93-6f1c78d00eea
function α(T; α0=Model.α, αi=0.5, ΔT=10.)
	if T < -ΔT
		return αi
	elseif -ΔT <= T < ΔT
		return αi + (α0-αi)*(T+ΔT)/(2ΔT)
	elseif T >= ΔT
		return α0
	end
end

# ╔═╡ 607058ec-253c-11eb-0fb6-add8cfb73a4f
function Model.timestep!(ebm)
	ebm.α = α(ebm.T[end]) # Added this line
	append!(ebm.T, ebm.T[end] + ebm.Δt*Model.tendency(ebm));
	append!(ebm.t, ebm.t[end] + ebm.Δt);
end

# ╔═╡ 9c1f73e0-268a-11eb-2bf1-216a5d869568
md"""
If you like, make the visualization more informative! Like in the lecture notebook, you could add a trail behind the black dot, or you could plot the stable and unstable branches. It's up to you! 
"""

# ╔═╡ 11096250-2544-11eb-057b-d7112f20b05c
md"""
#### Exercise 2.2

👉 Find the **lowest CO₂ concentration** necessary to melt the Snowball, programmatically (i.e., using code).
"""

# ╔═╡ 9eb07a6e-2687-11eb-0de3-7bc6aa0eefb0
co2_to_melt_snowball = let
	
	missing
end

# ╔═╡ 36ea4410-2433-11eb-1d98-ab4016245d95
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 36f8c1e8-2433-11eb-1f6e-69dc552a4a07
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 51e2e742-25a1-11eb-2511-ab3434eacc3e
hint(md"The function `findfirst` might be helpful.")

# ╔═╡ 53c2eaf6-268b-11eb-0899-b91c03713da4
hint(md"
```julia
@bind log_CO2 Slider(❓)
```

```julia
CO2 = 10^log_CO2
```

")

# ╔═╡ cb15cd88-25ed-11eb-2be4-f31500a726c8
hint(md"Use a condition on the albedo or temperature to check whether the Snowball has melted.")

# ╔═╡ 232b9bec-2544-11eb-0401-97a60bb172fc
hint(md"Start by writing a function `equilibrium_temperature(CO2)` which creates a new `EBM` at the Snowball Earth temperature T = $(Tneo) and returns the final temperature for a given CO2 level.")

# ╔═╡ 37061f1e-2433-11eb-3879-2d31dc70a771
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ 371352ec-2433-11eb-153d-379afa8ed15e
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 372002e4-2433-11eb-0b25-39ce1b1dd3d1
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 372c1480-2433-11eb-3c4e-95a37d51835f
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ 3737be8e-2433-11eb-2049-2d6d8a5e4753
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 374522c4-2433-11eb-3da3-17419949defc
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 37552044-2433-11eb-1984-d16e355a7c10
TODO = html"<span style='display: inline; font-size: 2em; color: purple; font-weight: 900;'>TODO</span>"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
Distributions = "~0.25.76"
LaTeXStrings = "~1.3.0"
Plots = "~1.33.0"
PlutoUI = "~0.7.48"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "3ca828fe1b75fa84b021a7860bd039eaea84d2f2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.3.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[DataAPI]]
git-tree-sha1 = "46d2680e618f8abd007bce0c3026cb0c4a8f2032"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.12.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "04db820ebcfc1e053bd8cbb8d8bccf0ff3ead3f7"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.76"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "802bfc139833d2ba893dd9e62ba1767c88d708ae"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.5"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "cf0a9940f250dc3cb6cc6c6821b4bf8a4286cf9c"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.66.2"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "a97d47758e933cd5fe5ea181d178936a9fc60427"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.5.1"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

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

[[IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

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

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "3c3c4a401d267b04942545b1e964a20279587fd7"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "6c01a9b494f6d2a9fc180a08b182fcb06f0958a0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "6062b3b25ad3c58e817df0747fc51518b9110e5f"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.33.0"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "97aa253e65b784fd13e83774cadc95b38011d734"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.6.0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "d12e612bba40d189cead6ff857ddb67bd2e6a387"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "80aaeb2ec4d67f6c48b7cb1144f96455192655cf"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.8"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "22c5201127d7b243b9ee1de3b43c408879dff60f"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.3.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5783b877201a82fc0014cbf381e7e6eb130473a4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.0.1"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─169727be-2433-11eb-07ae-ab7976b5be90
# ╟─21524c08-2433-11eb-0c55-47b1bdc9e459
# ╟─253f4da0-2433-11eb-1e48-4906059607d3
# ╠═1e06178a-1fbf-11eb-32b3-61769a79b7c0
# ╟─87e68a4a-2433-11eb-3e9d-21675850ed71
# ╟─fe3304f8-2668-11eb-066d-fdacadce5a19
# ╟─930d7154-1fbf-11eb-1c3a-b1970d291811
# ╟─1312525c-1fc0-11eb-2756-5bc3101d2260
# ╠═c4398f9c-1fc4-11eb-0bbb-37f066c6027d
# ╟─7f961bc0-1fc5-11eb-1f18-612aeff0d8df
# ╟─25f92dec-1fc4-11eb-055d-f34deea81d0e
# ╟─fa7e6f7e-2434-11eb-1e61-1b1858bb0988
# ╟─16348b6a-1fc2-11eb-0b9c-65df528db2a1
# ╟─e296c6e8-259c-11eb-1385-53f757f4d585
# ╠═a86f13de-259d-11eb-3f46-1f6fb40020ce
# ╟─3d66bd30-259d-11eb-2694-471fb3a4a7be
# ╠═5f82dec8-259e-11eb-2f4f-4d661f44ef41
# ╟─56b68356-2601-11eb-39a9-5f4b8e580b87
# ╟─7d815988-1fc7-11eb-322a-4509e7128ce3
# ╟─aed8f00e-266b-11eb-156d-8bb09de0dc2b
# ╠═b9f882d8-266b-11eb-2998-75d6539088c7
# ╟─269200ec-259f-11eb-353b-0b73523ef71a
# ╠═e10a9b70-25a0-11eb-2aed-17ed8221c208
# ╟─2dfab366-25a1-11eb-15c9-b3dd9cd6b96c
# ╠═50ea30ba-25a1-11eb-05d8-b3d579f85652
# ╟─51e2e742-25a1-11eb-2511-ab3434eacc3e
# ╟─bade1372-25a1-11eb-35f4-4b43d4e8d156
# ╠═02232964-2603-11eb-2c4c-c7b7e5fed7d1
# ╟─736ed1b6-1fc2-11eb-359e-a1be0a188670
# ╠═49cb5174-1fc3-11eb-3670-c3868c9b0255
# ╟─f3abc83c-1fc7-11eb-1aa8-01ce67c8bdde
# ╠═3d72ab3a-2689-11eb-360d-9b3d829b78a9
# ╟─b6d7a362-1fc8-11eb-03bc-89464b55c6fc
# ╠═1f148d9a-1fc8-11eb-158e-9d784e390b24
# ╟─cf8dca6c-1fc8-11eb-1f89-099e6ba53c22
# ╠═02173c7a-2695-11eb-251c-65efb5b4a45f
# ╟─440271b6-25e8-11eb-26ce-1b80aa176aca
# ╠═cf276892-25e7-11eb-38f0-03f75c90dd9e
# ╟─5b5f25f0-266c-11eb-25d4-17e411c850c9
# ╟─3f823490-266d-11eb-1ba4-d5a23975c335
# ╟─971f401e-266c-11eb-3104-171ae299ef70
# ╠═746aa5bc-266c-11eb-14c9-63ccc313f5de
# ╟─a919d584-2670-11eb-1cf9-2327c8135d6d
# ╠═bfb07a0a-2670-11eb-3938-772499c637b1
# ╟─12cbbab0-2671-11eb-2b1f-038c206e84ce
# ╠═9596c2dc-2671-11eb-36b9-c1af7e5f1089
# ╠═f94a1d56-2671-11eb-2cdc-810a9c7a8a5f
# ╟─4b091fac-2672-11eb-0db8-75457788d85e
# ╟─9cdc5f84-2671-11eb-3c78-e3495bc64d33
# ╠═f688f9f2-2671-11eb-1d71-a57c9817433f
# ╠═049a866e-2672-11eb-29f7-bfea7ad8f572
# ╠═09901de6-2672-11eb-3d50-05b176b729e7
# ╠═aea0d0b4-2672-11eb-231e-395c863827d3
# ╟─9c32db5c-1fc9-11eb-029a-d5d554de1067
# ╠═19957754-252d-11eb-1e0a-930b5208f5ac
# ╠═40f1e7d8-252d-11eb-0549-49ca4e806e16
# ╟─ee1be5dc-252b-11eb-0865-291aa823b9e9
# ╟─06c5139e-252d-11eb-2645-8b324b24c405
# ╠═f2e55166-25ff-11eb-0297-796e97c62b07
# ╟─1ea81214-1fca-11eb-2442-7b0b448b49d6
# ╟─a0ef04b0-25e9-11eb-1110-cde93601f712
# ╟─3e310cf8-25ec-11eb-07da-cb4a2c71ae34
# ╟─d6d1b312-2543-11eb-1cb2-e5b801686ffb
# ╠═378aed18-252b-11eb-0b37-a3b511af2cb5
# ╟─3cbc95ba-2685-11eb-3810-3bf38aa33231
# ╟─68b2a560-2536-11eb-0cc4-27793b4d6a70
# ╟─0e19f82e-2685-11eb-2e99-0d094c1aa520
# ╟─1eabe908-268b-11eb-329b-b35160ec951e
# ╠═1d388372-2695-11eb-3068-7b28a2ccb9ac
# ╟─53c2eaf6-268b-11eb-0899-b91c03713da4
# ╠═06d28052-2531-11eb-39e2-e9613ab0401c
# ╟─4c9173ac-2685-11eb-2129-99071821ebeb
# ╠═736515ba-2685-11eb-38cb-65bfcf8d1b8d
# ╟─8b06b944-268c-11eb-0bfc-8d4dd21e1f02
# ╟─09ce27ca-268c-11eb-0cdd-c9801db876f8
# ╟─298deff4-2676-11eb-2595-e7e22f613ea1
# ╟─2bbf5a70-2676-11eb-1085-7130d4a30443
# ╟─de95efae-2675-11eb-0909-73afcd68fd42
# ╟─c78e02b4-268a-11eb-0af7-f7c7620fcc34
# ╠═d7801e88-2530-11eb-0b93-6f1c78d00eea
# ╠═607058ec-253c-11eb-0fb6-add8cfb73a4f
# ╟─9c1f73e0-268a-11eb-2bf1-216a5d869568
# ╟─11096250-2544-11eb-057b-d7112f20b05c
# ╠═9eb07a6e-2687-11eb-0de3-7bc6aa0eefb0
# ╟─cb15cd88-25ed-11eb-2be4-f31500a726c8
# ╟─232b9bec-2544-11eb-0401-97a60bb172fc
# ╟─36ea4410-2433-11eb-1d98-ab4016245d95
# ╟─36f8c1e8-2433-11eb-1f6e-69dc552a4a07
# ╟─37061f1e-2433-11eb-3879-2d31dc70a771
# ╟─371352ec-2433-11eb-153d-379afa8ed15e
# ╟─372002e4-2433-11eb-0b25-39ce1b1dd3d1
# ╟─372c1480-2433-11eb-3c4e-95a37d51835f
# ╟─3737be8e-2433-11eb-2049-2d6d8a5e4753
# ╟─374522c4-2433-11eb-3da3-17419949defc
# ╟─37552044-2433-11eb-1984-d16e355a7c10
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
