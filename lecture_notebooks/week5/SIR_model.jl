### A Pluto.jl notebook ###
# v0.11.10

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

# ╔═╡ aaadd68c-01c1-11eb-0aa3-cdf794836f7c
begin
	using Pkg
	Pkg.add.(["Plots", "StatsBase", "PlutoUI", "DataStructures", "GR"])
	
	using DataStructures
	using Plots
	using StatsBase
	using PlutoUI
end

# ╔═╡ 6a201026-01d8-11eb-26ef-eda43c7ee72a
md"""
## SIR models
### Step 1: Define all our types
"""

# ╔═╡ 631ec26c-01cf-11eb-29c2-3548ae2d64b4
md"""
Define infection status.  Here, the values S, I and R are really aliases for the numbers 0, 1 and 2, but this way we can attach this status to the agents in our model in a more readable way.

+ S is for Susceptible, modeling individuals who can catch the disease
+ I is for Infectious, modeling those who can spread it to susceptible agents
+ R is for Recovered, modeling those who can no longer catch the disease
"""

# ╔═╡ 1089ba28-01c2-11eb-2c6c-abbf6a2ba114
@enum InfectionStatus S I R

# ╔═╡ 6730f8f6-0270-11eb-3ab7-31aa3118e7d9
InfectionStatus(2)

# ╔═╡ d6ce5342-01c2-11eb-354a-e92a48999ab1
md"Define an abstract agent type, which can be instantiated by various concrete structs"

# ╔═╡ 7ffad354-0261-11eb-2261-3b600d2399d4
abstract type Agent end

# ╔═╡ 4dad29e2-01c4-11eb-19d9-8be19587a615
mutable struct SimpleAgent <: Agent
	status::InfectionStatus
	num_infected::Int
	
	function SimpleAgent()
		new(S, 0)
	end
end

# ╔═╡ c9c6bd1c-01d7-11eb-1d2d-efd3a00d15dc
md"""
Define a disease type, characterized by the probability that an infectious agent infects a susceptible agent when they interact, along with the probability that an infectious agent recovers on any given day.
"""

# ╔═╡ 605e1f6c-01d6-11eb-0978-d3086226d9a9
mutable struct Disease
	p_infection::Float64
	p_recovery::Float64
end	

# ╔═╡ 99003ce0-01d8-11eb-099a-8f53d4c2ab28
md"""
We need to model when one agent infects another. When two people interact, and if one is infectious while the other is susceptible, there will be some probability that one infects the other
"""

# ╔═╡ 06ef8986-026a-11eb-0f88-21cd04345f93
function infect(agent1::Agent, agent2::Agent)
	if agent1.status == I && agent2.status == S
		agent2.status = I
		agent1.num_infected += 1
	end
end

# ╔═╡ bc6712e4-01ce-11eb-2f76-25a10039815f
function interact(agent1::Agent, agent2::Agent, disease::Disease)
	if rand() < disease.p_infection
		infect(agent1, agent2)
		infect(agent2, agent1)
	end
end

# ╔═╡ 4bef2bf4-026a-11eb-08fb-2f754a857bd9
md"""
With every time step, an infection individual will have some probability of recovering
"""

# ╔═╡ be3c86f2-01d1-11eb-1869-1936bccc2161
function check_for_recovery(agent::Agent, disease::Disease)
	if agent.status == I && rand() < disease.p_recovery
		agent.status = R
	end
end

# ╔═╡ 3519f834-0272-11eb-20ce-9b080c462cb2
begin
	alice = SimpleAgent()
	alice.status = I
	disease = Disease(0.2, 0.5)
	
	check_for_recovery(alice, disease)
	alice
end


# ╔═╡ 756e625a-01da-11eb-0485-6da95a77c3bc
md"## Population dynamics"

# ╔═╡ ebd84202-01c2-11eb-23aa-13be0620662c
md"""
### Fully connected model

First, we'll model a population where every individual has some constant probability of interacting with every other individual.

As a first step, we have a few helper functions to prepare a population where just one person is infections and to pull out the statistics of a population.
"""

# ╔═╡ 06e72a94-0255-11eb-0ea4-7b86f15db2f4
function get_prepared_population(pop_size=500, agent_type=SimpleAgent)
	population = [agent_type() for x in 1:pop_size]
	patient_zero = rand(population)
	patient_zero.status = I
	return population
end

# ╔═╡ 976d4168-0262-11eb-0c76-45ea4f94f4bc
function get_status_counts(agents)
	status_map = countmap([agent.status for agent in agents])
	return [get(status_map, status, 0) for status in (S, I, R)]
end

# ╔═╡ cc23b778-0278-11eb-3ddc-f7be66fb850e
md"""
The heart of the model depends on how agents interact with each other.  For our first pass, we'll do the simplest thing we can think of, albeit very unrealistic, which is to have every pair of agents in the model interact with some probability (mixing_rate)
"""

# ╔═╡ ec76031a-0254-11eb-1707-cf56a0142172
function random_interactions(population, disease, mixing_rate=0.01)
	for i in 1:length(population)
		for j in i+1:length(population)
			if rand() < mixing_rate
				interact(population[i], population[j], disease)
			end
		end
	end
end

# ╔═╡ 36eda15a-0278-11eb-3796-cb4bad8ba8bf
md"""
The goal is to write a function to run a simulation which is as reusable as possible.  It will take in an array of Agents (population), a disease, and a function which determines how interactions happen.

For our first model, we will use the simple random_interactions function written above,but for more sophisticated interaction models you would pass in a different function
"""

# ╔═╡ 82e07bda-01e4-11eb-22f2-1d12499b08e3
function run_simulation(
		population,
		disease,
		population_interaction_function,
		num_steps=200,
	)
	
	status_data = zeros(Int, num_steps, 3)
	for step in 1:num_steps
		# Handle all interactions
		population_interaction_function(population, disease)
		# Handle recovery
		for agent in population
			check_for_recovery(agent, disease)
		end
		status_data[step, :] = get_status_counts(population)
	end
	return status_data
end

# ╔═╡ 2fb4df48-01ec-11eb-16de-87401c517a5f
md"Plot the results"

# ╔═╡ 892b0250-01ec-11eb-3a0c-87fe07c29b2b
function plot_sir_curves(status_data)
	plot(
		status_data,
		m=:o,
		alpha=0.5,
		ms=3,
		xlabel="day",
		ylabel="Number of agents",
		label=["S" "I" "R"],
		color=[:teal :red :grey],
		title="Infection statuses",
	)
end

# ╔═╡ c5a9c814-026a-11eb-1871-6f4d9d334efc
@bind p_infection Slider(0:0.01:0.2, default=0.1, show_value=true)

# ╔═╡ dcb7fbfc-026a-11eb-3b57-5fd058413572
@bind p_recovery Slider(0:0.1:1, default=0.1, show_value=true)

# ╔═╡ 8735d482-0257-11eb-098e-0b07f97200c8
begin
	status_data = run_simulation(
		get_prepared_population(500),
		Disease(p_infection, p_recovery),
		random_interactions,
	)
	plot_sir_curves(status_data)
end

# ╔═╡ 0d757914-0279-11eb-2d76-cd97626fc327
md"""
This function animates what goes on at each step of our simulation.  For now, this is showing the plot of SIR statistics, but for the next section we can have the same function show the locations of each agent in a random walk model.
"""

# ╔═╡ c56aa86e-0265-11eb-00d0-6933df0ad7e6
function animated_simulation(
		population,
		disease,
		population_interaction_function,
		plot_function,
		num_steps=100,
		fps=30,
	)
	
	status_data = zeros(Int, num_steps, 3)
	anim = @animate for step in 1:num_steps
		# Handle all interactions
		population_interaction_function(population, disease)
		# Handle recovery
		for agent in population
			check_for_recovery(agent, disease)
		end
		status_data[step, :] = get_status_counts(population)
		# Plot
		plot_function(status_data[1:step, :], population)
	end
	gif(anim, fps=fps)
end

# ╔═╡ fc856c62-0265-11eb-22f8-6b993a21d305
 animated_simulation(
 	get_prepared_population(500),
 	Disease(0.05, 0.1),
 	random_interactions,
 	(sd, pop) -> plot_sir_curves(sd),
 	200,
 	10,
 )

# ╔═╡ 00809862-01c3-11eb-3270-dde3cf2959f2
md"""
## Random walk model
"""

# ╔═╡ 454a30c2-020e-11eb-16eb-67714cc80e91
city_size = 20

# ╔═╡ 531efbc0-0279-11eb-3e90-d7d65f9ce04a
md"""
Since Wanderer is a subtype of Agent, we can pass in anything of type Wanderer to functions which require input of type Agent.  Note, given how agents are treated above, it's important that Wanderer has "status" and "num_infected" attributes.

If it didn't, that's alright, but we would have to specify how the functions interact and check_for_recovery should respond to inputs of this new type.
"""

# ╔═╡ d2f8ac80-01cd-11eb-3351-f7cc7f605c0d
mutable struct Wanderer <: Agent
	status::InfectionStatus
	num_infected::Int
	x::Int
	y::Int
	
	function Wanderer()
		new(S, 0, rand(1:city_size), rand(1:city_size))
	end
end

# ╔═╡ fb8dec10-020d-11eb-222d-1fbbe80d97b1
function random_step(wanderer::Wanderer)
	if rand() < 0.5
		wanderer.x += rand((-1, 0, 1))
		wanderer.x = clamp(wanderer.x, 1, city_size)
	else
		wanderer.y += rand((-1, 0, 1))
		wanderer.y = clamp(wanderer.y, 1, city_size)
	end
end

# ╔═╡ b450dce2-0279-11eb-29c5-13f707e9c684
md"""
In this new model, agents only interact if they are sufficiently close to each other.
"""

# ╔═╡ 39491330-025f-11eb-3bc9-6988afdea79e
function wanderer_interactions(population, disease)
	for i in 1:length(population)
		for j in i+1:length(population)
			w1 = population[i]
			w2 = population[j]
			if abs(w1.x - w2.x) <= 1 && abs(w1.y - w2.y) <= 1
				interact(w1, w2, disease)
			end
		end
	end
	for wanderer in population
		random_step(wanderer)
	end
end

# ╔═╡ c2cdcbfe-0279-11eb-0718-5d52b5d45926
md"""
Note, we can use the same run_simulation function, but we pass in a different function to reflect the new model for interactions.
"""

# ╔═╡ 31fce8c2-0261-11eb-19a6-21f59a6fa6db
begin
	status_data2 = run_simulation(
		get_prepared_population(500, Wanderer),
		Disease(0.1, 0.05),
		wanderer_interactions,
		200
	)
	plot_sir_curves(status_data2)
end

# ╔═╡ 45422e88-025a-11eb-3c89-1bba07365712
function show_wanderers(wanderers)
	sx, sy, ix, iy, rx, ry = [], [], [], [], [], []
	for wanderer in wanderers
		if wanderer.status==S
			push!(sx, wanderer.x)
			push!(sy, wanderer.y)
		elseif wanderer.status==I
			push!(ix, wanderer.x)
			push!(iy, wanderer.y)
		else
			push!(rx, wanderer.x)
			push!(ry, wanderer.y)
		end
	end
	scatter(
		sx, sy,
		leg=false,
		color=:teal,
		alpha=0.5,
		xlims = (0,city_size + 1),
		ylims = (0,city_size + 1),
	)
	scatter!(ix, iy, color=:red, alpha=0.5, ms=8)
	scatter!(rx, ry, color=:grey, alpha=0.5)
end

# ╔═╡ 40a31a38-0267-11eb-203c-47d02865f438
animated_simulation(
	get_prepared_population(150, Wanderer),
	Disease(0.2, 0.1),
	wanderer_interactions,
	(sd, pop) -> show_wanderers(pop),
	200,
	3,
)

# ╔═╡ Cell order:
# ╟─aaadd68c-01c1-11eb-0aa3-cdf794836f7c
# ╟─6a201026-01d8-11eb-26ef-eda43c7ee72a
# ╟─631ec26c-01cf-11eb-29c2-3548ae2d64b4
# ╠═1089ba28-01c2-11eb-2c6c-abbf6a2ba114
# ╠═6730f8f6-0270-11eb-3ab7-31aa3118e7d9
# ╟─d6ce5342-01c2-11eb-354a-e92a48999ab1
# ╠═7ffad354-0261-11eb-2261-3b600d2399d4
# ╠═4dad29e2-01c4-11eb-19d9-8be19587a615
# ╟─c9c6bd1c-01d7-11eb-1d2d-efd3a00d15dc
# ╠═605e1f6c-01d6-11eb-0978-d3086226d9a9
# ╟─99003ce0-01d8-11eb-099a-8f53d4c2ab28
# ╠═06ef8986-026a-11eb-0f88-21cd04345f93
# ╠═bc6712e4-01ce-11eb-2f76-25a10039815f
# ╟─4bef2bf4-026a-11eb-08fb-2f754a857bd9
# ╠═be3c86f2-01d1-11eb-1869-1936bccc2161
# ╠═3519f834-0272-11eb-20ce-9b080c462cb2
# ╟─756e625a-01da-11eb-0485-6da95a77c3bc
# ╟─ebd84202-01c2-11eb-23aa-13be0620662c
# ╠═06e72a94-0255-11eb-0ea4-7b86f15db2f4
# ╠═976d4168-0262-11eb-0c76-45ea4f94f4bc
# ╟─cc23b778-0278-11eb-3ddc-f7be66fb850e
# ╠═ec76031a-0254-11eb-1707-cf56a0142172
# ╟─36eda15a-0278-11eb-3796-cb4bad8ba8bf
# ╠═82e07bda-01e4-11eb-22f2-1d12499b08e3
# ╟─2fb4df48-01ec-11eb-16de-87401c517a5f
# ╟─892b0250-01ec-11eb-3a0c-87fe07c29b2b
# ╠═c5a9c814-026a-11eb-1871-6f4d9d334efc
# ╠═dcb7fbfc-026a-11eb-3b57-5fd058413572
# ╠═8735d482-0257-11eb-098e-0b07f97200c8
# ╟─0d757914-0279-11eb-2d76-cd97626fc327
# ╟─c56aa86e-0265-11eb-00d0-6933df0ad7e6
# ╠═fc856c62-0265-11eb-22f8-6b993a21d305
# ╟─00809862-01c3-11eb-3270-dde3cf2959f2
# ╠═454a30c2-020e-11eb-16eb-67714cc80e91
# ╟─531efbc0-0279-11eb-3e90-d7d65f9ce04a
# ╠═d2f8ac80-01cd-11eb-3351-f7cc7f605c0d
# ╠═fb8dec10-020d-11eb-222d-1fbbe80d97b1
# ╟─b450dce2-0279-11eb-29c5-13f707e9c684
# ╠═39491330-025f-11eb-3bc9-6988afdea79e
# ╟─c2cdcbfe-0279-11eb-0718-5d52b5d45926
# ╠═31fce8c2-0261-11eb-19a6-21f59a6fa6db
# ╟─45422e88-025a-11eb-3c89-1bba07365712
# ╠═40a31a38-0267-11eb-203c-47d02865f438
