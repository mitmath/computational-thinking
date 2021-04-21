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

# ╔═╡ 41f7d874-8cb9-11eb-308d-47dea998f6bf
html"""
<div style="
position: absolute;
width: calc(100% - 30px);
border: 50vw solid #282936;
border-top: 500px solid #282936;
border-bottom: none;
box-sizing: content-box;
left: calc(-50vw + 15px);
top: -500px;
height: 500px;
pointer-events: none;
"></div>

<div style="
height: 500px;
width: 100%;
background: #282936;
color: #fff;
padding-top: 68px;
">
<span style="
font-family: Vollkorn, serif;
font-weight: 700;
font-feature-settings: 'lnum', 'pnum';
"> <p style="
font-size: 1.5rem;
opacity: .8;
"><em>Section 3.1</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Time stepping </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

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

# ╔═╡ 6f871ac0-716d-4bf8-a067-c798869c103f
md"""
# Modeling component failure: Discrete and continuous
"""

# ╔═╡ ae243395-521b-4834-b61e-19501e54b41c
md"""
Let's think about a simple model for failure of components such as light bulbs. 
(We actually derived this global, or macroscopic, model from a microscopic stochastic model a few lectures ago.)
	
Components can fail at any moment but we'll start off by checking once per day to count the number that have failed during that day. Then we'll check several times per day. This is still a **discrete** model. Finally we'll see how we can turn this into a **continuous** model where we can talk about the number that have failed by any real time $t$.
"""

# ╔═╡ 8d2858a4-8c38-11eb-0b3b-61a913eed928
md"""
## Checking failures once per day (integer time steps)
"""

# ╔═╡ e93c5f2f-d7c8-41ea-bdbb-7cf6587b6266
md"""


Let's call $N_k$ the (average) number of bulbs that are still functioning on day number $k$, starting from an initial number $N_0$.

We can find an equation for the number $N_{k+1}$ that are still functioning at the end of day number $k+1$ by working out how many *fail* on day $k+1$. 

Let's call $p$ the probability that each bulb fails each day. For example, if 10% of the bulbs fail each day then $p = 0.1$.

If there are 100 bulbs and 10% fail on the first day, then 10 fail, so there will be 90 remaining. In general, if a proportion $p$ of the $N_k$ fail, in total we expect $p \, N_k$ to fail.

Hence

$$N_{k+1} = N_k - p \, N_k$$

or

$$N_{k+1} - N_k = - p N_k.$$

In this very simple model we can actually solve this recurrence relation analytically to find the number still functioning at time $t$:

$$N_{k+1} = (1 - p) N_k$$

so

$$N_k = (1 - p) N_{k-1} = (1 - p)^2 N_{k-2} = \cdots$$

hence

$$N_k = N_0 \, (1 - p)^k.$$

"""

# ╔═╡ 43f5ac88-7d07-429c-b27f-49908c30bdf9
md"""
## Checking failures $n$ times per day
"""

# ╔═╡ b70465ab-9c7c-4533-9539-b414ef54a892
md"""
Now suppose instead we ask how many light bulbs fail in *half* a day. If 10% fail per day, it's natural to think that 5% fail in half a day. 

However, this is not quite right due to the effect of **compounding** (as in compound interest). If 5% fail and then 5% of the remainder fail, then how many are left?



"""

# ╔═╡ 80c1a728-1784-4bb7-b2c3-e77b41929a78
(1 - 0.05) * (1 - 0.05)

# ╔═╡ a25cb8e6-f65d-4061-b90c-079814458c94
md"""
So slightly *fewer* than 10% in total have failed, due to the effect of compounding. Nonetheless, the result is approximately right, so let's take that.
"""

# ╔═╡ 4cc483e5-c322-44c8-83f1-802b6cb432aa
md"""
So let's suppose that $n$ times a day, a proportion $p / n$ fail (for example, 10% and twice a day gives 5% failing each time, approximately).

Then the number remaining after the first failure check on day $k$ is
"""

# ╔═╡ 3ce501b4-76bc-49ab-b3b8-a41f29dbcc2b
md"""
$N_{k + \frac{1}{n}} = \textstyle (1 - \frac{p}{n}) N_k$

Here we have used a subscript since we are in a discrete situation. We could also have written instead

$$N(k + \textstyle \frac{1}{n}).$$

The solution at the next day is

$$N_{k+1} = N_k \, (1 - \textstyle \frac{p}{n})^n.$$

And the full solution for the number remaining after $k$ days is

$N_k = N_0 \, \textstyle (1 - \frac{p}{n})^{nk}$
"""

# ╔═╡ c539e622-d76d-489a-abb9-4ba47dfe9b90
md"""
Let's plot these to see what they look like:
"""

# ╔═╡ 95fe38c5-d717-47d0-8db7-5f8d53a6c6f1
md"""
n = $(n_slider = @bind n Slider(0:8, show_value=true))
"""

# ╔═╡ 2982c418-dad5-44cc-8194-5b607af84b16
p = 0.4

# ╔═╡ c97964d1-b5d2-4ee7-80cc-995b3f344aa1
let
	N0 = 100
	T = 20
	
	N = [N0 * (1 - p)^t for t in 0:T]
	
	plot(0:T, N, m=:o, alpha=0.5, ms=3, label="once daily", lw=2)
	
# 	N2 = [N0 * (1 - p5/2)^(t) for t in 0:2T]
# 	plot!(0:0.5:T, N2, m=:o, alpha=0.5, ms=2, label="twice a day")
	
# 	N4 = [N0 * (1 - p5/4)^(t) for t in 0:4T]
# 	plot!(0:0.25:T, N4, m=:o, alpha=0.5, ms=2, label="four times a day")
	
	N = [N0 * (1 - p/(2^n))^(t) for t in 0:(2^n)*T]
	plot!(0:(2.0^(-n)):T, N, m=:o, alpha=0.5, ms=2, label="$(2^n) times per day")
	
	xlabel!("days (k)")
	ylabel!("N_k")
	
	title!("$(2^n) times per day")
	
	
	# plot!(t -> N0 * exp(-p5 * t))
end

# ╔═╡ ba121b40-2bfc-42d4-81ee-5f90e18ec8de
md"""
## Continuous time 
"""

# ╔═╡ 74892ec6-6639-469d-8711-5039a140d833
md"""
Thinking back to the class on "discrete to continuous", we see that we are producing more and more discrete values to keep track of, but after a while the curve they trace out does not really change. It thus makes sense to define a **limiting object**, which is what would happen if you could take smaller and smaller time steps in the right way, i.e. take the limit as $n \to \infty$. 

In that case we could imagine being able to calculate the (average) number $N(t)$
of bulbs that are functioning at time $t$, where $t$ can be *any* positive real number.


"""

# ╔═╡ fc6899d3-ea18-487a-add1-20be86ce9c74
md"""
In calculus we learn ways to see that
"""

# ╔═╡ 75a60bcf-3f77-49fb-a7ee-db4580aae6f3
md"""
$(1 - p/n)^n$ converges to $\exp(-p)$ as $n \to \infty$.
"""

# ╔═╡ 786beb46-d175-44b3-a63e-057150e53c66
md"""
An alternative approach is to look at the time evolution in terms of *differences*. In a time $1/n$ a proportion $p/n$ decays. Here we are thinking of $\delta t = 1/n$ as the **time step** between consecutive checks. If there are $N(t)$ bulbs functioning at a time $t$ and we take a small time  step of general length $\delta t$, a proportion $p \, \delta t$ should fail, so that
"""

# ╔═╡ 2d9f3aad-1d41-4918-a128-47dc58b667e3
md"""
$N(t + \delta t) - N(t) = -(p \, \delta t) \, N(t).$
"""

# ╔═╡ 17a23094-3975-49f4-8c7f-03fbc8afbbf2
md"""
Dividing through by $\delta t$ we find
"""

# ╔═╡ eaf6f4eb-b367-492e-a1be-81f9455252c4
md"""
$$\frac{N(t + \delta t) - N(t)}{\delta t} = -p \, N(t).$$

"""

# ╔═╡ 51c226b9-ab3d-46b4-a963-3548ad715d85
md"""
We now recognise the left-hand side of the equation: if we take the limit as $\delta t \to 0$, we have exactly the definition of  the **derivative** $\frac{dN(t)}{dt}$.

Hence, taking that limit we obtain
"""

# ╔═╡ 6c527098-ab53-4862-bda6-0c11b1564a11
md"""
$$\frac{dN(t)}{dt} = - p \, N(t)$$

with $N(0) = N_0$, the initial number.

This is an **ordinary differential equation**: it is an equation relating the value of the function $N(t)$ at time $t$ to the derivative (slope) of that function at that point. This relationship must hold for all $t$. It is not obvious that this equation even makes sense (although it should do, given the way we have derived it), but in differential equations courses we see that it does make sense (under some technical conditions), and uniquely specifies a function satisfying the ODE together with the initial condition. (This is called an "initial-value problem".)
"""

# ╔═╡ 3c2b2f03-522c-40a0-ac1d-8054fe8e3fa2
md"""
In this particular case, once again we are lucky enough to be able to solve this equation analytically:  $N(t)$ is a function whose derivative is a multiple of the same function, and hence it must be exponential:
"""

# ╔═╡ 5cec433e-ee71-44b5-b5d6-3feab80fa535
md"""
$N(t) = N_0 \exp(-p \, t)$
"""

# ╔═╡ 96b02ce7-ce16-4276-a147-ba94d7a2e160
md"""
This is an alternative way to define the exponential function. We can add this to the above plot:
"""

# ╔═╡ d952db33-1f82-42f5-96af-8038c256715b
n_slider

# ╔═╡ 2b9276dc-fcca-4469-a62c-028a9eb3c2a9
let
	N0 = 100
	T = 20
	
	N = [N0 * (1 - p)^t for t in 0:T]
	
	plot(0:T, N, m=:o, alpha=0.5, ms=3, label="once daily", lw=2)
	
# 	N2 = [N0 * (1 - p5/2)^(t) for t in 0:2T]
# 	plot!(0:0.5:T, N2, m=:o, alpha=0.5, ms=2, label="twice a day")
	
# 	N4 = [N0 * (1 - p5/4)^(t) for t in 0:4T]
# 	plot!(0:0.25:T, N4, m=:o, alpha=0.5, ms=2, label="four times a day")
	
	N = [N0 * (1 - p/(2^n))^(t) for t in 0:(2^n)*T]
	plot!(0:(2.0^(-n)):T, N, m=:o, alpha=0.5, ms=2, label="$(2^n) times per day")
	
	xlabel!("days (k)")
	ylabel!("N_k")
	
	title!("$(2^n) times per day")
	
	
	plot!(t -> N0 * exp(-p * t), label="continuous", lw=2)
end

# ╔═╡ 754fe8c1-7021-48e8-9523-d5b22d0af93f
md"""
We see graphically that this is indeed the correct limiting curve.
"""

# ╔═╡ ccb35ad7-db20-46fa-abff-a6e88ef999e0
md"""
In this context, $p$ is called a **rate**; it is a *probability per unit time*, i.e. a ratio of probability and time. (To get the probability of decaying in a time $\delta t$, we *multiplied* $p$ by $\delta t$.)
"""

# ╔═╡ d03d9bfc-20ea-49bc-bc7b-df22cc240ffe
md"""
Let's summarise what we have found:
"""

# ╔═╡ dde3ffc7-b333-4305-b8e7-9888e4512c41
md"""
| Step type   | Time stepping     |  Difference    |   Solution  |
| ----------- | :-----------: | :-----------:  | :-----------: |
| Integer            | $N_{k+1} = (1 - p) N_k$  |  $N_{k+1} - N_k = -p N_k$  | $N_k = N_0 (1 - p)^k$
| Rational |  $N_{k + \frac{1}{n}} = \textstyle (1 - \frac{p}{n}) N_k$ | $N_{k + \frac{1}{n}} - N_k = \textstyle (- \frac{p}{n}) N_k$   | $N_k = N_0 (1 - \frac{p}{n})^{n k}$ 
| Continuous   | $N(t + \delta t) = (1 - p \, \delta t) N(t)$         |  $\frac{dN(t)}{dt} = - p \, N(t)$  |  $N(t) = N_0 \exp(-p \, t)$

"""

# ╔═╡ d74bace6-08f4-11eb-2a6b-891e52952f57
md"""
# SIR model
"""

# ╔═╡ 76268535-e232-4e02-97cd-cf9b3ddec256
md"""

Let's look at a more complicated example, the **SIR** model of the spread of an epidemic, or of a rumour, in a population. You are surely familiar with models of this type modelling the spread of COVID-19, and from the homework.

As in the homework, we can make a fully discrete, stochastic agent-based model, where we give microscopic rules specifying how individual agents interact with one another. When we run such models with large enough systems, we observe that the results are often quite smooth. An alternative approach is to try to write down macroscopic discrete equations that describe the dynamics of averages. 

Often it is easier to understand the behaviour of such systems by formulating a continuous version of the model. Some people make discrete models because they're not happy with continuous models; large discrete models can also be computationally wasteful. On the other hand, they can also include effects that might be more difficult to model in a continuous framework, e.g. non-local effects or things that "don't become continuous very well". 
"""

# ╔═╡ 11e24e1d-39db-4b7e-96db-50458def72af
md"""
## Discrete-time SIR model
"""

# ╔═╡ dbdf2812-08f4-11eb-25e7-811522b24627
md"""
First let's think about the SI model: agents can be susceptible (S) and infectious (I). A susceptible person becomes infectious when they come into contact with an infectious person, with some probability.
"""

# ╔═╡ 238f0716-0903-11eb-1595-df71600f5de7
md"""
Let's call $S_t$ and $I_t$ be the number of susceptible and infectious people at time $t$, respectively, and let's call $N$ the total number of people.

Let's suppose that at each time step, each infectious person has the chance to interact with one other person (on average). That person will be chosen at random from the total population of size $N$. A new infection occurs only if that chosen person is susceptible, which happens with probability $S_t / N$, and only if the infection attempt is successful, with probability $b$, say.

Hence the change in the number of infectious people after that step is
"""

# ╔═╡ 8e771c8a-0903-11eb-1e34-39de4f45412b
md"""
$$\Delta I_t = I_{t+1} - I_t = b \, I_t \, \left(\frac{S_t}{N} \right)$$
"""

# ╔═╡ fb52c62d-15d3-46a2-8e3d-2de20c68ded4
md"""
The decrease in $S_t$ is also given by $\Delta I_t$.
"""

# ╔═╡ e83fc5b8-0904-11eb-096b-8da3a1acba12
md"""
There is also recovery, with a constant probability $c$ at each step, once you are infectious.

It is useful to normalize by $N$, so we define the proportions of the population that are susceptible, infectious and recovered as

$$s_t := \frac{S_t}{N}; \quad i_t := \frac{I_t}{N}; \quad r_t := \frac{R_t}{N}.$$
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

# ╔═╡ cea2dcfb-b1eb-4269-81d7-8596969e9bd6
md"""
## Continuous-time SIR model
"""

# ╔═╡ 08d166f1-3af0-45a8-bcad-6ee958497453
md"""
We can now go through the same process as with the failure model, where we take time steps of length $\delta t$ instead, and replace probabilities $b$ and $c$ with *rates* $\beta$ and $\gamma$. Taking the limit $\delta t \to 0$ we get
"""

# ╔═╡ 72061c66-090d-11eb-14c0-df619958e2b6
md"""
$$\begin{align}
\frac{ds(t)}{dt} &= -\beta \, s(t) \, i(t) \\
\frac{di(t)}{dt} &= +\beta \, s(t) \, i(t) &- \gamma \, i(t)\\
\frac{dr(t)}{dt} &= &+ \gamma \, i(t)
\end{align}$$
"""

# ╔═╡ c07367be-0987-11eb-0680-0bebd894e1be
md"""
We can think of this as a model of a chemical reaction with species S, I and R. The term $s(t) i(t)$ is known as the [**mass action**](https://en.wikipedia.org/wiki/Law_of_mass_action) form of interaction.

Note that no analytical solutions of these (simple) nonlinear ODEs are known as a function of time! (However, [parametric solutions are known](https://arxiv.org/abs/1403.2160).)
"""

# ╔═╡ f8a28ba0-0915-11eb-12d1-336f291e1d84
md"""
Below is an example simulation of the discrete-time model. 
"""

# ╔═╡ 442035a6-0915-11eb-21de-e11cf950f230
begin
	ts = 1:length(SIR)
	discrete_time_SIR_plot = plot(ts, [x.s for x in SIR], 
		m=:o, label="S", alpha=0.2, linecolor=:blue, leg=:right, size=(400, 300))
	plot!(ts, [x.i for x in SIR], m=:o, label="I", alpha=0.2)
	plot!(ts, [x.r for x in SIR], m=:o, label="R", alpha=0.2)
	
	xlims!(0, 500)
end

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

# ╔═╡ 5f5d7332-b5f8-4d05-971b-ec0564f1339b
md"""
# Time stepping: The Euler method
"""

# ╔═╡ 7cf51986-5983-4094-a18f-f95f2f6993da
md"""
Above we showed how we can think of Ordinary Differential Equations (ODEs) as arising in a natural way from discrete-time models where we take time steps.

What about if somebody gives us an ODE -- how should we solve it numerically?

In fact, we do the reverse process: We **discretize** the equation and reduce it to a system where we take time steps!

Suppose the differential equation is

$$\dot{x} = f(x)$$

The simplest such method is the **Euler method**: we approximate the derivative using a small (but not *too* small) time step $h$ (what we called $\delta t$ above):

$$\dot{x} \simeq \frac{x(t + h) - x(t)}{h}$$

giving

$$x(t + \delta t) \simeq x(t) + h \, f(x).$$ 

The Euler method with constant time step is then the following algorithm:

$$x_{k+1} = x_k + h \, f(x_k)$$

If we have several variables in our ODE, we can wrap the variables up into a vector and use the *same* method: for the ODE

$$\dot{\mathbf{x}} = \mathbf{f}(\mathbf{x})$$

the Euler method becomes

$$\mathbf{x}_{k+1} = \mathbf{x}_k + h \, \mathbf{f}(\mathbf{x}_k),$$

where $\mathbf{f}$ denotes is a vector-valued function mapping the vector of variables to the vector of right-hand sides of the ODEs.


"""

# ╔═╡ 763bbb15-c52e-4159-99b7-f3d17f47d56a
md"""
However, in general the Euler method is *not* a good algorithm to simulate the dynamics of an ODE! We can see why that might be from the graphs at the start of this notebook: taking time steps like this actually does a *bad* job at approximating the continuous curve. Numerical analysis courses show how to design better numerical methods to approximate the true solution of an ODE more accurately.

The Julia [SciML / DifferentialEquations.jl](https://diffeq.sciml.ai/stable/tutorials/ode_example/) ecosystem provides a large suite of methods for solving ODEs and many other types of differential equations using state-of-the-art methods.
"""

# ╔═╡ Cell order:
# ╟─41f7d874-8cb9-11eb-308d-47dea998f6bf
# ╠═9a0cec14-08db-11eb-3cfa-4d1c327c63f1
# ╠═fb6cdc08-8b44-11eb-09f5-43c167aa53fd
# ╟─6f871ac0-716d-4bf8-a067-c798869c103f
# ╟─ae243395-521b-4834-b61e-19501e54b41c
# ╟─8d2858a4-8c38-11eb-0b3b-61a913eed928
# ╟─e93c5f2f-d7c8-41ea-bdbb-7cf6587b6266
# ╟─43f5ac88-7d07-429c-b27f-49908c30bdf9
# ╟─b70465ab-9c7c-4533-9539-b414ef54a892
# ╠═80c1a728-1784-4bb7-b2c3-e77b41929a78
# ╟─a25cb8e6-f65d-4061-b90c-079814458c94
# ╟─4cc483e5-c322-44c8-83f1-802b6cb432aa
# ╟─3ce501b4-76bc-49ab-b3b8-a41f29dbcc2b
# ╟─c539e622-d76d-489a-abb9-4ba47dfe9b90
# ╟─95fe38c5-d717-47d0-8db7-5f8d53a6c6f1
# ╠═2982c418-dad5-44cc-8194-5b607af84b16
# ╠═c97964d1-b5d2-4ee7-80cc-995b3f344aa1
# ╟─ba121b40-2bfc-42d4-81ee-5f90e18ec8de
# ╟─74892ec6-6639-469d-8711-5039a140d833
# ╟─fc6899d3-ea18-487a-add1-20be86ce9c74
# ╟─75a60bcf-3f77-49fb-a7ee-db4580aae6f3
# ╟─786beb46-d175-44b3-a63e-057150e53c66
# ╟─2d9f3aad-1d41-4918-a128-47dc58b667e3
# ╟─17a23094-3975-49f4-8c7f-03fbc8afbbf2
# ╟─eaf6f4eb-b367-492e-a1be-81f9455252c4
# ╟─51c226b9-ab3d-46b4-a963-3548ad715d85
# ╟─6c527098-ab53-4862-bda6-0c11b1564a11
# ╟─3c2b2f03-522c-40a0-ac1d-8054fe8e3fa2
# ╟─5cec433e-ee71-44b5-b5d6-3feab80fa535
# ╟─96b02ce7-ce16-4276-a147-ba94d7a2e160
# ╠═d952db33-1f82-42f5-96af-8038c256715b
# ╠═2b9276dc-fcca-4469-a62c-028a9eb3c2a9
# ╟─754fe8c1-7021-48e8-9523-d5b22d0af93f
# ╟─ccb35ad7-db20-46fa-abff-a6e88ef999e0
# ╟─d03d9bfc-20ea-49bc-bc7b-df22cc240ffe
# ╟─dde3ffc7-b333-4305-b8e7-9888e4512c41
# ╟─d74bace6-08f4-11eb-2a6b-891e52952f57
# ╟─76268535-e232-4e02-97cd-cf9b3ddec256
# ╟─11e24e1d-39db-4b7e-96db-50458def72af
# ╟─dbdf2812-08f4-11eb-25e7-811522b24627
# ╟─238f0716-0903-11eb-1595-df71600f5de7
# ╟─8e771c8a-0903-11eb-1e34-39de4f45412b
# ╟─fb52c62d-15d3-46a2-8e3d-2de20c68ded4
# ╟─e83fc5b8-0904-11eb-096b-8da3a1acba12
# ╟─d1fbea7a-0904-11eb-377d-690d7a16aa7b
# ╟─dba896a4-0904-11eb-3c47-cbbf6c01e830
# ╟─cea2dcfb-b1eb-4269-81d7-8596969e9bd6
# ╟─08d166f1-3af0-45a8-bcad-6ee958497453
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
# ╟─5f5d7332-b5f8-4d05-971b-ec0564f1339b
# ╟─7cf51986-5983-4094-a18f-f95f2f6993da
# ╟─763bbb15-c52e-4159-99b7-f3d17f47d56a
