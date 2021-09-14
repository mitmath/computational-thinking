### A Pluto.jl notebook ###
# v0.16.0

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

# ╔═╡ e0c0dc94-277e-11eb-379e-83d064a93413
begin
    using Plots, PlutoUI, LinearAlgebra
end

# ╔═╡ 8c1e6dae-b339-11eb-0e86-f1d18858689a
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
"><em>Section 3.7</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Advection and diffusion in 1D </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/Xb-iUwXI78A" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 5648fa26-da0b-41d9-b13f-debd4e0485af
TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)

# ╔═╡ 00877a4a-277c-11eb-3ec0-e71e4094b404
md"""
# Evolution in time and space: Advection and diffusion in 1D
"""

# ╔═╡ 1b25b916-277c-11eb-0274-4b4fb946258d
md"""
So far we have been looking at dynamics in time, for example how does the temperature of the Earth change over time. But the Earth does not have a single, uniform temperature; rather, at a particular moment in time, different places on Earth are at different temperatures, and those different temperatures change over time due to several mechanisms. 

In this notebook we will look at two fundamental mechanisms: **advection** and **diffusion**. Let's think about the temperature in the ocean. Since the ocean is a fluid that is in motion, a warm "parcel" of water can flow (move) to a new location due to the physical motion of the water itself; this is **advection**.  And even if the water doesn't move, temperature or a higher concentration of some substance dissolved in the fluid can spread out due to molecular mechanisms; this is **diffusion**.
"""

# ╔═╡ 956f5104-277d-11eb-291d-1faef485a5aa
md"""
In this notebook we will restrict ourselves to one spatial dimension (1D).
So we will think about the temperature $T$, for example, being a function 

$$T(t, x)$$

of two independent variables:

- time, $t$
- space, $x$


We want to calculate a value of the temperature $T$ for each possible pair of values $(t, x)$, i.e. for all time ($>0$) and all positions.

The temperature at a given point will change due to different physical processes. We need to model this by writing down equations describing each physical process and how it affects the temperature. Since there are now *two* independent variables, $t$ and $x$, we can expect to end up with derivatives with respect to *both* of these variables, so that the rate of change of temperature in time at a given point depends also on gradients of the temperature in *space*. This will lead to a **partial differential equation** that relates *partial* derivatives of $T$.

In the context of climate modelling, we can think of $x$ as being the **latitude**, supposing that the temperature is the same at all points with the same latitude. In this way we could model the fact that the poles are cold and the equator is warm, and we could model how heat flows from hot to cold. 

However, we clearly cannot model actual ocean currents like this, which would require two, or even three, spatial dimensions.

"""

# ╔═╡ b12e76db-1a18-465a-8955-dab29dfde611
md"""
## Visualising advection--diffusion
"""

# ╔═╡ c14470f2-d8a4-4d34-8470-09842b2576a3
md"""
Here is a visualisation of the physical processes of advection and diffusion in one dimension that we will discuss and build during this notebook.
"""

# ╔═╡ b04a6f81-3ece-4521-b141-a2e416718948
md"""
U = $(@bind UU Slider(-1:0.01:1, show_value=true, default=0))

D = $(@bind DD Slider(-0.2:0.001:0.2, show_value=true, default=0))
"""

# ╔═╡ 36328b70-277d-11eb-02c7-2f854c1466cc
md"""
# Temperature profiles and discretization
"""

# ╔═╡ 42190984-277d-11eb-1ac2-7d84516c3269
md"""
An ordinary differential equation needs an initial value for each variable. Similarly, we will need an initial *function* $T_0(x)$ that gives us the temperature at each position $x$. Let's suppose that the position is restricted to the interval $[0, L_x]$.

As usual, to represent the continuous function $T_0(x)$ on a computer, we will need to **discretise** it in some way, i.e. *approximate* the continuous function by a *finite* set of numbers in the computer.

The simplest (but far from the only!) discretisation method is to **sample** the function at discrete **grid points** (or **nodes**) $x_i$, for $i = 1, \dots, N_x$. For simplicity we will take these equally spaced, with spacing $x_{i+1} - x_i =: \delta x := L_x / N_x$.
"""

# ╔═╡ d2bed768-277e-11eb-32cf-41f1fedec3cb
md"""
For example, let's consider the following initial temperature profile:
"""

# ╔═╡ e6493da0-277e-11eb-22ff-29752652b576
# T₀(x) = sin(2π * x)^2 + 0.5

T₀(x) = sin(2π * x) + 2*cos(4π * x) + 0.2

# ╔═╡ 0d6271c0-286c-11eb-1c9c-3ba039b49d24
md"""
and define the grid points as follows:
"""

# ╔═╡ f17f7734-277e-11eb-25cf-5f2ba2db5aa3
begin
	Nₓ = 20
	Lₓ = 1.0
	
	δx = Lₓ / Nₓ
	
	xs = δx/2:δx:Lₓ
end

# ╔═╡ fa327c08-286b-11eb-0032-2384998a42a8
xs

# ╔═╡ 0db43be2-284c-11eb-2740-4379437fd70c
md"""
It turns out to be a good idea to take the grid points at the *centre* of each interval, so that we have $N_x$ intervals and $N_x$ grid points, starting at $x_1 = \delta x/2$ and finishing at $x_N = L_x - \delta x / 2$.
"""

# ╔═╡ 468a0590-2780-11eb-045c-d1f468fc4e50
md"""
We call such a function of $x$ at a given time a **temperature profile**. Let's draw it both as a function and as a heatmap:
"""

# ╔═╡ af30a0d0-2781-11eb-0274-ab423205facb
md"""
We will denote by $T^0_i$ the initial temperature at grid point number $i$.
"""

# ╔═╡ 646bc32e-284c-11eb-2ce8-5f64b1a49534
md"""
A useful way to think about $T^n_i$ is as some kind of (spatial) average of $T(t_n, x)$ over the interval of positions between neighbouring grid points, so $T_i$ is the average over the interval between $x_i - \frac{\delta x}{2}$ and $x_i + \frac{\delta x}{2}$. We can thus think of the following **piecewise constant** approximation to the original continuous function:
"""

# ╔═╡ 79ce4b10-284c-11eb-2258-2155f850171d
let
	δx = xs[2] - xs[1]
	
	p = plot(0:0.001:Lₓ, T₀, label="T₀", lw=1, ls=:dash)
	scatter!(xs, T₀.(xs), label="sampled")
	scatter!(xs, zero.(xs), label="x nodes", alpha=0.5, ms=3, lw=2)
	
	for i in 1:length(xs)
		plot!([ (xs[i] - δx/2, T₀(xs[i])), (xs[i] + δx/2, T₀(xs[i])) ], c=:green, lw=4, lab=false)
		
		plot!([ (xs[i] - δx/2, 0), (xs[i] - δx/2, T₀(xs[i])), (xs[i] + δx/2, T₀(xs[i])), (xs[i] + δx/2, 0)], c=:green, lw=1, lab=false, ls=:dash, alpha=0.3
		)
	end
	
	xlabel!("x")
	ylabel!("T₀(x)")
end

# ╔═╡ 2494daaa-2780-11eb-3084-2317924048ea
md"""
# Advection
"""

# ╔═╡ 29444ffe-2780-11eb-0875-095302b5d486
md"""
Now let's think of this profile as representing the temperature in each small volume, or "parcel", of fluid. Let's suppose that the fluid is moving to the right with a constant, uniform speed $U$. (**Uniform** here means that the speed is the same in all parts of the fluid.) Then the temperature profile should also *move with the fluid*! We call a quantity, such as the temperature, that is carried along with the fluid a **tracer**.

If we fix our attention at a single, fixed point in space, say the grid point $x_i$, the temperature there will vary over time, due to the fact that the fluid is moving past it. How it varies in time depends on the values at neighbouring grid points, since they determine how much heat will be transported *into* and *out of* the current cell.

[The point of view where we fix our attention at one point in space is called **Eulerian**. The alternative is to follow a parcel of fluid as it moves along in space; this is called **Lagrangian**.]
"""

# ╔═╡ 1dcb9690-6436-49f0-880f-23490fe28ea4
md"""
## Visualising fluxes in a fluid
"""

# ╔═╡ b63bb2e8-1d23-48fb-94b5-60d947465830
md"""
Let's visualise what happens as the fluid moves past a grid point, or rather the cell centered at a grid point. We will visualise tracer particles moving inside the fluid:
"""

# ╔═╡ e94a90c5-f2c1-4b5b-9946-7869ef7775a6
N = 5000

# ╔═╡ dd87fc01-4bf0-44f6-a9f6-560e433754a0
begin
	xx = ( abs.(-2 .+ 4 .* rand(N)) .^ 2) .- 1.5
	yy = rand(N)
end

# ╔═╡ 7ae9f5b8-10ea-42a7-aa01-0e04a7287c77
δ = 0.8

# ╔═╡ 2f24e0c7-b05c-4f89-835a-081f8e6107e5
md"""
show particles entering and leaving in $\delta t$: $(@bind show_particles CheckBox())
"""

# ╔═╡ 75bc87be-2b66-46b5-8de8-428a63655815
md"""
t = $(@bind t Slider(0:0.001:2, show_value=true, default=0))
"""

# ╔═╡ 3437e53b-9dd0-4afe-a1bd-a556871d1799
md"""
## Time stepping
"""

# ╔═╡ 65df7158-60dc-4809-82a3-913a79bcfc75
md"""
We want to model how the temperature profile changes in time due to the flow of the fluid. We'll do so by looking at each cell and asking how much heat enters and leaves the cell in a given time step, of duration $\delta t$.
"""

# ╔═╡ 7256778a-2785-11eb-0369-f3b43d5dd203
md"""
Let's call $T^n_i$ the approximate (unknown) average value of $T$ in the cell at position $x_i$ and at the $n$th time step $t_n$, i.e. an approximation of $T(t_n, x_i)$, where $t_n = n \, \delta t$. 

Then $T^{n+1}_i \simeq T(t_n + \delta t, x_i)$ and $T^{n}_{i+1} \simeq T(t_n, x_i + \delta x)$.

[Note that the superscript $n$ in these algorithms does not mean a power; it's just a label for the time step. We could write $T_i^{(n)}$ instead, but that is annoying to both write and read, so we omit the parentheses.]


"""

# ╔═╡ 44433a34-2782-11eb-0079-837c9306c5bd
md"""
Suppose the fluid is moving to the right with speed $U$. During a time step of duration $\delta t$, the temperature $T^n_i$ at cell $i$ changes for two reasons:

- some heat enters cell $i$
- some heat leaves cell $i$ 

Note that most of the fluid that starts within cell $i$ remains within that cell during the time step (if the time step is short enough), as we see from the visualisation above. 

To calculate how much heat enters and leaves, note that only heat in the region of fluid within a distance $U \, \delta t$ from the boundary of the cell will cross into that cell. So a *proportion* $(U \, \delta t) / \delta x$ of the amount in cell $i$ crosses the boundary.

[We will blur the distinction between "amount of heat" and temperature.]

Hence, roughly an amount $T^n_i (U \delta t) / \delta x$ will leave cell number $i$ and cross into cell $i+1$ (the cell to the right). Similarly, an amount $T^n_{i-1} (U \delta t) / \delta x$ will *enter* cell $i$ from the neighbouring cell $i-1$ on the left. 

Hence we arrive at the following:

$$T^{n+1}_i = T^{n}_i + (T^n_{i-1} - T^n_{i})\, U \, \delta t / \delta x.$$

Note that on the right-hand side we have quantities at the time step $n$, and on the left at time step $n+1$. So this tells us how to *update* our quantities from slice $n$ to slice $n+1$.

"""

# ╔═╡ 87e2be25-227c-498c-94fa-6e404c8918f1
md"""
## Continuous limit: Advection equation PDE
"""

# ╔═╡ 72c0ab0c-2781-11eb-1f59-9b22a52b0be0
md"""
Rearranging the previous equation we get 

$$\frac{T^{n+1}_i - T^{n}_i}{\delta t} =  \frac{T^n_{i-1} - T^n_{i}}{\delta x}\,  U.$$
"""

# ╔═╡ e5761990-278b-11eb-134e-7954b577b1ac
md"""
Taking the continuum limit when $\delta t \to 0$ and $\delta x \to 0$, we recognise the definition of **partial derivatives** with respect to time and space variables from multivariable calculus. (Note the different indices that change on the two sides of the equation.) 

Denoting these partial derivatives using $\partial$, we arrive at the **advection equation**:

$$\frac{\partial T(t, x)}{\partial t} = -U \frac{\partial T(t, x)}{\partial x},$$

or for short

$$\frac{\partial T}{\partial t} = -U \frac{\partial T}{\partial x}.$$


Since $T$ is a function of both $x$ and $t$, and this equation involves partial derivatives with respect to both of the independent variables, this is a **partial differential equation** (PDE). It describes how the function $T(t, x)$ changes continuously as a function both of time and space. 

Although there are some analytical methods to solve PDEs, often it's necessary to use numerical methods. Here we'll look at simple numerical methods to solve such equations.
"""

# ╔═╡ 2033364e-278c-11eb-2936-17598ce14a41
md"""
## Numerics for the advection equation
"""

# ╔═╡ e9a37908-278c-11eb-278e-9bd155f0cae6
md"""
Let's return to the version of the equation in which the value at the *following* time step is isolated:

$$T^{n+1}_i = T^{n}_i - \left( U \frac{\delta t}{\delta x} \right) (T^n_{i} - T^n_{i-1}).$$

In the last term on the right-hand side, we see that we require combinations of values of $T$ at the *same* time step from *different* places, with certain coefficients.
"""

# ╔═╡ bcf1ceca-f557-4d75-9058-bbaa58665fb7
md"""
There are many approaches to implementing this numerically. The simplest is to directly transcribe the equation for the $i$th entry of the vector.

Calling `T` the current vector, i.e. $\mathbf{T}^n := (T^n_i)_{i=1, \ldots, N_x}$, and `T′` the new vector at the next time step, we have the following basic expression:

	T′[i] = T[i] + δt * U * (T[i-1] - T[i]) / δx

But now we realise a problem: What should we do when $i=1$? This will try to access the index 0 of the vector `T`, which does not exist!
"""

# ╔═╡ 3736a25e-4dec-46ac-9bf6-9712e3d00e7a
md"""

### Boundary conditions

This illustrates the necessity of choosing **boundary conditions** that specify what happens at the edge of the domain.

For simplicity we will choose to use **periodic boundary conditions**. This is a convenient mathematical fiction that allows us to treat all cells as being on the same footing, by wrapping the system around a torus, so that cells $i=1$ and $i=N_x$ are neighbours.
"""

# ╔═╡ e542a8da-284e-11eb-3297-6bbbf052284b
md"""
We can then write this as follows, where we separate out the case $i=1$:
"""

# ╔═╡ b15f4f44-284b-11eb-37c5-ab0153f7fe92
function advection(T, δt, δx, U)
	N = length(T)
	T′ = similar(T)  # create new vector of the same length
	
	# bulk cells:
	for i in 2:N  
		T′[i] = T[i] - δt * U * (T[i] - T[i-1]) / δx
	end

	# boundary cells:
	T′[1] = T[1] - δt * U * (T[1] - T[N]) / δx   # periodic
	
	return T′
end

# ╔═╡ fcbec610-d9fc-4e41-8e76-729dbbc61d92
md"""
This performs a single time step of the advection equation; it takes in the current vector of $T$s and returns the new $T$s after the step.

Note that this is just like a step of the Euler method for solving ODEs, but where many spatial coordinates are updated at the same time. Effectively we are solving a system of coupled ODEs!
"""

# ╔═╡ af79e360-286e-11eb-2a4d-3d6d7564088c
δt = 0.001;

# ╔═╡ dce9e53a-28f4-11eb-070b-17e10779a38b
U = 0.2;

# ╔═╡ addab3e6-f189-41d6-badb-92f0323b6192
# assign colours to particles:

cs = map(xx) do x
	if -U * δ < x < 0
		1
	elseif 1 - (U * δ) < x < 1
		2
	else
		0
	end
end
	

# ╔═╡ f684dd94-f1c7-4f79-9776-3a06b8eec39b
begin
	plot([0, 1, 1, 0, 0], [0, 0, 1, 1, 0], series=:shape, alpha=0.5, fill=true, ratio=1, label=false, leg=false)
	
	new_xx = xx .+ U .* t
	
	scatter!(xx .+ U .* t, yy, ms=1.5, alpha=0.1, c=:gray)
	
	if show_particles
		scatter!(new_xx[cs .!= 0], yy[cs .!= 0], ms=1.5, alpha=0.5, c=cs[cs .!= 0])
	end
	
	plot!([-1.5, 2], [0, 0], c=:black)
	plot!([-1.5, 2], [1, 1], c=:black)

	
	xlims!(-2, 2)
	ylims!(-0.1, 1.1)
	
	as_svg(plot!(axis=true, yticks=[0, 1]))
end

# ╔═╡ 8c05e3cc-2858-11eb-1e1c-9781c30738c3
md"""
Unfortunately this does *not* behave as we expect: instead of preserving the shape of the profile over time, it is decaying. This is due to the way we are approximating. 

A better way to discretize the spatial derivative is using the following **centered difference**:

$$\frac{\partial T(t_n, x_i)}{\partial x} \simeq \frac{T^n_{i+1} - T^n_{i-1}}{2 \delta x}$$


"""

# ╔═╡ a29fecac-285a-11eb-14b0-9313f8994fbb
function advection2(T, δt, δx, U)
	N = length(T)
	T′ = similar(T)  # create new vector of the same length
	
	for i in 2:N-1
		T′[i] = T[i] - δt * U * (T[i+1] - T[i-1]) / (2δx)
	end

	# periodic boundary:
	T′[1] = T[1] - δt * U * (T[2] - T[N]) / (2δx)
	T′[N] = T[N] - δt * U * (T[1] - T[N-1]) / (2δx)

	return T′
end

# ╔═╡ c59388ea-286e-11eb-0f21-eb18e5ba516f
md"""
# Diffusion
"""

# ╔═╡ 3c944998-2888-11eb-087d-492b9d0ee32e
md"""
Another key physical process is **diffusion**. This models how temperature or mass spreads out from hot or high concentration regions towards regions where it is cold or where there is a low concentration.

## Physical mechanism: Random walks

The physical mechanism behind this is **random motion**: this is the continuous limit of equations describing the evolution of the probability distribution in space and time of a cloud of random walkers.

This is the same process that we studied in lecture 2.6.
Using our current notation, there we showed that the probability distribution of a cloud of random walkers satisfies the following time evolution:

$$p^{n+1}_i = \frac{1}{2}(p^n_{i-1} + p^n_{i+1})$$

If now we say that the walkers jump only with a certain probability, with a large probability to stay in the same place, and that these random walkers are the carriers of heat, then we get 

$$T^{n+1}_i = \kappa (T^n_{i-1} - 2 T^n_i + T^n_{i+1}).$$

Watch [this video](https://www.youtube.com/watch?v=a3V0BJLIo_c) from last semester's class to see Grant Sanderson explaining this.
"""

# ╔═╡ 6ac74e34-ed58-4903-8c53-82be13b6c21f
md"""
## Continuous limit: Heat equation PDE
"""

# ╔═╡ de42149c-85ce-4e73-8503-84f64a173cbb
md"""
Introducing $\delta x$ as the spatial discretisation, and $\delta t$ as the time step, we get 

$$T^{n+1}_i = \kappa \frac{\delta t}{\delta x^2}  (T^n_{i-1} - 2 T^n_i + T^n_{i+1}).$$

"""

# ╔═╡ ef42d541-74a1-433a-9773-5e6cca525350
md"""
The continuous limit is the following **heat equation** or **diffusion equation**:
"""

# ╔═╡ 6b7cea44-2888-11eb-0208-990860d6a152
md"""
$$\frac{\partial T}{\partial t} = \kappa \frac{\partial^2 T}{\partial x^2}.$$
"""

# ╔═╡ 83a1e1f5-0946-422c-83f4-d7a19e9c0789
md"""
Here, $\kappa$ is the **heat diffusivity**, which says how quickly heat spreads out. In the context of diffusion of mass the equivalent is the **diffusion coefficient**, $D$.
"""

# ╔═╡ 68db3372-2888-11eb-1b03-b5ebca4c2bd5
md"""
To obtain a numerical method to solve this equation, we again need to discretise this, in particular the second derivative. One possible discretisation is

$$\frac{\partial^2 T}{\partial x^2}(t_n, x_i) \simeq \frac{T^n_{i+1} - 2 T^n_i + T^n_{i-1}}{\delta x^2}.$$
"""

# ╔═╡ d6131ad0-2889-11eb-3085-15d17e33ee7a
md"""
This may again be transcribed directly into code:
"""

# ╔═╡ 630314bc-2868-11eb-1b93-b7b08a4b2887
function diffusion(T, δt, δx, D)
	N = length(T)
	T′ = similar(T)  # create new vector of the same length
	
	for i in 2:N-1
		T′[i] = T[i] + δt * D * (T[i+1] -2T[i] + T[i-1]) / (δx^2)
	end

	# periodic boundary:
	T′[1] = T[1] + δt * D * (T[2] - 2T[1] + T[N]) / (δx^2)
	T′[N] = T[N] + δt * D * (T[1] - 2T[N] + T[N-1]) / (δx^2)

	return T′
end

# ╔═╡ e74d920a-28fa-11eb-3c91-9133a01effc5
@bind n4 Slider(1:length(evolution4), show_value=true)

# ╔═╡ e63cfa84-2889-11eb-1ea2-51726645ddd9
md"""
# The advection--diffusion PDE
"""

# ╔═╡ eee3008e-2889-11eb-088a-73aff304e736
md"""
Finally we can combine both mechanisms, to describe a tracer that is both being advected at a constant speed and diffusing. This basically utilises the composition of the advection and diffusion functions:
"""

# ╔═╡ ffd2a838-2889-11eb-1a7c-b35992543b8a
function advection_diffusion(T, δt, δx, (U, D))
	temp = advection2(T, δt, δx, U)
	return diffusion(temp, δt, δx, D)
end

# ╔═╡ 575a5f3c-2780-11eb-2119-27a4114ceac5
md"""
# Function library
"""

# ╔═╡ 5a3eec86-2780-11eb-0341-39a5c343fc52
function temperature_heatmap(x, T)

	p = heatmap(x, [0.], collect(T'), 
			   clims=(-1., 1.), cbar=false, xticks=nothing, yticks=nothing)

	return p
end

# ╔═╡ 6de1859c-277f-11eb-1ead-8b4794832d59
begin
	p1 = plot(0:0.001:Lₓ, T₀, label="T₀", lw=3)
	scatter!(xs, T₀.(xs), label="sampled")
	scatter!(xs, zero.(xs), label="x nodes", alpha=0.5, ms=3)
	
	xlabel!("x")
	ylabel!("T₀")
	
	for x in xs
		plot!([ (x, 0), (x, T₀(x)) ], ls=:dash, c=:black, label="", alpha=0.5)
	end
	
	hline!([0], ls=:dash, lab=false)
	
	
	p2 = temperature_heatmap(xs, T₀.(xs))
	
	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]))

end

# ╔═╡ 9187350a-2851-11eb-05f0-d3a6eef190fe
function evolve(method, xs, δt, U, t_final=10.0, f₀=T₀)
	
	T = f₀.(xs)  
	δx = xs[2] - xs[1]
	
	t = 0.0
	ts = [t]
	
	results = [T]
	
	while t < t_final
		T′ = method(T, δt, δx, U)  # new
		push!(results, T′)
		
		t += δt
		push!(ts, t)
		
		T = copy(T′)

	end
	
	return ts, results
end

# ╔═╡ 30006c82-695d-40b1-8ded-22d03c3bff41
tt, results = evolve(advection_diffusion, xs, δt, (UU, DD))

# ╔═╡ 6b2bfc73-d0a9-4a36-970d-c89149238284
md"""
time step = $(@bind n6 Slider(1:length(results), show_value=true))
"""

# ╔═╡ 02a893e4-2852-11eb-358a-371459191da7
ts, evolution = evolve(advection, xs, δt, U)

# ╔═╡ e6ae447e-2851-11eb-3fe1-096459167f2b
@bind n Slider(1:length(evolution), show_value=true)

# ╔═╡ 014e2530-2852-11eb-103f-1d647cb999b0
let
	p1 = plot(xs, evolution[n], m=:o, xlim=(0, 1), ylim=(-1.1, 1.1), title="t = $(round(ts[n], digits=2))", leg=false)

	p2 = temperature_heatmap(xs, evolution[n])
	
	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]))
end



# ╔═╡ e42ec13e-285a-11eb-3cc0-7dc41ed5495b
ts2, evolution2 = evolve(advection2, xs, δt, 0.1)

# ╔═╡ f60a8b5e-285a-11eb-0d35-8daf23cf92ae
n2_slider = @bind n2 Slider(1:length(evolution2), show_value=true)

# ╔═╡ f1b5d130-285a-11eb-001c-67035925f43d
let
	p1 = plot(xs, evolution2[n2], m=:o, xlim=(0, 1), ylim=(-3.1, 3.1), title="t = $(round(ts2[n2], digits=2))", leg=false)
	
	p2 = temperature_heatmap(xs, evolution2[n2])
	
	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]))
end


# ╔═╡ 09bc3c40-288a-11eb-0339-59f0b70e03a3
@bind n3 Slider(1:length(evolution2), show_value=true)

# ╔═╡ 121255d2-288a-11eb-1fa5-9db68af8c232
ts3, evolution3 = evolve(diffusion, xs, δt, 0.01)

# ╔═╡ 21eb19f7-467b-4995-be65-8dede4eb7ac1
let
	p1 = plot(xs, results[n6], m=:o, xlim=(0, 1), ylim=(-3.1, 3.1), title="t = $(round(ts3[n3], digits=2))", leg=false)
	p2 = temperature_heatmap(xs, results[n6])

	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]), clim=(-1, 1))
end

# ╔═╡ 175d9902-288a-11eb-3700-390ccd1caa5b
let
	p1 = plot(xs, evolution3[n3], m=:o, xlim=(0, 1), ylim=(-3.1, 3.1), title="t = $(round(ts3[n3], digits=2))", leg=false)
	p2 = temperature_heatmap(xs, evolution3[n3])

	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]), clim=(-1, 1))
end


# ╔═╡ dc7b6328-28fa-11eb-38b7-71a6f8d0a751
let
	p1 = plot(xs, evolution4[n4], m=:o, xlim=(0, 1), ylim=(-0.1, 1.1), title="t = $(round(ts3[n3], digits=2))", leg=false)
	p2 = temperature_heatmap(xs, evolution4[n4])

	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]), clim=(-1, 1))
end


# ╔═╡ f6fa3770-288d-11eb-32de-f95e03705791
ts5, evolution5 = evolve(advection_diffusion, xs, δt, (1.0, 0.01))

# ╔═╡ 6eb00a02-288d-11eb-354b-b56cf5a8380e
@bind n5 Slider(1:length(evolution5), show_value=true)

# ╔═╡ 65126bfc-288d-11eb-2bfc-493588365164
let
	p1 = plot(xs, evolution5[n5], m=:o, xlim=(0, 1), ylim=(-1.1, 1.1), title="t = $(round(ts3[n3], digits=2))", leg=false)
	p2 = temperature_heatmap(xs, evolution5[n5])

	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]), clim=(-1, 1))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.21.3"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "4866e381721b30fac8dda4c8cb1d9db45c8d2994"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.37.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "bec2532f8adb82005476c141ec23e921fc20971b"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.8.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "ef49a187604f865f4708c90e3f431890724e9012"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.59.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "60ed5f1643927479f845b0135bb369b031b541fa"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.14"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "8a954fed8ac097d5be04921d595f741115c1b2ad"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+0"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "2537ed3c0ed5e03896927187f5f2ee6a4ab342db"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.14"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "2dbafeadadcf7dadff20cd60046bba416b4912be"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.21.3"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "d4491becdc53580c6dadb0f6249f90caae888554"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.0"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "f41020e84127781af49fc12b7e92becd7f5dd0ba"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.2"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "1162ce4a6c4b7e31e0e6b14486a6986951c73be9"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.2"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─8c1e6dae-b339-11eb-0e86-f1d18858689a
# ╠═e0c0dc94-277e-11eb-379e-83d064a93413
# ╠═5648fa26-da0b-41d9-b13f-debd4e0485af
# ╟─00877a4a-277c-11eb-3ec0-e71e4094b404
# ╟─1b25b916-277c-11eb-0274-4b4fb946258d
# ╟─956f5104-277d-11eb-291d-1faef485a5aa
# ╟─b12e76db-1a18-465a-8955-dab29dfde611
# ╟─c14470f2-d8a4-4d34-8470-09842b2576a3
# ╟─30006c82-695d-40b1-8ded-22d03c3bff41
# ╟─b04a6f81-3ece-4521-b141-a2e416718948
# ╟─6b2bfc73-d0a9-4a36-970d-c89149238284
# ╟─21eb19f7-467b-4995-be65-8dede4eb7ac1
# ╟─36328b70-277d-11eb-02c7-2f854c1466cc
# ╟─42190984-277d-11eb-1ac2-7d84516c3269
# ╟─d2bed768-277e-11eb-32cf-41f1fedec3cb
# ╠═e6493da0-277e-11eb-22ff-29752652b576
# ╟─0d6271c0-286c-11eb-1c9c-3ba039b49d24
# ╠═f17f7734-277e-11eb-25cf-5f2ba2db5aa3
# ╠═fa327c08-286b-11eb-0032-2384998a42a8
# ╟─0db43be2-284c-11eb-2740-4379437fd70c
# ╟─468a0590-2780-11eb-045c-d1f468fc4e50
# ╠═6de1859c-277f-11eb-1ead-8b4794832d59
# ╟─af30a0d0-2781-11eb-0274-ab423205facb
# ╟─646bc32e-284c-11eb-2ce8-5f64b1a49534
# ╟─79ce4b10-284c-11eb-2258-2155f850171d
# ╟─2494daaa-2780-11eb-3084-2317924048ea
# ╟─29444ffe-2780-11eb-0875-095302b5d486
# ╟─1dcb9690-6436-49f0-880f-23490fe28ea4
# ╟─b63bb2e8-1d23-48fb-94b5-60d947465830
# ╠═e94a90c5-f2c1-4b5b-9946-7869ef7775a6
# ╠═dd87fc01-4bf0-44f6-a9f6-560e433754a0
# ╠═7ae9f5b8-10ea-42a7-aa01-0e04a7287c77
# ╟─addab3e6-f189-41d6-badb-92f0323b6192
# ╟─2f24e0c7-b05c-4f89-835a-081f8e6107e5
# ╟─75bc87be-2b66-46b5-8de8-428a63655815
# ╟─f684dd94-f1c7-4f79-9776-3a06b8eec39b
# ╟─3437e53b-9dd0-4afe-a1bd-a556871d1799
# ╟─65df7158-60dc-4809-82a3-913a79bcfc75
# ╟─7256778a-2785-11eb-0369-f3b43d5dd203
# ╟─44433a34-2782-11eb-0079-837c9306c5bd
# ╟─87e2be25-227c-498c-94fa-6e404c8918f1
# ╟─72c0ab0c-2781-11eb-1f59-9b22a52b0be0
# ╟─e5761990-278b-11eb-134e-7954b577b1ac
# ╟─2033364e-278c-11eb-2936-17598ce14a41
# ╟─e9a37908-278c-11eb-278e-9bd155f0cae6
# ╟─bcf1ceca-f557-4d75-9058-bbaa58665fb7
# ╟─3736a25e-4dec-46ac-9bf6-9712e3d00e7a
# ╟─e542a8da-284e-11eb-3297-6bbbf052284b
# ╠═b15f4f44-284b-11eb-37c5-ab0153f7fe92
# ╟─fcbec610-d9fc-4e41-8e76-729dbbc61d92
# ╠═af79e360-286e-11eb-2a4d-3d6d7564088c
# ╠═dce9e53a-28f4-11eb-070b-17e10779a38b
# ╠═02a893e4-2852-11eb-358a-371459191da7
# ╠═e6ae447e-2851-11eb-3fe1-096459167f2b
# ╟─014e2530-2852-11eb-103f-1d647cb999b0
# ╟─8c05e3cc-2858-11eb-1e1c-9781c30738c3
# ╠═a29fecac-285a-11eb-14b0-9313f8994fbb
# ╠═e42ec13e-285a-11eb-3cc0-7dc41ed5495b
# ╠═f60a8b5e-285a-11eb-0d35-8daf23cf92ae
# ╠═f1b5d130-285a-11eb-001c-67035925f43d
# ╟─c59388ea-286e-11eb-0f21-eb18e5ba516f
# ╟─3c944998-2888-11eb-087d-492b9d0ee32e
# ╟─6ac74e34-ed58-4903-8c53-82be13b6c21f
# ╟─de42149c-85ce-4e73-8503-84f64a173cbb
# ╟─ef42d541-74a1-433a-9773-5e6cca525350
# ╟─6b7cea44-2888-11eb-0208-990860d6a152
# ╟─83a1e1f5-0946-422c-83f4-d7a19e9c0789
# ╟─68db3372-2888-11eb-1b03-b5ebca4c2bd5
# ╟─d6131ad0-2889-11eb-3085-15d17e33ee7a
# ╠═630314bc-2868-11eb-1b93-b7b08a4b2887
# ╠═121255d2-288a-11eb-1fa5-9db68af8c232
# ╠═09bc3c40-288a-11eb-0339-59f0b70e03a3
# ╠═175d9902-288a-11eb-3700-390ccd1caa5b
# ╠═e74d920a-28fa-11eb-3c91-9133a01effc5
# ╟─dc7b6328-28fa-11eb-38b7-71a6f8d0a751
# ╟─e63cfa84-2889-11eb-1ea2-51726645ddd9
# ╟─eee3008e-2889-11eb-088a-73aff304e736
# ╠═ffd2a838-2889-11eb-1a7c-b35992543b8a
# ╠═f6fa3770-288d-11eb-32de-f95e03705791
# ╠═6eb00a02-288d-11eb-354b-b56cf5a8380e
# ╠═65126bfc-288d-11eb-2bfc-493588365164
# ╟─575a5f3c-2780-11eb-2119-27a4114ceac5
# ╟─5a3eec86-2780-11eb-0341-39a5c343fc52
# ╠═9187350a-2851-11eb-05f0-d3a6eef190fe
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
