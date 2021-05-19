### A Pluto.jl notebook ###
# v0.14.5

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

# ╔═╡ f4fda666-7b9c-11eb-0304-716c5e710462
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="ForwardDiff", version="0.10"),
        Pkg.PackageSpec(name="Symbolics", version="0.1"),
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="LaTeXStrings", version="1"),
    ])
    using Symbolics, ForwardDiff, Plots, PlutoUI, LaTeXStrings
	using ForwardDiff: jacobian
end

# ╔═╡ c09f092a-887e-11eb-1ccc-4367bf05602d
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
"><em>Section 1.6</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> The Newton Method </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/Wjcx9sNSLP8" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ d82f1eae-7b9c-11eb-24d8-e1dcb2eef71a
md"""
## Solving equations and finding inverse transformations using the Newton method
"""

# ╔═╡ e410c1d0-7ba1-11eb-394f-71dac89756b7
md"""
In science and engineering we often need to *solve systems of equations*. 

If the equations are *linear* then linear algebra tells us a general method to solve them; these are now routinely applied to solve systems of millions of linear equations.

If the equations are *non*linear then things are less obvious. The main solution methods we know work by... reducing the nonlinear equations to a sequence of linear equations! They do this by *approximating* the function by a linear function and solving that to get a better solution, then repeating this operation as many times as necessary to get a *sequence* of increasingly better solutions. This is an example of an **iterative algorithm**.

A well-known and elegant method, which can be used in many different contexts, is the **Newton method**. It does, however, have the disadvantage that it requires derivatives of the function. This can be overcome using **automatic differentiation** techniques.

We will illustrate the Newton method using the `ForwardDiff.jl` package to carry out automatic differentiation, but we will also try to understand what's going on "under the hood".
"""

# ╔═╡ 5ea7344c-7ba2-11eb-2cc5-0bbdca218c82
md"""
## The Newton method in 1D

We would like to solve equations like $f(x) = g(x)$. 
We rewrite that by moving all the terms to one side of the equation so that we can write $h(x) = 0$, with $h(x) := f(x) - g(x)$.

A point $x^*$ such that $h(x^*) = 0$ is called a **root** or **zero** of $h$.

The Newton method finds zeros, and hence solves the original equation.
"""

# ╔═╡ 8c0c412e-7c2f-11eb-1880-4f6c45d77597
md"""


The idea of the Newton method is to *follow the direction in which the function is pointing*! We do this by building a **tangent line** at the current position and following that instead, until it hits the $x$-axis.

Let's look at that visually first:

"""

# ╔═╡ ce44554e-847f-4129-8841-1a729dfa7a2e
md"""
n = $(@bind n2 Slider(0:10, show_value=true, default=0))
"""

# ╔═╡ 77ef0cfb-60db-4599-bec2-b65e99e5b246
md"""
x₀ = $(@bind x02 Slider(-10:10, show_value=true, default=6))
"""

# ╔═╡ 2445da24-7b9d-11eb-02bd-eb99a3d95a2e
md"""
n = $(@bind n Slider(0:10, show_value=true, default=0))
"""

# ╔═╡ 9addbcbe-7b9e-11eb-3e8c-fbab3be40e05
md"""
x₀ = $(@bind x0 Slider(-10:10, show_value=true, default=6))
"""

# ╔═╡ c0b4defe-7c2f-11eb-1913-bdb01d28a4a8
md"""
## Using symbolic calculations to understand derivatives and nonlinear maps
"""

# ╔═╡ 615aff3c-7c30-11eb-2ca8-9d2fdf299017
md"""
We can use Julia's new symbolic capabilities to understand what's going on with a nonlinear (polynomial) function.

Let's see what happens if we perturb a function $f$ around a point $z$ by a small amount $\eta$.
"""

# ╔═╡ 71efd6b0-7c30-11eb-0da7-0d4a5ab8f8ff
@variables z, η

# ╔═╡ a869e6c6-7c31-11eb-13c8-155d08be02eb
md"""
m = $(@bind m Slider(1:6, show_value=true))
"""

# ╔═╡ 6dc89964-7c30-11eb-0a41-8d97b210ed34
f(x) = x^m - 2;

# ╔═╡ d35e0cc8-7c30-11eb-28d3-17c9e221ea62
f′(x) = ForwardDiff.derivative(f, x);

# ╔═╡ 63dbf052-7c32-11eb-1062-5b3581d38f70
f(z)

# ╔═╡ 9371f930-7c30-11eb-1f77-c7f31b97ea26
f(z + η)

# ╔═╡ 9d778e36-7c30-11eb-1f4b-894af86a8f5d
md"""
When $\eta$	is small, $\eta^2$ is *very* small, so we can ignore it. We are left with terms that either don't contain $\eta$ (constants), or multiply $\eta$ (linear). The part that multiplies $\eta$ is the derivative:
"""

# ╔═╡ db26375a-7c30-11eb-066e-ab9e8ded3356
f′(z)

# ╔═╡ ea741018-7c30-11eb-3912-a50475e6ec49
f(z) + η*f′(z)

# ╔═╡ 389e990e-7c40-11eb-37c4-5ba0f59173b3
md"""
The derivative gives the "*linear* part" of the function. `ForwardDiff.jl`, and forward-mode automatic differentiation in general, effectively uses this (although not symbolically in this sense) to just propagate the linear part of each function through a calculation.
"""

# ╔═╡ 5123c038-7ba2-11eb-1be2-19f789b02c1f
md"""
## Mathematics of the Newton method
"""

# ╔═╡ 9bfafcc0-7ba2-11eb-1b67-e3a3803ead08
md"""
We can convert the idea of "following the tangent line" into equations as follows.
(You can also do so by just looking at the geometry in 1D, but that does not help in 2D.)
"""

# ╔═╡ f153b4b8-7ba0-11eb-37ec-4f1a3dbe20e8
md"""
Suppose we have a guess $x_0$ for the root and we want to find a (hopefully) better guess $x_1$.

Let's set $x_1 = x_0 + \delta$, where $x_1$ and $\delta$ are still unknown.

We want $x_1$ to be a root, so
"""

# ╔═╡ 9cfa9062-7ba0-11eb-3a93-197ac0287ab4
md"""
$$f(x_1) = f(x_0 + \delta) \simeq 0$$
"""

# ╔═╡ 1ba1ae44-7ba1-11eb-21ff-558c95446435
md"""
If we are already "quite close" to the root then $\delta$ should be small, so we can approximate $f$ using the tangent line:

$$f(x_0) + \delta \, f'(x_0) \simeq 0$$

and hence

$$\delta \simeq \frac{-f(x_0)}{f'(x_0)}$$

so that

$$x_1 = x_0 - \frac{f(x_0)}{f'(x_0)}$$

Now we can repeat so that 

$$x_2 = x_1 - \frac{f(x_1)}{f'(x_1)}$$

and in general

$$x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}.$$


This is the Newton method in 1D.
"""

# ╔═╡ ba570c4c-7ba2-11eb-2125-9f23e415a1dc
md"""
## Implementation in 1D
"""

# ╔═╡ d690f83a-7c2e-11eb-14d7-79a250deb473
function newton1D(f, x0)
	
	f′(x) = ForwardDiff.derivative(f, x)   # \prime<TAB>
	
	x0 = 37.0  # starting point
	sequence = [x0]
	
	x = x0
	
	for i in 1:10
		x -= f(x) / f′(x)
	end
	
	return x
	
end

# ╔═╡ 2fb40dc6-7c2f-11eb-2469-8deb4db59b5c
newton1D(x -> x^2 - 2, 37.0)

# ╔═╡ 35791bca-7c2f-11eb-1cfb-8d5ebd0208cb
sqrt(2)

# ╔═╡ 1d7dd328-7c2d-11eb-2b35-bdbf5df686f0
md"""
## Symbolic derivative in 2D

"""

# ╔═╡ d44c73b4-7c3e-11eb-1302-8ba9039ae789
md"""
Let's see what happens when we perturb by small amounts $\delta$ in the $x$ direction and $\epsilon$ in the $y$ direction around the point $(a, b)$:
"""

# ╔═╡ fe742fec-7c3e-11eb-1f54-55cdf02a1574
md"""
p = $(@bind p Slider(0:0.01:1, show_value=true))
"""

# ╔═╡ 23536420-7c2d-11eb-20b0-9523f7a5f9d7
@variables a, b, δ, ϵ

# ╔═╡ 4dd2322c-7ba0-11eb-2b3b-af7c6c1d60a0
md"""
## Newton for transformations in 2 dimensions

$$T: \mathbb{R}^2 \to \mathbb{R}^2$$

"""

# ╔═╡ 5c9edb2c-7ba0-11eb-14f6-3d5e52123bc7
md"""
We want to find the inverse $T^{-1}(y)$, i.e. to solve the equation $T(x) = y$ for $x$.

We use the same idea as in 1D, but now in 2D:
"""

# ╔═╡ 80917990-7ba0-11eb-029a-dba981c52b58
md"""
$$T(x_0 + \delta) \simeq 0$$

$$T(x_0) + J \cdot \delta \simeq 0,$$

where $J := DT_{x_0}$ is the Jacobian matrix of $T$ at $x_0$, i.e. the best linear approximation of $T$ near to $x_0$.
"""

# ╔═╡ af887dea-7ba1-11eb-3b0d-6925756382a7
md"""
Hence $\delta$ is the solution of the system of linear equations
"""

# ╔═╡ b7dc4666-7ba1-11eb-32eb-fd3d720c2960
md"""
$$J \cdot \delta = -T(x_0)$$

Then we again construct the new approximation $x_1$ as $x_1 := x_0 + \delta$.
"""

# ╔═╡ c519704c-7ba1-11eb-12da-8b9b176daa0d
md"""
In 2D we have an explicit formula for the inverse of the matrix.
"""

# ╔═╡ e1afc6ca-7ba1-11eb-3fb9-ef3a7f82d750
md"""
## Implementation in 2D
"""

# ╔═╡ 1db66b0e-7ba4-11eb-2157-d5a399a73b1f
function newton2D_step(T, x)
	
	J = ForwardDiff.jacobian(T, x)   # should use StaticVectors
	
	δ = J \ T(x)   # J^(-1) * T(x)
	
	return x - δ
end

# ╔═╡ 923bde64-7ba4-11eb-21e9-a11993aaab2e
"Looks for x such that T(x) = 0"
function newton2D(T, x0, n=10)
	
	x = x0

	for i in 1:n
		x = newton2D_step(T, x)
	end
	
	return x
end

# ╔═╡ 61905ae0-7ba6-11eb-0773-17e9aa4e9991
md"""
Remember that Newton is designed to look for *roots*, i.e. places where $T(x) = 0$.
We want $T(x) = y$, so we need another layer:
"""

# ╔═╡ ff8b6aec-7ba5-11eb-0d83-19803b1bdda7
"Looks for x such that f(x) = y, i.e. f(x) - y = 0"
function inverse(f, y, x0=[0, 0])
	return newton2D(x -> f(x) - y, x0)
end

# ╔═╡ 2e2e5f0e-7c31-11eb-0da7-770b07ee6202
inverse(f) = y -> inverse(f, y)

# ╔═╡ 1b77fada-7b9d-11eb-3266-ebb3895cb76a
straight(x0, y0, x, m) = y0 + m * (x - x0)

# ╔═╡ f25af026-7b9c-11eb-1f11-77a8b06b2d71
function standard_Newton(f, n, x_range, x0, ymin=-10, ymax=10)
    
    f′ = x -> ForwardDiff.derivative(f, x)


	p = plot(f, x_range, lw=3, ylim=(ymin, ymax), legend=:false, size=(400, 300))

	hline!([0.0], c="magenta", lw=3, ls=:dash)
	scatter!([x0], [0], c="green", ann=(x0, -5, L"x_0", 10))

	for i in 1:n

		plot!([x0, x0], [0, f(x0)], c=:gray, alpha=0.5)
		scatter!([x0], [f(x0)], c=:red)
		m = f′(x0)

		plot!(x_range, [straight(x0, f(x0), x, m) for x in x_range], 
			  c=:blue, alpha=0.5, ls=:dash, lw=2)

		x1 = x0 - f(x0) / m

		scatter!([x1], [0], c="green", ann=(x1, -5, L"x_%$i", 10))
		
		x0 = x1

	end

	p |> as_svg


end

# ╔═╡ ecb40aea-7b9c-11eb-1476-e54faf32d91c
let
	f(x) = x^2 - 2

	standard_Newton(f, n2, -1:0.01:10, x02, -10, 70)
end

# ╔═╡ ec6c6328-7b9c-11eb-1c69-dba12ae522ad
let
	f(x) = 0.2x^3 - 4x + 1
	
	standard_Newton(f, n, -10:0.01:10, x0, -10, 70)
end

# ╔═╡ 515c23b6-7c2d-11eb-28c9-1b1d92eb4ba0
T(α) = ( (x, y), ) -> [x + α*y^2, y + α*x^2]

# ╔═╡ 09b97be8-7c2e-11eb-05fd-65bbd097afb8
jacobian(T(p), [a, b]) .|> Text

# ╔═╡ 18ce2fac-7c2e-11eb-03d2-b3a674621662
jacobian(T(p), [a, b]) * [δ, ϵ]

# ╔═╡ 395fd8e2-7c31-11eb-1933-dd719fa0cd22
md"""
α = $(@bind α Slider(0.0:0.01:1.0, show_value=true))
"""

# ╔═╡ 02b1b470-7c31-11eb-28f4-411956f73f12
T(α)( [0.3, 0.4] )

# ╔═╡ 07a754da-7c31-11eb-0394-4bef4d79fc30
inverse(T(α))( [0.3, 0.4] )

# ╔═╡ 5faa2784-7c31-11eb-34f1-3f8224dbdbde
( T(α) ∘ inverse(T(α)) )( [0.3, 0.4] )

# ╔═╡ ee91563e-7c3e-11eb-3f65-1f336073869a
md"""
## Appendix
"""

# ╔═╡ 786f8e78-7c2d-11eb-1bb8-c5cb2e349f45
expand(ex) = simplify(ex, polynorm=true)

# ╔═╡ 98158a38-7c30-11eb-0796-2335e97ec6d0
expand( f(z + η) )

# ╔═╡ e18f2470-7c31-11eb-2b74-d59d00d20ba4
expand( f(z + η) ) - ( f(z) + η*f′(z) )

# ╔═╡ 3828b94c-7c2d-11eb-2e01-79038b0f5226
image = expand.(T(p)( [ (a + δ), (b + ϵ) ] ) )

# ╔═╡ ed605b90-7c3e-11eb-34e9-776a05a177dd
image - T(p)([a, b])

# ╔═╡ 35b5c5c6-7c3f-11eb-2723-4b406a809114
simplify.( expand.( image - T(p)([a, b]) - jacobian(T(p), [a, b]) * [δ, ϵ] ) )

# ╔═╡ Cell order:
# ╟─c09f092a-887e-11eb-1ccc-4367bf05602d
# ╠═f4fda666-7b9c-11eb-0304-716c5e710462
# ╟─d82f1eae-7b9c-11eb-24d8-e1dcb2eef71a
# ╟─e410c1d0-7ba1-11eb-394f-71dac89756b7
# ╟─5ea7344c-7ba2-11eb-2cc5-0bbdca218c82
# ╟─8c0c412e-7c2f-11eb-1880-4f6c45d77597
# ╟─ce44554e-847f-4129-8841-1a729dfa7a2e
# ╟─77ef0cfb-60db-4599-bec2-b65e99e5b246
# ╠═ecb40aea-7b9c-11eb-1476-e54faf32d91c
# ╟─2445da24-7b9d-11eb-02bd-eb99a3d95a2e
# ╟─9addbcbe-7b9e-11eb-3e8c-fbab3be40e05
# ╠═ec6c6328-7b9c-11eb-1c69-dba12ae522ad
# ╟─c0b4defe-7c2f-11eb-1913-bdb01d28a4a8
# ╟─615aff3c-7c30-11eb-2ca8-9d2fdf299017
# ╠═71efd6b0-7c30-11eb-0da7-0d4a5ab8f8ff
# ╠═6dc89964-7c30-11eb-0a41-8d97b210ed34
# ╠═d35e0cc8-7c30-11eb-28d3-17c9e221ea62
# ╟─a869e6c6-7c31-11eb-13c8-155d08be02eb
# ╠═63dbf052-7c32-11eb-1062-5b3581d38f70
# ╠═9371f930-7c30-11eb-1f77-c7f31b97ea26
# ╠═98158a38-7c30-11eb-0796-2335e97ec6d0
# ╟─9d778e36-7c30-11eb-1f4b-894af86a8f5d
# ╠═db26375a-7c30-11eb-066e-ab9e8ded3356
# ╠═ea741018-7c30-11eb-3912-a50475e6ec49
# ╠═e18f2470-7c31-11eb-2b74-d59d00d20ba4
# ╟─389e990e-7c40-11eb-37c4-5ba0f59173b3
# ╟─5123c038-7ba2-11eb-1be2-19f789b02c1f
# ╟─9bfafcc0-7ba2-11eb-1b67-e3a3803ead08
# ╟─f153b4b8-7ba0-11eb-37ec-4f1a3dbe20e8
# ╟─9cfa9062-7ba0-11eb-3a93-197ac0287ab4
# ╟─1ba1ae44-7ba1-11eb-21ff-558c95446435
# ╟─ba570c4c-7ba2-11eb-2125-9f23e415a1dc
# ╠═d690f83a-7c2e-11eb-14d7-79a250deb473
# ╠═2fb40dc6-7c2f-11eb-2469-8deb4db59b5c
# ╠═35791bca-7c2f-11eb-1cfb-8d5ebd0208cb
# ╟─1d7dd328-7c2d-11eb-2b35-bdbf5df686f0
# ╟─d44c73b4-7c3e-11eb-1302-8ba9039ae789
# ╟─fe742fec-7c3e-11eb-1f54-55cdf02a1574
# ╠═23536420-7c2d-11eb-20b0-9523f7a5f9d7
# ╠═3828b94c-7c2d-11eb-2e01-79038b0f5226
# ╠═09b97be8-7c2e-11eb-05fd-65bbd097afb8
# ╠═18ce2fac-7c2e-11eb-03d2-b3a674621662
# ╠═ed605b90-7c3e-11eb-34e9-776a05a177dd
# ╠═35b5c5c6-7c3f-11eb-2723-4b406a809114
# ╟─4dd2322c-7ba0-11eb-2b3b-af7c6c1d60a0
# ╟─5c9edb2c-7ba0-11eb-14f6-3d5e52123bc7
# ╟─80917990-7ba0-11eb-029a-dba981c52b58
# ╟─af887dea-7ba1-11eb-3b0d-6925756382a7
# ╟─b7dc4666-7ba1-11eb-32eb-fd3d720c2960
# ╟─c519704c-7ba1-11eb-12da-8b9b176daa0d
# ╟─e1afc6ca-7ba1-11eb-3fb9-ef3a7f82d750
# ╠═1db66b0e-7ba4-11eb-2157-d5a399a73b1f
# ╠═923bde64-7ba4-11eb-21e9-a11993aaab2e
# ╟─61905ae0-7ba6-11eb-0773-17e9aa4e9991
# ╠═ff8b6aec-7ba5-11eb-0d83-19803b1bdda7
# ╠═2e2e5f0e-7c31-11eb-0da7-770b07ee6202
# ╟─1b77fada-7b9d-11eb-3266-ebb3895cb76a
# ╠═f25af026-7b9c-11eb-1f11-77a8b06b2d71
# ╠═515c23b6-7c2d-11eb-28c9-1b1d92eb4ba0
# ╟─395fd8e2-7c31-11eb-1933-dd719fa0cd22
# ╠═02b1b470-7c31-11eb-28f4-411956f73f12
# ╠═07a754da-7c31-11eb-0394-4bef4d79fc30
# ╠═5faa2784-7c31-11eb-34f1-3f8224dbdbde
# ╟─ee91563e-7c3e-11eb-3f65-1f336073869a
# ╠═786f8e78-7c2d-11eb-1bb8-c5cb2e349f45
