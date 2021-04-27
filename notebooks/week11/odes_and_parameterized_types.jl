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

# ╔═╡ 54e6bd88-a6a9-11eb-3380-49b79430f6cf
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
"><em>Section 3.2</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> ODEs and parameterized types </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/S71YIZ8e7MQ" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 5997bb40-b508-4647-8b12-a7cc5152e550
begin
    import Pkg
    Pkg.activate(mktempdir())
	
    Pkg.add([
        Pkg.PackageSpec(name="DifferentialEquations", version="6"),
        Pkg.PackageSpec(name="Plots", version="1"),
		Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="MappedArrays", version="0.4"),

    ])
	
    using DifferentialEquations, Plots, PlutoUI, MappedArrays
end

# ╔═╡ 38c74e63-13e9-49a9-8eae-4a898197647a
TableOfContents(aside=true)

# ╔═╡ 7a1d476b-1302-4b98-b9fa-01b990979985
md"""
# Julia concepts
- Using libraries
- Libraries are built around types and objects
- Plot recipes: Defining how to plot our objects
- Making objects into callable functions
- Parameterized types
"""

# ╔═╡ 3004336a-0250-483f-be00-60db592c9fc8
md"""
# ODEs and parameterized types
"""

# ╔═╡ a1cfd00b-825f-494e-91a9-192815f06ad6
md"""
In the previous lecture we started to look at Ordinary Differential Equations (ODEs). These are equations relating a function to its derivatives, telling us how to move at each moment in time.

For example, exponential decay is modelled by

$$\dot{u} = -p \, u,$$

in other words

$$\dot{u}(t) = - p \, u(t)$$

for all real $t \ge 0$,

with initial condition 

$$u(0) = u_0$$

where $u(t)$ is the number of light bulbs still functioning at time $t$, the number of radioactive nuclei that have not yet decayed, or the number of people who are still infectious and have not yet recovered. The parameter $p$ is the decay rate.

We saw that **time stepping** methods provide a class of numerical methods for solving such initial-value problems, of which the Euler method is the simplest example.

Unfortunately the Euler method is *not* a good choice, since it is not accurate enough. In numerical analysis classes (like [18.330](https://github.com/mitmath/18330)) various better methods are derived.

Fortunately those methods are available in a Julia **library** or package, `DifferentialEquations.jl`.


"""

# ╔═╡ b2d2b8f0-c81d-437a-83cf-726b5caa77ab
md"""
# The `DifferentialEquations.jl` library
"""

# ╔═╡ d27ec502-ea0c-4d15-a223-7cbf6b784d1c
md"""
[DifferentialEquations.jl](https://diffeq.sciml.ai/v2.0/) (often abbreviated as DiffEq) is a Julia library for solving many types of differential equations. It has become the best (most complete and fastest) general library for **solving** ordinary differential equations (and many other types) in any programming environment. It is also a very good example of the way that Julia libraries are often structured.

We will see some basic usage examples and how Julia **types** are used both to control the library and to store the input and output to the **solvers**.
"""

# ╔═╡ 6f87059a-dbdc-46dd-933b-7bb36980868e
md"""
## Basic usage of DifferentialEquations.jl
"""

# ╔═╡ 557cedbc-6e44-40a8-b0ab-37ae11b63f55
md"""
Let's try to solve the above equation that we derived in the previous lecture, $\dot{u} = -p \, u$. (We are using $u$ as the name of the dependent variable for consistency with the `DifferentialEquations.jl` documentation and internal structure.)

We write a general ODE in 1 variable as 

$\dot{u} = f_p(t, u).$

The right-hand side of the ODE is given by a function $f$, which may depend on a **parameter** $p$, i.e. a constant which does not change for any given run of the ODE.
$f$ may also depend explicitly on time.

In our example we do indeed have a parameter $p$ that we want to change, but $f$ does not have an explicit time dependence, so we write
"""

# ╔═╡ a6ae905b-db28-4e75-b567-54840dcda9a5
f(u, p, t) = -p * u

# ╔═╡ f16644d0-e2d2-44ac-988c-aa5b178844f5
md"""
Note that you always need the three input arguments `u`, `p` and `t`, in that order, even if you don't use them.
"""

# ╔═╡ 1ea2acfe-6ba1-44d3-9a24-a904a5fac0c4
md"""
Now we define our initial condition $u_0$ and the time span to integrate over, given as a tuple (initial\_time, final\_time):
"""

# ╔═╡ 264a27cd-9ace-48cc-9556-7eb798298f17
begin
	u0 = 100.0
	
	time_span = (0.0, 10.0)
end

# ╔═╡ 70ebe76d-6107-492d-a3d2-84c1dd7f59fb
md"""
To set up the **problem** instance we use a type `ODEProblem` that is defined in the `DifferentialEquations.jl` package, into which we pass all the information necessary to define the problem. The parameters must go in the following order:
"""

# ╔═╡ 6e7c8e9e-bef0-4bf8-b1b1-d50c82aa203e
problem = ODEProblem(f, u0, time_span, p)

# ╔═╡ b5379dc2-d97f-47ed-8737-35e3fe59285c
md"""
(For more advanced use there are also some additional, optional, keyword arguments.)
Note that the displayed output does not currently include information about the function, nor the parameters.
"""

# ╔═╡ 0ed8e007-2137-43e0-93b8-6f5dfb9496f5
md"""
To solve the ODE we call the `solve` function:
"""

# ╔═╡ ff91515a-89a4-4423-a186-5572c712493d
solution = solve(problem)

# ╔═╡ 64b26404-1ca0-4aa4-bea0-3c9075b08298
md"""
What happened here? A suitable solver (i.e. an algorithm to calculate the solution) was chosen *automatically*, and it chose certain moments in time at which to output information about the (approximate, but very accurate) solution. 

In this particular case it chose to output data at only eight points in time between $t=0$ and $t=10$.

Let's try to plot the `solution` object:
"""

# ╔═╡ b07de2ce-640b-42d6-8b60-39fcbcd116e7
plot(solution, size=(500, 300), label="solution")

# ╔═╡ 0b1855de-a8c9-492e-a249-3238e41fe84c
md"""
### Plot recipes
"""

# ╔═╡ 0190bdb0-97bf-4c35-b3c8-e97c1940b702
md"""
Two surprising things happen. Firstly, there is no reason to expect this to have worked: `solution` is some kind of Julia object, but somehow `Plots.jl` knows how to plot it. This is because `DifferentialEquations.jl` defines a **plot recipe**. This specifies a way to turn solution objects into plots! Any package can do this relatively easily.
"""

# ╔═╡ 555a6328-8aff-4f9f-87f5-51a67450002d
md"""
The second surprise is that the output looks like a smooth curve, rather than just 8 points. Let's see those points on top of the curve. We can extract the relevant data from the `solution` object:
"""

# ╔═╡ d65372df-e6ca-4165-8d9b-b21cc5c9f796
scatter!(solution.t, solution.u, label="discrete output")

# ╔═╡ b274c61b-4fab-4f4a-99df-5d39e0f56aa1
md"""
We see that the package in fact gives not only the value at those points, but it is in fact also capable of calculating an (approximate) solution at *any* intermediate point, using **interpolation**. In fact, we can access this by treating `solution` as if it were a function:
"""

# ╔═╡ e3d9e0be-6cf4-4ae1-8c7f-b444a153a9f5
begin
	tt = 3.5
	solution(tt)
end

# ╔═╡ 180bcdc1-5f51-4b32-8b9c-5000605cdf32
scatter!([tt], [solution(tt)], label="t = $(tt)", ms=5, m=:square)

# ╔═╡ 13b38f88-2ead-46b3-bc96-eae2ea10204d
md"""
For this particular ODE we know the analytical solution. Let's compare them as we vary the parameter $p$:
"""

# ╔═╡ 475ef0e5-7f3a-4bbb-b513-8be29abfd3f9
md"""
p = $(@bind p Slider(0.0:0.1:2.0, show_value=true))
"""

# ╔═╡ 0ed6d65c-707d-4666-b203-2ad0ea822687
let
	
	problem = ODEProblem(f, u0, time_span, p)	
	solution = solve(problem)
	
	plot(solution,
		linewidth=3, xlabel="t", yaxis="x(t)", label="numerical", size=(500, 300))
		
	plot!(t -> u0 * exp(-p*t), lw=3, ls=:dash, label="exact")
	
	ylims!(0, 100)
	title!("p = $p")
end

# ╔═╡ cf9a293c-aa0f-40ce-960b-d4c3b82b8346
md"""
We see that the numerical and exact solutions are (to the eye) indistinguishable, and that the package is fast enough to calculate the solution basically in real time.
"""

# ╔═╡ efcfdc1a-5a80-4780-ba56-43c5e2d6ea36
md"""
## Systems of ODEs
"""

# ╔═╡ 5d7a81d7-8080-4390-924a-72c34c0a5e23
md"""
Now let's try to solve the SIR equations:

$$\begin{aligned}
\dot{s} &= -\beta s i \\
\dot{i} &= +\beta s i - \gamma i\\
\dot{r} &= + \gamma i
\end{aligned}$$
"""

# ╔═╡ 6c607126-dd0b-438d-8724-c1ef5e79c71d
md"""
We need to think of the system in a vector form,

$$\dot{\mathbf{x}} = \mathbf{f}_\mathbf{p}(t, \mathbf{x}),$$

where:
- the vector $\mathbf{x}$ is a vector of all the variables, $\mathbf{x} := (x_1, x_2, x_3) := (s, i, r)$
- the function $\mathbf{f}$ is a vector-valued function $\mathbb{R}^3 \to \mathbb{R}^3$, where $f_k$ gives the right-hand side of the equation for $\dot{x_k}$; and 
- the vector $\mathbf{p} = (\beta, \gamma)$ is a vector of the parameters.


"""

# ╔═╡ d16e06f4-55c4-4c0e-bde5-c0ce4b36b043
x0 = [0.99, 0.01, 0.0]

# ╔═╡ aa0e4260-6268-4eff-a662-f3fd55e7d450
function SIR(x, p, t)
	
	s, i, r = x    # unpack the vectors into scalar values
	β, γ = p
	
	# build a new vector to return:
	
	return [-β * s * i, 
			+β * s * i - γ * i,
					   + γ * i]
		        
end

# ╔═╡ d0f40681-73df-4cd3-bbd5-3edb8193153e
params = [β, γ]

# ╔═╡ fd122a25-5655-410b-aa7f-34936fc97b53
SIR_problem = ODEProblem(SIR, x0, (0.0, 50.0), params)

# ╔═╡ 8ac7da6b-46e0-470b-91b3-1a61c226fa4a
sol = solve(SIR_problem)

# ╔═╡ 7aa45efe-865d-4e0e-9c71-0c032c72c40d
md"""
Now we see that the solverr has recognised that everything is a vector, and it returns a vector at each time stamp.

Again we can plot:
"""

# ╔═╡ bca8112f-cb61-43dc-ae87-383915c8a89b
gr()

# ╔═╡ a766a141-5d7b-499f-9e18-48bf926ee7ea
plot(sol)

# ╔═╡ 76cbc37d-54c8-4626-8bfe-58b63a602c38
md"""
β = $(@bind β Slider(-0.5:0.01:2.0, default=1.0, show_value=true))

γ = $(@bind γ Slider(-0.5:0.01:2.0, default=0.1, show_value=true))
"""

# ╔═╡ c2765282-bcc7-4110-9822-10557326461e
md"""
It knows to plot each variable separately.

We can instead plot combinations of variables in *phase space* or *state space*:
"""

# ╔═╡ 7671506d-d4b7-4792-9571-e003097235e1
gr()

# ╔═╡ 203e90b0-4d0c-4999-8513-d4eb43f53aac
plot(sol, vars=(1, 2), xlabel="s", ylabel="i", arrow=true, xlims=(-0.1, 1.0), size=(500, 300))

# ╔═╡ 326890ae-0675-4779-b5e8-9b3e0412a52b
md"""
And even in 3D:
"""

# ╔═╡ d7025d1f-c3b8-461a-94dc-2414fbdfd373
plotly()

# ╔═╡ 7f5c41f9-96b9-40d6-87f8-3e81c372b48e
plot(sol, vars=(1, 2, 3), xlabel="s", ylabel="i", zlabel="r")

# ╔═╡ d8f15e9b-aef1-4795-8522-85ea3564e351
md"""
The [ModelingToolkit.jl](https://mtk.sciml.ai/stable/tutorials/ode_modeling/) library  provides ways to make creating ODE models more intuitive, using symbolic equation objects.
"""

# ╔═╡ e723400e-3f8f-47d6-8944-28355a54c698
md"""
## Making objects into callable functions
"""

# ╔═╡ 15fdb430-4157-4401-85b9-665dde795a22
md"""
One of the interesting things we have seen is the way that the `solution` object can be **called** using the normal syntax for calling functions:
"""

# ╔═╡ a410e98d-dd7f-4f55-8812-8b0339a56c86
solution(3.5)

# ╔═╡ 239f39b2-53c6-4da9-ac25-b5e7d19deb5f
md"""
Not all types allow this. For example, if we define a matrix
"""

# ╔═╡ 6630cbc8-1b2f-4ea9-bcd6-e4f4fcb2e844
A = rand(2, 2)

# ╔═╡ 5c1c7016-69aa-4009-8dc8-0c68c925ee66
md"""
we cannot usually call it with a vector:
"""

# ╔═╡ 83719ef1-e8d6-44d0-98ab-a851b1082fa5
A(rand(2))

# ╔═╡ e4d36db5-352b-4fb2-9169-da5c6a3458b7
md"""
If we wanted to do so, we could, however, using the following syntax:
"""

# ╔═╡ 167015ff-1caf-42a8-85f1-070da3e5d5c5
# (A::Matrix)(x) = A * x

# ╔═╡ f8bcd82d-089c-49a2-99d0-b17a5ac5c509
md"""
Note that this makes objects (instances) of the type callable, rather than the type itself, which we can already call as a **constructor** to create objects of that type:
"""

# ╔═╡ cd17e738-089b-4934-af63-d27706c5d1c7
Matrix([1 2; 3 4])

# ╔═╡ fc525f77-ad62-43cb-92e4-0fc1354be99c
md"""
For example, if we wanted to write our own type to store the output of the Euler method, we could do something like
"""

# ╔═╡ ec90842a-a20c-4847-a803-e070d343b98d
begin
	struct SimpleEulerOutput
		times::Vector{Float64}
		values::Vector{Float64}
	end
	
	function (soln::SimpleEulerOutput)(t) 
		# use interpolation to calculate the value at time t
		# using  `soln.times` and `soln.values`
	end
end

# ╔═╡ 9fad6f01-a3b7-4dbb-a8f5-29f2ea1f545a
md"""
The definition of the function makes it callable.

This says that "the way to call an object called `soln`, of type `EulerOutput`, is the following:". Note that inside the function you will need too access the `times` and `values` from *inside* the `soln` object, using `soln.times` and `soln.values`.

Note that at the time of writing, Pluto requires that you put this call definition in the same cell as the type definition.
"""

# ╔═╡ 658d8d15-5b3e-4d35-88b1-4e2fa0f3b17a
md"""
## Digging into objects
"""

# ╔═╡ aafeeb55-943f-4375-9cc0-e0dce659d161
md"""
A key feature of the `DifferentialEquations.jl` library, and of most other libraries in Julia, is the way they define and use new **types**. 

As we have seen previously, we can define new types using `struct` which store data, and then define functions which act on those types.
"""

# ╔═╡ 3c45ad21-d18b-41fa-a0fd-64d8988621f3
md"""
Let's start by looking at the `ODEProblem` type:
"""

# ╔═╡ 96e871a8-48b9-459b-a1a0-94fc1deb941e
problem

# ╔═╡ 2622801c-4e37-42f1-ab77-939d461b8d20
md"""
To see what fields, or attributes, the object contains we can use
"""

# ╔═╡ 43e7b270-6452-4a4c-ba6f-c286a337a423
fieldnames(typeof(problem))

# ╔═╡ dbdb9998-ca3b-46fb-87cf-5b7c6e387ab9
md"""
In Pluto and other interactive environments we can get the same information using `problem.<TAB>`, i.e. by typing the TAB key after `problem.`
"""

# ╔═╡ b8fbff51-72fe-4432-9f6f-06f4628320d4
md"""
As usual we can extract the data contained in the object as usual using `.`:
"""

# ╔═╡ ef677abe-c96d-41cc-9b4a-192ff29cdb86
problem.u0

# ╔═╡ 78933b33-8a3c-492e-8a58-19ad7187b45e
problem.tspan

# ╔═╡ 9ef4aa78-2ecd-4d53-87ae-f0909bb46915
md"""
To see everything contained in the object, we can use `Dump` in Pluto, or `dump` if we are not using Pluto:
"""

# ╔═╡ 798bc482-7556-4904-8946-0d9898ce2d33
Dump(problem)

# ╔═╡ 32e9f6e5-8df6-4d40-8092-efaf2bce28d3
md"""
This seems (much) more complicated than you might expect. The library is clearly doing more than just storing the data that we provide in a type! The main thing that has happened is that the function we passed in has been processed by wrapping it into yet another type, `ODEFunction`. This contains information such as how to calculate the derivative of the function that can be provided for more advanced usage of the package.
"""

# ╔═╡ 6dfc2699-fe5e-4b55-8437-0866f715170a
md"""
Similarly we can look inside the solution object:
"""

# ╔═╡ 17d6021b-0d21-4d04-a8ae-64743cc01404
fieldnames(typeof(solution))

# ╔═╡ f4c3b174-57ac-461b-a816-869460d8896d
Dump(solution)

# ╔═╡ 500973f5-faa7-4a31-b812-d0b20dbb9d82
md"""
The solution is even more complicated, containing not only the data that was calculated, but also all information about which algorithms were used to solve the problem and tables of coefficients for interpolation.
"""

# ╔═╡ 4a575627-32c2-4842-a540-52253f79ff89
md"""
## Parameterized types
"""

# ╔═╡ bea223ef-f961-457c-8962-d0ed396f4717
md"""
Let's look now at the *type* of the DiffEq objects:
"""

# ╔═╡ 92bd82dc-eaab-4869-9d95-cb4647092352
typeof(problem)

# ╔═╡ d518828a-1972-4bfa-b96f-0ebbf86b6193
md"""
We see that indeed `problem` is an object of type `ODEProblem`, but that it also has several **type parameters**, which are listed inside the curly braces (`{` and `}`):
"""

# ╔═╡ c3570557-55bd-4189-a332-aa2e54693665
[typeof(problem).parameters...]

# ╔═╡ 1f684b1b-8e43-4e0e-8a47-1f2474cc5e4f
md"""
For example, we see that the second type parameter is of type `Tuple{Float64, Float64}`, which is the type of the variable `time_span`:
"""

# ╔═╡ 1bf84cfe-9ddc-4644-b7ea-8ac43b01d477
typeof(time_span)

# ╔═╡ d2a1f97e-2e3e-4ae9-8287-2de62065d708
md"""
One of the reasons for using parameterized types like this is for efficiency: Julia is fastest when it knows the exact types of every variable, since then it can generate efficient machine code.
"""

# ╔═╡ a71aaf0b-8ce9-4242-b31f-8f05730ce2e7
md"""
# Making parameterized types
"""

# ╔═╡ 09ddc00b-2361-44c5-b194-7b4b6d24bef4
md"""
Let's see how and why we would make a parameterized type.

Let's think again about the `EulerOutput` type that we started to write above.
What happens if, as in the `DifferentialEquations.jl` library, we would like to handle both *scalar* ODEs (one single real dependent variable), and *vector* ODEs?

We can no longer specify that the output type is a `Vector{Float64}`, so we would need to leave it unspecified:
"""

# ╔═╡ c7c16e89-3ccf-4d70-9cdb-d5ae71a5ea49
struct SimpleEulerOutput2
	times
	values
end

# ╔═╡ 1872c30d-aece-44a5-b3b6-36e82c072609
md"""
However, it turns out that we then lose efficiency (speed). 

What we would need is two different types: one in which we specify the type of `times` as `Vector{Float64}`, and the other as `Vector{Vector{Float64}}`.

Julia provides a mechanism to define *both at once*: this is what parameterized types do!
"""

# ╔═╡ 5d06734e-ffbd-421e-820e-609e373ccc7b
md"""
Let's define our own `MyODEProblem` type as a simple example. We specify type parameters for each variable:
"""

# ╔═╡ 62d55814-c863-4d4d-8582-908721d37326
struct MyODEProblem{T, U}
	t0::T
	tfinal::T
	
	u0::U
end

# ╔═╡ 470b7808-5ff6-4cda-82cc-2ac250d51909
md"""
Note that the starting and final times have been specified to require the *same* type `T`.
"""

# ╔═╡ d392de63-137e-43fb-86ca-4f344769bc71
md"""
Now if we create objects of this type, we see that Julia matches the types we pass in to the correct type parameters:
"""

# ╔═╡ e07830be-3aab-4410-a830-786a30eb162a
newprob = MyODEProblem(3, 4, 100.0)

# ╔═╡ 6d809ff0-20c5-4910-aca0-612496955812
newprob.t0

# ╔═╡ 816a64ed-1f88-43a8-9df7-8070372e84ea
newprob.tfinal

# ╔═╡ cdd6a0dd-e188-4d37-ab6d-12e7fecd3e90
newprob.u0

# ╔═╡ c29d4796-9e52-4234-8325-5bf31099c79d
md"""
If we change the types of the inputs, the type parameters change:
"""

# ╔═╡ 7e5b0073-1bc7-41c7-ae74-c9c1bdf6c6ea
MyODEProblem(3.0, 4.0, 100.0)

# ╔═╡ 67e36f7c-0cb9-4ead-82ad-4c47639802a8
md"""
If we mix types for the first two arguments then we get an error, since Julia can't match to a single type `T`:
"""

# ╔═╡ cdc25238-ed48-42e5-9db4-2367577b215d
MyODEProblem(3.0, 5, 100.0)

# ╔═╡ f66b6078-bab5-48ef-9241-8d5fb0dc78ea
md"""
We can use vectors:
"""

# ╔═╡ 73016af9-5efe-4af2-9e99-ce1a7de6fa96
MyODEProblem(3, 4, [17.0, 18.0])

# ╔═╡ Cell order:
# ╟─54e6bd88-a6a9-11eb-3380-49b79430f6cf
# ╠═5997bb40-b508-4647-8b12-a7cc5152e550
# ╠═38c74e63-13e9-49a9-8eae-4a898197647a
# ╟─7a1d476b-1302-4b98-b9fa-01b990979985
# ╟─3004336a-0250-483f-be00-60db592c9fc8
# ╟─a1cfd00b-825f-494e-91a9-192815f06ad6
# ╟─b2d2b8f0-c81d-437a-83cf-726b5caa77ab
# ╟─d27ec502-ea0c-4d15-a223-7cbf6b784d1c
# ╟─6f87059a-dbdc-46dd-933b-7bb36980868e
# ╟─557cedbc-6e44-40a8-b0ab-37ae11b63f55
# ╠═a6ae905b-db28-4e75-b567-54840dcda9a5
# ╟─f16644d0-e2d2-44ac-988c-aa5b178844f5
# ╟─1ea2acfe-6ba1-44d3-9a24-a904a5fac0c4
# ╠═264a27cd-9ace-48cc-9556-7eb798298f17
# ╟─70ebe76d-6107-492d-a3d2-84c1dd7f59fb
# ╠═6e7c8e9e-bef0-4bf8-b1b1-d50c82aa203e
# ╟─b5379dc2-d97f-47ed-8737-35e3fe59285c
# ╟─0ed8e007-2137-43e0-93b8-6f5dfb9496f5
# ╠═ff91515a-89a4-4423-a186-5572c712493d
# ╟─64b26404-1ca0-4aa4-bea0-3c9075b08298
# ╠═b07de2ce-640b-42d6-8b60-39fcbcd116e7
# ╟─0b1855de-a8c9-492e-a249-3238e41fe84c
# ╟─0190bdb0-97bf-4c35-b3c8-e97c1940b702
# ╟─555a6328-8aff-4f9f-87f5-51a67450002d
# ╠═d65372df-e6ca-4165-8d9b-b21cc5c9f796
# ╟─b274c61b-4fab-4f4a-99df-5d39e0f56aa1
# ╠═e3d9e0be-6cf4-4ae1-8c7f-b444a153a9f5
# ╠═180bcdc1-5f51-4b32-8b9c-5000605cdf32
# ╟─13b38f88-2ead-46b3-bc96-eae2ea10204d
# ╟─475ef0e5-7f3a-4bbb-b513-8be29abfd3f9
# ╠═0ed6d65c-707d-4666-b203-2ad0ea822687
# ╟─cf9a293c-aa0f-40ce-960b-d4c3b82b8346
# ╟─efcfdc1a-5a80-4780-ba56-43c5e2d6ea36
# ╟─5d7a81d7-8080-4390-924a-72c34c0a5e23
# ╟─6c607126-dd0b-438d-8724-c1ef5e79c71d
# ╠═d16e06f4-55c4-4c0e-bde5-c0ce4b36b043
# ╠═aa0e4260-6268-4eff-a662-f3fd55e7d450
# ╠═d0f40681-73df-4cd3-bbd5-3edb8193153e
# ╠═fd122a25-5655-410b-aa7f-34936fc97b53
# ╠═8ac7da6b-46e0-470b-91b3-1a61c226fa4a
# ╟─7aa45efe-865d-4e0e-9c71-0c032c72c40d
# ╠═bca8112f-cb61-43dc-ae87-383915c8a89b
# ╠═a766a141-5d7b-499f-9e18-48bf926ee7ea
# ╟─76cbc37d-54c8-4626-8bfe-58b63a602c38
# ╟─c2765282-bcc7-4110-9822-10557326461e
# ╠═7671506d-d4b7-4792-9571-e003097235e1
# ╠═203e90b0-4d0c-4999-8513-d4eb43f53aac
# ╟─326890ae-0675-4779-b5e8-9b3e0412a52b
# ╠═d7025d1f-c3b8-461a-94dc-2414fbdfd373
# ╠═7f5c41f9-96b9-40d6-87f8-3e81c372b48e
# ╟─d8f15e9b-aef1-4795-8522-85ea3564e351
# ╟─e723400e-3f8f-47d6-8944-28355a54c698
# ╟─15fdb430-4157-4401-85b9-665dde795a22
# ╠═a410e98d-dd7f-4f55-8812-8b0339a56c86
# ╟─239f39b2-53c6-4da9-ac25-b5e7d19deb5f
# ╠═6630cbc8-1b2f-4ea9-bcd6-e4f4fcb2e844
# ╟─5c1c7016-69aa-4009-8dc8-0c68c925ee66
# ╠═83719ef1-e8d6-44d0-98ab-a851b1082fa5
# ╟─e4d36db5-352b-4fb2-9169-da5c6a3458b7
# ╠═167015ff-1caf-42a8-85f1-070da3e5d5c5
# ╟─f8bcd82d-089c-49a2-99d0-b17a5ac5c509
# ╠═cd17e738-089b-4934-af63-d27706c5d1c7
# ╟─fc525f77-ad62-43cb-92e4-0fc1354be99c
# ╠═ec90842a-a20c-4847-a803-e070d343b98d
# ╟─9fad6f01-a3b7-4dbb-a8f5-29f2ea1f545a
# ╟─658d8d15-5b3e-4d35-88b1-4e2fa0f3b17a
# ╟─aafeeb55-943f-4375-9cc0-e0dce659d161
# ╟─3c45ad21-d18b-41fa-a0fd-64d8988621f3
# ╠═96e871a8-48b9-459b-a1a0-94fc1deb941e
# ╟─2622801c-4e37-42f1-ab77-939d461b8d20
# ╠═43e7b270-6452-4a4c-ba6f-c286a337a423
# ╟─dbdb9998-ca3b-46fb-87cf-5b7c6e387ab9
# ╟─b8fbff51-72fe-4432-9f6f-06f4628320d4
# ╠═ef677abe-c96d-41cc-9b4a-192ff29cdb86
# ╠═78933b33-8a3c-492e-8a58-19ad7187b45e
# ╟─9ef4aa78-2ecd-4d53-87ae-f0909bb46915
# ╠═798bc482-7556-4904-8946-0d9898ce2d33
# ╟─32e9f6e5-8df6-4d40-8092-efaf2bce28d3
# ╟─6dfc2699-fe5e-4b55-8437-0866f715170a
# ╠═17d6021b-0d21-4d04-a8ae-64743cc01404
# ╠═f4c3b174-57ac-461b-a816-869460d8896d
# ╟─500973f5-faa7-4a31-b812-d0b20dbb9d82
# ╟─4a575627-32c2-4842-a540-52253f79ff89
# ╟─bea223ef-f961-457c-8962-d0ed396f4717
# ╠═92bd82dc-eaab-4869-9d95-cb4647092352
# ╟─d518828a-1972-4bfa-b96f-0ebbf86b6193
# ╠═c3570557-55bd-4189-a332-aa2e54693665
# ╟─1f684b1b-8e43-4e0e-8a47-1f2474cc5e4f
# ╠═1bf84cfe-9ddc-4644-b7ea-8ac43b01d477
# ╟─d2a1f97e-2e3e-4ae9-8287-2de62065d708
# ╟─a71aaf0b-8ce9-4242-b31f-8f05730ce2e7
# ╟─09ddc00b-2361-44c5-b194-7b4b6d24bef4
# ╠═c7c16e89-3ccf-4d70-9cdb-d5ae71a5ea49
# ╟─1872c30d-aece-44a5-b3b6-36e82c072609
# ╟─5d06734e-ffbd-421e-820e-609e373ccc7b
# ╠═62d55814-c863-4d4d-8582-908721d37326
# ╟─470b7808-5ff6-4cda-82cc-2ac250d51909
# ╟─d392de63-137e-43fb-86ca-4f344769bc71
# ╠═e07830be-3aab-4410-a830-786a30eb162a
# ╠═6d809ff0-20c5-4910-aca0-612496955812
# ╠═816a64ed-1f88-43a8-9df7-8070372e84ea
# ╠═cdd6a0dd-e188-4d37-ab6d-12e7fecd3e90
# ╟─c29d4796-9e52-4234-8325-5bf31099c79d
# ╠═7e5b0073-1bc7-41c7-ae74-c9c1bdf6c6ea
# ╟─67e36f7c-0cb9-4ead-82ad-4c47639802a8
# ╠═cdc25238-ed48-42e5-9db4-2367577b215d
# ╟─f66b6078-bab5-48ef-9241-8d5fb0dc78ea
# ╠═73016af9-5efe-4af2-9e99-ce1a7de6fa96
