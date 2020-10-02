### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ 12cc2940-0403-11eb-19a7-bb570de58f6f
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 15187690-0403-11eb-2dfd-fd924faa3513
begin
	Pkg.add(["Plots", "PlutoUI",])

	using Plots
	plotly()
	using PlutoUI
end

# ╔═╡ 01341648-0403-11eb-2212-db450c299f35
md"_homework 4, version 1_"

# ╔═╡ 06f30b2a-0403-11eb-0f05-8badebe1011d
md"""

# **Homework 4**: _Epidemic modeling I_
`18.S191`, fall 2020

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

# ╔═╡ 1d3356c4-0403-11eb-0f48-01b5eb14a585
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/Yx055xdSkx0?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ df8547b4-0400-11eb-07c6-fb370b61c2b6
md"""
## **Exercise 1:** _Modelling recovery_

In this exercise we will investigate a simple stochastic (probabilistic) model of recovery from an infection and
the time $\tau$ needed to recover. Although this model can be easily studied analytically using probability theory, we will instead use computational methods. (If you know about this distribution already, try to ignore what you know about it!)

In this model, an individual who is infected has a constant probability $p$ to recover each day. If they recover on day $n$ then $\tau$ takes the value $n$. Each time we run a new experiment $\tau$ will take on different values, so $\tau$ is a (discrete) random variable. We thus need to study statistical properties of $\tau$, such as its mean and its probability distribution.

#### Exercise 1.1 - _Probability distributions_

👉 Define the function `bernoulli(p)`, which returns `true` with probability $p$ and `false` with probability $(1 - p)$.

"""

# ╔═╡ 02b0c2fc-0415-11eb-2b40-7bca8ea4eef9
function bernoulli(p::Number)
	
	return missing
end

# ╔═╡ 76d117d4-0403-11eb-05d2-c5ea47d06f43
md"""
👉 Write a function `recovery_time(p)` that returns the time taken until the person recovers. 
"""

# ╔═╡ d57c6a5a-041b-11eb-3ab4-774a2d45a891
function recovery_time(p)
	if p ≤ 0
		throw(ArgumentError("p must be positive: p = 0 cannot result in a recovery"))
	end
	
	# Your code here. See the comment below about the p ≤ 0 case.
	return missing
end

# ╔═╡ 6db6c894-0415-11eb-305a-c75b119d89e9
md"""
We should always be aware of special cases (sometimes called "boundary conditions"). Make sure *not* to run the code with $p=0$! What would happen in that case? Your code should check for this and throw an `ArgumentError` as follows:

```julia
throw(ArgumentError("..."))  
```

with a suitable error message.
    
"""

# ╔═╡ 6de37d6c-0415-11eb-1b05-85ac820016c7
md"""
👉 What happens for $p=1$? 
"""

# ╔═╡ 73047bba-0416-11eb-1047-23e9c3dbde05
interpretation_of_p_equals_one = md"""
blablabla
"""

# ╔═╡ 76f62d64-0403-11eb-27e2-3de58366b619
md"""
#### Exercise 1.2
👉 Write a function `do_experiment(p, N)` that runs the function `recovery_time` `N` times and collects the results into a vector.
"""

# ╔═╡ c5c7cb86-041b-11eb-3360-45463105f3c9
function do_experiment(p, N)
	
	return missing
end

# ╔═╡ d8abd2f6-0416-11eb-1c2a-f9157d9760a7
small_experiment = do_experiment(0.5, 20)

# ╔═╡ 771c8f0c-0403-11eb-097e-ab24d0714ad5
md"""
#### Exercise 1.3
👉 Write a function `frequencies(data)` that calculates and returns the frequencies (i.e. probability distribution) of input data.

The input will be an array of integers, **with duplicates**, and the result will be a dictionary that maps each occured value to its frequency in the data.

For example,
```julia
frequencies([7, 8, 9, 7])
```
should give
```julia
Dict(
	7 => 0.5, 
	8 => 0.25, 
	9 => 0.25
)
```

As with any probability distribution, it should be normalised to $1$, in the sense that the *total* probability should be $1$.
"""

# ╔═╡ 105d347e-041c-11eb-2fc8-1d9e5eda2be0
function frequencies(values)
	
	return missing
end

# ╔═╡ 1ca7a8c2-041a-11eb-146a-15b8cdeaea72
frequencies(small_experiment)

# ╔═╡ 77428072-0403-11eb-0068-81e3728f2ebe
md"""
Let's run an experiment with $p=0.25$ and $N=10,000$.
"""

# ╔═╡ 4b3ec86c-0419-11eb-26fd-cbbfdf19afa8
large_experiment = do_experiment(0.25, 10_000) 
# (10_000 is just 10000 but easier to read)

# ╔═╡ dc784864-0430-11eb-1478-d1153e017310
md"""
The frequencies dictionary is difficult to interpret on its own, so instead, we will **plot** it, i.e. plot $P(\tau = n)$ against $n$, where $n$ is the recovery time.

Plots.jl comes with a function `bar`, which does exactly what we want:
"""

# ╔═╡ 8a28c56e-04b4-11eb-279c-3b4dfb2a9f9b
bar(frequencies(large_experiment))

# ╔═╡ 9374e63c-0493-11eb-0952-4b97512d7cdb
md"""
Great! Feel free to experiment with this function, try giving it a different array as argument. Plots.jl is pretty clever, it even works with an array of strings!

#### Exercise 1.4
Next, we want to **add a new element** to our plot: a vertical line. To demonstrate how this works, here we added a vertical line at the _maximum value_.

To write this function, we first create a **base plot**, we then **modify** that plot to add the vertical line, and finally, we **return** the plot. More on this in [the next info box](#note_about_plotting).
"""

# ╔═╡ 823364ce-041c-11eb-2467-7ffa4f751527
function frequencies_plot_with_maximum(data::Vector)
	base = bar(frequencies(data))
	vline!(base, [maximum(data)], label="maximum")
	
	return base
end

# ╔═╡ 1ddbaa18-0494-11eb-1fc8-250ab6ae89f1
frequencies_plot_with_maximum(large_experiment)

# ╔═╡ f3f81172-041c-11eb-2b9b-e99b7b9400ed
md"""
$(html"<span id=note_about_plotting></span>")
> ### Note about plotting
> 
> Plots.jl has an interesting property: a plot is an object, not an action. Functions like `plot`, `bar`, `histogram` don't draw anything on your screen - they just return a `Plots.Plot`. This is a struct that contains the _description_ of a plot (what data should be plotted in what way?), not the _picture_.
> 
> So a Pluto cell with a single line, `plot(1:10)`, will show a plot, because the _result_ of the function `plot` is a `Plot` object, and Pluto just shows the result of a cell.
>
> ##### Modifying plots
> Nice plots are often formed by overlaying multiple plots. In Plots.jl, this is done using the **modifying functions**: `plot!`, `bar!`, `vline!`, etc. These take an extra (first) argument: a previous plot to modify.
> 
> For example, to plot the `sin`, `cos` and `tan` functions in the same view, we do:
> ```julia
> function sin_cos_plot()
>     T = -1.0:0.01:1.0
>     
>     result = plot(T, sin.(T))
>     plot!(result, T, cos.(T))
>     plot!(result, T, tan.(T))
>
>     return result
> end
> ```
> 
> 💡 This example demonstrates a useful pattern to combine plots:
> 1. Create a **new** plot and store it in a variable
> 2. **Modify** that plot to add more elements
> 3. Return the plot
> 
> It is recommended that these 3 steps happen **within a single cell**. This can prevent some strange glitches when re-running cells. There are three ways to group expressions together into a single cell: `begin`, `let` and `function`. More on this [later](#function_begin_let)!
"""

# ╔═╡ 7768a2dc-0403-11eb-39b7-fd660dc952fe
md"""
👉 Write the function `frequencies_plot_with_mean` that calculates the mean recovery time and displays it using a vertical line. 
"""

# ╔═╡ f1f89502-0494-11eb-2303-0b79d8bbd13f
function frequencies_plot_with_mean(data)
	# start out by copying the frequencies_plot_with_maximum function
	
	return missing
end

# ╔═╡ 06089d1e-0495-11eb-0ace-a7a7dc60e5b2
frequencies_plot_with_mean(large_experiment)

# ╔═╡ 77b54c10-0403-11eb-16ad-65374d29a817
md"""
👉 Write an interactive visualization that draws the histogram and mean for $p$ between $0.01$ (not $0$!) and $1$, and $N$ between $1$ and $100,000$, say. To avoid a naming conflict, call them `p_interactive` and `N_interactive`, instead of just `p` and `N`.
"""

# ╔═╡ bb63f3cc-042f-11eb-04ff-a128aec3c378


# ╔═╡ bb8aeb58-042f-11eb-18b8-f995631df619
md"""
As you separately vary $p$ and $N$, what do you observe about the **mean** in each case? Does that make sense?
"""

# ╔═╡ 778ec25c-0403-11eb-3146-1d11c294bb1f
md"""
#### Exercise 1.5
👉 What shape does the distribution seem to have? Can you verify that by adding a second plot with the expected shape?
"""

# ╔═╡ 7bb8e426-0495-11eb-3a8b-cbbab61a1631


# ╔═╡ 77db111e-0403-11eb-2dea-4b42ceed65d6
md"""
#### Exercise 1.6
👉 Use $N = 10,000$ to calculate the mean time $\langle \tau(p) \rangle$ to recover as a function of $p$ between $0.001$ and $1$ (say). Plot this relationship.

"""

# ╔═╡ 7335de44-042f-11eb-2873-8bceef722432


# ╔═╡ 61789646-0403-11eb-0042-f3b8308f11ba
md"""
## **Exercise 2:** _Agent-based model for an epidemic outbreak -- types_

In this and the following exercises we will develop a simple stochastic model for combined infection and recovery in a population, which may exhibit an **epidemic outbreak** (i.e. a large spike in the number of infectious people).
The population is **well mixed**, i.e. everyone is in contact with everyone else.
[An example of this would be a small school or university in which people are
constantly moving around and interacting with each other.]

The model is an **individual-based** or **agent-based** model: 
we explicitly keep track of each individual, or **agent**, in the population and their
infection status. For the moment we will not keep track of their position in space;
we will just assume that there is some mechanism, not included in the model, by which they interact with other individuals.

#### Exercise 2.1

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

# ╔═╡ 860790fc-0403-11eb-2f2e-355f77dcc7af
md"""
#### Exercise 2.2

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

(In Pluto, multiple methods for the same function need to be combined in a single cell using a `begin end` block.)

Let's check that the new method works correctly. How many methods does the constructor have now?

"""

# ╔═╡ 82f2580a-04c8-11eb-1eea-bdb4e50eee3b
Agent()

# ╔═╡ 8631a536-0403-11eb-0379-bb2e56927727
md"""
#### Exercise 2.3
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
#### Exericse 2.4
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
#### Exercise 2.5
👉 Write a function `interact!` that takes an affected `agent` of type `Agent`, an `source` of type `Agent` and an `infection` of type `InfectionRecovery`.  It implements a single (one-sided) interaction between two agents: 

- If the `agent` is susceptible and the `source` is infectious, then the `source` infects our `agent` with the given infection probability. If the `source` successfully infects the other agent, then its `num_infected` record must be updated.
- If the `agent` is infected then it recovers with the relevant probability.
- Otherwise, nothing happens.

$(html"<span id=interactfunction></span>")
"""

# ╔═╡ 406aabea-04a5-11eb-06b8-312879457c42
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
## **Exercise 3:** _Agent-based model for an epidemic outbreak --  Monte Carlo simulation_

In this exercise we will build on Exercise 2 to write a Monte Carlo simulation of how an infection propagates in a population.

Make sure to re-use the functions that we have already written, and introduce new ones if they are helpful! Short functions make it easier to understand what the function does and build up new functionality piece by piece.

You should not use any global variables inside the functions: Each function must accept as arguments all the information it requires to carry out its task. You need to think carefully about what the information each function requires.

#### Exercise 3.1

👉 Write a function `step!` that takes a vector of `Agent`s and an `infection` of type `InfectionRecovery`. It implements a single step of the infection dynamics as follows: 

- Choose two random agents: an `agent` and a `source`.
- Apply `interact!(agent, source, infection)`.
- Return `agents`.

"""

# ╔═╡ 2ade2694-0425-11eb-2fb2-390da43d9695
function step!(agents::Vector{Agent}, infection::AbstractInfection)
	# your code here
end

# ╔═╡ 955321de-0403-11eb-04ce-fb1670dfbb9e
md"""
👉 Write a function `sweep!`. It runs `step!` $N$ times, where $N$ is the number of agents. Thus each agent acts, on average, once per sweep; a sweep is thus the unit of time in our Monte Carlo simulation.
"""

# ╔═╡ 46133a74-04b1-11eb-0b46-0bc74e564680
function sweep!(agents::Vector{Agent}, infection::AbstractInfection)
	# your code here
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

	# your code here
	
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

# ╔═╡ 0a967f38-0493-11eb-0624-77e40b24d757
md"""
We used a `let` block in this cell to group multiple expressions together, but how is it different from `begin` or `function`?

$(html"<span id=function_begin_let></span>")
> ##### _**function**_ vs. _**begin**_ vs. _**let**_
> Writing functions is a way to group multiple expressions (i.e. lines of code) together into a mini-program. Note the following about functions:
> - A function always returns **one object**.[^1] This object can be given explicitly by writing `return x`, or implicitly: Julia functions always return the result of the last expression by default. So `f(x) = x+2` is the same as `f(x) = return x+2`.
> - Variables defined inside a function are _not accessible outside the function_. We say that function bodies have a **local scope**. This helps to keep your program easy to read and write: if you define a local variable, then you don't need to worry about it in the rest of the notebook.
> 
> There are two other ways to group epxressions together that you might have seen before: `begin` and `let`.
> 
> ###### begin
> **`begin`** will group expressions together, and it takes the value of its last subexpression. 
>     
> We use it in this notebook when we want multiple expressions to always run together.
> 
> ###### let
> **`let`** also groups multiple expressions together into one, but variables defined inside of it are **local**: they don't affect code outside of the block. So like `begin`, it is just a block of code, but like `function`, it has a local variable scope.
> 
> We use it when we want to define some local (temporary) variables to produce a complicated result, without interfering with other cells. Pluto allows only one definition per _global_ variable of the same name, but you can define _local_ variables with the same names whenever you wish!
> 
> [^1]: Even a function like 
>     
>     `f(x) = return`
>     
>     returns **one object**: the object `nothing` — try it out!
"""

# ╔═╡ bf6fd176-04cc-11eb-008a-2fb6ff70a9cb
md"""
#### Exercise 3.2
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
#### Exercise 3.3

👉 Plot the probability distribution of `num_infected`. Does it have a recognisable shape? (Feel free to increase the number of agents in order to get better statistics.)

"""

# ╔═╡ 26e2978e-0435-11eb-0d61-25f552d2771e


# ╔═╡ 9635c944-0403-11eb-3982-4df509f6a556
md"""
#### Exercse 3.4
👉 What are three *simple* ways in which you could characterise the magnitude (size) of the epidemic outbreak? Find approximate values of these quantities for one of the runs of your simulation.

"""

# ╔═╡ 4ad11052-042c-11eb-3643-8b2b3e1269bc


# ╔═╡ 61c00724-0403-11eb-228d-17c11670e5d1
md"""
## **Exercise 4:** _Reinfection_

In this exercise we will *re-use* our simulation infrastructure to study the dynamics of a different type of infection: there is no immunity, and hence no "recovery" rather, susceptible individuals may now be **re-infected** 

#### Exercise 4.1
👉 Make a new infection type `Reinfection`. This has the *same* two fields as `InfectionRecovery` (`p_infection` and `p_recovery`). However, "recovery" now means "becomes susceptible again", instead of "moves to the `R` class. 

This new type `Reinfection` should also be a **subtype** of `AbstractInfection`. This allows us to reuse our previous functions, which are defined for the abstract supertype.
"""

# ╔═╡ 8dd97820-04a5-11eb-36c0-8f92d4b859a8


# ╔═╡ 99ef7b2a-0403-11eb-08ef-e1023cd151ae
md"""
👉 Make a *new method* for the `interact!` function that accepts the new infection type as argument, reusing as much functionality as possible from the previous version. 

Write it in the same cell as [our previous `interact!` method](#interactfunction), and use a `begin` block to group the two definitions together.

"""

# ╔═╡ 9a13b17c-0403-11eb-024f-9b37e95e211b
md"""
#### Exercise 4.2
👉 Run the simulation 20 times and plot $I$ as a function of time for each one, together with the mean over the 20 simulations (as you did in the previous exercises).

Note that you should be able to re-use the `sweep!` and `simulation` functions , since those should be sufficiently **generic** to work with the new `step!` function! (Modify them if they are not.)

"""

# ╔═╡ 1ac4b33a-0435-11eb-36f8-8f3f81ae7844


# ╔═╡ 9a377b32-0403-11eb-2799-e7e59caa6a45
md"""
👉 Run the new simulation and draw $I$ (averaged over runs) as a function of time. Is the behaviour qualitatively the same or different? Describe what you see.


"""

# ╔═╡ 21c50840-0435-11eb-1307-7138ecde0691


# ╔═╡ da49710e-0420-11eb-092e-4f1173868738
md"""
## **Exercise 5** - _Lecture transcript_
(MIT students only)
Please see the link for hw 4 transcript document on [Canvas](https://canvas.mit.edu/courses/5637).
We want each of you to correct about 400 lines, but don’t spend more than 15 minutes on it.
See the the beginning of the document for more instructions.
:point_right: Please mention the name of the video(s) and the line ranges you edited:
"""

# ╔═╡ e6219c7c-0420-11eb-3faa-13126f7c8007
lines_i_edited = md"""
Abstraction, lines 1-219

Array Basics, lines 1-137

Course Intro, lines 1-44 

(_for example_)
"""

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

# ╔═╡ 6d906d0c-0415-11eb-0c1c-b5c0aca841db
hint(md"Remember to always re-use work you have done previously: in this case you should re-use the function `bernoulli`.")

# ╔═╡ 08e2bc64-0417-11eb-1457-21c0d18e8c51
hint(md"""
Do you remember how we worked with dictionaries in Homework 3? You can create an empty dictionary using `Dict()`. You may want to use either the function `haskey` or the function `get` on your dictionary -- check the documentation for how to use these functions.
""")

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

# ╔═╡ b817f466-04d4-11eb-0a26-c1c667f9f7f7
if !@isdefined(bernoulli)
	not_defined(:bernoulli)
else
	let
		result = bernoulli(0.5)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Bool)
			keep_working(md"Make sure that you return either `true` or `false`.")
		else
			if bernoulli(0.0) == false && bernoulli(1.0) == true
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ c61f35ea-04d6-11eb-2503-17a79f8d0298
if !@isdefined(recovery_time)
	not_defined(:recovery_time)
else
	let
		result = recovery_time(1.0)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Integer)
			keep_working(md"Make sure that you return an integer: the recovery time.")
		else
			if result == 1
				samples = [recovery_time(0.2) for _ in 1:256]
				
				a, b = extrema(samples)
				if a == 1 && b > 20
					correct()
				else
					keep_working()
				end
			else
				keep_working(md"`p = 1.0` should return `1`: the agent recovers after the first time step.")
			end
		end
	end
end

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

# ╔═╡ Cell order:
# ╟─01341648-0403-11eb-2212-db450c299f35
# ╟─03a85970-0403-11eb-334a-812b59c0905b
# ╟─06f30b2a-0403-11eb-0f05-8badebe1011d
# ╠═095cbf46-0403-11eb-0c37-35de9562cebc
# ╟─107e65a4-0403-11eb-0c14-37d8d828b469
# ╠═12cc2940-0403-11eb-19a7-bb570de58f6f
# ╠═15187690-0403-11eb-2dfd-fd924faa3513
# ╟─1d3356c4-0403-11eb-0f48-01b5eb14a585
# ╟─2b26dc42-0403-11eb-205f-cd2c23d8cb03
# ╟─df8547b4-0400-11eb-07c6-fb370b61c2b6
# ╠═02b0c2fc-0415-11eb-2b40-7bca8ea4eef9
# ╟─b817f466-04d4-11eb-0a26-c1c667f9f7f7
# ╟─76d117d4-0403-11eb-05d2-c5ea47d06f43
# ╠═d57c6a5a-041b-11eb-3ab4-774a2d45a891
# ╟─c61f35ea-04d6-11eb-2503-17a79f8d0298
# ╟─6d906d0c-0415-11eb-0c1c-b5c0aca841db
# ╟─6db6c894-0415-11eb-305a-c75b119d89e9
# ╟─6de37d6c-0415-11eb-1b05-85ac820016c7
# ╠═73047bba-0416-11eb-1047-23e9c3dbde05
# ╟─76f62d64-0403-11eb-27e2-3de58366b619
# ╠═c5c7cb86-041b-11eb-3360-45463105f3c9
# ╠═d8abd2f6-0416-11eb-1c2a-f9157d9760a7
# ╟─771c8f0c-0403-11eb-097e-ab24d0714ad5
# ╠═105d347e-041c-11eb-2fc8-1d9e5eda2be0
# ╠═1ca7a8c2-041a-11eb-146a-15b8cdeaea72
# ╟─08e2bc64-0417-11eb-1457-21c0d18e8c51
# ╟─77428072-0403-11eb-0068-81e3728f2ebe
# ╠═4b3ec86c-0419-11eb-26fd-cbbfdf19afa8
# ╟─dc784864-0430-11eb-1478-d1153e017310
# ╠═8a28c56e-04b4-11eb-279c-3b4dfb2a9f9b
# ╟─9374e63c-0493-11eb-0952-4b97512d7cdb
# ╠═823364ce-041c-11eb-2467-7ffa4f751527
# ╠═1ddbaa18-0494-11eb-1fc8-250ab6ae89f1
# ╟─f3f81172-041c-11eb-2b9b-e99b7b9400ed
# ╟─7768a2dc-0403-11eb-39b7-fd660dc952fe
# ╠═f1f89502-0494-11eb-2303-0b79d8bbd13f
# ╠═06089d1e-0495-11eb-0ace-a7a7dc60e5b2
# ╟─77b54c10-0403-11eb-16ad-65374d29a817
# ╠═bb63f3cc-042f-11eb-04ff-a128aec3c378
# ╟─bb8aeb58-042f-11eb-18b8-f995631df619
# ╟─778ec25c-0403-11eb-3146-1d11c294bb1f
# ╠═7bb8e426-0495-11eb-3a8b-cbbab61a1631
# ╟─77db111e-0403-11eb-2dea-4b42ceed65d6
# ╠═7335de44-042f-11eb-2873-8bceef722432
# ╟─61789646-0403-11eb-0042-f3b8308f11ba
# ╠═26f84600-041d-11eb-1856-b12a3e5c1dc7
# ╟─271ec5f0-041d-11eb-041b-db46ec1465e0
# ╠═7f4e121c-041d-11eb-0dff-cd0cbfdfd606
# ╟─7f744644-041d-11eb-08a0-3719cc0adeb7
# ╠═88c53208-041d-11eb-3b1e-31b57ba99f05
# ╟─847d0fc2-041d-11eb-2864-79066e223b45
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
# ╠═406aabea-04a5-11eb-06b8-312879457c42
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
# ╟─0a967f38-0493-11eb-0624-77e40b24d757
# ╟─bf6fd176-04cc-11eb-008a-2fb6ff70a9cb
# ╠═38b1aa5a-04cf-11eb-11a2-930741fc9076
# ╠═80c2cd88-04b1-11eb-326e-0120a39405ea
# ╟─80e6f1e0-04b1-11eb-0d4e-475f1d80c2bb
# ╠═9cd2bb00-04b1-11eb-1d83-a703907141a7
# ╟─9cf9080a-04b1-11eb-12a0-17013f2d37f5
# ╟─95c598d4-0403-11eb-2328-0175ed564915
# ╠═843fd63c-04d0-11eb-0113-c58d346179d6
# ╠═7f635722-04d0-11eb-3209-4b603c9e843c
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
# ╟─9a13b17c-0403-11eb-024f-9b37e95e211b
# ╠═1ac4b33a-0435-11eb-36f8-8f3f81ae7844
# ╟─9a377b32-0403-11eb-2799-e7e59caa6a45
# ╠═21c50840-0435-11eb-1307-7138ecde0691
# ╟─da49710e-0420-11eb-092e-4f1173868738
# ╠═e6219c7c-0420-11eb-3faa-13126f7c8007
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
