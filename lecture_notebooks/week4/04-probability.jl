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

# ╔═╡ f6d07dee-fdb9-11ea-004a-f1283db60877
begin
	using Pkg
	Pkg.add.(["Plots", "StatsBase", "PlutoUI", "DataStructures", "GR"])
	
	using DataStructures
	using Plots
	using StatsBase
	using PlutoUI
end

# ╔═╡ c3dc6d9c-fdb6-11ea-3b74-e1ecfa6c6f49
md"# Probability via computation"

# ╔═╡ f07d314c-fdb6-11ea-0e6e-173e625133cf
md"""
We would like to model how an epidemic spreads in a population. There are many approaches to do so. 

One approach would be to think about individual people, or **agents**. They move around in an environment and interact with other agents when they are close by. If I spend time near a person who is infectious, I might catch the infection. It's too hard to model the details of the physical process by which virus particles get transmitted from one person to another, so we will model that as saying that I have a certain **probability** (chance) $p_I$ to get infected whenever I meet somebody infectious.
"""

# ╔═╡ 8fbf80ac-fe0c-11ea-1848-9fae8515757f
md"![](https://i.imgur.com/OzlPEjn.gif)"

# ╔═╡ 89cbbbe8-fe0c-11ea-1cf8-e33f6bd7cee2
md"""
Once I'm infected, a complicated process takes place in my immune system which is also difficult to model. So we could say that each day I have a certain **probability** $p_R$ to recover.

In order to implement an **agent-based model** (or "individual-based model") like this, we first need to understand what it means for something to happen with probability $p$, and how to implement that on a computer.

We will take a practical and pragmatic approach to probability *via computation*, and leave discussions of the philosophical underpinnings of probability to other venues!
"""

# ╔═╡ e906450c-fdb6-11ea-13c3-d1348fdae587
md"## Random sampling"

# ╔═╡ cd32d0c6-fdb7-11ea-3d3f-d9981951293f
md"We have already generated random objects using the `rand` function. Let's look at that function in a bit more detail. In this notebook we won't discuss how randomness is generated on a computer; we will just assume that these methods are already available. 

[Note that computers cannot generate true randomness -- they simulate it using complicated deterministic processes. There are [ways](https://www.random.org/) to obtain true randomness from physical processes, such as atmospheric or electronic noisde.]"

# ╔═╡ ebccc984-fdb9-11ea-2f94-997184ccc66d
md"Calling `rand` on a collection like an array or a tuple returns one of the elements in that collection with equal (**uniform**) probability, i.e. each element of the collection has the same chance of being returned. 

For example, we can choose a random friend to call:
"

# ╔═╡ c55235d4-fdbc-11ea-0942-45ac804aa51d
friends = ["Alicia", "Jaime", "Elena", "Roberto"]

# ╔═╡ cf2a7ec2-fdbc-11ea-1010-190de6ff85d1
rand(friends)

# ╔═╡ 1ef8cf70-fe13-11ea-257b-cbc9abd8ab3b
rand( (1, 2) )

# ╔═╡ f317779a-fdbc-11ea-1afa-2dc25c9a16f8
md"Choosing a random element like this is called (uniform) **sampling**.

The `rand` function has many methods that sample from different types of objects."

# ╔═╡ e31461dc-fdbc-11ea-1398-89b7ba513f5c
md"## Rolling a die"

# ╔═╡ b6aec1dc-fdbc-11ea-2345-831cff1d5e7c
 md"""Let's roll an (unbiased) die. ["Die" is the singular of "dice".]"""

# ╔═╡ 2fea1cb6-fdba-11ea-2744-f5dd5fe0fcd7
begin
	num_sides = 6
	sides = 1:num_sides
end

# ╔═╡ 74430946-fe95-11ea-31d6-31bde3a357ba
sides

# ╔═╡ 75e017d0-fe95-11ea-37b1-357616582a9e
typeof(sides)

# ╔═╡ 5a5d74d4-fdba-11ea-16a3-ed2c24f47821
rand(sides)

# ╔═╡ 61f7ab10-fdba-11ea-271c-d17d8d4ebc8e
md"
We can repeat this sampling $N$ times by adding a second argument to `rand`:
"

# ╔═╡ a36f553e-fdba-11ea-2a6a-b3ba05d11acd
md"What does it mean for the sampling to be uniform? It means that we expect each element to occur with the same **frequency** (number of occurrences).

We can compute the frequencies using the `countmap` function from the `StatsBase.jl` package. But you should think about how we could write this function ourselves!"

# ╔═╡ a03b164e-fdba-11ea-0c7f-a59d54b2f813
sample = rand(sides, 10)

# ╔═╡ 10b83e00-fdbe-11ea-260d-65cf5e080534
frequencies = StatsBase.countmap(sample)

# ╔═╡ a6da8b1a-fe89-11ea-364c-958bddfa4612
bar(frequencies, alpha=0.5,
	size=(400, 300), leg=false,
	xlabel="outcome", ylabel="number of rolls", xlim=(0, num_sides+1))

# ╔═╡ 2d0be59e-fdbf-11ea-0b86-a50db0aaccaa
md"We expect the **relative frequency** or **proportion** to be near $1/6$:"

# ╔═╡ db102cb6-fdbf-11ea-0408-61334cb89f6d
begin
	max_rolls = 10000
	rolls2 = rand(1:num_sides, max_rolls)
end

# ╔═╡ b596f406-fdbf-11ea-0ed7-ab15d2da9fd2
@bind num_rolls2 Slider(1:max_rolls, show_value=true)

# ╔═╡ 46ae7d02-fdbf-11ea-1f19-4f94f9bbf851
begin
	freqs2 = SortedDict(StatsBase.countmap(rolls2[1:num_rolls2]))
	
	ks = collect(keys(freqs2))
	vs = collect(values(freqs2)) ./ num_rolls2
	
	bar(ks, vs, leg=false, alpha=0.5, xlims=(0, num_sides+1),
		size=(400,300),
		xlabel="value", ylabel="relative frequency")
	
	hline!([1 / num_sides], ls=:dash, lw=3, c=:red)
	
	 ylims!(0, 0.3)
end

# ╔═╡ f97c2aa6-fdbf-11ea-11bf-2b44cd0a90bc
md"Note that we **pre-generated** the data, to avoid generating new random samples each time."

# ╔═╡ 24674186-fdc5-11ea-2a67-3bd71199ae6e
md"## Random variables"

# ╔═╡ 2b954fca-fdc5-11ea-149f-e5f7f6d49407
md"Let's call $X$ the outcome of flipping one coin. Each time we run the experiment, $X$ will take a different value. This makes $X$ an example of a **random variable**. 

[Giving a proper mathematical description of this is rather tricky; see an advanced probability course.]

We write 

$$\mathbb{P}(X=1) = \textstyle \frac{1}{6}$$

to say that the probability that $X$ takes the value 1 is $\frac{1}{6}$.
"

# ╔═╡ 112c47a4-fe0f-11ea-04a4-adc7e339a352
md"## Uniform random numbers"

# ╔═╡ 69c2c1e4-fdc0-11ea-0e76-335b6e06057d
md"From the above we can see how to do something with probability $1/6$: 

> roll a 6-sided die, and return `true` if the outcome is 1 (for example).

Let's extend this to events which occur with a given probability $p$ with $0 \le p \le 1$: How could we sample an event with probability $p$?"

# ╔═╡ cbe5bbc6-fe0e-11ea-17c7-095c0d485bdd
md"""Calling the `rand()` function with *no* arguments returns a random `Float64` between $0$ and $1$. This approximates uniform sampling of a *real* number between $0$ and $1$."""

# ╔═╡ 6d7f1ca4-fe8a-11ea-3b20-b3df98a4201b
rand(Float64)

# ╔═╡ d5743c58-fe0e-11ea-0391-c7591b944bdd
rand()

# ╔═╡ bf084b00-fdc1-11ea-04ca-1757996125fd
md"""
Let's see what this looks like. We'll sample uniform random variates in $[0, 1]$ and plot them as a function of "time" on the $x$ axis (i.e. the number of the trial in which they appeared). We also plot the outcomes along the $y$ axis so that we can see how the interval $[0, 1]$ gets covered:
"""

# ╔═╡ 019bd65c-fdc3-11ea-01ba-51d497f875d2
max_samples = 500

# ╔═╡ 2dd45d84-fdc3-11ea-1b61-6bc6467a5013
sample2 = rand(max_samples)

# ╔═╡ 08af602e-fdc3-11ea-0e47-af1047c7bd13
@bind num_samples Slider(1:max_samples, show_value=true)

# ╔═╡ da913e08-fdc2-11ea-14c1-6bb4fdaf9353
begin
	r = sample2[1:num_samples]
	scatter(r, 1:length(r), alpha=0.5, leg=false,
			size=(400, 300))
	scatter!(r, zeros(length(r)), alpha=0.5)
	
	ylims!(-10, max_samples)
	xlims!(0, 1)
	
	xlabel!("random variate")
	ylabel!("position in sequence (time)")
end

# ╔═╡ e5994394-fe0e-11ea-1350-51442f863799
md"How uniform is the sampling? Let's plot a **histogram**. This splits the interval $[0, 1]$ up into boxes and counts the number (frequency) of data that fall into each box:"

# ╔═╡ 3620150e-fe0f-11ea-0eff-91a85ccf3864
@bind bins Slider(10:1000, show_value=true)

# ╔═╡ 479e0232-fe0f-11ea-308e-2928fe213807
@bind random_samples Slider(1:max_samples, show_value=true)

# ╔═╡ 022adcee-fde1-11ea-1ae5-8bcf6b129404
histogram(sample2[1:random_samples], bins=bins, alpha=0.5, leg=false,
		size=(400, 300), xlims=(0, 1))

# ╔═╡ 5d4102dc-fdc0-11ea-049f-7bc11f5b728d
md"## Sampling events with a given probability: Bernoulli trials"

# ╔═╡ 86731f7a-fdc3-11ea-2955-6b938f3346a5
md"""
How can we use *uniform* sampling to do *non-uniform* sampling? For example, to simulate an event that occurs with probability 0.25? This means that when we sample many points, the proportion that fall into $X$ should be approximately 0.25.

Since the sampling is uniform, we can take $X = [0, 0.25]$. The definition of "uniform" is that the probability is proportional to the length of the interval.

The recipe for sampling an event with probability $p$ is then as follows:

> 1. Generate a uniform random variate $r \in [0, 1]$, using `rand()`.
>  2. If $r < p$ then return `true`, else return `false`.
"""

# ╔═╡ ba9939f0-fe0f-11ea-0328-6780c29cc01c
md"To get a feeling for why this is a good definition, let's go back to our picture of uniform sampling and add in the cutoff at height $p$:"

# ╔═╡ ca62d4a4-fe0f-11ea-3623-73a11752dc8c
@bind num_samples2 Slider(1:max_samples, show_value=true)

# ╔═╡ 8fa5e992-fde1-11ea-0c65-3d83d42729ea
@bind pp Slider(0:0.01:1, show_value=true)

# ╔═╡ 39b9d2a0-fde1-11ea-2189-97a95849152f
begin
	r2 = sample2[1:num_samples2]
	
	scatter(r2, 1:length(r2), alpha=0.5, leg=false,
			size=(400, 300))
	scatter!(r2, zeros(length(r2)), alpha=0.5)

	ylims!(-10, max_samples)
	xlims!(0, 1)
	
	vline!([pp], ls=:dash, lw=3, c=:green)
	annotate!(170, pp+0.06, text("p", color=:green))
	
	which = findall(x -> x .< pp, r2)
	scatter!(r2[which], which, m=:square, alpha=0.5)
	scatter!(r2[which], zeros(length(r2[which])), m=:square, alpha=0.5)

end

# ╔═╡ f80a700a-fe15-11ea-2c48-9f499842e45d
md"We expect that out of $N$ trials, about $pN$ will be below $p$. So the proportion of the total number is $(pN) / N \simeq p$.
"

# ╔═╡ 1fa92ed0-fdc4-11ea-0f6c-9178b21b259c
md"The above procedure is called a [**Bernoulli trial**](https://en.wikipedia.org/wiki/Bernoulli_trial) with probability $p$.
We can think of it as flipping a coin that is **biased** to fall on heads a higher proportion of the time (e.g. by making the coin out of two different metals, one of which is more dense than the other).

Julia allows us to code this in the following very compact way:"

# ╔═╡ 4bf82e84-fdc4-11ea-2abf-19174c74f726
bernoulli(p) = rand() < p

# ╔═╡ bc549f38-fe15-11ea-10dd-db165347709d
3 < 4

# ╔═╡ 9ab21d04-fe97-11ea-0f88-11a86a4974c6
function bernoulli2(p)
	if rand() < p
		return true
	else
		return false
	end
end


# ╔═╡ 4f9ebeea-fdc4-11ea-052d-3b9e7dfbc02b
bernoulli(0.25)

# ╔═╡ 5640f132-fdc4-11ea-372e-799a17716334
md"We are using the short-form version of a function definition, together with the fact that a comparison like `x < y` returns a Boolean value."

# ╔═╡ db63e988-fde1-11ea-152e-8b194c107e78
md"Note that the value returned, $B$, is a random variable! It has

$$\mathbb{P}(B = 1) = p$$
$$\mathbb{P}(B = 0) = 1 - p$$
"

# ╔═╡ 11e7a0b2-fde2-11ea-0c37-6be01573167b
md"This collection of the probabilities of all the possible outcomes is the **probability distribution** of the Bernoulli random variable."

# ╔═╡ c9b287a2-fdc4-11ea-04c6-6b0d1a6c5321
md"## Flipping many biased coins"

# ╔═╡ ca7b9150-fdc5-11ea-2281-b3b026825ea5
md"
Let's suppose we flip $n$ coins, each with the same probability $p$. We will suppose that the coins are **independent**, i.e. that flipping one of them has no influence on the outcome of the others. (This would not be the case if the coins were metallic and attracted each other, for example.)

There are many quantities of interest, or **observables**, that we might want to measure. One obvious one is the number of coins that come out as heads:
"

# ╔═╡ 60949cce-fde2-11ea-1946-31d1b1bce37a
[bernoulli(0.3) for i = 1:10]  # array comprehension

# ╔═╡ 727b0e56-fdd7-11ea-28d1-5b859a5f8a29
flips(n, p) = count( bernoulli(p) for i = 1:n )

# ╔═╡ dabc00d6-fe97-11ea-0180-cd138faaab5d
( bernoulli(0.3) for i = 1:10 )

# ╔═╡ d450742c-fdd7-11ea-2477-b37441b6ddfa
flips(20, 0.3)

# ╔═╡ dca0b5a6-fdd7-11ea-15e4-0320a1ceebff
md"The function `count` counts the number of `true`s in its argument. The argument itself looks like an array comprehension, but with no square brackets; this is called a **generator expression**. Since `count` does not need to **materialize** the array, i.e. create it in memory, it can be faster."

# ╔═╡ 2c2479a0-fdd8-11ea-19a2-db21219dd7c3
md"""The outcome of flipping the coin is another random variable, $H_{n}$. Clearly its possible values are the integers between $0$ and $n$. But intuitively we expect that it's very *unlikely* to have either exactly $0$ or exactly $n$ heads. This is another example of a *non-uniform* random variable.

What again need to calculate the **probability distribution** of the random variable $H_{n,p}$, i.e. the probability that it takes on each of its possible values.

We can calculate this numerically by thinking of "flipping $n$ coins" as a single experiment, and running that experiment many times:
"""

# ╔═╡ aa63b25e-fdd8-11ea-2b30-ed13d2072488
run_experiment(n, p, num_times) = [flips(n, p) for i in 1:num_times]

# ╔═╡ 48acfd94-fde3-11ea-3ae8-0d8ba164a68c
num_experiments = 1000

# ╔═╡ 521c85c0-fde3-11ea-1040-09a6e13a4328
num_coins = 100

# ╔═╡ c55013e6-fdd8-11ea-3784-cd27c2e3d0d8
run_experiment(num_coins, 0.3, num_experiments)

# ╔═╡ caf791ca-fdd8-11ea-2234-bdc14d214cac
md"As expected, we get back a dataset containing integers between 0 and 20, but actually 1 and 20 occur few times. 

How can we calculate the probability distribution? We can use `countmap` again to obtain the frequencies:"

# ╔═╡ 15231f76-fdd9-11ea-361e-0f85e1c3ace2
begin 
	max_times = 10^6
	data = run_experiment(num_coins, 0.3, max_times)
end

# ╔═╡ 29edd4e6-fdd9-11ea-016b-9142be69bf68
@bind num_times Slider(1:max_times, show_value=true)

# ╔═╡ 3398d3a6-fdd9-11ea-0845-f54dab63b2dc
begin
	freqs3 = SortedDict(countmap(data[1:num_times]))
	bar(collect(keys(freqs3)), collect(values(freqs3)) ./ num_times,
		alpha=0.5,
		size=(400, 300), leg=false)
	
	xlims!(0, num_coins)
	ylims!(0, 0.2)
	
	xlabel!("number of heads")
	ylabel!("proportion")
end

# ╔═╡ adf1c626-fdd9-11ea-3535-2d2219feda56
md"As we take more samples, the **empirical distribution** (calculated from the data) converges to the true underlying **population distribution** (the theoretical distribution for this random variable)."

# ╔═╡ 92efff82-fde3-11ea-010d-a188a852b79b
md"If we take a large number of coins then we see the well-known bell-shaped distribution, called a  **Gaussian distribution** or **normal distribution**.

If we call the $i$th coin flip result $B_i$, which takes the value 0 or 1, then we have

$$H_{n} = \sum_{i=1}^n B_i.$$

We are summing up independent random variables which take the value 0 or 1 (the number of heads in each coin flip), and the Central Limit Theorem says that the sum of independent random variables usually converges to a normal distribution.

Note that we have not said what we mean by **converges** here. Making that precise turns out to be quite difficult. Intuitively it means that the function describing the probability distribution converges at each point to a limiting curve, but unfortunately this intuition is not always correct. 
"

# ╔═╡ Cell order:
# ╠═f6d07dee-fdb9-11ea-004a-f1283db60877
# ╟─c3dc6d9c-fdb6-11ea-3b74-e1ecfa6c6f49
# ╟─f07d314c-fdb6-11ea-0e6e-173e625133cf
# ╟─8fbf80ac-fe0c-11ea-1848-9fae8515757f
# ╟─89cbbbe8-fe0c-11ea-1cf8-e33f6bd7cee2
# ╟─e906450c-fdb6-11ea-13c3-d1348fdae587
# ╟─cd32d0c6-fdb7-11ea-3d3f-d9981951293f
# ╟─ebccc984-fdb9-11ea-2f94-997184ccc66d
# ╠═c55235d4-fdbc-11ea-0942-45ac804aa51d
# ╠═cf2a7ec2-fdbc-11ea-1010-190de6ff85d1
# ╠═1ef8cf70-fe13-11ea-257b-cbc9abd8ab3b
# ╟─f317779a-fdbc-11ea-1afa-2dc25c9a16f8
# ╟─e31461dc-fdbc-11ea-1398-89b7ba513f5c
# ╟─b6aec1dc-fdbc-11ea-2345-831cff1d5e7c
# ╠═2fea1cb6-fdba-11ea-2744-f5dd5fe0fcd7
# ╠═74430946-fe95-11ea-31d6-31bde3a357ba
# ╠═75e017d0-fe95-11ea-37b1-357616582a9e
# ╠═5a5d74d4-fdba-11ea-16a3-ed2c24f47821
# ╟─61f7ab10-fdba-11ea-271c-d17d8d4ebc8e
# ╟─a36f553e-fdba-11ea-2a6a-b3ba05d11acd
# ╠═a03b164e-fdba-11ea-0c7f-a59d54b2f813
# ╠═10b83e00-fdbe-11ea-260d-65cf5e080534
# ╟─a6da8b1a-fe89-11ea-364c-958bddfa4612
# ╟─2d0be59e-fdbf-11ea-0b86-a50db0aaccaa
# ╠═db102cb6-fdbf-11ea-0408-61334cb89f6d
# ╠═b596f406-fdbf-11ea-0ed7-ab15d2da9fd2
# ╟─46ae7d02-fdbf-11ea-1f19-4f94f9bbf851
# ╟─f97c2aa6-fdbf-11ea-11bf-2b44cd0a90bc
# ╟─24674186-fdc5-11ea-2a67-3bd71199ae6e
# ╟─2b954fca-fdc5-11ea-149f-e5f7f6d49407
# ╟─112c47a4-fe0f-11ea-04a4-adc7e339a352
# ╟─69c2c1e4-fdc0-11ea-0e76-335b6e06057d
# ╟─cbe5bbc6-fe0e-11ea-17c7-095c0d485bdd
# ╠═6d7f1ca4-fe8a-11ea-3b20-b3df98a4201b
# ╠═d5743c58-fe0e-11ea-0391-c7591b944bdd
# ╟─bf084b00-fdc1-11ea-04ca-1757996125fd
# ╠═019bd65c-fdc3-11ea-01ba-51d497f875d2
# ╠═2dd45d84-fdc3-11ea-1b61-6bc6467a5013
# ╟─08af602e-fdc3-11ea-0e47-af1047c7bd13
# ╟─da913e08-fdc2-11ea-14c1-6bb4fdaf9353
# ╟─e5994394-fe0e-11ea-1350-51442f863799
# ╠═3620150e-fe0f-11ea-0eff-91a85ccf3864
# ╠═479e0232-fe0f-11ea-308e-2928fe213807
# ╠═022adcee-fde1-11ea-1ae5-8bcf6b129404
# ╟─5d4102dc-fdc0-11ea-049f-7bc11f5b728d
# ╟─86731f7a-fdc3-11ea-2955-6b938f3346a5
# ╟─ba9939f0-fe0f-11ea-0328-6780c29cc01c
# ╠═ca62d4a4-fe0f-11ea-3623-73a11752dc8c
# ╠═8fa5e992-fde1-11ea-0c65-3d83d42729ea
# ╟─39b9d2a0-fde1-11ea-2189-97a95849152f
# ╟─f80a700a-fe15-11ea-2c48-9f499842e45d
# ╟─1fa92ed0-fdc4-11ea-0f6c-9178b21b259c
# ╠═4bf82e84-fdc4-11ea-2abf-19174c74f726
# ╠═bc549f38-fe15-11ea-10dd-db165347709d
# ╠═9ab21d04-fe97-11ea-0f88-11a86a4974c6
# ╠═4f9ebeea-fdc4-11ea-052d-3b9e7dfbc02b
# ╟─5640f132-fdc4-11ea-372e-799a17716334
# ╟─db63e988-fde1-11ea-152e-8b194c107e78
# ╟─11e7a0b2-fde2-11ea-0c37-6be01573167b
# ╟─c9b287a2-fdc4-11ea-04c6-6b0d1a6c5321
# ╟─ca7b9150-fdc5-11ea-2281-b3b026825ea5
# ╠═60949cce-fde2-11ea-1946-31d1b1bce37a
# ╠═727b0e56-fdd7-11ea-28d1-5b859a5f8a29
# ╠═dabc00d6-fe97-11ea-0180-cd138faaab5d
# ╠═d450742c-fdd7-11ea-2477-b37441b6ddfa
# ╟─dca0b5a6-fdd7-11ea-15e4-0320a1ceebff
# ╟─2c2479a0-fdd8-11ea-19a2-db21219dd7c3
# ╠═aa63b25e-fdd8-11ea-2b30-ed13d2072488
# ╠═48acfd94-fde3-11ea-3ae8-0d8ba164a68c
# ╠═521c85c0-fde3-11ea-1040-09a6e13a4328
# ╠═c55013e6-fdd8-11ea-3784-cd27c2e3d0d8
# ╟─caf791ca-fdd8-11ea-2234-bdc14d214cac
# ╠═15231f76-fdd9-11ea-361e-0f85e1c3ace2
# ╠═29edd4e6-fdd9-11ea-016b-9142be69bf68
# ╟─3398d3a6-fdd9-11ea-0845-f54dab63b2dc
# ╟─adf1c626-fdd9-11ea-3535-2d2219feda56
# ╟─92efff82-fde3-11ea-010d-a188a852b79b
