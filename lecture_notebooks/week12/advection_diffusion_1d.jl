### A Pluto.jl notebook ###
# v0.12.10

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
	using Plots
	using PlutoUI
end

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
In this notebook we will restrict ourselves to 1 space dimension.
So we will think about the temperature $T$, for example, being a function 

$$T(t, x)$$

of

- time: $t$
- space: $x$


We want to calculate a value of the temperature $T$ at each point $(t, x)$.

"""

# ╔═╡ 36328b70-277d-11eb-02c7-2f854c1466cc
md"""
## Temperature profiles and discretization
"""

# ╔═╡ 42190984-277d-11eb-1ac2-7d84516c3269
md"""
An ordinary differential equation needs an initial value for each variable. Similarly, we will need an initial *function* $T_0(x)$ that gives us the temperature at each position $x$. Let's suppose that the position is restricted to the interval $[0, L_x]$.

As usual, to represent the continuous function $T_0(x)$ on a computer, we will need to **discretise** it in some way, i.e. *approximate* the continuous function by a *finite* set of numbers in the computer.

The simplest (but far from the only!) discretisation method is to **sample** the function at discrete **grid points** (or **nodes**) $x_i$, for $i = 1, \dots, N_x$. For simplicity we will take these equally spaced, with spacing $x_{i+1} - x_i =: \delta x := L_x / N_x$.
"""

# ╔═╡ d2bed768-277e-11eb-32cf-41f1fedec3cb
md"""
For example, let's consider an initial temperature profile given by a sine curve:
"""

# ╔═╡ e6493da0-277e-11eb-22ff-29752652b576
T₀(x) = sin(2π * x)

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
We call such a function of $x$ at a given time a **temperature profile**. Let's draw it as a function and as a heatmap:
"""

# ╔═╡ af30a0d0-2781-11eb-0274-ab423205facb
md"""
We will denote by $T^0_i$ the initial temperature at grid point number $i$.
"""

# ╔═╡ 646bc32e-284c-11eb-2ce8-5f64b1a49534
md"""
A useful way to think about $T^n_i$ is as the (spatial) average of $T(t_n, x)$ over the interval of positions between neighbouring grid points, so $T_i$ is the average over the interval between $x_i - \frac{\delta x}{2}$ and $x_i + \frac{\delta x}{2}$. We can thus think of the following **piecewise constant** approximation to the original continuous function:
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
## Advection
"""

# ╔═╡ 29444ffe-2780-11eb-0875-095302b5d486
md"""
Now let's think of this as the temperature in a fluid, and let's suppose that the fluid is moving to the right with a constant, uniform speed $U$. (**Uniform** here means that the speed is the same in all parts of the fluid.) Then the temperature profile should also *move with the fluid*. We call a quantity, such as the temperature, that is carried along with the fluid a **tracer**.

If we fix our attention at a single point in space, say the grid point $x_i$, the temperature there will vary over time due to the motion of the fluid. How it varies in time depends on the values at neighbouring grid points, since they determine how much heat will be *transported into* the current cell.
"""

# ╔═╡ 7256778a-2785-11eb-0369-f3b43d5dd203
md"""
Let's think about a time-stepping algorithm, and let $\delta t$ be the duration of a time step. We'll denote by $T^n_i$ the approximate value of $T$ to calculate at position $x_i$ and at the $n$th time step $t_n$, i.e. an approximation of $T(t_n, x_i)$, where $t_n = n \, \delta t$. 

For example, $T^{n+1}_i \simeq T(t_n + \delta t, x_i)$ and $T^{n}_{i+1} \simeq T(t_n, x_i + \delta x)$.

[Note that the superscript $n$ in these algorithms does not denote a power; it's just a label for the time step. We could write $T_i^{(n)}$ instead, but that is annoying to both write and read, so we suppress the parentheses.]
"""

# ╔═╡ 44433a34-2782-11eb-0079-837c9306c5bd
md"""
Suppose the fluid is moving to the right with speed $U$. During a time step of duration $\delta t$, the temperature $T^n_i$ at cell $i$ changes due to the amount of heat that leaves cell $i$, and the amount that enters that cell.

Most of the fluid that starts within cell $i$ remains within that cell during the time step (if the time step is short enough). Only fluid that is within a distance $U \, \delta t$ from the boundary of the cell will cross over that cell. So a *proportion* $(U \, \delta t) / \delta x$ of the amount in cell $i$ crosses the boundary.

Hence, roughly an amount $T^n_i (U \delta t) / \delta x$ will leave cell number $i$ and cross into cell $i+1$ (the cell to the right). Similarly, an amount $T^n_{i-1} (U \delta t) / \delta x$ will *enter* cell $i$ from the neighbouring cell $i-1$ on the left. Hence we have

$$T^{n+1}_i = T^{n}_i + (T^n_{i-1} - T^n_{i})\, U \, \delta t / \delta x.$$
"""

# ╔═╡ 72c0ab0c-2781-11eb-1f59-9b22a52b0be0
md"""
Thus

$$\frac{T^{n+1}_i - T^{n}_i}{\delta t} =  \frac{T^n_{i-1} - T^n_{i}}{\delta x}\, U.$$
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

# ╔═╡ a10266c4-284e-11eb-3433-adee2e0e2d52
md"""
There are many approaches to implementing this numerically. The simplest is to directly transcribe the equation for the $i$th entry of the vector.

Calling `T` the current vector, i.e. $\mathbf{T}^n := (T^n_i)_{i=1, \ldots, N_x}$, and `T′` the new vector at the next time step, we have the following basic expression:

	T′[i] = T[i] + δt * U * (T[i-1] - T[i]) / δx

But now we realise a problem: What should we do when $i=1$? This will try to access the index 0 of the vector `T`, which does not exist!

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
	
	for i in 2:N
		T′[i] = T[i] - δt * U * (T[i] - T[i-1]) / δx
	end

	# periodic boundary:
	T′[1] = T[1] - δt * U * (T[1] - T[N]) / δx
	
	return T′
end

# ╔═╡ 85540de0-286e-11eb-0d00-03435a8c7c83
md"""
We use a function `evolve` that carries out a generic time evolution. This is basically the Euler method again, except now we apply it to a vector of values at different points in space at each step. 
"""

# ╔═╡ af79e360-286e-11eb-2a4d-3d6d7564088c
δt = 0.001;

# ╔═╡ dce9e53a-28f4-11eb-070b-17e10779a38b
U = 0.2;

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
## Diffusion
"""

# ╔═╡ 3c944998-2888-11eb-087d-492b9d0ee32e
md"""
Another key physical process is **diffusion**. This models how temperature or mass spreads out from hot or high concentration regions towards regions where it is cold or where there is a low concentration.

The PDE describing this is the **heat equation**, or **diffusion equation**:
"""

# ╔═╡ 6b7cea44-2888-11eb-0208-990860d6a152
md"""
$$\frac{\partial T}{\partial t} = D \frac{\partial^2 T}{\partial x^2}.$$
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

# ╔═╡ e63cfa84-2889-11eb-1ea2-51726645ddd9
md"""
## Advection--diffusion
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
## Function library
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
@bind n2 Slider(1:length(evolution2), show_value=true)

# ╔═╡ f1b5d130-285a-11eb-001c-67035925f43d
let
	p1 = plot(xs, evolution2[n2], m=:o, xlim=(0, 1), ylim=(-1.1, 1.1), title="t = $(round(ts2[n2], digits=2))", leg=false)
	
	p2 = temperature_heatmap(xs, evolution2[n2])
	
	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]))
end


# ╔═╡ 09bc3c40-288a-11eb-0339-59f0b70e03a3
@bind n3 Slider(1:length(evolution2), show_value=true)

# ╔═╡ 121255d2-288a-11eb-1fa5-9db68af8c232
ts3, evolution3 = evolve(diffusion, xs, δt, 0.01)

# ╔═╡ 175d9902-288a-11eb-3700-390ccd1caa5b
let
	p1 = plot(xs, evolution3[n3], m=:o, xlim=(0, 1), ylim=(-1.1, 1.1), title="t = $(round(ts3[n3], digits=2))", leg=false)
	p2 = temperature_heatmap(xs, evolution3[n3])

	plot(p1, p2, layout = grid(2, 1, heights=[0.9, 0.1]), clim=(-1, 1))
end


# ╔═╡ 73efeed4-28fa-11eb-10c0-8fcfd53b812f
ts4, evolution4 = evolve(diffusion, xs, 0.0001, 0.01, 10.0, x -> (0.45 < x < 0.55) ? 1.0 : 0.0)

# ╔═╡ e74d920a-28fa-11eb-3c91-9133a01effc5
@bind n4 Slider(1:length(evolution4), show_value=true)

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

# ╔═╡ Cell order:
# ╠═e0c0dc94-277e-11eb-379e-83d064a93413
# ╟─00877a4a-277c-11eb-3ec0-e71e4094b404
# ╟─1b25b916-277c-11eb-0274-4b4fb946258d
# ╟─956f5104-277d-11eb-291d-1faef485a5aa
# ╟─36328b70-277d-11eb-02c7-2f854c1466cc
# ╟─42190984-277d-11eb-1ac2-7d84516c3269
# ╟─d2bed768-277e-11eb-32cf-41f1fedec3cb
# ╠═e6493da0-277e-11eb-22ff-29752652b576
# ╟─0d6271c0-286c-11eb-1c9c-3ba039b49d24
# ╠═f17f7734-277e-11eb-25cf-5f2ba2db5aa3
# ╠═fa327c08-286b-11eb-0032-2384998a42a8
# ╟─0db43be2-284c-11eb-2740-4379437fd70c
# ╟─468a0590-2780-11eb-045c-d1f468fc4e50
# ╟─6de1859c-277f-11eb-1ead-8b4794832d59
# ╟─af30a0d0-2781-11eb-0274-ab423205facb
# ╟─646bc32e-284c-11eb-2ce8-5f64b1a49534
# ╟─79ce4b10-284c-11eb-2258-2155f850171d
# ╟─2494daaa-2780-11eb-3084-2317924048ea
# ╟─29444ffe-2780-11eb-0875-095302b5d486
# ╟─7256778a-2785-11eb-0369-f3b43d5dd203
# ╟─44433a34-2782-11eb-0079-837c9306c5bd
# ╟─72c0ab0c-2781-11eb-1f59-9b22a52b0be0
# ╟─e5761990-278b-11eb-134e-7954b577b1ac
# ╟─2033364e-278c-11eb-2936-17598ce14a41
# ╟─e9a37908-278c-11eb-278e-9bd155f0cae6
# ╟─a10266c4-284e-11eb-3433-adee2e0e2d52
# ╟─e542a8da-284e-11eb-3297-6bbbf052284b
# ╠═b15f4f44-284b-11eb-37c5-ab0153f7fe92
# ╟─85540de0-286e-11eb-0d00-03435a8c7c83
# ╠═af79e360-286e-11eb-2a4d-3d6d7564088c
# ╠═dce9e53a-28f4-11eb-070b-17e10779a38b
# ╠═02a893e4-2852-11eb-358a-371459191da7
# ╠═e6ae447e-2851-11eb-3fe1-096459167f2b
# ╟─014e2530-2852-11eb-103f-1d647cb999b0
# ╟─8c05e3cc-2858-11eb-1e1c-9781c30738c3
# ╠═a29fecac-285a-11eb-14b0-9313f8994fbb
# ╠═e42ec13e-285a-11eb-3cc0-7dc41ed5495b
# ╠═f60a8b5e-285a-11eb-0d35-8daf23cf92ae
# ╟─f1b5d130-285a-11eb-001c-67035925f43d
# ╟─c59388ea-286e-11eb-0f21-eb18e5ba516f
# ╟─3c944998-2888-11eb-087d-492b9d0ee32e
# ╟─6b7cea44-2888-11eb-0208-990860d6a152
# ╟─68db3372-2888-11eb-1b03-b5ebca4c2bd5
# ╟─d6131ad0-2889-11eb-3085-15d17e33ee7a
# ╠═630314bc-2868-11eb-1b93-b7b08a4b2887
# ╠═121255d2-288a-11eb-1fa5-9db68af8c232
# ╠═09bc3c40-288a-11eb-0339-59f0b70e03a3
# ╟─175d9902-288a-11eb-3700-390ccd1caa5b
# ╠═73efeed4-28fa-11eb-10c0-8fcfd53b812f
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
