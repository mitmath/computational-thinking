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

# ╔═╡ 1f65fc80-a83b-11eb-2583-89bff1ea8372
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
"><em>Section 3.3</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Why we can't predict the weather </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/M3udLzIHtsc" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 88b46d2e-220e-11eb-0f7f-b3f523f0214e
begin
    import Pkg
    Pkg.activate(mktempdir())
	
    Pkg.add([
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="LaTeXStrings", version="1"),
        Pkg.PackageSpec(name="Roots", version="1"),
		Pkg.PackageSpec(name="DifferentialEquations", version="6"),
    ])
	
    using Plots, PlutoUI, LaTeXStrings, Roots, DifferentialEquations
	using LinearAlgebra
end

# ╔═╡ f9dbf2e8-574d-4846-af48-f7e5a82a1afc
TableOfContents(aside=true)

# ╔═╡ a2b2eae2-762e-41c3-a546-0caedc79db7d
md"""
# Why we can predict the climate but can't predict the weather
"""

# ╔═╡ 91b34e59-e4d2-45b7-9e2b-1b95748e5d6a
md"""
## Weather vs. climate
"""

# ╔═╡ 22bddfca-fd1c-4dc7-85f3-f864c3b53407
md"""
Will it rain tomorrow? We should be able to predict that using observations about the current state of the atmosphere and mathematical models in the form of partial differential equations that predict how the wind will move the air around, what the temperature will be, and how much water can precipitate out.

What about predicting rain next week? Next year?

We know from experience that we can only predict the weather in the short term, up to a week or so (and still only with a certain probability). Predicting even one month out doesn't seem possible.

On the other hand, we can talk about the *climate* and how it behaves on much longer time scales, e.g. "the average temperature in in Boston in April is 55°F". The short-term weather has a significant random (or apparently random) component, but becomes much more predictable when we look at statistical properties like averages and standard deviations; this is then called **climate**.
"""

# ╔═╡ 6f554dc0-220c-11eb-341f-1b66de841c86
md"""
# Nonlinear dynamics: stability and bifurcations
"""

# ╔═╡ 2c6f4b31-2f08-4e24-8e31-ad80d2700fa8
md"""
In this notebook we will see that the simplest possible model of the weather, a set of 3 coupled, nonlinear ODEs known as the **Lorenz equations**, can have unpredictable behaviour, known as 
**(deterministic) chaos**. We will build up to that by looking at two simpler models of dynamics, in 1D and 2D.
"""

# ╔═╡ 822c015a-8bb3-4432-a2d4-2e2ba4f906a6
md"""
## Reminder: Ordinary Differential Equations (ODEs)
"""

# ╔═╡ 816de40c-220c-11eb-2d3a-23e6267cd529
md"""
Recall that we are looking at **differential equations**, with the goal of modelling the evolution in time of the climate.

The simplest such models are **ordinary differential equations** (ODEs), where one or a few continuous variables evolve continuously in time, with a model that specifies their instantaneous rate of change as a function of their current values.

The general form of an ODE (that does not depend explicitly on time, i.e. that is **autonomous**), is

$$\frac{dx(t)}{dt} = f(x(t)),$$

or

$$\dot{x}(t) = f(x(t)),$$

with an initial condition $x(t=0) = x_0$.

Here $\dot{x}(t)$ denotes the derivative of the function $t \mapsto x(t)$ at time $t$.
"""

# ╔═╡ d21f6358-220c-11eb-00b8-03fe0746fdc9
md"""
We have seen that the simplest numerical method to solve such an equation is the **(forward) Euler method**, in which we convert this equation into an explicit time-stepping routine: we take a small time step of length $h$ and approximate the derivative as

$$\frac{dx(t)}{dt} \simeq \frac{x(t + h) - x(t)}{h},$$

giving the numerical method

$$x_{n+1} = x_{n} + h f(x_n),$$

where $x_n$ is the approximation of the true solution $x(t_n)$ at the $n$th time step $t_n$.

"""



# ╔═╡ 735bb47e-220d-11eb-1ba6-8d591a935857
md"""
# 1D: Modelling bacterial growth
"""

# ╔═╡ 79b148b6-220d-11eb-2785-25d05068aeed
md"""
Let's use this to simulate a simple nonlinear ODE describing the dynamics of a population of bacteria. The bacteria reproduce at a rate $\lambda$ *provided* that there is sufficient food, in which case we would have $\dot{x} = \lambda x$. But the need for enough food will put a *limit* on the sustainable population to a value $K$, sometimes called the **carrying capacity**. 

The simplest model for the combined effect of growth and saturation is as follows:

$$\dot{x} = \lambda \, x \, (K - x).$$

When $x$ is close to $0$, the growth rate is $\lambda$, but that rate decreases as $x$ increases.

(This is sometimes called the [**logistic**](https://en.wikipedia.org/wiki/Logistic_function#Logistic_differential_equation) differential equation, although that name does not seem particularly helpful.)
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
It's useful to rescale the variables to the simplest form:

$$\dot{x} = x \, (1 - x).$$

[We can do so by defining new adimensional space and time variables $x'$ and $t'$ as follows: $x = K \, x'$, giving $K \dot{x'} = \lambda K \, x' (K - K x')$, and then $t' = \lambda K \, t$, giving $dx' / dt' = x' (1 - x')$.]
"""

# ╔═╡ 57566646-1b4c-4098-abf7-eb242d01ca81
md"""
We define a function representing the right-hand side of the ODE:
"""

# ╔═╡ 6aa1d2f4-220e-11eb-06e0-c346f74aa018
logistic(x) = x * (1 - x)

# ╔═╡ b6d0dd18-22d4-11eb-2083-0b02de030579
md"""
Let's simulate this with the Euler method and plot the trajectory $x(t)$ as a function of time $t$:
"""

# ╔═╡ 6e90ea26-220e-11eb-0c65-bf52b3d2e195
results = euler(logistic, 0.5, 0.01, 20.0)

# ╔═╡ 2d1c6abf-3b15-4638-88c5-89b5d0585c98
md"""
Normally we would *not* choose the Euler method to calculate actual trajectories, but it is enough for our purposes of understanding the *qualitative* behaviour of the equations.
"""

# ╔═╡ f055be76-22d4-11eb-268a-bf70c7d8f1a1
md"""
We see that for this particular initial condition, the solution seems to settle down to a fixed value after some time, and then remains at that value thereafter.

Such a value is called a **fixed point**, a **stationary point**, or a **steady state** of the ODE.
"""

# ╔═╡ 96e22792-220e-11eb-2729-63964507b5f2
begin
	plot(results.ts, results.xs, size=(400, 300), leg=false, xlabel=L"t", ylabel=L"x(t)", lw=3)
	scatter!([(results.ts[1], results.xs[1])])
	ylims!(0.4, 1.1)
end

# ╔═╡ 90ccb392-2216-11eb-1fd8-83b7d7c16b54
md"""
## Qualitative behaviour: Fixed points and their stability
"""

# ╔═╡ 0bf302de-4a0f-4341-b010-d3606e237acc
# gr(fmt=:png, dpi=150, size=(300, 200))
# gr(fmt=:svg)

gr(fmt=:png, dpi=300, size=(400, 300))


# ╔═╡ bef9c2e4-220e-11eb-24d8-bd618d2985ea
md"""
 Let's see what happens for other initial conditions:
"""

# ╔═╡ 17317eb8-22d5-11eb-0f46-2bf1bddd36bb
md"""
x₀ = $(@bind x0 Slider(-0.9:0.001:3.0, default=0.5, show_value=true))
"""

# ╔═╡ 2300b29a-22d5-11eb-3c99-bdec0e5a2685
let
	p = plot(xlabel=L"t", ylabel=L"x(t)",  leg=false, ylim=(-1, 2))

	results = euler(logistic, x0, 0.01, 5.0)	
		
	plot!(results.ts, results.xs, alpha=1, lw=3)
	scatter!([0.0], [x0])
	
	hline!([0.0], ls=:dash)
	# as_svg(p)
end
	

# ╔═╡ ae862e10-22d5-11eb-3d75-1d748cf86944
md"""
To get an overview of the behaviour we can draw all the results on a single graph:
"""

# ╔═╡ c5bf15b1-a540-478b-acec-1aa47aad13d1
let
	p = plot(xlabel=L"t", ylabel=L"x(t)", leg=false, ylim=(-1, 2))

	# for x0 in -0.5:0.05:2.0
#for x0 in 0.0:0.1:2.0
	for x0 in -0.5:0.1:2.0
	results = euler(logistic, x0, 0.05, 5.0)	
	
# 	for x0 in -0.5:0.05:2.0
# 		results = euler(logistic, x0, 0.01, 10.0)	
		
		plot!(p, results.ts, results.xs, alpha=0.8, lw=1, arrow=true)
	end

	
	md"""
	#### Trajectories for $ẋ = x(1-x)$ 
	
	$p

	"""
end

# ╔═╡ 446c564e-220f-11eb-191a-6b419e790f3f
md"""
We see that all the curves starting near to $x_0=1.0$ seem to converge to 1 at long times. If the system starts *exactly* at 0 then it stays there forever. However, if it starts close to 0, on either side, then it moves *away* from 0 (on that same side of 0) -- starting from a negative value $x$ becomes ever more negative. (Even though negative populations have no meaning in the original interpretation as the dynamics of a population, we can still ask study the dynamics of the equation with negative initial conditions, since it may model other systems too.)

The special values $x^*_1=1$ and $x^*_2=0$ are called **stationary points** or **fixed points** of the differential equation. If we start at $x^*_i$, then the derivative there is $f'(x^*_i) = 0$, and hence we cannot move away from $x^*_i$! The fixed points can be found as zeros or **roots** of the function $f$, i.e. values $x^*$ such that $f(x^*) = 0$.
"""

# ╔═╡ 38894c32-2210-11eb-26ff-d9796edd7871
md"""
We see, though, that the two types of fixed points are **qualitatively different**: trajectories that start close to $x^*_1 = 1$ move *towards* $x^*_1$, whereas trajectories that start close to $x^*_2 = 0$ move *away* from it. We say that $x^*_1$ is a **stable fixed point** and $x^*_2$ is an **unstable fixed point**.

In general it is not possible to find analytical formulas for the position and stability of fixed points; instead, we can use numerical **root-finding algorithms**, for example the Newton method. There are various Julia packages with implementations of these algorithms; we will use `Roots.jl`, which works well for scalar-valued functions.
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

# ╔═╡ 9a833edc-2217-11eb-0701-99862b410bfa
vector_field(logistic)

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
md"""
μ = $(@bind λ Slider(-1.0:0.05:1, show_value=true))
"""

# ╔═╡ 25578fa6-2248-11eb-2838-57fbfb928fc4
begin
	vector_field(x -> g(λ, x))
end

# ╔═╡ 49ec803a-22d7-11eb-3f04-db8f8c119a7d
md"""
Now let's collect all the vector fields into a single plot. The horizontal axis now represents the different possible values of the parameter $\mu$:
"""

# ╔═╡ b9ee4db4-22d7-11eb-38ef-511e30df16cc
bifurcation_diagram(g)

# ╔═╡ 27190ac0-230b-11eb-3367-af2bbbf57e5e
md"""
We see that at the **critical value** $\mu_c = 0$ there is a **qualitative change in behaviour** of the system: for $\mu_c < 0$ there are two fixed points, whereas for $\mu_c > 0$ there are no fixed points at all. Such a qualitative change is called a **bifurcation**. In this particular case the two fixed points collide in a **saddle--node** or **fold** bifurcation.
"""

# ╔═╡ 48ef665e-22d0-11eb-2c72-b722fafd296e
md"""
# 1D: Bistability and hysteresis
"""

# ╔═╡ 51eeb46c-22d0-11eb-1643-c92e725d9da0
md"""
Now let's look at the dynamics of the following system:

$$\dot{x} = \mu + x - x^3.$$
"""

# ╔═╡ 44c1738a-2247-11eb-3232-f30b46fd7ce6
h(μ, x) = μ + x - x^3

# ╔═╡ 7a94642e-39d8-480d-9516-d11e6c1b078b
md"""
Let's plot the bifurcation diagram again:
"""

# ╔═╡ f040d1c4-2247-11eb-0bf0-090e90a86a85
bifurcation_diagram(h)

# ╔═╡ a56ad0bc-22d7-11eb-0418-d36f3ef14109
md"""
We see that there is a range of values of $\mu$ for which there are *three coexisting fixed points*, two stable and one unstable. Since there are two stable fixed points in which the system can remain, we say that the system is **bistable**.
"""

# ╔═╡ 5b9c66ce-224b-11eb-02a4-b9a5a173ee6a
md"""
Now that we understand what the plots mean and the dynamics, let's plot just the fixed points $x^*(\mu)$ as a function of $\mu$. Such a plot is called a **bifurcation diagram**:
"""

# ╔═╡ 0c3c88fe-2249-11eb-03af-bf9c393fadd4
fixed_points(h)

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
Suppose we now think about slowly varying the parameter $\mu$. If we change the parameter $\mu$ by a little, the system is no longer at a fixed point, since the position of the fixed point moves when $\mu$ changes. However, the system will then **relax**: it will follow the dynamics at the new value of $\mu$, and will rapidly converge to the new fixed point nearby for that new value of $\mu$.

For example, starting at $\mu=-2$, the system will stay on the lower black (stable) **branch** until $\mu=0.4$ or so. At that point, two fixed points collide and annihilate each other! After that there is no longer a fixed point nearby. However, there is another fixed point much further up that will now attract all trajectories, so the system rapidly transitions to that fixed point.

Now suppose we decrease the parameter again. The system will now track the *upper* branch until $\mu=-0.4$ or so, when again it will jump back down.

For each parameter value $\mu$ in the interval $[-0.4, 0.4]$ there is **bistability**, i.e. **coexistence** of *two* fixed points with the same value of $\mu$ (together with a third, unstable fixed point that is not observable).

The fact that the system tracks different stable branches depending on where we started, i.e. on the history of the dynamics, is known as **hysteresis**.
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
What are we actually doing when we let the parameter $\mu$ vary? Effectively we now have a system of *two* coupled ODEs, for example

$$\dot{x} = \mu + x - x^3;$$
$$\dot{\mu} = \epsilon,$$

where $\mu$ varies at a slow speed $\epsilon$. On a time scale much shorter than $1 / \epsilon$, the dynamics of $x$ "does not know" that $\mu$ is changing, so it will converge to a fixed point $x^*(\mu)$ for the current value of $\mu$. [An associated term is **adiabatic approximation**.] However, in fact $\mu$ does gradually change, so the value of $x$ will effectively "slide along" the curve $x(t) \simeq x^*(\mu(t))$, tracking the curve of fixed points as $\mu$ changes.

Once $\mu$ reaches a critical value $\mu_c$, however, there is no longer a nearby fixed point to move to, and the vector field will move the system to rapidly transition to the far away alternative fixed point.

If we now reverse the dynamics of $\mu$, we slide back along the upper branch.
"""

# ╔═╡ bcce1286-2213-4f25-a947-7a429bd96594
md"""
# 2D: Oscillations in chemical reactions -- the Brusselator model
"""

# ╔═╡ 77ae220e-08bd-4808-b1f5-f80397afe9bc
md"""
Bifurcations are not restricted to 1D systems; indeed, the dynamics can be much richer in higher dimensions. 

For example, let's look at the [Brusselator model](https://en.wikipedia.org/wiki/Brusselator). This models a chemical reaction that **oscillates**, known as a [chemical clock](https://en.wikipedia.org/wiki/Chemical_clock):
"""

# ╔═╡ c48b8097-d81e-43a1-a61f-b2d01edbc8d5
md"""
$$\begin{aligned}
\dot{x} &= a + x^2 y - bx - x \\
\dot{y} &= b x - x^2 y
\end{aligned}$$
"""

# ╔═╡ 6b857cb0-182f-4451-9f5a-e170dae185c1
function brusselator(xx, p, t)
	x, y = xx
	a, b = p
	
	return [a + x^2 * y - b*x - x, 
			b * x - x^2 * y]
end

# ╔═╡ e2953d11-6880-45cb-8000-3f6903a85c7d
begin
	u0 = [1, 1]
	tspan = (0.0, 50.0)
	params = [a, b]
end

# ╔═╡ cbb9e351-b496-45cc-8816-519ada1dc5d5
begin
	prob = ODEProblem(brusselator, u0, tspan, params)
	soln = solve(prob)
end;

# ╔═╡ 77e5ff47-1e95-4552-a3d2-2fdf7bbea7cb
md"""
a = $(@bind a Slider(0.0:0.1:5.0, show_value=true, default=1.0))

b = $(@bind b Slider(0.0:0.1:5.0, show_value=true, default=1.5))
"""

# ╔═╡ 92aca04d-376f-4ac7-b4c3-5b0652974157
gr(dpi=300)

# ╔═╡ 34556546-0cab-43e2-bc2c-f7487288392c
let
	tspan = (0.0, 10.0)
	params = [a, b]
	
	p1 = plot(leg=false, background_color_inside=:black)

	for x in 0:1.0:5
		for y in 0:1.0:5
			u0 = [x, y]
			
			prob = ODEProblem(brusselator, u0, tspan, params)
			soln = solve(prob)

	
			plot!(p1, soln, vars=(1, 2), xlims=(0, 5), ylims=(0, 5), ratio=1, lw=1.5)
#	p2 = plot(soln)
	
#	plot(p1, p2, ylims=(0, 5))
		end
	end
	
	# plot direction field:
	xs = Float64[]
	ys = Float64[]
	
	for x in 0:0.1:5
		for y in 0:0.1:5
			v = brusselator([x, y], params, 0)
			v ./= (norm(v) * 30)
			# plot!([x, x + v[1]], [y, y + v[2]], alpha=0.5, c=:gray)
			
			push!(xs, x - v[1], x + v[1], NaN)
			push!(ys, y - v[2], y + v[2], NaN)
		
		end
	end
	
	plot!(xs, ys, alpha=0.7, c=:gray)
	
	# as_svg(p1)
	
	md"""
	#### Trajectories in state space for the Brusselator model
	
	$(p1)
	
	"""
	
	
end

# ╔═╡ c90e3885-33bd-40d2-8a64-946fd7676656
md"""
We see that there is a critical value of $b$ above which the fixed point becomes unstable and gives rise to an attracting periodic orbit. This is a [**Hopf bifurcation**](https://en.wikipedia.org/wiki/Hopf_bifurcation).
"""

# ╔═╡ e01fa79b-e92b-4b77-8234-108839ed2598
md"""
# 3D: Chaos in the Lorenz equations
"""

# ╔═╡ 1d91975b-2644-41da-a2a4-667ae6ed5ca1
md"""
The [Lorenz equations](https://en.wikipedia.org/wiki/Lorenz_system) form a (very) simplified model of convection in a layer of fluid representing the atmosphere, first investigated in a famous paper by Edward Lorenz, published in 1963, about work done at MIT.  They represent a pioneering numerical investigation of **chaotic behaviour**.

The Lorenz equations are a set of three coupled ODEs. They have an apparently simple form, with only two nonlinear terms:
"""

# ╔═╡ d99002e1-02ca-45bd-ba26-581f7f1b4fe8
md"""
$$\begin{align}
\dot{x} &= \sigma (y - x) \\[6pt]
\dot{y} &= x (\rho - z) - y \\[6pt]
\dot{z} &= x y - \beta z
\end{align}$$
"""

# ╔═╡ 64642233-3331-40ea-929b-be5daa933393
md"""
Nonetheless, we will see that they can exhibit remarkably complex behaviour. Indeed, most nonlinear ODEs with at least three variables can be expected to exhibit similarly complicated behaviour.
"""

# ╔═╡ 2228c7f6-8692-487e-bf8a-6600e7e93a06
md"""
Let's solve the system using `DifferentialEquations.jl`. We will take the classical parameter values $\sigma = 10$ and $\beta = 8/3$, but we will allow $\rho$ to vary; its classical value is $28$.
"""

# ╔═╡ cfa7b192-f1a0-4cd1-ae34-cec07e7b47f6
function lorenz(u, p, t)
	x, y, z = u
	σ, ρ, β = p
	
	dx = σ * (y - x)
	dy = x * (ρ - z) - y
	dz = x * y - β * z
	
	return [dx, dy, dz]
end 

# ╔═╡ 2e61c129-7fd8-46b6-8480-40f0244aab47
begin
	lorenz_prob = ODEProblem(lorenz, [0.01, 0.01, 0.01], (0.0, 100.0), lorenz_params)
	
	lorenz_soln = solve(lorenz_prob)
end;

# ╔═╡ 58dbd153-09e2-4a38-94c1-9f69acf515ae
lorenz_params = (σ = 10.0, ρ = ρ, β = 8/3)

# ╔═╡ e068c809-34c6-4723-8ad5-a55918cfed87
md"""
ρ = $(@bind ρ Slider(0.0:0.1:100.0, show_value=true, default=10.0))
"""

# ╔═╡ 5ffeba9b-8487-4be1-bb64-8d2330824ee5
plot(lorenz_soln, vars=(1, 2, 3), xlabel="x", ylabel="y", zlabel="z", xlims=(-25, 25), ylims=(-25, 25), zlims=(0, 60))

# ╔═╡ a7f067e4-d088-400b-bba4-d58f9cfb87a8
md"""
As $\rho$ increases we see a sequence of bifurcations. Above a critical value, trajectories converge to a fractal **strange attractor**, on which the dynamics is **chaotic**.
"""

# ╔═╡ cc7ee950-6b86-4d43-8524-86254978bd1b
md"""
Deterministic chaos occurs when nearby initial conditions separate exponentially fast in state space. This has been given the name **butterly effect**: the perturbation to the atmosphere's state caused by a butterfly flapping its wings could end up being magnified to modify the direction in which a tornado moves. 

We can see this in a simple way by perturbing the initial condition slightly and calculating the distance between the two systems as a function of $t$:
"""

# ╔═╡ aebdd083-4f70-4490-9949-8fe5c1cb2e1e
begin
	ϵ = 1e-10
	
	lorenz_prob2 = ODEProblem(lorenz, [0.01 + ϵ, 0.01 + ϵ, 0.01 + ϵ], (0.0, 50.0), lorenz_params)
		
	lorenz_soln2 = solve(lorenz_prob2)
end;

# ╔═╡ f44c9f92-aacd-4556-b494-8ee874387e5d
begin
	ts = 0:0.01:50
	distances = [norm(lorenz_soln2(t) - lorenz_soln(t)) for t in ts]
end

# ╔═╡ c2615e16-93d1-4db0-af18-0c1a758cd58a
plot(ts, distances, yscale=:log10, label="distance", xlabel="t", leg=:topleft)

# ╔═╡ 0b1b4e0e-d146-4c94-bfee-3d0a50323d0b
md"""
We indeed see a significant window over which the distance grows exponentially (straight line on the semi-logarithmic graph) for large enough values of $\rho$, before it saturates at a value of the order of the diameter of the attractor.

The rate of the exponential growth is known as the **Lyapunov exponent**; there are better ways to measure it more accurately.
"""

# ╔═╡ b8423240-1761-490d-a856-f722714cc763
md"""
Since the Lorenz equations model the atmosphere, we could expect that the dynamics of the atmosphere is at least as complicated.
"""

# ╔═╡ 8eb1c83e-18f2-497a-94fd-a4abe11beed3
md"""
We can also plot the $x$ coordinate of each trajectory for comparison:
"""

# ╔═╡ 3188c2ca-ab8f-45a9-bcbc-10159659a9d4
begin
	plot(lorenz_soln, vars=1, label="original", size=(500, 300), leg=:topleft)
	plot!(lorenz_soln2, vars=1, label="perturbed")
	ylabel!("x(t)")
end

# ╔═╡ 75f3d63d-aa5d-46ce-824c-72153623d2c5
md"""
At long enough times the trajectories separate and behave very differently.
"""

# ╔═╡ 019be011-51ed-4997-8e8e-1035c109efe7
md"""
Now let's look at the "climate" in this model, namely the average value of each coordinate over a long time:
"""

# ╔═╡ edd470f6-828e-47f4-b2d1-cb16f6103158
mean(v) = sum(v) / length(v)

# ╔═╡ 5c27ade2-5983-4332-9097-20efb20504bc
begin
	T = 1000.0
	
	lorenz_prob3 = ODEProblem(lorenz, [1 + ϵ, 1 + ϵ, 1 + ϵ], (0.0, T), lorenz_params)
			
	lorenz_soln3 = solve(lorenz_prob3)
	
	lorenz_prob4 = ODEProblem(lorenz, [1, 1, 1], (0.0, T), lorenz_params)
			
	lorenz_soln4 = solve(lorenz_prob4)
end;

# ╔═╡ 043c35e5-bf4b-445a-b746-9030b96033ca
mean(abs.(lorenz_soln3(t)) for t in T/2:T)

# ╔═╡ d9b34169-85a2-4f97-a7e3-a2ed67ee205a
mean(abs.(lorenz_soln4(t)) for t in T/2:T)

# ╔═╡ 02f295ba-6bb1-41ca-9581-af33766241a4
md"""
We see that the average mean value of each component is approximately the same, even though the individual trajectories are wildly different. This is an example of how statistical properties can be the same, even if individual behaviour is very different, and motivates the idea that climate -- i.e. "average weather" -- can be stable, even if day-to-day variations differ a lot.
"""

# ╔═╡ d0918f0c-22d4-11eb-383a-553e33114c52
md"""
# Function library
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
			plot!([x-arrow_size, x+arrow_size], [0, 0], arrow=true, c=:blue, alpha=0.5, lw=1.5)
			
		elseif d < -tol
			plot!([x+arrow_size, x-arrow_size], [0, 0], arrow=true, c=:red, alpha=0.5, lw=1.5)
			
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
"Draw vertical vector field of 1D ODE on plot p with parameter μ"
function vector_field!(p, μ, f)

	xlo, xhi = -2, 2
	arrow_size = 0.07
	tol=1e-5  # tolerance to check for fixed point

	for x in xlo:0.2:xhi
		d = f(x)  # derivative

		if d > tol
			
			plot!([μ, μ], [x-arrow_size, x+arrow_size], arrow=(3.0, 2.0), arrowstyle=:triangle, c=:blue, alpha=0.4, lw=1.5)

		elseif d < -tol
			plot!([μ, μ], [x+arrow_size, x-arrow_size], arrow=true, c=:red, alpha=0.4, lw=1.5)
		end

	end

	roots = find_zeros(f, -10, 10)

	for root in roots
		stability = sign(derivative(f, root))  

		if stability > 0
			scatter!([μ], [root], c=:green, alpha=0.5, m=:square, ms=2)  # unstable
		else
			scatter!([μ], [root], c=:black, alpha=0.5, ms=3)  # stable
		end

	end

	p
end

# ╔═╡ d4fa7bec-2371-11eb-3e9f-69d552546331
function vector_field(f)
	p = plot(leg=false, xticks=[], xrange=(-1, 1), size=(100, 200))
	vector_field!(p, 0, f)
end

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

# ╔═╡ Cell order:
# ╟─1f65fc80-a83b-11eb-2583-89bff1ea8372
# ╠═88b46d2e-220e-11eb-0f7f-b3f523f0214e
# ╠═f9dbf2e8-574d-4846-af48-f7e5a82a1afc
# ╟─a2b2eae2-762e-41c3-a546-0caedc79db7d
# ╟─91b34e59-e4d2-45b7-9e2b-1b95748e5d6a
# ╟─22bddfca-fd1c-4dc7-85f3-f864c3b53407
# ╟─6f554dc0-220c-11eb-341f-1b66de841c86
# ╟─2c6f4b31-2f08-4e24-8e31-ad80d2700fa8
# ╟─822c015a-8bb3-4432-a2d4-2e2ba4f906a6
# ╟─816de40c-220c-11eb-2d3a-23e6267cd529
# ╟─d21f6358-220c-11eb-00b8-03fe0746fdc9
# ╟─735bb47e-220d-11eb-1ba6-8d591a935857
# ╟─79b148b6-220d-11eb-2785-25d05068aeed
# ╟─d43a869e-220d-11eb-009c-a119de57e7da
# ╟─088eabb2-220e-11eb-1ac0-df419b87f39a
# ╟─a44cc180-22d4-11eb-2129-211d024c4921
# ╟─57566646-1b4c-4098-abf7-eb242d01ca81
# ╠═6aa1d2f4-220e-11eb-06e0-c346f74aa018
# ╟─b6d0dd18-22d4-11eb-2083-0b02de030579
# ╠═6e90ea26-220e-11eb-0c65-bf52b3d2e195
# ╟─2d1c6abf-3b15-4638-88c5-89b5d0585c98
# ╟─f055be76-22d4-11eb-268a-bf70c7d8f1a1
# ╟─96e22792-220e-11eb-2729-63964507b5f2
# ╟─90ccb392-2216-11eb-1fd8-83b7d7c16b54
# ╠═0bf302de-4a0f-4341-b010-d3606e237acc
# ╟─bef9c2e4-220e-11eb-24d8-bd618d2985ea
# ╟─17317eb8-22d5-11eb-0f46-2bf1bddd36bb
# ╟─2300b29a-22d5-11eb-3c99-bdec0e5a2685
# ╟─ae862e10-22d5-11eb-3d75-1d748cf86944
# ╟─c5bf15b1-a540-478b-acec-1aa47aad13d1
# ╟─446c564e-220f-11eb-191a-6b419e790f3f
# ╟─38894c32-2210-11eb-26ff-d9796edd7871
# ╟─a196a20a-2216-11eb-11f9-6789bb2a3ece
# ╟─c15a53e8-2216-11eb-1460-8510aea0f570
# ╠═9a833edc-2217-11eb-0701-99862b410bfa
# ╟─42c28b16-2218-11eb-304a-e534353fa12b
# ╟─e6ed3366-2246-11eb-3a86-f375162c746d
# ╟─ec3c5d9c-2246-11eb-1ec5-e3d9c8a7fa23
# ╠═3fa21738-2247-11eb-09d5-4dcf0e7377fc
# ╟─19eb987e-2248-11eb-2982-1930b5840aed
# ╠═25578fa6-2248-11eb-2838-57fbfb928fc4
# ╟─49ec803a-22d7-11eb-3f04-db8f8c119a7d
# ╠═b9ee4db4-22d7-11eb-38ef-511e30df16cc
# ╟─27190ac0-230b-11eb-3367-af2bbbf57e5e
# ╟─48ef665e-22d0-11eb-2c72-b722fafd296e
# ╟─51eeb46c-22d0-11eb-1643-c92e725d9da0
# ╠═44c1738a-2247-11eb-3232-f30b46fd7ce6
# ╟─7a94642e-39d8-480d-9516-d11e6c1b078b
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
# ╟─bcce1286-2213-4f25-a947-7a429bd96594
# ╟─77ae220e-08bd-4808-b1f5-f80397afe9bc
# ╟─c48b8097-d81e-43a1-a61f-b2d01edbc8d5
# ╠═6b857cb0-182f-4451-9f5a-e170dae185c1
# ╠═e2953d11-6880-45cb-8000-3f6903a85c7d
# ╠═cbb9e351-b496-45cc-8816-519ada1dc5d5
# ╟─77e5ff47-1e95-4552-a3d2-2fdf7bbea7cb
# ╠═92aca04d-376f-4ac7-b4c3-5b0652974157
# ╠═34556546-0cab-43e2-bc2c-f7487288392c
# ╟─c90e3885-33bd-40d2-8a64-946fd7676656
# ╟─e01fa79b-e92b-4b77-8234-108839ed2598
# ╟─1d91975b-2644-41da-a2a4-667ae6ed5ca1
# ╟─d99002e1-02ca-45bd-ba26-581f7f1b4fe8
# ╟─64642233-3331-40ea-929b-be5daa933393
# ╟─2228c7f6-8692-487e-bf8a-6600e7e93a06
# ╠═cfa7b192-f1a0-4cd1-ae34-cec07e7b47f6
# ╠═2e61c129-7fd8-46b6-8480-40f0244aab47
# ╠═58dbd153-09e2-4a38-94c1-9f69acf515ae
# ╟─e068c809-34c6-4723-8ad5-a55918cfed87
# ╠═5ffeba9b-8487-4be1-bb64-8d2330824ee5
# ╟─a7f067e4-d088-400b-bba4-d58f9cfb87a8
# ╟─cc7ee950-6b86-4d43-8524-86254978bd1b
# ╠═aebdd083-4f70-4490-9949-8fe5c1cb2e1e
# ╠═f44c9f92-aacd-4556-b494-8ee874387e5d
# ╠═c2615e16-93d1-4db0-af18-0c1a758cd58a
# ╟─0b1b4e0e-d146-4c94-bfee-3d0a50323d0b
# ╟─b8423240-1761-490d-a856-f722714cc763
# ╟─8eb1c83e-18f2-497a-94fd-a4abe11beed3
# ╟─3188c2ca-ab8f-45a9-bcbc-10159659a9d4
# ╟─75f3d63d-aa5d-46ce-824c-72153623d2c5
# ╟─019be011-51ed-4997-8e8e-1035c109efe7
# ╠═edd470f6-828e-47f4-b2d1-cb16f6103158
# ╠═5c27ade2-5983-4332-9097-20efb20504bc
# ╠═043c35e5-bf4b-445a-b746-9030b96033ca
# ╠═d9b34169-85a2-4f97-a7e3-a2ed67ee205a
# ╟─02f295ba-6bb1-41ca-9581-af33766241a4
# ╟─d0918f0c-22d4-11eb-383a-553e33114c52
# ╠═319c2ba8-220e-11eb-1ee0-4dd51ff4cd25
# ╠═42de6dd6-220e-11eb-2a48-a3c69b10a03b
# ╠═546168ce-2218-11eb-198b-1da9f8a9a242
# ╠═46f1e3a2-2217-11eb-184f-f5649b892004
# ╠═2b1b49b0-2247-11eb-1d25-57f3b4f46d04
# ╠═d4fa7bec-2371-11eb-3e9f-69d552546331
# ╠═e55d2780-2247-11eb-01e0-fbdc94bba264
# ╟─e27dace4-2248-11eb-2ae1-953639d8c944
