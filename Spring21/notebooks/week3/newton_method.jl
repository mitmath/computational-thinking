### A Pluto.jl notebook ###
# v0.12.21

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
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="LaTeXStrings", version="1"),
    ])
    using ForwardDiff, Plots, PlutoUI, LaTeXStrings
end

# ╔═╡ d82f1eae-7b9c-11eb-24d8-e1dcb2eef71a
md"""
# The Newton method for solving equations
"""

# ╔═╡ e410c1d0-7ba1-11eb-394f-71dac89756b7
md"""
In science and engineering we often need to *solve systems of equations*. 

If the equations are *linear* then linear algebra tells us a general method to solve them; these are now routinely applied to solve systems of millions of linear equations.

If the equations are *non*linear then things are less obvious. The main solution methods we know work by... reducing the nonlinear equations to a sequence of linear equations! They do this by *approximating* the function by a linear function and solving that to get a better solution, then repeating this operation as many times as necessary to get a *sequence* of increasingly better solutions. This is an example of an **iterative algorithm**.

A well-known and elegant method, which can be used in many different contexts, is the **Newton method**. It does, however, have the disadvantage that it requires derivatives of the function. This can be overcome using **automatic differentiation** techniques.

We will illustrate the method using the `ForwardDiff.jl` package.
"""

# ╔═╡ 5ea7344c-7ba2-11eb-2cc5-0bbdca218c82
md"""
## What is the Newton method?

The idea of the Newton method is to *follow the direction in which the function is pointing*! We do this by building a **tangent line** at the current position and following that instead, until it hits the $x$-axis.

Let's look at that visually first:

"""

# ╔═╡ 2445da24-7b9d-11eb-02bd-eb99a3d95a2e
md"""
n = $(@bind n Slider(0:10, show_value=true, default=0))
"""

# ╔═╡ 9addbcbe-7b9e-11eb-3e8c-fbab3be40e05
md"""
x₀ = $(@bind x0 Slider(-10:10, show_value=true, default=6))
"""

# ╔═╡ b803743a-7b9e-11eb-203d-595e0a0493e2


# ╔═╡ ba570c4c-7ba2-11eb-2125-9f23e415a1dc
md"""
## Implementation in 1D
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

# ╔═╡ f0de6d96-7ba5-11eb-3be6-5101974f059f


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

# ╔═╡ 7c742116-7ba6-11eb-166d-f96389a467db


# ╔═╡ 1b77fada-7b9d-11eb-3266-ebb3895cb76a
straight(x0, y0, x, m) = y0 + m * (x - x0)

# ╔═╡ f25af026-7b9c-11eb-1f11-77a8b06b2d71
function standard_Newton(f, n, x_range, x0, ymin=-10, ymax=10)
    
    f′ = x -> ForwardDiff.derivative(f, x)


	p = plot(f, x_range, lw=3, ylim=(ymin, ymax), legend=:false)

	scatter!([x0], [0], c="green", ann=(x0, -5, L"x_0", 10))

	hline!([0.0], c="magenta", lw=3, ls=:dash)

	for i in 1:n

		plot!([x0, x0], [0, f(x0)], c=:gray, alpha=0.5)
		scatter!([x0], [f(x0)], c=:red)
		m = f′(x0)

		plot!(x_range, [straight(x0, f(x0), x, m) for x in x_range], c=:blue, alpha=0.5, ls=:dash, lw=2)

		x1 = x0 - f(x0) / m
		#scatter!([x1], [0], c="green", ann=(x1, -5, "x$i"))

		if i <= n
			scatter!([x1], [0], c="green", ann=(x1, -5, L"x_%$i", 10))
		end
		
		x0 = x1

	end

	p


end

# ╔═╡ ecb40aea-7b9c-11eb-1476-e54faf32d91c
let
	f(x) = x^2 - 2

	standard_Newton(f, n, -1:0.01:10, x0, -10, 70)
end

# ╔═╡ ec6c6328-7b9c-11eb-1c69-dba12ae522ad
let
	f(x) = 0.2x^3 - 4x + 1
	
	standard_Newton(f, n, -10:0.01:10, x0, -10, 70)
end

# ╔═╡ Cell order:
# ╟─d82f1eae-7b9c-11eb-24d8-e1dcb2eef71a
# ╟─e410c1d0-7ba1-11eb-394f-71dac89756b7
# ╟─5ea7344c-7ba2-11eb-2cc5-0bbdca218c82
# ╟─f4fda666-7b9c-11eb-0304-716c5e710462
# ╟─2445da24-7b9d-11eb-02bd-eb99a3d95a2e
# ╟─9addbcbe-7b9e-11eb-3e8c-fbab3be40e05
# ╟─ecb40aea-7b9c-11eb-1476-e54faf32d91c
# ╠═b803743a-7b9e-11eb-203d-595e0a0493e2
# ╠═ec6c6328-7b9c-11eb-1c69-dba12ae522ad
# ╟─ba570c4c-7ba2-11eb-2125-9f23e415a1dc
# ╟─5123c038-7ba2-11eb-1be2-19f789b02c1f
# ╟─9bfafcc0-7ba2-11eb-1b67-e3a3803ead08
# ╟─f153b4b8-7ba0-11eb-37ec-4f1a3dbe20e8
# ╟─9cfa9062-7ba0-11eb-3a93-197ac0287ab4
# ╟─1ba1ae44-7ba1-11eb-21ff-558c95446435
# ╟─4dd2322c-7ba0-11eb-2b3b-af7c6c1d60a0
# ╟─5c9edb2c-7ba0-11eb-14f6-3d5e52123bc7
# ╟─80917990-7ba0-11eb-029a-dba981c52b58
# ╟─af887dea-7ba1-11eb-3b0d-6925756382a7
# ╟─b7dc4666-7ba1-11eb-32eb-fd3d720c2960
# ╟─c519704c-7ba1-11eb-12da-8b9b176daa0d
# ╟─e1afc6ca-7ba1-11eb-3fb9-ef3a7f82d750
# ╠═f0de6d96-7ba5-11eb-3be6-5101974f059f
# ╠═1db66b0e-7ba4-11eb-2157-d5a399a73b1f
# ╠═923bde64-7ba4-11eb-21e9-a11993aaab2e
# ╟─61905ae0-7ba6-11eb-0773-17e9aa4e9991
# ╠═ff8b6aec-7ba5-11eb-0d83-19803b1bdda7
# ╠═7c742116-7ba6-11eb-166d-f96389a467db
# ╟─1b77fada-7b9d-11eb-3266-ebb3895cb76a
# ╠═f25af026-7b9c-11eb-1f11-77a8b06b2d71
