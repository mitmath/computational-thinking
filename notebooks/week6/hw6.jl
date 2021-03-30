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

# ╔═╡ 8c8388cf-9891-423c-8db2-d40d870bb38e
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="PlutoUI",version="0.7"),
			Pkg.PackageSpec(name="Plots"),

			])

	using PlutoUI, Plots
end

# ╔═╡ eadb174e-2c1d-48c8-9de2-99cdc2b38d32
md"_homework 6, version 3_"

# ╔═╡ 082542fe-f89d-4774-be20-1e1a78f21291
md"""

# **Homework 6**: _Probability distributions_
`18.S191`, Spring 2021

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 6f4274b5-87e2-420d-83d2-83a8408650cd
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 0560cf7b-9986-402a-9c40-779ea7a7292d
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ aaa41509-a62d-417b-bca7-a120e3a5e5b2
md"""
#### Intializing packages
_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ 6c6e055a-8c4c-11eb-14a7-6d3036e248b9
md"""

## **Exercise 1:** _Calculating frequencies_

In this exercise we practise using dictionaries in Julia by writing our own version of the `countmap` function. Recall that that function counts the number of times that a given (discrete) value occurs in an input data set.

A suitable data structure for this is a **dictionary**, since it allows us to store data that is very sparse (i.e. for which many input values do not occur).
"""

# ╔═╡ 2bebafd4-8c4d-11eb-14ba-27ab7eb763c1
function counts(data::Vector)
	counts = Dict{Int, Int}()
	
	# your code here
	
	return counts
end

# ╔═╡ d025d432-23d0-4a6b-8b09-cc1114367b8f
counts([7, 8, 9, 7])

# ╔═╡ 17faeb5e-8c4d-11eb-3589-c96e799b8a52
md"""
Test that your code is correct by applying it to obtain the counts of the data vector `test_data` defined below. What should the result be? Test that you do get the correct result and call the result `test_counts`.
"""

# ╔═╡ 5e6f16fc-04a0-4774-8ce0-78953e047269
test_data = [1, 0, 1, 0, 1000, 1, 1, 1000]

# ╔═╡ 49b9e55c-1179-4bee-844e-62ae36d20a5d
test_counts = counts(test_data)

# ╔═╡ 18031e1e-8c4d-11eb-006b-adaf55d54282
md"""
#### Exercise 1.2
The dictionary contains the information as a sequence of **pairs** mapping keys to values. This is not a particularly useful form for us. Instead, we would prefer a vector of the keys and a vector of the values, sorted in order of the key.

We are going to make a new version `counts2` where you do the following (below). Start off by just running the following commands each in their own cell on the dictionary `test_counts` you got by running the previous `counts` function on the vector `test_data` so that you see the result of running each command. Once you have understood what's happening at *each* step, add them to the `counts2` function in a new cell.

👉 Extract vectors `ks` of keys and `vs` of values using the `keys()` and `values()` functions and convert the results into a vector using the `collect` function.
"""

# ╔═╡ 4bbbbd24-d592-4ce3-a619-b7f760672b99


# ╔═╡ 44d0f365-b2a8-41a2-98d3-0aa34e8c80c0


# ╔═╡ 18094d52-8c4d-11eb-0620-d30c24a8c75e
md"""
👉 Define a variable `perm` as the result of running the function `sortperm` on the keys. This gives a **permutation** that tells you in which order you need to take the keys to give a sorted version.
"""

# ╔═╡ c825f913-9545-4dbd-96f9-5f7621fc242d


# ╔═╡ 180fc1d2-8c4d-11eb-0362-230d84d47c7f
md"""

👉 Use indexing `ks[perm]` to find the sorted keys and values vectors.  

[Here we are passing in a *vector* as the index. Julia extracts the values at the indices given in that vector]
"""

# ╔═╡ fde456e5-9985-4939-af59-9b9a92313b61


# ╔═╡ cc6923ff-09e0-44cc-9385-533182c4382d


# ╔═╡ 18103c98-8c4d-11eb-2bed-ed20aba64ae6
md"""
Verify that your new `counts2` function gives the correct result for the vector `v` by comparing it to the true result (that you get by doing the counting by hand!)
"""

# ╔═╡ bfa216a2-ffa6-4716-a057-62a58fd9f04a
md"""
👉 Create the function `counts2` that performs these steps.
"""

# ╔═╡ 156c1bea-8c4f-11eb-3a7a-793d0a056f80
function counts2(data::Vector)
	
	return missing
end

# ╔═╡ 37294d02-8c4f-11eb-141e-0be49ea07611
counts2(test_data)

# ╔═╡ 18139dc0-8c4d-11eb-0c31-a75361ed7321
md"""
#### Exercise 1.3
👉 Make a function `probability_distribution` that normalizes the result of `counts2` to calculate the relative frequencies of each value, i.e. to give a probability distribution (i.e. such that the sum of the resulting vector is 1).

The function should return the keys (the unique data that was in the original data set, as calculated in `counts2`, and the probabilities (relative frequencies).

Test that it gives the correct result for the vector `vv`.

We will use this function in the rest of the exercises.
"""

# ╔═╡ 447bc642-8c4f-11eb-1d4f-750e883b81fb
function probability_distribution(data::Vector)
	
	return missing
end

# ╔═╡ 6b1dc96a-8c4f-11eb-27ca-ffba02520fec
probability_distribution(test_data)

# ╔═╡ 95145ee9-c826-45e3-ab51-442c8ca70fa3
md"""
## Intermezzo: _**function**_ vs. _**begin**_ vs. _**let**_
$(html"<span id=function_begin_let></span>")

In our lecture materials, we sometimes use a `let` block in this cell to group multiple expressions together, but how is it different from `begin` or `function`?

> ##### function
> Writing functions is a way to group multiple expressions (i.e. lines of code) together into a mini-program. Note the following about functions:
> - A function always returns **one object**.[^1] This object can be given explicitly by writing `return x`, or implicitly: Julia functions always return the result of the last expression by default. So `f(x) = x+2` is the same as `f(x) = return x+2`.
> - Variables defined inside a function are _not accessible outside the function_. We say that function bodies have a **local scope**. This helps to keep your program easy to read and write: if you define a local variable, then you don't need to worry about it in the rest of the notebook.
> 
> There are two other ways to group expressions together that you might have seen before: `begin` and `let`.

> ##### begin
> **`begin`** will group expressions together, and it takes the value of its last subexpression. 
>     
> We use it in this notebook when we want multiple expressions to always run together.

> ##### let
> **`let`** also groups multiple expressions together into one, but variables defined inside of it are **local**: they don't affect code outside of the block. So like `begin`, it is just a block of code, but like `function`, it has a local variable scope.
> 
> We use it when we want to define some local (temporary) variables to produce a complicated result, without interfering with other cells. Pluto allows only one definition per _global_ variable of the same name, but you can define _local_ variables with the same names whenever you wish!

[^1]: Even a function like 
    
    `f(x) = return`
    
    returns **one object**: the object `nothing` — try it out!
"""

# ╔═╡ c5464196-8ef7-418d-b1aa-fafc3a03c68c
md"""
### Example of a scope problem with `begin`

The following will not work, because `fruits` has multiple definitions:
"""

# ╔═╡ 409ed7e5-a3b8-4d37-b85d-e5cb4c1e1708
md"""
### Solved using `let`
"""

# ╔═╡ 36de9792-1870-4c78-8330-83f273ee1b46
let
	vegetables = ["🥦", "🥔", "🥬"]
	length(vegetables)
end

# ╔═╡ 8041603b-ae47-4569-af1d-cebb00edb32a
let
	vegetables = ["🌽"]
	length(vegetables)
end

# ╔═╡ 2d56bf20-8866-4ec1-9ceb-41004aa185d0


# ╔═╡ 2577c5a7-338f-4aef-b34b-456949cfc17b
md"""
This works, because `vegetables` is only defined as a _local variable inside the cell_, not as a global:
"""

# ╔═╡ d12229f4-d950-4983-84a4-304a7637ac7b
vegetables

# ╔═╡ a8241562-8c4c-11eb-2a85-d7502e7fb2cf
md"""
## **Exercise 2:** _Modelling component failure with the geometric distribution_

In this exercise, we will investigate the simple model of failure of mechanical components (or light bulbs, or radioactive decay, or recovery from an infection, or...) that we saw in lectures. 
Let's call $\tau$ the time to failure.

We will use a  simple model, in which each component has probability $p$ to fail each day. If it fails on day $n$, then $\tau = n$.
We see that $\tau$ is a random variable, so we need to study its **probability distribution**.

"""

# ╔═╡ fdb394a0-8c4f-11eb-0585-bb8c28f952cb
md"""
#### Exercise 2.1

👉 Define the function `bernoulli(p)` from lectures. Recall that this generates `true` with probability $p$ and `false` with probability $(1 - p)$.
"""

# ╔═╡ 0233835a-8c50-11eb-01e7-7f80bd27683e
function bernoulli(p::Real)
	
	return missing
end

# ╔═╡ fdb3f1c8-8c4f-11eb-2281-bf01205bb804
md"""
#### Exercise 2.2

👉 Write a function `geometric(p)`. This should run a simulation with probability $p$ to recover and wait *until* the individual recovers, at which point it returns the time taken to recover. The resulting failure time is known as a **geometric random variable**, or a random variable whose distribution is the **geometric distribution**.
"""

# ╔═╡ 08028df8-8c50-11eb-3b22-fdf5104a4d52
function geometric(p::Real)
	
	
	return missing
end

# ╔═╡ 2b35dc1c-8c50-11eb-3517-83589f2aa8cc
geometric(0.25)

# ╔═╡ e125bd7f-1881-4cff-810f-8af86850249d
md"""
We should always be aware of special cases (sometimes called "boundary conditions"). Make sure *not* to run the code with $p=0$! What would happen in that case? Your code should check for this and throw an `ArgumentError` as follows:

```julia
throw(ArgumentError("..."))  
```

with a suitable error message.
    
"""

# ╔═╡ 6cb36508-836a-4191-b615-45681a1f7443
md"""
👉 What happens for $p=1$? 
"""

# ╔═╡ 370ec1dc-8688-443c-bf57-dd1b2a42a5fa
interpretation_of_p_equals_one = md"""
blablabla
"""

# ╔═╡ fdb46c72-8c4f-11eb-17a2-8b7628b5d3b3
md"""
#### Exercise 2.3
👉 Write a function `experiment(p, N)` that runs the `geometric` function `N` times and collects the results into a vector.
"""

# ╔═╡ 32700660-8c50-11eb-2fdf-5d9401c07de3
function experiment(p::Real, N::Integer)
	
	return missing
end

# ╔═╡ 192caf02-5234-4379-ad74-a95f3f249a72
small_experiment = experiment(0.5, 20)

# ╔═╡ fdc1a9f2-8c4f-11eb-1c1e-5f92987b79c7
md"""
#### Exercise 2.4
Let's run an experiment with $p=0.25$ and $N=10,000$. We will plot the resulting probability distribution, i.e. plot $P(\tau = n)$ against $n$, where $n$ is the recovery time.
"""

# ╔═╡ 3cd78d94-8c50-11eb-2dcc-4d0478096274
large_experiment = experiment(0.25, 10000)

# ╔═╡ 4118ef38-8c50-11eb-3433-bf3df54671f0
let
	xs, ps = probability_distribution(large_experiment)
		
	bar(xs, ps, alpha=0.5, leg=false)	
end

# ╔═╡ c4ca3940-9bd5-4fa6-8c73-8675ef7d5f41
md"""
👉 Calculate the mean recovery time. 


"""

# ╔═╡ 25ae71d0-e6e2-45ff-8900-3caf6fcea937


# ╔═╡ 3a7c7ca2-e879-422e-a681-d7edd271c018
md"""
👉 Create the same plot as above, and add the mean recovery time to the plot using the `vline!()` function and the `ls=:dash` argument to make a dashed line.

Note that `vline!` requires a *vector* of values where you wish to draw vertical lines.
"""

# ╔═╡ 97d7d154-8c50-11eb-2fdd-fdf0a4e402d3
let
	
	# your code here
end

# ╔═╡ b1287960-8c50-11eb-20c3-b95a2a1b8de5
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
> ##### Grouping expressions
> It is highly recommended that these 3 steps happen **within a single cell**. This can prevent some strange glitches when re-running cells. There are three ways to group expressions together into a single cell: `begin`, `let` and `function`. More on this [here](#function_begin_let)!
"""

# ╔═╡ fdcab8f6-8c4f-11eb-27c6-3bdaa3fcf505
md"""
#### Exercise 2.5
👉 What shape does the distribution seem to have? Can you verify that by using one or more log scales in a new plot?
"""

# ╔═╡ 1b1f870f-ee4d-497f-8d4b-1dba737be075


# ╔═╡ fdcb1c1a-8c4f-11eb-0aeb-3fae27eaacbd
md"""
Use the widgets from PlutoUI to write an interactive visualization that performs Exercise 2.3 for $p$ varying between $0$ and $1$ and $N$ between $0$ and $100,000$.

You might want to go back to Exercise 2.3 to turn your code into a _function_ that can be called again.

As you vary $p$, what do you observe? Does that make sense?
"""

# ╔═╡ d5b29c53-baff-4529-b2c1-776afe000d38
@bind hello Slider( 2 : 0.5 : 10 )

# ╔═╡ 9a92eba4-ad68-4c53-a242-734718aeb3f1
hello

# ╔═╡ 48751015-c374-4a77-8a00-bca81bbc8305


# ╔═╡ 562202be-5eac-46a4-9542-e6593bc39ff9


# ╔═╡ e8d2a4ab-b710-4c16-ab71-b8c1e71fe442


# ╔═╡ a486dc37-609d-4aae-b4ec-71de726191c7


# ╔═╡ 65ea5492-d833-4754-89a3-0aa671c3ec7a


# ╔═╡ 264089bc-aa30-450f-89f7-ffd589eee13c


# ╔═╡ 0be83efa-e94f-4397-829f-24f705b044b1


# ╔═╡ fdd5d98e-8c4f-11eb-32bc-51bc1db98930
md"""
#### Exercise 2.6
👉 For fixed $N = 10,000$, write a function that calculates the *mean* time to recover, $\langle \tau(p) \rangle$, as a function of $p$.
"""

# ╔═╡ 406c9bfa-409d-437c-9b86-fd02fdbeb88f


# ╔═╡ f8b982a7-7246-4ede-89c8-b2cf183470e9
md"""
👉 Use plots of your function to find the relationship between $\langle \tau(p) \rangle$ and $p$.
"""

# ╔═╡ caafed37-0b3b-4f6c-919f-f16df7248c23


# ╔═╡ 501bcc30-f96f-42e4-a5aa-09a4138b5b72


# ╔═╡ b763b6e8-8221-4b08-9a8e-8d5e63cbd144


# ╔═╡ d2e4185e-8c51-11eb-3c31-637902456634
md"""
Based on my observations, it looks like we have the following relationship:

```math
\langle \tau(p) \rangle = my \cdot answer \cdot here
```
"""

# ╔═╡ a82728c4-8c4c-11eb-31b8-8bc5fcd8afb7
md"""

## **Exercise 3:** _More efficient geometric distributions_

Let's use the notation $P_n := \mathbb{P}(\tau = n)$ for the probability to fail on the $n$th step.

Probability theory tells us that in the limit of an infinite number of trials, we have the following exact results: $P_1 = p$;  $P_2 = p (1-p)$, and in general $P_n = p (1 - p)^{n-1}$.
	"""

# ╔═╡ 23a1b76b-7393-4a4c-b6a5-40fb15dadd29
md"""
#### Exercise 3.1

👉 Fix $p = 0.25$. Make a vector of the values $P_n$ for $n=1, \dots, 50$. You must (of course!) use a loop or similar construction; do *not* do this by hand!
"""

# ╔═╡ 45735d82-8c52-11eb-3735-6ff9782dde1f
Ps = let 
	
	# your code here
end

# ╔═╡ dd80b2eb-e4c3-4b2f-ad5c-526a241ac5e6
md"""
👉 Do they sum to 1?

"""

# ╔═╡ 3df70c76-1aa6-4a0c-8edf-a6e3079e406b


# ╔═╡ b1ef5e8e-8c52-11eb-0d95-f7fa123ee3c9
md"""
#### Exercise 3.2
👉 Check analytically that the probabilities sum to 1 when you include *all* (infinitely many) of them.
"""

# ╔═╡ a3f08480-4b2b-46f2-af4a-14270869e766
md"""

```math
\sum_{k=1}^{\infty} P_k = \dots your \cdot answer \cdot here \dots = 1

```
"""

# ╔═╡ 1b6035fb-d8fc-437f-b75e-f1a6b3b4cae7
md"""
#### Exercise 3.3: Sum of a geometric series
"""

# ╔═╡ c3cb9ea0-5e0e-4d5a-ab23-80ed8d91209c
md"""
👉 Plot $P_n$ as a function of $n$. Compare it to the corresponding result from the previous exercise (i.e. plot them both on the same graph).
	"""

# ╔═╡ dd59f48c-bb22-47b2-8acf-9c4ee4457cb9


# ╔═╡ 5907dc0a-de60-4b58-ac4b-1e415f0051d2
md"""
👉   How could we measure the *error*, i.e. the distance between the two graphs? What do you think determines it?
	"""

# ╔═╡ c7093f08-52d2-4f22-9391-23bd196c6fb9


# ╔═╡ 316f369a-c051-4a35-9c64-449b12599295
md"""
#### Exercise 3.4
If $p$ is *small*, say $p=0.001$, then the algorithm we used in Exercise 2 to sample from geometric distribution will be very slow, since it just sits there calculating a lot of `false`s! (The average amount of time taken is what you found in [1.8].)
"""

# ╔═╡ 9240f9dc-aa34-4e7b-8b82-86ea1376f527
md"""
   Let's make a better algorithm. Think of each probability $P_n$ as a "bin", or interval, of length $P_n$. If we lay those bins next to each other starting from $P_1$ on the left, then $P_2$, etc., there will be an *infinite* number of bins that fill up the interval between $0$ and $1$. (In principle there is no upper limit on how many days it will take to recover, although the probability becomes *very* small.)
"""

# ╔═╡ d24ddb61-3d65-4bea-ad8f-d5a3ac44a563
md"""
   Now suppose we take a uniform random number $r$ between $0$ and $1$. That will fall into one of the bins. If it falls into the bin corresponding to $P_n$, then we return $n$ as the recovery time!
"""

# ╔═╡ 430e0975-8eb6-420c-a18e-f3493182c5c7
md"""
👉 To draw this picture, we need to add up the lengths of the lines from 1 to $n$ for each $n$, i.e. calculate the **cumulative sum**. Write a function `cumulative_sum`, which returns a new vector.
"""

# ╔═╡ 5185c938-8c53-11eb-132d-83342e0c775f
function cumulative_sum(xs::Vector)
	
	return missing
end

# ╔═╡ e4095d34-552e-495d-b318-9afe6839d577
cumulative_sum([1, 3, 5, 7, 9])

# ╔═╡ fa5843e8-8c52-11eb-2138-dd57b8bf25f7
md"""
👉 Plot the resulting values on a horizontal line. Generate a few random points and plot those. Convince yourself that the probability that a point hits a bin is equal to the length of that bin.
"""

# ╔═╡ 7aa0ec08-8c53-11eb-1935-23237a448399
cumulative = cumulative_sum(Ps)

# ╔═╡ e649c914-dd28-4194-9393-4dc8836f3743


# ╔═╡ fa59099a-8c52-11eb-37a7-291f80ea0406
md"""
#### Exercise 3.5
👉 Calculate the sum of $P_1$ up to $P_n$ analytically.
"""

# ╔═╡ 1ae91530-c77e-4d92-9ad3-c969bc7e1fa8
md"""
```math
C_n := \sum_{k=1}^n P_k = my \cdot answer \cdot here
```
"""

# ╔═╡ fa599248-8c52-11eb-147a-99b5fb75d131
md"""
👉 Use the previous result to find (analytically) which bin $n$ a given value of $r \in [0, 1]$ falls into, using the inequality $P_{n+1} \le r \le P_n$.


	
"""

# ╔═╡ 16b4e98c-4ae7-4145-addf-f43a0a96ec82
md"""
```math
n(r,p) = my \cdot answer \cdot here
```
"""

# ╔═╡ fa671c06-8c52-11eb-20e0-85e2abb4ecc7
md"""
#### Exercise 3.6

👉 Implement this as a function `geomtric_bin(r, p)`, use the `floor` function.
"""

# ╔═╡ 47d56992-8c54-11eb-302a-eb3153978d26
function geometric_bin(u::Real, p::Real)
	
	return missing
end

# ╔═╡ adfb343d-beb8-4576-9f2a-d53404cee42b
md"""
We can use this to define a **fast** version of the `geomtric` function:
"""

# ╔═╡ 5b7f2a91-a4f0-49f7-b8cf-6f677104d3e1
geometric_fast(p) = geometric_bin(rand(), p)

# ╔═╡ b3b11113-2f0c-45d2-a14e-011a61ae8e9b
geometric_fast(0.25)

# ╔═╡ fc681dde-8c52-11eb-07fa-7d0ef9f22e93
md"""
#### Exercise 3.7
👉 Generate `10_000` samples from `geometric_fast` with $p=10^{-10}$ and plot a histogram of them. This would have taken a very long time with the previous method!
"""

# ╔═╡ 1d007d99-2526-4c19-9c96-3fad1750670e


# ╔═╡ c37bbb1f-8f5e-4097-9104-43ef65aa1cbd


# ╔═╡ 79eb5e14-8c54-11eb-3c8c-dfeba16305b2
md"""
## **Exercise 4:** _Distribution of the "atmosphere"_

In this question we will implement a (very!) simple model of the density of the atmosphere, using a **random walk**, i.e. a particle that undergoes random *motion*. (We will see more about random walks in lectures.)

We can think of a very light dust particle being moved around by the wind. We are only interested in its vertical position, $y$, and we will suppose for simplicity that $y$ is an integer. The particle jumps up and down randomly as it is moved by the wind; however, due to gravity it has a higher probability $p$ of moving downwards (to $y-1$) than upwards (to $y+1$), which happens with probability $1-p$.

At $y = 1$ there is a **boundary condition**: it hits a reflective boundary (the "surface of the Earth"). We can model this using "bounce-back": if the particle tries to jump downwards from $y=1$ then it hits a reflective boundary and bounces back to $y=1$. (In other words it remains in the same place.)

"""

# ╔═╡ 8c9c217e-8c54-11eb-07f1-c5fde6aa2946
md"""
#### Exercise 4.1
👉 Write a simulation of this model in a function `atmosphere` that accepts `p`, the initial height `y0`, and the number of steps $N$ as variables.

"""

# ╔═╡ 2270e6ba-8c5e-11eb-3600-615519daa5e0
function atmosphere(p::Real, y0::Real, N::Integer)
	
	return missing
end

# ╔═╡ 225bbcbd-0628-4151-954e-9a85d1020fd9
atmosphere(0.8, 10, 50)

# ╔═╡ 1dc5daa6-8c5e-11eb-1355-b1f627d04a18
md"""
Let's simulate it for $10^7$ time steps with $x_0 = 10$ and $p=0.55$. 

#### Exercise 4.2

👉 Calculate and plot the probability distribution of the walker's height.
"""

# ╔═╡ deb5fbfb-1e03-42ce-a6d6-c8d3edd89a9a


# ╔═╡ 8517f92b-d4d3-46b5-9b9a-e609175b6481


# ╔═╡ c1e3f066-5e12-4018-9fb2-4e7fc13172ba


# ╔═╡ 1dc68e2e-8c5e-11eb-3486-454d58ac9c87
md"""
👉 What does the resulting figure look like? What form do you think this distribution has? Verify your hypothesis by plotting the distribution using different scales. You can increase the number of time steps to make the results look nicer.
"""

# ╔═╡ bb8f69fd-c704-41ca-9328-6622d390f71f


# ╔═╡ 1dc7389c-8c5e-11eb-123a-7f59dc6504cf
md"""
#### Exercise 4.3

👉 Make an interactive visualization of how the distribution develops over time. What happens for longer and longer times?

"""

# ╔═╡ d3bec73d-0106-496d-93ae-e1e26534b8c7


# ╔═╡ d972be1f-a8ad-43ed-a90d-bca358d812c2


# ╔═╡ de83ffd6-cd0c-4b78-afe4-c0bcc54471d7
md"""
👉 Use wikipedia to find a formula for the barometric pressure at a given altitude. Does this result match your expectations?
"""

# ╔═╡ fe45b8de-eb3f-43ca-9d63-5c01d0d27671


# ╔═╡ 5aabbec1-a079-4936-9cd1-9c25fe5700e6
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 42d6b87d-b4c3-4ccb-aceb-d1b020135f47
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 17fa9e2e-8c4d-11eb-334c-ad3704b43e95
md"""

#### Exercise 1.1
👉 Write a function `counts` that accepts a vector `data` and calculates the number of times each value in `data` occurs.

The input will be an array of integers, **with duplicates**, and the result will be a dictionary that maps each occured value to its count in the data.

For example,
```julia
counts([7, 8, 9, 7])
```
should give
```julia
Dict(
	7 => 2, 
	8 => 1, 
	9 => 1,
)
```

To do so, use a **dictionary** called `counts`. [We can create a local variable with the same name as the function.]

$(hint(md"Do you remember how we worked with dictionaries in Homework 3? You can create an empty dictionary using `Dict()`. You may want to use either the function `haskey` or the function `get` on your dictionary -- check the documentation for how to use these functions.
"))

The function should return the dictionary.
"""

# ╔═╡ 7077a0b6-4539-4246-af2d-ab990c34e810
hint(md"Remember to always re-use work you have done previously: in this case you should re-use the function `bernoulli`.")

# ╔═╡ 8fd9e34c-8f20-4979-8f8a-e3e2ae7d6c65
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ d375c52d-2126-4594-b819-aba9d34fe77f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 2d7565d4-88da-4e41-aad6-958ed6b3b2e0
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ d7f45d51-f426-4353-af58-858395295ce0
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next question."]

# ╔═╡ 9b2aa95d-4583-40ec-893c-9fc751ea22a1
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 5dca2bb3-24e6-49ae-a6fc-d3912da4f82a
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 645ace88-b8e6-4957-ad6e-49fd82b08fe5
if !@isdefined(counts)
	not_defined(:counts)
else
	let
		result = counts([51,-52,-52,53,51])

		if ismissing(result)
			still_missing()
		elseif !(result isa Dict)
			keep_working(md"Make sure that `counts` returns a Dictionary.")
		elseif result == Dict(
				51 => 2,
				-52 => 2,
				53 => 1,
			)
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 6a302ce6-a327-449e-b41a-859d502f4df7
if !@isdefined(test_counts)
	not_defined(:test_counts)
else
	if test_counts != Dict(
			0 => 2,
			1000 => 2,
			1 => 4
			)
		
		keep_working()
	else
		correct()
	end
end

# ╔═╡ 2b6a64b9-779b-47d1-9724-ad066f14fbff
if !@isdefined(counts2)
	not_defined(:counts2)
else
	let
		result = counts2([51,-52,-52,53,51])

		if ismissing(result)
			still_missing()
		elseif !(result isa Tuple{<:AbstractVector,<:AbstractVector})
			keep_working(md"Make sure that `counts2` returns a Tuple of two vectors.")
		elseif result == (
				[-52, 51, 53],
				[2, 2, 1],
			)
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 26bf2a9c-f42e-4c97-83d2-b9d637a2e8ae
if !@isdefined(probability_distribution)
	not_defined(:probability_distribution)
else
	let
		result = probability_distribution([51,-52,-52,53,51])

		if ismissing(result)
			still_missing()
		elseif !(result isa Tuple{<:AbstractVector,<:AbstractVector})
			keep_working(md"Make sure that `counts2` returns a Tuple of two vectors.")
		elseif result[1] == [-52, 51, 53] &&
				isapprox(result[2], [2, 2, 1] ./ 5)
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 3ea51057-4438-4d4a-b964-630e87a82ce5
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

# ╔═╡ fccff967-e44f-4f89-8995-d822783301c3
if !@isdefined(geometric)
	not_defined(:geometric)
else
	let
		result = geometric(1.0)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Int)
			keep_working(md"Make sure that you return an integer: the recovery time.")
		else
			if result == 1
				samples = [geometric(0.2) for _ in 1:256]
				
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

# ╔═╡ 0210b558-80ae-4a15-92c1-60b0fd7924f3
if !@isdefined(cumulative_sum)
	not_defined(:cumulative_sum)
else
	let
		result = cumulative_sum([1,2,3,4])
		if result isa Missing
			still_missing()
		elseif !(result isa AbstractVector)
			keep_working(md"Make sure that you return an Array: the cumulative sum!")
		elseif length(result) != 4
			keep_working(md"You should return an array of the same size a `xs`.")
		else
			if isapprox(result, [1, 3, 6, 10])
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ a81516e8-0099-414e-9f2c-ab438764348e
if !@isdefined(geometric_bin)
	not_defined(:geometric_bin)
else
	let
		result1 = geometric_bin(0.1, 0.1)
		result2 = geometric_bin(0.9, 0.1)
		
		if result1 isa Missing
			still_missing()
		elseif !(result1 isa Real)
			keep_working(md"Make sure that you return a number.")
		elseif all(isinteger, [result1, result2])
			if result1 == 21 || result2 == 21 ||  result1 == 22 || result2 == 22

				correct()
			else
				keep_working()
			end
		else
			keep_working(md"You should use the `floor` function to return an integer.")
		end
	end
end

# ╔═╡ ddf2a828-7823-4fc0-b944-72b60b391247
todo(text) = HTML("""<div
	style="background: rgb(220, 200, 255); padding: 2em; border-radius: 1em;"
	><h1>TODO</h1>$(repr(MIME"text/html"(), text))</div>""")

# ╔═╡ a7feaaa4-618b-4afe-8050-4bf7cc609c17
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 4ce0e43d-63d6-4cb2-88b8-8ba80e17012a
bigbreak

# ╔═╡ 6f55a612-8c4f-11eb-0f6b-755442c4ed3d
bigbreak

# ╔═╡ 51801da7-38da-4628-8a7a-119358e60086
bigbreak

# ╔═╡ 43966251-c8db-4999-bc4f-0f1fc34e0264
bigbreak

# ╔═╡ 06412687-b44d-4a69-8d6c-0cf4eb51dfad
bigbreak

# ╔═╡ 94053b41-4a06-435d-a91a-9dfa9655937c
bigbreak

# ╔═╡ a5234680-8b02-11eb-2574-15489d0d49ea
bigbreak

# ╔═╡ 2962c6da-feda-4d65-918b-d3b178a18fa0
begin
	fruits = ["🍒", "🍐", "🍋"]
	length(fruits)
end

# ╔═╡ 887a5106-c44a-4437-8c6f-04ad6610738a
begin
	fruits = ["🍉"]
	length(fruits)
end

# ╔═╡ Cell order:
# ╟─eadb174e-2c1d-48c8-9de2-99cdc2b38d32
# ╟─0560cf7b-9986-402a-9c40-779ea7a7292d
# ╟─082542fe-f89d-4774-be20-1e1a78f21291
# ╠═6f4274b5-87e2-420d-83d2-83a8408650cd
# ╟─aaa41509-a62d-417b-bca7-a120e3a5e5b2
# ╠═8c8388cf-9891-423c-8db2-d40d870bb38e
# ╟─4ce0e43d-63d6-4cb2-88b8-8ba80e17012a
# ╟─6c6e055a-8c4c-11eb-14a7-6d3036e248b9
# ╟─17fa9e2e-8c4d-11eb-334c-ad3704b43e95
# ╠═2bebafd4-8c4d-11eb-14ba-27ab7eb763c1
# ╠═d025d432-23d0-4a6b-8b09-cc1114367b8f
# ╟─17faeb5e-8c4d-11eb-3589-c96e799b8a52
# ╠═5e6f16fc-04a0-4774-8ce0-78953e047269
# ╠═49b9e55c-1179-4bee-844e-62ae36d20a5d
# ╟─645ace88-b8e6-4957-ad6e-49fd82b08fe5
# ╟─6a302ce6-a327-449e-b41a-859d502f4df7
# ╟─18031e1e-8c4d-11eb-006b-adaf55d54282
# ╠═4bbbbd24-d592-4ce3-a619-b7f760672b99
# ╠═44d0f365-b2a8-41a2-98d3-0aa34e8c80c0
# ╟─18094d52-8c4d-11eb-0620-d30c24a8c75e
# ╠═c825f913-9545-4dbd-96f9-5f7621fc242d
# ╟─180fc1d2-8c4d-11eb-0362-230d84d47c7f
# ╠═fde456e5-9985-4939-af59-9b9a92313b61
# ╠═cc6923ff-09e0-44cc-9385-533182c4382d
# ╟─18103c98-8c4d-11eb-2bed-ed20aba64ae6
# ╟─bfa216a2-ffa6-4716-a057-62a58fd9f04a
# ╠═156c1bea-8c4f-11eb-3a7a-793d0a056f80
# ╠═37294d02-8c4f-11eb-141e-0be49ea07611
# ╟─2b6a64b9-779b-47d1-9724-ad066f14fbff
# ╟─18139dc0-8c4d-11eb-0c31-a75361ed7321
# ╠═447bc642-8c4f-11eb-1d4f-750e883b81fb
# ╠═6b1dc96a-8c4f-11eb-27ca-ffba02520fec
# ╟─26bf2a9c-f42e-4c97-83d2-b9d637a2e8ae
# ╟─6f55a612-8c4f-11eb-0f6b-755442c4ed3d
# ╟─95145ee9-c826-45e3-ab51-442c8ca70fa3
# ╟─51801da7-38da-4628-8a7a-119358e60086
# ╟─c5464196-8ef7-418d-b1aa-fafc3a03c68c
# ╠═2962c6da-feda-4d65-918b-d3b178a18fa0
# ╠═887a5106-c44a-4437-8c6f-04ad6610738a
# ╟─409ed7e5-a3b8-4d37-b85d-e5cb4c1e1708
# ╠═36de9792-1870-4c78-8330-83f273ee1b46
# ╠═8041603b-ae47-4569-af1d-cebb00edb32a
# ╟─2d56bf20-8866-4ec1-9ceb-41004aa185d0
# ╟─2577c5a7-338f-4aef-b34b-456949cfc17b
# ╠═d12229f4-d950-4983-84a4-304a7637ac7b
# ╟─43966251-c8db-4999-bc4f-0f1fc34e0264
# ╟─a8241562-8c4c-11eb-2a85-d7502e7fb2cf
# ╟─fdb394a0-8c4f-11eb-0585-bb8c28f952cb
# ╠═0233835a-8c50-11eb-01e7-7f80bd27683e
# ╟─3ea51057-4438-4d4a-b964-630e87a82ce5
# ╟─fdb3f1c8-8c4f-11eb-2281-bf01205bb804
# ╠═08028df8-8c50-11eb-3b22-fdf5104a4d52
# ╠═2b35dc1c-8c50-11eb-3517-83589f2aa8cc
# ╟─7077a0b6-4539-4246-af2d-ab990c34e810
# ╟─e125bd7f-1881-4cff-810f-8af86850249d
# ╟─fccff967-e44f-4f89-8995-d822783301c3
# ╟─6cb36508-836a-4191-b615-45681a1f7443
# ╠═370ec1dc-8688-443c-bf57-dd1b2a42a5fa
# ╟─fdb46c72-8c4f-11eb-17a2-8b7628b5d3b3
# ╠═32700660-8c50-11eb-2fdf-5d9401c07de3
# ╠═192caf02-5234-4379-ad74-a95f3f249a72
# ╟─fdc1a9f2-8c4f-11eb-1c1e-5f92987b79c7
# ╠═3cd78d94-8c50-11eb-2dcc-4d0478096274
# ╠═4118ef38-8c50-11eb-3433-bf3df54671f0
# ╟─c4ca3940-9bd5-4fa6-8c73-8675ef7d5f41
# ╠═25ae71d0-e6e2-45ff-8900-3caf6fcea937
# ╟─3a7c7ca2-e879-422e-a681-d7edd271c018
# ╠═97d7d154-8c50-11eb-2fdd-fdf0a4e402d3
# ╟─b1287960-8c50-11eb-20c3-b95a2a1b8de5
# ╟─fdcab8f6-8c4f-11eb-27c6-3bdaa3fcf505
# ╠═1b1f870f-ee4d-497f-8d4b-1dba737be075
# ╟─fdcb1c1a-8c4f-11eb-0aeb-3fae27eaacbd
# ╠═d5b29c53-baff-4529-b2c1-776afe000d38
# ╠═9a92eba4-ad68-4c53-a242-734718aeb3f1
# ╠═48751015-c374-4a77-8a00-bca81bbc8305
# ╠═562202be-5eac-46a4-9542-e6593bc39ff9
# ╠═e8d2a4ab-b710-4c16-ab71-b8c1e71fe442
# ╠═a486dc37-609d-4aae-b4ec-71de726191c7
# ╠═65ea5492-d833-4754-89a3-0aa671c3ec7a
# ╠═264089bc-aa30-450f-89f7-ffd589eee13c
# ╠═0be83efa-e94f-4397-829f-24f705b044b1
# ╟─fdd5d98e-8c4f-11eb-32bc-51bc1db98930
# ╠═406c9bfa-409d-437c-9b86-fd02fdbeb88f
# ╟─f8b982a7-7246-4ede-89c8-b2cf183470e9
# ╠═caafed37-0b3b-4f6c-919f-f16df7248c23
# ╠═501bcc30-f96f-42e4-a5aa-09a4138b5b72
# ╠═b763b6e8-8221-4b08-9a8e-8d5e63cbd144
# ╠═d2e4185e-8c51-11eb-3c31-637902456634
# ╟─06412687-b44d-4a69-8d6c-0cf4eb51dfad
# ╟─a82728c4-8c4c-11eb-31b8-8bc5fcd8afb7
# ╟─23a1b76b-7393-4a4c-b6a5-40fb15dadd29
# ╠═45735d82-8c52-11eb-3735-6ff9782dde1f
# ╟─dd80b2eb-e4c3-4b2f-ad5c-526a241ac5e6
# ╠═3df70c76-1aa6-4a0c-8edf-a6e3079e406b
# ╟─b1ef5e8e-8c52-11eb-0d95-f7fa123ee3c9
# ╠═a3f08480-4b2b-46f2-af4a-14270869e766
# ╟─1b6035fb-d8fc-437f-b75e-f1a6b3b4cae7
# ╟─c3cb9ea0-5e0e-4d5a-ab23-80ed8d91209c
# ╠═dd59f48c-bb22-47b2-8acf-9c4ee4457cb9
# ╟─5907dc0a-de60-4b58-ac4b-1e415f0051d2
# ╠═c7093f08-52d2-4f22-9391-23bd196c6fb9
# ╟─316f369a-c051-4a35-9c64-449b12599295
# ╟─9240f9dc-aa34-4e7b-8b82-86ea1376f527
# ╟─d24ddb61-3d65-4bea-ad8f-d5a3ac44a563
# ╟─430e0975-8eb6-420c-a18e-f3493182c5c7
# ╠═5185c938-8c53-11eb-132d-83342e0c775f
# ╠═e4095d34-552e-495d-b318-9afe6839d577
# ╟─0210b558-80ae-4a15-92c1-60b0fd7924f3
# ╟─fa5843e8-8c52-11eb-2138-dd57b8bf25f7
# ╠═7aa0ec08-8c53-11eb-1935-23237a448399
# ╠═e649c914-dd28-4194-9393-4dc8836f3743
# ╟─fa59099a-8c52-11eb-37a7-291f80ea0406
# ╠═1ae91530-c77e-4d92-9ad3-c969bc7e1fa8
# ╟─fa599248-8c52-11eb-147a-99b5fb75d131
# ╠═16b4e98c-4ae7-4145-addf-f43a0a96ec82
# ╟─fa671c06-8c52-11eb-20e0-85e2abb4ecc7
# ╠═47d56992-8c54-11eb-302a-eb3153978d26
# ╟─a81516e8-0099-414e-9f2c-ab438764348e
# ╟─adfb343d-beb8-4576-9f2a-d53404cee42b
# ╠═5b7f2a91-a4f0-49f7-b8cf-6f677104d3e1
# ╠═b3b11113-2f0c-45d2-a14e-011a61ae8e9b
# ╟─fc681dde-8c52-11eb-07fa-7d0ef9f22e93
# ╠═1d007d99-2526-4c19-9c96-3fad1750670e
# ╠═c37bbb1f-8f5e-4097-9104-43ef65aa1cbd
# ╟─94053b41-4a06-435d-a91a-9dfa9655937c
# ╟─79eb5e14-8c54-11eb-3c8c-dfeba16305b2
# ╟─8c9c217e-8c54-11eb-07f1-c5fde6aa2946
# ╠═2270e6ba-8c5e-11eb-3600-615519daa5e0
# ╠═225bbcbd-0628-4151-954e-9a85d1020fd9
# ╟─1dc5daa6-8c5e-11eb-1355-b1f627d04a18
# ╠═deb5fbfb-1e03-42ce-a6d6-c8d3edd89a9a
# ╠═8517f92b-d4d3-46b5-9b9a-e609175b6481
# ╠═c1e3f066-5e12-4018-9fb2-4e7fc13172ba
# ╟─1dc68e2e-8c5e-11eb-3486-454d58ac9c87
# ╠═bb8f69fd-c704-41ca-9328-6622d390f71f
# ╟─1dc7389c-8c5e-11eb-123a-7f59dc6504cf
# ╠═d3bec73d-0106-496d-93ae-e1e26534b8c7
# ╠═d972be1f-a8ad-43ed-a90d-bca358d812c2
# ╟─de83ffd6-cd0c-4b78-afe4-c0bcc54471d7
# ╠═fe45b8de-eb3f-43ca-9d63-5c01d0d27671
# ╟─a5234680-8b02-11eb-2574-15489d0d49ea
# ╟─5aabbec1-a079-4936-9cd1-9c25fe5700e6
# ╟─42d6b87d-b4c3-4ccb-aceb-d1b020135f47
# ╟─8fd9e34c-8f20-4979-8f8a-e3e2ae7d6c65
# ╟─d375c52d-2126-4594-b819-aba9d34fe77f
# ╟─2d7565d4-88da-4e41-aad6-958ed6b3b2e0
# ╟─d7f45d51-f426-4353-af58-858395295ce0
# ╟─9b2aa95d-4583-40ec-893c-9fc751ea22a1
# ╟─5dca2bb3-24e6-49ae-a6fc-d3912da4f82a
# ╟─ddf2a828-7823-4fc0-b944-72b60b391247
# ╟─a7feaaa4-618b-4afe-8050-4bf7cc609c17
