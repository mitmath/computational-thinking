### A Pluto.jl notebook ###
# v0.19.4

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

# ╔═╡ 88b46d2e-220e-11eb-0f7f-b3f523f0214e
begin
	using Plots, PlutoUI, LaTeXStrings, Roots, DifferentialEquations
	using LinearAlgebra
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

# ╔═╡ f9dbf2e8-574d-4846-af48-f7e5a82a1afc
TableOfContents()

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

# ╔═╡ 2d1c6abf-3b15-4638-88c5-89b5d0585c98
md"""
Normally we would *not* choose the Euler method to calculate actual trajectories, but it is enough for our purposes of understanding the *qualitative* behaviour of the equations.
"""

# ╔═╡ f055be76-22d4-11eb-268a-bf70c7d8f1a1
md"""
We see that for this particular initial condition, the solution seems to settle down to a fixed value after some time, and then remains at that value thereafter.

Such a value is called a **fixed point**, a **stationary point**, or a **steady state** of the ODE.
"""

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

# ╔═╡ ae862e10-22d5-11eb-3d75-1d748cf86944
md"""
To get an overview of the behaviour we can draw all the results on a single graph:
"""

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

# ╔═╡ 49ec803a-22d7-11eb-3f04-db8f8c119a7d
md"""
Now let's collect all the vector fields into a single plot. The horizontal axis now represents the different possible values of the parameter $\mu$:
"""

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

# ╔═╡ 77e5ff47-1e95-4552-a3d2-2fdf7bbea7cb
md"""
a = $(@bind a Slider(0.0:0.1:5.0, show_value=true, default=1.0))

b = $(@bind b Slider(0.0:0.1:5.0, show_value=true, default=1.5))
"""

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

# ╔═╡ e068c809-34c6-4723-8ad5-a55918cfed87
md"""
ρ = $(@bind ρ Slider(0.0:0.1:100.0, show_value=true, default=10.0))
"""

# ╔═╡ 58dbd153-09e2-4a38-94c1-9f69acf515ae
lorenz_params = (σ = 10.0, ρ = ρ, β = 8/3)

# ╔═╡ 2e61c129-7fd8-46b6-8480-40f0244aab47
begin
	lorenz_prob = ODEProblem(lorenz, [0.01, 0.01, 0.01], (0.0, 100.0), lorenz_params)
	
	lorenz_soln = solve(lorenz_prob)
end;

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
	p = plot(xlabel=L"t", ylabel=L"x(t)",  leg=false, ylim=(-1, 2))

	results = euler(logistic, x0, 0.01, 5.0)	
		
	plot!(results.ts, results.xs, alpha=1, lw=3)
	scatter!([0.0], [x0])
	
	hline!([0.0], ls=:dash)
	# as_svg(p)
end
	

# ╔═╡ c5bf15b1-a540-478b-acec-1aa47aad13d1
let
	p = plot(xlabel=L"t", ylabel=L"x(t)", leg=false, ylim=(-1, 2))

	# for x0 in -0.5:0.05:2.0
# for x0 in 0.0:0.1:2.0
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

# ╔═╡ 9a833edc-2217-11eb-0701-99862b410bfa
vector_field(logistic)

# ╔═╡ 25578fa6-2248-11eb-2838-57fbfb928fc4
begin
	vector_field(x -> g(λ, x))
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"

[compat]
DifferentialEquations = "~7.1.0"
LaTeXStrings = "~1.3.0"
Plots = "~1.29.0"
PlutoUI = "~0.7.38"
Roots = "~2.0.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "81f0cb60dc994ca17f68d9fb7c942a5ae70d9ee4"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.8"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c23473c60476e62579c077534b9643ec400f792b"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "0.8.6"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "019aa88766e2493c59cbd0a9955e1bac683ffbcd"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.16.13"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "28bbdbf0354959db89358d1d79d421ff31ef0b5e"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.3"

[[deps.BoundaryValueDiffEq]]
deps = ["BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NLsolve", "Reexport", "SparseArrays"]
git-tree-sha1 = "fe34902ac0c3a35d016617ab7032742865756d7d"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "2.7.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "Static"]
git-tree-sha1 = "baaac45b4462b3b0be16726f38b789bf330fcb7a"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.21"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "f576084239e6bdf801007c80e27e2cc2cd963fe0"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "63d1e802de0c4882c00aee5cb16f9dd4d6d7c59c"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.1"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DEDataArrays]]
deps = ["ArrayInterface", "DocStringExtensions", "LinearAlgebra", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "5e5f8f363c8c9a2415ef9185c4e0ff6966c87d52"
uuid = "754358af-613d-5f8d-9788-280bf1605d4c"
version = "0.2.2"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "UnPack"]
git-tree-sha1 = "52f54bd7f7bc1ce794add0ccf08f8fa21acfaed9"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.35.1"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "ChainRulesCore", "DEDataArrays", "DataStructures", "Distributions", "DocStringExtensions", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "IterativeSolvers", "LabelledArrays", "LinearAlgebra", "Logging", "MuladdMacro", "NonlinearSolve", "Parameters", "PreallocationTools", "Printf", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "StaticArrays", "Statistics", "SuiteSparse", "ZygoteRules"]
git-tree-sha1 = "bd3812f2be255da87a2438c3b87a0a478cdbd050"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.84.0"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "LinearAlgebra", "NLsolve", "OrdinaryDiffEq", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "c4b99e3a199e293e7290eea94ba89364d47ee557"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.22.0"

[[deps.DiffEqJump]]
deps = ["ArrayInterface", "Compat", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "26d88f58260cb61f9532c2f7283bc6c6519f954d"
uuid = "c894b116-72e5-5b58-be3c-e6d8d4ac2b12"
version = "8.4.2"

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "LinearAlgebra", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "Requires", "ResettableStacks", "SciMLBase", "StaticArrays", "Statistics"]
git-tree-sha1 = "d6839a44a268c69ef0ed927b22a6f43c8a4c2e73"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.9.0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqJump", "DiffEqNoiseProcess", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "3f3db9365fedd5fdbecebc3cce86dfdfe5c43c50"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.1.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "8a6b49396a4058771c5c072239b2e0a76e2e898c"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.58"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExponentialUtilities]]
deps = ["ArrayInterface", "GenericSchur", "LinearAlgebra", "Printf", "Requires", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "789a5aaec6856ad774a95cdb558806afeeb256f9"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.15.0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FastBroadcast]]
deps = ["LinearAlgebra", "Polyester", "Static"]
git-tree-sha1 = "b6bf57ec7a3f294c97ae46124705a9e6b906a209"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.1.15"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "51c8f36c81badaa0e9ec405dcbabaf345ed18c84"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.11.1"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "7a380de46b0a1db85c59ebbce5788412a39e4cb7"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.28"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "241552bc2209f0fa068b6415b1942cc0aa486bcc"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "57c021de207e234108a6f1454003120a1bf350c4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.6.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "18be5268cf415b5e27f34980ed25a7d34261aa83"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.7"

[[deps.Hwloc]]
deps = ["Hwloc_jll"]
git-tree-sha1 = "92d99146066c5c6888d5a3abc871e6a214388b91"
uuid = "0e44f5e4-bd66-52a0-8798-143a42290a1d"
version = "2.0.0"

[[deps.Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "303d70c961317c4c20fafaf5dbe0e6d610c38542"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.7.1+0"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "SpecialFunctions", "Test"]
git-tree-sha1 = "65e4589030ef3c44d3b90bdc5aac462b4bb05567"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.8"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "cae5e3dfd89b209e01bcd65b3a25e74462c67ee0"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.3.0"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "13b16b00144816211cbf92823ded6042490eb009"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.8.1"

[[deps.KrylovKit]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "49b0c1dd5c292870577b8f58c51072bd558febb9"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.5.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LabelledArrays]]
deps = ["ArrayInterface", "ChainRulesCore", "LinearAlgebra", "MacroTools", "StaticArrays"]
git-tree-sha1 = "fbd884a02f8bf98fd90c53c1c9d2b21f9f30f42a"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.8.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "b651f573812d6c36c22c944dd66ef3ab2283dfa1"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.6"

[[deps.LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "DocStringExtensions", "IterativeSolvers", "KLU", "Krylov", "KrylovKit", "LinearAlgebra", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "SuiteSparse", "UnPack"]
git-tree-sha1 = "6eb8e10ed29b85673495c29bd77ee0dfa8929977"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "1.15.0"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SLEEFPirates", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "4acc35e95bf18de5e9562d27735bef0950f2ed74"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.108"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MuladdMacro]]
git-tree-sha1 = "c6190f9a7fc5d9d5915ab29f2134421b12d24a68"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.2"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.NonlinearSolve]]
deps = ["ArrayInterface", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "aeebff6a2a23506e5029fd2248a26aca98e477b3"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.16"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "aee446d0b3d5764e35289762f6a18e8ea041a592"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.11.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "7a28efc8e34d5df89fc87343318b0a8add2c4021"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.OrdinaryDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastClosures", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "NonlinearSolve", "Polyester", "PreallocationTools", "RecursiveArrayTools", "Reexport", "SciMLBase", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "8031a288c9b418664a3dfbac36e464a3f61ace73"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.10.0"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "027185efff6be268abbaf30cfd53ca9b59e3c857"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.10"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d457f881ea56bbfa18222642de51e0abf67b9027"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.PoissonRandom]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "44d018211a56626288b5d3f8c6497d28c26dc850"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.0"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "8d95a735921204f5d551ac300b20d802a150433a"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.6.8"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "7e597df97e46ffb1c8adbaddfa56908a7a20194b"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.5"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff", "LabelledArrays"]
git-tree-sha1 = "6c138c8510111fa47b5d2ed8ada482d97e279bee"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.2.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "afeacaecf4ed1649555a19cb2cad3c141bbc9474"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.5.0"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "ChainRulesCore", "DocStringExtensions", "FillArrays", "LinearAlgebra", "RecipesBase", "Requires", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "bfe14f127f3e7def02a6c2b1940b39d0dabaa3ef"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.26.3"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "a9a852c7ebb08e2a40e8c0ab9830a744fa283690"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.10"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "e382260f6482c27b5062eba923e36fde2f5ab0b9"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "62c2da6eb66de8bb88081d20528647140d4daa0e"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "ac399b5b163b9140f9c310dfe9e9aaa225617ff6"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.32"

[[deps.SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "5420ffd1d5ad49e2c8309efb7338cc2443487029"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.31.4"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SparseDiffTools]]
deps = ["Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays", "VertexSafeGraphs"]
git-tree-sha1 = "314a07e191ea4a5ea5a2f9d6b39f03833bde5e08"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "1.21.0"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "5309da1cdef03e95b73cd3251ac3a39f887da53e"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "ca9f8a0c9f2e41431dc5b7697058a3f8f8b89498"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.0.0"

[[deps.SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "3e057e1f9f12d18cac32011aed9e61eef6c1c0ce"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.6.6"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqJump", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "963686543afb4cda9dbbeca46878073182cfe859"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.47.0"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "Requires", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "70d9007ff05440058c0301985b2275edc2b2ce25"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.3.3"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "e75d82493681dfd884a357952bbd7ab0608e1dc3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.7"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "Reexport", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "e0805213754f0d871f9333eacd77862a44acb46d"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.9.3"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "04777432d74ec5bc91ca047c9e0e0fd7f81acdb6"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.1+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "f8629df51cab659d70d2e5618a430b4d3f37f2c3"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.0"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "b8d08f55b02625770c09615d96927b3a8396925e"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.11"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "Hwloc", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "ff34c2f1d80ccb4f359df43ed65d6f90cb70b323"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.31"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

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
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

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
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
