### A Pluto.jl notebook ###
# v0.12.7

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

# ╔═╡ 88b46d2e-220e-11eb-0f7f-b3f523f0214e
begin
	using Plots
	using PlutoUI
	using LaTeXStrings
	using Roots
end

# ╔═╡ 6f554dc0-220c-11eb-341f-1b66de841c86
md"""
## Nonlinear dynamics: stability and bifurcations
"""

# ╔═╡ 816de40c-220c-11eb-2d3a-23e6267cd529
md"""
In this module on climate modelling we will be studying various **differential equations** that model the evolution of aspects of the climate over time.

The simplest such models are **ordinary differential equations** (ODEs), where one or a few continuous variables evolve continuously in time, with a model that specifies their instantaneous rate of change as a function of their current values.

The general form of an ODE (that doesn't depend explicitly on time, i.e. that is **autonomous**), is

$$\frac{dx(t)}{dt} = f(x(t)),$$

or

$$\dot{x}(t) = f(x(t)),$$

with an initial condition $x(t=0) = x_0$.

Here, $\dot{x}(t)$ denotes the derivative of the function $t \mapsto x(t)$ at time $t$.
"""

# ╔═╡ d21f6358-220c-11eb-00b8-03fe0746fdc9
md"""
The simplest numerical method to solve such an equation is the **(forward) Euler method**, in which we convert this equation into an explicit time-stepping routine: we take a small time step of length $h$ and approximate the derivative as

$$\frac{dx(t)}{dt} \simeq \frac{x(t + h) - x(t)}{h},$$

giving the approximation

$$x(t + h) \simeq x(t) + h \, f(x(t))$$

for the approximation at the next time step.
"""



# ╔═╡ 735bb47e-220d-11eb-1ba6-8d591a935857
md"""
## Solving the ODE: Euler method
"""

# ╔═╡ 79b148b6-220d-11eb-2785-25d05068aeed
md"""
Let's use this to simulate a simple nonlinear ODE that describes the dynamics of a population of bacteria. The bacteria will grow by reproduction at a rate $\lambda$ provided there is sufficient food, in which case we would have $\dot{x} = \lambda x$. But the available food will actually always limit the sustainable population to a value $K$. A simple model for this is as follows:

$$\dot{x} = \lambda \, x \, (K - x).$$

When $x$ is close to $0$, the growth rate is $\lambda$, but that rate decreases as $x$ increases.

This is sometimes called the [**logistic** differential equation](https://en.wikipedia.org/wiki/Logistic_function#Logistic_differential_equation) (although the name does not seem particularly helpful).
"""

# ╔═╡ d43a869e-220d-11eb-009c-a119de57e7da
md"""
Our goal is to use computational thinking, but we will actually not be interested so much in the exact dynamics in time, but rather in the **qualitative** features of the behaviour of the system. For example, at long times (formally $t \to \infty$) does the population get arbitrarily large? Or does it, for example, oscillate around a particular value? Or does it converge to a particular size? This forms the subject of **nonlinear dynamics** or **dynamical systems** theory. 
"""

# ╔═╡ 088eabb2-220e-11eb-1ac0-df419b87f39a
md"""
Let's simulate the system using the Euler method to try to guess the answer to this question. Note that there are many much more sophisticated methods for solving ODEs collected in the DifferentialEquations.jl package. We should never use the Euler method in practice, but should use a tried and tested library instead, and algorithms that provide much better accuracy in the solutions, if we are interested in faithful numerical results.
"""

# ╔═╡ a44cc180-22d4-11eb-2129-211d024c4921
md"""
We'll rescale the variables to the simplest form:

$$\dot{x} = x \, (1 - x).$$
"""

# ╔═╡ 6aa1d2f4-220e-11eb-06e0-c346f74aa018
logistic(x) = x * (1 - x)

# ╔═╡ b6d0dd18-22d4-11eb-2083-0b02de030579
md"""
Let's simulate this with Euler and plot the trajectory $x(t)$ as a function of time $t$:
"""

# ╔═╡ f055be76-22d4-11eb-268a-bf70c7d8f1a1
md"""
We see that for this particular initial condition, the solution seems to settle down to a fixed value after some time, and then remains at that value thereafter.

Such a value is called a **fixed point** or a **stationary point** of the ODE.
"""

# ╔═╡ 90ccb392-2216-11eb-1fd8-83b7d7c16b54
md"""
## Qualitative behaviour: Fixed points and their stability
"""

# ╔═╡ bef9c2e4-220e-11eb-24d8-bd618d2985ea
md"""
 Let's see if what happens for other initial conditions:
"""

# ╔═╡ 17317eb8-22d5-11eb-0f46-2bf1bddd36bb
@bind x0 Slider(-1.0:0.001:20, default=0.0, show_value=true)

# ╔═╡ ae862e10-22d5-11eb-3d75-1d748cf86944
md"""
To get an overview of the behaviour we can also draw all the results on a single graph:
"""

# ╔═╡ 446c564e-220f-11eb-191a-6b419e790f3f
md"""
We see that all the curves starting near to $x_0=1.0$ seem to converge to 1 at long times. If the system starts *exactly* at 0 then it stays there forever. However, if it starts close to 0, on either side, then it moves *away* from 0 (on that same side of 0) -- starting from a negative value $x$ becomes ever more negative. (Even though negative populations have no meaning in the original interpretation as the dynamics of a population, we can still ask study the dynamics of the equation with negative initial conditions, since it may model other systems too.)

The special values $x^*_1=1$ and $x^*_2=0$ are called **stationary points** or **fixed points** of the differential equation. If we start at $x^*_i$, then the derivative there is $f'(x^*_i) = 0$, and hence we cannot move away from $x^*_i$! The fixed points can be found as zeros or **roots** of the function $f$, i.e. values $x^*$ such that $f(x^*) = 0$.
"""

# ╔═╡ 38894c32-2210-11eb-26ff-d9796edd7871
md"""
We see, though, that the two types of fixed points are **qualitatively different**: trajectories that start close to $x^*_1 = 1$ move *towards* $x^*_1$, whereas trajectories that start close to $x^*_2 = 0$ move *away* from it. We say that $x^*_1$ is a **stable fixed point** and $x^*_2$ is an **unstable fixed point**.

In general it is not possible to find analytical formulas for the position and stability of fixed points; instead, we can use numerical **root-finding algorithms**, for example the Newton method: see e.g. course 18.330 next semester. There are various Julia packages for root finding; we will use `Roots.jl`.
"""

# ╔═╡ a196a20a-2216-11eb-11f9-6789bb2a3ece
md"""
## State space: Vector field and phase portrait
"""

# ╔═╡ c15a53e8-2216-11eb-1460-8510aea0f570
md"""
If we want to find the whole trajectory for a given initial condition then we need to solve the equations, either numerically or analytically.

However, we may want less information about the system, for example the **long-time** or **asymptotic** dynamics. It turns out that we can obtain some information about that *without* explicitly solving the ODE! This is the **qualitative approach** to studying nonlinear systems.

Instead of drawing trajectories $x(t)$ as a function of time $t$, as we did above, let's use a different graphical representation, where we draw **state space** or **phase space**: This is the set ("space") of all possible values of the dependent variables ("states"). For the above ODE there is only a single dependent variable, $x$, so the state space is the real line, $\mathbb{R}$.

At each possible value of $x$, the ODE gives us information about the rate of change of $x(t)$ at that point. Let's draw an **arrow** at that point, pointing in the direction that a particle placed at that point would move: to the right if $\dot{x} > 0$ and to the left if $\dot{x} < 0$.
"""

# ╔═╡ 42c28b16-2218-11eb-304a-e534353fa12b
md"""
This vector field indeed gives us a *qualitative* picture of the dynamics. It does not tell us how fast the dynamics will occur in each region, but it indicates what the *tendency* is. We have coded the fixed points according to their stability; this may be calculated using the derivative evaluated at the fixed point, $f'(x^*)$, since this derivative controls the behaviour of nearby initial conditions $x^* + \delta x$.
The unstable fixed point is shown as a green square, and the stable fixed point as a grey circle; we will use this convention throughout the notebook.
"""

# ╔═╡ e6ed3366-2246-11eb-3a86-f375162c746d
md"""
## Bifurcations
"""

# ╔═╡ ec3c5d9c-2246-11eb-1ec5-e3d9c8a7fa23
md"""
Now suppose that there is a **parameter** $\mu$ in the system that can be varied. For each value of $\mu$ we have a *different* ODE

$$\dot{x} = f_\mu(x).$$

For example, 
$$\dot{x} = \mu + x^2.$$

Let's draw the state space for each different value of $\mu$:
"""

# ╔═╡ 3fa21738-2247-11eb-09d5-4dcf0e7377fc
g(μ, x) = μ + x^2

# ╔═╡ 19eb987e-2248-11eb-2982-1930b5840aed
@bind λ Slider(-1.0:0.05:1, show_value=true)

# ╔═╡ 49ec803a-22d7-11eb-3f04-db8f8c119a7d
md"""
Now let's collect all the vector fields into a single plot. We *rotate* the vector field to now be vertical, thinking of the dynamics of $x$ as occurring along the vertical direction. The horizontal axis now represents the different possible values of the parameter $\mu$:
"""

# ╔═╡ 27190ac0-230b-11eb-3367-af2bbbf57e5e
md"""
We see that at the **critical value** $\mu_c = 0$ there is a **qualitative change in behaviour** in the system: for $\mu_c < 0$ there are two fixed points, whereas for $\mu_c > 0$ there are no fixed points at all.  In this particular ODE the two fixed points collide in a **saddle--node** or **fold** bifurcation.
"""

# ╔═╡ 48ef665e-22d0-11eb-2c72-b722fafd296e
md"""
## Bistability and hysteresis
"""

# ╔═╡ 51eeb46c-22d0-11eb-1643-c92e725d9da0
md"""
Now let's look at the dynamics of the following system:

$$\dot{x} = \mu + x - x^3.$$
"""

# ╔═╡ 44c1738a-2247-11eb-3232-f30b46fd7ce6
h(μ, x) = μ + x - x^3

# ╔═╡ a56ad0bc-22d7-11eb-0418-d36f3ef14109
md"""
We see that there is a range of values of $\mu$ for which there are *three coexisting fixed points*, two stable and one unstable. Since there are two stable fixed points in which the system can remain, we say that the system is **bistable**.
"""

# ╔═╡ 5b9c66ce-224b-11eb-02a4-b9a5a173ee6a
md"""
Now that we understand what the plots mean and the dynamics, let's plot just the fixed points $x^*(\mu)$ as a function of $\mu$. Such a plot is called a **bifurcation diagram**:
"""

# ╔═╡ aa81663c-230b-11eb-3c0e-39759f36deb6
md"""
The pieces of curve are called **branches**.
"""

# ╔═╡ 55d4d188-2249-11eb-0c47-dfddce9b2027
md"""
## Hysteresis
"""

# ╔═╡ 5ac33518-2249-11eb-2d57-7de185d43e5f
md"""
Suppose we now think about slowly varying the parameter $\mu$. If we change the parameter $\mu$ by a little, the system is no longer at a fixed point, since the position of the fixed point moves when $\mu$ changes. However, the system will theb **relax** by following the dynamics at the new value of $\mu$, and will rapidly converge to the new fixed point nearby.

For example, starting at $\mu=-2$, the system will stay on the lower black (stable) **branch** until $\mu=0.4$ or so. At that point, two fixed points collide and annihilate each other! After that there is no longer a fixed point nearby. However, there is another fixed point much further up that will now attract all trajectories, so the system rapidly transitions to that fixed point.

Now suppose we decrease the parameter again. The system will now track the *upper* branch until $\mu=-0.4$ or so, when again it will jump back down.

For each parameter value $\mu$ in the interval $[-0.4, 0.4]$ there is **bistability**, i.e. **coexistence** of *two* fixed points with the same value of $\mu$ (together with a third, unstable fixed point that is not observable).

The fact that the system tracks different stable branches depending on where we started, i.e. on the history, is known as **hysteresis**.
"""

# ╔═╡ 4c73705e-230c-11eb-3c90-b14536d78808
md"""
Hysteretic behaviour like this is found in many scientific and engineering contexts,  including switches in biology, for example genetic switches, and in the historical dynamics of the earth's climate.
"""

# ╔═╡ 2ced9e26-22d0-11eb-34a5-bf80822f5c43
md"""
## Slow--fast systems
"""

# ╔═╡ 3213d406-22d0-11eb-0e89-71b42ea5cada
md"""
What are we actually doing when we let the parameter $\mu$ vary? Effectively we now have a system with *two* equations, for example

$$\dot{x} = \mu + x - x^3;$$
$$\dot{\mu} = \epsilon,$$

where $\mu$ varies at some slow speed $\epsilon$. On a time scale much shorter than $1 / \epsilon$, the dynamics of $x$ "does not know" that $\mu$ is changing, so it will converge to a fixed point $x^*(\mu)$ for the current value of $\mu$. [An associated term is **adiabatic approximation**.] However, $\mu$ does gradually change, so the value of $x$ will effectively "slide along" the curve $x(t) \simeq x^*(\mu(t))$, tracking the curve of fixed points as $\mu$ changes.

Once $\mu$ reaches a critical value $\mu_c$, however, there is no longer a nearby fixed point, and the dynamics will rapidly transition to the far away alternative fixed point.

If we now reverse the dynamics of $\mu$, we slide back along the upper branch.
"""

# ╔═╡ d0918f0c-22d4-11eb-383a-553e33114c52
md"""
## Function library
"""

# ╔═╡ 319c2ba8-220e-11eb-1ee0-4dd51ff4cd25
euler_step(f, x, h) = x + h * f(x)

# ╔═╡ 42de6dd6-220e-11eb-2a48-a3c69b10a03b
function euler(f, x0, h, t_final)
	ts = [0.0]
	xs = [x0]
	
	x = x0
	t = 0.0
	
	while t < t_final
		x = euler_step(f, x, h)
		t += h
		
		push!(xs, x)
		push!(ts, t)
	end
	
	return (ts=ts, xs=xs)  # a named tuple
end

# ╔═╡ 6e90ea26-220e-11eb-0c65-bf52b3d2e195
results = euler(logistic, 0.5, 0.01, 20.0)

# ╔═╡ 96e22792-220e-11eb-2729-63964507b5f2
begin
	plot(results.ts, results.xs, size=(400, 300), leg=false, xlabel=L"t", ylabel=L"x(t)", lw=3)
	scatter!([(results.ts[1], results.xs[1])])
	ylims!(0.4, 1.1)
end

# ╔═╡ 2300b29a-22d5-11eb-3c99-bdec0e5a2685
let
	p = plot(xlabel=L"t", ylabel=L"x(t)", size = (400, 300), leg=false, ylim=(-1, 2))

	results = euler(logistic, x0, 0.01, 10.0)	
		
	plot!(results.ts, results.xs, alpha=1, lw=3)
	scatter!([0], [x0])
	
	hline!([0], ls=:dash)
	p
end
	

# ╔═╡ f1d7fd8e-220e-11eb-0d2a-cf9e829c2bb5
let
	p = plot(xlabel=L"t", ylabel=L"x(t)", size = (400, 300), leg=false, ylim=(-1, 2))

	for x0 in -0.5:0.1:2.0
		results = euler(logistic, x0, 0.01, 10.0)	
		
		plot!(results.ts, results.xs, alpha=0.5, lw=2)
	end
	
	p
end

# ╔═╡ 546168ce-2218-11eb-198b-1da9f8a9a242
derivative(f, x, h=0.001) = ( f(x + h) - f(x - h) ) / (2h)

# ╔═╡ 46f1e3a2-2217-11eb-184f-f5649b892004
"Draw 1D vector field using centred arrows"
function horiz_vector_field(f)
	
	xlo, xhi = -2, 2.5
	arrow_size = 0.07
	tol=1e-5  # tolerance to check for fixed point
	
	p = plot(size=(400, 100), xlim=(xlo, xhi), ylim=(-0.5, 0.5), leg=false, yticks=[])
	
	for x in xlo:0.2:xhi
		d = f(x)  # derivative
		
		if d > tol
			plot!([x-arrow_size, x+arrow_size], [0, 0], arrow=true, c=:blue, alpha=0.5, lw=2)
			
		elseif d < -tol
			plot!([x+arrow_size, x-arrow_size], [0, 0], arrow=true, c=:red, alpha=0.5, lw=2)
			
		end
		
		
	end
	
	roots = find_zeros(f, -10, 10)
	
	for root in roots
		stability = sign(derivative(f, root))  

		if stability > 0
			scatter!([root], [0], c=:green, alpha=0.5, m=:square, ms=5)  # unstable
		else
			scatter!([root], [0], c=:black, alpha=0.5, ms=6)  # stable
		end

	end			

	p
end

# ╔═╡ 2b1b49b0-2247-11eb-1d25-57f3b4f46d04
"Draw vertical vector field of 1D ODE"
function vector_field!(p, μ, f)

	xlo, xhi = -2, 2
	arrow_size = 0.07
	tol=1e-5  # tolerance to check for fixed point

	for x in xlo:0.2:xhi
		d = f(x)  # derivative

		if d > tol
			
			plot!([μ, μ], [x-arrow_size, x+arrow_size], arrow=(3.0, 2.0), arrowstyle=:triangle, c=:blue, alpha=0.4, lw=2)

		elseif d < -tol
			plot!([μ, μ], [x+arrow_size, x-arrow_size], arrow=true, c=:red, alpha=0.4, lw=2)
		end

	end

	roots = find_zeros(f, -10, 10)

	for root in roots
		stability = sign(derivative(f, root))  

		if stability > 0
			scatter!([μ], [root], c=:green, alpha=0.5, m=:square, ms=4)  # unstable
		else
			scatter!([μ], [root], c=:black, alpha=0.5, ms=5)  # stable
		end

	end

	p
end

# ╔═╡ d4fa7bec-2371-11eb-3e9f-69d552546331
function vector_field(f)
	p = plot(leg=false, xticks=[], size=(100, 300), xrange=(-1, 1))
	vector_field!(p, 0, f)
end

# ╔═╡ 9a833edc-2217-11eb-0701-99862b410bfa
vector_field(logistic)

# ╔═╡ 25578fa6-2248-11eb-2838-57fbfb928fc4
vector_field(x -> g(λ, x))

# ╔═╡ e55d2780-2247-11eb-01e0-fbdc94bba264
function bifurcation_diagram(h)
	p = plot(leg=false, ratio=1)
	
	for μ in -2:0.15:2
		vector_field!(p, μ, x -> h(μ, x))
	end
	
	xlabel!("μ")
	ylabel!("fixed points and dynamics with given μ")
	
	return p
end

# ╔═╡ b9ee4db4-22d7-11eb-38ef-511e30df16cc
bifurcation_diagram(g)

# ╔═╡ f040d1c4-2247-11eb-0bf0-090e90a86a85
bifurcation_diagram(h)

# ╔═╡ e27dace4-2248-11eb-2ae1-953639d8c944
function fixed_points(f)
	p = plot(leg=false, ratio=1)
	
	for μ in -2:0.01:2
		
		roots = find_zeros(x -> f(μ, x), -10, 10)
		
		for root in roots
			stability = sign(derivative(x -> f(μ, x), root))  

			if stability > 0
				scatter!([μ], [root], c=:green, alpha=0.5, m=:square)  # unstable
			else
				scatter!([μ], [root], c=:black, alpha=0.5)  # stable
			end
		end

	end
	
	xlabel!(L"\mu")
	ylabel!(L"x^*(\mu)")
	
	
	return p
end

# ╔═╡ 0c3c88fe-2249-11eb-03af-bf9c393fadd4
fixed_points(h)

# ╔═╡ Cell order:
# ╠═88b46d2e-220e-11eb-0f7f-b3f523f0214e
# ╟─6f554dc0-220c-11eb-341f-1b66de841c86
# ╟─816de40c-220c-11eb-2d3a-23e6267cd529
# ╟─d21f6358-220c-11eb-00b8-03fe0746fdc9
# ╟─735bb47e-220d-11eb-1ba6-8d591a935857
# ╟─79b148b6-220d-11eb-2785-25d05068aeed
# ╟─d43a869e-220d-11eb-009c-a119de57e7da
# ╟─088eabb2-220e-11eb-1ac0-df419b87f39a
# ╟─a44cc180-22d4-11eb-2129-211d024c4921
# ╠═6aa1d2f4-220e-11eb-06e0-c346f74aa018
# ╟─b6d0dd18-22d4-11eb-2083-0b02de030579
# ╠═6e90ea26-220e-11eb-0c65-bf52b3d2e195
# ╟─f055be76-22d4-11eb-268a-bf70c7d8f1a1
# ╟─96e22792-220e-11eb-2729-63964507b5f2
# ╟─90ccb392-2216-11eb-1fd8-83b7d7c16b54
# ╟─bef9c2e4-220e-11eb-24d8-bd618d2985ea
# ╠═17317eb8-22d5-11eb-0f46-2bf1bddd36bb
# ╟─2300b29a-22d5-11eb-3c99-bdec0e5a2685
# ╟─ae862e10-22d5-11eb-3d75-1d748cf86944
# ╟─f1d7fd8e-220e-11eb-0d2a-cf9e829c2bb5
# ╟─446c564e-220f-11eb-191a-6b419e790f3f
# ╟─38894c32-2210-11eb-26ff-d9796edd7871
# ╟─a196a20a-2216-11eb-11f9-6789bb2a3ece
# ╟─c15a53e8-2216-11eb-1460-8510aea0f570
# ╠═9a833edc-2217-11eb-0701-99862b410bfa
# ╟─42c28b16-2218-11eb-304a-e534353fa12b
# ╟─e6ed3366-2246-11eb-3a86-f375162c746d
# ╟─ec3c5d9c-2246-11eb-1ec5-e3d9c8a7fa23
# ╠═3fa21738-2247-11eb-09d5-4dcf0e7377fc
# ╠═19eb987e-2248-11eb-2982-1930b5840aed
# ╠═25578fa6-2248-11eb-2838-57fbfb928fc4
# ╟─49ec803a-22d7-11eb-3f04-db8f8c119a7d
# ╠═b9ee4db4-22d7-11eb-38ef-511e30df16cc
# ╟─27190ac0-230b-11eb-3367-af2bbbf57e5e
# ╟─48ef665e-22d0-11eb-2c72-b722fafd296e
# ╟─51eeb46c-22d0-11eb-1643-c92e725d9da0
# ╠═44c1738a-2247-11eb-3232-f30b46fd7ce6
# ╠═f040d1c4-2247-11eb-0bf0-090e90a86a85
# ╟─a56ad0bc-22d7-11eb-0418-d36f3ef14109
# ╟─5b9c66ce-224b-11eb-02a4-b9a5a173ee6a
# ╠═0c3c88fe-2249-11eb-03af-bf9c393fadd4
# ╟─aa81663c-230b-11eb-3c0e-39759f36deb6
# ╟─55d4d188-2249-11eb-0c47-dfddce9b2027
# ╟─5ac33518-2249-11eb-2d57-7de185d43e5f
# ╟─4c73705e-230c-11eb-3c90-b14536d78808
# ╟─2ced9e26-22d0-11eb-34a5-bf80822f5c43
# ╟─3213d406-22d0-11eb-0e89-71b42ea5cada
# ╟─d0918f0c-22d4-11eb-383a-553e33114c52
# ╟─319c2ba8-220e-11eb-1ee0-4dd51ff4cd25
# ╟─42de6dd6-220e-11eb-2a48-a3c69b10a03b
# ╟─546168ce-2218-11eb-198b-1da9f8a9a242
# ╟─46f1e3a2-2217-11eb-184f-f5649b892004
# ╟─2b1b49b0-2247-11eb-1d25-57f3b4f46d04
# ╟─d4fa7bec-2371-11eb-3e9f-69d552546331
# ╟─e55d2780-2247-11eb-01e0-fbdc94bba264
# ╟─e27dace4-2248-11eb-2ae1-953639d8c944
