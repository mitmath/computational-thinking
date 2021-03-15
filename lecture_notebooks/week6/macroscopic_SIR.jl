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

# ╔═╡ 9a0cec14-08db-11eb-3cfa-4d1c327c63f1
begin
	using Plots
	using PlutoUI
	using Statistics
end

# ╔═╡ a3b2accc-0845-11eb-229a-e97bc3943016
md"""
## From micro to macro & discrete to continuous
"""

# ╔═╡ ac4f6944-08d9-11eb-0b3c-f5e0a8b8c17e
md"""

Microscopic stochastic models, like the ones we have been studying in the homeworks, are intuitive and useful to include different effects. But often what we are actually interested in is a global picture of how an epidemic is evolving in time: how many infectious individuals there are in total at a given time, for example.

In this notebook we will see that it is often possible to summarise the **microscopic dynamics** of a **stochastic model** using **deterministic** equations for a **macroscopic** description.

Those macroscopic equations can either be in discrete time (**recurrence relations** or **difference equations**), or we can take a **continuous limit** and convert them into **ordinary differential equations**.

We're aiming for a plot like the following:
"""

# ╔═╡ f9a75ac4-08d9-11eb-3167-011eb698a32c
md"""
Let's go back to the model of recovery from an infection from the homework, with allowed transitions $I \to R$:

> we have $N$ people infected at time $0$. If each has probability $p$ to recover each day, how many are still infected at day number $t$?

Let's use a computational thinking approach: start off by coding the simulation and plotting the results:
"""

# ╔═╡ ba7ffe78-0845-11eb-2847-851a407dd2ec
bernoulli(p) = rand() < p 

# ╔═╡ d088ed2e-0845-11eb-0697-310f374effbc
N = 200

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

# ╔═╡ 58d8542c-08db-11eb-193a-398ce01b8635
begin
	infected = trues(N)
		
	results = [copy(step!(infected, 0.05)) for i in 1:T]
	pushfirst!(results, trues(N))
end

# ╔═╡ 8d6c0c06-08db-11eb-3790-c98fdc545352
@bind i Slider(1:T, show_value=true)

# ╔═╡ 7e1b61ac-08db-11eb-209e-1d6c328f5113
begin
	scatter(results[i], 
		alpha=0.5, size=(300, 200), leg=false, c=Int.(results[i]))
	
	annotate!(N, 0.9, text("$(count(results[i]))", 10))
	annotate!(N, 0.1, text("$(N - count(results[i]))", 10))
	
	ylims!(-0.1, 1.1)
	
	xlabel!("i")
	ylabel!("X_i(t)")

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
	ylabel!("number infectious")
end

# ╔═╡ f3c85814-0846-11eb-1266-63f31f351a51
all_data = [simulate_recovery(pp, T) for i in 1:30];

# ╔═╡ 01dbe272-0847-11eb-1331-4360a575ff14
begin
	plot(all_data, alpha=0.1, leg=false, m=:o, ms=1,
		size=(500, 400), label="")
	xlabel!("time t")
	ylabel!("number infectious")
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
	ylabel!("number infectious")
end



# ╔═╡ caa3faa2-08e5-11eb-33fe-cbbc00cfd459
md"""
## Deterministic dynamics for the mean: Intuitive derivation
"""

# ╔═╡ 2174aeba-08e6-11eb-09a9-2d6a882a2604
md"""
The mean seems to behave in a rather predictable way over time. Can we derive this?

Let $I_t$ be the number of infectious people at time $t$. This decreases because some people recover. Since people recover with probability $p$, the number of people that recover at time $t$ is, on average, $p I_t$. [Note that one time unit corresponds to one *sweep* of the simulation.]

So

$$I_{t+1} = I_t - p \, I_t$$

or

$$I_{t+1} = I_t (1 - p).$$

"""

# ╔═╡ 7e89f992-0847-11eb-3155-c5313575f767
md"""
At time $t$ there are $I_t$ infectious.
How many decay? Each decays with probability $p$, so on average $p I_t$ recover, so are removed from the number of infectious, giving the change

$$\Delta I_t = I_{t+1} - I_t = -p \, I_t$$
"""

# ╔═╡ f5756dd6-0847-11eb-0870-fd06ad10b6c7
md"""
We can rearrange and solve the recurrence relation:

$$I_{t+1} = (1 - p) I_t. $$

so

$$I_{t+1} = (1 - p) (1 - p) I_{t-1} = (1 - p)^2 I_{t-1}$$


and hence solve the recurrence relation:

$$I_t = (1-p)^t \, I_0.$$
"""

# ╔═╡ 113c31b2-08ed-11eb-35ef-6b4726128eff
md"""
Let's compare the exact and numerical results:
"""

# ╔═╡ 6a545268-0846-11eb-3861-c3d5f52c061b
exact = [N * (1-pp)^t for t in 0:T]

# ╔═╡ 4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
begin
	plot(mean(all_data), m=:o, label="numerical mean",
		size=(500, 400))
	plot!(exact, lw=3, label="analytical mean")
end
	

# ╔═╡ 3cd1ad48-08ed-11eb-294c-f96b0e7c33bb
md"""
They agree well, as they should. The agreement is expected to be better (i.e. the fluctuations smaller) for a larger population.
"""

# ╔═╡ 57665108-08e7-11eb-2d45-311e07217c4e
md"""

## Derivation using mean of stochastic process 

Instead of appealing to our intuition in the derivation, we can formulate an exact description of the stochastic process in terms of random variables: $X_t^i$ takes the value 1 if the $i$th person is infected at time $t$, and $0$ if they have recovered, as in the plot above.

Each coin flip is given by an independent Bernoulli random variable $B_t^i$, which has the value 1 (true) with probability $p$, and 0 (false) with probability $1 - p$.

The value at the next time step, $X_{t+1}^i$, is given by

$$X_{t+1}^i = \begin{cases} 0 &\text{if } X_t^i = 0 \text{ or } B_t^i = 1 \\
1 &\text{otherwise}
\end{cases}$$

We can write this as

$$X_{t+1}^i = X_t^i \, (1 - B_t^i).$$

(You should check that this is equivalent to the previous description!)

"""

# ╔═╡ 04d1ce96-0986-11eb-0c35-c73eb60d0994
md"""

$$\newcommand{mean}[1]{\left \langle #1 \right \rangle}$$

Let's denote the mean of a random variable $X$ by, denoted $\langle X \rangle$. In probability theory this is often called **expectation** (or "expected value") and written $\mathbb{E}[X]$.

Taking the expectation of both sides of the above equation, and using that the expectation of a product of independent random variables is the product of their expectations, we obtain

$$\mean{X_{t+1}^i} = \mean{X_t^i} \, \left(1 - \mean{B_t^i} \right).$$

The mean of each independent but identically distributed Bernoulli variable $B_t^i$ is $p$.

To find the mean total number of infected individuals we just sum up the boolean variables $X_t^i$:

$$I_t = \mean{\sum_{i=1}^N X_t^i}.$$
"""

# ╔═╡ 9d688084-0986-11eb-240f-23d85d9a3554
md"""
Putting all this together gives us back our previous result,

$$I_{t+1} = (1 - p) \, I_t .$$
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

# ╔═╡ 5f4516fe-098c-11eb-3abe-418aac994cc3
discrete_time_SIR_plot

# ╔═╡ Cell order:
# ╠═9a0cec14-08db-11eb-3cfa-4d1c327c63f1
# ╟─a3b2accc-0845-11eb-229a-e97bc3943016
# ╟─ac4f6944-08d9-11eb-0b3c-f5e0a8b8c17e
# ╠═5f4516fe-098c-11eb-3abe-418aac994cc3
# ╟─f9a75ac4-08d9-11eb-3167-011eb698a32c
# ╠═ba7ffe78-0845-11eb-2847-851a407dd2ec
# ╠═d088ed2e-0845-11eb-0697-310f374effbc
# ╠═e2d764d0-0845-11eb-0031-e74d2f5acaf9
# ╠═9282eca0-08db-11eb-2e36-d761594b427c
# ╠═58d8542c-08db-11eb-193a-398ce01b8635
# ╠═8d6c0c06-08db-11eb-3790-c98fdc545352
# ╟─7e1b61ac-08db-11eb-209e-1d6c328f5113
# ╠═33f9fc36-0846-11eb-18c2-77f92fca3176
# ╠═39a69c2a-0846-11eb-35c1-53c68a9f71e5
# ╠═cb278624-08dd-11eb-3375-276bfe8d7b3a
# ╠═f3c85814-0846-11eb-1266-63f31f351a51
# ╟─01dbe272-0847-11eb-1331-4360a575ff14
# ╟─be8e4ac2-08dd-11eb-2f72-a9da5a750d32
# ╟─8bc52d58-0848-11eb-3487-ef0d06061042
# ╟─caa3faa2-08e5-11eb-33fe-cbbc00cfd459
# ╟─2174aeba-08e6-11eb-09a9-2d6a882a2604
# ╟─7e89f992-0847-11eb-3155-c5313575f767
# ╟─f5756dd6-0847-11eb-0870-fd06ad10b6c7
# ╟─113c31b2-08ed-11eb-35ef-6b4726128eff
# ╟─6a545268-0846-11eb-3861-c3d5f52c061b
# ╟─4c8827b8-0847-11eb-0fd1-cfbdbdcf392e
# ╟─3cd1ad48-08ed-11eb-294c-f96b0e7c33bb
# ╟─57665108-08e7-11eb-2d45-311e07217c4e
# ╟─04d1ce96-0986-11eb-0c35-c73eb60d0994
# ╟─9d688084-0986-11eb-240f-23d85d9a3554
# ╟─2f980870-0848-11eb-3edb-0d4cd1ed5b3d
# ╟─6af30142-08b4-11eb-3759-4d2505faf5a0
# ╟─c6f9feb6-08f3-11eb-0930-83385ca5f032
# ╟─d8d8e7d8-08b4-11eb-086e-6fdb88511c6a
# ╟─780c483a-08f4-11eb-1205-0b8aaa4b1c2d
# ╟─a13dd444-08f4-11eb-08f5-df9dd99c8ab5
# ╟─cb99fe22-0848-11eb-1f61-5953be879f92
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
