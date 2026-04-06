### A Pluto.jl notebook ###
# v0.19.45

#> [frontmatter]
#> chapter = 2
#> video = "https://www.youtube.com/watch?v=d8BohH76C7E"
#> image = "https://user-images.githubusercontent.com/6933510/136196572-b11974d5-7335-4678-9092-630e034bbe8f.png"
#> section = 3
#> order = 3
#> title = "Modeling with Stochastic Simulation"
#> layout = "layout.jlhtml"
#> youtube_id = "d8BohH76C7E"
#> description = ""
#> tags = ["lecture", "module2", "track_julia", "probability", "statistics", "track_math", "epidemiology", "interactive", "plotting", "programming", "type", "discrete", "continuous", "ODE", "differential equation", "agent based model"]

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

# ╔═╡ 9a0cec14-08db-11eb-3cfa-4d1c327c63f1
using Plots, PlutoUI, StatsBase, Statistics, HypertextLiteral

# ╔═╡ fb6cdc08-8b44-11eb-09f5-43c167aa53fd
PlutoUI.TableOfContents(aside=true)

# ╔═╡ b6b055b6-8cae-11eb-29e5-b507c1a2b9bf
md"""
## Julia features
"""

# ╔═╡ bcfaedfa-8cae-11eb-10a1-cb7be7dc2e6b
md"""
- Extending a function from another package (not `Base`)

- Why create a new type? Abstractions and concentrating information around objects (organisation!)

- Plotting shapes 

- String interpolation
"""

# ╔═╡ d2c19564-8b44-11eb-1077-ddf6d1395b59
md"""
## Individual-based ("microscopic") models
"""

# ╔═╡ ac4f6944-08d9-11eb-0b3c-f5e0a8b8c17e
md"""

In **individual-based** models, we literally specify the behaviour, or actions, of each individual in a set of rules. But often we are interested in a global picture of how the whole system, consisting of many individuals, evolves in time: how many infectious individuals there are in total at a given time, for example, or the behaviour of the whole stock market.

In this notebook we will see how we can start from an individual-based probabilistic  (probabilistic) model, and how sometimes we can find **deterministic** equations for a **macroscopic** (system-level) description.

Those macroscopic equations can either be in discrete time (**recurrence relations** or **difference equations**), or we can take a **continuous limit** and convert them into **ordinary differential equations**.

"""

# ╔═╡ 4ca399f4-8b45-11eb-2d2b-8189e04fc804
md"""
## Modelling time to success (or time to failure)
"""

# ╔═╡ 57080632-8b45-11eb-1003-05afb2331b25
md"""
Let's start with a very simple model of **time to success**. Suppose we are playing a game in which we have a probability $p$ of success on each turn. How many turns do we need until we succeed? For example, how many rolls of a die do we need until we roll a 6? How many rolls of 2 dice until we get a double 6?
"""

# ╔═╡ 139ecfec-8b46-11eb-2649-2f77833d749a
md"""
This can be used as a model in many different situations, for example: Time to failure of a light bulb or a piece of machinery; time for a radioactive nucleus to decay; time to recover from an infection, etc.
"""

# ╔═╡ f9a75ac4-08d9-11eb-3167-011eb698a32c
md"""

The basic question is:

> Suppose we have $N$ light bulbs that are working correctly on day $0$. 
> 
> - If each bulb has probability $p$ to fail on each day, how many are still working at day number $t$?
> - How long, on average, will a given bulb last?
> - And, do light bulbs really fail exactly at midnight each night? Can you imagine a more realistic model?



As usual we will take a computational thinking point of view: let's code up the simulation and plot the results. Then we can step back and 
"""

# ╔═╡ 17812c7c-8cac-11eb-1d0a-6512415f6938
md"""
## Visualizing component failure
"""

# ╔═╡ a38fe2b2-8cae-11eb-19e8-d563e82855d3
gr()

# ╔═╡ 18da7920-8cac-11eb-07f4-e109298fd5f1
begin
	rectangle(w, h, x, y) = (x .+ [0,w,w,0], y .+ [0,0,h,h])
	
	circle(r,x,y) = (θ = LinRange(0, 2π, 30); (x.+r.*cos.(θ), y.+r.*sin.(θ)))
end

# ╔═╡ a9447530-8cb6-11eb-38f7-ff69a640e3c4
md"""
## String interpolation
"""

# ╔═╡ c1fde6ba-8cb6-11eb-2170-af6bc84c01a7
md"""
As an aside, how could we display a picture of Daniel Bernoulli and resize it in Pluto? To do so we use a piece of HTML, which we represent as a string. We need to substitute the *value* of a Julia variable into the string, which we do with string interpolation, with the syntax `$(variable)` inside the string.
		
Then we convert the string to HTML with the `HTML(...)` constructor:
"""

# ╔═╡ 18755e3e-8cac-11eb-37bf-1dfa5fbe730a
@bind bernoulliwidth Slider(10:10:500, show_value=true)

# ╔═╡ f947a976-8cb6-11eb-2ae7-59eba4c6f40f
url = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/ETH-BIB-Bernoulli%2C_Daniel_%281700-1782%29-Portrait-Portr_10971.tif_%28cropped%29.jpg/440px-ETH-BIB-Bernoulli%2C_Daniel_%281700-1782%29-Portrait-Portr_10971.tif_%28cropped%29.jpg"

# ╔═╡ 5a0b407e-8cb7-11eb-0c0d-c7767a6b0a1d
s = "<img src=$(url) width=$(bernoulliwidth) >"

# ╔═╡ fe53ee0c-8cb6-11eb-19bc-2976da1abe16
md"""
Note that we can use *three* sets of double quotes (`"`) to represent a **multi-line** string, or to enclose another string that itself contains quotes.
"""

# ╔═╡ 1894b388-8cac-11eb-2287-97f985df1fbd
HTML(s)

# ╔═╡ 71fbc75e-8bf3-11eb-3ac9-dd5401033c78
md"""
## Math: Bernoulli random variables
"""

# ╔═╡ 7c01f6a6-8bf3-11eb-3c4d-ad7e206a9277
md"""
Recall that a **Bernoulli random variable** models a weighted coin: it takes the value 1, with probability $p$, and 0, with probability $(1 - p)$:
"""

# ╔═╡ dcd279b0-8bf3-11eb-0cb9-95f351626ed1
md"""
Note that `rand() < p` returns a `Bool` (true or false). We are converting to `Int` to get a value 1 or 0.
"""

# ╔═╡ fbada990-8bf3-11eb-2bb7-d786362669e8
md"""
Let's generate (sample) some Bernoulli random variates:
"""

# ╔═╡ ac98f5da-8bf3-11eb-076f-597ce4455e76
md"""
It is natural to ask what the **mean**, or **expected value**, is:
"""

# ╔═╡ 111eccd2-8bf4-11eb-097c-7582f811d146
md"""
If you think about how to calculate the mean (sum up and divide by the total number of flips), it just gives the proportion of 1s, which should be around $p$.

#### Exercise: 
Calculate the variance of a Bernoulli random variable. 

Hint: What happens when you sum the squares? Remember that you also need to center the data. 
"""

# ╔═╡ 4edaec4a-8bf4-11eb-3094-010ebe9b56ab
md"""
## Julia: Make it a type!
"""

# ╔═╡ 9d66e31e-8cad-11eb-3ad0-3980ba66cb0e
md"""

Currently we need one function for sampling from a Bernoulli random variable, a different function to calculate its mean, a different function for its standard deviation, etc. 

From a mathematical point of view we have the concept "Bernoulli random variable" and we are calculating properties of that concept. Computationally we can *do the same thing!* by creating a new *object* to represent "a Bernoulli random variable".
"""

# ╔═╡ 8405e310-8bf8-11eb-282b-d93b4fc683aa
struct Bernoulli
	p::Float64
end

# ╔═╡ af2594c4-8cad-11eb-0fff-f59e65102b3f
md"""
We want to be able to sample from it, using `rand`, and take its `mean`.
To do so we will **extend** (sometimes called "overload") the `rand` function from Julia's `Base` library, and the `mean` function from the `Statistics` standard library. Note that we are *adding methods* to these functions; you will do this in the homework.
"""

# ╔═╡ 8aa60da0-8bf8-11eb-0fa2-11aeecb89564
Base.rand(X::Bernoulli) = Int( rand() < X.p )

# ╔═╡ a034c2a6-8bf8-11eb-0f06-0b35a0e8e68d
B = Bernoulli(0.25)

# ╔═╡ 3ef23da4-8cb4-11eb-0d5f-d5ee8fc56227
md"""
The object `B` really represents "a Bernoulli random variable with probability of success $p$". Since all such random variables are the same, this represents *any* Bernoulli random variable with that probability.

We should use this type any time we need a Bernoulli random variable. If you need this in another notebook you will either need to copy and paste the definition or, better, make your own mini-library. However, note that types like this are already available in the `Distributions.jl` package and the new `MeasureTheory.jl` package.
"""

# ╔═╡ 2d9c560e-8bf9-11eb-1ac5-f77f7caf776f
Statistics.mean(X::Bernoulli) = X.p

# ╔═╡ ce94541c-8bf9-11eb-1ac9-51e66a017813
mean(B)

# ╔═╡ a057e7ee-8bf9-11eb-2ceb-2dda3718a70a
md"""
## Running the stochastic simulation
"""

# ╔═╡ 4a743662-8cb6-11eb-26a6-d911e60653e4
md"""
Let's take the simulation and run it a few times.
"""

# ╔═╡ 9282eca0-08db-11eb-2e36-d761594b427c
T = 100

# ╔═╡ fe0aa72c-8b46-11eb-15aa-49ae570e5858
md"""
N = $(@bind N Slider(1:1000, show_value=true, default=70))

p = $(@bind ppp Slider(0:0.01:1, show_value=true, default=0.25))

t = $(@bind t Slider(1:T, show_value=true))
"""

# ╔═╡ 39a69c2a-0846-11eb-35c1-53c68a9f71e5
p = 0.1

# ╔═╡ caa3faa2-08e5-11eb-33fe-cbbc00cfd459
md"""
## Time evolution of the mean: Intuitive derivation
"""

# ╔═╡ 2174aeba-08e6-11eb-09a9-2d6a882a2604
md"""
The mean seems to behave in a rather predictable way over time. Can we derive this?

Let $N_t$ be the number of green light bulbs at time $t$. This decreases because some bulbs fail. Since bulbs fail with probability $p$, the number of bulbs that fail at time $t$ is, on average, $p I_t$. [Note that one time unit corresponds to one *sweep* of the simulation.]

At time $t$ there are $N_t$ green bulbs.
How many decay? Each decays with probability $p$, so *on average* $p I_t$ fail, so are removed from the number of infectious, giving the change

$$\Delta I_t = {\color{lightgreen} I_{t+1}} - {\color{lightgreen}I_t} = -{\color{red} p \, I_t}$$

So

$${\color{lightgreen} I_{t+1}} = {\color{lightgreen}I_t} - {\color{red} p \, I_t}$$

or

$$I_{t+1} = (1 - p) I_t .$$

"""

# ╔═╡ f5756dd6-0847-11eb-0870-fd06ad10b6c7
md"""
We can now take one step backwards:


$$I_{t+1} = (1 - p) (1 - p) I_{t-1} = (1 - p)^2 I_{t-1}$$


and then continue to solve the recurrence:

$$I_t = (1-p)^t \, I_0.$$
"""

# ╔═╡ 113c31b2-08ed-11eb-35ef-6b4726128eff
md"""
Let's compare the exact and numerical results:
"""

# ╔═╡ 3cd1ad48-08ed-11eb-294c-f96b0e7c33bb
md"""
They agree well, as they should. The agreement is expected to be better (i.e. the fluctuations smaller) for a larger population.
"""

# ╔═╡ f32b936a-8bf6-11eb-1dd7-fd8c5904bf1f
md"""
## Binomial distribution
"""

# ╔═╡ f8f38028-8bf6-11eb-321b-8f91e38da495
md"""

At time $0$ there are $N_0$ light bulbs. How many will turn ``{\color{red} \text{red}}`` (fail) at the first step? Let's call this $\Delta N_0$.

Intuitively, the mean is $\mean{\Delta N_0} = p N_0$, but in fact $\Delta N_0$ is a random variable! In principle, it could be that no light bulbs fail, or all of them fail, but both of those events have very small probability.

For each of the $N_0$ bulbs, $i=1, \ldots, N_0$, we have a Bernoulli random variable that tells us if bulb $i$ will fail. Let's call them we call $B_0^i$.
Then 

$$\Delta N_0 = \sum_{i=1}^{N_0} B_0^i$$
"""

# ╔═╡ 2de1ef6c-8cb1-11eb-3dd9-f3904ec1408b
md"""
Let's make a type to represent the sum of $N$ Bernoullis with probability $p$. This is called a **binomial random variable**. The *only* information that we require is just that, $N$ and $p$.
"""

# ╔═╡ 48fb6ed6-8cb1-11eb-0894-b526e6c43b01
struct Binomial
	N::Int64
	p::Float64
end

# ╔═╡ 713a2644-8cb1-11eb-1904-f301e39d141e
md"""
Note that does not require (or even allow) methods at first, as some other languages would. You can add methods later, and other people can add methods too if they can load your package. (But they do *not* need to modify *your* code.)
"""

# ╔═╡ 511892e0-8cb1-11eb-3814-b98e8e0bbe5c
Base.rand(X::Binomial) = sum(rand(Bernoulli(X.p)) for i in 1:X.N)

# ╔═╡ 178631ec-8cac-11eb-1117-5d872ba7f66e
function simulate(N, p, max_steps=100)
	v = fill(max_steps, N, N)
	t = 0

	while any( v .== max_steps ) && t < max_steps
		t += 1

		for i= 1:N, j=1:N
			if rand() < p && v[i,j]==max_steps
				v[i,j] = t
			end
		end

	end

	return v
end

# ╔═╡ ba7ffe78-0845-11eb-2847-851a407dd2ec
bernoulli(p) = rand() < p

# ╔═╡ b6786ec8-8bf3-11eb-1347-61f231fd3b4c
flips = [Int(bernoulli(0.25)) for i in 1:100]

# ╔═╡ 0e7a04a4-8bf4-11eb-2e9d-fb48c23b8d8c
mean(flips)

# ╔═╡ e2d764d0-0845-11eb-0031-e74d2f5acaf9
function step!(infectious, p)
	for i in 1:length(infectious)
		
		if infectious[i] && bernoulli(p)
			infectious[i] = false
		end
	end
	
	return infectious
end

# ╔═╡ 58d8542c-08db-11eb-193a-398ce01b8635
begin
	infected = [true for i in 1:N]
		
	results = [copy(step!(infected, ppp)) for i in 1:T]
	pushfirst!(results, trues(N))
end

# ╔═╡ 33f9fc36-0846-11eb-18c2-77f92fca3176
function simulate_recovery(p, T)
	infectious = trues(N)
	num_infectious = [N]
	
	for t in 1:T
		step!(infectious, p)
		push!(num_infectious, count(infectious))
	end
	
	return num_infectious
end

# ╔═╡ cb278624-08dd-11eb-3375-276bfe8d7b3a
begin
	pp = 0.05
	
	plot(simulate_recovery(pp, T), label="run 1", alpha=0.5, lw=2, m=:o)
	plot!(simulate_recovery(pp, T), label="run 2", alpha=0.5, lw=2, m=:o)
	
	xlabel!("time t")
	ylabel!("number infectious")
end

# ╔═╡ 6a545268-0846-11eb-3861-c3d5f52c061b
exact = [N * (1-pp)^t for t in 0:T]

# ╔═╡ f3c85814-0846-11eb-1266-63f31f351a51
all_data = [simulate_recovery(pp, T) for i in 1:30];

# ╔═╡ 01dbe272-0847-11eb-1331-4360a575ff14
begin
	plot(all_data, alpha=0.1, leg=false, m=:o, ms=1,
		size=(500, 400), label="")
	xlabel!("time t")
	ylabel!("number still functioning")
end

# ╔═╡ be8e4ac2-08dd-11eb-2f72-a9da5a750d32
plot!(mean(all_data), leg=true, label="mean",
		lw=3, c=:red, m=:o, alpha=0.5, 
		size=(500, 400))

# ╔═╡ 8bc52d58-0848-11eb-3487-ef0d06061042
begin
	plot(replace.(all_data, 0.0 => NaN), 
		yscale=:log10, alpha=0.3, leg=false, m=:o, ms=1,
		size=(500, 400))
	
	plot!(mean(all_data), yscale=:log10, lw=3, c=:red, m=:o, label="mean", alpha=0.5)
	
	xlabel!("time t")
	ylabel!("number still functioning")
end



# ╔═╡ 4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
begin
	plot(mean(all_data), m=:o, alpha=0.5, label="mean of stochastic simulations",
		size=(500, 400))
	plot!(exact, lw=3, alpha=0.8, label="deterministic model", leg=:right)
	title!("Experiment vs. theory")
	xlabel!("time")
	ylabel!("""number of "greens" """)
end
	

# ╔═╡ bc5d6fae-8cad-11eb-3351-a734d2366557
rand(B)

# ╔═╡ 1173ebbe-8cb1-11eb-0a21-7d40a2c8a855
rand(Binomial(10, 0.25))

# ╔═╡ dfdaf1dc-8cb1-11eb-0287-f150380d323b
md"""
N = $(@bind binomial_N Slider(1:100, show_value=true, default=1)); 
p = $(@bind binomial_p Slider(0.0:0.01:1, show_value=true, default=0))

"""

# ╔═╡ ca3db0a8-8cb1-11eb-2f7b-c9343a29ed02
begin
	binomial_data = [rand(Binomial(binomial_N, binomial_p)) for i in 1:10000]
	
	bar(countmap(binomial_data), alpha=0.5, size=(500, 300), leg=false, bin_width=0.5)
end

# ╔═╡ b3ce9e3a-8c35-11eb-1ad0-81f9b09f963e
md"""
Let's call $q := 1 - p$.
Then for each bulb we are choosing either $p$ (failure) or $q$ (non-failure). (This is the same as flipping $n$ independent, weighted coins.)

The number of ways of choosing such that $k$ bulbs fail is given by the coefficient of $p^k$ in the expansion of $(p + q)^n$, namely the **binomial coefficient**

$$\begin{pmatrix} n \\ k \end{pmatrix} := \frac{n!}{k! \, (n-k)!},$$

where $n! := 1 \times 2 \times \cdots n$ is the factorial of $n$.

"""

# ╔═╡ 2f980870-0848-11eb-3edb-0d4cd1ed5b3d
md"""
## Continuous time

If we look at the graph of the mean as a function of time, it seems to follow a smooth curve. Indeed it makes sense to ask not only how many people have recovered each *day*, but to aim for finer granularity.

Suppose we instead increment time in steps of $\delta t$; the above analysis was for $\delta t = 1$.

Then we will need to adjust the probability of recovery in each time step. 
It turns out that to make sense in the limit $\delta t \to 0$, we need to choose the probability $p(\delta t)$ to recover in time $t$ to be proportional to $\delta t$:

$$p(\delta t) \simeq \lambda \, \delta t,$$

where $\lambda$ is the recovery **rate**. Note that a rate is a probability *per unit time*.

We get
"""

# ╔═╡ 6af30142-08b4-11eb-3759-4d2505faf5a0
md"""
$$I(t + \delta t) - I(t) \simeq -\lambda \,\delta t \, I(t)$$
"""

# ╔═╡ c6f9feb6-08f3-11eb-0930-83385ca5f032
md"""
Dividing by $\delta t$ gives

$$\frac{I(t + \delta t) - I(t)}{\delta t} \simeq -\lambda \, I(t)$$

We recognise the left-hand side as the definition of the **derivative** when $\delta t \to 0$. Taking that limit finally gives
"""

# ╔═╡ d8d8e7d8-08b4-11eb-086e-6fdb88511c6a
md"""
$$\frac{dI(t)}{dt} = -\lambda \, I(t)$$

That is, we obtain an **ordinary differential equation** that gives the solution implicitly. Solving this equation with initial condition $I(0) = I_0$ gives
"""

# ╔═╡ 780c483a-08f4-11eb-1205-0b8aaa4b1c2d
md"""
$$I(t) = I_0 \exp(-\lambda \, t).$$
"""

# ╔═╡ a13dd444-08f4-11eb-08f5-df9dd99c8ab5
md"""
Alternatively, we can derive this by recognising the exponential in the limit $\delta t \to 0$ of the following expression, which is basically the expression for compounding interest:
"""

# ╔═╡ cb99fe22-0848-11eb-1f61-5953be879f92
md"""
$$I_{t} = (1 - \lambda \, \delta t)^{(t / \delta t)} I_0$$
"""

# ╔═╡ 8d2858a4-8c38-11eb-0b3b-61a913eed928
md"""
## Discrete to continuous
"""

# ╔═╡ 93da8b36-8c38-11eb-122a-85314d6e1921
function plot_cumulative!(p, N, δ=1; kw...)
    ps = [p * (1 - p)^(n-1) for n in 1:N]
    cumulative = cumsum(ps)

    ys = [0; reduce(vcat, [ [cumulative[n], cumulative[n]] for n in 1:N ])]

    pop!(ys)
    pushfirst!(ys, 0)

    xs = [0; reduce(vcat, [ [n*δ, n*δ] for n in 1:N ])];

    # plot!(xs, ys)
    scatter!([n*δ for n in 1:N], cumulative; kw...)
end

# ╔═╡ f1f0529a-8c39-11eb-372b-95d591a573e2
plotly()

# ╔═╡ 9572eda8-8c38-11eb-258c-739b511de833
begin
	plot(size=(500, 300), leg=false)
	plot_cumulative!(0.1, 30, 1.0, ms=2, c=:red, alpha=1)
#	plot_cumulative!(0.1, 30, 0.5, ms=2, c=:red)
	plot_cumulative!(0.05, 60, 0.5; label="", ms=2, c=:lightgreen, alpha=1)
	plot_cumulative!(0.025, 120, 0.25; label="", ms=1, c=:lightgreen, alpha=1)
	plot_cumulative!(0.0125, 240, 0.125; label="", ms=1, c=:lightgreen, alpha=1)
	
end

# ╔═╡ 7850b114-8c3b-11eb-276a-df5c332bf6d3
1 - 0.95^2  # almost 10%

# ╔═╡ 9f41d4f2-8c38-11eb-3eae-a1ec0d86d64c
begin
	λ = -log(1 - 0.1)
	
	plot!(0:0.01:20, t -> 1 - exp(-λ*t), lw=1)
	plot!(0:0.01:20, t -> 1 - exp(-0.1*t), lw=1)

	
end

# ╔═╡ 148f486c-8c3d-11eb-069f-cd595c5f7177
md"""
What does it mean to talk about a **rate** -- a probability per unit time.
"""

# ╔═╡ 4d61636e-8c3d-11eb-2726-6dc51e8a4f84


# ╔═╡ 3ae9fc0a-8c3d-11eb-09d5-13cefa2d9da5
md"""
How many light bulbs turn red in 1 second, half a second. Looks like 0 / 0. If have billions of light bulbs.
"""

# ╔═╡ c92bf164-8c3d-11eb-128c-7bd2c0ad681e
md"""
People get sick / light bulbs not on discrete time clock. Limit as $\delta t \to 0$

You measure it discretely
"""

# ╔═╡ 1336397c-8c3c-11eb-2ecf-eb017a3a65cd
λ

# ╔═╡ d74bace6-08f4-11eb-2a6b-891e52952f57
md"""
## SIR model
"""

# ╔═╡ dbdf2812-08f4-11eb-25e7-811522b24627
md"""
Now let's extend the procedure to the full SIR model, $S \to I \to R$. Since we already know how to deal with recovery, consider just the SI model, where susceptible agents are infected via contact, with probability
"""

# ╔═╡ 238f0716-0903-11eb-1595-df71600f5de7
md"""
Let's denote by $S_t$ and $I_t$ be the number of susceptible and infectious people at time $t$, respectively, and by $N$ the total number of people.

On average, in each sweep each infectious individual has the chance to interact with one other individual. That individual is chosen uniformly at random from the total population of size $N$. But a new infection occurs only if that chosen individual is susceptible, which happens with probability $S_t / N$, and then if the infection is successful, with probability $b$, say.

Hence the change in the number of infectious people after that step is.

The decrease in $S_t$ is also given by $\Delta I_t$.
"""

# ╔═╡ 8e771c8a-0903-11eb-1e34-39de4f45412b
md"""
$$\Delta I_t = I_{t+1} - I_t = b \, I_t \, \left(\frac{S_t}{N} \right)$$
"""

# ╔═╡ e83fc5b8-0904-11eb-096b-8da3a1acba12
md"""
It is useful to normalize by $N$, so we define

$$s_t := \frac{S_t}{N}; \quad i_t := \frac{I_t}{N}; \quad r_t := \frac{R_t}{N}$$
"""

# ╔═╡ d1fbea7a-0904-11eb-377d-690d7a16aa7b
md"""
Including recovery with probability $c$ we obtain the **discrete-time SIR model**:
"""

# ╔═╡ dba896a4-0904-11eb-3c47-cbbf6c01e830
md"""
$$\begin{align}
s_{t+1} &= s_t - b \, s_t \, i_t \\
i_{t+1} &= i_t + b \, s_t \, i_t - c \, i_t\\
r_{t+1} &= r_t + c \, i_t
\end{align}$$
"""

# ╔═╡ 267cd19e-090d-11eb-0676-0f88b57da937
md"""
Again we can obtain this from the stochastic process by taking expectations (exercise!). [Hint: Ignore recovery to start with and take variables $Y_t^i$ that are $0$ if the person is susceptible and 1 if it is infected.]
"""

# ╔═╡ 4e3c7e62-090d-11eb-3d16-e921405a6b16
md"""
And again we can allow the processes to occur in steps of length $\delta t$ and take the limit $\delta t \to 0$. With rates $\beta$ and $\gamma$ we obtain the standard (continuous-time) **SIR model**:
"""

# ╔═╡ 72061c66-090d-11eb-14c0-df619958e2b6
md"""
$$\begin{align}
\textstyle \frac{ds(t)}{dt} &= -\beta \, s(t) \, i(t) \\
\textstyle \frac{di(t)}{dt} &= +\beta \, s(t) \, i(t) &- \gamma \, i(t)\\
\textstyle \frac{dr(t)}{dt} &= &+ \gamma \, i(t)
\end{align}$$
"""

# ╔═╡ c07367be-0987-11eb-0680-0bebd894e1be
md"""
We can think of this as a model of a chemical reaction with species S, I and R. The term $s(t) i(t)$ is known as the [**mass action**](https://en.wikipedia.org/wiki/Law_of_mass_action) form of interaction.

Note that no analytical solutions of these (simple) nonlinear ODEs are known as a function of time! (However, [parametric solutions are known](https://arxiv.org/abs/1403.2160).)
"""

# ╔═╡ f8a28ba0-0915-11eb-12d1-336f291e1d84
md"""
Below is a simulation of the discrete-time model. Note that the simplest numerical method to solve (approximately) the system of ODEs, the **Euler method**, basically reduces to solving the discrete-time model!  A whole suite of more advanced ODE solvers is provided in the [Julia `DiffEq` ecosystem](https://diffeq.sciml.ai/dev/).
"""

# ╔═╡ d994e972-090d-11eb-1b77-6d5ddb5daeab
begin
	NN = 100
	
	SS = NN - 1
	II = 1
	RR = 0
end

# ╔═╡ 050bffbc-0915-11eb-2925-ad11b3f67030
ss, ii, rr = SS/NN, II/NN, RR/NN

# ╔═╡ 1d0baf98-0915-11eb-2f1e-8176d14c06ad
p_infection, p_recovery = 0.1, 0.01

# ╔═╡ 28e1ec24-0915-11eb-228c-4daf9abe189b
TT = 1000

# ╔═╡ 349eb1b6-0915-11eb-36e3-1b9459c38a95
function discrete_SIR(s0, i0, r0, T=1000)

	s, i, r = s0, i0, r0
	
	results = [(s=s, i=i, r=r)]
	
	for t in 1:T

		Δi = p_infection * s * i
		Δr = p_recovery * i
		
		s_new = s - Δi
		i_new = i + Δi - Δr
		r_new = r      + Δr

		push!(results, (s=s_new, i=i_new, r=r_new))

		s, i, r = s_new, i_new, r_new
	end
	
	return results
end

# ╔═╡ 39c24ef0-0915-11eb-1a0e-c56f7dd01235
SIR = discrete_SIR(ss, ii, rr)

# ╔═╡ 442035a6-0915-11eb-21de-e11cf950f230
begin
	ts = 1:length(SIR)
	discrete_time_SIR_plot = plot(ts, [x.s for x in SIR], 
		m=:o, label="S", alpha=0.2, linecolor=:blue, leg=:right, size=(400, 300))
	plot!(ts, [x.i for x in SIR], m=:o, label="I", alpha=0.2)
	plot!(ts, [x.r for x in SIR], m=:o, label="R", alpha=0.2)
	
	xlims!(0, 500)
end

# ╔═╡ 84ba80d9-a4b6-4972-968e-b88b6f61cfb9
macro bindname(name::Symbol, ex::Expr)
    quote
        HypertextLiteral.@htl("""
		<div style='display: flex;'>
        <code style='font-weight: bold'>$($(String(name)))</code>: $(@bind $(name) $(esc(ex)))
		</div>
        """)
    end
end

# ╔═╡ 179a4db2-8cac-11eb-374f-0f24dc81ebeb
@bindname M Slider(2:20, show_value=true, default=8)

# ╔═╡ 8c8b5681-eeaa-4087-8b6b-1c72c99ae36b
@bindname prob Slider(0.01:.01:1, show_value=true, default=.1)

# ╔═╡ 17bbf532-8cac-11eb-1e3f-c54072021208
simulation = simulate(M, prob)

# ╔═╡ 3bfed362-9732-4cb5-86a6-ec50b8429ad5
@bindname tt Slider(1:100, show_value=true, default=1)

# ╔═╡ 17e0d142-8cac-11eb-2d6a-fdf175f5d419
begin
	w = .9
	h = .9
	c = [RGB(0,1,0), RGB(1,0,0), :purple][1 .+ (simulation .< tt) .+ (simulation .<  (tt.-1))] 
	
	plot(ratio=1, legend=false, axis=false, ticks=false)
	
	for i=1:M, j=1:M
		plot!( rectangle(w,h, i, j), c=:black, fill=true, alpha=0.5)
		plot!( circle(.3,i+.45,j+.45), c = c[i, j], fill=true)
	end
	
	for i=1:M, j=1:M
		if simulation[i,j] < tt
	       annotate!(i+.45, j+.5, text("$(simulation[i,j])", font(7), :white))
		end
	end
    
	
	plot!(lims=(0.5, M+1.1), title="time = $(tt-1);  failed count: $(sum(simulation.<tt))")
	
end

# ╔═╡ 17fe87a0-8cac-11eb-2938-2d9cd19ecc0f
begin
	
	plot(size=(500, 300))
	cdf= [ count(simulation .≤ i) for i=0:100] 
	bar!(cdf, c=:purple, legend=false, xlim=(0,tt),alpha=0.8)
end

# ╔═╡ 1829091c-8cac-11eb-1b77-c5ed7dd1261b
begin
	newcdf = [ count(simulation .> i) for i=0:100] 
	bar!( newcdf, c=RGB(0,1,0), legend=false, xlim=(0,tt),alpha=0.8)
end

# ╔═╡ 1851dd6a-8cac-11eb-18e4-87dbe1714be0
bar(countmap(simulation[:]), c=:red, legend=false, xlim=(0, tt+.5), size=(500, 300))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
HypertextLiteral = "~0.9.4"
Plots = "~1.40.5"
PlutoUI = "~0.7.48"
StatsBase = "~0.34.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "13cb1aa36c5c7caa918c1f40c3045a0e1bdfee6c"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a2f1c8c668c8e3cb4cca4e57a8efdb09067bb3fd"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "b8fe8546d52ca154ac556809e10c75e6e7430ac8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.5"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "b1c55339b7c6c350ee89f2c1604299660525b248"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.15.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "5c1d8ae0efc6c2e7b1fc502cbe25def8f661b7bc"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.2+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "3f74912a156096bd8fdbef211eff66ab446e7297"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "3e527447a45901ea392fe12120783ad6ec222803"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.6"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "182c478a179b267dd7a741b6f8f4c3e0803795d6"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.6+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "7c82e6a6cd34e9d935e9aa4051b66c6ff3af59ba"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.2+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c84a835e1a09b289ffcd2271bf2a337bbdda6637"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.3+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "5b0d630f3020b82c0775a51d05895852f8506f50"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.4"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fbb1f2bef882392312feb1ede3615ddc1e9b99ed"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.49.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0c4f9c4f1a50d8f35048fa0532dabbadf702f81e"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.1+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5ee6203157c120d79034c748a2acba45b82b8807"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.1+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a028ee3cb5641cccc4c24e90c36b0a4f7707bdf5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.14+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "6e55c6841ce3411ccb3457ee52fc48cb698d6fb0"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.2.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "082f0c4b70c202c37784ce4bfbc33c9f437685bf"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.5"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "96612ac5365777520c3c5396314c8cf7408f436a"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.1"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d95fe458f26209c66a187b1114df96fd70839efd"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.21.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "d9717ce3518dc68a99e6b96300813760d887a01d"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.1+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "a54ee957f4c86b526460a720dbc882fa5edcbefc"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.41+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "bcd466676fef0878338c61e655629fa7bbc69d8e"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

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
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╠═9a0cec14-08db-11eb-3cfa-4d1c327c63f1
# ╠═fb6cdc08-8b44-11eb-09f5-43c167aa53fd
# ╟─b6b055b6-8cae-11eb-29e5-b507c1a2b9bf
# ╟─bcfaedfa-8cae-11eb-10a1-cb7be7dc2e6b
# ╟─d2c19564-8b44-11eb-1077-ddf6d1395b59
# ╟─ac4f6944-08d9-11eb-0b3c-f5e0a8b8c17e
# ╟─4ca399f4-8b45-11eb-2d2b-8189e04fc804
# ╟─57080632-8b45-11eb-1003-05afb2331b25
# ╟─139ecfec-8b46-11eb-2649-2f77833d749a
# ╟─f9a75ac4-08d9-11eb-3167-011eb698a32c
# ╟─17812c7c-8cac-11eb-1d0a-6512415f6938
# ╠═178631ec-8cac-11eb-1117-5d872ba7f66e
# ╠═179a4db2-8cac-11eb-374f-0f24dc81ebeb
# ╠═17bbf532-8cac-11eb-1e3f-c54072021208
# ╠═8c8b5681-eeaa-4087-8b6b-1c72c99ae36b
# ╠═3bfed362-9732-4cb5-86a6-ec50b8429ad5
# ╠═a38fe2b2-8cae-11eb-19e8-d563e82855d3
# ╠═17e0d142-8cac-11eb-2d6a-fdf175f5d419
# ╠═18da7920-8cac-11eb-07f4-e109298fd5f1
# ╟─17fe87a0-8cac-11eb-2938-2d9cd19ecc0f
# ╟─1829091c-8cac-11eb-1b77-c5ed7dd1261b
# ╟─1851dd6a-8cac-11eb-18e4-87dbe1714be0
# ╟─a9447530-8cb6-11eb-38f7-ff69a640e3c4
# ╟─c1fde6ba-8cb6-11eb-2170-af6bc84c01a7
# ╠═18755e3e-8cac-11eb-37bf-1dfa5fbe730a
# ╠═f947a976-8cb6-11eb-2ae7-59eba4c6f40f
# ╠═5a0b407e-8cb7-11eb-0c0d-c7767a6b0a1d
# ╟─fe53ee0c-8cb6-11eb-19bc-2976da1abe16
# ╠═1894b388-8cac-11eb-2287-97f985df1fbd
# ╟─71fbc75e-8bf3-11eb-3ac9-dd5401033c78
# ╟─7c01f6a6-8bf3-11eb-3c4d-ad7e206a9277
# ╠═ba7ffe78-0845-11eb-2847-851a407dd2ec
# ╟─dcd279b0-8bf3-11eb-0cb9-95f351626ed1
# ╟─fbada990-8bf3-11eb-2bb7-d786362669e8
# ╠═b6786ec8-8bf3-11eb-1347-61f231fd3b4c
# ╟─ac98f5da-8bf3-11eb-076f-597ce4455e76
# ╠═0e7a04a4-8bf4-11eb-2e9d-fb48c23b8d8c
# ╟─111eccd2-8bf4-11eb-097c-7582f811d146
# ╟─4edaec4a-8bf4-11eb-3094-010ebe9b56ab
# ╟─9d66e31e-8cad-11eb-3ad0-3980ba66cb0e
# ╠═8405e310-8bf8-11eb-282b-d93b4fc683aa
# ╟─af2594c4-8cad-11eb-0fff-f59e65102b3f
# ╠═8aa60da0-8bf8-11eb-0fa2-11aeecb89564
# ╠═a034c2a6-8bf8-11eb-0f06-0b35a0e8e68d
# ╟─3ef23da4-8cb4-11eb-0d5f-d5ee8fc56227
# ╠═bc5d6fae-8cad-11eb-3351-a734d2366557
# ╠═2d9c560e-8bf9-11eb-1ac5-f77f7caf776f
# ╠═ce94541c-8bf9-11eb-1ac9-51e66a017813
# ╟─a057e7ee-8bf9-11eb-2ceb-2dda3718a70a
# ╟─4a743662-8cb6-11eb-26a6-d911e60653e4
# ╠═e2d764d0-0845-11eb-0031-e74d2f5acaf9
# ╠═9282eca0-08db-11eb-2e36-d761594b427c
# ╠═58d8542c-08db-11eb-193a-398ce01b8635
# ╟─fe0aa72c-8b46-11eb-15aa-49ae570e5858
# ╠═33f9fc36-0846-11eb-18c2-77f92fca3176
# ╠═39a69c2a-0846-11eb-35c1-53c68a9f71e5
# ╠═cb278624-08dd-11eb-3375-276bfe8d7b3a
# ╠═f3c85814-0846-11eb-1266-63f31f351a51
# ╟─01dbe272-0847-11eb-1331-4360a575ff14
# ╟─be8e4ac2-08dd-11eb-2f72-a9da5a750d32
# ╟─8bc52d58-0848-11eb-3487-ef0d06061042
# ╟─caa3faa2-08e5-11eb-33fe-cbbc00cfd459
# ╟─2174aeba-08e6-11eb-09a9-2d6a882a2604
# ╟─f5756dd6-0847-11eb-0870-fd06ad10b6c7
# ╟─113c31b2-08ed-11eb-35ef-6b4726128eff
# ╟─6a545268-0846-11eb-3861-c3d5f52c061b
# ╟─4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
# ╟─3cd1ad48-08ed-11eb-294c-f96b0e7c33bb
# ╟─f32b936a-8bf6-11eb-1dd7-fd8c5904bf1f
# ╟─f8f38028-8bf6-11eb-321b-8f91e38da495
# ╟─2de1ef6c-8cb1-11eb-3dd9-f3904ec1408b
# ╠═48fb6ed6-8cb1-11eb-0894-b526e6c43b01
# ╟─713a2644-8cb1-11eb-1904-f301e39d141e
# ╠═511892e0-8cb1-11eb-3814-b98e8e0bbe5c
# ╠═1173ebbe-8cb1-11eb-0a21-7d40a2c8a855
# ╟─dfdaf1dc-8cb1-11eb-0287-f150380d323b
# ╠═ca3db0a8-8cb1-11eb-2f7b-c9343a29ed02
# ╟─b3ce9e3a-8c35-11eb-1ad0-81f9b09f963e
# ╟─2f980870-0848-11eb-3edb-0d4cd1ed5b3d
# ╟─6af30142-08b4-11eb-3759-4d2505faf5a0
# ╟─c6f9feb6-08f3-11eb-0930-83385ca5f032
# ╟─d8d8e7d8-08b4-11eb-086e-6fdb88511c6a
# ╟─780c483a-08f4-11eb-1205-0b8aaa4b1c2d
# ╟─a13dd444-08f4-11eb-08f5-df9dd99c8ab5
# ╟─cb99fe22-0848-11eb-1f61-5953be879f92
# ╟─8d2858a4-8c38-11eb-0b3b-61a913eed928
# ╠═93da8b36-8c38-11eb-122a-85314d6e1921
# ╟─f1f0529a-8c39-11eb-372b-95d591a573e2
# ╟─9572eda8-8c38-11eb-258c-739b511de833
# ╟─7850b114-8c3b-11eb-276a-df5c332bf6d3
# ╟─9f41d4f2-8c38-11eb-3eae-a1ec0d86d64c
# ╟─148f486c-8c3d-11eb-069f-cd595c5f7177
# ╟─4d61636e-8c3d-11eb-2726-6dc51e8a4f84
# ╟─3ae9fc0a-8c3d-11eb-09d5-13cefa2d9da5
# ╟─c92bf164-8c3d-11eb-128c-7bd2c0ad681e
# ╟─1336397c-8c3c-11eb-2ecf-eb017a3a65cd
# ╟─d74bace6-08f4-11eb-2a6b-891e52952f57
# ╟─dbdf2812-08f4-11eb-25e7-811522b24627
# ╟─238f0716-0903-11eb-1595-df71600f5de7
# ╟─8e771c8a-0903-11eb-1e34-39de4f45412b
# ╟─e83fc5b8-0904-11eb-096b-8da3a1acba12
# ╟─d1fbea7a-0904-11eb-377d-690d7a16aa7b
# ╟─dba896a4-0904-11eb-3c47-cbbf6c01e830
# ╟─267cd19e-090d-11eb-0676-0f88b57da937
# ╟─4e3c7e62-090d-11eb-3d16-e921405a6b16
# ╟─72061c66-090d-11eb-14c0-df619958e2b6
# ╟─c07367be-0987-11eb-0680-0bebd894e1be
# ╟─f8a28ba0-0915-11eb-12d1-336f291e1d84
# ╠═442035a6-0915-11eb-21de-e11cf950f230
# ╠═d994e972-090d-11eb-1b77-6d5ddb5daeab
# ╠═050bffbc-0915-11eb-2925-ad11b3f67030
# ╠═1d0baf98-0915-11eb-2f1e-8176d14c06ad
# ╠═28e1ec24-0915-11eb-228c-4daf9abe189b
# ╠═349eb1b6-0915-11eb-36e3-1b9459c38a95
# ╠═39c24ef0-0915-11eb-1a0e-c56f7dd01235
# ╟─84ba80d9-a4b6-4972-968e-b88b6f61cfb9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
