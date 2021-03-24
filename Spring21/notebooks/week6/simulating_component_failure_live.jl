### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 9a0cec14-08db-11eb-3cfa-4d1c327c63f1
begin
    import Pkg
	
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="StatsBase", version="0.33"),
    ])
	
    using Plots, PlutoUI, StatsBase, Statistics
end

# ╔═╡ fb6cdc08-8b44-11eb-09f5-43c167aa53fd
PlutoUI.TableOfContents(aside=true)

# ╔═╡ f3aad4f0-8cc2-11eb-1a25-535297327c65
md"""
# Modeling with stochastic simulation
"""

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

- Conventions on capitalization of function, variable and type names
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

# ╔═╡ 178631ec-8cac-11eb-1117-5d872ba7f66e
function simulate(N, p)
	v = fill(0, N, N)
	t = 0 
	
	while any( v .== 0 ) && t < 100
		t += 1
		
		for i= 1:N, j=1:N
			if rand() < p && v[i,j]==0
				v[i,j] = t
			end					    
		end
		
	end
	
	return v
end

# ╔═╡ 179a4db2-8cac-11eb-374f-0f24dc81ebeb
md"""
M= $(@bind M Slider(2:20, show_value=true, default=8))
"""

# ╔═╡ 17cf895a-8cac-11eb-017e-c79ffcab60b1
md"""
p= $(@bind prob Slider(0.01:.01:1, show_value=true, default=.1))

t = $(@bind tt Slider(1:100, show_value=true, default=1))
"""

# ╔═╡ 17bbf532-8cac-11eb-1e3f-c54072021208
simulation = simulate(M, prob)

# ╔═╡ a38fe2b2-8cae-11eb-19e8-d563e82855d3
gr()

# ╔═╡ 18da7920-8cac-11eb-07f4-e109298fd5f1
begin
	rectangle(w, h, x, y) = (x .+ [0, w, w, 0], y .+ [0, 0, h, h])
	
	circle(r, x, y) = (θ = range(0, 2π, length=30); (x .+ r .* cos.(θ), y .+ r .* sin.(θ)))
end

# ╔═╡ 17e0d142-8cac-11eb-2d6a-fdf175f5d419
begin
	w = .9
	h = .9
	c = [RGB(0,1,0), RGB(1,0,0), :purple][1 .+ (simulation .< tt) .+ (simulation .<  (tt.-1))] 
	
	plot(ratio=1, legend=false, axis=false, ticks=false)
	
	for i=1:M, j=1:M
		plot!(rectangle(w, h, i, j), c=:black, fill=true, alpha=0.5)
		plot!(circle(0.3, i+0.45, j+0.45), c = c[i, j], fill=true, alpha=0.5)
	end
	
	for i=1:M, j=1:M
		if simulation[i,j] < tt
	       annotate!(i+0.45, j+0.5, text("$(simulation[i, j])", 7, :white))
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

# ╔═╡ 86299112-8cc6-11eb-257a-9d803feac359
html"3 <br> 4"

# ╔═╡ 9eb69e94-8cc6-11eb-323b-5587cc743571
HTML("3 <br> 4")

# ╔═╡ b8d01ae4-8cc6-11eb-1d16-47095532f738
@bind num_breaks Slider(1:10, show_value=true)

# ╔═╡ c5bc97aa-8cc6-11eb-3564-fd96184ff2c3
repeat("<br>", 5)

# ╔═╡ d5cffd96-8cc6-11eb-2714-975d46d4fa27
"<br>"^5

# ╔═╡ da6525f0-8cc6-11eb-31ec-cd7d515f054a
"<br>" * "<br>" * "<br>"

# ╔═╡ fc715452-8cc6-11eb-0246-e941f7698cfe
HTML("3 $("<br>"^num_breaks) 4")

# ╔═╡ 71fbc75e-8bf3-11eb-3ac9-dd5401033c78
md"""
## Math: Bernoulli random variables
"""

# ╔═╡ 7c01f6a6-8bf3-11eb-3c4d-ad7e206a9277
md"""
Recall that a **Bernoulli random variable** models a weighted coin: it takes the value 1, with probability $p$, and 0, with probability $q = (1 - p)$:
"""

# ╔═╡ ba7ffe78-0845-11eb-2847-851a407dd2ec
bernoulli(p) = rand() < p

# ╔═╡ 45bb6df0-8cc7-11eb-100f-37c2a76df464
bernoulli(0.25)

# ╔═╡ dcd279b0-8bf3-11eb-0cb9-95f351626ed1
md"""
Note that `rand() < p` returns a `Bool` (true or false). We are converting to `Int` to get a value 1 or 0.
"""

# ╔═╡ fbada990-8bf3-11eb-2bb7-d786362669e8
md"""
Let's generate (sample) some Bernoulli random variates:
"""

# ╔═╡ b6786ec8-8bf3-11eb-1347-61f231fd3b4c
flips = [Int(bernoulli(0.25)) for i in 1:100]

# ╔═╡ ac98f5da-8bf3-11eb-076f-597ce4455e76
md"""
It is natural to ask what the **mean**, or **expected value**, is:
"""

# ╔═╡ 0e7a04a4-8bf4-11eb-2e9d-fb48c23b8d8c
sample_mean(data) = sum(data) / length(data)

# ╔═╡ 093275e4-8cc8-11eb-136f-3ffe522c4125
sample_mean(flips)

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
struct Bernoulli   # weighted coin flip
	p::Float64
end

# ╔═╡ af2594c4-8cad-11eb-0fff-f59e65102b3f
md"""
We want to be able to sample from it, using `rand`, and take its `mean`.
To do so we will **extend** (sometimes called "overload") the `rand` function from Julia's `Base` library, and the `mean` function from the `Statistics` standard library. Note that we are *adding methods* to these functions; you will do this in the homework.
"""

# ╔═╡ 8aa60da0-8bf8-11eb-0fa2-11aeecb89564
Base.rand(X::Bernoulli) = Int( rand() < X.p )

# ╔═╡ 8d56b6d2-8cc8-11eb-0dbd-b3533dde4aa3
md"""
[Recall: In Julia the convention is that functions and variable names start with lower-case letters; types start with upper case. Maybe with an exception for 1-letter variable names for mathematical objects.]
"""

# ╔═╡ a034c2a6-8bf8-11eb-0f06-0b35a0e8e68d
B = Bernoulli(0.25)

# ╔═╡ c166edb6-8cc8-11eb-0436-f74164ff6ea7
methods(Bernoulli)

# ╔═╡ d25dc130-8cc8-11eb-177f-63a1792494c0
Bernoulli(1//4)

# ╔═╡ e2f45234-8cc8-11eb-2be9-598eb590592a
rand(B)

# ╔═╡ 3ef23da4-8cb4-11eb-0d5f-d5ee8fc56227
md"""
The object `B` really represents "a Bernoulli random variable with probability of success $p$". Since all such random variables are the same, this represents *any* Bernoulli random variable with that probability.

We should use this type any time we need a Bernoulli random variable. If you need this in another notebook you will either need to copy and paste the definition or, better, make your own mini-library. However, note that types like this are already available in the `Distributions.jl` package and the new `MeasureTheory.jl` package.
"""

# ╔═╡ bc5d6fae-8cad-11eb-3351-a734d2366557
rand(B)

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

# ╔═╡ e2d764d0-0845-11eb-0031-e74d2f5acaf9
function step!(infectious, p)
	for i in 1:length(infectious)
		
		if infectious[i] && bernoulli(p)
			infectious[i] = false
		end
	end
	
	return infectious
end

# ╔═╡ 9282eca0-08db-11eb-2e36-d761594b427c
T = 100

# ╔═╡ fe0aa72c-8b46-11eb-15aa-49ae570e5858
md"""
N = $(@bind N Slider(1:1000, show_value=true, default=70))

p = $(@bind ppp Slider(0:0.01:1, show_value=true, default=0.25))

t = $(@bind t Slider(1:T, show_value=true))
"""

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

# ╔═╡ 39a69c2a-0846-11eb-35c1-53c68a9f71e5
p = 0.1

# ╔═╡ cb278624-08dd-11eb-3375-276bfe8d7b3a
begin
	pp = 0.05
	
	plot(simulate_recovery(pp, T), label="run 1", alpha=0.5, lw=2, m=:o)
	plot!(simulate_recovery(pp, T), label="run 2", alpha=0.5, lw=2, m=:o)
	
	xlabel!("time t")
	ylabel!("number of light bulbs that are alive")
end

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



# ╔═╡ caa3faa2-08e5-11eb-33fe-cbbc00cfd459
md"""
## Time evolution of the mean: Intuitive derivation
"""

# ╔═╡ 2174aeba-08e6-11eb-09a9-2d6a882a2604
md"""
The mean seems to behave in a rather predictable way over time. Can we derive this?

Let $N_t$ be the number of green light bulbs at time $t$. This decreases because some bulbs fail. Since bulbs fail with probability $p$, the number of bulbs that fail at time $t$ is, on average, $p N_t$. [Note that one time unit corresponds to one *sweep* of the simulation.]

At time $t$ there are $N_t$ green bulbs.
How many decay? Each decays with probability $p$, so *on average* $p N_t$ fail, so are removed from the number of infectious, giving the change

$$\Delta N_t = {\color{lightgreen} N_{t+1}} - {\color{lightgreen}N_t} = -{\color{red} p \, N_t}$$

So

$${\color{lightgreen} N_{t+1}} = {\color{lightgreen}N_t} - {\color{red} p \, N_t}$$

or

$$N_{t+1} = (1 - p) N_t .$$

"""

# ╔═╡ f5756dd6-0847-11eb-0870-fd06ad10b6c7
md"""
We can now take one step backwards:


$$N_{t+1} = (1 - p) (1 - p) N_{t-1} = (1 - p)^2 N_{t-1}$$


and then continue to solve the recurrence:

$$N_t = (1-p)^t \, N_0.$$
"""

# ╔═╡ 113c31b2-08ed-11eb-35ef-6b4726128eff
md"""
Let's compare the exact and numerical results:
"""

# ╔═╡ 6a545268-0846-11eb-3861-c3d5f52c061b
exact = [N * (1-pp)^t for t in 0:T]

# ╔═╡ 4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
begin
	plot(mean(all_data), m=:o, alpha=0.5, label="mean of stochastic simulations",
		size=(500, 400))
	plot!(exact, lw=3, alpha=0.8, label="deterministic model", leg=:right)
	title!("Experiment vs. theory")
	xlabel!("time")
	ylabel!("""number of "greens" """)
end
	

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

Intuitively, the mean is $\langle \Delta N_0 \rangle = p N_0$, but in fact $\Delta N_0$ is a random variable! In principle, it could be that no light bulbs fail, or all of them fail, but both of those events have very small probability.

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

# ╔═╡ Cell order:
# ╠═9a0cec14-08db-11eb-3cfa-4d1c327c63f1
# ╠═fb6cdc08-8b44-11eb-09f5-43c167aa53fd
# ╟─f3aad4f0-8cc2-11eb-1a25-535297327c65
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
# ╟─179a4db2-8cac-11eb-374f-0f24dc81ebeb
# ╠═17bbf532-8cac-11eb-1e3f-c54072021208
# ╟─17cf895a-8cac-11eb-017e-c79ffcab60b1
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
# ╠═86299112-8cc6-11eb-257a-9d803feac359
# ╠═9eb69e94-8cc6-11eb-323b-5587cc743571
# ╠═b8d01ae4-8cc6-11eb-1d16-47095532f738
# ╠═c5bc97aa-8cc6-11eb-3564-fd96184ff2c3
# ╠═d5cffd96-8cc6-11eb-2714-975d46d4fa27
# ╠═da6525f0-8cc6-11eb-31ec-cd7d515f054a
# ╠═fc715452-8cc6-11eb-0246-e941f7698cfe
# ╟─71fbc75e-8bf3-11eb-3ac9-dd5401033c78
# ╟─7c01f6a6-8bf3-11eb-3c4d-ad7e206a9277
# ╠═ba7ffe78-0845-11eb-2847-851a407dd2ec
# ╠═45bb6df0-8cc7-11eb-100f-37c2a76df464
# ╟─dcd279b0-8bf3-11eb-0cb9-95f351626ed1
# ╟─fbada990-8bf3-11eb-2bb7-d786362669e8
# ╠═b6786ec8-8bf3-11eb-1347-61f231fd3b4c
# ╟─ac98f5da-8bf3-11eb-076f-597ce4455e76
# ╠═0e7a04a4-8bf4-11eb-2e9d-fb48c23b8d8c
# ╠═093275e4-8cc8-11eb-136f-3ffe522c4125
# ╟─111eccd2-8bf4-11eb-097c-7582f811d146
# ╟─4edaec4a-8bf4-11eb-3094-010ebe9b56ab
# ╟─9d66e31e-8cad-11eb-3ad0-3980ba66cb0e
# ╠═8405e310-8bf8-11eb-282b-d93b4fc683aa
# ╟─af2594c4-8cad-11eb-0fff-f59e65102b3f
# ╠═8aa60da0-8bf8-11eb-0fa2-11aeecb89564
# ╟─8d56b6d2-8cc8-11eb-0dbd-b3533dde4aa3
# ╠═a034c2a6-8bf8-11eb-0f06-0b35a0e8e68d
# ╠═c166edb6-8cc8-11eb-0436-f74164ff6ea7
# ╠═d25dc130-8cc8-11eb-177f-63a1792494c0
# ╠═e2f45234-8cc8-11eb-2be9-598eb590592a
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
# ╠═01dbe272-0847-11eb-1331-4360a575ff14
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
