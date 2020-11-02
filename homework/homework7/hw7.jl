### A Pluto.jl notebook ###
# v0.12.6

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

# ╔═╡ c3e52bf2-ca9a-11ea-13aa-03a4335f2906
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Plots", version="1.6-1"),
			Pkg.PackageSpec(name="PlutoUI", version="0.6.8-0.6"),
			])
	using Plots
	using PlutoUI
	using LinearAlgebra
end

# ╔═╡ 1df32310-19c4-11eb-0824-6766cd21aaf4
md"_homework 7, version 1_"

# ╔═╡ 1e01c912-19c4-11eb-269a-9796cccdf274
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

# ╔═╡ 1e109620-19c4-11eb-013e-1bc95c14c2ba
md"""

# **Homework 7**: _Raytracing in 2D_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 1e202680-19c4-11eb-29a7-99061b886b3c
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 1df82c20-19c4-11eb-0959-8543a0d5630d
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 1e2cd0b0-19c4-11eb-3583-0b82092139aa
md"_Let's create a package environment:_"

# ╔═╡ 92290e54-1940-11eb-1a24-5d1eaee9f6ca
md"""
## **Exercise 1:** _Walls_

As discussed the lecture, event-driven simulations are the traditional method used for raytracing. Here, we look for any objects in our path and _analytically_ determine how far away they are. From there, we take one big timestep all the way to the surface boundary, calculate refraction or reflection to see what direction we are moving in, and then seek out any other object we could potentially run into.

So let's start simple with determining when a ray of light could intersect with a wall.

#### Exercise 1.1 - _what is a wall?_

To start, let's create the concept of a wall. For our purposes, walls will be infinitely long, so we only need to create an object that has a position and a normal vector at that position:
"""

# ╔═╡ d851a202-1ca0-11eb-3da0-51fcb656783c
abstract type Object end

# ╔═╡ 99c61b74-1941-11eb-2323-2bdb7c120a28
struct Wall <: Object
	"Position"
	position::Vector{Float64}

	"Normal vector"
	normal::Vector{Float64}
end

# ╔═╡ 0906b340-19d3-11eb-112c-e568f69deb5d
test_wall = Wall(
	[8,-1],
	normalize([-3,1]),
)

# ╔═╡ 6de1bafc-1a01-11eb-3d67-c9d9b6c3cea8
function plot_object!(p, wall::Wall)
	# old_xlims = xlims(p)
	# old_ylims = ylims(p)
	
	adjacent = [wall.normal[2], -wall.normal[1]]
	
	a = wall.position + adjacent * 20
	b = wall.position - adjacent * 20
	
	line = [a, b]
	
	plot!(p, first.(line), last.(line), label="Wall")
	# xlims!(p, old_xlims)
	# xlims!(p, old_xlims)
end

# ╔═╡ 5f551588-1ac4-11eb-1f86-197442f1ef1d
md"""
In our simulations, we will enclose our scene in a box of **four walls**, to make sure that no rays can escape the scene. We have written this box (i.e. vector of walls) below, but we are still missing the roof.
"""

# ╔═╡ ac9bafaa-1ac4-11eb-16c4-0df8133f9c98
box_scene = [
	Wall(
		[10,0],
		[-1,0]
		),
	Wall(
		[-10,0],
		[1,0]
		),
	Wall(
		[0,-10],
		[0,1]
		),
	# your code here
	]

# ╔═╡ 293776f8-1ac4-11eb-21db-9d023c09e89f
md"""
👉 Modify the definition of `box_scene` to be a vector of 4 walls, instead of 3. The fourth wall should be positioned at `[0,10]`, and point downwards.
"""

# ╔═╡ e5ed6098-1c70-11eb-0b58-31d1830b9a10
md"""
In the next exercise, we will find the intersection of a ray of light and a wall. To represent light, we create a `struct` called **`Photon`**, holding the position and travel direction of a single particle of light. We also include the _index of refraction_ of the medium it is currently traveling in, we will use this later.
"""

# ╔═╡ 24b0d4ba-192c-11eb-0f66-e77b544b0510
struct Photon
	"Position vector"
	p::Vector{Float64}

	"Direction vector"
	l::Vector{Float64}

    "Current Index of Refraction"
	ior::Real
end

# ╔═╡ 925e98d4-1c78-11eb-230d-994518f0060e
test_photon = Photon([-1, 2], normalize([1,-.8]), 1.0)

# ╔═╡ eabca8ce-1c73-11eb-26ad-271f6eba889b
function plot_photon_arrow!(p, photon::Photon, length=2; kwargs...)
	line = [photon.p, photon.p .+ length*photon.l]
	
	plot!(p, first.(line), last.(line); lw=2, arrow=true, color=:darkred, kwargs..., label=nothing)
	scatter!(p, photon.p[1:1], photon.p[2:2]; color=:darkred, markersize=3, label=nothing, kwargs...)
end

# ╔═╡ aa43ef1c-1941-11eb-04de-552719a08da0
md"""
$(html"<br><br><br><br>")
#### Exercise 1.2 - _how far is the wall?_
We will write a function that finds the location where a photon hits the wall. Instead of moving the photon forward in small timesteps until we reach the wall, we will compute the intersection directly, making use of the fact that the wall is a geometrically simple object.

Our function will return one of two possible types: a `Miss` or a `Intersection`. We define these types below, and both definitions need some elaboration.
"""

# ╔═╡ 8acef4b0-1a09-11eb-068d-79a259244ed1
struct Miss end

# ╔═╡ 8018fbf0-1a05-11eb-3032-95aae07ca78f
struct Intersection{T<:Object}
	object::T
	distance::Float64
	point::Vector{Float64}
end

# ╔═╡ e9c5d68c-1ac2-11eb-04ec-3b72eb133239
md"""
##### `Miss` 
is a struct with _no fields_. It does not contain any information, except the fact that it is a `Miss`. You create a new `Miss` object like so:
"""

# ╔═╡ 5a9d00f6-1ac3-11eb-01fb-53c35796e766
a_miss = Miss()

# ╔═╡ 5aa7c4e8-1ac3-11eb-23f3-03bd58e75c4b
md"""
##### `Intersection`
is a **parametric type**. The first field (`object`) is of type `T`, and `T` is a subtype of `Object`. Have a look at the definition above, and take note of how we write such statements in Julia syntax.

We also could have used `Object` directly as the type for the field `object`, but what's special about parametric types is that `T` becomes "part of the type". Let's have a look at an example:
"""

# ╔═╡ 9df1d0f2-1ac3-11eb-0eac-d90eccca669c
test_intersection_1 = Intersection(test_wall, 3.0, [1.0,2.0])

# ╔═╡ bc10541e-1ac3-11eb-0b5f-916922f1a8e8
typeof(test_intersection_1)

# ╔═╡ d39f149e-1ac3-11eb-39a2-41c2030d7d49
md"""
You see that `Wall` is **included in the type**. This will be very useful later, when we want to do something different _depending on the intersected object_ (wall, sphere, etc.) using multiple dispatch. We can write one method for `::Intersection{Sphere}`, and one for `::Intersection{Wall}`.
"""

# ╔═╡ e135d490-1ac2-11eb-053e-914051f16e31
md"""
 $(html"<br><br>")

##### Wall geometry
So, how do we find the location where it hits the wall? Well, because our walls are infinitely long, we are essentially trying to find the point at which 2 lines intersect.

To do this, we can combine a few dot products: one to find how far away we are, and another to scale that distance. Mathematically, it would look like:

$D = -\frac{(p_{\text{ray}} - p_{\text{wall}})\cdot \hat n}{\hat \ell \cdot \hat n},$

where $p$ is the position, $\hat \ell$ is the direction of the light, and $\hat n$ is the normal vector for the wall. subscripts $i$, $r$, and $w$ represent the intersection point, ray, and wall respectively. The result is $D$, the amount that the photon needs to travel until it hits the wall.

👉 Write a function `intersection_distance` that implements this formula, and returns $D$. You can use `dot(a,b)` to compute the vector dot product ``a \cdot b``.
"""

# ╔═╡ abe3de54-1ca0-11eb-01cd-11fe798bfb97
function intersection_distance(photon::Photon, wall::Wall)
	
	return missing
end

# ╔═╡ 42d65f56-1aca-11eb-1079-e32f85554349
md"""
 $(html"<br><br><br><br>")
#### Exercise 1.3 - _hitting the wall_

👉 Write a function `intersection` that takes a `photon` and a `wall`, and returns either a `Miss` or an `Intersection`, based on the result of `intersection_distance(photon, wall)` ``= D``.

If $D$ is _positive_, then the photon will hit the wall, and we should return an `Intersection`. We already have the intersected object, and we have $D$, our intersection distance. To find the intersection _point_, we use the photon's position and velocity.

$p_{\text{intersection}} = p_{\text{ray}} + D\hat \ell$

If $D$ is _negative_ (or zero), then the wall is _behind_ the photon - we should return a `Miss`.

##### Floating points
We are using _floating points_ (`Float64`) to store positions, distances, etc., which means that we need to account for small errors. Like in the lecture, we will not check for `D > 0`, but `D > ϵ` with `ϵ = 1e-3`.
"""

# ╔═╡ a5847264-1ca0-11eb-0b45-eb5388f6e688
function intersection(photon::Photon, wall::Wall; ϵ=1e-3)
	
	return missing
end

# ╔═╡ 7f286ccc-1c75-11eb-1270-95a87840b300
@bind dizzy_angle Slider(0:0.0001:2π, default=2.2)

# ╔═╡ 6544be90-19d3-11eb-153c-218025f738c6
dizzy = Photon([0, 1], normalize([cos(dizzy_angle + π),sin(dizzy_angle + π)]), 1.0)

# ╔═╡ d70380a4-1ad0-11eb-1184-f7e9b84a83ad
md"""
 $(html"<br><br><br><br>")
#### Exercise 1.4 - _which wall?_

We are now able to find the `Intersection` of a single photon with a single wall (or detect a `Miss`). Great! To make our simulation more interesting, we will combine **multiple walls** into a single scene.
"""

# ╔═╡ 55187168-1c78-11eb-1182-ab4336b577a4
philip = Photon([3, 0], normalize([.5,-1]), 1.0)

# ╔═╡ 2158a356-1a05-11eb-3f5b-4dfa810fc602
ex_1_scene = [box_scene..., test_wall]

# ╔═╡ 87a8e280-1c7c-11eb-2bb0-034011f6c10f
md"""
When we shoot a photon at the scene, we compute the intersections between the photon and every object in the scene. Click on the vector below to see all elements:
"""

# ╔═╡ 4d69c36a-1c73-11eb-3ae3-23900db09c27
md"""
There are two misses and three intersections. Just what we hoped!
"""

# ╔═╡ 5342430e-1c79-11eb-261c-15abd0f8cfc1
md"""
So which of these **five** results should we use to determine what the photon does next? It should be the _closest intersection_.

Because we used two different types for hits and misses, we can express this in a charming way. We define what it means for one to be better than the other:
"""

# ╔═╡ 6c37c5f4-1a09-11eb-08ae-9dce752f29cb
begin
	Base.isless(a::Miss, b::Miss) = false
	Base.isless(a::Miss, b::Intersection) = false
	Base.isless(a::Intersection, b::Miss) = true
	Base.isless(a::Intersection, b::Intersection) = a.distance < b.distance
end

# ╔═╡ 052dc502-1c7a-11eb-2316-d3a1eef2af94
md"""
And we can now use all of Julia's built in functions to work with a vector of hit/miss results. For example, we can **sort** it:
"""

# ╔═╡ 55f475a8-1c7a-11eb-377e-91d07fa0bdb6
md"""
And we can take the **minimum**:
"""

# ╔═╡ 6cf7df1a-1c7a-11eb-230b-df1333f191c7
md"""
> Note that we did not define the `sort` and `minimum` methods ourselves! We only added methods for `Base.isless`.

By taking the minimum, we have found our closest hit! Let's turn this into a function. 

👉 Write a function `closest_hit` that takes a `photon` and a vector of objects. Calculate the vector of `Intersection`s/`Miss`es, and return the `minimum`.
"""

# ╔═╡ 19cf420e-1c7c-11eb-1cb8-dd939fee1276
function closest_hit(photon::Photon, objects::Vector{<:Object})
	
	return missing
end

# ╔═╡ b8cd4112-1c7c-11eb-3b2d-29170ad9beb5
test_closest = closest_hit(philip, ex_1_scene)

# ╔═╡ e9c6a0b8-1ad0-11eb-1606-0319caf0948a
md"""
 $(html"<br><br><br><br>")
## **Exercise 2:** _Mirrors_
"""

# ╔═╡ 522e6b22-194d-11eb-167c-052e65f6b703
md"""
Now we're going to make a bold claim: All walls in this simulation are mirrors. This is just for simplicity so we don't need to worry about rays stopping at the boundaries.

We are already able to find the intersection of a light ray with a mirror, but we still need to tell our friendly computer what a _reflection_ is.
"""

# ╔═╡ dad5acfa-194c-11eb-27f9-01f40342a681
md"
#### Exercise 2.1 - _reflect_

For this one, we need to implement a reflection function. This one is way easier than refraction. All we need to do is find how much of the light is moving in the direction of the surface's normal and subtract that twice.

$\ell_2 = \ell_1 - 2(\ell_1\cdot \hat n)\hat n$

Where $\ell_1$ and $\ell_2$ are the photon directions before and after the reflection off a surface with normal ``\hat{n}``. Let's write that in code:
"

# ╔═╡ 43306bd4-194d-11eb-2e30-07eabb8b29ef
reflect(ℓ₁::Vector, n̂::Vector)::Vector = ℓ₁ - 2 * dot(ℓ₁, n̂) * n̂

# ╔═╡ 70b8401e-1c7e-11eb-16b2-d54d8f66d71a
md"""
👉 Verify that the function `reflect` works by writing a simple test case:
"""

# ╔═╡ 79532662-1c7e-11eb-2edf-57e7cfbc1eda


# ╔═╡ b6614d80-194b-11eb-1edb-dba3c29672f8
md"""
#### Exercise 2.2 - _step_

Our event-driven simulation is a stepping method, but instead of taking small steps in time, we take large steps from one collision event to the next.

👉 Write a function `interact` that takes a photon and a `hit::Intersection{Wall}` and returns a new `Photon` at the next step. The new photon is located at the hit point, its direction is reflected off the wall's normal and the `photon.ior` is reused.
"""

# ╔═╡ 2c6defd0-1ca1-11eb-17db-d5cb498f3265
function interact(photon::Photon, hit::Intersection{Wall})
	
	return missing
end

# ╔═╡ 3f727a2c-1c80-11eb-3608-e55ccb9786d9
md"""
For convenience, we define a function `step_ray` that combines these two actions: it finds the closest hit and computes the interaction.
"""

# ╔═╡ a45e1012-194d-11eb-3252-bb89daed3c8d
md"
Great! Next, we will repeat this action to trace the path of a photon. 
"

# ╔═╡ 7ba5dda0-1ad1-11eb-1c4e-2391c11f54b3
md"""
#### Exercise 2.3 - _accumulate_

👉 Write a function `trace` that takes an initial `Photon`, a vector of `Object`s and `N`, the number of steps to make. Return a vector of `Photon`s. Try to use `accumulate`.
"""

# ╔═╡ 1a43b70c-1ca3-11eb-12a5-a94ebbba0e86
function trace(photon::Photon, scene::Vector{<:Object}, N)
	
	return missing
end

# ╔═╡ 3cd36ac0-1a09-11eb-1818-75b36e67594a
@bind mirror_test_ray_N Slider(1:30; default=4)

# ╔═╡ 7478330a-1c81-11eb-2f9f-099f1111032c
md"""
#### Recap
In Exercise 3 and 4, we will add a `Sphere` type, and our scene will consist of `Wall`s (mirrors) and `Sphere`s (lenses). But before we move on, let's review what we have done so far.

Our main character is a `Photon`, which bounces around a scene made up of `Wall`s. 

1. Using `intersection(photon, wall::Wall)` we can find either an `Intersection` (containing the `wall`, the `distance` and the `point`) or a `Miss`.
2. Our scene is just a `Vector` or objects, and we compute the intersection between the photon and every object.
3. By adding `Base.isless` methods we have told Julia how to compare hit/miss results, and we get the closest one using `minimum(all_intersections)`.
4. We wrote a function `interact(photon, hit::Intersection{Wall})` that returns a new photon after interacting with a wall collision.

We repeat these four steps to trace a ray through the scene.

---

In the next two exercises we will reuse some of the functionality that we have already written, using multiple dispatch! For example, we add a method `intersection(photon, sphere::Sphere)`, and steps 2 and 3 magically also work with spheres!


"""
# We have a type `Photon` and a type `Wall`, and u

# ╔═╡ ba0a869a-1ad1-11eb-091f-916e9151f052
md"""
 $(html"<br><br><br><br>")

## **Exercise 3:** _Spheres_
Now that we know how to bounce light around mirrors, we want to simulate a _spherical lens_ to make things more interesting. Let's define a `Sphere`. 
"""

# ╔═╡ 3aa539ce-193f-11eb-2a0f-bbc6b83528b7
struct Sphere <: Object
	# Position
	center::Vector{Float64}
	
	# Radius
	radius::Real
	
	# Index of refraction
	ior::Real
end

# ╔═╡ caa98732-19cd-11eb-04ce-2f018275cf01
function plot_object!(p::Plots.Plot, sphere::Sphere)
	points = [
		sphere.center .+ sphere.radius .* [cos(ϕ), sin(ϕ)]
		for ϕ in LinRange(0,2π,50)
	]
	
	plot!(p, points .|> first, points .|> last, seriestype=:shape, label="Sphere", fillopacity=0.2)
	p
end

# ╔═╡ eff9329e-1a05-11eb-261f-734127d36750
function plot_scene(objects::Vector{<:Object}; kwargs...)
	p = plot(aspect_ratio=:equal; kwargs...)
	
	for o in objects
		plot_object!(p, o)
	end
	p
end

# ╔═╡ e45e1d36-1a12-11eb-2720-294c4be6e9fd
plot_scene([test_wall], size=(400,200))

# ╔═╡ 0393dd3a-1a06-11eb-18a9-494ae7a26bc0
plot_scene(box_scene, legend=false, size=(400,200))

# ╔═╡ 76d4351c-1c78-11eb-243f-5f6f5e485d5d
let
	p = plot_scene(box_scene, legend=false, size=(400,200))
	plot_photon_arrow!(p, test_photon, 7)
	p
end

# ╔═╡ 5501a700-19ec-11eb-0ded-53e41f7f821a
let
	p = plot_scene(ex_1_scene, legend=false, size=(400,200))
	plot_photon_arrow!(p, philip, 5)
end

# ╔═╡ a99c40bc-1c7c-11eb-036b-7fe6e9b937e5
let
	p = plot_scene(ex_1_scene)
	
	plot_photon_arrow!(p, philip, 4; label="Philip")
	
	scatter!(p, test_closest.point[1:1], test_closest.point[2:2], label="Closest hit")
	
	p |> as_svg
end

# ╔═╡ 1ee0787e-1a08-11eb-233b-43a654f70117
let
	p = plot_scene(ex_1_scene, legend=false, xlim=(-11,11), ylim=(-11,11))
	
	path = trace(philip, ex_1_scene, mirror_test_ray_N)
	
	
	line = [philip.p, [r.p for r in path]...]
	plot!(p, first.(line), last.(line), lw=5, color=:pink)
	
	plot_photon_arrow!(p, philip)
	plot_photon_arrow!.([p], path)
	
	p
end |> as_svg

# ╔═╡ e5c0e960-19cc-11eb-107d-39b397a783ab
example_sphere = Sphere(
	[7, -6],
	2,
	1.5,
)

# ╔═╡ 2a2b7284-1ade-11eb-3b71-d17fe2ca638a
plot_scene([example_sphere], size=(400,200), legend=false, xlim=(-15,15), ylim=(-10,10))

# ╔═╡ e2a8d1d6-1add-11eb-0da1-cda1492a950c
md"
#### Exercise 3.1
Just like with the `Wall`, our first step is to be able to find the intersection point of a ray of light and a sphere.

This one is a bit more challenging than the intersction with the wall, in particular because there are 3 potential outcomes of a line interacting with a sphere:
- No intersection
- 1 intersection
- 2 intersections

As shown below:
"

# ╔═╡ 337918f4-194f-11eb-0b45-b13fef3b23bf
PlutoUI.Resource("https://upload.wikimedia.org/wikipedia/commons/6/67/Line-Sphere_Intersection_Cropped.png")

# ╔═╡ 492b257a-194f-11eb-17fb-f770b4d3da2e
md"""
So we need a way of finding all of these.

To start, let's look at the intersection of a **point** and a sphere. So long as the relative distance between the photon and the sphere's center satisfies the sphere equation, we can be considered inside of the sphere. More specifically, we are inside the sphere if:

$(x_s-x_p)^2+(y_s-y_p) < r^2.$

where the $s$ and $p$ subscripts represent the sphere and photon, respectively. We know we are *on* the sphere if

$(x_s-x_p)^2+(y_s-y_p) = r^2.$

Let's rewrite this in vector notation as:

$(\mathbf{R} - \mathbf{S})\cdot(\mathbf{R} - \mathbf{S}) = r^2,$

where $\mathbf{R}$ and $\mathbf{S}$ are the $x$, $y$, and $z$ location of the photon and sphere, respectively.

Returning to the timestepping example from above, we know that our ray is moving forward with time such that $\mathbf{R} = \mathbf{R}_0 + v dt = \mathbf{R}_0 + \ell t$. We now need to ask ourselves if there is any time when our ray interacts with the sphere. Plugging this in to the dot product from above, we get

$(\mathbf{R}_0 + \ell t - \mathbf{S})\cdot(\mathbf{R}_0 + \ell t - \mathbf{S}) = r^2$

To solve this for $t$, we first need to reorder everything into the form of a polynomial, such that:

$t^2(\ell\cdot\ell)+2t\ell\cdot(\mathbf{R_0}-\mathbf{S})+(\mathbf{R}_0-\mathbf{S})\cdot(\mathbf{R}_0-\mathbf{S}) - r^2=0.$

This can be solved with the good ol' fashioned quadratic equation:

$\frac{-b\pm\sqrt{b^2-4ac}}{2a},$

where $a = \ell\cdot\ell$, $b = 2\ell\cdot(\mathbf{R}_0-\mathbf{S})$, and $c=(\mathbf{R}_0-\mathbf{S})\cdot(\mathbf{R}_0-\mathbf{S}) - r^2$

If the quadratic equation returns no roots, there is no intersection. If it returns 1 root, the ray just barely hits the edge of the sphere. If it returns 2 roots, it goes right through!

The easiest way to check this is by looking at the discriminant $d = b^2-4ac$.

```math
\text{Number of roots} = \left\{
    \begin{align}
       &0, \qquad \text{if } d < 0 \\
       &1, \qquad \text{if } d = 0 \\
       &2, \qquad \text{if } d > 0 \\
    \end{align}
\right.
```

In the case that there are 2 roots, the second root corresponds to when the ray would interact with the far edge of the sphere *if there were no refraction or reflection!*; therefore, we only care about returning the closest point.

With all this said, we are ready to write some code.

👉 Write a new method `intersection` that takes a `Photon` and a `Sphere`, and returns either a `Miss` or an `Intersection`, using the method described above. Go back to Exercise 1.3 where we defined the first method, and see how we adapt it to a sphere.
"""

# ╔═╡ 392fe192-1ca1-11eb-36c4-f9bd2b01a5e5
function intersection(photon::Photon, sphere::Sphere; ϵ=1e-3)
	
	return missing
end

# ╔═╡ a306e880-19eb-11eb-0ff1-d7ef49777f63
test_intersection = intersection(dizzy, test_wall)

# ╔═╡ 3663bf80-1a06-11eb-3596-8fbbed28cc38
let
	p = plot_scene([test_wall])
	plot_photon_arrow!(p, dizzy, 4; label="Philip")
	
	try
		scatter!(p, test_intersection.point[1:1], test_intersection.point[2:2], label="Intersection point")
	catch
	end
	
	p
end

# ╔═╡ 1b0c0e4c-1c73-11eb-225d-23c731455755
all_intersections = [intersection(philip, o) for o in ex_1_scene]

# ╔═╡ e055262c-1c73-11eb-14de-2f537a19b012
let
	p = plot_scene(ex_1_scene)
	
	plot_photon_arrow!(p, philip, 4; label="Philip")
	for (i,hit) in enumerate(all_intersections)
		if hit isa Intersection
			scatter!(p, hit.point[1:1], hit.point[2:2], label="intersection $i")
		end
	end
	p |> as_svg
end

# ╔═╡ c3090e4a-1a09-11eb-0f32-d3bbfd9992e0
sort(all_intersections)

# ╔═╡ 63ef21c6-1c7a-11eb-2f3c-c5ac16bc289f
minimum(all_intersections)

# ╔═╡ af5c6bea-1c9c-11eb-35ae-250337e4fc86
test_sphere = Sphere(
	[7, -6],
	2,
	1.5,
)

# ╔═╡ 251f0262-1a0c-11eb-39a3-09be67091dc8
sphere_intersection = intersection(philip, test_sphere)

# ╔═╡ b3ab93d2-1a0b-11eb-0f5a-cdca19af3d89
ex_3_scene = [test_sphere, box_scene...]

# ╔═╡ 83aa9cea-1a0c-11eb-281d-699665da2b4f
let
	p = plot_scene(ex_3_scene)
	
	plot_photon_arrow!(p, philip, 4; label="Philip")
	if sphere_intersection isa Intersection
		scatter!(p, sphere_intersection.point[1:1], sphere_intersection.point[2:2], label="Intersection point")
	end
	
	p |> as_svg
end

# ╔═╡ 71dc652e-1c9c-11eb-396c-cfd9ee2261fe
md"""
👉 Change the definition of `test_sphere` to test different situations:
- Hit the circle
- Miss the circle
- Start inside the cricle (you should hit the exit boundary)
"""

# ╔═╡ 584ce620-1935-11eb-177a-f75d9ad8a399
md"""
 $(html"<br><br><br><br>")
## **Exercise 4:** _Lenses_

For this, we will start with refraction from the surface of water and then move on to a spherical lens. 

So, how does refraction work? Well, every time light enters a new medium that is more dense than air, it will bend towards the normal to the surface, like so:

$(RemoteResource("https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Snells_law2.svg/800px-Snells_law2.svg.png", :width=>200, :style=>"display: block; margin: auto;"))
"""

# ╔═╡ 78915326-1937-11eb-014f-fff29b3660a0
md"""
This can be described by Snell's law:

$\frac{n_1}{n_2} = \frac{v_2}{v_1} = \frac{\sin(\theta_2)}{\sin(\theta_1)}$

Here, $n$ is the index of refraction, $v$ is the speed (not velocity (sorry for the notation!)), and $\theta$ is the angle with respect to the surface normal. Any variables with an subscript of 1 are in the outer medium (air), and any variables with a subscript 2 are in the inner medium (water).

This means that we can find the angle of the new ray of light as

$\sin(\theta_2) = \frac{n_1}{n_2}\sin(\theta_1)$

The problem is that $\sin$ is slow, so we typically want to rewrite this in terms of vector operations. This means that we want to rewrite everything to be in terms of dot products, but because $A\cdot B = |A||B|cos(\theta)$, we really want to rewrite everything in terms of cosines first. So, using the fact that $\sin(\theta)^2 + \cos(\theta)^2 = 1$, we can rewrite the above equation to be:

$\sin(\theta_2) = \frac{n_1}{n_2}\sqrt{1-\cos(\theta_1)^2}$

We also know that 

$\cos(\theta_2) = \sqrt{1-\sin(\theta_2)^2} = \sqrt{1-\left(\frac{n_1}{n_2}\right)^2\left(1-\cos(\theta_1)^2\right)}.$

Finally, we know that the new light direction should be the same as the old one, but shifted towards (or away) from the normal according to the new refractive index.
In particular:

$n_2 \ell _2 = {n_1} \ell _1 + (n_1\cos(\theta_1)-n_2\cos(\theta_2))\hat n,$

where $\hat n$ is the normal from the water's surface. Rewriting this, we find:

$\ell _2 = \left(\frac{n_1}{n_2}\right) \ell _1 + \left(\left(\frac{n_1}{n_2}\right)\cos(\theta_1)-\cos(\theta_2)\right)\hat n.$

Now, we already know $\cos(\theta_2)$ in terms of $\cos(\theta_1)$, so we can just plug that in... But first, let's do some simplifications, such that 

$r = \frac{n_1}{n_2}$

and

$c = -\hat n \cdot \ell_1.$

Now, we can rewrite everything such that

$\ell_2 = r\ell_1 + \left(rc-\sqrt{1-r^2(1-c^2)}\right)\hat n.$

The last step is to write this in code with a function that takes the light direction, the normal, and old and new indices of refraction:
"""

# ╔═╡ 14dc73d2-1a0d-11eb-1a3c-0f793e74da9b
function refract(
		ℓ₁::Vector, n̂::Vector,
		old_ior, new_ior
	)
	
	r = old_ior / new_ior
	
	n̂_oriented = if -dot(ℓ₁, n̂) < 0
		-n̂
	else
		n̂
	end
	
	c = -dot(ℓ₁, n̂_oriented)
	
	normalize(r * ℓ₁ + (r*c - sqrt(1 - r^2 * (1 - c^2))) * n̂_oriented)
end

# ╔═╡ 71b70da6-193e-11eb-0bc4-f309d24fd4ef
md"

Now to move on to lenses. Like in lecture, we will focus exclusively on spherical lenses. Ultimately, there isn't a big difference between a lens and a spherical drop of water. It just has a slightly different refractive index and it's normal is defined slightly differently.
"

# ╔═╡ 54b81de0-193f-11eb-004d-f90ec43588f8
md"""
We need a helper functions to find the normal of the sphere's surface at any position. Remember that the normal will always be pointing perpendicularly from the surface of the sphere. This means that no matter what point you are at, the normal will just be a normalized vector of your current location minus the sphere's position:
"""

# ╔═╡ 6fdf613c-193f-11eb-0029-957541d2ed4d
function sphere_normal_at(p::Vector{Float64}, s::Sphere)
	normalize(p - s.center)
end

# ╔═╡ 392c25b8-1add-11eb-225d-49cfca27bef4
md"""
👉 Write a new method for `interact` that takes a `photon` and a `hit` of type `Intersection{Sphere}`, that implements refraction. It returns a new `Photon` positioned at the hit point, with the refracted velocity and the new index of refraction.
"""

# ╔═╡ 427747d6-1ca1-11eb-28ae-ff50728c84fe
function interact(photon::Photon, hit::Intersection{Sphere})
	
	return missing
end

# ╔═╡ 0b03316c-1c80-11eb-347c-1b5c9a0ae379
test_new_photon = interact(philip, test_closest)

# ╔═╡ fb70cc0c-1c7f-11eb-31b5-87b168a66e19
let
	p = plot_scene(ex_1_scene)
	
	plot_photon_arrow!(p, philip, 4; label="Philip")	
	plot_photon_arrow!(p, test_new_photon, 4; label="Philip after interaction")
	
	p |> as_svg
end

# ╔═╡ 76ef6e46-1a06-11eb-03e3-9f40a86dc9aa
function step_ray(photon::Photon, objects::Vector{<:Object})
	hit = closest_hit(photon, objects)
	
	interact(photon, hit)
end

# ╔═╡ dced1fd0-1c9e-11eb-3226-17dc1e09e018
md"""
To test your code, modify the definition of `test_lens_photon` and `test_lens` below.
"""

# ╔═╡ 65aec4fc-1c9e-11eb-1c5a-6dd7c533d3b8
test_lens_photon = Photon([0,0], [1,0], 1.0)

# ╔═╡ 5895d9ae-1c9e-11eb-2f4e-671f2a7a0150
test_lens = Sphere(
	[5, -1.5],
	3,
	1.5,
	)

# ╔═╡ 83acf10e-1c9e-11eb-3426-bb28e7bc6c79
let
	scene = [test_lens, box_scene...]
	N = 3
	
	p = plot_scene(scene, legend=false, xlim=(-11,11), ylim=(-11,11))
	
	path = accumulate(1:N; init=test_lens_photon) do old_photon, i
		step_ray(old_photon, scene)
	end
	
	line = [test_lens_photon.p, [r.p for r in path]...]
	plot!(p, first.(line), last.(line), lw=5, color=:red)
	
	p
end |> as_svg

# ╔═╡ 13fef49c-1c9e-11eb-2aa3-d3aa2bfd0d57
md"""
By defining a method for `interact` that takes a sphere intersection, we are now able to use the machinery developed in Exercise 2 to simulate a scene with both lenses and mirrors. Let's try it out!
"""

# ╔═╡ c492a1f8-1a0c-11eb-2c38-5921c39cf5f8
@bind sphere_test_ray_N Slider(1:30; default=4)

# ╔═╡ b65d9a0c-1a0c-11eb-3cd5-e5a2c4302c7e
let
	scene = [test_lens, box_scene...]
	p = plot_scene(scene, legend=false, xlim=(-11,11), ylim=(-11,11))
	
	path = accumulate(1:sphere_test_ray_N; init=test_lens_photon) do old_photon, i
		step_ray(old_photon, scene)
	end
	
	line = [test_lens_photon.p, [r.p for r in path]...]
	plot!(p, first.(line), last.(line), lw=5, color=:red)
	
	p
end |> as_svg

# ╔═╡ c00eb0a6-cab2-11ea-3887-070ebd8d56e2
md"
#### Spherical aberration
Now we can put it all together into an image of spherical aberration!
"

# ╔═╡ 3dd0a48c-1ca3-11eb-1127-e7c43b5d1666
md"""
👉 Recreate the spherical aberration figure from [the lecture](https://www.youtube.com/watch?v=MkkZb5V6HqM) (around the end of the video), and make the index of refraction interactive using a `Slider`. _Or make something else!_
"""

# ╔═╡ 270762e4-1ca4-11eb-2fb4-392e5c3b3e04


# ╔═╡ bbf730c8-1ca6-11eb-3bb0-1188046339ac
md"""
## **Exercise XX:** _Lecture transcript_
(MIT students only)
Please see the link for hw 7 transcript document on [Canvas](https://canvas.mit.edu/courses/5637).
We want each of you to correct about 500 lines, but don’t spend more than 20 minutes on it.
See the the beginning of the document for more instructions.

👉 Please mention the name of the video(s) and the line ranges you edited:
"""

# ╔═╡ cbd8f164-1ca6-11eb-1440-bdaabf73a6c7
lines_i_edited = md"""
Abstraction, lines 1-219; Array Basics, lines 1-137; Course Intro, lines 1-144 (_for example_)
"""

# ╔═╡ ebd05bf0-19c3-11eb-2559-7d0745a84025
if student.name == "Jazzy Doe" || student.kerberos_id == "jazz"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ ec275590-19c3-11eb-23d0-cb3d9f62ba92
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ ec31dce0-19c3-11eb-1487-23cc20cd5277
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ ad5a7420-1c7f-11eb-042f-115a9ef4c676
hint(md"`Intersection` contains the intersected object, so you can retrieve the wall using `hit.object`, and the normal using `hit.object.normal`.")

# ╔═╡ c25caf08-1a13-11eb-3c4d-0567faf4e662
md"""
You can use `ray.ior == 1.0` to check whether this is a ray _entering_ or _leaving_ the sphere.
""" |> hint

# ╔═╡ ec3ed530-19c3-11eb-10bb-a55e77550d1f
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ec4abc12-19c3-11eb-1ca4-b5e9d3cd100b
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ec57b460-19c3-11eb-2142-07cf28dcf02b
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ ec5d59b0-19c3-11eb-0206-cbd1a5415c28
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ ec698eb0-19c3-11eb-340a-e319abb8ebb5
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 0e9a240c-1ac5-11eb-1a7e-b3c43c459484
let
	if length(box_scene) != 4
		keep_working()
	elseif !(box_scene isa Vector{Wall})
		keep_working(md"`box_scene` should be a Vector of `Wall` objects.")
	else
		w = last(box_scene)
		
		if w.position != [0,10]
			keep_working(md"The wall's position is not correct.")
		elseif w.normal != [0,-1]
			keep_working(md"The wall's direction is not correct.")
		else
			correct()
		end
	end
end

# ╔═╡ 0787f130-1aca-11eb-24b4-2ff2ddd0bc48
let
	p = Photon([5,0], [1,0], 1.0)
	w = Wall([10,10], normalize([-1,-1]))
	
	result = intersection_distance(p, w)
	
	
	if result isa Missing
		still_missing()
	elseif !(result isa Real)
		keep_working(md"You need to return a number.")
	else
		if abs(result - (20 - 5)) > 0.1
			if abs(-result - (20 - 5)) > 0.1
				keep_working(md"The returned distance is not correct.")
			else
				keep_working(md"Did you forget the minus sign?")
			end
		else
			correct()
		end
	end
end

# ╔═╡ 038d5e88-1ac7-11eb-2020-a9d7e19feebc
let
	p = Photon([5,0], [1,0], 1.0)
	w = Wall([10,10], normalize([-1,-1]))
	
	result = intersection(p, w)
	
	
	if result isa Missing
		still_missing()
	elseif !(result isa Miss || result isa Intersection)
		keep_working(md"You need to return a `Miss` or a `Intersection`.")
	else
		if result isa Miss
			keep_working(md"You returned a `Miss` for a photon that hit the wall.")
		else
			if abs(result.distance - (20 - 5)) > 0.1
				keep_working(md"The returned distance is not correct.")
			else
				p = Photon([5,0], [-1,0], 1.0)
				result = intersection(p, w)
				
				if !(result isa Miss)
					almost(md"What should happen when ``D < 0``?")
				else
					p = Photon([10,10], [1,0], 1.0)
					w = Wall([10,10], normalize([-1,-1]))
					
					result = intersection(p, w)
					if result isa Miss
						correct()
					else
						almost(md"Remember to use ``\epsilon``.")
					end
				end
			end
		end
	end
end

# ╔═╡ ec7638e0-19c3-11eb-1ca1-0b3aa3b40240
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ ec85c940-19c3-11eb-3375-a90735beaec1
TODO = html"<span style='display: inline; font-size: 2em; color: purple; font-weight: 900;'>TODO</span>"

# ╔═╡ 8cfa4902-1ad3-11eb-03a1-736898ff9cef
TODO_note(text) = Markdown.MD(Markdown.Admonition("warning", "TODO note", [text]))

# ╔═╡ Cell order:
# ╟─1df32310-19c4-11eb-0824-6766cd21aaf4
# ╟─1df82c20-19c4-11eb-0959-8543a0d5630d
# ╟─1e01c912-19c4-11eb-269a-9796cccdf274
# ╟─1e109620-19c4-11eb-013e-1bc95c14c2ba
# ╟─1e202680-19c4-11eb-29a7-99061b886b3c
# ╟─1e2cd0b0-19c4-11eb-3583-0b82092139aa
# ╠═c3e52bf2-ca9a-11ea-13aa-03a4335f2906
# ╟─92290e54-1940-11eb-1a24-5d1eaee9f6ca
# ╠═d851a202-1ca0-11eb-3da0-51fcb656783c
# ╠═99c61b74-1941-11eb-2323-2bdb7c120a28
# ╠═0906b340-19d3-11eb-112c-e568f69deb5d
# ╠═e45e1d36-1a12-11eb-2720-294c4be6e9fd
# ╟─6de1bafc-1a01-11eb-3d67-c9d9b6c3cea8
# ╟─eff9329e-1a05-11eb-261f-734127d36750
# ╟─5f551588-1ac4-11eb-1f86-197442f1ef1d
# ╠═ac9bafaa-1ac4-11eb-16c4-0df8133f9c98
# ╠═0393dd3a-1a06-11eb-18a9-494ae7a26bc0
# ╟─293776f8-1ac4-11eb-21db-9d023c09e89f
# ╟─0e9a240c-1ac5-11eb-1a7e-b3c43c459484
# ╟─e5ed6098-1c70-11eb-0b58-31d1830b9a10
# ╠═24b0d4ba-192c-11eb-0f66-e77b544b0510
# ╠═925e98d4-1c78-11eb-230d-994518f0060e
# ╟─76d4351c-1c78-11eb-243f-5f6f5e485d5d
# ╟─eabca8ce-1c73-11eb-26ad-271f6eba889b
# ╟─aa43ef1c-1941-11eb-04de-552719a08da0
# ╠═8acef4b0-1a09-11eb-068d-79a259244ed1
# ╠═8018fbf0-1a05-11eb-3032-95aae07ca78f
# ╟─e9c5d68c-1ac2-11eb-04ec-3b72eb133239
# ╠═5a9d00f6-1ac3-11eb-01fb-53c35796e766
# ╟─5aa7c4e8-1ac3-11eb-23f3-03bd58e75c4b
# ╠═9df1d0f2-1ac3-11eb-0eac-d90eccca669c
# ╠═bc10541e-1ac3-11eb-0b5f-916922f1a8e8
# ╟─d39f149e-1ac3-11eb-39a2-41c2030d7d49
# ╟─e135d490-1ac2-11eb-053e-914051f16e31
# ╠═abe3de54-1ca0-11eb-01cd-11fe798bfb97
# ╟─0787f130-1aca-11eb-24b4-2ff2ddd0bc48
# ╟─42d65f56-1aca-11eb-1079-e32f85554349
# ╠═a5847264-1ca0-11eb-0b45-eb5388f6e688
# ╟─038d5e88-1ac7-11eb-2020-a9d7e19feebc
# ╟─6544be90-19d3-11eb-153c-218025f738c6
# ╠═a306e880-19eb-11eb-0ff1-d7ef49777f63
# ╟─3663bf80-1a06-11eb-3596-8fbbed28cc38
# ╟─7f286ccc-1c75-11eb-1270-95a87840b300
# ╟─d70380a4-1ad0-11eb-1184-f7e9b84a83ad
# ╠═55187168-1c78-11eb-1182-ab4336b577a4
# ╟─2158a356-1a05-11eb-3f5b-4dfa810fc602
# ╠═5501a700-19ec-11eb-0ded-53e41f7f821a
# ╟─87a8e280-1c7c-11eb-2bb0-034011f6c10f
# ╠═1b0c0e4c-1c73-11eb-225d-23c731455755
# ╟─4d69c36a-1c73-11eb-3ae3-23900db09c27
# ╟─e055262c-1c73-11eb-14de-2f537a19b012
# ╟─5342430e-1c79-11eb-261c-15abd0f8cfc1
# ╠═6c37c5f4-1a09-11eb-08ae-9dce752f29cb
# ╟─052dc502-1c7a-11eb-2316-d3a1eef2af94
# ╠═c3090e4a-1a09-11eb-0f32-d3bbfd9992e0
# ╟─55f475a8-1c7a-11eb-377e-91d07fa0bdb6
# ╠═63ef21c6-1c7a-11eb-2f3c-c5ac16bc289f
# ╟─6cf7df1a-1c7a-11eb-230b-df1333f191c7
# ╠═19cf420e-1c7c-11eb-1cb8-dd939fee1276
# ╠═b8cd4112-1c7c-11eb-3b2d-29170ad9beb5
# ╟─a99c40bc-1c7c-11eb-036b-7fe6e9b937e5
# ╟─e9c6a0b8-1ad0-11eb-1606-0319caf0948a
# ╟─522e6b22-194d-11eb-167c-052e65f6b703
# ╟─dad5acfa-194c-11eb-27f9-01f40342a681
# ╠═43306bd4-194d-11eb-2e30-07eabb8b29ef
# ╟─70b8401e-1c7e-11eb-16b2-d54d8f66d71a
# ╠═79532662-1c7e-11eb-2edf-57e7cfbc1eda
# ╟─b6614d80-194b-11eb-1edb-dba3c29672f8
# ╠═2c6defd0-1ca1-11eb-17db-d5cb498f3265
# ╟─ad5a7420-1c7f-11eb-042f-115a9ef4c676
# ╠═0b03316c-1c80-11eb-347c-1b5c9a0ae379
# ╟─fb70cc0c-1c7f-11eb-31b5-87b168a66e19
# ╟─3f727a2c-1c80-11eb-3608-e55ccb9786d9
# ╠═76ef6e46-1a06-11eb-03e3-9f40a86dc9aa
# ╟─a45e1012-194d-11eb-3252-bb89daed3c8d
# ╟─7ba5dda0-1ad1-11eb-1c4e-2391c11f54b3
# ╠═1a43b70c-1ca3-11eb-12a5-a94ebbba0e86
# ╟─3cd36ac0-1a09-11eb-1818-75b36e67594a
# ╟─1ee0787e-1a08-11eb-233b-43a654f70117
# ╟─7478330a-1c81-11eb-2f9f-099f1111032c
# ╟─ba0a869a-1ad1-11eb-091f-916e9151f052
# ╠═3aa539ce-193f-11eb-2a0f-bbc6b83528b7
# ╟─caa98732-19cd-11eb-04ce-2f018275cf01
# ╠═e5c0e960-19cc-11eb-107d-39b397a783ab
# ╠═2a2b7284-1ade-11eb-3b71-d17fe2ca638a
# ╟─e2a8d1d6-1add-11eb-0da1-cda1492a950c
# ╟─337918f4-194f-11eb-0b45-b13fef3b23bf
# ╟─492b257a-194f-11eb-17fb-f770b4d3da2e
# ╠═392fe192-1ca1-11eb-36c4-f9bd2b01a5e5
# ╠═251f0262-1a0c-11eb-39a3-09be67091dc8
# ╟─83aa9cea-1a0c-11eb-281d-699665da2b4f
# ╠═af5c6bea-1c9c-11eb-35ae-250337e4fc86
# ╠═b3ab93d2-1a0b-11eb-0f5a-cdca19af3d89
# ╟─71dc652e-1c9c-11eb-396c-cfd9ee2261fe
# ╟─584ce620-1935-11eb-177a-f75d9ad8a399
# ╟─78915326-1937-11eb-014f-fff29b3660a0
# ╠═14dc73d2-1a0d-11eb-1a3c-0f793e74da9b
# ╠═71b70da6-193e-11eb-0bc4-f309d24fd4ef
# ╟─54b81de0-193f-11eb-004d-f90ec43588f8
# ╠═6fdf613c-193f-11eb-0029-957541d2ed4d
# ╟─392c25b8-1add-11eb-225d-49cfca27bef4
# ╟─c25caf08-1a13-11eb-3c4d-0567faf4e662
# ╠═427747d6-1ca1-11eb-28ae-ff50728c84fe
# ╟─dced1fd0-1c9e-11eb-3226-17dc1e09e018
# ╠═65aec4fc-1c9e-11eb-1c5a-6dd7c533d3b8
# ╠═5895d9ae-1c9e-11eb-2f4e-671f2a7a0150
# ╟─83acf10e-1c9e-11eb-3426-bb28e7bc6c79
# ╟─13fef49c-1c9e-11eb-2aa3-d3aa2bfd0d57
# ╟─c492a1f8-1a0c-11eb-2c38-5921c39cf5f8
# ╟─b65d9a0c-1a0c-11eb-3cd5-e5a2c4302c7e
# ╟─c00eb0a6-cab2-11ea-3887-070ebd8d56e2
# ╟─3dd0a48c-1ca3-11eb-1127-e7c43b5d1666
# ╠═270762e4-1ca4-11eb-2fb4-392e5c3b3e04
# ╟─bbf730c8-1ca6-11eb-3bb0-1188046339ac
# ╠═cbd8f164-1ca6-11eb-1440-bdaabf73a6c7
# ╟─ebd05bf0-19c3-11eb-2559-7d0745a84025
# ╟─ec275590-19c3-11eb-23d0-cb3d9f62ba92
# ╟─ec31dce0-19c3-11eb-1487-23cc20cd5277
# ╟─ec3ed530-19c3-11eb-10bb-a55e77550d1f
# ╟─ec4abc12-19c3-11eb-1ca4-b5e9d3cd100b
# ╟─ec57b460-19c3-11eb-2142-07cf28dcf02b
# ╟─ec5d59b0-19c3-11eb-0206-cbd1a5415c28
# ╠═ec698eb0-19c3-11eb-340a-e319abb8ebb5
# ╟─ec7638e0-19c3-11eb-1ca1-0b3aa3b40240
# ╟─ec85c940-19c3-11eb-3375-a90735beaec1
# ╠═8cfa4902-1ad3-11eb-03a1-736898ff9cef
