### A Pluto.jl notebook ###
# v0.12.4

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

# ╔═╡ 05b01f6e-106a-11eb-2a88-5f523fafe433
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="PlutoUI", version="0.6.7-0.6"), 
			Pkg.PackageSpec(name="Plots", version="1.6-1"),
			])

	using Plots
	gr()
	using PlutoUI
end

# ╔═╡ 048890ee-106a-11eb-1a81-5744150543e8
md"_homework 6, version 0_"

# ╔═╡ 056ed7f2-106a-11eb-3543-31a5cb560e80
# WARNING FOR OLD PLUTO VERSIONS, DONT DELETE ME

html"""
<script>
const warning = html`
<h2 style="color: #800">Oopsie! You need to update Pluto to the latest version</h2>
<p>Close Pluto, go to the REPL, and type:
<pre><code>julia> import Pkg
julia> Pkg.update("Pluto")
</code></pre>
`

const super_old = window.version_info == null || window.version_info.pluto == null
if(super_old) {
	return warning
}
const version_str = window.version_info.pluto.substring(1)
const numbers = version_str.split(".").map(Number)
console.log(numbers)

if(numbers[0] > 0 || numbers[1] > 12 || numbers[2] > 1) {
	
} else {
	return warning
}

</script>

"""

# ╔═╡ 0579e962-106a-11eb-26b5-2160f461f4cc
md"""

# **Homework 6**: _Epidemic modeling III_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 0587db1c-106a-11eb-0560-c3d53c516805
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 0565af4c-106a-11eb-0d38-2fb84493d86f
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 05976f0c-106a-11eb-03a4-0febbc18fae8
md"_Let's create a package environment:_"

# ╔═╡ 0d191540-106e-11eb-1f20-bf72a75fb650
md"""
We began this module with **data** on the COVID-19 epidemic, but then looked at mathematical **models**. 
How can we make the connection between data and models?

Models have *parameters*, such as the rate of recovery from infection. 
Where do the parameter values come from? Ideally we would like to extract them from data. 
The goal of this homework is to do this by *fitting* a model to data.

For simplicity we will use data that generated from the spatial model in Homework 5, rather than real-world data, 
and we will fit the simplest SIR model. But the same ideas apply more generally.

There are many ways to fit a function to data, but all must involve some form of **optimization**, 
usually **minimization** of a particular function, a **loss function**; this is the basis of the vast field of **machine learning**.

The loss function is a function of the model parameters; it measures *how far* the model *output* is from the data,
for the given values of the parameters. 

We emphasise that this material is pedagogical; there is no suggestion that these specific techniques should be used actual calculations; rather, it is the underlying ideas that are important.
"""

# ╔═╡ 3cd69418-10bb-11eb-2fb5-e93bac9e54a9
md"""
## **Exercise 1**: _Calculus without calculus_
"""

# ╔═╡ 17af6a00-112b-11eb-1c9c-bfd12931491d
md"""
Before we jump in to simulating the SIR equations, let's experiment with a simple 1D function. In calculus, we learn techniques for differentiating and integrating _symbolic_ equations, e.g. ``\frac{d}{dx} x^n = nx^{n-1}``. But in real applications, it is often impossible to apply these techniques, either because the problem is too complicated to solve symbolically, or because our problem has no symbolic expression, like when working with experimental results.

Instead, we use ✨ _computers_ ✨ to approximate derivatives and integrals. Instead of applying rules to symbolic expressions, we use much simpler strategies that _only use the output values of our function_.

As a first example, we will approximate the _derivative_ of a function. Our method is inspired by the analytical definition of the derivative!

$$f'(a) := \lim_{h \rightarrow 0} \frac{f(a + h) - f(a)}{h}.$$

The finite difference method simply fixes a small value for $h$, say $h = 10^{-3}$, and then approximates the derivative as:

$$f'(a) \simeq \frac{f(a + h) - f(a)}{h}.$$
"""

# ╔═╡ 2a4050f6-112b-11eb-368a-f91d7a023c9d
md"""
#### Exercise 1.1 - _tangent line_

👉 Write a function `finite_difference_slope` that takes a function `f` and numbers `a` and `h`. It returns the slope ``f'(a)``, approximated using the finite difference formula above.
"""

# ╔═╡ d217a4b6-12e8-11eb-29ce-53ae143a39cd
function finite_difference_slope(f::Function, a, h=1e-3)
	
	return missing
end

# ╔═╡ f0576e48-1261-11eb-0579-0b1372565ca7
finite_difference_slope(sqrt, 4.0, 5.0)

# ╔═╡ bf8a4556-112b-11eb-042e-d705a2ca922a
md"""
👉 Write a function `tangent_line` that takes the same arguments `f`, `a` and `g`, but it **returns a function**. This function (``\mathbb{R} \rightarrow \mathbb{R}``) is the _tangent line_ with slope ``f'(a)`` (computed using `finite_difference_slope`) that passes through ``(a, f(a))``.
"""

# ╔═╡ cbf0a27a-12e8-11eb-379d-85550b942ceb
function tangent_line(f, a, h)
	
	return missing
end

# ╔═╡ 2b79b698-10b9-11eb-3bde-53fc1c48d5f7
# this is our test function
wavy(x) = .1x^3 - 1.6x^2 + 7x - 3;

# ╔═╡ a732bbcc-112c-11eb-1d65-110c049e226c
md"""
The slider below controls ``h`` using a _log scale_. In the (mathematical) definition of the derivative, we take ``\lim_{h \rightarrow 0}``. This corresponds to moving the slider to the left. 

Notice that, as you decrease ``h``, the tangent line gets more accurate, but what happens if you make ``h`` too small?
"""

# ╔═╡ c9535ad6-10b9-11eb-0537-45f13931cd71
@bind log_h Slider(-16:0.01:.5, default=-.5)

# ╔═╡ 7495af52-10ba-11eb-245f-a98781ba123c
h_finite_diff = 10.0^log_h

# ╔═╡ 327de976-10b9-11eb-1916-69ad75fc8dc4
zeroten = LinRange(0.0, 10.0, 300);

# ╔═╡ abc54b82-10b9-11eb-1641-817e2f043d26
@bind a_finite_diff Slider(zeroten, default=4)

# ╔═╡ 43df67bc-10bb-11eb-1cbd-cd962a01e3ee
md"""
$(html"<span id=theslopeequation></span>")
#### Exercise 1.2 - _antiderivative_

In the finite differences method, we approximated the derivative of a function:

$$f'(a) \simeq \frac{f(a + h) - f(a)}{h}$$

We can do something very similar to approximate the 'antiderivate' of a function. Finding the antiderivative means that we use the _slope_ ``f'`` to compute ``f`` numerically!

This antiderivative problem is illustrated below. The only information that we have is the **slope** at any point ``a \in \mathbb{R}``, and we have one **initial value**, ``f(1)``.
"""

# ╔═╡ d5a8bd48-10bf-11eb-2291-fdaaff56e4e6
# in this exercise, only the derivative is given
wavy_deriv(x) = .3x^2 - 3.2x + 7;

# ╔═╡ 0b4e8cdc-10bd-11eb-296c-d51dc242a372
@bind a_euler Slider(zeroten, default=1)

# ╔═╡ 1d8ce3d6-112f-11eb-1343-079c18cdc89c
md"""
Using only this information, we want to **reconstruct** ``f``.

By rearranging [the equation above](#theslopeequation), we get the _Euler method_:

$$f(a+h) \simeq hf'(a) + f(a)$$

Using this formula, we only need to know the _value_ ``f(a)`` and the _slope_ ``f'(a)`` of a function at ``a`` to get the value at ``a+h``. Doing this repeatedly can give us the value at ``a+2h``, at ``a+3h``, etc., all from one initial value ``f(a)``.

👉 Write a function `euler_integrate_step` that applies this formula to a known function ``f'`` at ``a``, with step size ``h`` and the initial value ``f(a)``. It returns the next value, ``f(a+h)``.
"""

# ╔═╡ fa320028-12c4-11eb-0156-773e2aba8e58
function euler_integrate_step(fprime::Function, fa::Number, 
		a::Number, h::Number)
	
	return missing
end

# ╔═╡ 2335cae6-112f-11eb-3c2c-254e82014567
md"""
👉 Write a function `euler_integrate` that takes takes a known function ``f'``, the initial value ``f(a)`` and a range `T` with `a == first(T)` and `h == step(T)`. It applies the function `euler_integrate_step` repeatedly, once per entry in `T`, to produce the sequence of values ``f(a+h)``, ``f(a+2h)``, etc.
"""

# ╔═╡ fff7754c-12c4-11eb-2521-052af1946b66
function euler_integrate(fprime::Function, fa::Number, 
		T::AbstractRange)
	
	a0 = T[1]
	h = step(T)
	
	return missing
end

# ╔═╡ 4d0efa66-12c6-11eb-2027-53d34c68d5b0
md"""
Let's try it out on ``f'(x) = 3x^2`` and `T` ranging from ``0`` to ``10``.

We already know the analytical solution ``f(x) = x^3``, so the result should be an array going from (approximately) `0.0` to `1000.0`.
"""

# ╔═╡ b74d94b8-10bf-11eb-38c1-9f39dfcb1096
euler_test = let
	fprime(x) = 3x^2
	T = 0 : 0.1 : 10
	
	euler_integrate(fprime, 0, T)
end

# ╔═╡ ab72fdbe-10be-11eb-3b33-eb4ab41730d6
@bind N_euler Slider(2:40)

# ╔═╡ d21fad2a-1253-11eb-304a-2bacf9064d0d
md"""
You see that our numerical antiderivate is not very accurate, but we can get a smaller error by choosing a smaller step size. Try it out!

There are also alternative integration methods that are more accurate with the same step size. Some methods also use the second derivative, other methods use multiple steps at once, etc.! This is the study of Numerical Methods.
"""

# ╔═╡ 518fb3aa-106e-11eb-0fcd-31091a8f12db
md"""
## **Exercise 2:** _Simulating the SIR differential equations_

Recall from the lectures that the ordinary differential equations (ODEs) for the SIR model are as follows:

$$\begin{align*}
\dot{s} &= - \beta s \, i \\
\dot{i} &= + \beta s \, i - \gamma i \\
\dot{r} &= +\gamma i
\end{align*}$$

where ``\dot{s} := \frac{ds}{dt}`` is the derivative of $s$ with respect to time. 
Recall that $s$ denotes the *proportion* (fraction) of the population that is susceptible, a number between $0$ and $1$.

We will use the simplest possible method to simulate these, namely the **Euler method**. The Euler method is not always a good method to solve ODEs accurately, but for our purposes it is good enough.

In the previous exercise, we introduced the euler method for a 1D function, which you can see as an ODE that only depends on time. For the SIR equations, we have an ODE that only depends on the previous _value_, not on time, and we have 3 equations instead of 1.

The solution is quite simple, we apply the euler method to *each* of the differential equations within a *single* time step to get new values for *each* of $s$, $i$ and $r$ at the end of the time step in terms of the values at the start of the time step. The euler discretised equations are:

$$\begin{align*}
s(t+h) &= s(t) - h\,\cdot\beta s(t) \, i(t) \\
i(t+h) &= i(t) + h\,\cdot(\beta s(t) \, i(t) - \gamma i(t)) \\
r(t+h) &= r(t) + h\,\cdot \gamma i(t)
\end{align*}$$

👉 Implement a function `euler_SIR_step(β, γ, sir_0, h)` that performs a single Euler step for these equations with the given parameter values and initial values, with a step size $h$.

`sir_0` is a 3-element vector, and you should return a new 3-element vector with the values after the timestep.
"""

# ╔═╡ 1e5ca54e-12d8-11eb-18b8-39b909584c72
function euler_SIR_step(β, γ, sir_0::Vector, h::Number)
	s, i, r = sir_0
	
	return [
		missing,
		missing,
		missing,
	]
end

# ╔═╡ 84daf7c4-1244-11eb-0382-d1da633a63e2
euler_SIR_step(0.1, 0.05, 
	[0.99, 0.01, 0.00], 
	0.1)

# ╔═╡ 517efa24-1244-11eb-1f81-b7f95b87ce3b
md"""
👉 Implement a function `euler_SIR(β, γ, sir_0, T)` that applies the previously defined function over a time range $T$.

You should return a vector of vectors: a 3-element vector for each point in time.
"""

# ╔═╡ 51a0138a-1244-11eb-239f-a7413e2e44e4
function euler_SIR(β, γ, sir_0::Vector, T::AbstractRange)
	# T is a range, you get the step size and number of steps like so:
	h = step(T)
	
	num_steps = length(T)
	
	return missing
end

# ╔═╡ 4b791b76-12cd-11eb-1260-039c938f5443
sir_T = 0 : 0.1 : 60.0

# ╔═╡ 0a095a94-1245-11eb-001a-b908128532aa
sir_results = euler_SIR(0.3, 0.15, 
	[0.99, 0.01, 0.00], 
	sir_T)

# ╔═╡ 51c9a25e-1244-11eb-014f-0bcce2273cee
md"""
Let's plot $s$, $i$ and $r$ as a function of time.
"""

# ╔═╡ b4bb4b3a-12ce-11eb-3fe5-ad7ccd73febb
function plot_sir!(p, T, results; label="", kwargs...)
	s = getindex.(results, [1])
	i = getindex.(results, [2])
	r = getindex.(results, [3])
	
	plot!(p, T, s; color=1, label=label*" S", lw=3, kwargs...)
	plot!(p, T, i; color=2, label=label*" I", lw=3, kwargs...)
	plot!(p, T, r; color=3, label=label*" R", lw=3, kwargs...)
	
	p
end

# ╔═╡ 58675b3c-1245-11eb-3548-c9cb8a6b3188
plot_sir!(plot(), sir_T, sir_results)

# ╔═╡ 586d0352-1245-11eb-2504-05d0aa2352c6
md"""
👉 Do you see an epidemic outbreak (i.e. a rapid growth in number of infected individuals, followed by a decline)? What happens after a long time? Does everybody get infected?
"""

# ╔═╡ 589b2b4c-1245-11eb-1ec7-693c6bda97c4
default_SIR_parameters_observation = md"""
blabla
"""

# ╔═╡ 58b45a0e-1245-11eb-04d1-23a1f3a0f242
md"""
👉 Make an interactive visualization in which you vary $\beta$ and $\gamma$. What relation should $\beta$ and $\gamma$ have for an epidemic outbreak to occur?
"""

# ╔═╡ 68274534-1103-11eb-0d62-f1acb57721bc


# ╔═╡ 82539bbe-106e-11eb-0e9e-170dfa6a7dad
md"""

## **Exercise 3:** _Numerical gradient_

For fitting we need optimization, and for optimization we will use *derivatives* (rates of change). In Exercise 1, we wrote a function `finite_difference_slope(f, a)` to approximate ``f'(a)``. In this exercise we will write a function to compute _partial derivatives_.
"""

# ╔═╡ b394b44e-1245-11eb-2f86-8d10113e8cfc
md"""
#### Exercise 3.1
👉 Write functions `∂x(f, a, b)` and `∂y(f, a, b)` that calculate the **partial derivatives** $\frac{\partial f}{\partial x}$ and $\frac{\partial f}{\partial y}$ at $(a, b)$ of a function $f : \mathbb{R}^2 \to \mathbb{R}$ (i.e. a function that takes two real numbers and returns one real).

Recall that $\frac{\partial f}{\partial x}$  is the derivative of the single-variable function $g(x) := f(x, b)$ obtained by fixing the value of $y$ to $b$.

You should use **anonymous functions** for this. These have the form `x -> x^2`, meaning "the function that sends $x$ to $x^2$".

"""

# ╔═╡ bd8522c6-12e8-11eb-306c-c764f78486ef
function ∂x(f::Function, a, b)
	
	return missing
end

# ╔═╡ 321964ac-126d-11eb-0a04-0d3e3fb9b17c
∂x(
	(x, y) -> 7x^2 + y, 
	3, 7
)

# ╔═╡ b7d3aa8c-12e8-11eb-3430-ff5d7df6a122
function ∂y(f::Function, a, b)
	
	return missing
end

# ╔═╡ a15509ee-126c-11eb-1fa3-cdda55a47fcb
∂y(
	(x, y) -> 7x^2 + y, 
	3, 7
)

# ╔═╡ b398a29a-1245-11eb-1476-ab65e92d1bc8
md"""
#### Exercise 3.2
👉 Write a function `gradient(f, a, b)` that calculates the **gradient** of a function $f$ at the point $(a, b)$, given by the vector $\nabla f(a, b) := (\frac{\partial f}{\partial x}(a, b), \frac{\partial f}{\partial y}(a, b))$.
"""

# ╔═╡ adbf65fe-12e8-11eb-04e9-3d763ba91a63
function gradient(f::Function, a, b)
	
	return missing
end

# ╔═╡ 66b8e15e-126c-11eb-095e-39c2f6abc81d
gradient(
	(x, y) -> 7x^2 + y, 
	3, 7
)

# ╔═╡ 82579b90-106e-11eb-0018-4553c29e57a2
md"""
## **Exercise 4:** _Minimisation using gradient descent_

In this exercise we will use **gradient descent** to find local **minima** of (smooth enough) functions.

To do so we will think of a function as a hill. To find a minimum we should "roll down the hill".

#### Exercise 4.1

We want to minimize a 1D function, i.e. a function $f: \mathbb{R} \to \mathbb{R}$. To do so we notice that the derivative tells us the direction in which the function *increases*. Positive slope means that the minimum is to the left, negative slope means to the right. So our _gradient descent method_ is to take steps in the *opposite* direction, of a small size $\eta \cdot f'(x_0)$.

👉 Write a function `gradient_descent_1d_step(f, x0)` that performs a single gradient descrent step, from the point `x0` and using your function `finite_difference_slope` to approximate the derivative. The result should be the next guess for ``x``.

"""

# ╔═╡ a7f1829c-12e8-11eb-15a1-5de40ed92587
function gradient_descent_1d_step(f, x0; η=0.01)
	
	return missing
end

# ╔═╡ d33271a2-12df-11eb-172a-bd5600265f49
let
	f = x -> x^2
	# the minimum is at 0, so we should take a small step to the left
	
	gradient_descent_1d_step(f, 5)
end

# ╔═╡ 8ae98c74-12e0-11eb-2802-d9a544d8b7ae
@bind N_gradient_1d Slider(0:20)

# ╔═╡ a53cf3f8-12e1-11eb-0b0c-2b794a7ac841
md" ``x_0 = `` $(@bind x0_gradient_1d Slider(-3:.01:1.5, default=-1, show_value=true))"

# ╔═╡ 754e4c48-12df-11eb-3818-f54f6fc7176b
md"""
👉 Write a function `gradient_descent_1d(f, x0)` that repeatedly applies the previous function (`N_steps` times), starting from the point `x0`, like in the vizualisation above. The result should be the final guess for ``x``.
"""

# ╔═╡ 9489009a-12e8-11eb-2fb7-97ba0bdf339c
function gradient_descent_1d(f, x0; η=0.01, N_steps=1000)
	
	return missing
end

# ╔═╡ 34dc4b02-1248-11eb-26b2-5d2610cfeb41
let
	f = x -> (x - 5)^2 - 3
	# minimum should be at x = 5
	gradient_descent_1d(f, 0.0)
end

# ╔═╡ e3120c18-1246-11eb-3bf4-7f4ac45856e0
md"""
Right now we take a fixed number of steps, even if the minimum is found quickly. What would be a better way to decide when to end the function?
"""

# ╔═╡ ebca11d8-12c9-11eb-3dde-c546eccf40fc
better_stopping_idea = md"""
blabla
"""

# ╔═╡ 9fd2956a-1248-11eb-266d-f558cda55702
md"""
#### Exericse 4.2
Multivariable calculus tells us that the gradient $\nabla f(a, b)$ at a point $(a, b)$ is the direction in which the function *increases* the fastest. So again we should take a small step in the *opposite* direction. Note that the gradient is a *vector* which tells us which direction to move in the plane $(a, b)$. We multiply this vector with the scalar ``\eta`` to control the step size.

👉 Write functions `gradient_descent_2d_step(f, x0, y0)` and `gradient_descent_2d(f, x0, y0)` that do the same for functions $f(x, y)$ of two variables.
"""

# ╔═╡ 852be3c4-12e8-11eb-1bbb-5fbc0da74567
function gradient_descent_2d_step(f, x0, y0; η=0.01)
	
	return missing
end

# ╔═╡ 8a114ca8-12e8-11eb-2de6-9149d1d3bc3d
function gradient_descent_2d(f, x0, y0; η=0.01)
	
	return missing
end

# ╔═╡ 4454c2b2-12e3-11eb-012c-c362c4676bf6
@bind N_gradient_2d Slider(0:20)

# ╔═╡ 4aace1a8-12e3-11eb-3e07-b5827a2a6765
md" ``x_0 = `` $(@bind x0_gradient_2d Slider(-4:.01:4, default=0, show_value=true))"

# ╔═╡ 54a58f84-12e3-11eb-10b9-7d55a16c81ba
md" ``y_0 = `` $(@bind y0_gradient_2d Slider(-4:.01:4, default=0, show_value=true))"

# ╔═╡ a0045046-1248-11eb-13bd-8b8ad861b29a
himmelbau(x, y) = (x^2 + y - 11)^2 + (x + y^2 - 7)^2

# ╔═╡ 92854562-1249-11eb-0b81-156982df1284
gradient_descent_2d(himmelbau, 0, 0)

# ╔═╡ 7e318fea-12e7-11eb-3490-b17e0d4dbc50
md"""
We also prepared a 3D visualisation if you like! It's a bit slow...
"""

# ╔═╡ 605aafa4-12e7-11eb-2d13-7f7db3fac439
run_3d_visualisation = false

# ╔═╡ a03890d6-1248-11eb-37ee-85b0a5273e0c
md"""
👉 Can you find different minima?
"""

# ╔═╡ 6d1ee93e-1103-11eb-140f-63fca63f8b06


# ╔═╡ 8261eb92-106e-11eb-2ccc-1348f232f5c3
md"""
## **Exercise 5:** _Learning parameter values_

In this exercise we will apply gradient descent to fit a simple function $y = f_{\alpha, \beta}(x)$ to some data given as pairs $(x_i, y_i)$. Here $\alpha$ and $\beta$ are **parameters** that appear in the form of the function $f$. We want to find the parameters that provide the **best fit**, i.e. the version $f_{\alpha, \beta}$ of the function that is closest to the data when we vary $\alpha$ and $\beta$.

To do so we need to define what "best" means. We will define a measure of the distance between the function and the data, given by a **loss function**, which itself depends on the values of $\alpha$ and $\beta$. Then we will *minimize* the loss function over $\alpha$ and $\beta$ to find those values that minimize this distance, and hence are "best" in this precise sense.

The iterative procedure by which we gradually adjust the parameter values to improve the loss function is often called **machine learning** or just **learning**, since the computer is "discovering" information in a gradual way, which is supposed to remind us of how humans learn. [Hint: This is not how humans learn.]

#### Exercise 5.1 - _🎲 frequencies_
We generate a small dataset by throwing 10 dice, and counting the sum. We repeat this experiment many times, giving us a frequency distribution in a familiar shape.
"""

# ╔═╡ 65e691e4-124a-11eb-38b1-b1732403aa3d
import Statistics

# ╔═╡ 6f4aa432-1103-11eb-13da-fdd9eefc7c86
function dice_frequencies(N_dice, N_experiments)
	
	experiment() = let
		sum_of_rolls = sum(rand(1:6, N_dice))
	end
	
	results = [experiment() for _ in 1:N_experiments]
	
	x = N_dice : N_dice*6
	
	y = map(x) do total
		sum(isequal(total), results)
	end ./ N_experiments
	
	x, y
end

# ╔═╡ dbe9635a-124b-11eb-111d-fb611954db56
dice_x, dice_y = dice_frequencies(10, 20_000)

# ╔═╡ 57090426-124e-11eb-0a17-1566ae96b7c2
md"""
Let's try to fit a gaussian (normal) distribution. Its PDF with mean $\mu$ and standard deviation $\sigma$ is

$$f_{\mu, \sigma}(x) := \frac{1}{\sigma \sqrt{2 \pi}}\exp \left[- \frac{(x - \mu)^2}{2 \sigma^2} \right]$$

👉 _(Not graded)_ Manually fit a Gaussian distribution to our data by adjusting ``\mu`` and ``\sigma`` until you find a good fit. 
"""

# ╔═╡ 66192a74-124c-11eb-0c6a-d74aecb4c624
md"μ = $(@bind guess_μ Slider(1:0.1:last(dice_x); default = last(dice_x) * 0.4, show_value=true))"

# ╔═╡ 70f0fe9c-124c-11eb-3dc6-e102e68673d9
md"σ = $(@bind guess_σ Slider(0.1:0.1:last(dice_x)/2; default=12, show_value=true))"


# ╔═╡ 41b2262a-124e-11eb-2634-4385e2f3c6b6
md"Show manual fit: $(@bind show_manual_fit CheckBox())"

# ╔═╡ 0dea1f70-124c-11eb-1593-e535ab21976c
function gauss(x, μ, σ)
	(1 / (sqrt(2π) * σ)) * exp(-(x-μ)^2 / σ^2 / 2)
end

# ╔═╡ 471cbd84-124c-11eb-356e-371d23011af5
md"""
What we just did was adjusting the function parameters until we found the best possible fit. Let's automate this process! To do so, we need to quantify how _good or bad_ a fit is.

👉 Define a **loss function** to measure the "distance" between the actual data and the function. It will depend on the values of $\mu$ and $\sigma$ that you choose:

$$\mathcal{L}(\mu, \sigma) := \sum_i [f_{\mu, \sigma}(x_i) - y_i]^2$$
"""

# ╔═╡ 2fc55daa-124f-11eb-399e-659e59148ef5
function loss_dice(μ, σ)
	
	return missing
end

# ╔═╡ 3a6ec2e4-124f-11eb-0f68-791475bab5cd
loss_dice(guess_μ + 3, guess_σ) >
loss_dice(guess_μ, guess_σ)

# ╔═╡ 2fcb93aa-124f-11eb-10de-55fced6f4b83
md"""
👉 Use your `gradient_descent_2d` function to find a local minimum of $\mathcal{L}$, starting with initial values $\mu = 30$ and $\sigma = 1$. Call the found parameters `found_μ` and `found_σ`.
"""

# ╔═╡ a150fd60-124f-11eb-35d6-85104bcfd0fe
found_μ, found_σ = let
	
	# your code here
	
	missing, missing
end

# ╔═╡ ac320522-124b-11eb-1552-51c2adaf2521
let
	p = plot(dice_x, dice_y, size=(600,200), label="data")
	if show_manual_fit
		plot!(p, dice_x, gauss.(dice_x, [guess_μ], [guess_σ]), label="manual fit")
	end
	try
		plot!(p, dice_x, gauss.(dice_x, [found_μ], [found_σ]), label="optimized fit")
	catch
	end
	p
end

# ╔═╡ 3f5e88bc-12c8-11eb-2d74-51f2f5060928
md"""
Go back to the graph to see your optimized gaussian curve!

If your fit is close, then probability theory tells us that the found parameter ``\mu`` should be close to the _weighted mean_ of our data, and ``\sigma`` should approximate the _sample standard deviation_. We have already computed these values, and we check how close they are:
"""

# ╔═╡ 65aa13fe-1266-11eb-03c2-5927dbeca36e
stats_μ = sum(dice_x .* dice_y)

# ╔═╡ c569a5d8-1267-11eb-392f-452de141161b
abs(stats_μ - found_μ)

# ╔═╡ 6faf4074-1266-11eb-1a0a-991fc2e991bb
stats_σ = sqrt(sum(dice_x.^2 .* dice_y) - stats_μ .^ 2)

# ╔═╡ e55d9c1e-1267-11eb-1b3c-5d772662518a
abs(stats_σ - found_σ)

# ╔═╡ 826bb0dc-106e-11eb-29eb-03e7ddf9e4b5
md"""

## **Exercise 6:** _Putting it all together — fitting an SIR model to data_

In this exercise we will fit the (non-spatial) SIR ODE model from Exercise 1 to some data generated from the spatial model in Problem Set 4. 
If we are able to find a good fit, that would suggest that the spatial aspect "does not matter" too much for the dynamics of these models. 
If the fit is not so good, perhaps there is an important effect of space. (As usual in statistics, and indeed in modelling in general, we should be very cautious of making claims of this nature.)

This fitting procedure will be different from that in Exercise 4, however: we no longer have an explicit form for the function that we are fitting -- rather, it is the output of an ODE! So what should we do?

We will try to find the parameters $\beta$ and $\gamma$ for which *the output of the ODEs when we simulate it with those parameters* best matches the data!

#### Exercise 6.1

Below the result from Homework 4, Exercise 3.2. These are the _average S, I, R fractions_ of running 20 simulations. Click on it!
"""

# ╔═╡ c56cc19c-12ca-11eb-3c6c-7f3ea98eeb4e
hw4_results_transposed = (S = [0.99, 0.9895, 0.9895, 0.989, 0.9885, 0.9885, 0.9885, 0.988, 0.9865, 0.986, 0.9855, 0.9855, 0.9855, 0.9845, 0.9845, 0.9845, 0.984, 0.984, 0.984, 0.9835, 0.9835, 0.982, 0.982, 0.982, 0.982, 0.9815, 0.981, 0.9805, 0.98, 0.98, 0.98, 0.98, 0.9795, 0.9795, 0.979, 0.979, 0.979, 0.978, 0.9775, 0.9775, 0.977, 0.976, 0.9755, 0.9745, 0.9735, 0.9735, 0.973, 0.972, 0.972, 0.972, 0.971, 0.971, 0.9695, 0.968, 0.9675, 0.967, 0.9665, 0.966, 0.9655, 0.9645, 0.9645, 0.9645, 0.964, 0.9615, 0.9595, 0.959, 0.958, 0.9575, 0.9575, 0.9575, 0.9565, 0.956, 0.954, 0.9535, 0.9535, 0.951, 0.95, 0.949, 0.9485, 0.948, 0.947, 0.9465, 0.9465, 0.9455, 0.945, 0.9425, 0.9415, 0.9405, 0.9395, 0.9385, 0.938, 0.937, 0.9355, 0.9355, 0.935, 0.9325, 0.932, 0.93, 0.929, 0.927, 0.9265, 0.926, 0.9245, 0.924, 0.9235, 0.923, 0.9225, 0.9225, 0.922, 0.9215, 0.9195, 0.918, 0.915, 0.9125, 0.911, 0.907, 0.9055, 0.9045, 0.9025, 0.9005, 0.899, 0.898, 0.8965, 0.8955, 0.893, 0.892, 0.89, 0.8875, 0.885, 0.8835, 0.882, 0.8805, 0.8785, 0.8755, 0.8735, 0.869, 0.868, 0.868, 0.8645, 0.8625, 0.8605, 0.8575, 0.8545, 0.8505, 0.847, 0.8455, 0.8435, 0.8415, 0.84, 0.8385, 0.8365, 0.8345, 0.829, 0.826, 0.824, 0.822, 0.817, 0.8145, 0.814, 0.811, 0.8095, 0.8075, 0.805, 0.8005, 0.7985, 0.7965, 0.793, 0.7895, 0.7865, 0.785, 0.7815, 0.779, 0.776, 0.769, 0.7655, 0.764, 0.7625, 0.7595, 0.7575, 0.754, 0.751, 0.7485, 0.743, 0.7395, 0.736, 0.7355, 0.732, 0.728, 0.725, 0.7235, 0.7215, 0.718, 0.7165, 0.7135, 0.7095, 0.709, 0.705, 0.7015, 0.699, 0.697, 0.694, 0.69, 0.685, 0.6835, 0.6805, 0.6795, 0.6765, 0.6745, 0.6735, 0.6705, 0.6665, 0.6625, 0.66, 0.656, 0.653, 0.65, 0.6465, 0.641, 0.639, 0.6365, 0.6335, 0.632, 0.6285, 0.6265, 0.623, 0.6195, 0.617, 0.6125, 0.609, 0.607, 0.6045, 0.601, 0.596, 0.591, 0.5905, 0.5885, 0.5825, 0.579, 0.576, 0.574, 0.5705, 0.569, 0.563, 0.559, 0.5565, 0.555, 0.5515, 0.546, 0.5455, 0.5435, 0.5395, 0.538, 0.535, 0.5315, 0.528, 0.525, 0.523, 0.519, 0.516, 0.513, 0.511, 0.509, 0.5065, 0.5045, 0.5015, 0.497, 0.4925, 0.488, 0.485, 0.4795, 0.473, 0.47, 0.465, 0.4595, 0.457, 0.454, 0.45, 0.447, 0.444, 0.4405, 0.4385, 0.4345, 0.431, 0.4275, 0.4245, 0.422, 0.421, 0.418, 0.414, 0.411, 0.4075, 0.404, 0.4015, 0.398, 0.3945, 0.3915, 0.39, 0.3875, 0.385, 0.3825, 0.379, 0.3765, 0.3725, 0.3685, 0.3655, 0.364, 0.359, 0.3555, 0.3555, 0.354, 0.351, 0.3495, 0.347, 0.345, 0.343, 0.341, 0.3365, 0.3325, 0.3325, 0.3275, 0.3255, 0.3225, 0.3205, 0.3195, 0.3175, 0.316, 0.313, 0.3125, 0.31, 0.308, 0.3055, 0.302, 0.301, 0.299, 0.297, 0.294, 0.29, 0.2895, 0.2855, 0.283, 0.2825, 0.279, 0.276, 0.273, 0.2695, 0.2665, 0.2655, 0.2635, 0.261, 0.2595, 0.258, 0.257, 0.254, 0.2535, 0.251, 0.25, 0.2465, 0.245, 0.2435, 0.2415, 0.2405, 0.238, 0.2365, 0.235, 0.2335, 0.2325, 0.23, 0.2275, 0.226, 0.2245, 0.2235, 0.223, 0.22, 0.218, 0.2165, 0.2135, 0.2135, 0.2095, 0.2075, 0.206, 0.205, 0.2045, 0.2025, 0.201, 0.2, 0.1985, 0.1985, 0.196, 0.1945, 0.1915, 0.1895, 0.188, 0.185, 0.184, 0.1835, 0.1835, 0.183, 0.183, 0.182, 0.182, 0.1805, 0.179, 0.1785, 0.177, 0.176, 0.1745, 0.174, 0.1735, 0.173, 0.1715, 0.171, 0.1685, 0.167, 0.1665, 0.165, 0.1645, 0.163, 0.162, 0.162, 0.1605, 0.1605, 0.16, 0.159, 0.158, 0.1555, 0.155, 0.1545, 0.1545, 0.152, 0.1505, 0.15, 0.149, 0.1475, 0.1465, 0.1445, 0.1435, 0.142, 0.1405, 0.14, 0.14, 0.139, 0.139, 0.1375, 0.137, 0.136, 0.1355, 0.135, 0.134, 0.1335, 0.133, 0.133, 0.1325, 0.1315, 0.1305, 0.13, 0.1295, 0.1295, 0.1275, 0.1265, 0.126, 0.126, 0.125, 0.124, 0.124, 0.1235, 0.1225, 0.1225, 0.1225, 0.122, 0.121, 0.1205, 0.1205, 0.1195, 0.1185, 0.117, 0.1145, 0.1135, 0.113, 0.113, 0.113, 0.112, 0.1105, 0.11, 0.109, 0.1085, 0.1055, 0.1055, 0.105, 0.105, 0.105, 0.105, 0.1035, 0.103, 0.1025, 0.102, 0.101, 0.1005, 0.0995, 0.099, 0.0975, 0.0965, 0.096, 0.096, 0.095, 0.095, 0.095, 0.0945, 0.0935, 0.0935, 0.0925, 0.091, 0.091, 0.0905, 0.09, 0.09, 0.09, 0.09, 0.0895, 0.0895, 0.0895, 0.088, 0.087, 0.0865, 0.0865, 0.086, 0.085, 0.085, 0.0845, 0.0845, 0.084, 0.084, 0.084, 0.084, 0.0835, 0.0825, 0.0825, 0.082, 0.082, 0.0815, 0.081, 0.081, 0.0805, 0.0795, 0.0795, 0.0795, 0.0795, 0.0795, 0.079, 0.0785, 0.078, 0.0775, 0.077, 0.076, 0.076, 0.076, 0.076, 0.076, 0.0755, 0.0755, 0.0755, 0.0755, 0.0755, 0.075, 0.075, 0.075, 0.075, 0.074, 0.074, 0.074, 0.0735, 0.0735, 0.0735, 0.0735, 0.073, 0.072, 0.072, 0.072, 0.072, 0.0715, 0.0715, 0.0715, 0.0705, 0.0705, 0.0695, 0.0695, 0.0695, 0.0695, 0.0695, 0.0695, 0.069, 0.069, 0.0685, 0.0685, 0.0685, 0.0685, 0.0685, 0.0685, 0.068, 0.0675, 0.0665, 0.0665, 0.0665, 0.0665, 0.0665, 0.066, 0.066, 0.066, 0.0655, 0.065, 0.065, 0.065, 0.0645, 0.0645, 0.0645, 0.0645, 0.064, 0.064, 0.0635, 0.0635, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.062, 0.062, 0.062, 0.062, 0.062, 0.062, 0.062, 0.062, 0.062, 0.062, 0.062, 0.0615, 0.0615, 0.0615, 0.0615, 0.0615, 0.0615, 0.061, 0.0605, 0.0605, 0.0605, 0.06, 0.0595, 0.0595, 0.0595, 0.059, 0.059, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.0585, 0.058, 0.058, 0.058, 0.058, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.0575, 0.057, 0.057, 0.057, 0.057, 0.057, 0.057, 0.057, 0.057, 0.057, 0.057, 0.057, 0.057, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.0565, 0.056, 0.056, 0.056, 0.056, 0.056, 0.0555, 0.0555, 0.0555, 0.0555, 0.0555, 0.0555, 0.0555, 0.0555, 0.0555, 0.0555, 0.0555, 0.055, 0.055, 0.0545, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.054, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.053, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.0525, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.052, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.0515, 0.051, 0.051, 0.051, 0.051, 0.051, 0.051, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.0505, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05], I = [0.01, 0.0105, 0.0105, 0.011, 0.0115, 0.0115, 0.0115, 0.0115, 0.013, 0.0135, 0.014, 0.014, 0.014, 0.015, 0.015, 0.015, 0.0155, 0.0155, 0.0155, 0.016, 0.016, 0.0175, 0.0175, 0.0175, 0.017, 0.0175, 0.018, 0.0185, 0.019, 0.019, 0.019, 0.019, 0.0195, 0.0195, 0.02, 0.02, 0.0195, 0.0205, 0.0205, 0.0205, 0.021, 0.022, 0.022, 0.023, 0.024, 0.024, 0.0245, 0.0255, 0.0255, 0.0255, 0.0265, 0.0265, 0.028, 0.0295, 0.03, 0.0305, 0.031, 0.0315, 0.032, 0.033, 0.033, 0.033, 0.0335, 0.036, 0.037, 0.0375, 0.0385, 0.039, 0.039, 0.039, 0.0395, 0.0395, 0.0415, 0.042, 0.0415, 0.0435, 0.0445, 0.0455, 0.0455, 0.046, 0.047, 0.0475, 0.0475, 0.0485, 0.0485, 0.051, 0.052, 0.053, 0.053, 0.054, 0.0545, 0.0555, 0.057, 0.057, 0.0575, 0.06, 0.0605, 0.0625, 0.0635, 0.0645, 0.065, 0.0655, 0.067, 0.0675, 0.068, 0.0685, 0.069, 0.069, 0.0695, 0.07, 0.072, 0.0735, 0.076, 0.0785, 0.0795, 0.0835, 0.0845, 0.0855, 0.0875, 0.0895, 0.091, 0.0915, 0.093, 0.0935, 0.096, 0.097, 0.0985, 0.101, 0.1035, 0.105, 0.1065, 0.108, 0.1095, 0.1125, 0.1135, 0.1175, 0.1185, 0.1185, 0.122, 0.124, 0.126, 0.1285, 0.1315, 0.1355, 0.1385, 0.14, 0.1415, 0.1435, 0.1445, 0.144, 0.146, 0.148, 0.1535, 0.1565, 0.1585, 0.1605, 0.1655, 0.1675, 0.168, 0.171, 0.172, 0.174, 0.176, 0.1795, 0.181, 0.1815, 0.1845, 0.188, 0.191, 0.192, 0.1955, 0.1975, 0.199, 0.206, 0.209, 0.21, 0.2105, 0.213, 0.215, 0.218, 0.2205, 0.2225, 0.2275, 0.2305, 0.2335, 0.2335, 0.2365, 0.24, 0.242, 0.242, 0.244, 0.2465, 0.2475, 0.2505, 0.2535, 0.2525, 0.256, 0.259, 0.261, 0.2625, 0.2645, 0.268, 0.273, 0.273, 0.2745, 0.2755, 0.278, 0.28, 0.281, 0.2835, 0.2865, 0.2905, 0.292, 0.295, 0.2975, 0.3, 0.303, 0.308, 0.3095, 0.3115, 0.313, 0.3145, 0.318, 0.319, 0.3225, 0.326, 0.328, 0.332, 0.333, 0.334, 0.3355, 0.3385, 0.3435, 0.348, 0.3475, 0.347, 0.353, 0.356, 0.3585, 0.36, 0.3635, 0.365, 0.371, 0.3745, 0.376, 0.3765, 0.379, 0.3835, 0.384, 0.386, 0.3875, 0.3875, 0.3895, 0.3915, 0.395, 0.397, 0.3975, 0.3995, 0.402, 0.4035, 0.4055, 0.4075, 0.409, 0.41, 0.4115, 0.416, 0.42, 0.424, 0.4255, 0.4305, 0.4355, 0.4375, 0.441, 0.445, 0.4465, 0.4475, 0.4505, 0.4535, 0.4565, 0.4595, 0.4605, 0.4635, 0.4665, 0.4695, 0.472, 0.474, 0.4745, 0.4775, 0.48, 0.483, 0.4835, 0.4865, 0.489, 0.491, 0.4935, 0.495, 0.4945, 0.4965, 0.4985, 0.5, 0.502, 0.5045, 0.508, 0.51, 0.5125, 0.514, 0.518, 0.52, 0.5185, 0.519, 0.5215, 0.522, 0.5225, 0.5235, 0.5245, 0.525, 0.529, 0.5315, 0.5315, 0.5345, 0.5355, 0.5375, 0.5385, 0.538, 0.54, 0.541, 0.5435, 0.5425, 0.5445, 0.545, 0.547, 0.549, 0.549, 0.55, 0.551, 0.553, 0.5565, 0.557, 0.56, 0.562, 0.5615, 0.564, 0.5655, 0.5655, 0.5665, 0.569, 0.567, 0.5665, 0.569, 0.568, 0.568, 0.5675, 0.5695, 0.569, 0.5705, 0.5695, 0.572, 0.5725, 0.574, 0.575, 0.5755, 0.5775, 0.5775, 0.5785, 0.5785, 0.579, 0.5805, 0.582, 0.583, 0.583, 0.583, 0.5815, 0.5825, 0.584, 0.585, 0.5855, 0.584, 0.5865, 0.587, 0.5875, 0.5875, 0.5865, 0.587, 0.587, 0.5875, 0.588, 0.5865, 0.588, 0.5885, 0.5905, 0.5915, 0.5925, 0.5945, 0.5935, 0.592, 0.5905, 0.5905, 0.5905, 0.5905, 0.59, 0.59, 0.5905, 0.589, 0.589, 0.5885, 0.5875, 0.5875, 0.585, 0.584, 0.584, 0.583, 0.5835, 0.583, 0.582, 0.5825, 0.582, 0.5825, 0.582, 0.581, 0.582, 0.581, 0.579, 0.5785, 0.5775, 0.5795, 0.58, 0.579, 0.576, 0.578, 0.579, 0.579, 0.578, 0.5795, 0.5795, 0.5805, 0.58, 0.5805, 0.5815, 0.5805, 0.5795, 0.5795, 0.5775, 0.5765, 0.576, 0.5765, 0.576, 0.5755, 0.5755, 0.5755, 0.575, 0.5745, 0.5745, 0.574, 0.573, 0.573, 0.5715, 0.568, 0.5695, 0.5705, 0.571, 0.5705, 0.5695, 0.5695, 0.569, 0.569, 0.569, 0.5685, 0.566, 0.565, 0.5655, 0.565, 0.564, 0.564, 0.563, 0.563, 0.565, 0.564, 0.564, 0.563, 0.563, 0.5635, 0.564, 0.563, 0.5635, 0.563, 0.5655, 0.564, 0.5635, 0.562, 0.562, 0.5605, 0.5605, 0.5595, 0.559, 0.5595, 0.5595, 0.559, 0.558, 0.557, 0.5575, 0.5575, 0.556, 0.5555, 0.5545, 0.5525, 0.5495, 0.549, 0.549, 0.5475, 0.5475, 0.548, 0.548, 0.548, 0.547, 0.5445, 0.5425, 0.5425, 0.5425, 0.5415, 0.541, 0.5415, 0.541, 0.5405, 0.5395, 0.5395, 0.54, 0.539, 0.539, 0.5375, 0.5365, 0.5355, 0.535, 0.5345, 0.534, 0.5345, 0.534, 0.533, 0.5325, 0.5315, 0.532, 0.5315, 0.5315, 0.5315, 0.531, 0.53, 0.5295, 0.528, 0.526, 0.5255, 0.5235, 0.524, 0.523, 0.5215, 0.521, 0.521, 0.5205, 0.5205, 0.5205, 0.52, 0.519, 0.5185, 0.517, 0.5165, 0.5145, 0.5135, 0.513, 0.513, 0.513, 0.513, 0.5135, 0.5125, 0.5125, 0.511, 0.5115, 0.5125, 0.5115, 0.511, 0.511, 0.51, 0.5095, 0.509, 0.509, 0.5065, 0.5065, 0.506, 0.5045, 0.504, 0.502, 0.4995, 0.4995, 0.4995, 0.4995, 0.4985, 0.4965, 0.493, 0.492, 0.492, 0.491, 0.49, 0.4905, 0.4905, 0.4905, 0.4905, 0.4895, 0.489, 0.488, 0.4875, 0.488, 0.486, 0.4855, 0.4855, 0.485, 0.484, 0.483, 0.4825, 0.483, 0.482, 0.4815, 0.481, 0.4815, 0.4805, 0.4785, 0.4775, 0.477, 0.475, 0.4735, 0.473, 0.4725, 0.471, 0.4705, 0.47, 0.469, 0.4675, 0.4675, 0.466, 0.466, 0.4645, 0.4635, 0.4625, 0.4615, 0.461, 0.46, 0.4595, 0.458, 0.458, 0.457, 0.457, 0.4565, 0.4545, 0.454, 0.453, 0.452, 0.451, 0.4495, 0.449, 0.448, 0.4465, 0.4465, 0.4455, 0.4455, 0.4455, 0.4455, 0.4455, 0.445, 0.444, 0.444, 0.4425, 0.4415, 0.44, 0.4385, 0.438, 0.437, 0.436, 0.4355, 0.435, 0.4345, 0.432, 0.4295, 0.4295, 0.428, 0.427, 0.426, 0.4255, 0.4245, 0.4215, 0.4215, 0.4205, 0.4205, 0.42, 0.4195, 0.4195, 0.4185, 0.4165, 0.4155, 0.4135, 0.412, 0.4125, 0.4105, 0.41, 0.409, 0.4075, 0.407, 0.407, 0.4065, 0.405, 0.4045, 0.404, 0.4035, 0.404, 0.4015, 0.4, 0.3995, 0.398, 0.398, 0.397, 0.397, 0.397, 0.396, 0.396, 0.395, 0.3945, 0.395, 0.394, 0.393, 0.393, 0.393, 0.392, 0.391, 0.3905, 0.39, 0.389, 0.3885, 0.388, 0.387, 0.386, 0.385, 0.384, 0.384, 0.3835, 0.3825, 0.3825, 0.3825, 0.3815, 0.3815, 0.38, 0.38, 0.3795, 0.379, 0.379, 0.378, 0.377, 0.3765, 0.376, 0.3755, 0.3735, 0.3715, 0.371, 0.3715, 0.371, 0.3705, 0.37, 0.37, 0.369, 0.369, 0.3675, 0.367, 0.367, 0.3655, 0.364, 0.3625, 0.3615, 0.361, 0.3605, 0.3605, 0.36, 0.3595, 0.359, 0.3575, 0.3575, 0.357, 0.3565, 0.355, 0.355, 0.354, 0.3535, 0.353, 0.352, 0.352, 0.3515, 0.351, 0.3495, 0.3495, 0.349, 0.348, 0.3475, 0.345, 0.344, 0.3435, 0.3425, 0.3425, 0.341, 0.3395, 0.3395, 0.339, 0.3375, 0.337, 0.336, 0.336, 0.3345, 0.3345, 0.334, 0.3335, 0.3335, 0.3325, 0.3325, 0.3315, 0.3295, 0.3285, 0.328, 0.328, 0.326, 0.326, 0.326, 0.326, 0.326, 0.3255, 0.325, 0.3235, 0.3225, 0.3215, 0.3215, 0.3215, 0.321, 0.3195, 0.318, 0.3175, 0.317, 0.3165, 0.316, 0.3155, 0.3155, 0.315, 0.3145, 0.3135, 0.3135, 0.313, 0.3105, 0.31, 0.31, 0.308, 0.3075, 0.3075, 0.3075, 0.307, 0.305, 0.3045, 0.3035, 0.3035, 0.3015, 0.3015, 0.3015, 0.3015, 0.301, 0.3, 0.2995, 0.2995, 0.299, 0.299, 0.298, 0.298, 0.297, 0.2965, 0.2945, 0.294, 0.293, 0.293, 0.2915, 0.2915, 0.291, 0.2905, 0.29, 0.289, 0.289, 0.288, 0.288, 0.288, 0.288, 0.288, 0.2865, 0.2855, 0.2855, 0.2845, 0.2835, 0.283, 0.282, 0.2815, 0.281, 0.281, 0.2805, 0.281, 0.2805, 0.2795, 0.2785, 0.278, 0.278, 0.2785, 0.2785, 0.277, 0.2765, 0.275, 0.2745, 0.2745, 0.2745, 0.274, 0.273, 0.273, 0.273, 0.2715, 0.27, 0.2695, 0.2695, 0.269, 0.2685, 0.268, 0.267, 0.266, 0.266, 0.265, 0.2645, 0.2645, 0.2635, 0.263, 0.2625, 0.2625, 0.262, 0.262, 0.2605, 0.26, 0.259, 0.2575, 0.2565, 0.2555, 0.255, 0.254, 0.253, 0.2525, 0.251, 0.2505, 0.2505, 0.2505, 0.25, 0.2495, 0.2495, 0.2495, 0.249, 0.249, 0.249, 0.2485, 0.2475, 0.246, 0.246, 0.245, 0.245, 0.2445, 0.2445, 0.244, 0.244, 0.2435, 0.2425, 0.242, 0.242, 0.2415, 0.2405, 0.239, 0.238, 0.2375, 0.2365, 0.2365, 0.2365, 0.236, 0.236, 0.2365, 0.2365, 0.2365, 0.2365, 0.236, 0.235, 0.2345, 0.234, 0.234, 0.2335, 0.2335, 0.233, 0.233, 0.2325, 0.232, 0.2315, 0.231, 0.2295, 0.2285], R = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.0005, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.0015, 0.0015, 0.002, 0.002, 0.002, 0.002, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0025, 0.0035, 0.0035, 0.0035, 0.0035, 0.0035, 0.0035, 0.004, 0.0045, 0.0045, 0.0045, 0.005, 0.0055, 0.0055, 0.0055, 0.006, 0.006, 0.006, 0.006, 0.006, 0.006, 0.0065, 0.0065, 0.0065, 0.0065, 0.0075, 0.0075, 0.0075, 0.0075, 0.0075, 0.0075, 0.0075, 0.0075, 0.0075, 0.0075, 0.0075, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.0085, 0.009, 0.009, 0.0095, 0.0095, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0105, 0.0105, 0.011, 0.011, 0.011, 0.0115, 0.0115, 0.0115, 0.0115, 0.0115, 0.0115, 0.012, 0.012, 0.013, 0.0135, 0.0135, 0.0135, 0.0135, 0.0135, 0.0135, 0.014, 0.014, 0.014, 0.0145, 0.0145, 0.015, 0.015, 0.0155, 0.0175, 0.0175, 0.0175, 0.0175, 0.0175, 0.0175, 0.0175, 0.0175, 0.018, 0.018, 0.018, 0.0185, 0.0185, 0.019, 0.02, 0.0205, 0.022, 0.0225, 0.0225, 0.0225, 0.023, 0.023, 0.0235, 0.025, 0.025, 0.0255, 0.026, 0.027, 0.0275, 0.0275, 0.028, 0.0285, 0.029, 0.0295, 0.03, 0.0305, 0.031, 0.0315, 0.032, 0.033, 0.0345, 0.0345, 0.0355, 0.036, 0.036, 0.037, 0.0385, 0.039, 0.0395, 0.04, 0.0405, 0.0415, 0.042, 0.042, 0.0435, 0.045, 0.045, 0.0455, 0.0455, 0.0455, 0.046, 0.047, 0.047, 0.048, 0.049, 0.0495, 0.05, 0.0505, 0.051, 0.0515, 0.052, 0.0535, 0.0535, 0.0535, 0.0545, 0.0545, 0.0545, 0.055, 0.0555, 0.058, 0.059, 0.06, 0.0605, 0.0605, 0.061, 0.062, 0.0645, 0.0645, 0.065, 0.0655, 0.066, 0.066, 0.066, 0.066, 0.0665, 0.0675, 0.0685, 0.0695, 0.0705, 0.0705, 0.0705, 0.073, 0.0745, 0.0755, 0.077, 0.077, 0.078, 0.0795, 0.0815, 0.082, 0.0835, 0.0835, 0.0835, 0.0845, 0.0855, 0.087, 0.087, 0.0875, 0.088, 0.0895, 0.09, 0.0915, 0.0925, 0.094, 0.0955, 0.0965, 0.0985, 0.0995, 0.0995, 0.0995, 0.1, 0.101, 0.102, 0.1025, 0.103, 0.1035, 0.104, 0.1045, 0.1045, 0.106, 0.106, 0.109, 0.1095, 0.1095, 0.111, 0.112, 0.1135, 0.1155, 0.116, 0.1165, 0.1175, 0.119, 0.119, 0.1195, 0.1215, 0.122, 0.122, 0.123, 0.1245, 0.126, 0.127, 0.1275, 0.1285, 0.1305, 0.1315, 0.1325, 0.134, 0.1345, 0.136, 0.136, 0.138, 0.139, 0.14, 0.141, 0.1425, 0.1425, 0.143, 0.1435, 0.145, 0.1455, 0.147, 0.1475, 0.149, 0.15, 0.151, 0.152, 0.153, 0.1535, 0.1535, 0.1545, 0.155, 0.156, 0.157, 0.1585, 0.1615, 0.164, 0.1645, 0.1675, 0.17, 0.17, 0.1725, 0.174, 0.1755, 0.1765, 0.1775, 0.1785, 0.1805, 0.1815, 0.1825, 0.1825, 0.1835, 0.184, 0.1845, 0.186, 0.1865, 0.188, 0.1885, 0.1895, 0.1905, 0.191, 0.1925, 0.1935, 0.1955, 0.1975, 0.198, 0.1985, 0.201, 0.2025, 0.204, 0.2055, 0.2065, 0.2075, 0.209, 0.2105, 0.212, 0.2125, 0.2135, 0.215, 0.216, 0.217, 0.218, 0.219, 0.2195, 0.2205, 0.2225, 0.2245, 0.226, 0.2265, 0.2265, 0.2275, 0.228, 0.2295, 0.2305, 0.2325, 0.234, 0.2355, 0.238, 0.2385, 0.2415, 0.243, 0.2445, 0.246, 0.248, 0.25, 0.2515, 0.2525, 0.2535, 0.2545, 0.256, 0.257, 0.2575, 0.2585, 0.261, 0.2625, 0.2645, 0.265, 0.265, 0.2665, 0.2695, 0.27, 0.2705, 0.271, 0.273, 0.273, 0.274, 0.275, 0.2765, 0.2775, 0.278, 0.2795, 0.2805, 0.2815, 0.2835, 0.286, 0.287, 0.2875, 0.2885, 0.2895, 0.2905, 0.291, 0.292, 0.2925, 0.293, 0.2945, 0.2965, 0.297, 0.299, 0.3025, 0.303, 0.303, 0.303, 0.3035, 0.3055, 0.3065, 0.307, 0.3075, 0.3085, 0.309, 0.3115, 0.313, 0.3135, 0.3145, 0.3155, 0.3165, 0.3185, 0.32, 0.3205, 0.3225, 0.323, 0.324, 0.324, 0.3245, 0.3255, 0.327, 0.3275, 0.3285, 0.329, 0.3305, 0.3315, 0.333, 0.333, 0.3345, 0.336, 0.3375, 0.3385, 0.3385, 0.3395, 0.3405, 0.3425, 0.344, 0.345, 0.346, 0.348, 0.3485, 0.3505, 0.3525, 0.3555, 0.3565, 0.3575, 0.359, 0.36, 0.361, 0.361, 0.3615, 0.363, 0.3655, 0.3675, 0.3675, 0.368, 0.369, 0.3695, 0.3705, 0.372, 0.373, 0.374, 0.3745, 0.375, 0.376, 0.3765, 0.378, 0.3795, 0.3805, 0.381, 0.3815, 0.3825, 0.383, 0.3835, 0.385, 0.3855, 0.387, 0.387, 0.3875, 0.388, 0.389, 0.3895, 0.3905, 0.391, 0.3925, 0.395, 0.396, 0.3985, 0.3985, 0.4, 0.4025, 0.403, 0.403, 0.4035, 0.4035, 0.404, 0.4045, 0.4055, 0.406, 0.4075, 0.4085, 0.4105, 0.4115, 0.412, 0.413, 0.413, 0.413, 0.413, 0.414, 0.414, 0.4155, 0.4155, 0.4155, 0.4165, 0.417, 0.417, 0.4185, 0.419, 0.4195, 0.4205, 0.423, 0.424, 0.4245, 0.426, 0.4265, 0.4285, 0.431, 0.4315, 0.4315, 0.432, 0.433, 0.435, 0.4385, 0.4395, 0.4395, 0.441, 0.4425, 0.443, 0.443, 0.443, 0.443, 0.444, 0.445, 0.446, 0.4465, 0.4465, 0.449, 0.4495, 0.4495, 0.4505, 0.4515, 0.4525, 0.453, 0.453, 0.454, 0.455, 0.4555, 0.456, 0.457, 0.459, 0.46, 0.4605, 0.4625, 0.464, 0.4645, 0.465, 0.4665, 0.467, 0.4675, 0.4685, 0.47, 0.47, 0.4715, 0.472, 0.4735, 0.4745, 0.4755, 0.4765, 0.477, 0.478, 0.4785, 0.48, 0.48, 0.481, 0.4815, 0.482, 0.484, 0.4845, 0.4855, 0.4865, 0.488, 0.49, 0.4905, 0.4915, 0.4935, 0.494, 0.495, 0.495, 0.4955, 0.4955, 0.496, 0.4965, 0.4975, 0.4975, 0.499, 0.5, 0.5015, 0.503, 0.5035, 0.5045, 0.5055, 0.506, 0.5065, 0.5075, 0.51, 0.5125, 0.5125, 0.5145, 0.5155, 0.5165, 0.517, 0.518, 0.521, 0.521, 0.522, 0.522, 0.5225, 0.523, 0.523, 0.524, 0.526, 0.527, 0.529, 0.5305, 0.5305, 0.5325, 0.533, 0.534, 0.5355, 0.536, 0.536, 0.5365, 0.538, 0.5385, 0.539, 0.5395, 0.5395, 0.542, 0.5435, 0.544, 0.5455, 0.5455, 0.5465, 0.5465, 0.5465, 0.5475, 0.5475, 0.5485, 0.549, 0.549, 0.55, 0.551, 0.551, 0.551, 0.5525, 0.5535, 0.554, 0.5545, 0.5555, 0.556, 0.5565, 0.5575, 0.5585, 0.5595, 0.5605, 0.561, 0.5615, 0.563, 0.5635, 0.5635, 0.5645, 0.5645, 0.566, 0.566, 0.5665, 0.567, 0.567, 0.568, 0.569, 0.5695, 0.57, 0.5705, 0.5725, 0.5745, 0.575, 0.5755, 0.576, 0.5765, 0.577, 0.577, 0.578, 0.578, 0.5795, 0.58, 0.58, 0.5815, 0.583, 0.5845, 0.5855, 0.586, 0.5865, 0.5865, 0.587, 0.5875, 0.588, 0.5895, 0.5895, 0.59, 0.5905, 0.592, 0.592, 0.593, 0.5935, 0.594, 0.595, 0.595, 0.596, 0.5965, 0.598, 0.598, 0.5985, 0.5995, 0.6, 0.6025, 0.6035, 0.604, 0.605, 0.605, 0.6065, 0.608, 0.608, 0.6085, 0.61, 0.6105, 0.6115, 0.6115, 0.613, 0.613, 0.6135, 0.614, 0.614, 0.615, 0.615, 0.616, 0.618, 0.619, 0.6195, 0.6195, 0.6215, 0.6215, 0.6215, 0.6215, 0.6215, 0.622, 0.6225, 0.624, 0.625, 0.626, 0.6265, 0.6265, 0.627, 0.6285, 0.63, 0.6305, 0.631, 0.6315, 0.632, 0.6325, 0.6325, 0.633, 0.6335, 0.6345, 0.6345, 0.635, 0.6375, 0.638, 0.638, 0.64, 0.6405, 0.6405, 0.6405, 0.641, 0.643, 0.6435, 0.6445, 0.6445, 0.6465, 0.6465, 0.6465, 0.6465, 0.647, 0.648, 0.6485, 0.6485, 0.649, 0.649, 0.65, 0.65, 0.651, 0.6515, 0.6535, 0.654, 0.655, 0.655, 0.6565, 0.6565, 0.657, 0.6575, 0.658, 0.659, 0.659, 0.6605, 0.6605, 0.6605, 0.6605, 0.6605, 0.662, 0.663, 0.663, 0.664, 0.665, 0.6655, 0.6665, 0.667, 0.6675, 0.6675, 0.668, 0.668, 0.6685, 0.6695, 0.6705, 0.671, 0.671, 0.671, 0.671, 0.6725, 0.673, 0.6745, 0.675, 0.675, 0.675, 0.6755, 0.6765, 0.6765, 0.6765, 0.678, 0.6795, 0.68, 0.68, 0.6805, 0.681, 0.6815, 0.6825, 0.6835, 0.6835, 0.6845, 0.685, 0.685, 0.686, 0.6865, 0.687, 0.687, 0.6875, 0.6875, 0.689, 0.6895, 0.6905, 0.692, 0.693, 0.694, 0.6945, 0.6955, 0.6965, 0.697, 0.6985, 0.699, 0.699, 0.699, 0.6995, 0.7, 0.7, 0.7, 0.7005, 0.7005, 0.7005, 0.701, 0.702, 0.7035, 0.7035, 0.7045, 0.7045, 0.705, 0.705, 0.7055, 0.7055, 0.706, 0.707, 0.7075, 0.7075, 0.708, 0.709, 0.7105, 0.7115, 0.712, 0.713, 0.713, 0.713, 0.7135, 0.7135, 0.7135, 0.7135, 0.7135, 0.7135, 0.714, 0.715, 0.7155, 0.716, 0.716, 0.7165, 0.7165, 0.717, 0.717, 0.7175, 0.718, 0.7185, 0.719, 0.7205, 0.7215]);

# ╔═╡ 249c297c-12ce-11eb-2054-d1e926335148
hw4_results = collect.(zip(hw4_results_transposed...))

# ╔═╡ 04364dee-12cb-11eb-2f94-bfd3fb405907
hw4_T = 1:length(hw4_results)

# ╔═╡ 480fde46-12d4-11eb-2dfb-1b71692c7420
md"""
👉 _(Not graded)_ Manually fit the SIR curves to our data by adjusting ``\beta`` and ``\gamma`` until you find a good fit.
"""

# ╔═╡ 4837e1ae-12d2-11eb-0df9-21dcc1892fc9
md"β = $(@bind guess_β Slider(0.00:0.0001:0.1; default = 0.05, show_value=true))"

# ╔═╡ a9630d28-12d2-11eb-196b-773d8498b0bb
md"γ = $(@bind guess_γ Slider(0.00:0.0001:0.01; default = 0.005, show_value=true))"

# ╔═╡ 23c53be4-12d4-11eb-1d39-8d11b4431993
md"Show manual fit: $(@bind show_manual_sir_fit CheckBox())"

# ╔═╡ 6016fccc-12d4-11eb-0f58-b9cd331cc7b3
md"""
👉 To do this automatically, we will again need to define a loss function $\mathcal{L}(\beta, \gamma)$. This will compare *the solution of the SIR equations* with parameters $\beta$ and $\gamma$ with your data.

This time, instead of comparing two vectors of numbers, we need to compare two vectors of _vectors_, the S, I, R values.


"""

# ╔═╡ 754b5368-12e8-11eb-0763-e3ec56562c5f
function loss_sir(β, γ)
	
	return missing
end

# ╔═╡ ee20199a-12d4-11eb-1c2c-3f571bbb232e
loss_sir(guess_β, guess_γ)

# ╔═╡ 38b09bd8-12d5-11eb-2f7b-579e9db3973d
md"""
👉 Use this loss function to find the optimal parameters ``\beta`` and ``\gamma``.
"""

# ╔═╡ 6e1b5b6a-12e8-11eb-3655-fb10c4566cdc
found_β, found_γ = let
	
	# your code here
	
	missing, missing
end

# ╔═╡ b94b7610-106d-11eb-2852-25337ce6ec3a
if student.name == "Jazzy Doe" || student.kerberos_id == "jazz"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ b94f9df8-106d-11eb-3be8-c5a1bb79d0d4
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ b9586d66-106d-11eb-0204-a91c8f8355f7
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 0f0b7ec4-112c-11eb-3399-59e22df07355
hint(md"""
	Remember that [functions are objects](https://www.youtube.com/watch?v=_O-HBDZMLrM)! For example, here is a function that returns the square root function:
	```julia
	function the_square_root_function()
		f = x -> sqrt(x)
		return f
	end
	```
	""")

# ╔═╡ b9616f92-106d-11eb-1bd1-ede92a617fdb
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ b969dbaa-106d-11eb-3e5a-81766a333c49
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ b9728c20-106d-11eb-2286-4f670c229f3e
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ b97afa48-106d-11eb-3c2c-cdee1d1cc6d7
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ b98238ce-106d-11eb-1e39-f9eda5df76af
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 3df7d63a-12c4-11eb-11ca-0b8db4bd9121
let
	result = euler_integrate_step(x -> x^2, 10, 11, 12)

	if result isa Missing
		still_missing()
	elseif !(result isa Number)
		keep_working(md"Make sure that you return a number.")
	else
		if result ≈ 6358
			correct()
		elseif result ≈ 1462
			almost(md"Use ``f'(a+h)``, not ``f'(a)``.")
		else
			keep_working()
		end
	end
end

# ╔═╡ 15b50428-1264-11eb-163e-23e2f3590502
if euler_test isa Missing
	still_missing()
elseif !(euler_test isa Vector) || (abs(length(euler_test) - 101) > 1)
	keep_working(md"Make sure that you return a vector of numbers, of the same size as `T`.")
else
	if abs(euler_test[1] - 0) > 1
		keep_working()
	elseif abs(euler_test[50] - 5^3) > 20
		keep_working()
	elseif abs(euler_test[end] - 10^3) > 100
		keep_working()
	else
		correct()
	end
end

# ╔═╡ ed344a8c-12df-11eb-03a3-2922620fd20f
let
	result1 = gradient_descent_1d_step(x -> x^2, 10; η=1)
	result2 = gradient_descent_1d_step(x -> x^2, 10; η=2)
	
	if result1 isa Missing
		still_missing()
	elseif !(result1 isa Real)
		keep_working(md"You need to return a number.")
	else
		if result2 < result1 < 10.0
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ f46aeaf0-1246-11eb-17aa-2580fdbcfa5a
let
	result = gradient_descent_1d(10) do x
		(x - 5pi) ^ 2 + 10
	end
	
	if result isa Missing
		still_missing()
	elseif !(result isa Real)
		keep_working(md"You need to return a number.")
	else
		error = abs(result - 5pi)
		if error > 5.0
			almost(md"It's not accurate enough yet. Maybe you need to increase the number of steps?")
		elseif error > 0.02
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 106670f2-12d6-11eb-1854-5bf0fc6f4dfb
let
	if (found_β isa Missing) || (found_γ isa Missing)
		still_missing()
	else
		if isnan(found_β) || isnan(found_γ)
			hint(md"The found parameters are `NaN`, which means that floating point errors led to an invalid value. Try setting ``\eta`` much lower, try `1e-6`, `1e-7`, etc.")
		else
			diffb = abs(found_β - 0.019)
			diffc = abs(found_γ - 0.0026)

			if diffb > .1 || diffc > .01
				almost(md"Try using initial values that are closer to the expected result. (For example, the values that you found using the sliders.)")
			elseif diffb > .01 || diffc > .001
				almost(md"Try using initial values that are closer to the expected result. (For example, the values that you found using the sliders.)
					
You can also experiment with a different loss function. Are you using the absolute error, instead of the square of the error? A parabolic loss function is 'easier to optimize' using gradient descent than a cone-shaped one.")
			else
				correct(md"""
If you made it this far, congratulations -- you have just taken your first step into the exciting world of scientific machine learning!
""")
			end
		end
	end
end

# ╔═╡ b989e544-106d-11eb-3c53-3906c5c922fb
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ cd7583b0-1261-11eb-2a98-537bfab2463e
if !@isdefined(finite_difference_slope)
	not_defined(:finite_difference_slope)
else
	let
		result = finite_difference_slope(sqrt, 4.0, 5.0)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Real)
			keep_working(md"Make sure that you return a number.")
		else
			if result ≈ 0.2
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ 66198242-1262-11eb-1b0f-37c58199c754
if !@isdefined(tangent_line)
	not_defined(:tangent_line)
else
	let
		result = tangent_line(sqrt, 4.0, 5.0)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Function)
			keep_working(md"Make sure that you return a function.")
		else
			if finite_difference_slope(result, 14.0, 15.0) ≈ 0.2
				if result(4.0) ≈ 2.0
					correct()
				else
					almost(md"The tangent line should pass through $(a, f(a))$.")
				end
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ 5ea6c1f0-126c-11eb-3963-c98548f0b36e
if !@isdefined(∂x)
	not_defined(:∂x)
else
	let
		result = ∂x((x, y) -> 2x^2 + 3y^2, 6, 7)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Number)
			keep_working(md"Make sure that you return a number.")
		else
			if abs(result - 24) < 1.0
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ c82b2148-126c-11eb-1c03-c157c9bd7eba
if !@isdefined(∂y)
	not_defined(:∂y)
else
	let
		result = ∂y((x, y) -> 2x^2 + 3y^2, 6, 7)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Number)
			keep_working(md"Make sure that you return a number.")
		else
			if abs(result - 42) < 1.0
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ 46b07b1c-126d-11eb-0966-6ff5ab87ac9d
if !@isdefined(gradient)
	not_defined(:gradient)
else
	let
		result = gradient((x, y) -> 2x^2 + 3y^2, 6, 7)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Vector)
			keep_working(md"Make sure that you return a 2-element vector.")
		else
			if abs(result[1] - 24) < 1 && abs(result[2] - 42) < 1
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ a737990a-1251-11eb-1114-c57ceee75181
if !@isdefined(found_μ)
	not_defined(:found_μ)
elseif !@isdefined(found_σ)
	not_defined(:found_σ)
else
	let
		if (found_μ isa Missing) || (found_σ isa Missing)
			still_missing()
		else

			diff_μ = abs(stats_μ - found_μ)
			diff_σ = abs(stats_σ - found_σ)

			if diff_μ > 1 || diff_σ > 1
				keep_working()
			elseif diff_μ > .2 || diff_σ > .2
				almost(md"The fit is close, but we can do better. Try increasing ``\eta`` ")
			else
				correct()
			end
		end
	end
end

# ╔═╡ 05bfc716-106a-11eb-36cb-e7c488050d54
TODO = html"<span style='display: inline; font-size: 2em; color: purple; font-weight: 900;'>TODO</span>"

# ╔═╡ df42aa9e-10c9-11eb-2c19-2d7ce40a1c6c
as_mime(m::MIME) = x -> PlutoUI.Show(m, repr(m, x))

# ╔═╡ 15b60272-10ca-11eb-0a28-599ed78cf98a
"""
Return the argument, but force it to be shown as SVG.

This is an optimization for Plots.jl GR plots: it makes them less jittery and keeps the page DOM small.
"""
as_svg = as_mime(MIME"image/svg+xml"())

# ╔═╡ 3d44c264-10b9-11eb-0895-dbfc22ba0c37
let
	p = plot(zeroten, wavy, label="f(x)")
	scatter!(p, [a_finite_diff], [wavy(a_finite_diff)], label="a", color="red")
	vline!(p, [a_finite_diff], label=nothing, color="red", linestyle=:dash)
	scatter!(p, [a_finite_diff+h_finite_diff], [wavy(a_finite_diff+h_finite_diff)], label="a + h", color="green")
	
	try
		result = tangent_line(wavy, a_finite_diff, h_finite_diff)
		
		plot!(p, zeroten, result, label="tangent", color="purple")
	catch
	end
	
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end |> as_svg

# ╔═╡ 70df9a48-10bb-11eb-0b95-95a224b45921
let
	slope = wavy_deriv(a_euler)
	
	p = plot(LinRange(1.0 - 0.1, 1.0 + 0.1, 2), wavy, label=nothing, lw=3)
	scatter!(p, [1], wavy, label="f(1)", color="blue", lw=3)
	# p = plot()
	x = [a_euler - 0.2,a_euler + 0.2]
	for y in -4:10
		plot!(p, x, slope .* (x .- a_euler) .+ y, label=nothing, color="purple", opacity=.6)
	end
	
	vline!(p, [a_euler], color="red", label="a", linestyle=:dash)
	
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end |> as_svg

# ╔═╡ 990236e0-10be-11eb-333a-d3080a224d34
let
	a = 1
	h = .3
	history = euler_integrate(wavy_deriv, wavy(a), range(a; step=h, length=N_euler))
	
	slope = wavy_deriv(a_euler)
	
	p = plot(zeroten, wavy, label="exact solution", lw=3, opacity=.1, color="gray")
	# p = plot()
	
	last_a = a + (N_euler-1)*h
	
	vline!(p, [last_a], color="red", label="a", linestyle=:dash)

	try
		plot!(p, a .+ h .* (1:N_euler), history, 
			color="blue", label=nothing)
		scatter!(p, a .+ h .* (1:N_euler), history, 
			color="blue", label="appromixation", 
			markersize=2, markerstrokewidth=0)

		
		plot!(p, [0,10], ([0,10] .- (last_a+h)) .* wavy_deriv(last_a+h) .+ history[end],
			label="tangent",
			color="purple")

	catch
	end
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end |> as_svg

# ╔═╡ 90114f98-12e0-11eb-2011-a3207bbc24f6
function gradient_1d_viz(N_gradient_1d, x0)
	f = x -> x^4 + 3x^3 - 3x + 5.
	
	x = LinRange(-3, 1.5, 200)
	
	history = accumulate(1:N_gradient_1d, init=x0) do old, _
		gradient_descent_1d_step(f, old, η=.025)
	end
	
	all = [x0, history...]
	
	# slope = wavy_deriv(a_euler)
	
	p = plot(x, f, label="f(x)", lw=3, opacity=.6, color="gray")
	# p = plot()
	
	plot!(p, all, f, 
		color="blue", opacity=range(.5,step=.2,length=length(all)), label=nothing)
	scatter!(p, all, f,
		color="blue", label="gradient descent", 
		markersize=3, markerstrokewidth=0)
	
	as_svg(p)
end

# ╔═╡ 88b30f10-12e1-11eb-383d-4f095625cd16
gradient_1d_viz(N_gradient_1d, x0_gradient_1d)

# ╔═╡ 5e0f16b4-12e3-11eb-212f-e565f97adfed
function gradient_2d_viz_3d(N_gradient_2d, x0, y0)

	history = accumulate(1:N_gradient_2d, init=[x0, y0]) do old, _
		gradient_descent_2d_step(himmelbau, old...)
	end
	
	all = [[x0, y0], history...]
	
	p = surface(-4:0.4:5, -4:0.4:4, himmelbau)
	
	trace = [himmelbau(s...) for s in all]
	
	plot!(p, first.(all), last.(all), trace, 
		color="blue", opacity=range(.5,step=.2,length=length(all)), label=nothing)
	scatter!(p, first.(all), last.(all), trace, 
		color="blue", label="gradient descent", 
		markersize=3, markerstrokewidth=0)
	
	as_svg(p)
end

# ╔═╡ 9ae4ebac-12e3-11eb-0acc-23113f5264a9
if run_3d_visualisation
	let
		# we temporarily change the plotting backend to an interactive one
		plotly()

		# we dont use the sliders because this plot is quite slow
		x0 = 0.5
		N = 20
		y0 = -3

		p = gradient_2d_viz_3d(N, x0, y0)
		gr()

		p
	end
end

# ╔═╡ b6ae4d7e-12e6-11eb-1f92-c95c040d4401
function gradient_2d_viz_2d(N_gradient_2d, x0, y0)

	history = accumulate(1:N_gradient_2d, init=[x0, y0]) do old, _
		gradient_descent_2d_step(himmelbau, old...)
	end
	
	all = [[x0, y0], history...]
	
	p = heatmap(-4:0.4:5, -4:0.4:4, himmelbau)
	
	plot!(p, first.(all), last.(all), 
		color="blue", opacity=range(.5,step=.2,length=length(all)), label=nothing)
	scatter!(p, first.(all), last.(all), 
		color="blue", label="gradient descent", 
		markersize=3, markerstrokewidth=0)
	
	as_svg(p)
end

# ╔═╡ fbb4a9a4-1248-11eb-00e2-fd346f0056db
gradient_2d_viz_2d(N_gradient_2d, x0_gradient_2d, y0_gradient_2d)

# ╔═╡ 496b8816-12d3-11eb-3cec-c777ba81eb60
let
	p = plot()
	plot_sir!(p, hw4_T, hw4_results, label="hw4", opacity=.7)
	
	if show_manual_sir_fit
		guess_results = euler_SIR(guess_β, guess_γ, 
		[0.99, 0.01, 0.00], 
		hw4_T)
		
		plot_sir!(p, hw4_T, guess_results, label="manual", linestyle=:dash, lw=2)
	end
	
	try
		@assert !(found_β isa Missing) && !(found_γ isa Missing)
		found_results = euler_SIR(found_β, found_γ, 
		[0.99, 0.01, 0.00], 
		hw4_T)
		
		plot_sir!(p, hw4_T, found_results, label="optimized", linestyle=:dot, lw=2)
	catch
	end
	
	as_svg(p)
end

# ╔═╡ Cell order:
# ╟─048890ee-106a-11eb-1a81-5744150543e8
# ╟─0565af4c-106a-11eb-0d38-2fb84493d86f
# ╟─056ed7f2-106a-11eb-3543-31a5cb560e80
# ╟─0579e962-106a-11eb-26b5-2160f461f4cc
# ╠═0587db1c-106a-11eb-0560-c3d53c516805
# ╟─05976f0c-106a-11eb-03a4-0febbc18fae8
# ╠═05b01f6e-106a-11eb-2a88-5f523fafe433
# ╟─0d191540-106e-11eb-1f20-bf72a75fb650
# ╟─3cd69418-10bb-11eb-2fb5-e93bac9e54a9
# ╟─17af6a00-112b-11eb-1c9c-bfd12931491d
# ╟─2a4050f6-112b-11eb-368a-f91d7a023c9d
# ╠═d217a4b6-12e8-11eb-29ce-53ae143a39cd
# ╠═f0576e48-1261-11eb-0579-0b1372565ca7
# ╟─cd7583b0-1261-11eb-2a98-537bfab2463e
# ╟─bf8a4556-112b-11eb-042e-d705a2ca922a
# ╟─0f0b7ec4-112c-11eb-3399-59e22df07355
# ╠═cbf0a27a-12e8-11eb-379d-85550b942ceb
# ╟─66198242-1262-11eb-1b0f-37c58199c754
# ╟─abc54b82-10b9-11eb-1641-817e2f043d26
# ╟─3d44c264-10b9-11eb-0895-dbfc22ba0c37
# ╠═2b79b698-10b9-11eb-3bde-53fc1c48d5f7
# ╟─a732bbcc-112c-11eb-1d65-110c049e226c
# ╟─c9535ad6-10b9-11eb-0537-45f13931cd71
# ╟─7495af52-10ba-11eb-245f-a98781ba123c
# ╟─327de976-10b9-11eb-1916-69ad75fc8dc4
# ╟─43df67bc-10bb-11eb-1cbd-cd962a01e3ee
# ╠═d5a8bd48-10bf-11eb-2291-fdaaff56e4e6
# ╟─0b4e8cdc-10bd-11eb-296c-d51dc242a372
# ╟─70df9a48-10bb-11eb-0b95-95a224b45921
# ╟─1d8ce3d6-112f-11eb-1343-079c18cdc89c
# ╠═fa320028-12c4-11eb-0156-773e2aba8e58
# ╟─3df7d63a-12c4-11eb-11ca-0b8db4bd9121
# ╟─2335cae6-112f-11eb-3c2c-254e82014567
# ╠═fff7754c-12c4-11eb-2521-052af1946b66
# ╟─4d0efa66-12c6-11eb-2027-53d34c68d5b0
# ╠═b74d94b8-10bf-11eb-38c1-9f39dfcb1096
# ╟─15b50428-1264-11eb-163e-23e2f3590502
# ╟─ab72fdbe-10be-11eb-3b33-eb4ab41730d6
# ╟─990236e0-10be-11eb-333a-d3080a224d34
# ╟─d21fad2a-1253-11eb-304a-2bacf9064d0d
# ╟─518fb3aa-106e-11eb-0fcd-31091a8f12db
# ╠═1e5ca54e-12d8-11eb-18b8-39b909584c72
# ╠═84daf7c4-1244-11eb-0382-d1da633a63e2
# ╟─517efa24-1244-11eb-1f81-b7f95b87ce3b
# ╠═51a0138a-1244-11eb-239f-a7413e2e44e4
# ╠═4b791b76-12cd-11eb-1260-039c938f5443
# ╠═0a095a94-1245-11eb-001a-b908128532aa
# ╟─51c9a25e-1244-11eb-014f-0bcce2273cee
# ╟─58675b3c-1245-11eb-3548-c9cb8a6b3188
# ╟─b4bb4b3a-12ce-11eb-3fe5-ad7ccd73febb
# ╟─586d0352-1245-11eb-2504-05d0aa2352c6
# ╠═589b2b4c-1245-11eb-1ec7-693c6bda97c4
# ╟─58b45a0e-1245-11eb-04d1-23a1f3a0f242
# ╠═68274534-1103-11eb-0d62-f1acb57721bc
# ╟─82539bbe-106e-11eb-0e9e-170dfa6a7dad
# ╟─b394b44e-1245-11eb-2f86-8d10113e8cfc
# ╠═bd8522c6-12e8-11eb-306c-c764f78486ef
# ╠═321964ac-126d-11eb-0a04-0d3e3fb9b17c
# ╟─5ea6c1f0-126c-11eb-3963-c98548f0b36e
# ╠═b7d3aa8c-12e8-11eb-3430-ff5d7df6a122
# ╠═a15509ee-126c-11eb-1fa3-cdda55a47fcb
# ╟─c82b2148-126c-11eb-1c03-c157c9bd7eba
# ╟─b398a29a-1245-11eb-1476-ab65e92d1bc8
# ╠═adbf65fe-12e8-11eb-04e9-3d763ba91a63
# ╠═66b8e15e-126c-11eb-095e-39c2f6abc81d
# ╟─46b07b1c-126d-11eb-0966-6ff5ab87ac9d
# ╟─82579b90-106e-11eb-0018-4553c29e57a2
# ╠═a7f1829c-12e8-11eb-15a1-5de40ed92587
# ╠═d33271a2-12df-11eb-172a-bd5600265f49
# ╟─ed344a8c-12df-11eb-03a3-2922620fd20f
# ╟─8ae98c74-12e0-11eb-2802-d9a544d8b7ae
# ╟─88b30f10-12e1-11eb-383d-4f095625cd16
# ╟─a53cf3f8-12e1-11eb-0b0c-2b794a7ac841
# ╟─90114f98-12e0-11eb-2011-a3207bbc24f6
# ╟─754e4c48-12df-11eb-3818-f54f6fc7176b
# ╠═9489009a-12e8-11eb-2fb7-97ba0bdf339c
# ╠═34dc4b02-1248-11eb-26b2-5d2610cfeb41
# ╟─f46aeaf0-1246-11eb-17aa-2580fdbcfa5a
# ╟─e3120c18-1246-11eb-3bf4-7f4ac45856e0
# ╠═ebca11d8-12c9-11eb-3dde-c546eccf40fc
# ╟─9fd2956a-1248-11eb-266d-f558cda55702
# ╠═852be3c4-12e8-11eb-1bbb-5fbc0da74567
# ╠═8a114ca8-12e8-11eb-2de6-9149d1d3bc3d
# ╠═92854562-1249-11eb-0b81-156982df1284
# ╠═4454c2b2-12e3-11eb-012c-c362c4676bf6
# ╟─fbb4a9a4-1248-11eb-00e2-fd346f0056db
# ╟─4aace1a8-12e3-11eb-3e07-b5827a2a6765
# ╟─54a58f84-12e3-11eb-10b9-7d55a16c81ba
# ╠═a0045046-1248-11eb-13bd-8b8ad861b29a
# ╟─7e318fea-12e7-11eb-3490-b17e0d4dbc50
# ╠═605aafa4-12e7-11eb-2d13-7f7db3fac439
# ╟─9ae4ebac-12e3-11eb-0acc-23113f5264a9
# ╟─5e0f16b4-12e3-11eb-212f-e565f97adfed
# ╟─b6ae4d7e-12e6-11eb-1f92-c95c040d4401
# ╟─a03890d6-1248-11eb-37ee-85b0a5273e0c
# ╠═6d1ee93e-1103-11eb-140f-63fca63f8b06
# ╟─8261eb92-106e-11eb-2ccc-1348f232f5c3
# ╠═65e691e4-124a-11eb-38b1-b1732403aa3d
# ╟─6f4aa432-1103-11eb-13da-fdd9eefc7c86
# ╠═dbe9635a-124b-11eb-111d-fb611954db56
# ╟─ac320522-124b-11eb-1552-51c2adaf2521
# ╟─57090426-124e-11eb-0a17-1566ae96b7c2
# ╟─66192a74-124c-11eb-0c6a-d74aecb4c624
# ╟─70f0fe9c-124c-11eb-3dc6-e102e68673d9
# ╟─41b2262a-124e-11eb-2634-4385e2f3c6b6
# ╠═0dea1f70-124c-11eb-1593-e535ab21976c
# ╟─471cbd84-124c-11eb-356e-371d23011af5
# ╠═2fc55daa-124f-11eb-399e-659e59148ef5
# ╠═3a6ec2e4-124f-11eb-0f68-791475bab5cd
# ╟─2fcb93aa-124f-11eb-10de-55fced6f4b83
# ╠═a150fd60-124f-11eb-35d6-85104bcfd0fe
# ╟─3f5e88bc-12c8-11eb-2d74-51f2f5060928
# ╠═c569a5d8-1267-11eb-392f-452de141161b
# ╠═e55d9c1e-1267-11eb-1b3c-5d772662518a
# ╟─a737990a-1251-11eb-1114-c57ceee75181
# ╟─65aa13fe-1266-11eb-03c2-5927dbeca36e
# ╟─6faf4074-1266-11eb-1a0a-991fc2e991bb
# ╟─826bb0dc-106e-11eb-29eb-03e7ddf9e4b5
# ╟─04364dee-12cb-11eb-2f94-bfd3fb405907
# ╟─249c297c-12ce-11eb-2054-d1e926335148
# ╟─c56cc19c-12ca-11eb-3c6c-7f3ea98eeb4e
# ╟─496b8816-12d3-11eb-3cec-c777ba81eb60
# ╟─480fde46-12d4-11eb-2dfb-1b71692c7420
# ╟─4837e1ae-12d2-11eb-0df9-21dcc1892fc9
# ╟─a9630d28-12d2-11eb-196b-773d8498b0bb
# ╟─23c53be4-12d4-11eb-1d39-8d11b4431993
# ╟─6016fccc-12d4-11eb-0f58-b9cd331cc7b3
# ╠═754b5368-12e8-11eb-0763-e3ec56562c5f
# ╠═ee20199a-12d4-11eb-1c2c-3f571bbb232e
# ╟─38b09bd8-12d5-11eb-2f7b-579e9db3973d
# ╠═6e1b5b6a-12e8-11eb-3655-fb10c4566cdc
# ╟─106670f2-12d6-11eb-1854-5bf0fc6f4dfb
# ╟─b94b7610-106d-11eb-2852-25337ce6ec3a
# ╟─b94f9df8-106d-11eb-3be8-c5a1bb79d0d4
# ╟─b9586d66-106d-11eb-0204-a91c8f8355f7
# ╟─b9616f92-106d-11eb-1bd1-ede92a617fdb
# ╟─b969dbaa-106d-11eb-3e5a-81766a333c49
# ╟─b9728c20-106d-11eb-2286-4f670c229f3e
# ╟─b97afa48-106d-11eb-3c2c-cdee1d1cc6d7
# ╟─b98238ce-106d-11eb-1e39-f9eda5df76af
# ╟─b989e544-106d-11eb-3c53-3906c5c922fb
# ╟─05bfc716-106a-11eb-36cb-e7c488050d54
# ╟─df42aa9e-10c9-11eb-2c19-2d7ce40a1c6c
# ╟─15b60272-10ca-11eb-0a28-599ed78cf98a
