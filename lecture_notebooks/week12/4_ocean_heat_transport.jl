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

# ╔═╡ 9c8a7e5a-12dd-11eb-1b99-cd1d52aefa1d
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		"Plots",
		"PlutoUI",
		"Images",
		"FileIO",
		"ImageMagick",
		"ImageIO",
		"OffsetArrays"
	])
	using Statistics
	using Plots
	using PlutoUI
	using Images
	using OffsetArrays
end

# ╔═╡ 0f8db6f4-2113-11eb-18b4-21a469c67f3a
md"""
### Lecture 23: Solving Partial Differential Equations (PDEs) Numerically
**Part II: Heat transport by ocean currents (two-dimensional advection and diffusion)**

Guest Lecturer: Henri F. Drake (MIT Climate Science and Oceanography PhD Student)
"""

# ╔═╡ ed741ec6-1f75-11eb-03be-ad6284abaab8
html"""
<iframe width="700" height="394" src="https://www.youtube-nocookie.com/embed/6_GQuVopmUM?start=15" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ ac759b96-2114-11eb-24cb-d50b556f4142
md"""
### 1) Background: two-dimensional advection-diffusion

##### 1.1) The two-dimensional advection-diffusion equation
Recall from **Lecture 22** that the one-dimensional advection-diffusion equation is written as

$\frac{\partial T(x,t)}{\partial t} = -U \frac{\partial T}{\partial x} + \kappa \frac{\partial^{2} T}{\partial x^{2}},$

where $T(x, t)$ is the temperature, $U$ is a constant *advective velocity* and $\kappa$ is the *diffusivity*.

The two-dimensional advection diffusion equation adds advection and diffusion operators acting in a *second spatial dimension* $y$ (orthogonal to $x$):

$\frac{\partial T(x,y,t)}{\partial t} = u(x,y) \frac{\partial T}{\partial x} + v(x,y) \frac{\partial T}{\partial y} + \kappa \left( \frac{\partial^{2} T}{\partial x^{2}} + \frac{\partial^{2} T}{\partial y^{2}} \right),$

where $\vec{u}(x,y) = (u, v) = u\,\mathbf{\hat{x}} + v\,\mathbf{\hat{y}}$ is a velocity vector field.

Throughout the rest of the Climate Modelling module, we will consider $x$ to be the *longitundinal* direction (positive from west to east) and $y$ to the be the *latitudinal* direction (positive from south to north).
"""

# ╔═╡ 3a4a1aea-2118-11eb-30a9-57b87f2ddfae
begin
	reviewBox = @bind show_review CheckBox(default=false)
	md"""
	##### 1.2) Review of multivariable calculus identities and notation

	*Check the box for a review* $(reviewBox)
	

	"""
end

# ╔═╡ 023779a0-2a95-11eb-35b5-7be93c43afaf
if show_review
	md"""
	Conventionally, the two-dimensional advection-diffusion equation is written more succintly as

	$\frac{\partial T(x,y,t)}{\partial t} = - \vec{u} \cdot \nabla T + \kappa \nabla^{2} T,$

	using the following shorthand notation.

	The **gradient** operator is defined as 

	$\nabla \equiv (\frac{\partial}{\partial x}, \frac{\partial }{\partial y})$

	such that

	$\nabla T = (\frac{\partial T}{\partial x}, \frac{\partial T}{\partial y})$ and 

	$\vec{u} \cdot \nabla T = (u, v) \cdot (\frac{\partial T}{\partial x}, \frac{\partial T}{\partial y}) = u \frac{\partial T}{\partial x} + v\frac{\partial T}{\partial y}.$

	The **Laplacian** operator $\nabla^{2}$ (sometimes denoted $\Delta$) is defined as 

	$\nabla^{2} = \frac{\partial^{2}}{\partial x^{2}} + \frac{\partial^{2}}{\partial y^{2}}$

	such that

	$\nabla^{2} T = \frac{\partial^{2} T}{\partial x^{2}} + \frac{\partial^{2} T}{\partial y^{2}}.$

	The **divergence** operator is defined as $\nabla \cdot [\quad]$, such that

	$\nabla \cdot \vec{u} = \left(\frac{\partial}{\partial x}, \frac{\partial}{\partial x} \right) \cdot (u,v) = \frac{\partial u}{\partial x} + \frac{\partial v}{\partial y}.$

	**Note:** Since seawater is largely incompressible, we can approximate ocean currents as a *non-divergent flow*, with $\nabla \cdot \vec{u} = \frac{\partial u}{\partial x} + \frac{\partial v}{\partial y} = 0$. Among other implications, this allows us to write:

	\begin{align}
	\vec{u} \cdot \nabla T&=
	u\frac{\partial T(x,y,t)}{\partial x} + v\frac{\partial T(x,y,t)}{\partial y}\newline &=
	u\frac{\partial T}{\partial x} + v\frac{\partial T}{\partial y} + T\left(\frac{\partial u}{\partial x} + \frac{\partial v}{\partial y}\right)\newline &=
	\left( u\frac{\partial T}{\partial x} + T\frac{\partial u}{\partial x} \right) +
	\left( v\frac{\partial T}{\partial y} + \frac{\partial v}{\partial y} \right)
	\newline &=
	\frac{\partial (uT)}{\partial x} + \frac{\partial (vT)}{\partial x}\newline &=
	\nabla \cdot (\vec{u}T)
	\end{align}

	using the product rule (separately in both $x$ and $y$).
	
	##### 1.3) The flux-form two-dimensional advection-diffusion equation

	This lets us finally re-write the two-dimensional advection-diffusion equation as:

	$\frac{\partial T}{\partial t} = - \nabla \cdot (\vec{u}T) + \kappa \nabla^{2} T$

	which is the form we will use in our numerical algorithm below.
	"""
end

# ╔═╡ b1b5625e-211a-11eb-3ee1-3ba9c9cc375a
md"""
### 2) Numerical implementation

##### 2.1) Discretizing advection in two dimensions

In Lecture XX we saw that in one dimension we can discretize a first-partial derivative in space using the *centered finite difference*

$\frac{\partial T(x_{i}, t_{n})}{\partial x} \approx \frac{T_{i+1}^{n} - T_{i-1}^{n}}{2 \Delta x}.$

In two dimensions, we discretize the partial derivative the exact same way, except that we also need to keep track of the cell index $j$ in the $y$ dimension:

$\frac{\partial T(x_{i}, y_{j}, t_{n})}{\partial x} \approx \frac{T_{i+1,\, j}^{n} - T_{i-1,\,j}^{n}}{2 \Delta x}.$

The *x-gradient kernel* below, implemented using the `OffsetArray` type, is shown below, and is reminiscent of the *edge-detection* or *sharpening* kernels used in image processing and machine learning:
"""

# ╔═╡ 3578b158-2a97-11eb-0771-bf6d82d3b6d1
md"""
The first-order partial derivative in $y$ is similarly discretized as:

$\frac{\partial T(x_{i}, y_{j}, t_{n})}{\partial y} \approx \frac{T_{i,\, j+1}^{n} - T_{i,\,j-1}^{n}}{2 \Delta y}.$

Its kernel is shown below.
"""

# ╔═╡ 7f3c9550-2a97-11eb-1549-455009025872
md"""
Now that we have discretized the two derivate terms, we can write out the *advective tendency* for computing $T_{i, j, n+1}$ as

$u\frac{\partial T}{\partial x} + v\frac{\partial T}{\partial y} \approx u_{i,\, j}^{n} \frac{T_{i,\, j+1}^{n} - T_{i,\,j-1}^{n}}{2 \Delta y} + v_{i,\, j}^{n} \frac{T_{i,\, j+1}^{n} - T_{i,\,j-1}^{n}}{2 \Delta y}.$

We implement this in julia as a series of methods for the `advect` function. The first method computes the advective tendency (as a single `Float64` type) for the $(i,j)$ grid cell while the second method returns an array of the tendencies for each grid cell using two nested for loops.
"""

# ╔═╡ 0127bca6-2a99-11eb-16a0-8d7af66694f8
md"""
##### 2.2) Discretizing diffusion in two dimensions

Just as with advection, the process for discretizing the diffusion operators effectively consists of repeating the one-dimensional process for $x$ in a second dimension $y$, separately:

$\kappa \left( \frac{\partial^{2} T}{\partial x^{2}} + \frac{\partial^{2} T}{\partial y^{2}} \right) = \kappa \left(
\frac{T_{i+1,\;j}^{n} - 2T_{i,\;j}^{n} + T_{i-1,\;j}^{n}}{\left( \Delta x \right)^{2}} +
\frac{T_{i,\;j+1}^{n} - 2T_{i,\;j}^{n} + T_{i,\;j-1}^{n}}{\left( \Delta y \right)^{2}}
\right)$

The corresponding $x$ and $y$ second-derivative kernels are shown below:
"""

# ╔═╡ eac507ce-2a99-11eb-3eba-0780a4a7e078
md"""
Just as we did with advection, we implement a `diffuse` function using multiple dispatch:
"""

# ╔═╡ 09f179c0-2a9a-11eb-1d0f-e59012f9e77b
md"""##### 2.3) No-flux boundary conditions

We want to impose the no-flux boundary conditions, which states that

$u\frac{\partial T}{\partial x} = \kappa \frac{\partial T}{\partial x} = 0$ at $x$ boundaries and 

$v\frac{\partial T}{\partial y} = \kappa \frac{\partial T}{\partial y} = 0$ at the $y$ boundaries.

To impose this, we treat $i=1$ and $i=N_{x}$ as *ghost cells*, which do not do anything expect help us impose these boundaries conditions. Discretely, the boundary fluxes between $i=1$ and $i=2$ vanish if

$\dfrac{T_{2,\,j}^{n} -T_{1,\,j}^{n}}{\Delta x} = 0$ or 

$T_{1,\,j}^{n} = T_{2,\,j}^{n}.$

Thus, we can implement the boundary conditions by updating the temperature of the ghost cells to match their interior-point neighbors:
"""

# ╔═╡ 7caca2fa-2a9a-11eb-373f-156a459a1637
function update_ghostcells!(A::Array{Float64,2}; option="no-flux")
	Atmp = @view A[:,:]
	if option=="no-flux"
		A[1, :] = Atmp[2, :]; Atmp[end, :] = Atmp[end-1, :]
		A[:, 1] = Atmp[:, 2]; Atmp[:, end] = Atmp[:, end-1]
	end
end

# ╔═╡ 1f06bc34-2a9b-11eb-1030-ff12d103176c
md"Let's get a feel for what this is actually doing"

# ╔═╡ 2ef2f0cc-2a9b-11eb-03c6-5d8b4c6ae822
begin
	A = rand(Float64, 6,6);
	heatmap(A, size=(200,200))
end |> as_svg

# ╔═╡ 4558d4f8-2a9b-11eb-1f56-416975bcd180
begin
	Acopy = copy(A);
	update_ghostcells!(Acopy)
	heatmap(Acopy, size=(200,200))
end |> as_svg

# ╔═╡ 74aa7512-2a9c-11eb-118c-c7a5b60eac1b
md"""
##### 2.4) Timestepping
"""

# ╔═╡ 13eb3966-2a9a-11eb-086c-05510a3f5b80
md"""
##### 2.5) Data structures
"""

# ╔═╡ cd2ee4ca-2a06-11eb-0e61-e9a2ecf72bd6
struct Grid
	N::Int64
	L::Float64
	
	Δx::Float64
	Δy::Float64
	
	x::Array{Float64, 2}
	y::Array{Float64, 2}
	
	Nx::Int64
	Ny::Int64
	
	function Grid(N, L)
		Δx = L/N # [m]
		Δy = L/N # [m]
		
		x = 0. -Δx/2.:Δx:L +Δx/2.
		x = reshape(x, (1, size(x,1)))
		y = -L -Δy/2.:Δy:L +Δy/2.
		y = reshape(y, (size(y,1), 1))

		Nx, Ny = size(x, 2), size(y, 1)
		
		return new(N, L, Δx, Δy, x, y, Nx, Ny)
	end
end

# ╔═╡ 2a93145e-2a09-11eb-323b-01817062aa89
struct Parameters
	κ::Float64
end

# ╔═╡ 32663184-2a81-11eb-0dd1-dd1e10ed9ec6
abstract type ClimateModel end

# ╔═╡ d3796644-2a05-11eb-11b8-87b6e8c311f9
begin
	struct OceanModel <: ClimateModel
		G::Grid
		P::Parameters

		u::Array{Float64, 2}
		v::Array{Float64, 2}
	end

	OceanModel(G, P) = OceanModel(G, P, zeros(G), zeros(G))
	OceanModel(G) = OceanModel(G, Parameters(1.e4), zeros(G), zeros(G))
end;

# ╔═╡ f92086c4-2a74-11eb-3c72-a1096667183b
begin
	mutable struct ClimateModelSimulation{ModelType<:ClimateModel}
		model::ModelType
		
		T::Array{Float64, 2}
		Δt::Float64
		
		iteration::Int64
	end
	
	ClimateModelSimulation(C::ModelType, T, Δt) where ModelType = 
		ClimateModelSimulation{ModelType}(C, T, Δt, 0)
end

# ╔═╡ 31cb0c2c-2a9a-11eb-10ba-d90a00d8e03a
md"""
##### 3) Simulating heat transport by advective & diffusive ocean currents
"""

# ╔═╡ 981ef38a-2a8b-11eb-08be-b94be2924366
md"**Simulation controls**"

# ╔═╡ d042d25a-2a62-11eb-33fe-65494bb2fad5
begin
	quiverBox = @bind show_quiver CheckBox(default=false)
	anomalyBox = @bind show_anomaly CheckBox(default=false)
	md"""
	*Click to show the velocity field* $(quiverBox) *or to show temperature **anomalies** instead of absolute values* $(anomalyBox)
	"""
end

# ╔═╡ c20b0e00-2a8a-11eb-045d-9db88411746f
begin
	U_ex_Slider = @bind U_ex Slider(-4:1:8, default=0, show_value=false);
	md"""
	$(U_ex_Slider)
	"""
end

# ╔═╡ 6dbc3d34-2a89-11eb-2c80-75459a8e237a
begin
	md"*Vary the current speed U:*  $(2. ^U_ex) [× reference]"
end

# ╔═╡ 933d42fa-2a67-11eb-07de-61cab7567d7d
begin
	κ_ex_Slider = @bind κ_ex Slider(0.:1.e3:1.e5, default=1.e4, show_value=true)
	md"""
	*Vary the diffusivity κ:* $(κ_ex_Slider) [m²/s]
	"""
end

# ╔═╡ c9ea0f72-2a67-11eb-20ba-376ca9c8014f
@bind go_ex Clock(0.1)

# ╔═╡ c3f086f4-2a9a-11eb-0978-27532cbecebf
md"""
**Some unit tests for verification**
"""

# ╔═╡ ad7b7ed6-2a9c-11eb-06b7-0f5595167575
function CFL_adv(sim::ClimateModelSimulation)
	maximum(sqrt.(sim.model.u.^2 + sim.model.v.^2)) * sim.Δt / sim.model.G.Δx
end

# ╔═╡ a04d3dee-2a9c-11eb-040e-7bd2facb2eaa
md"""
# Appendix
"""

# ╔═╡ 16905a6a-2a78-11eb-19ea-81adddc21088
Nvec = 1:25

# ╔═╡ c0e46442-27fb-11eb-2c94-15edbda3f84d
function plot_state(sim::ClimateModelSimulation; clims=(-1.1,1.1), 
		show_quiver=true, show_anomaly=false, IC=nothing)
	
	model = sim.model
	grid = sim.model.G
	
	
	p = plot(;
		xlabel="longitudinal distance [km]", ylabel="latitudinal distance [km]",
		clabel="Temperature",
		yticks=( (-grid.L:1000e3:grid.L), Int64.(1e-3*(-grid.L:1000e3:grid.L)) ),
		xticks=( (0:1000e3:grid.L), Int64.(1e-3*(0:1000e3:grid.L)) ),
		xlims=(0., grid.L), ylims=(-grid.L, grid.L),
		)
	
	X = repeat(grid.x, grid.Ny, 1)
	Y = repeat(grid.y, 1, grid.Nx)
	if show_anomaly
		arrow_col = :black
		maxdiff = maximum(abs.(sim.T .- IC))
		heatmap!(p, grid.x[:], grid.y[:], sim.T .- IC, clims=(-1.1, 1.1),
			color=:balance, colorbar_title="Temperature anomaly [°C]", linewidth=0.,
			size=(400,530)
		)
	else
		arrow_col = :white
		heatmap!(p, grid.x[:], grid.y[:], sim.T,
			color=:thermal, levels=clims[1]:(clims[2]-clims[1])/21.:clims[2],
			colorbar_title="Temperature [°C]", clims=clims,
			linewidth=0., size=(400,520)
		)
	end
	
	annotate!(p,
		50e3, 6170e3,
		text(
			string("t = ", Int64(round(sim.iteration*sim.Δt/(60*60*24))), " days"),
			color=:black, :left, 9
		)
	)
	
	if show_quiver
		Nq = grid.N ÷ 5
		quiver!(p,
			X[(Nq+1)÷2:Nq:end], Y[(Nq+1)÷2:Nq:end],
			quiver=grid.L*4 .*(model.u[(Nq+1)÷2:Nq:end], model.v[(Nq+1)÷2:Nq:end]),
			color=arrow_col, alpha=0.7
		)
	end
	
	as_png(p)
end

# ╔═╡ c0298712-2a88-11eb-09af-bf2c39167aa6
md"""##### Computing the velocity field for a single circular vortex
"""

# ╔═╡ e3ee80c0-12dd-11eb-110a-c336bb978c51
begin
	∂x(ϕ, Δx) = (ϕ[:,2:end] - ϕ[:,1:end-1])/Δx
	∂y(ϕ, Δy) = (ϕ[2:end,:] - ϕ[1:end-1,:])/Δy
	
	xpad(ϕ) = hcat(zeros(size(ϕ,1)), ϕ, zeros(size(ϕ,1)))
	ypad(ϕ) = vcat(zeros(size(ϕ,2))', ϕ, zeros(size(ϕ,2))')
	
	xitp(ϕ) = 0.5*(ϕ[:,2:end]+ϕ[:,1:end-1])
	yitp(ϕ) = 0.5*(ϕ[2:end,:]+ϕ[1:end-1,:])
	
	function diagnose_velocities(ψ, G)
		u = xitp(∂y(ψ, G.Δy/G.L))
		v = yitp(-∂x(ψ, G.Δx/G.L))
		return u,v
	end
end

# ╔═╡ df706ebc-2a63-11eb-0b09-fd9f151cb5a8
function impose_no_flux!(u, v)
	u[1,:] .= 0.; v[1,:] .= 0.;
	u[end,:] .= 0.; v[end,:] .= 0.;
	u[:,1] .= 0.; v[:,1] .= 0.;
	u[:,end] .= 0.; v[:,end] .= 0.;
end

# ╔═╡ e2e4cfac-2a63-11eb-1b7f-9d8d5d304b43
function PointVortex(G; Ω=1., a=0.2, x0=0.5, y0=0.)
	x = reshape(0. -G.Δx/(G.L):G.Δx/G.L:1. +G.Δx/(G.L), (1, G.Nx+1))
	y = reshape(-1. -G.Δy/(G.L):G.Δy/G.L:1. +G.Δy/(G.L), (G.Ny+1, 1))
	
	function ψ̂(x,y)
		r = sqrt.((y .-y0).^2 .+ (x .-x0).^2)
		
		stream = -Ω/4*r.^2
		stream[r .> a] = -Ω*a^2/4*(1. .+ 2*log.(r[r .> a]/a))
		
		return stream
	end
		
	u, v = diagnose_velocities(ψ̂(x, y), G)
	impose_no_flux!(u, v)
	
	return u,v
end

# ╔═╡ bb084ace-12e2-11eb-2dfc-111e90eabfdd
md"""##### Computing a quasi-realistic ocean velocity field $\vec{u} = (u, v)$
Our velocity field is given by an analytical solution to the classic wind-driven gyre
problem, which is given by solving the fourth-order partial differential equation:

$- \epsilon_{M} \hat{\nabla}^{4} \hat{\Psi} + \frac{\partial \hat{\Psi} }{ \partial \hat{x}} = \nabla \times \hat{\tau} \mathbf{z},$

where the hats denote that all of the variables have been non-dimensionalized and all of their constant coefficients have been bundles into the single parameter $\epsilon_{M} \equiv \dfrac{\nu}{\beta L^3}$.

The solution makes use of an advanced *asymptotic method* (valid in the limit that $\epsilon \ll 1$) known as *boundary layer analysis* (see MIT course 18.305 to learn more). 
"""



# ╔═╡ ecaab27e-2a16-11eb-0e99-87c91e659cf3
function DoubleGyre(G; β=2e-11, τ₀=0.1, ρ₀=1.e3, ν=1.e5, κ=1.e5, H=1000.)
	ϵM = ν/(β*G.L^3)
	ϵ = ϵM^(1/3.)
	x = reshape(0. -G.Δx/(G.L):G.Δx/G.L:1. +G.Δx/(G.L), (1, G.Nx+1))
	y = reshape(-1. -G.Δy/(G.L):G.Δy/G.L:1. +G.Δy/(G.L), (G.Ny+1, 1))
	
	ψ̂(x,y) = π*sin.(π*y) * (
		1 .- x - exp.(-x/(2*ϵ)) .* (
			cos.(√3*x/(2*ϵ)) .+
			(1. /√3)*sin.(√3*x/(2*ϵ))
			)
		.+ ϵ*exp.((x .- 1.)/ϵ)
	)
		
	u, v = (τ₀/ρ₀)/(β*G.L*H) .* diagnose_velocities(ψ̂(x, y), G)
	impose_no_flux!(u, v)
	
	return u, v
end

# ╔═╡ e59d869c-2a88-11eb-2511-5d5b4b380b80
md"""
##### Some simple initial temperature fields
"""

# ╔═╡ c4424838-12e2-11eb-25eb-058344b39c8b
linearT(G) = 0.5*(1. .+[ -(y/G.L) for y in G.y[:, 1], x in G.x[1, :] ])

# ╔═╡ 3d12c114-2a0a-11eb-131e-d1a39b4f440b
function InitBox(G; value=1., nx=2, ny=2, xspan=false, yspan=false)
	T = zeros(G)
	T[G.Ny÷2-ny:G.Ny÷2+ny, G.Nx÷2-nx:G.Nx÷2+nx] .= value
	if xspan
		T[G.Ny÷2-ny:G.Ny÷2+ny, :] .= value
	end
	if yspan
		T[:, G.Nx÷2-nx:G.Nx÷2+nx] .= value
	end
	return T
end

# ╔═╡ 863a6330-2a08-11eb-3992-c3db439fb624
begin
	G = Grid(10, 6.e6);
	P = Parameters(κ_ex);
	
	#u, v = zeros(G), zeros(G)
	u, v = PointVortex(G, Ω=0.5)
	# u, v = DoubleGyre(G)

	# IC = InitBox(G)
	IC = InitBox(G, xspan=true)
	# IC = linearT(G)
	
	model = OceanModel(G, P, u*2. ^U_ex, v*2. ^U_ex)
	Δt = 12*60*60
	
	ocean_sim = ClimateModelSimulation(model, copy(IC), Δt)
end;

# ╔═╡ dc9d12d0-2a9a-11eb-3dae-85b3b6029658
begin
	heat_capacity = 51.
	total_heat_content = sum(heat_capacity*ocean_sim.T*(ocean_sim.model.G.Δx*ocean_sim.model.G.Δy))*1e-15
	mean_temp = mean(ocean_sim.T)
end;

# ╔═╡ bff89550-2a9a-11eb-3038-d70249c96219
begin
	#go_ex
	md"""
	Let's make sure our model conserves energy. We have not added any energy to the system: advection and diffusion just move the energy around. The total heat content is $(round(total_heat_content, digits=3)) peta-Joules and the average temperature is $(round(mean_temp, digits=2)) °C.
	"""
end

# ╔═╡ d9e23a5a-2a8b-11eb-23f1-73ff28be9f12
md"**The CFL condition**

The CFL condition is defined by $\text{CFL} = \dfrac{\max\left(\sqrt{u² + v²}\right)Δt}{Δx} =$ $(round(CFL_adv(ocean_sim), digits=2))
"

# ╔═╡ 2908988e-2a9a-11eb-2cf7-494972f93152
Base.zeros(G::Grid) = zeros(G.Ny, G.Nx)

# ╔═╡ 6b3b6030-2066-11eb-3343-e19284638efb
plot_kernel(A) = heatmap(
	collect(A),
	color=:bluesreds, clims=(-maximum(abs.(A)), maximum(abs.(A))), colorbar=false,
	xticks=false, yticks=false, size=(30+30*size(A, 2), 30+30*size(A, 1)), xaxis=false, yaxis=false
)

# ╔═╡ 1e8d37ee-2a97-11eb-1d45-6b426b25d4eb
begin
	xgrad_kernel = OffsetArray(reshape([-1., 0, 1.], 1, 3),  0:0, -1:1)
	plot_kernel(xgrad_kernel)
end

# ╔═╡ 682f2530-2a97-11eb-3ee6-99a7c79b3767
begin
	ygrad_kernel = OffsetArray(reshape([-1., 0, 1.], 3, 1),  -1:1, 0:0)
	plot_kernel(ygrad_kernel)
end

# ╔═╡ f4c884fc-2a97-11eb-1ba9-01bf579f8b43
begin
	function advect(T, u, v, Δy, Δx, j, i)
		return .-(
			u[j, i].*sum(xgrad_kernel[0, -1:1].*T[j, i-1:i+1])/(2Δx) .+
			v[j, i].*sum(ygrad_kernel[-1:1, 0].*T[j-1:j+1, i])/(2Δy)
		)
	end
	advect(T, u, v, Δy, Δx) = [
		advect(T, u, v, Δy, Δx, j, i)
		for j=2:size(T, 1)-1, i=2:size(T, 2)-1
	]
	
	advect(T, O::OceanModel) = advect(T, O.u, O.v, O.G.Δy, O.G.Δx)
end

# ╔═╡ b629d89a-2a95-11eb-2f27-3dfa45789be4
begin
	xdiff_kernel = OffsetArray(reshape([1., -2., 1.], 1, 3),  0:0, -1:1)
	ydiff_kernel = OffsetArray(reshape([1., -2., 1.], 3, 1),  -1:1, 0:0)

	[plot_kernel(xdiff_kernel), plot_kernel(ydiff_kernel)]
end

# ╔═╡ ee6716c8-2a95-11eb-3a00-319ee69dd37f
begin
	function diffuse(T, κ, Δy, Δx, j, i)
		return κ.*(
			sum(xdiff_kernel[0, -1:1].*T[j, i-1:i+1])/(Δx^2) +
			sum(ydiff_kernel[-1:1, 0].*T[j-1:j+1, i])/(Δy^2)
		)
	end
	diffuse(T, κ, Δy, Δx) = [
		diffuse(T, κ, Δy, Δx, j, i) for j=2:size(T, 1)-1, i=2:size(T, 2)-1
	]
	
	diffuse(T, O::OceanModel) = diffuse(T, O.P.κ, O.G.Δy, O.G.Δx)
end

# ╔═╡ 81bb6a4a-2a9c-11eb-38bb-f7701c79afa2
function timestep!(sim::ClimateModelSimulation{OceanModel})
	update_ghostcells!(sim.T)
	tendencies = advect(sim.T, sim.model) .+ diffuse(sim.T, sim.model)
	sim.T[2:end-1, 2:end-1] .+= sim.Δt*tendencies
	sim.iteration += 1
end;

# ╔═╡ c98f4680-2b45-11eb-2fbe-ada2cbc080ca
for i in 1:50
	timestep!(ocean_sim)
end

# ╔═╡ 3b24e1b0-2b46-11eb-383b-c57cbf3e68f1
let
	go_ex
	if ocean_sim.iteration == 0
		timestep!(ocean_sim)
	else
		for i in 1:50
			timestep!(ocean_sim)
		end
	end
	plot_state(ocean_sim, clims=(-0.1, 1), show_quiver=show_quiver, show_anomaly=show_anomaly, IC=IC)
end

# ╔═╡ 8346b590-2b41-11eb-0bc1-1ba79bb77dfb
tvec = map(Nvec) do Npower
	G = Grid(8*Npower, 6.e6);
	P = Parameters(κ_ex);

	#u, v = DoubleGyre(G)
	#u, v = PointVortex(G, Ω=0.5)
	u, v = zeros(G), zeros(G)

	model = OceanModel(G, P, u, v)

	IC = InitBox(G)
	#IC = InitBox(G, nx=G.Nx÷2-1)
	#IC = linearT(G)

	Δt = 6*60*60
	S = ClimateModelSimulation(model, copy(IC), Δt)

	return @elapsed timestep!(S)
end

# ╔═╡ 794c2148-2a78-11eb-2756-5bd28b7726fa
begin
	plot(8*Nvec, tvec, xlabel="Number of Grid Cells (in x-direction)", ylabel="elapsed time per timestep [s]")
end |> as_svg

# ╔═╡ Cell order:
# ╟─0f8db6f4-2113-11eb-18b4-21a469c67f3a
# ╠═ed741ec6-1f75-11eb-03be-ad6284abaab8
# ╟─ac759b96-2114-11eb-24cb-d50b556f4142
# ╟─3a4a1aea-2118-11eb-30a9-57b87f2ddfae
# ╟─023779a0-2a95-11eb-35b5-7be93c43afaf
# ╟─b1b5625e-211a-11eb-3ee1-3ba9c9cc375a
# ╠═1e8d37ee-2a97-11eb-1d45-6b426b25d4eb
# ╟─3578b158-2a97-11eb-0771-bf6d82d3b6d1
# ╟─682f2530-2a97-11eb-3ee6-99a7c79b3767
# ╟─7f3c9550-2a97-11eb-1549-455009025872
# ╠═f4c884fc-2a97-11eb-1ba9-01bf579f8b43
# ╟─0127bca6-2a99-11eb-16a0-8d7af66694f8
# ╟─b629d89a-2a95-11eb-2f27-3dfa45789be4
# ╟─eac507ce-2a99-11eb-3eba-0780a4a7e078
# ╠═ee6716c8-2a95-11eb-3a00-319ee69dd37f
# ╟─09f179c0-2a9a-11eb-1d0f-e59012f9e77b
# ╠═7caca2fa-2a9a-11eb-373f-156a459a1637
# ╟─1f06bc34-2a9b-11eb-1030-ff12d103176c
# ╠═2ef2f0cc-2a9b-11eb-03c6-5d8b4c6ae822
# ╠═4558d4f8-2a9b-11eb-1f56-416975bcd180
# ╟─74aa7512-2a9c-11eb-118c-c7a5b60eac1b
# ╠═81bb6a4a-2a9c-11eb-38bb-f7701c79afa2
# ╟─13eb3966-2a9a-11eb-086c-05510a3f5b80
# ╠═cd2ee4ca-2a06-11eb-0e61-e9a2ecf72bd6
# ╠═2a93145e-2a09-11eb-323b-01817062aa89
# ╠═32663184-2a81-11eb-0dd1-dd1e10ed9ec6
# ╠═d3796644-2a05-11eb-11b8-87b6e8c311f9
# ╠═f92086c4-2a74-11eb-3c72-a1096667183b
# ╟─31cb0c2c-2a9a-11eb-10ba-d90a00d8e03a
# ╠═863a6330-2a08-11eb-3992-c3db439fb624
# ╠═c98f4680-2b45-11eb-2fbe-ada2cbc080ca
# ╟─981ef38a-2a8b-11eb-08be-b94be2924366
# ╟─d042d25a-2a62-11eb-33fe-65494bb2fad5
# ╟─6dbc3d34-2a89-11eb-2c80-75459a8e237a
# ╟─c20b0e00-2a8a-11eb-045d-9db88411746f
# ╟─933d42fa-2a67-11eb-07de-61cab7567d7d
# ╟─c9ea0f72-2a67-11eb-20ba-376ca9c8014f
# ╟─3b24e1b0-2b46-11eb-383b-c57cbf3e68f1
# ╟─c3f086f4-2a9a-11eb-0978-27532cbecebf
# ╟─bff89550-2a9a-11eb-3038-d70249c96219
# ╟─dc9d12d0-2a9a-11eb-3dae-85b3b6029658
# ╟─d9e23a5a-2a8b-11eb-23f1-73ff28be9f12
# ╠═ad7b7ed6-2a9c-11eb-06b7-0f5595167575
# ╟─a04d3dee-2a9c-11eb-040e-7bd2facb2eaa
# ╠═16905a6a-2a78-11eb-19ea-81adddc21088
# ╠═8346b590-2b41-11eb-0bc1-1ba79bb77dfb
# ╠═794c2148-2a78-11eb-2756-5bd28b7726fa
# ╠═c0e46442-27fb-11eb-2c94-15edbda3f84d
# ╟─c0298712-2a88-11eb-09af-bf2c39167aa6
# ╟─e2e4cfac-2a63-11eb-1b7f-9d8d5d304b43
# ╟─e3ee80c0-12dd-11eb-110a-c336bb978c51
# ╟─df706ebc-2a63-11eb-0b09-fd9f151cb5a8
# ╟─bb084ace-12e2-11eb-2dfc-111e90eabfdd
# ╟─ecaab27e-2a16-11eb-0e99-87c91e659cf3
# ╟─e59d869c-2a88-11eb-2511-5d5b4b380b80
# ╟─c4424838-12e2-11eb-25eb-058344b39c8b
# ╟─3d12c114-2a0a-11eb-131e-d1a39b4f440b
# ╟─2908988e-2a9a-11eb-2cf7-494972f93152
# ╠═9c8a7e5a-12dd-11eb-1b99-cd1d52aefa1d
# ╟─6b3b6030-2066-11eb-3343-e19284638efb
