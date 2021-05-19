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

# ╔═╡ 4ed28d02-f423-4f53-8010-644edacd5b74
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="JuMP", version="0.21"),
        Pkg.PackageSpec(name="Ipopt", version="0.6"),
    ])
    using PlutoUI, Plots, Statistics, JuMP, Ipopt
end

# ╔═╡ d719e2ed-ade8-4640-82fe-ffcafd204792
TableOfContents()

# ╔═╡ d18eaa56-b8ad-11eb-1586-b15a611d773d
md"""
# Solving inverse problems: Optimization with JuMP
"""

# ╔═╡ 5bbd06bd-9191-4d06-84f3-95556afb9125
md"""
## Forward and inverse problems
"""

# ╔═╡ 3047f39a-a18a-4dea-9d2d-6523d7d0ec4f
md"""
In a **forward problem** we provide inputs and calculate what the resulting output is using a model.

In an [inverse problem](https://en.wikipedia.org/wiki/Inverse_problem) we have a goal *output* and wish to find which *inputs* to the model will produce that goal. To do so we often need to solve an **optimization problem**.
	
JuMP is a **modeling language** embedded in Julia. It allows us to write down optimization problems in a natural way; these are then converted by JuMP into the correct input format to be sent to different **solvers**, i.e. software programs that choose which optimization algorithms to apply to solve the optimization problem.
"""

# ╔═╡ a0aeb0c6-0980-4c6a-8736-8eccdf17e561
md"""
## Unconstrained optimization
"""

# ╔═╡ 3a81aaa1-05c3-4ef4-ab7a-bd913a5dc85e
md"""
a = $(@bind a Slider(-3:0.01:3, show_value=true, default=0))
"""

# ╔═╡ f488fa22-8ff9-4ea1-84c1-deaf966520d1
f(x) = x^2 - a*x + 2

# ╔═╡ 7d635168-8251-4ee9-8cc5-85ac5d810e21
min_value = let
	
	model = Model(Ipopt.Optimizer)
	
	# tell JuMP about our function:
	register(model, :f, 1, f, autodiff=true)
	
	# declare a variable
	@variable(model, -10 ≤ x ≤ 10)

	# set the *objective function* to optimize:
    @NLobjective(model, Min, f(x))


	
	optimize!(model)
	
	getvalue(x)
end

# ╔═╡ 9b494263-7fb1-4893-aa15-33ad6b839773
begin
	plot(f, size=(400, 300), leg=false)
	plot!(x -> x^2 + 2, ls=:dash, alpha=0.5)
	scatter!([min_value], [f(min_value)], xlims=(-5, 5), ylims=(-10, 20))
end

# ╔═╡ 9934adb3-b704-467f-b189-e90fb0c6c1cb
md"""
## Constrained optimization
"""

# ╔═╡ a0c8165a-dd64-46b8-9419-fe3ef2cf39e1
md"""
Often we need to add **constraints**, i.e. restrictions, to the problem.
"""

# ╔═╡ e9bff1db-a2ce-4821-a237-815793d9cbea
g(x) = 3x + 4

# ╔═╡ 696bddde-f5a3-42e6-b5b6-dd25a3fe0782
constraint(x, y) = y - x

# ╔═╡ 8dc1fe61-ed8d-4f5a-b200-6269cc89c142
k(x, y) = x^2 + y^2 - 1

# ╔═╡ f58a62aa-f56b-4114-bfef-c57bdbc24e3b
b_slider = @bind b Slider(-5:0.1:5, show_value=true, default=0)

# ╔═╡ 3ab8f4fe-3842-46ac-8411-37f509c7dfb5
minx, miny = let
	
	model = Model(Ipopt.Optimizer)
	
	register(model, :k, 2, k, autodiff=true)
	register(model, :constraint, 2, constraint, autodiff=true)

	@variable(model, -10 ≤ x ≤ 10)
	@variable(model, -10 ≤ y ≤ 10)


    @NLobjective(model, Min, k(x, y))
	@NLconstraint(model, constraint(x, y) == b)
	
	optimize!(model)
	
	(x = getvalue(x), y = getvalue(y))
end

# ╔═╡ 964a440f-e0bf-4cab-a1e7-1976a03127d3
md"""
b = $(b_slider)
"""

# ╔═╡ 3e87ef34-9d43-4c73-80fd-67c7e2441be8
gr()

# ╔═╡ 46ae2fae-5db8-4a43-b31b-a9018a6ff9e2
begin
	r = -5:0.1:5
	
	contour(r, r, k, leg=false)
	contour!(r, r, constraint, levels=[b], ratio=1, lw=3)
	scatter!([minx], [miny])
end

# ╔═╡ 64d5dae1-39ee-4bf0-9e27-3f1d54b88a8d
plotly()

# ╔═╡ 2dd2aefe-7152-4773-b630-5edda439c431
surface(-5:0.1:5, -5:0.1:5, k, alpha=0.5)

# ╔═╡ 34e39922-2781-4ef7-9310-b978d08ce727
md"""
$y - x = b$ so $y = x + b$

$z = x^2 + y^2 = x^2 + (x + b)^2$

"""

# ╔═╡ 9ab39d2f-7d0d-41ec-b4c2-68b27cd15172
begin
	xs = -5:0.1:5
	ys = xs .+ b
end

# ╔═╡ 9a64168d-ece0-4264-9193-5cb1cdf000ed
b_slider

# ╔═╡ 3a7decbc-5d45-4f72-95a5-6795391e80a2
begin
	surface(-5:0.1:5, -5:0.1:5, k, alpha=0.5)
	
	plot!(xs, ys, k.(xs, ys), lw=3)
	
	scatter!([minx], [miny], [k(minx, miny)], zlim=(-10, 50), xlim=(-5, 5), ylim=(-5, 5))

end

# ╔═╡ Cell order:
# ╠═4ed28d02-f423-4f53-8010-644edacd5b74
# ╠═d719e2ed-ade8-4640-82fe-ffcafd204792
# ╟─d18eaa56-b8ad-11eb-1586-b15a611d773d
# ╟─5bbd06bd-9191-4d06-84f3-95556afb9125
# ╟─3047f39a-a18a-4dea-9d2d-6523d7d0ec4f
# ╟─a0aeb0c6-0980-4c6a-8736-8eccdf17e561
# ╠═f488fa22-8ff9-4ea1-84c1-deaf966520d1
# ╠═7d635168-8251-4ee9-8cc5-85ac5d810e21
# ╟─3a81aaa1-05c3-4ef4-ab7a-bd913a5dc85e
# ╠═9b494263-7fb1-4893-aa15-33ad6b839773
# ╟─9934adb3-b704-467f-b189-e90fb0c6c1cb
# ╟─a0c8165a-dd64-46b8-9419-fe3ef2cf39e1
# ╠═e9bff1db-a2ce-4821-a237-815793d9cbea
# ╠═696bddde-f5a3-42e6-b5b6-dd25a3fe0782
# ╠═8dc1fe61-ed8d-4f5a-b200-6269cc89c142
# ╠═3ab8f4fe-3842-46ac-8411-37f509c7dfb5
# ╠═f58a62aa-f56b-4114-bfef-c57bdbc24e3b
# ╟─964a440f-e0bf-4cab-a1e7-1976a03127d3
# ╠═3e87ef34-9d43-4c73-80fd-67c7e2441be8
# ╠═46ae2fae-5db8-4a43-b31b-a9018a6ff9e2
# ╠═64d5dae1-39ee-4bf0-9e27-3f1d54b88a8d
# ╠═2dd2aefe-7152-4773-b630-5edda439c431
# ╟─34e39922-2781-4ef7-9310-b978d08ce727
# ╠═9ab39d2f-7d0d-41ec-b4c2-68b27cd15172
# ╠═9a64168d-ece0-4264-9193-5cb1cdf000ed
# ╠═3a7decbc-5d45-4f72-95a5-6795391e80a2
