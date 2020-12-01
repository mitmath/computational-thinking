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

# ╔═╡ 232c24de-0e30-11eb-1544-53cb0b45ec9b
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		"Colors",
		"Plots",
		"PlutoUI",
		])
	using Colors
	using Plots
	using PlutoUI
end

# ╔═╡ beed7b48-0e2b-11eb-2805-edf0be651fc3
md"""
### Lecture 22: Solving Partial Differential Equations (PDEs) Numerically
**Part I: One-dimensional advection and diffusion**

#### 1) Advection

Consider the following differential equation for temperature $T(x,t)$,

$\frac{\partial T}{\partial t} = - U \frac{\partial T}{\partial x}$

which describes the rate of change of temperature due to a uniform flow of speed $U$ in the $\mathbf{x}$ direction.

**Notation**:
Since this differential equation includes derivatives in both time $t$ **and** space $x$, we replace the *ordinary* deriative symbol $d$ with a *partial* derivative symbol $\partial$, and call the equation a **partial differential equation (PDE)**.

#### 1.1) Discretizing in time: forward finite difference
**A.k.a. *Euler's Method*$\,$**

As in our solution of the "zero-dimenisonal" energy balance model ODE, we begin by discretizing time using a *forward finite difference* scheme:

$\frac{T_{n+1}-T_{n}}{\Delta t} = - U \frac{\partial T}{\partial x},$

where $\Delta t \equiv t_{n+1} - t_{n}$ is a uniform discrete **timestep**.
"""

# ╔═╡ e74322be-12d6-11eb-3f27-f17821669699
md"
#### 1.2) Discretizing in space: centered finite difference

We now need to discretize the spatial derivative. Unlike for differencing in time, we no longer have a prefered direction for the discretization and so we use a *centered finite difference*:

$\frac{T_{n+1,\, i}-T_{n,\, i}}{\Delta t} = - U \frac{T_{n,\, i+1} - T_{n,\, i-1}}{2 \Delta x},$

where $\Delta x \equiv x_{i+1} - x_{i} = x_{i} - x_{i-1}$ is a uniform discrete **grid spacing**.
"

# ╔═╡ c9a1719a-12d6-11eb-1c8c-13e1f75bc852
md"**Note:** You should think of the *centered* finite difference average of the *right* (forward) and *left* (backward) finite differences:

$\frac{1}{2}\left(\frac{T_{n,\, i+1} - T_{n,\, i}}{\Delta x} + \frac{T_{n,\, i} - T_{n,\, i-1}}{\Delta x} \right) = \frac{T_{n,\, i+1} - T_{n,\, i-1}}{2 \Delta x}$

"

# ╔═╡ c3f99436-0f49-11eb-33b6-e78c150d4ff5
md"""
#### 1.3) Algorithmic procedure: time-stepping

Just as before, we re-order the equation to solve for the temperature of the $i$th grid cell at the next timestep $t_{n+1}$,

$T_{n+1,\, i} = T_{n,\, i} + \Delta t \left(-U \frac{T_{n,\, i+1} - T_{n,\, i-1}}{2 \Delta x} \right),$

which allows us to recursively advance in time, for each $i$, given some initial condition $T_{0,\, i}$ for all $i$.

#### 1.4) Numerical grid and boundary conditions
Consider solving this on a grid $i \in [1,\, N_{i}]$. How do we handle the edge case $i=1$, where $T_{n+1,\, 1}$ depends on $T_{n+1,\, 0}$, which is undefined?

For both this point $i=1$ and the other extreme $i=N_{i}$, we need a **boundary condition**. There are a number of ways of doing this, and we will explore some alternative kinds of boundary conditions later, but the simplest is a *periodic boundary condition*, which wraps the grid around by setting $T_{n,\, 0} = T_{n,\, N_{i}}$ and $T_{n,\, 1} = T_{n,\, N_{i}+1}$
"""

# ╔═╡ 0967dc46-0f4d-11eb-13b2-2b2042595b6e
md"#### 2) Numerical implementation"

# ╔═╡ 19273c8a-0f4d-11eb-3caf-678f073c6b1a
md"##### 2.1) Setting up the model parameters

To keep things simple, let us consider our temperature equation as a model of temperature variations in a one-dimensional ocean current of length $L=1$ m and with a speed $U = 1$ m/s.

The choice of the **discretization resolution** $N_{i}$ is up to the modeller, but here we make it $N_{i} = 10$ because we will be able to easily pick out each of the individual grid cells in plots below.
"

# ╔═╡ e700c752-0e2d-11eb-2c61-3959bdba269a
begin
	nx = 10
	Lx = 1.
	Δx = Lx/nx
	Δt = 0.001
	U = 1.
	
	x = Δx/2.:Δx:Lx
end;

# ╔═╡ 5b1b6802-0e2e-11eb-1fa6-1ddd5478cc54
begin
	# Initial conditions
	T = sin.(2π*x);
	t = [0.]
end;

# ╔═╡ 4463cf8c-0ef8-11eb-2c6e-45d982d5687a
function advect(T)
	return U*(circshift(T, (1)) .- circshift(T, (-1)))/(2Δx)
end

# ╔═╡ 67cb0ed2-0efa-11eb-2645-495dba94ea64
function timestep!(t, T)
	T .+= Δt*(advect(T))
	t .+= Δt
end

# ╔═╡ ba1ea938-0f44-11eb-0fac-cd1afe507d57
timestepButton = @bind go Button("Timestep")

# ╔═╡ 18a3f9dc-0e6d-11eb-0b31-0b5296c2e83b
begin
	⏩ = nothing
	go
	nT = 50
	for i = 1:nT
		timestep!(t, T)
	end
end;

# ╔═╡ f2c7638a-0e34-11eb-2210-9f9b0c3519fe
function temperature_heatmap(T)
	p = plot(xticks=x, yticks=nothing, size=(700,90))
	plot!(p, x, [0.], reshape(T, (size(T)...,1))', st=:heatmap, clims=(-1., 1.))
end;

# ╔═╡ b19bfb58-0f4e-11eb-218f-8d930b7afff6
md"#### 2) Diffusion

$\frac{\partial T}{\partial t} = \kappa \frac{\partial^{2} T}{\partial x^{2}}$


Again, we discretize the equation by considering the derivatives one at a time:

$\frac{T_{n+1,\, i} - T_{n,\, i}}{\Delta t} = \kappa \frac{\partial^{2} T}{\partial x^{2}}$

$\frac{T_{n+1,\, i} - T_{n,\, i}}{\Delta t} = \kappa \left( \frac{\frac{\partial T}{\partial x}|_{n,\, i+0.5} - \frac{\partial T}{\partial x}|_{n,\, i-0.5}}{\Delta x} \right)$

$\frac{T_{n+1,\, i} - T_{n,\, i}}{\Delta t} = \kappa \left( \frac{\frac{T_{n,\, i+1} - T_{n,\, i}}{\Delta x} - \frac{T_{n,\, i} - T_{n,\, i-1}}{\Delta x}}{\Delta x}\right)$

$\frac{T_{n+1,\, i} - T_{n,\, i}}{\Delta t} = \kappa \left( \frac{T_{n,\, i+1} - 2 T_{n,\, i} + T_{n,\, i-1}}{(\Delta x)^{2}}\right)$
"



# ╔═╡ 37bed6e8-12da-11eb-1c36-c7f92fe732e4
κ = 0.05

# ╔═╡ 3e1d44b6-12da-11eb-16ac-2524d0e0d900
function diffuse(T)
	return κ*(circshift(T, (1)) .- 2*T .+ circshift(T, (-1)))/(Δx^2)
end

# ╔═╡ 43d1272a-2113-11eb-1d03-c948d11a8423
# function timestep!(t, T)
# 	T .+= Δt*(diffuse(T))
# 	t .+= Δt
# end

# ╔═╡ 74a36fd4-2113-11eb-2d3e-3be5e4318dea
timestepButton

# ╔═╡ d2c101c8-0f4e-11eb-0c4f-0972be924ce1
md"#### 3) Advection-Diffusion"

# ╔═╡ 7c490fd2-2113-11eb-3239-f72cc77c0b53
# function timestep!(t, T)
# 	T .+= Δt*(advect(T) .+ diffuse(T))
# 	t .+= Δt
# end

# ╔═╡ 894b97f4-2113-11eb-3b86-2986a6cd4fd1
timestepButton

# ╔═╡ b00f7bec-12da-11eb-3e20-7769cc2bd0ec
md"
#### 4) Finite differences as kernels acting on an array

##### 4.1) Analogies between image processing and PDEs

##### 4.1.1) Blurring (Gaussian kernel) vs. Laplacian operator

##### 4.1.2) Edge detection (Sobel kernel) vs. Gradient operator
"

# ╔═╡ 70ae3138-0f44-11eb-1a8d-d3b5a39c1b42
md"""#### Pluto Book-keeping"""

# ╔═╡ 845e102a-0f44-11eb-3935-2d9a0efecedc
as_svg(x) = PlutoUI.Show(MIME"image/svg+xml"(), repr(MIME"image/svg+xml"(), x))

# ╔═╡ 00cc530a-0e35-11eb-133b-ef8e30ea7b12
begin
	⏩
	p1 = plot(x, T, label="Temperature", ylim=[-1.1, 1.1], xlim=[0., 1.], marker=:c)
	annotate!(p1, [(0.05, 0.9, string("t = ", round(t[1], digits=2)))])
	p2 = temperature_heatmap(T)
	p = plot(p1, p2, layout=grid(2, 1, heights=[0.7 , 0.3]), size=(680,250))
	as_svg(p)
end

# ╔═╡ 4c5b62fa-2113-11eb-14ff-2bd776efe96c
as_svg(p)

# ╔═╡ 869c4be8-2113-11eb-0703-f905fe93142f
as_svg(p)

# ╔═╡ Cell order:
# ╟─beed7b48-0e2b-11eb-2805-edf0be651fc3
# ╟─e74322be-12d6-11eb-3f27-f17821669699
# ╟─c9a1719a-12d6-11eb-1c8c-13e1f75bc852
# ╟─c3f99436-0f49-11eb-33b6-e78c150d4ff5
# ╟─0967dc46-0f4d-11eb-13b2-2b2042595b6e
# ╟─19273c8a-0f4d-11eb-3caf-678f073c6b1a
# ╠═e700c752-0e2d-11eb-2c61-3959bdba269a
# ╠═5b1b6802-0e2e-11eb-1fa6-1ddd5478cc54
# ╠═4463cf8c-0ef8-11eb-2c6e-45d982d5687a
# ╠═67cb0ed2-0efa-11eb-2645-495dba94ea64
# ╠═ba1ea938-0f44-11eb-0fac-cd1afe507d57
# ╠═00cc530a-0e35-11eb-133b-ef8e30ea7b12
# ╠═18a3f9dc-0e6d-11eb-0b31-0b5296c2e83b
# ╠═f2c7638a-0e34-11eb-2210-9f9b0c3519fe
# ╟─b19bfb58-0f4e-11eb-218f-8d930b7afff6
# ╠═37bed6e8-12da-11eb-1c36-c7f92fe732e4
# ╠═3e1d44b6-12da-11eb-16ac-2524d0e0d900
# ╠═43d1272a-2113-11eb-1d03-c948d11a8423
# ╠═74a36fd4-2113-11eb-2d3e-3be5e4318dea
# ╠═4c5b62fa-2113-11eb-14ff-2bd776efe96c
# ╟─d2c101c8-0f4e-11eb-0c4f-0972be924ce1
# ╠═7c490fd2-2113-11eb-3239-f72cc77c0b53
# ╠═894b97f4-2113-11eb-3b86-2986a6cd4fd1
# ╠═869c4be8-2113-11eb-0703-f905fe93142f
# ╟─b00f7bec-12da-11eb-3e20-7769cc2bd0ec
# ╟─70ae3138-0f44-11eb-1a8d-d3b5a39c1b42
# ╠═232c24de-0e30-11eb-1544-53cb0b45ec9b
# ╠═845e102a-0f44-11eb-3935-2d9a0efecedc
