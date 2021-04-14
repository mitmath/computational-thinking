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

# ╔═╡ 945c2bf1-d7dc-42c9-93d7-fd754f8fb1d7
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
"><em>Section 2.9</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Optimization </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 400ebe26-0dea-4cf2-8744-6c73a45cd33e
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="Optim", version="1"),
        Pkg.PackageSpec(name="JuMP", version="0.21"),
        Pkg.PackageSpec(name="Ipopt", version="0.6"),
        Pkg.PackageSpec(name="ForwardDiff", version="0.10"),
    ])
    using PlutoUI, Plots, Statistics, Optim, JuMP, Ipopt, ForwardDiff
end

# ╔═╡ b8d66df5-f593-40b4-8c46-3b638f9cc3e1
TableOfContents(title="📚 Table of Contents", aside=true)

# ╔═╡ 77253dd5-a2c8-4cf5-890a-5c8420c395b7
md"""
# Julia concepts

- Named tuples
"""

# ╔═╡ dccbd53d-33ed-4d37-9d2c-da76e090d5dd
md"""
# Line Fitting Many Ways
"""

# ╔═╡ 235919f2-a4b0-4bb5-870c-82809a170195
md"""
Last lecture we did some line fitting ("regression"). Let's see how we can actually solve that problem.
"""

# ╔═╡ 2ed86f33-bced-413c-9a8d-c6e49bfe5afb
md"""
# Exploratory Data Analysis
"""

# ╔═╡ a78aff8d-5ac0-4915-92de-ffefdb08f88e
md"""
Let's start off by making some noisy data.
"""

# ╔═╡ 0e43a6d3-7198-422b-b50c-b9caeaa53074
md"""
n = $(@bind n Slider(3:10:200, show_value=true))
"""

# ╔═╡ f8c98995-2152-4d45-996a-a0532a233719
x = sort((rand( -10:100, n)))

# ╔═╡ 8a5f1fdc-3cef-4c02-a73f-e5975b57b15a
y = 5/9 .* x  .- 17.7777777  .+  5 .* randn.() #  same as y =  5/9 .* (x .- 32)

# ╔═╡ 647093eb-a7e3-4175-8091-29c33407e5c9
begin	
	plot(x,y, m=:c, mc=:red, legend=false, ls=:dash)
	xlabel!("°F")
	ylabel!("°C")
	# plot!( x, (x.-30)./2) Dave's cool approximation
end

# ╔═╡ cdc25782-65a8-43c5-8090-c1241b798b1a
md"""
# Least Squares fitting to a straight line
"""

# ╔═╡ 9ec4dd43-c95a-4f11-b844-fd6ccc93bb68
md"""
Suppose we are given data $x_i$ and measurements $y_i$. **Least-squares fitting** a straight line means finding the best ``m`` (slope) and ``b`` (intercept) that minimize
the "error" (distance from the data) in a least-squares sense:

$$\min_{m,b} \sum  ( (b + m x_i) - y_i)^2$$ 
"""

# ╔═╡ 9276b315-27b2-4b01-8fc8-4ebbba58d080
md"""
# Direct Formulas
"""

# ╔═╡ d22fd4bd-acfe-4e27-a484-3c2d6138f44e
md"""
## The Statistician's formula
"""

# ╔═╡ da0d208b-7d30-470a-b180-4cbfa98298e7
begin
	m = cov(x,y)/var(x) # same as (x.-mean(x))⋅(y.-mean(y))/sum(abs2,x.-mean(x))
	b = mean(y) - m * mean(x)
	(b=b, m=m)
end

# ╔═╡ 6cf233a7-9b8b-47aa-a3ad-2440d001af73
md"""
### Julia: Named Tuples
"""

# ╔═╡ 613c3e5f-bbdd-4cf9-b30f-69e2c42ae0ec
nt = (first=1, next=2, last=3.1) # kind of handy

# ╔═╡ 4cce580b-0032-419c-b386-e470b084ab96
typeof( nt )

# ╔═╡ 5503b4de-0b53-4223-8ce0-5e014be3f7ab
plot!(x -> m*x + b, lw=3, alpha=0.7)

# ╔═╡ 05e512ca-3123-48d9-9c11-5d6e9d90ef95
md"""
## The Linear Algebraist's Formula
"""

# ╔═╡ 939900b4-5327-43b4-883f-740c173c0db4
md"""
This is even shorter, but you need to know linear algebra. But it also generalizes.
"""

# ╔═╡ e0b4c2a9-a68b-47af-bf9c-f1a9f0256fd4
[one.(x) x]\y  # even shorter but you need to know linear algebra, but generalizes

# ╔═╡ 6d25e38e-c18a-48b3-8b12-b670f5a5180f
md"""
# Optimization Methods

Since the problem is an optimization problem, we can use optimization software to obtain an answer.  This is overkill for lines, but generalizes to so many nonlinear situations, including neural networks as in machine learning.
"""

# ╔═╡ f291c0cb-51ee-4b30-9e07-e7cf374f809e
md"""
## Optim.jl: A package written entirely in Julia for optimization
"""

# ╔═╡ aa06a447-d6c5-48ee-9864-c1f431fe5e4b
md"""
[Optim.jl Documentation](https://julianlsolvers.github.io/Optim.jl/stable/#)
"""

# ╔═╡ d3edfb26-7258-45a3-a88c-60831338df1f
md"""
We can  ask software to just solve the problem

$$\min_{b,m} \sum_{i=1}^n  [ (b + m x_i) - y_i]^2$$

or
``\min_{b,m}``  `loss(b,m)`

"""

# ╔═╡ 372b304a-3f57-4bec-88df-3d51ded57d5c
loss( (b, m) ) = sum( (b + m*x[i] - y[i])^2  for i=1:n )

# ╔═╡ 13b9ff38-225d-4ec1-be7f-bf0e0f5b4076
result =  optimize(loss, [0.0,0.0] )  # optimize f with starting guess

# ╔═╡ 7bd9bb8f-36c5-4ae1-ba20-25732d7fef2e
result.minimizer

# ╔═╡ 0af48ea2-698e-4919-aa96-97c5f46a928b
md"""
### Functions of Functions and Computing Power

Optimization such as 
``\min_{b,m}``  `loss(b, m)`
is an example of a fairly heavy function of a function.  By this we mean that the input is a *function* such as  `loss(b, m)` and the output is the location or value of a minimum, say.  By "heavy" we mean that typically a large amount of computing power is needed.

Not that many years ago, computers were not strong enough for realistic problems.  Modern-day machine learning and so much more is enabled because computers can now surround entire codes with optimization, or if the software is compatible, automatic differentiation.  
"""

# ╔═╡ 10386ce6-82fd-46ea-a44a-6ba14c5b0cd9
md"""
## JuMP.jl: A popular modelling language for Optimization Problems

JuMP = Julia for Mathematical Programming
"""

# ╔═╡ b7d8f11d-91ce-4b3a-87a1-1aa162e198ff
let
	
	n = length(x)
	model = Model(Ipopt.Optimizer)
	
	@variable(model, b)
	@variable(model, m)

    @objective(model, Min, sum( (b + m*x[i] - y[i])^2 for i in 1:n) )

	#set_silent(model)
	optimize!(model)
	
	(b=getvalue(b), m=getvalue(m))
end

# ╔═╡ 5ca85768-a19e-4ddf-89a4-88dca599d7a7
md"""
# Gradients
"""

# ╔═╡ dd39b088-f59f-43fa-bce0-5076398238f9
md"""
The above optimization methods made no explicit mention of derivative or gradient information.  For simple problems, gradients can be hand calculated, but for many real problems this is impractical.
"""

# ╔═╡ 5f41acf0-22bd-4224-a65a-81bd656e1c07
md"""
### Hand Computation
"""

# ╔═╡ 84f3a912-031c-40ed-ae29-02bbcc7b4612
md"""
``  \frac{\partial}{\partial b}\sum_{i=1}^n  ( (b + m x_i) - y_i)^2 
=   2\sum_{i=1}^n  ( (b + m x_i) - y_i) `` 


``   \frac{\partial}{\partial m }\sum_{i=1}^n  ( (b + m x_i) - y_i)^2 
=   2\sum_{i=1}^n  x_i( (b + m x_i) - y_i) `` 
"""

# ╔═╡ 6f64ede7-612e-47b3-b3a4-d22a1992a98d
begin
	∇loss(b,m,i) = 2*(b+m*x[i]-y[i]) .* [1,x[i]] # ith summand
	∇loss(b,m) = sum(∇loss(b,m,i) for i=1:n)
	
end

# ╔═╡ 36300b71-5a96-4964-b661-93de5631cf07
md"""
### Finite Difference Evaluation
"""

# ╔═╡ ad578b33-4387-49f5-b39d-92e05fca4ea5
∇loss(.1,.3)

# ╔═╡ 67fd90d7-bb34-411f-89f1-a410e6fb29ba
begin # finite difference
	ϵ = .000000001
	([loss([.1+ϵ ,.3]);loss([.1 ,.3+ϵ])] .- loss([.1 ,.3])) ./ ϵ
end

# ╔═╡ 3e229e4a-a697-460e-b995-a4773a6aca70
md"""
### Automatic Differentiation (AutoDiff)
 We're all so good at calculus I suppose, but nothing like letting the computer do it.  For real problems, what you learned in calculus is impractical. Note: Autodiff is not finite differences.  It is not as problematic as finite differences is in that
with finite differences it can be hard to know which ϵ to use, etc.
"""

# ╔═╡ 7566cb7e-f5da-4b81-af07-bf2c86963333
∇loss(.1,.3) # hand computation

# ╔═╡ e6d9aafd-fbd6-4ec4-a4a1-740a4e889dc5
ForwardDiff.gradient( loss, [.1,.3])

# ╔═╡ c9417d90-a9cb-4655-a258-8a8898e5576a
md"""
# Gradient Descent can be difficult for complicated functions
"""

# ╔═╡ 6535280a-e0ce-4e13-86dd-165d5f06cfe7
let
	b,m = 0,0  # starting guess
	
	for i=1:25
		db,dm = ∇loss(b,m)
		
		# Getting a good step size can be really hard
		# I worked out the line search η by hand
		η = sum( (b+m*x[i]-y[i])*(db+dm*x[i]) for i=1:n)/sum( (db+dm*x[i])^2 for i=1:n)
		
		b,m  = (b,m) .- η .* (db,dm)
	end
	(b=b,m=m)
	
end

# ╔═╡ 4c285bc2-b3c2-4d20-a904-ecaa07795342
md"""
Hoping for
	
`(b=-18.1716, m=0.56601)`
"""

# ╔═╡ 592397eb-ec52-423b-925b-d8becb9eac8e
md"""
# Stochastic Gradient Descent

Pick one coordinate (or a few coordinates) to update at a time.
This is what works in machine learning.

"""

# ╔═╡ 7086950b-c8db-49d4-b095-15be91c73b56
let
	b, m  = 0.0, 0.0
	for t=1:10_000_000
	    η = .00002  # there seems to be an art to picking these steplengths
	 
	    b,m  =  (b,m) .- η *∇loss(b,m, rand(1:n))
	   
	end
   	(b=b,m=m)
end

# ╔═╡ 327514f1-8081-4a6c-8be4-8ffd52ed3c46
md"""
# Bells and Whistles for optim.jl
"""

# ╔═╡ 98e00b2d-0802-4160-8e5c-302be5226916
optimize(loss, [0.0,0.0], BFGS(),  autodiff=:forward)

# ╔═╡ ef165ca5-bf4f-465e-8e9a-df1aec2d7caa
optimize(loss, [0.0,0.0], BFGS() )

# ╔═╡ 0305b418-51bb-47bb-98fb-319fc26b94cf
optimize(loss, [0.0,0.0], GradientDescent() )

# ╔═╡ 304a3a6e-c8c3-48d8-a101-313b3aa062f2
optimize(loss, [0.0,0.0], GradientDescent(), autodiff=:forward )

# ╔═╡ Cell order:
# ╟─945c2bf1-d7dc-42c9-93d7-fd754f8fb1d7
# ╠═400ebe26-0dea-4cf2-8744-6c73a45cd33e
# ╠═b8d66df5-f593-40b4-8c46-3b638f9cc3e1
# ╟─77253dd5-a2c8-4cf5-890a-5c8420c395b7
# ╟─dccbd53d-33ed-4d37-9d2c-da76e090d5dd
# ╟─235919f2-a4b0-4bb5-870c-82809a170195
# ╟─2ed86f33-bced-413c-9a8d-c6e49bfe5afb
# ╟─a78aff8d-5ac0-4915-92de-ffefdb08f88e
# ╟─0e43a6d3-7198-422b-b50c-b9caeaa53074
# ╠═f8c98995-2152-4d45-996a-a0532a233719
# ╠═8a5f1fdc-3cef-4c02-a73f-e5975b57b15a
# ╠═647093eb-a7e3-4175-8091-29c33407e5c9
# ╟─cdc25782-65a8-43c5-8090-c1241b798b1a
# ╟─9ec4dd43-c95a-4f11-b844-fd6ccc93bb68
# ╟─9276b315-27b2-4b01-8fc8-4ebbba58d080
# ╟─d22fd4bd-acfe-4e27-a484-3c2d6138f44e
# ╠═da0d208b-7d30-470a-b180-4cbfa98298e7
# ╟─6cf233a7-9b8b-47aa-a3ad-2440d001af73
# ╠═613c3e5f-bbdd-4cf9-b30f-69e2c42ae0ec
# ╠═4cce580b-0032-419c-b386-e470b084ab96
# ╠═5503b4de-0b53-4223-8ce0-5e014be3f7ab
# ╟─05e512ca-3123-48d9-9c11-5d6e9d90ef95
# ╟─939900b4-5327-43b4-883f-740c173c0db4
# ╠═e0b4c2a9-a68b-47af-bf9c-f1a9f0256fd4
# ╟─6d25e38e-c18a-48b3-8b12-b670f5a5180f
# ╟─f291c0cb-51ee-4b30-9e07-e7cf374f809e
# ╟─aa06a447-d6c5-48ee-9864-c1f431fe5e4b
# ╟─d3edfb26-7258-45a3-a88c-60831338df1f
# ╠═372b304a-3f57-4bec-88df-3d51ded57d5c
# ╠═13b9ff38-225d-4ec1-be7f-bf0e0f5b4076
# ╠═7bd9bb8f-36c5-4ae1-ba20-25732d7fef2e
# ╟─0af48ea2-698e-4919-aa96-97c5f46a928b
# ╟─10386ce6-82fd-46ea-a44a-6ba14c5b0cd9
# ╠═b7d8f11d-91ce-4b3a-87a1-1aa162e198ff
# ╟─5ca85768-a19e-4ddf-89a4-88dca599d7a7
# ╟─dd39b088-f59f-43fa-bce0-5076398238f9
# ╟─5f41acf0-22bd-4224-a65a-81bd656e1c07
# ╟─84f3a912-031c-40ed-ae29-02bbcc7b4612
# ╠═6f64ede7-612e-47b3-b3a4-d22a1992a98d
# ╟─36300b71-5a96-4964-b661-93de5631cf07
# ╠═ad578b33-4387-49f5-b39d-92e05fca4ea5
# ╠═67fd90d7-bb34-411f-89f1-a410e6fb29ba
# ╟─3e229e4a-a697-460e-b995-a4773a6aca70
# ╠═7566cb7e-f5da-4b81-af07-bf2c86963333
# ╠═e6d9aafd-fbd6-4ec4-a4a1-740a4e889dc5
# ╟─c9417d90-a9cb-4655-a258-8a8898e5576a
# ╠═6535280a-e0ce-4e13-86dd-165d5f06cfe7
# ╟─4c285bc2-b3c2-4d20-a904-ecaa07795342
# ╟─592397eb-ec52-423b-925b-d8becb9eac8e
# ╠═7086950b-c8db-49d4-b095-15be91c73b56
# ╟─327514f1-8081-4a6c-8be4-8ffd52ed3c46
# ╠═98e00b2d-0802-4160-8e5c-302be5226916
# ╠═ef165ca5-bf4f-465e-8e9a-df1aec2d7caa
# ╠═0305b418-51bb-47bb-98fb-319fc26b94cf
# ╠═304a3a6e-c8c3-48d8-a101-313b3aa062f2
