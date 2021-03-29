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

# ╔═╡ 74a414ca-8fd1-11eb-140f-49dc439cc031
using Statistics

# ╔═╡ a6278652-8fd4-11eb-1d81-c38628cd51eb
using Plots

# ╔═╡ d59b2df6-8fd4-11eb-0034-45d9ec1c253d
using PlutoUI

# ╔═╡ 53c91a12-8fda-11eb-18b1-0d1fdf4f718f
using Symbolics

# ╔═╡ 5d62e16c-8fd9-11eb-1c44-0b0232614011
TableOfContents(aside=true)

# ╔═╡ 6bbfa37e-8ffe-11eb-3031-19ea76a6a8d2
md"""
# Concepts for today

We won't be introducing any new Julia functions, but we are going to show off a key way in which Julia really shines: its type system.

With a few carefully-chosen definitions, we can gain a great deal of power!

Concepts for today:

- Types for code organisation of abstract concepts
- Abstract types
- Subtypes
- Building up expressions "under the hood" using types


- `sum` over an iterator / generator expression
"""

# ╔═╡ 8a125ca0-8ff5-11eb-0607-45f993fb5ca7
md"""
# Random variables as types
"""

# ╔═╡ b2971770-8ff7-11eb-002c-f9dc9d6d0d70
md"""
This lecture might appear to be about random variables (and it is). But we would be thrilled if you see this rather as a lecture on software engineering and abstractions, since the principles involved extend to *many* different contexts.
	

"""

# ╔═╡ 52b1df82-8fd1-11eb-27e9-99264c2c89b8
begin
	abstract type RandomVariable end
	
	abstract type DiscreteRandomVariable <: RandomVariable end
	abstract type ContinuousRandomVariable <: RandomVariable end
end

# ╔═╡ ae1b3a26-8fd3-11eb-3746-ad48301ff96e
md"""
Recall that a random variable $X$ is an object which has different possible outcomes $x$, to which we assign probabilities $\mathbb{P}(X = x)$.

The correspondence of probabilities to outcomes is called the **probability distribution** of the random variable.
"""

# ╔═╡ ae0008ee-8fd3-11eb-38bd-f52598a97dce
md"""
## Gaussian distributions
"""

# ╔═╡ c6c3cf54-8fd4-11eb-3b4f-415f1a2da18e
md"""
Let's remind ourselves of Gaussian distributions with mean $\mu$ and standard deviation $\sigma$ (or variance $\sigma^2$).

We can sample from a Gaussian distribution with mean $0$ and variance $1$ with the `randn` function (short for "random normal").
"""

# ╔═╡ d8b74772-8fd4-11eb-3943-f98c29d02171
md"""
μ = $(@bind μ Slider(-3:0.01:3, show_value=true, default=0.0))
σ = $(@bind σ Slider(0.01:0.01:3, show_value=true, default=1.0))
"""

# ╔═╡ b11d964e-8fd4-11eb-3f6a-43e8d2fa462c
data = μ .+ σ .* randn(10^5)

# ╔═╡ ad7b3bee-8fd5-11eb-06f6-b39738d4b1fd
bell_curve(x) = exp(-x^2 / 2) / √(2π)

# ╔═╡ c76cd760-8fd5-11eb-3500-5d15515c33f5
bell_curve(x, μ, σ) = bell_curve( (x - μ) / σ ) / σ

# ╔═╡ b8c253f8-8fd4-11eb-304a-b1be962687e4
begin
	histogram(data, alpha=0.2, norm=true, bins=100, leg=false, title="μ=$(μ), σ=$(σ)", size=(500, 300))
	xlims!(-6, 6)
	ylims!(0, 0.7)
	
	
	xs = [μ - σ, μ, μ + σ]
	
	plot!(-6:0.01:6, x -> bell_curve(x, μ, σ), lw=2)
	
	plot!((μ - σ):0.01:(μ + σ), x -> bell_curve(x, μ, σ), fill=true, alpha=0.5, c=:purple)
	
	plot!([μ, μ], [0.05, bell_curve(μ, μ, σ)], ls=:dash, lw=2, c=:white)
	annotate!(μ, 0.03, text("μ", :white))
#	annotate!(μ + σ, 0.03, text("μ+σ", :yellow))
#	annotate!(μ, 0.03, text("μ", :white))

	
end

# ╔═╡ f31275fa-8fd5-11eb-0b76-7d0513705273
bell_curve(0, 3, 2)

# ╔═╡ 276a7c36-8fd8-11eb-25d8-3d4cfaa1f71c
md"""
### Sum of two Gaussians
"""

# ╔═╡ 2be60570-8fd8-11eb-0bdf-951280dc6181
begin
	data1 = 4 .+ sqrt(0.3) .* randn(10^5)
	data2 = 6 .+ sqrt(0.7) .* randn(10^5)
	
	total = data1 + data2
end

# ╔═╡ 5e094b52-8fd8-11eb-2ac4-5797599ab013
histogram(total, alpha=0.5, leg=false, norm=true, size=(500, 300))

# ╔═╡ 79fb368c-8fd9-11eb-1c9c-bd0ceb122b11
md"""
The sum of two Gaussians with means $\mu_1$ etc. is ...

"""

# ╔═╡ a2481afa-8fd3-11eb-1769-bf97f42ea79e
md"""
## Theoretical random variables vs. sampling

What should a theoretical random variable be able to do? What should we be able to do with sampling?


- **Naming**, e.g. `Gaussian`
- **Parameters**, e.g. $\mu$ and $\sigma^2$



### Theoretical 

- Theoretical mean
- Theoretical variance




- Theoretical sum of  two random variables
- Theoretical product of two random variables


- Probability distribution


### Sampling

- **Sample** a  random variable
- Sample mean
- Sample variance

- Sample sum


- Histogram


"""

# ╔═╡ a9654334-8fd9-11eb-2ea8-8d308ea66963
md"""

# Why define a type at all?
"""

# ╔═╡ bb2132e0-8fd9-11eb-3bdd-594726c04859
md"""
How can we represent a random variable in software?

In some languages, like R and MATLAB, there are different names for the various functions associated to a random variable, but no name for the random variable itself!:

[Normal distribution in R](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/Normal)

[Chi-squared distribution in R](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/Chisquare)

There is a standard naming convention in R, with `d` for density, etc., followed by the name like `norm` for normal. The indicators are:

- `d` for density
- `p` for the distribution function
- `q` for the quantile function
- `r` for generating random variates


What's wrong with this? All these functions are referring to an underlying random variable (or probability distribution), which you will find in any course in probability, and yet there's no way to refer to the underlying mathematical object!
"""

# ╔═╡ f307e3b8-8ff0-11eb-137e-4f9a03bb4d78
md"""
Instead, we would like to be able to refer to the random variable (or probability distribution) itself. We should be able to provide a type with the name and parameters of a random variable, but not yet specify how to generate random instances (variates)? It turns out that this is a very good example of thinking ahead by providing an **abstraction**.

We can *later* provide a means for random sampling -- and even, if a new algorithm comes along that is more efficient, we can replace it some day!
"""

# ╔═╡ 681429d8-8fff-11eb-0fa1-bbf9e05e6cea
md"""
## Defining a Gaussian type
"""

# ╔═╡ dd130aae-8ff2-11eb-2b15-2f5123b40d20
md"""
### Name and parameters
"""

# ╔═╡ 21236a86-8fda-11eb-1fcf-59d1de75470c
md"""
Let's start off by looking at Gaussians:
"""

# ╔═╡ 4771e8e6-8fd2-11eb-178c-419cbdb348f4
begin
	struct Gaussian <: ContinuousRandomVariable
		μ     # mean
		σ²    # variance
	end
	
	Gaussian() = Gaussian(0.0, 1.0)  # normalised Gaussian with mean 0 and variance 1
end

# ╔═╡ ece14f6c-8fda-11eb-279b-c18dc0fc46d7
G = Gaussian(1, 2)

# ╔═╡ 0be6c548-8fd3-11eb-07a2-5bb382614cab
md"""
Note that here we have named a random variable, *without* sampling from it.
"""

# ╔═╡ 9c03814c-8ff2-11eb-189d-f3b0507507cb
md"""
### Theoretical mean and variance
"""

# ╔═╡ f24bcb1a-8fda-11eb-1828-0307c65b81cd
md"""
Now we can extend the `mean`, `var` (variance) and `std` (standard deviation) functions from the `Statistics` library to act on this object:
"""

# ╔═╡ 0c76f49e-8fdb-11eb-2c2c-59a4060e8e1d
begin
	Statistics.mean(X::Gaussian) = X.μ
	Statistics.var(X::Gaussian) = X.σ²
end

# ╔═╡ 4596edec-8fdb-11eb-1369-f3e98cb831cd
mean(G)

# ╔═╡ 255d51b6-8ff3-11eb-076c-31ba4c5ce10d
var(G)

# ╔═╡ 43292298-8ff7-11eb-2b9d-017acc9ef185
md"""
### Planning ahead: Standard deviation for *any* random variable, not just Gaussians
"""

# ╔═╡ 1bdc6068-8ff7-11eb-069c-6d0f1a83f373
md"""
Once we have defined the variance, we know how to calculate the standard deviation: it's just the square root of the variance. But, thinking ahead, this is true for *any* random variable, so we can define it to act on any random variable that we will define later!:
"""

# ╔═╡ 11ef1d18-8ff7-11eb-1645-113c1aae6e9b
Statistics.std(X::RandomVariable) = sqrt(var(X))

# ╔═╡ a32079ea-8fd8-11eb-01c4-81b603033b55
Statistics.std(total)

# ╔═╡ 592afd96-8ff7-11eb-1200-47eaf6b6a28a
md"""
This is an example of good software design.
"""

# ╔═╡ 4ef2153a-8fdb-11eb-1a23-8b1c28381e34
std(G)

# ╔═╡ 76f4424e-8fdc-11eb-35ee-dd09752b947b
md"""
### Sum of two Gaussian random variables
"""

# ╔═╡ dede8022-8fd2-11eb-22f8-a5614d703c01
md"""
Gaussians have a special property: the sum of two Gaussians is always a Gaussian. (We say that Gaussians are **stable** distributions. There are others.) Note that we don't need random samples for this theoretical observation, embodied in the following code.
"""

# ╔═╡ b4f18188-8fd2-11eb-1950-ef3bee3e4724
Base.:+(X::Gaussian, Y::Gaussian) = Gaussian(X.μ + Y.μ, X.σ² + Y.σ²)

# ╔═╡ 292f0e44-8fd3-11eb-07cf-5733a5327630
begin
	G1 = Gaussian(0, 1)
	G2 = Gaussian(5, 6)
end

# ╔═╡ 6b50e9e6-8fd3-11eb-0ab3-6fc3efea7e37
G1 + G2

# ╔═╡ 5300b082-8fdb-11eb-03fe-55f511364ad9
mean(G1 + G2) == mean(G1) + mean(G2)

# ╔═╡ ac3a7c18-8ff3-11eb-1c1f-17939cff40f9
md"""
The theoretical product of two Gaussians is not Gaussian; we will do the general case later.
"""

# ╔═╡ b8e59db2-8ff3-11eb-1fa1-595fdc6652bc
md"""
### Probability distribution of a Gaussian
"""

# ╔═╡ cb167a60-8ff3-11eb-3885-d1d8a70e2a5e
md"""
A Gaussian random variable is a **continuous** random variable, i.e. it has a continuous range of possible outcomes. The possible range of outcomes is called the **support** of the distribution. For a Gaussian it is the whole real line, $(-\infty, \infty)$.
"""

# ╔═╡ fc0acee6-8ff3-11eb-13d1-1350364f03a9
md"""
One way to specify a continous random variable $X$ is via its **probability density function**, or **PDF**, $f_X$. The probability that $X$ lies in the interval $[a, b]$ is given by an area under the curve $f_X(x)$ from $a$ to $b$:

$$\mathbb{P}(X \in [a, b]) = \int_{a}^b f_X(x) \, dx.$$
"""

# ╔═╡ 2c8b75de-8ff4-11eb-1bc6-cde7b67a2007
md"""
For a Gaussian distribution with mean $\mu$ and variance $\sigma^2$, the PDF is given by

$$f_X(X) = \frac{1}{\sqrt{2\pi \sigma^2}} \exp \left[ -\frac{1}{2} \left( \frac{x - \mu}{\sigma} \right)^2 \right]$$.
"""

# ╔═╡ 639e517c-8ff4-11eb-3ea8-07b73b0bff78
pdf(X::Gaussian) = x -> exp(-0.5 * ( (x - X.μ)^2 / X.σ²) ) / √(2π * X.σ²)

# ╔═╡ 3d78116c-8ff5-11eb-0ee3-71bf9413f30e
pdf(G)

# ╔═╡ b63c02e4-8ff4-11eb-11f6-d760e8760118
pdf(Gaussian())(0.0)

# ╔═╡ cd9b10f0-8ff5-11eb-1671-99c6738b8074
md"""
μ = $(@bind μμ Slider(-3:0.01:3, show_value=true, default=0.0))
σ = $(@bind σσ Slider(0.01:0.01:3, show_value=true, default=1.0))
"""

# ╔═╡ a899fc08-8ff5-11eb-1d00-e95b55c3be4b
begin
	plot(pdf(Gaussian(μμ, σσ)), leg=false)
	xlims!(-6, 6)
	ylims!(0, 0.5)
end

# ╔═╡ 0b901c34-8ff6-11eb-225b-511718412309
md"""
### Sampling from a Gaussian distribution
"""

# ╔═╡ 180a4746-8ff6-11eb-046f-ddf6bb938a35
Base.rand(X::Gaussian) = X.μ + √(X.σ²) * randn()

# ╔═╡ 27595716-8ff6-11eb-1d99-7bf13eedddf7
histogram!([rand(Gaussian(μμ, σσ)) for i in 1:10^4], alpha=0.5, norm=true)

# ╔═╡ bfb62f1a-8ff5-11eb-0f7a-cf725f3269c5
md"""
# More general distributions
"""

# ╔═╡ 0a150880-8ff6-11eb-0046-45fa2d4b476e
md"""
Let's recall the Bernoulli distribution from last lecture. This represents a weighted coin with probability $p$ to come up "heads" (1), and probability $1-p$ to come up "tails" (0).

Note that this is a **discrete** random variable: the possible outcomes are the discrete values $0$ and $1$.
"""

# ╔═╡ 26569eb4-8fd1-11eb-2df9-098a0792a09e
struct Bernoulli <: DiscreteRandomVariable
	p::Float64
end

# ╔═╡ baf1fe40-8ff6-11eb-1da1-cd43880db334
B = Bernoulli(0.25)

# ╔═╡ be5f9900-8ff6-11eb-1816-03447cabd9a9
begin
	Statistics.mean(X::Bernoulli) = X.p
	Statistics.var(X::Bernoulli) = X.p * (1 - X.p)
end

# ╔═╡ 52a2cac8-8ff8-11eb-2da4-0b113618c64b
mean(B), var(B), std(B)

# ╔═╡ 754b0a80-8ff8-11eb-364b-85fa49d6bb8e
Base.rand(X::Bernoulli) = Int(rand() < X.p)

# ╔═╡ bd484878-8ff8-11eb-0337-7730ab2b07d4
md"""
## Adding two random variables
"""

# ╔═╡ c3043eb6-8ff8-11eb-2cae-13d1c1613234
md"""
What happens if we add two Bernoulli random variables? There are two routes we could go: We could use the known theoretical sum, or we could write a general-purpose tool.
"""

# ╔═╡ eb555508-8ff8-11eb-1b70-e95290084742
struct SumOfTwoRandomVariables <: RandomVariable
	X1::RandomVariable
	X2::RandomVariable
end

# ╔═╡ 1e5047c4-8ff9-11eb-2628-c7824725678a
begin
	B1 = Bernoulli(0.25)
	B2 = Bernoulli(0.6)
end

# ╔═╡ 44a5ef96-8ff9-11eb-06a0-d3a8dcf5c1aa
Base.:+(X1::RandomVariable, X2::RandomVariable) = SumOfTwoRandomVariables(X1, X2)

# ╔═╡ 574744ec-8ff9-11eb-033c-a3dff07a292b
B1 + B2

# ╔═╡ 6003162e-8ff9-11eb-020e-21594868899f
md"""
Why couldn't we have just defined `+` directly, without the new `SumOfTwoRandomVariables` type? If you try to do it, you'll quickly realise that you we have no way of representing the result, since it is a different random variable that we haven't seen before!
"""

# ╔═╡ 318f5274-8ff9-11eb-1c88-5fde5b546099
md"""
Now we need to define the various functions on this type representing a sum
"""

# ╔═╡ 90ee7558-8ff9-11eb-3602-271890987ece
Statistics.mean(S::SumOfTwoRandomVariables) = mean(S.X1) + mean(S.X2)

# ╔═╡ bd083794-8fd8-11eb-0155-e59fe27d64f2
Statistics.mean(total)

# ╔═╡ a168ace6-8ff9-11eb-393d-45c34fdf577c
mean(B1 + B2)

# ╔═╡ a51b1538-8ff9-11eb-0635-81088e826bb3
md"""
To have a simple equation for the variance, we need to assume that the two random variables are **independent**. Perhaps the name should have been `SumOfTwoIndependentRandomVariables`, but it seems to be too long.
"""

# ╔═╡ d88c0830-8ff9-11eb-3e71-c1ac327f4e25
Statistics.var(S::SumOfTwoRandomVariables) = var(S.X1) + var(S.X2)

# ╔═╡ dd995120-8ff9-11eb-1a53-2d65f0b5585a
md"""
How can we sample from the sum? It's actually easy!
"""

# ╔═╡ f171c27c-8ff9-11eb-326c-6b2d8c38451d
Base.rand(S::SumOfTwoRandomVariables) = rand(S.X1) + rand(S.X2)

# ╔═╡ ab7c6b18-8ffa-11eb-2b6c-dde3dca1c6f7
md"""
Now it's easy to look at the sum of a Bernoulli and a Gaussian. This is an example of a [**mixture distribution**](https://en.wikipedia.org/wiki/Mixture_distribution).
"""

# ╔═╡ 79c55fc0-8ffb-11eb-229f-49198aee8245
md"""
Let's extend the `histogram` function to easily draw the histogram of a random variable:
"""

# ╔═╡ 4493ac9e-8ffb-11eb-15c9-a146091d7696
Plots.histogram(X::RandomVariable; kw...) = histogram([rand(X) for i in 1:10^6], norm=true, leg=false, alpha=0.5, size=(500, 300), kw...)

# ╔═╡ a591ac12-8ffb-11eb-1734-09657f875b1e
histogram(Bernoulli(0.25) + Bernoulli(0.75))

# ╔═╡ 6c5ef6d4-8ffb-11eb-2fe9-9dd87d92abe4
histogram(Bernoulli(0.25) + Gaussian(0, 0.1))

# ╔═╡ 1d4e236c-8ffb-11eb-209d-851e1af231d4
md"""
Now... What if we sum more random variables?
"""

# ╔═╡ 0c3cfb16-8ffb-11eb-3ef9-33ea9acbb8c0
B1 + B2 + G

# ╔═╡ 325560f4-8ffb-11eb-0e9b-53f6869bdd97
rand(B1 + B2 + G)

# ╔═╡ 89138e02-8ffb-11eb-2ad2-c32e663f57b0
histogram(Bernoulli(0.25) + Bernoulli(0.75) + Gaussian(0, 0.1))

# ╔═╡ 34bcab72-8ffb-11eb-1d0c-29bd83de638b
S = sum(Bernoulli(0.25) for i in 1:30)

# ╔═╡ bf9a4722-8ffb-11eb-1652-f1bfb4916d2a
histogram(S)

# ╔═╡ 611f770c-8ffc-11eb-2c23-0d5750afd7c8
mean(S)

# ╔═╡ 636b2ce0-8ffc-11eb-2411-571f78fb8a84
var(S)

# ╔═╡ c7613c44-8ffc-11eb-0a43-dbc8b1f62be9
rand(S)

# ╔═╡ 656999be-8ffc-11eb-0f51-51d5a162a004
md"""
This is a big deal! Everything just works.

By the way, the sum of $n$ Bernoulli random variables with the *same* probability $p$ is called a **binomial** random variable with parameters $(n, p)$.
"""

# ╔═╡ 8cb5373a-8ffc-11eb-175d-b11ec5fae1ab
md"""
If we were worried about performance, we would probably want to define a separate `Binomial` type, rather than using nested sums of Bernoullis:
"""

# ╔═╡ 3dd5581e-8fd1-11eb-282b-cb30f2dcb069
struct Binomial <: DiscreteRandomVariable
	n::Int64
	p::Float64
end

# ╔═╡ 10e3a754-8fd2-11eb-0c66-870b9568a05b
begin
	X = Bernoulli(0.25)
	Y = Binomial(10, 0.25)
end

# ╔═╡ 2e7adf46-8fd2-11eb-3d0f-eb01695084d8
md"""
But note that if we add two Bernoullis, we do *not* get back a Bernoulli, since the outcome 2 is also possible
"""

# ╔═╡ 19dbd48a-8fd2-11eb-132d-c7e67043513c
Base.:+(X::Bernoulli, Y::Binomial) = 

# ╔═╡ 8edb7874-8fd1-11eb-3e97-33e067f79500
begin
	struct SumOfRandomVariables <: RandomVariable
		variables::Vector{RandomVariable}
	end
	
	SumOfRandomVariables(variables::RandomVariable...) = SumOfRandomVariables([variables...])
end

# ╔═╡ e483d9c4-8fd1-11eb-311c-b37da0f373d5
SumOfRandomVariables(Bernoulli(0.25), Binomial(10, 0.25))

# ╔═╡ 25b4ccca-8ffd-11eb-3fe0-2d14ce90d8b3
md"""
## χ₁² distribution
"""

# ╔═╡ 9913427a-8ffd-11eb-3c28-c12ee05ed9d3
md"""
The chi-1 squared ($\chi_1^2$) distribution 
"""

# ╔═╡ aa9d94dc-8ffd-11eb-0537-c39344c224c2
struct ChiSquared1 <: ContinuousRandomVariable
end

# ╔═╡ b5300720-8ffd-11eb-2ca4-ed7a7c9b5516
Base.rand(X::ChiSquared1) = rand(Gaussian())^2

# ╔═╡ eea0c788-8ffd-11eb-06e0-cfb65dbba7f1
histogram(ChiSquared1(); xlims=(0, 10))

# ╔═╡ 028695a2-8ffe-11eb-3cf4-bd07bfe4df3a
histogram(sum(ChiSquared1() for i in 1:4))

# ╔═╡ 820af6dc-8fdc-11eb-1792-ad9f32eb915e
md"""
## Using symbolics
"""

# ╔═╡ ce330b78-8fda-11eb-144d-756275542eea
md"""
We can even do this symbolically!:
"""

# ╔═╡ 668ade6a-8fda-11eb-0a5e-cb791b245ec0
@variables μ₁, σ₁², μ₂, σ₂²   # introduce symbolic variables from Symbolics.jl

# ╔═╡ 4e94d1da-8fda-11eb-3572-398fb4a12c3c
Gaussian(μ₁, σ₁²) + Gaussian(μ₂, σ₂²)

# ╔═╡ 9ca993a6-8fda-11eb-089c-4d7f89c81b94
Gaussian(17, 3) + Gaussian(μ₂, σ₂²)

# ╔═╡ 28dd02f0-8fd3-11eb-397c-45f92b90a40c
Base.rand(X::Gaussian)

# ╔═╡ Cell order:
# ╠═5d62e16c-8fd9-11eb-1c44-0b0232614011
# ╠═74a414ca-8fd1-11eb-140f-49dc439cc031
# ╠═a6278652-8fd4-11eb-1d81-c38628cd51eb
# ╠═d59b2df6-8fd4-11eb-0034-45d9ec1c253d
# ╠═53c91a12-8fda-11eb-18b1-0d1fdf4f718f
# ╠═6bbfa37e-8ffe-11eb-3031-19ea76a6a8d2
# ╟─8a125ca0-8ff5-11eb-0607-45f993fb5ca7
# ╟─b2971770-8ff7-11eb-002c-f9dc9d6d0d70
# ╠═52b1df82-8fd1-11eb-27e9-99264c2c89b8
# ╟─ae1b3a26-8fd3-11eb-3746-ad48301ff96e
# ╟─ae0008ee-8fd3-11eb-38bd-f52598a97dce
# ╠═b11d964e-8fd4-11eb-3f6a-43e8d2fa462c
# ╟─c6c3cf54-8fd4-11eb-3b4f-415f1a2da18e
# ╟─d8b74772-8fd4-11eb-3943-f98c29d02171
# ╟─b8c253f8-8fd4-11eb-304a-b1be962687e4
# ╠═ad7b3bee-8fd5-11eb-06f6-b39738d4b1fd
# ╠═c76cd760-8fd5-11eb-3500-5d15515c33f5
# ╠═f31275fa-8fd5-11eb-0b76-7d0513705273
# ╟─276a7c36-8fd8-11eb-25d8-3d4cfaa1f71c
# ╠═2be60570-8fd8-11eb-0bdf-951280dc6181
# ╠═5e094b52-8fd8-11eb-2ac4-5797599ab013
# ╠═bd083794-8fd8-11eb-0155-e59fe27d64f2
# ╠═a32079ea-8fd8-11eb-01c4-81b603033b55
# ╠═79fb368c-8fd9-11eb-1c9c-bd0ceb122b11
# ╟─a2481afa-8fd3-11eb-1769-bf97f42ea79e
# ╟─a9654334-8fd9-11eb-2ea8-8d308ea66963
# ╟─bb2132e0-8fd9-11eb-3bdd-594726c04859
# ╟─f307e3b8-8ff0-11eb-137e-4f9a03bb4d78
# ╟─681429d8-8fff-11eb-0fa1-bbf9e05e6cea
# ╟─dd130aae-8ff2-11eb-2b15-2f5123b40d20
# ╟─21236a86-8fda-11eb-1fcf-59d1de75470c
# ╠═4771e8e6-8fd2-11eb-178c-419cbdb348f4
# ╟─ece14f6c-8fda-11eb-279b-c18dc0fc46d7
# ╟─0be6c548-8fd3-11eb-07a2-5bb382614cab
# ╟─9c03814c-8ff2-11eb-189d-f3b0507507cb
# ╟─f24bcb1a-8fda-11eb-1828-0307c65b81cd
# ╠═0c76f49e-8fdb-11eb-2c2c-59a4060e8e1d
# ╠═4596edec-8fdb-11eb-1369-f3e98cb831cd
# ╠═255d51b6-8ff3-11eb-076c-31ba4c5ce10d
# ╟─43292298-8ff7-11eb-2b9d-017acc9ef185
# ╟─1bdc6068-8ff7-11eb-069c-6d0f1a83f373
# ╠═11ef1d18-8ff7-11eb-1645-113c1aae6e9b
# ╟─592afd96-8ff7-11eb-1200-47eaf6b6a28a
# ╠═4ef2153a-8fdb-11eb-1a23-8b1c28381e34
# ╟─76f4424e-8fdc-11eb-35ee-dd09752b947b
# ╟─dede8022-8fd2-11eb-22f8-a5614d703c01
# ╠═b4f18188-8fd2-11eb-1950-ef3bee3e4724
# ╠═292f0e44-8fd3-11eb-07cf-5733a5327630
# ╠═6b50e9e6-8fd3-11eb-0ab3-6fc3efea7e37
# ╠═5300b082-8fdb-11eb-03fe-55f511364ad9
# ╟─ac3a7c18-8ff3-11eb-1c1f-17939cff40f9
# ╟─b8e59db2-8ff3-11eb-1fa1-595fdc6652bc
# ╟─cb167a60-8ff3-11eb-3885-d1d8a70e2a5e
# ╟─fc0acee6-8ff3-11eb-13d1-1350364f03a9
# ╟─2c8b75de-8ff4-11eb-1bc6-cde7b67a2007
# ╠═639e517c-8ff4-11eb-3ea8-07b73b0bff78
# ╠═3d78116c-8ff5-11eb-0ee3-71bf9413f30e
# ╠═b63c02e4-8ff4-11eb-11f6-d760e8760118
# ╟─cd9b10f0-8ff5-11eb-1671-99c6738b8074
# ╠═a899fc08-8ff5-11eb-1d00-e95b55c3be4b
# ╟─0b901c34-8ff6-11eb-225b-511718412309
# ╠═180a4746-8ff6-11eb-046f-ddf6bb938a35
# ╠═27595716-8ff6-11eb-1d99-7bf13eedddf7
# ╟─bfb62f1a-8ff5-11eb-0f7a-cf725f3269c5
# ╟─0a150880-8ff6-11eb-0046-45fa2d4b476e
# ╠═26569eb4-8fd1-11eb-2df9-098a0792a09e
# ╠═baf1fe40-8ff6-11eb-1da1-cd43880db334
# ╠═be5f9900-8ff6-11eb-1816-03447cabd9a9
# ╠═52a2cac8-8ff8-11eb-2da4-0b113618c64b
# ╠═754b0a80-8ff8-11eb-364b-85fa49d6bb8e
# ╟─bd484878-8ff8-11eb-0337-7730ab2b07d4
# ╟─c3043eb6-8ff8-11eb-2cae-13d1c1613234
# ╠═eb555508-8ff8-11eb-1b70-e95290084742
# ╠═1e5047c4-8ff9-11eb-2628-c7824725678a
# ╠═44a5ef96-8ff9-11eb-06a0-d3a8dcf5c1aa
# ╠═574744ec-8ff9-11eb-033c-a3dff07a292b
# ╟─6003162e-8ff9-11eb-020e-21594868899f
# ╠═318f5274-8ff9-11eb-1c88-5fde5b546099
# ╠═90ee7558-8ff9-11eb-3602-271890987ece
# ╠═a168ace6-8ff9-11eb-393d-45c34fdf577c
# ╟─a51b1538-8ff9-11eb-0635-81088e826bb3
# ╠═d88c0830-8ff9-11eb-3e71-c1ac327f4e25
# ╟─dd995120-8ff9-11eb-1a53-2d65f0b5585a
# ╠═f171c27c-8ff9-11eb-326c-6b2d8c38451d
# ╟─ab7c6b18-8ffa-11eb-2b6c-dde3dca1c6f7
# ╟─79c55fc0-8ffb-11eb-229f-49198aee8245
# ╠═4493ac9e-8ffb-11eb-15c9-a146091d7696
# ╠═a591ac12-8ffb-11eb-1734-09657f875b1e
# ╠═6c5ef6d4-8ffb-11eb-2fe9-9dd87d92abe4
# ╟─1d4e236c-8ffb-11eb-209d-851e1af231d4
# ╠═0c3cfb16-8ffb-11eb-3ef9-33ea9acbb8c0
# ╠═325560f4-8ffb-11eb-0e9b-53f6869bdd97
# ╠═89138e02-8ffb-11eb-2ad2-c32e663f57b0
# ╠═34bcab72-8ffb-11eb-1d0c-29bd83de638b
# ╠═bf9a4722-8ffb-11eb-1652-f1bfb4916d2a
# ╠═611f770c-8ffc-11eb-2c23-0d5750afd7c8
# ╠═636b2ce0-8ffc-11eb-2411-571f78fb8a84
# ╠═c7613c44-8ffc-11eb-0a43-dbc8b1f62be9
# ╟─656999be-8ffc-11eb-0f51-51d5a162a004
# ╟─8cb5373a-8ffc-11eb-175d-b11ec5fae1ab
# ╠═3dd5581e-8fd1-11eb-282b-cb30f2dcb069
# ╠═10e3a754-8fd2-11eb-0c66-870b9568a05b
# ╠═2e7adf46-8fd2-11eb-3d0f-eb01695084d8
# ╠═19dbd48a-8fd2-11eb-132d-c7e67043513c
# ╠═8edb7874-8fd1-11eb-3e97-33e067f79500
# ╠═e483d9c4-8fd1-11eb-311c-b37da0f373d5
# ╠═25b4ccca-8ffd-11eb-3fe0-2d14ce90d8b3
# ╠═9913427a-8ffd-11eb-3c28-c12ee05ed9d3
# ╠═aa9d94dc-8ffd-11eb-0537-c39344c224c2
# ╠═b5300720-8ffd-11eb-2ca4-ed7a7c9b5516
# ╠═eea0c788-8ffd-11eb-06e0-cfb65dbba7f1
# ╠═028695a2-8ffe-11eb-3cf4-bd07bfe4df3a
# ╟─820af6dc-8fdc-11eb-1792-ad9f32eb915e
# ╟─ce330b78-8fda-11eb-144d-756275542eea
# ╠═668ade6a-8fda-11eb-0a5e-cb791b245ec0
# ╠═4e94d1da-8fda-11eb-3572-398fb4a12c3c
# ╠═9ca993a6-8fda-11eb-089c-4d7f89c81b94
# ╠═28dd02f0-8fd3-11eb-397c-45f92b90a40c
