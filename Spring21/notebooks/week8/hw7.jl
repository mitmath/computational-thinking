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

# ╔═╡ 15187690-0403-11eb-2dfd-fd924faa3513
begin
    using Plots, PlutoUI
end

# ╔═╡ 01341648-0403-11eb-2212-db450c299f35
md"_homework 7, version 3_"

# ╔═╡ 06f30b2a-0403-11eb-0f05-8badebe1011d
md"""

# **Homework 7**: _Epidemic modeling_
`18.S191`, Spring 2021

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 095cbf46-0403-11eb-0c37-35de9562cebc
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 03a85970-0403-11eb-334a-812b59c0905b
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 107e65a4-0403-11eb-0c14-37d8d828b469
md"_Let's create a package environment:_"

# ╔═╡ d8797684-0414-11eb-1869-5b1e2c469011
function bernoulli(p::Number)
	rand() < p
end

# ╔═╡ 61789646-0403-11eb-0042-f3b8308f11ba
md"""
## **Exercise 1:** _Agent-based model for an epidemic outbreak -- types_

In this and the following exercises we will develop a simple stochastic model for combined infection and recovery in a population, which may exhibit an **epidemic outbreak** (i.e. a large spike in the number of infectious people).
The population is **well mixed**, i.e. everyone is in contact with everyone else.
[An example of this would be a small school or university in which people are
constantly moving around and interacting with each other.]

The model is an **individual-based** or **agent-based** model: 
we explicitly keep track of each individual, or **agent**, in the population and their
infection status. For the moment we will not keep track of their position in space;
we will just assume that there is some mechanism, not included in the model, by which they interact with other individuals.

#### Exercise 1.1

Each agent will have its own **internal state**, modelling its infection status, namely "susceptible", "infectious" or "recovered". We would like to code these as values `S`, `I` and `R`, respectively. One way to do this is using an [**enumerated type**](https://en.wikipedia.org/wiki/Enumerated_type) or **enum**. Variables of this type can take only a pre-defined set of values; the Julia syntax is as follows:
"""

# ╔═╡ 26f84600-041d-11eb-1856-b12a3e5c1dc7
@enum InfectionStatus S I R

# ╔═╡ 271ec5f0-041d-11eb-041b-db46ec1465e0
md"""
We have just defined a new type `InfectionStatus`, as well as names `S`, `I` and `R` that are the (only) possible values that a variable of this type can take.

👉 Define a variable `test_status` whose value is `S`. 
"""

# ╔═╡ 7f4e121c-041d-11eb-0dff-cd0cbfdfd606
test_status = missing

# ╔═╡ 7f744644-041d-11eb-08a0-3719cc0adeb7
md"""
👉 Use the `typeof` function to find the type of `test_status`.
"""

# ╔═╡ 88c53208-041d-11eb-3b1e-31b57ba99f05


# ╔═╡ 847d0fc2-041d-11eb-2864-79066e223b45
md"""
👉 Convert `x` to an integer using the `Integer` function. What value does it have? What values do `I` and `R` have?
"""

# ╔═╡ f2792ff5-b0b6-4fcd-94aa-0b6ef048f6ab


# ╔═╡ 860790fc-0403-11eb-2f2e-355f77dcc7af
md"""
#### Exercise 1.2

For each agent we want to keep track of its infection status and the number of *other* agents that it infects during the simulation. A good solution for this is to define a *new type* `Agent` to hold all of the information for one agent, as follows:
"""

# ╔═╡ ae4ac4b4-041f-11eb-14f5-1bcde35d18f2
mutable struct Agent
	status::InfectionStatus
	num_infected::Int64
end

# ╔═╡ ae70625a-041f-11eb-3082-0753419d6d57
md"""
When you define a new type like this, Julia automatically defines one or more **constructors**, which are methods of a generic function with the *same name* as the type. These are used to create objects of that type. 

👉 Use the `methods` function to check how many constructors are pre-defined for the `Agent` type.
"""

# ╔═╡ 60a8b708-04c8-11eb-37b1-3daec644ac90


# ╔═╡ 189cae1e-0424-11eb-2666-65bf297d8bdd
md"""
👉 Create an agent `test_agent` with status `S` and `num_infected` equal to 0.
"""

# ╔═╡ 18d308c4-0424-11eb-176d-49feec6889cf
test_agent = missing

# ╔═╡ 190deebc-0424-11eb-19fe-615997093e14
md"""
👉 For convenience, define a new constructor (i.e. a new method for the function) that takes no arguments and creates an `Agent` with status `S` and number infected 0, by calling one of the default constructors that Julia creates. This new method lives *outside* (not inside) the definition of the `struct`. (It is called an **outer constructor**.)

(In Pluto, a struct definition and an outer constructor need to be combined in a single cell using a `begin end` block.)

Let's check that the new method works correctly. How many methods does the constructor have now?

"""

# ╔═╡ 82f2580a-04c8-11eb-1eea-bdb4e50eee3b
Agent()

# ╔═╡ 8631a536-0403-11eb-0379-bb2e56927727
md"""
#### Exercise 1.3
👉 Write functions `set_status!(a)` and `set_num_infected!(a)` which modify the respective fields of an `Agent`. Check that they work. [Note the bang ("`!`") at the end of the function names to signify that these functions *modify* their argument.]

"""

# ╔═╡ 98beb336-0425-11eb-3886-4f8cfd210288
function set_status!(agent::Agent, new_status::InfectionStatus)
	# your code here
end

# ╔═╡ 866299e8-0403-11eb-085d-2b93459cc141
md"""
👉 We will also need functions `is_susceptible` and `is_infected` that check if a given agent is in those respective states.

"""

# ╔═╡ 9a837b52-0425-11eb-231f-a74405ff6e23
function is_susceptible(agent::Agent)
	
	return missing
end

# ╔═╡ a8dd5cae-0425-11eb-119c-bfcbf832d695
function is_infected(agent::Agent)
	
	return missing
end

# ╔═╡ 8692bf42-0403-11eb-191f-b7d08895274f
md"""
#### Exericse 1.4
👉 Write a function `generate_agents(N)` that returns a vector of `N` freshly created `Agent`s. They should all be initially susceptible, except one, chosen at random (i.e. uniformly), who is infectious.

"""

# ╔═╡ 7946d83a-04a0-11eb-224b-2b315e87bc84
function generate_agents(N::Integer)
	
	return missing
end

# ╔═╡ 488771e2-049f-11eb-3b0a-0de260457731
generate_agents(3)

# ╔═╡ 86d98d0a-0403-11eb-215b-c58ad721a90b
md"""
We will also need types representing different infections. 

Let's define an (immutable) `struct` called `InfectionRecovery` with parameters `p_infection` and `p_recovery`. We will make it a subtype of an abstract `AbstractInfection` type, because we will define more infection types later.
"""

# ╔═╡ 223933a4-042c-11eb-10d3-852229f25a35
abstract type AbstractInfection end

# ╔═╡ 1a654bdc-0421-11eb-2c38-7d35060e2565
struct InfectionRecovery <: AbstractInfection
	p_infection
	p_recovery
end

# ╔═╡ 2d3bba2a-04a8-11eb-2c40-87794b6aeeac
md"""
#### Exercise 1.5
👉 Write a function `interact!` that takes an affected `agent` of type `Agent`, an `source` of type `Agent` and an `infection` of type `InfectionRecovery`.  It implements a single (one-sided) interaction between two agents: 

- If the `agent` is susceptible and the `source` is infectious, then the `source` infects our `agent` with the given infection probability. If the `source` successfully infects the other agent, then its `num_infected` record must be updated.
- If the `agent` is infected then it recovers with the relevant probability.
- Otherwise, nothing happens.

$(html"<span id=interactfunction></span>")
"""

# ╔═╡ 9d0f9564-e393-401f-9dd5-affa4405a9c6
function interact!(agent::Agent, source::Agent, infection::InfectionRecovery)
	
	# your code here
end

# ╔═╡ b21475c6-04ac-11eb-1366-f3b5e967402d
md"""
Play around with the test case below to test your function! Try changing the definitions of `agent`, `source` and `infection`. Since we are working with randomness, you might want to run the cell multiple times.
"""

# ╔═╡ 9c39974c-04a5-11eb-184d-317eb542452c
let
	agent = Agent(S, 0)
	source = Agent(I, 0)
	infection = InfectionRecovery(0.9, 0.5)
	
	interact!(agent, source, infection)
	
	(agent=agent, source=source)
end

# ╔═╡ 619c8a10-0403-11eb-2e89-8b0974fb01d0
md"""
## **Exercise 2:** _Agent-based model for an epidemic outbreak --  Monte Carlo simulation_

In this exercise we will build on Exercise 2 to write a Monte Carlo simulation of how an infection propagates in a population.

Make sure to re-use the functions that we have already written, and introduce new ones if they are helpful! Short functions make it easier to understand what the function does and build up new functionality piece by piece.

You should not use any global variables inside the functions: Each function must accept as arguments all the information it requires to carry out its task. You need to think carefully about what the information each function requires.

#### Exercise 2.1

👉 Write a function `step!` that takes a vector of `Agent`s and an `infection` of type `InfectionRecovery`. It implements a single step of the infection dynamics as follows: 

- Choose two random agents: an `agent` and a `source`.
- Apply `interact!(agent, source, infection)`.
- Return `agents`.

"""

# ╔═╡ 2ade2694-0425-11eb-2fb2-390da43d9695
function step!(agents::Vector{Agent}, infection::InfectionRecovery)
	
end

# ╔═╡ 955321de-0403-11eb-04ce-fb1670dfbb9e
md"""
👉 Write a function `sweep!`. It runs `step!` $N$ times, where $N$ is the number of agents. Thus each agent acts, on average, once per sweep; a sweep is thus the unit of time in our Monte Carlo simulation.
"""

# ╔═╡ 46133a74-04b1-11eb-0b46-0bc74e564680
function sweep!(agents::Vector{Agent}, infection::AbstractInfection)
	
end

# ╔═╡ 95771ce2-0403-11eb-3056-f1dc3a8b7ec3
md"""
👉 Write a function `simulation` that does the following:

1. Generate the $N$ agents.

2. Run `sweep!` a number $T$ of times. Calculate and store the total number of agents with each status at each step in variables `S_counts`, `I_counts` and `R_counts`.

3. Return the vectors `S_counts`, `I_counts` and `R_counts` in a **named tuple**, with keys `S`, `I` and `R`.

You've seen an example of named tuples before: the `student` variable at the top of the notebook!

_Feel free to store the counts in a different way, as long as the return type is the same._
"""

# ╔═╡ 887d27fc-04bc-11eb-0ab9-eb95ef9607f8
function simulation(N::Integer, T::Integer, infection::AbstractInfection)

	return (S=missing, I=missing, R=missing)
end

# ╔═╡ b92f1cec-04ae-11eb-0072-3535d1118494
simulation(3, 20, InfectionRecovery(0.9, 0.2))

# ╔═╡ 2c62b4ae-04b3-11eb-0080-a1035a7e31a2
simulation(100, 1000, InfectionRecovery(0.005, 0.2))

# ╔═╡ 28db9d98-04ca-11eb-3606-9fb89fa62f36
@bind run_basic_sir Button("Run simulation again!")

# ╔═╡ c5156c72-04af-11eb-1106-b13969b036ca
let
	run_basic_sir
	
	N = 100
	T = 1000
	sim = simulation(N, T, InfectionRecovery(0.02, 0.002))
	
	result = plot(1:T, sim.S, ylim=(0, N), label="Susceptible")
	plot!(result, 1:T, sim.I, ylim=(0, N), label="Infectious")
	plot!(result, 1:T, sim.R, ylim=(0, N), label="Recovered")
end

# ╔═╡ bf6fd176-04cc-11eb-008a-2fb6ff70a9cb
md"""
#### Exercise 2.2
Alright! Every time that we run the simulation, we get slightly different results, because it is based on randomness. By running the simulation a number of times, you start to get an idea of the _mean behaviour_ of our model. This is the essence of a Monte Carlo method! You use computer-generated randomness to generate samples.

Instead of pressing the button many times, let's have the computer repeat the simulation. In the next cells, we run your simulation `num_simulations=20` times with $N=100$, $p_\text{infection} = 0.02$, $p_\text{infection} = 0.002$ and $T = 1000$. 

Every single simulation returns a named tuple with the status counts, so the result of multiple simulations will be an array of those. Have a look inside the result, `simulations`, and make sure that its structure is clear.
"""

# ╔═╡ 38b1aa5a-04cf-11eb-11a2-930741fc9076
function repeat_simulations(N, T, infection, num_simulations)
	N = 100
	T = 1000
	
	map(1:num_simulations) do _
		simulation(N, T, infection)
	end
end

# ╔═╡ 80c2cd88-04b1-11eb-326e-0120a39405ea
simulations = repeat_simulations(100, 1000, InfectionRecovery(0.02, 0.002), 20)

# ╔═╡ 80e6f1e0-04b1-11eb-0d4e-475f1d80c2bb
md"""
In the cell below, we plot the evolution of the number of $I$ individuals as a function of time for each of the simulations on the same plot using transparency (`alpha=0.5` inside the plot command).
"""

# ╔═╡ 9cd2bb00-04b1-11eb-1d83-a703907141a7
let
	p = plot()
	
	for sim in simulations
		plot!(p, 1:1000, sim.I, alpha=.5, label=nothing)
	end
	
	p
end

# ╔═╡ 95c598d4-0403-11eb-2328-0175ed564915
md"""
👉 Write a function `sir_mean_plot` that returns a plot of the means of $S$, $I$ and $R$ as a function of time on a single graph.
"""

# ╔═╡ 843fd63c-04d0-11eb-0113-c58d346179d6
function sir_mean_plot(simulations::Vector{<:NamedTuple})
	# you might need T for this function, here's a trick to get it:
	T = length(first(simulations).S)
	
	return missing
end

# ╔═╡ 7f635722-04d0-11eb-3209-4b603c9e843c
sir_mean_plot(simulations)

# ╔═╡ a4c9ccdc-12ca-11eb-072f-e34595520548
let
	T = length(first(simulations).S)
	
	all_S_counts = map(result -> result.S, simulations)
	all_I_counts = map(result -> result.I, simulations)
	all_R_counts = map(result -> result.R, simulations)
	
	(S=round.(sum(all_S_counts) ./ length(simulations) ./ 100, digits=4),
	I=round.(sum(all_I_counts) ./ length(simulations) ./ 100, digits=4),
	R=round.(sum(all_R_counts) ./ length(simulations) ./ 100, digits=4))
	
end

# ╔═╡ dfb99ace-04cf-11eb-0739-7d694c837d59
md"""
👉 Allow $p_\text{infection}$ and $p_\text{recovery}$ to be changed interactively and find parameter values for which you observe an epidemic outbreak.
"""

# ╔═╡ 1c6aa208-04d1-11eb-0b87-cf429e6ff6d0


# ╔═╡ 95eb9f88-0403-11eb-155b-7b2d3a07cff0
md"""
👉 Write a function `sir_mean_error_plot` that does the same as `sir_mean_plot`, which also computes the **standard deviation** $\sigma$ of $S$, $I$, $R$ at each step. Add this to the plot using **error bars**, using the option `yerr=σ` in the plot command; use transparency.

This should confirm that the distribution of $I$ at each step is pretty wide!
"""

# ╔═╡ 287ee7aa-0435-11eb-0ca3-951dbbe69404
function sir_mean_error_plot(simulations::Vector{<:NamedTuple})
	# you might need T for this function, here's a trick to get it:
	T = length(first(simulations).S)
	
	return missing
end

# ╔═╡ 9611ca24-0403-11eb-3582-b7e3bb243e62
md"""
#### Exercise 2.3

👉 Plot the probability distribution of `num_infected`. Does it have a recognisable shape? (Feel free to increase the number of agents in order to get better statistics.)

"""

# ╔═╡ 26e2978e-0435-11eb-0d61-25f552d2771e


# ╔═╡ 9635c944-0403-11eb-3982-4df509f6a556
md"""
#### Exercse 2.4
👉 What are three *simple* ways in which you could characterise the magnitude (size) of the epidemic outbreak? Find approximate values of these quantities for one of the runs of your simulation.

"""

# ╔═╡ 4ad11052-042c-11eb-3643-8b2b3e1269bc


# ╔═╡ 61c00724-0403-11eb-228d-17c11670e5d1
md"""
## **Exercise 3:** _Reinfection_

In this exercise we will *re-use* our simulation infrastructure to study the dynamics of a different type of infection: there is no immunity, and hence no "recovery" rather, susceptible individuals may now be **re-infected** 

#### Exercise 3.1
👉 Make a new infection type `Reinfection`. This has the *same* two fields as `InfectionRecovery` (`p_infection` and `p_recovery`). However, "recovery" now means "becomes susceptible again", instead of "moves to the `R` class. 

This new type `Reinfection` should also be a **subtype** of `AbstractInfection`. This allows us to reuse our previous functions, which are defined for the abstract supertype.
"""

# ╔═╡ 8dd97820-04a5-11eb-36c0-8f92d4b859a8


# ╔═╡ 99ef7b2a-0403-11eb-08ef-e1023cd151ae
md"""
👉 Make a *new method* for the `interact!` function that accepts the new infection type as argument, reusing as much functionality as possible from the previous version. 

"""

# ╔═╡ bbb103d5-c8f9-485b-9337-40892bb60506


# ╔═╡ 9a13b17c-0403-11eb-024f-9b37e95e211b
md"""
#### Exercise 3.2
👉 Run the simulation 20 times and plot $I$ as a function of time for each one, together with the mean over the 20 simulations (as you did in the previous exercises).

Note that you should be able to re-use the `sweep!` and `simulation` functions , since those should be sufficiently **generic** to work with the new `step!` function! (Modify them if they are not.)

"""

# ╔═╡ 1ac4b33a-0435-11eb-36f8-8f3f81ae7844


# ╔═╡ 9a377b32-0403-11eb-2799-e7e59caa6a45
md"""
👉 Run the new simulation and draw $I$ (averaged over runs) as a function of time. Is the behaviour qualitatively the same or different? Describe what you see.


"""

# ╔═╡ 21c50840-0435-11eb-1307-7138ecde0691


# ╔═╡ 531d13c2-0414-11eb-0acd-4905a684869d
if student.name == "Jazzy Doe"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ 4f19e872-0414-11eb-0dfd-e53d2aecc4dc
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 48a16c42-0414-11eb-0e0c-bf52bbb0f618
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 9cf9080a-04b1-11eb-12a0-17013f2d37f5
md"""
👉 Calculate the **mean number of infectious agents** of our simulations for each time step. Add it to the plot using a heavier line (`lw=3` for "linewidth") by modifying the cell above. 

Check the answer yourself: does your curve follow the average trend?

$(hint(md"This exercise requires some creative juggling with arrays, anonymous functions, `map`s, or whatever you see fit!"))
"""

# ╔═╡ 461586dc-0414-11eb-00f3-4984b57bfac5
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ 43e6e856-0414-11eb-19ca-07358aa8b667
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 41cefa68-0414-11eb-3bad-6530360d6f68
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 3f5e0af8-0414-11eb-34a7-a71e7aaf6443
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ 3d88c056-0414-11eb-0025-05d3aff1588b
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 3c0528a0-0414-11eb-2f68-a5657ab9e73d
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 7c515a7a-04d5-11eb-0f36-4fcebff709d5
if !@isdefined(set_status!)
	not_defined(:set_status!)
else
	let
		agent = Agent(I,2)
		
		set_status!(agent, R)
		
		if agent.status == R
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ c4a8694a-04d4-11eb-1eef-c9e037e6b21f
if !@isdefined(is_susceptible)
	not_defined(:is_susceptible)
else
	let
		result1 = is_susceptible(Agent(I,2))
		result2 = is_infected(Agent(I,2))
		
		if result1 isa Missing || result2 isa Missing
			still_missing()
		elseif !(result1 isa Bool) || !(result2 isa Bool)
			keep_working(md"Make sure that you return either `true` or `false`.")
		elseif result1 === false && result2 === true
			if is_susceptible(Agent(S,3)) && !is_infected(Agent(R,9))
				correct()
			else
				keep_working()
			end
		else
			keep_working()
		end
	end
end

# ╔═╡ 393041ec-049f-11eb-3089-2faf378445f3
if !@isdefined(generate_agents)
	not_defined(:generate_agents)
else
	let
		result = generate_agents(4)
		
		if result isa Missing
			still_missing()
		elseif result isa Nothing
			keep_working("The function returned `nothing`. Did you forget to return something?")
		elseif !(result isa Vector) || !all(x -> x isa Agent, result)
			keep_working(md"Make sure that you return an array of objects of the type `Agent`.")
		elseif length(result) != 4
			almost(md"Make sure that you return `N` agents.")
		elseif length(Set(result)) != 4
			almost(md"You returned the **same** agent `N` times. You need to call the `Agent` constructor `N` times, not once.")
		else
			if sum(a -> a.status == I, result) != 1
				almost(md"Exactly one of the agents should be infectious.")
			else
				correct()
			end
		end
	end
end

# ╔═╡ 759bc42e-04ab-11eb-0ab1-b12e008c02a9
if !@isdefined(interact!)
	not_defined(:interact!)
else
	let
		agent = Agent(S, 9)
		source = Agent(I, 0)
		interact!(agent, source, InfectionRecovery(0.0, 1.0))
		
		if source.status != I || source.num_infected != 0
			keep_working(md"The `source` should not be modified if no infection occured.")
		elseif agent.status != S
			keep_working(md"The `agent` should get infected with the right probability.")
		else
			agent = Agent(S, 9)
			source = Agent(S, 0)
			interact!(agent, source, InfectionRecovery(1.0, 1.0))

			if source.status != S || source.num_infected != 0 || agent.status != S
				keep_working(md"The `agent` should get infected with the right probability if the source is infectious.")
			else
				agent = Agent(S, 9)
				source = Agent(I, 3)
				interact!(agent, source, InfectionRecovery(1.0, 1.0))

				if agent.status == R
					almost(md"The agent should not recover immediately after becoming infectious.")
				elseif agent.status == S
					keep_working(md"The `agent` should recover from an infectious state with the right probability.")
				elseif source.status != I || source.num_infected != 4
					almost(md"The `source` did not get updated correctly after infecting the `agent`.")
				else
					correct(md"Your function treats the **susceptible** agent case correctly!")
				end
			end
		end
	end
end

# ╔═╡ 1491a078-04aa-11eb-0106-19a3cf1e94b0
if !@isdefined(interact!)
	not_defined(:interact!)
else
	let
		agent = Agent(I, 9)
		source = Agent(S, 0)

		interact!(agent, source, InfectionRecovery(1.0, 1.0))
		
		if source.status != S || source.num_infected != 0
			keep_working(md"The `source` should not be modified if `agent` is infectious.")
		elseif agent.status != R
			keep_working(md"The `agent` should recover from an infectious state with the right probability.")
		elseif agent.num_infected != 9
			keep_working(md"`agent.num_infected` should not be modified if `agent` is infectious.")
		else
			let
				agent = Agent(I, 9)
				source = Agent(R, 0)

				interact!(agent, source, InfectionRecovery(1.0, 0.0))
				
				if agent.status == R
					keep_working(md"The `agent` should recover from an infectious state with the right probability.")
				else
					correct(md"Your function treats the **infectious** agent case correctly!")
				end
			end
		end
	end
end

# ╔═╡ f8e05d94-04ac-11eb-26d4-6f1d2c5ed272
if !@isdefined(interact!)
	not_defined(:interact!)
else
	let
		agent = Agent(R, 9)
		source = Agent(I, 0)
		interact!(agent, source, InfectionRecovery(1.0, 1.0))
		
		if source.status != I || source.num_infected != 0
			keep_working(md"The `source` should not be modified if no infection occured.")
		elseif agent.status != R || agent.num_infected != 9
			keep_working(md"The `agent` should not be momdified if it is in a recoved state.")
		else
			correct(md"Your function treats the **recovered** agent case correctly!")
		end
	end
end

# ╔═╡ 39dffa3c-0414-11eb-0197-e72b299e9c63
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 2b26dc42-0403-11eb-205f-cd2c23d8cb03
bigbreak

# ╔═╡ 5689841e-0414-11eb-0492-63c77ddbd136
bigbreak

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.29.0"
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

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

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

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

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

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

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

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

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

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
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

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
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

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
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

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
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

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
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

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
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

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

[[NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

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

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d457f881ea56bbfa18222642de51e0abf67b9027"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.0"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

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
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

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

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

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
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "e75d82493681dfd884a357952bbd7ab0608e1dc3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.7"

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

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

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
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

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
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

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

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

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

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

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
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─01341648-0403-11eb-2212-db450c299f35
# ╟─03a85970-0403-11eb-334a-812b59c0905b
# ╟─06f30b2a-0403-11eb-0f05-8badebe1011d
# ╠═095cbf46-0403-11eb-0c37-35de9562cebc
# ╟─107e65a4-0403-11eb-0c14-37d8d828b469
# ╠═15187690-0403-11eb-2dfd-fd924faa3513
# ╟─2b26dc42-0403-11eb-205f-cd2c23d8cb03
# ╠═d8797684-0414-11eb-1869-5b1e2c469011
# ╟─61789646-0403-11eb-0042-f3b8308f11ba
# ╠═26f84600-041d-11eb-1856-b12a3e5c1dc7
# ╟─271ec5f0-041d-11eb-041b-db46ec1465e0
# ╠═7f4e121c-041d-11eb-0dff-cd0cbfdfd606
# ╟─7f744644-041d-11eb-08a0-3719cc0adeb7
# ╠═88c53208-041d-11eb-3b1e-31b57ba99f05
# ╟─847d0fc2-041d-11eb-2864-79066e223b45
# ╠═f2792ff5-b0b6-4fcd-94aa-0b6ef048f6ab
# ╟─860790fc-0403-11eb-2f2e-355f77dcc7af
# ╠═ae4ac4b4-041f-11eb-14f5-1bcde35d18f2
# ╟─ae70625a-041f-11eb-3082-0753419d6d57
# ╠═60a8b708-04c8-11eb-37b1-3daec644ac90
# ╟─189cae1e-0424-11eb-2666-65bf297d8bdd
# ╠═18d308c4-0424-11eb-176d-49feec6889cf
# ╟─190deebc-0424-11eb-19fe-615997093e14
# ╠═82f2580a-04c8-11eb-1eea-bdb4e50eee3b
# ╟─8631a536-0403-11eb-0379-bb2e56927727
# ╠═98beb336-0425-11eb-3886-4f8cfd210288
# ╟─7c515a7a-04d5-11eb-0f36-4fcebff709d5
# ╟─866299e8-0403-11eb-085d-2b93459cc141
# ╠═9a837b52-0425-11eb-231f-a74405ff6e23
# ╠═a8dd5cae-0425-11eb-119c-bfcbf832d695
# ╟─c4a8694a-04d4-11eb-1eef-c9e037e6b21f
# ╟─8692bf42-0403-11eb-191f-b7d08895274f
# ╠═7946d83a-04a0-11eb-224b-2b315e87bc84
# ╠═488771e2-049f-11eb-3b0a-0de260457731
# ╟─393041ec-049f-11eb-3089-2faf378445f3
# ╟─86d98d0a-0403-11eb-215b-c58ad721a90b
# ╠═223933a4-042c-11eb-10d3-852229f25a35
# ╠═1a654bdc-0421-11eb-2c38-7d35060e2565
# ╟─2d3bba2a-04a8-11eb-2c40-87794b6aeeac
# ╠═9d0f9564-e393-401f-9dd5-affa4405a9c6
# ╟─b21475c6-04ac-11eb-1366-f3b5e967402d
# ╠═9c39974c-04a5-11eb-184d-317eb542452c
# ╟─759bc42e-04ab-11eb-0ab1-b12e008c02a9
# ╟─1491a078-04aa-11eb-0106-19a3cf1e94b0
# ╟─f8e05d94-04ac-11eb-26d4-6f1d2c5ed272
# ╟─619c8a10-0403-11eb-2e89-8b0974fb01d0
# ╠═2ade2694-0425-11eb-2fb2-390da43d9695
# ╟─955321de-0403-11eb-04ce-fb1670dfbb9e
# ╠═46133a74-04b1-11eb-0b46-0bc74e564680
# ╟─95771ce2-0403-11eb-3056-f1dc3a8b7ec3
# ╠═887d27fc-04bc-11eb-0ab9-eb95ef9607f8
# ╠═b92f1cec-04ae-11eb-0072-3535d1118494
# ╠═2c62b4ae-04b3-11eb-0080-a1035a7e31a2
# ╠═c5156c72-04af-11eb-1106-b13969b036ca
# ╟─28db9d98-04ca-11eb-3606-9fb89fa62f36
# ╟─bf6fd176-04cc-11eb-008a-2fb6ff70a9cb
# ╠═38b1aa5a-04cf-11eb-11a2-930741fc9076
# ╠═80c2cd88-04b1-11eb-326e-0120a39405ea
# ╟─80e6f1e0-04b1-11eb-0d4e-475f1d80c2bb
# ╠═9cd2bb00-04b1-11eb-1d83-a703907141a7
# ╟─9cf9080a-04b1-11eb-12a0-17013f2d37f5
# ╟─95c598d4-0403-11eb-2328-0175ed564915
# ╠═843fd63c-04d0-11eb-0113-c58d346179d6
# ╠═7f635722-04d0-11eb-3209-4b603c9e843c
# ╠═a4c9ccdc-12ca-11eb-072f-e34595520548
# ╟─dfb99ace-04cf-11eb-0739-7d694c837d59
# ╠═1c6aa208-04d1-11eb-0b87-cf429e6ff6d0
# ╟─95eb9f88-0403-11eb-155b-7b2d3a07cff0
# ╠═287ee7aa-0435-11eb-0ca3-951dbbe69404
# ╟─9611ca24-0403-11eb-3582-b7e3bb243e62
# ╠═26e2978e-0435-11eb-0d61-25f552d2771e
# ╟─9635c944-0403-11eb-3982-4df509f6a556
# ╠═4ad11052-042c-11eb-3643-8b2b3e1269bc
# ╟─61c00724-0403-11eb-228d-17c11670e5d1
# ╠═8dd97820-04a5-11eb-36c0-8f92d4b859a8
# ╟─99ef7b2a-0403-11eb-08ef-e1023cd151ae
# ╠═bbb103d5-c8f9-485b-9337-40892bb60506
# ╟─9a13b17c-0403-11eb-024f-9b37e95e211b
# ╠═1ac4b33a-0435-11eb-36f8-8f3f81ae7844
# ╟─9a377b32-0403-11eb-2799-e7e59caa6a45
# ╠═21c50840-0435-11eb-1307-7138ecde0691
# ╟─5689841e-0414-11eb-0492-63c77ddbd136
# ╟─531d13c2-0414-11eb-0acd-4905a684869d
# ╟─4f19e872-0414-11eb-0dfd-e53d2aecc4dc
# ╟─48a16c42-0414-11eb-0e0c-bf52bbb0f618
# ╟─461586dc-0414-11eb-00f3-4984b57bfac5
# ╟─43e6e856-0414-11eb-19ca-07358aa8b667
# ╟─41cefa68-0414-11eb-3bad-6530360d6f68
# ╟─3f5e0af8-0414-11eb-34a7-a71e7aaf6443
# ╟─3d88c056-0414-11eb-0025-05d3aff1588b
# ╟─3c0528a0-0414-11eb-2f68-a5657ab9e73d
# ╟─39dffa3c-0414-11eb-0197-e72b299e9c63
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
