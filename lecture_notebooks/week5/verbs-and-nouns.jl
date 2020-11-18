### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 12478d9e-01f0-11eb-05d9-51c85d57ad10
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 823ed6c4-01fb-11eb-0d84-3b3f9f659ec8
begin
	pkg"add StatsBase MixedModels GLM"

	using StatsBase       # Base package that has the "fit" verb
	using GLM             # defines a linear model type and how "fit" it
	using MixedModels     # defines model types and to "fit" them
end

# ╔═╡ 7cd6090e-0263-11eb-3c32-0fcb38a68d7d
md"""
# Using functions and types: philosophy

In this notebook we will look at the way that we think about using functions and types in Julia.

"""

# ╔═╡ d2a317f2-024f-11eb-19e3-739d3bbcd9e5
md"""

## The Julian point of view

Making an analogy between computer languages and natural (human) languages, we can think of **functions** as **verbs** that act on **objects**, which correspond to **nouns**.


> In Julia we do **verb-oriented programming**.

That is, we regard the verbs as the most important part of the program. We want to *do* stuff!

In contrast, in other languages like Python, C++ and Java it is usual to do object-oriented programming (OOP):

> In traditional object-oriented programming (OOP), we do **noun-oriented programming**.

In those languages we have nouns ("Classes"), which can or can't do certain functions (methods). The objects "contain" functionality within them, which turns out to often be very awkward


In Julia we have functions (verbs), which have many different implementations, i.e. **methods**, based on the numbers and types of the arguments passed to them. Stop and think about this world view for a minute!

We will learn more about types and how to create them later in this notebook. 
But remembering that the **purpose of types is to extend functions with new methods** allows effective use of Julia.
"""

# ╔═╡ 6478b0ce-0250-11eb-2101-bd419c8876a3
md"""
# Functions: verbs that take nouns
"""

# ╔═╡ 010f58ee-0264-11eb-06eb-a92345fd47a4
md"""

Let's look at an example verb.

In statistics we talk about **fitting** a model to some data. 

The package `StatsBase` defines the verb (function) `fit` and a few types of model.
Other packages import `StatsBase` and define more models and how the verb `fit` works on those models:
"""

# ╔═╡ 99475ac8-01fb-11eb-359c-7b61ffc1e67e
methods(StatsBase.fit)

# ╔═╡ 3897efb6-0263-11eb-1c53-93c71a2e65fe
md"""
There are **[298 registered Julia packages that depend on StatsBase](https://juliahub.com/ui/Packages/StatsBase/EZjIG/0.33.1?t=2)**! 
Some of them use `fit`, or **extend** it to act on new types!
"""

# ╔═╡ 5541133a-0200-11eb-0ad0-65c155a1ae19
md"""
# Types: nouns and how to do verbs on them

One of the reasons for creating a new type in Julia is to add functionality to a verb (function) by extending it to the new type.

The basic way of creating new types is by defining `struct`s.


## Structs

Structs have three essential roles:

- They have a type -- this can be used to define how a function acts on the struct;
- They form a container which holds many values;
- They carry type information for the values contained inside.
"""

# ╔═╡ 93872f5c-026a-11eb-077e-7bcc945b21c8
md"
We have seen the basics of defining `struct`s in previous lectures. Now let's think more about how to extend verbs (functions) to act on them, and about the types of the objects they contain.
"

# ╔═╡ 12800e28-026b-11eb-174a-6b39f8024cf9
md"Let's define an object representing a point or vector in two dimensions with integer coordinates:"

# ╔═╡ 9ff41dbe-0200-11eb-2b17-f5e1be67c003
struct IntPoint
	x::Int64
	y::Int64
end

# ╔═╡ 3b2d5ffc-0254-11eb-2133-2d643e4f8380
md"""

- The **type** of the `struct` itself is `IntPoint`.
- It **contains** fields (data) `x` and `y`.
- The **type** of `x` and `y` are both `Int`.

In the same way we can define a similar object that represents a 2D vector whose coordinates are real numbers:
"""

# ╔═╡ aa2a4ea2-0200-11eb-009a-d7e3da674f03
struct FloatPoint
	x::Float64
	y::Float64
end

# ╔═╡ 79dc50b6-0254-11eb-1643-41e1ce885bd4
md"Now suppose that we want to be able to add two vectors.

We could invent a new function called `add`. But Julia already has a suitable function, namely... `+`!

The first thing we need to do is `import` the `+` function from Julia Base (where standard functions like `+` are defined), in order to be able to **extend** it by defining how it acts on our new types:
"

# ╔═╡ e7747972-0200-11eb-02f8-57282fbb5ecf
begin
	import Base: +
	
	+(a::IntPoint,   b::IntPoint)   = IntPoint(  a.x + b.x, a.y + b.y)
	
	+(a::FloatPoint, b::FloatPoint) = FloatPoint(a.x + b.x, a.y + b.y)
end

# ╔═╡ 7706a7e2-0254-11eb-1ceb-c71c4c3d99e2
md"The first thing to do is to check that it works!"

# ╔═╡ c8d3b47e-0200-11eb-1716-af05e82b8cee
begin
	a = IntPoint(1, 2)
	b = IntPoint(3, 4)
end

# ╔═╡ d9c83660-0200-11eb-0fb3-81b0d7f942a3
a + b

# ╔═╡ 93ed61c2-026b-11eb-3a9c-1d91b8726f69
md"""Let's see what's going on "under the hood":"""

# ╔═╡ ba1ed036-0254-11eb-1d06-cb20ef1eabd8
@code_lowered a + b

# ╔═╡ 3b9efcb6-0201-11eb-3fd4-2d28974d0a69
md"At the next stage in the compilation process, Julia **propagates the types it knows about**!:"

# ╔═╡ 3490369c-0201-11eb-02d7-216bac39ff41
@code_typed a + b # Julia propagates the types of the fields!

# ╔═╡ b99faabc-026b-11eb-1e4f-bb4aee759d20
md"What happens if we do the same with the floating-point version?"

# ╔═╡ 5f3b3eda-0258-11eb-21a3-2d1b2942a5ba
begin
	p = FloatPoint(.1, .2)
	q = FloatPoint(.3, .4)

	p + q
end

# ╔═╡ 922e343c-0258-11eb-2f7a-07857d4bf2a5
@code_typed p + q

# ╔═╡ 9d434312-0258-11eb-3bf0-b39d045a13a2
md"""
Note that Julia uses `add_int` in the case of `IntPoint`, but `add_float` in the `FloatPoint` case. When Julia knows the exact types, the run time is fast!

**Exercise**: Make an `UntypedPoint` as

```julia
struct UntypedPoint
	x
	y
end
```

and check what the typed generated code looks like!
"""

# ╔═╡ 1d9de34a-0262-11eb-3315-4544128264e1
md"""
Also, since we have extended `+` from Base, we can now automatically **use other functions that themselves use `+`**! This is very powerful. For example, the `sum` function is defined in terms of `+`, so the following works:
"""

# ╔═╡ 2fab9c78-0262-11eb-20ff-db4129f9ccaf
sum( FloatPoint(i / 10, (2i) / 10) for i in 1:10 )

# ╔═╡ 8fed54ae-0259-11eb-2d68-271a9098df38
md"""
## Parametric types
"""

# ╔═╡ 31bbe554-026c-11eb-12eb-e3f381c6fbf2
md"If we look at the way we defined `IntPoint` and `FloatPoint`, and then extended `+`, you should be feeling uncomfortable! We seem to be repeating ourselves a lot, since *the code looks exactly the same in each case* -- except that we change `Int64` to `Float64`. If we wanted to add, e.g., a `Rational` point, we would have to copy and paste yet again.

Computers are supposed to be good at automating things like this! So we should be able to get Julia to do this repetition for us!
"

# ╔═╡ 8b0b9780-026c-11eb-3f58-29d7be478750
md"The way to do so is by making the field type, i.e. the type of each variable contained inside an object of the type (`Int64` or `Float64` in the above examples) into a **type parameter**:
"

# ╔═╡ 8043cea0-0201-11eb-32b1-c1ce95a3232b
struct Point{T}
	x::T
	y::T
end

# ╔═╡ e7940ec4-026c-11eb-1160-4d79007f1c71
md"We use curly braces (`{` and `}`) to tell Julia that `T` is a type parameter. 
When we now create objects of this type, Julia will *automatically make objects of the correct parametrised type!*:"

# ╔═╡ 24c8416a-0205-11eb-0037-bd088c0e65c5
Point(1, 2)

# ╔═╡ a1287c6a-0259-11eb-2051-bfa9aa1e3c84
Point(0.1, 0.2)

# ╔═╡ 3ff49068-025e-11eb-0f96-bd59dc20ffbc
Point(1//2, 3//4)

# ╔═╡ 11e8e816-026d-11eb-0ac5-ed4849ec66d0
md"We can extend functions that act on these types just like we did above. For example, let's extend the `angle` function to calculate the angle of the vector:"

# ╔═╡ aa9a36aa-0259-11eb-3c29-47966f1d707e
begin
	import Base: angle
	angle(p::Point) = atan(p.y, p.x)
end

# ╔═╡ c795d5a0-0259-11eb-1ef2-e5e6e76c602c
angle(Point(1, 2))

# ╔═╡ da41443e-0259-11eb-0304-6b92fb2de7d8
@code_typed angle(Point(1, 2))  # Change the arguments to Int64s and Rationals to see what happens!

# ╔═╡ 04219ea8-01ff-11eb-3019-b9bebbe14c43
md"""
## Abstract types

We now have different types `Point{T}` with different parameters `T`. What is `Point` itself?
"""

# ╔═╡ 9e8c92cc-026d-11eb-2b9e-9f76595e822f
Point

# ╔═╡ 9ac90468-026d-11eb-0a69-7194e6966932
md"""
**`Point`** is an **abstract type**. We can think of it as the combination, or **union** (in the sense of set theory), of *all* the types `Point{T}`, where `T` is replaced by all available types in the Julia environment, that either exist now or in the future when more code may be loaded from a package!

In general, abstract types in Julia are combinations, or a "merging", of other types into a single more general type. They are "abstract" in the sense that it is not possible to actually make objects of the abstract type. Objects always have a concrete type like `Int64` or `Point{Int64}`, which may be **subtypes** of an abstract type.

The **subtype** relation is written as `<:`.

"""

# ╔═╡ 88a7e668-0255-11eb-1d19-35e764da7c63
Point{Int} <: Point

# ╔═╡ 957250d6-0255-11eb-0193-d1da1ab2c640
Point <: Point{Int}

# ╔═╡ a7124698-0255-11eb-3ef5-137d00151773
md"You can create explicit unions with `Union`:"

# ╔═╡ 83465d62-0255-11eb-1a00-dfadf9c24d3a
Int <: Union{Int, Float64}

# ╔═╡ 20587260-026e-11eb-1299-39e2ca8ff416
md"""Here, `Union{Int64, Float64}` means the union (combination) of both of those types. We can read it as "either `Int64` or `Float64`".

We can use `isa` to check if a value is of a certain type:
"""

# ╔═╡ 34717d00-026e-11eb-010d-2f9ae44eb8d6
3 isa Int64

# ╔═╡ 44edf784-026e-11eb-25a9-7d852d047f2a
3 isa Union{Int, Float64}

# ╔═╡ 48de248c-026e-11eb-32ab-e73f454aaeca
3.5 isa Int64

# ╔═╡ 4b274aae-026e-11eb-0764-71f6879c8a0e
3.5 isa Union{Int64, Float64}

# ╔═╡ a1648f62-0255-11eb-1ff9-1738a037a86c
Float64 <: Union{Int, Float64}

# ╔═╡ b17fbfe8-0255-11eb-2c58-bbed6fe2cc7f
md"""
## Different kinds of `Point`s

The mathematical concept of **point** is more abstract than just $x$ and $y$ coordinates. For example, we could represent a point using polar coordinates instead.

But we could still ask the same questions, which correspond to **verbs**:

- `x_coord`: what is the $x$ coordinate?
- `y_coord`: what is the $y$ coordinate?
- `radius`: What is the distance from the origin?
- `angle`: What is the angle from the $x$ axis?
"""

# ╔═╡ 33a3695c-026f-11eb-2481-0bc92174ee8e
md"Let's define types that correspond to the two representations of a point:"

# ╔═╡ e6a13f4e-0255-11eb-0748-dba33f2bd1be
struct CartesianPoint{T}
	x::T
	y::T
end

# ╔═╡ 46ee84ee-026f-11eb-3a00-959ae43bd920
struct PolarPoint{T}
	r::T
	θ::T
end

# ╔═╡ 05b2bbec-0256-11eb-3d92-bd5956c64cf8
begin
	x_coord(p::CartesianPoint) = p.x
	y_coord(p::CartesianPoint) = p.y
	
	x_coord(p::PolarPoint) = p.r * cos(p.θ)
	y_coord(p::PolarPoint) = p.r * sin(p.θ)

	theta(p) = atan(y_coord(p), x_coord(p))  # abstract
	theta(p::PolarPoint) = p.θ # -- optimization

	radius(p) = hypot(xcoord(p), ycoord(p)) # abstract
	# radius(p::PolarPoint) = p.r -- optimization
end

# ╔═╡ 85904c9e-026f-11eb-312b-79d0652db9ca
md"We have defined **generic** methods that act on any object `p`. They will work as long as the functions that we call also work. For example:"

# ╔═╡ 9b2e0054-025c-11eb-29f1-07e6a2f9f6c6
theta(CartesianPoint(1,2))

# ╔═╡ bd1d3278-025c-11eb-344e-ed13b50353c8
theta(PolarPoint(2.0,0.4636476090008061))

# ╔═╡ 05849030-025d-11eb-3c7e-07723387e94f
@code_typed theta(PolarPoint(2.0,0.4636476090008061)) # But we already know theta!

# ╔═╡ 0b044d6e-0270-11eb-20e6-9165669bb69f
md"""
But in fact, for a `PolarPoint` we already know theta -- it is crazy to do that complicated calculation. So we can define a **specialised method** that works *only* for `PolarPoint`, and leave the **generic "fallback"** that works with other types!

Julia will check the type of the argument we pass in to the `theta` function and will choose the **most specific** method of the `theta` function that applies to objects of that type.
"""

# ╔═╡ a1dac51c-025d-11eb-10ff-f7e813f9832a
md"""
Note that currently the functions `theta` and `radius` accept any type at all! But this is probably *not* what we actually intended, for example:
"""

# ╔═╡ 8f54be20-025d-11eb-2bcf-dd95f61eb477
theta("hello") 

# ╔═╡ d34342a6-0270-11eb-0ea8-b141ccf5ae50
md"The function `theta` itself is happy to accept a `String`, since we didn't restrict its input arguments at all. However, the first thing that it does is call `y_coord`, which fails since it has no method which can accept a `String`.
"

# ╔═╡ 142c6db0-025d-11eb-16ff-dd0bed953f8b
md"""
A solution to this would be to create an abstract type which encompasses the different `Point` types, and define `len` and `theta` only on that.

We could use a `Union{CartesianPoint, PolarPoint}`, but we actually want to **allow future users to create new `Point` types** and have this code still work, provided they define `x_coord` and `y_coord` on the new type!

To do this we *make a new abstract type*:
"""

# ╔═╡ 83445c12-025d-11eb-06fa-91b2906b95c9
abstract type AbstractPoint end

# ╔═╡ cae32b5c-025d-11eb-365e-f1c87a3da5fc
md"""Now we can add `<: AbstractPoint` to the struct definitions to make them subtypes of this new `AbstractPoint` abstract type, and we can annotate the function definitions to only accept objects which are `AbstractPoint`s!
"""

# ╔═╡ a309eacc-0278-11eb-3cca-17a714e0d512
struct NewPoint <: AbstractPoint
	x
	y
end

# ╔═╡ b6add3ec-0278-11eb-35be-f58dc34f4d87
new_theta(p::AbstractPoint) = theta(p)

# ╔═╡ 4083d902-0271-11eb-1182-a9fc930470df
md"As a complicated example of a **type hierarchy** in Julia, here is the hierarchy of number types that are defined in base Julia:
"

# ╔═╡ 14caccfc-025e-11eb-1244-67d123320e10
md"![](https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/Type-hierarchy-for-julia-numbers.png/1024px-Type-hierarchy-for-julia-numbers.png)"

# ╔═╡ 5a0b6818-0271-11eb-1475-b3e814606f77
md"The nodes with no children are concrete types. All the other nodes are abstract types. We may define new number types by making them subtypes of the relevant abstract type. For example, the [DoubleFloats.jl](https://github.com/JuliaMath/DoubleFloats.jl) package defines a new type `Double64`, having a precision roughly twice that of a `Float64`, as a new subtype of `AbstractFloat`.
"

# ╔═╡ Cell order:
# ╠═12478d9e-01f0-11eb-05d9-51c85d57ad10
# ╟─7cd6090e-0263-11eb-3c32-0fcb38a68d7d
# ╟─d2a317f2-024f-11eb-19e3-739d3bbcd9e5
# ╟─6478b0ce-0250-11eb-2101-bd419c8876a3
# ╟─010f58ee-0264-11eb-06eb-a92345fd47a4
# ╠═823ed6c4-01fb-11eb-0d84-3b3f9f659ec8
# ╠═99475ac8-01fb-11eb-359c-7b61ffc1e67e
# ╟─3897efb6-0263-11eb-1c53-93c71a2e65fe
# ╟─5541133a-0200-11eb-0ad0-65c155a1ae19
# ╟─93872f5c-026a-11eb-077e-7bcc945b21c8
# ╟─12800e28-026b-11eb-174a-6b39f8024cf9
# ╠═9ff41dbe-0200-11eb-2b17-f5e1be67c003
# ╟─3b2d5ffc-0254-11eb-2133-2d643e4f8380
# ╠═aa2a4ea2-0200-11eb-009a-d7e3da674f03
# ╟─79dc50b6-0254-11eb-1643-41e1ce885bd4
# ╠═e7747972-0200-11eb-02f8-57282fbb5ecf
# ╟─7706a7e2-0254-11eb-1ceb-c71c4c3d99e2
# ╠═c8d3b47e-0200-11eb-1716-af05e82b8cee
# ╠═d9c83660-0200-11eb-0fb3-81b0d7f942a3
# ╟─93ed61c2-026b-11eb-3a9c-1d91b8726f69
# ╠═ba1ed036-0254-11eb-1d06-cb20ef1eabd8
# ╟─3b9efcb6-0201-11eb-3fd4-2d28974d0a69
# ╠═3490369c-0201-11eb-02d7-216bac39ff41
# ╟─b99faabc-026b-11eb-1e4f-bb4aee759d20
# ╠═5f3b3eda-0258-11eb-21a3-2d1b2942a5ba
# ╠═922e343c-0258-11eb-2f7a-07857d4bf2a5
# ╟─9d434312-0258-11eb-3bf0-b39d045a13a2
# ╟─1d9de34a-0262-11eb-3315-4544128264e1
# ╠═2fab9c78-0262-11eb-20ff-db4129f9ccaf
# ╟─8fed54ae-0259-11eb-2d68-271a9098df38
# ╟─31bbe554-026c-11eb-12eb-e3f381c6fbf2
# ╟─8b0b9780-026c-11eb-3f58-29d7be478750
# ╠═8043cea0-0201-11eb-32b1-c1ce95a3232b
# ╟─e7940ec4-026c-11eb-1160-4d79007f1c71
# ╠═24c8416a-0205-11eb-0037-bd088c0e65c5
# ╠═a1287c6a-0259-11eb-2051-bfa9aa1e3c84
# ╠═3ff49068-025e-11eb-0f96-bd59dc20ffbc
# ╟─11e8e816-026d-11eb-0ac5-ed4849ec66d0
# ╠═aa9a36aa-0259-11eb-3c29-47966f1d707e
# ╠═c795d5a0-0259-11eb-1ef2-e5e6e76c602c
# ╠═da41443e-0259-11eb-0304-6b92fb2de7d8
# ╟─04219ea8-01ff-11eb-3019-b9bebbe14c43
# ╠═9e8c92cc-026d-11eb-2b9e-9f76595e822f
# ╟─9ac90468-026d-11eb-0a69-7194e6966932
# ╠═88a7e668-0255-11eb-1d19-35e764da7c63
# ╠═957250d6-0255-11eb-0193-d1da1ab2c640
# ╟─a7124698-0255-11eb-3ef5-137d00151773
# ╠═83465d62-0255-11eb-1a00-dfadf9c24d3a
# ╟─20587260-026e-11eb-1299-39e2ca8ff416
# ╠═34717d00-026e-11eb-010d-2f9ae44eb8d6
# ╠═44edf784-026e-11eb-25a9-7d852d047f2a
# ╠═48de248c-026e-11eb-32ab-e73f454aaeca
# ╠═4b274aae-026e-11eb-0764-71f6879c8a0e
# ╠═a1648f62-0255-11eb-1ff9-1738a037a86c
# ╟─b17fbfe8-0255-11eb-2c58-bbed6fe2cc7f
# ╟─33a3695c-026f-11eb-2481-0bc92174ee8e
# ╠═e6a13f4e-0255-11eb-0748-dba33f2bd1be
# ╠═46ee84ee-026f-11eb-3a00-959ae43bd920
# ╠═05b2bbec-0256-11eb-3d92-bd5956c64cf8
# ╟─85904c9e-026f-11eb-312b-79d0652db9ca
# ╠═9b2e0054-025c-11eb-29f1-07e6a2f9f6c6
# ╠═bd1d3278-025c-11eb-344e-ed13b50353c8
# ╠═05849030-025d-11eb-3c7e-07723387e94f
# ╟─0b044d6e-0270-11eb-20e6-9165669bb69f
# ╟─a1dac51c-025d-11eb-10ff-f7e813f9832a
# ╠═8f54be20-025d-11eb-2bcf-dd95f61eb477
# ╟─d34342a6-0270-11eb-0ea8-b141ccf5ae50
# ╟─142c6db0-025d-11eb-16ff-dd0bed953f8b
# ╠═83445c12-025d-11eb-06fa-91b2906b95c9
# ╟─cae32b5c-025d-11eb-365e-f1c87a3da5fc
# ╠═a309eacc-0278-11eb-3cca-17a714e0d512
# ╠═b6add3ec-0278-11eb-35be-f58dc34f4d87
# ╟─4083d902-0271-11eb-1182-a9fc930470df
# ╟─14caccfc-025e-11eb-1244-67d123320e10
# ╟─5a0b6818-0271-11eb-1475-b3e814606f77
