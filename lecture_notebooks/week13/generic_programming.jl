### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ 5206373c-3382-11eb-017f-7fff90b7110d
md"""
# Generic programming
"""

# ╔═╡ 5d9abdc0-3382-11eb-07d6-dd876e5a4870
md"""
Let's think about random walks again. Suppose we want to calculate the trajectory (path in time) of a random walker that starts at $0$, lives on the integers, and jumps left or right with probability $\frac{1}{2}$ at each time step.

We would probably write something like the following functions:

"""

# ╔═╡ 4bad5b46-33f9-11eb-320a-9f8854cc4b39
jump() = rand( (-1, +1) )

# ╔═╡ 8c21d08e-3382-11eb-165b-716c2ba5e3fc
function trajectory1D(T)
	
	x = 0
	traj = [x]  # array containing only `x`
	
	for t in 1:T
		x += jump()
		push!(traj, x)
	end
	
	return traj
end

# ╔═╡ abe4b4b8-3382-11eb-2b49-d5fc6f2853bd
md"""
Let's test that it works:
"""

# ╔═╡ b4a4aee6-3382-11eb-355e-433e589c9eea
trajectory1D(20)

# ╔═╡ b9ad4842-3382-11eb-196b-b97826045ab8
md"""
What about if we want a walker in 2D? We could copy and paste the function as follows, and then modify it appropriately:
"""

# ╔═╡ cfc793e6-3382-11eb-3243-cb3219b8f49d
function trajectory2D(T)
	x = 0
	y = 0
	trajx = [x]
	trajy = [y]
	
	for t in 1:T
		x += jump()
		y += jump()

		push!(trajx, x)
		push!(trajy, y)
	end
	
	return trajx, trajy
end

# ╔═╡ e23c0fae-3382-11eb-13a4-7f0770fcfe7a
md"""
Now suppose we also want a walker in 3D. More copying and pasting.

Now suppose that we want to modify the functions so that they can take an optional argument representing the starting position. We would have to go and modify each of the three different versions of the function.

What if we wanted to modify them so that they can jump in different directions with different probabilities. Or have behaviour that depends on the history of how it previously moved, for example be more likely to continue in the same direction (a so-called **persistent** or **correlated** random walk).  

Each modification seems to require us to write a new version of the code with basically the same structure, but changing the details, and changing at least 3 versions of the same code, which easily leads to making mistakes that are hard to spot. And it seems like it's a waste of our (humans') time -- can't the computer do this repetitive work for us?
"""

# ╔═╡ 61f2be26-3383-11eb-08d9-dfe4478d078d
md"""
## Abstraction
"""

# ╔═╡ 654116ae-3383-11eb-3395-696c0375995e
md"""
Since all the versions of the code have, in some sense, the *same structure*, we would like to identify that structure and make an *abstraction*. 

Let's go back and look at how we stated the problem in English: we have a "walker" and we want to "calculate its trajectory". We want to make abstractions corresponding to these two ideas. 

A "walker" is a thing or object -- i.e. a *noun* -- which  we can model, or represent, by defining a `struct`, which makes a new *type*.
Different *kinds of* walkers will correspond to defining different `struct`s, and hence *different types*. However, each of those types should somehow "have the same behaviour".

On the other hand, "calculate its trajectory" is an *action*, or *verb*, which we can model using a *function*.

"""

# ╔═╡ 278cf9bc-3384-11eb-263e-0ff23adef74d
md"""
### Analysing the verb
"""

# ╔═╡ 32d8ee98-3384-11eb-0648-09b1883c1b5f
md"""
Let's go back to the code for the 1D walker and try to isolate the properties that a walker needs and the actions that we are doing to it. We will do so by breaking out each action into a separate function:
"""

# ╔═╡ 7d4fb2a4-3384-11eb-34cc-01285c739aa5
md"""
We see that the walker needs an initial position, and a way to move:
"""

# ╔═╡ 859545e0-3385-11eb-3987-2f0c78b5205a
initial_position() = 0

# ╔═╡ 9040d7ca-3385-11eb-37ef-2d06cf3a9b3d
move(x) = x + jump()

# ╔═╡ db45d640-3384-11eb-3785-7bea0ed1aa50
md"""
Look carefully at the new version of the function `trajectory`. Its purpose now is basically to do the book-keeping of tracking the walker's position and storing it in the array `traj`. The details of how the walker is initialised and how it moves are delegated to the functions `initialise` and `move`.
"""

# ╔═╡ 3a2d67fe-3385-11eb-3ef7-ed88685c3a96
md"""
Now suppose we wanted a 2D walker instead. What would we need to do? We would somehow need to *replace* `initialise` and `move` by the following 2D versions:
"""

# ╔═╡ 4e8df2fe-3385-11eb-3643-35d100050c1d
initialise_2D() = (0, 0)

# ╔═╡ afeea12e-3385-11eb-0d8e-19133de42190
move_2D( (x, y) ) = (x + jump(), y + jump() )

# ╔═╡ b1ed1346-3385-11eb-364c-e3996b751d9c
md"""
But we don't want to overwrite the previous functions -- we might want 1D and 2D walkers.

Instead we would like to say to the `trajectory` function "use these functions instead of `initialise` and `move`. In other words, we should *pass them as parameters to the function*!:
"""

# ╔═╡ d79a98ae-3385-11eb-115b-d13654c1db88
function trajectory(T, initialise, move)
	
	x = initialise()

	traj = [x]  

	for t in 1:T
		x = move(x)
		push!(traj, x)
	end

	return traj
end

# ╔═╡ edd4c720-3385-11eb-2ffb-f5dedf50afcf
md"""
This is an example of **generic programming**: `trajectory` has suddenly become a *completely general* function that can calculate trajectories of "anything that behaves like a walker". And "behaving like a walker" corresponds to "having an `initialise` function and a `move` function.
"""

# ╔═╡ 171f93a8-3386-11eb-1e77-3d92d55550af
md"""
**Exercise**: For example, make a "walker" that computes the powers of two starting at $2^0$ = 1, by defining suitable `initialise` and `move` functions.
"""

# ╔═╡ 43bc9008-3386-11eb-1962-335824a8658d
md"""
## Analysing the nouns: Types
"""

# ╔═╡ 51eee9ac-3386-11eb-1ffd-5b68e238be13
md"""
In the above versions of the code, we have succeeded in making an abstraction for the verb "calculate a trajectory". But we haven't succeeded in making an abstraction for the noun "walker"; a walker has a position, but it's somehow implicit in the `initialise` function that we define.

Let's try to make it more explicit by defining `struct`s, i.e. user-defined types, and functions that act on them:


"""

# ╔═╡ dde97a8a-3386-11eb-26fc-191702a1f89b
struct Walker1D
	x::Int
end

# ╔═╡ 16ed3c4a-3387-11eb-1472-33c9ee79bd1f
move(w::Walker1D) = Walker1D( w.x + jump() )

# ╔═╡ 51dfa586-3387-11eb-0be7-0799094b9b2e
w = Walker1D(0)

# ╔═╡ 839c8b68-3387-11eb-072c-9942530f5e72
md"""
Now we can do the same in 2D, by defining a new type `Walker2D` and writing a **new method** of the *same* function `move`, that now acts on objects of type `Walker2D`:
"""

# ╔═╡ 9e16d7b2-3387-11eb-2322-b1f34a2af40a
struct Walker2D
	x::Int
	y::Int
end

# ╔═╡ a592d89c-3387-11eb-010b-5f70c9d46b28
move(w::Walker2D) = Walker2D( w.x + jump(), w.y + jump() )

# ╔═╡ 5413d69a-3384-11eb-3eaf-b97ae12d6f00
function trajectory(T)
	x = initial_position()

	traj = [x]

	for t in 1:T
		x = move(x)
		push!(traj, x)
	end

	return traj
end

# ╔═╡ 1c632810-3387-11eb-30e7-6ddebeca4a6f
function trajectory(T, w)   

	traj = [w]

	for t in 1:T
		w = move(w)
		push!(traj, w)
	end

	return traj
end

# ╔═╡ c1007ae2-3384-11eb-3463-457afe255045
trajectory(20)

# ╔═╡ ddb4f4a0-3385-11eb-3a9b-41af81da8f08
trajectory(20, initial_position, move)  # uses 1D functions defined previously

# ╔═╡ e7a42abe-3385-11eb-10c0-4f635dd24be2
trajectory(20, initialise_2D, move_2D)  # uses 2D functions defined previously

# ╔═╡ 676a5f40-3387-11eb-1c0a-89416df52e62
trajectory(20, w)

# ╔═╡ cddc7e66-3387-11eb-01b8-5707d56b09e5
w2 = Walker2D(3, 4)

# ╔═╡ cb0ea68c-3387-11eb-28b2-0f64dca334cc
trajectory(20, w2)

# ╔═╡ e60c7450-3387-11eb-0c86-b598fa05ad74
md"""
**Exercise**: How could you write a walker in $n$ dimensions? What data structure could you use for the walker's position? A good solution for this is the [`StaticArrays` package](https://github.com/JuliaArrays/StaticArrays.jl).
"""

# ╔═╡ Cell order:
# ╟─5206373c-3382-11eb-017f-7fff90b7110d
# ╟─5d9abdc0-3382-11eb-07d6-dd876e5a4870
# ╠═4bad5b46-33f9-11eb-320a-9f8854cc4b39
# ╠═8c21d08e-3382-11eb-165b-716c2ba5e3fc
# ╟─abe4b4b8-3382-11eb-2b49-d5fc6f2853bd
# ╠═b4a4aee6-3382-11eb-355e-433e589c9eea
# ╟─b9ad4842-3382-11eb-196b-b97826045ab8
# ╠═cfc793e6-3382-11eb-3243-cb3219b8f49d
# ╟─e23c0fae-3382-11eb-13a4-7f0770fcfe7a
# ╟─61f2be26-3383-11eb-08d9-dfe4478d078d
# ╟─654116ae-3383-11eb-3395-696c0375995e
# ╟─278cf9bc-3384-11eb-263e-0ff23adef74d
# ╟─32d8ee98-3384-11eb-0648-09b1883c1b5f
# ╟─7d4fb2a4-3384-11eb-34cc-01285c739aa5
# ╠═859545e0-3385-11eb-3987-2f0c78b5205a
# ╠═9040d7ca-3385-11eb-37ef-2d06cf3a9b3d
# ╠═5413d69a-3384-11eb-3eaf-b97ae12d6f00
# ╠═c1007ae2-3384-11eb-3463-457afe255045
# ╟─db45d640-3384-11eb-3785-7bea0ed1aa50
# ╟─3a2d67fe-3385-11eb-3ef7-ed88685c3a96
# ╠═4e8df2fe-3385-11eb-3643-35d100050c1d
# ╠═afeea12e-3385-11eb-0d8e-19133de42190
# ╟─b1ed1346-3385-11eb-364c-e3996b751d9c
# ╠═d79a98ae-3385-11eb-115b-d13654c1db88
# ╠═ddb4f4a0-3385-11eb-3a9b-41af81da8f08
# ╠═e7a42abe-3385-11eb-10c0-4f635dd24be2
# ╟─edd4c720-3385-11eb-2ffb-f5dedf50afcf
# ╟─171f93a8-3386-11eb-1e77-3d92d55550af
# ╟─43bc9008-3386-11eb-1962-335824a8658d
# ╟─51eee9ac-3386-11eb-1ffd-5b68e238be13
# ╠═dde97a8a-3386-11eb-26fc-191702a1f89b
# ╠═16ed3c4a-3387-11eb-1472-33c9ee79bd1f
# ╠═1c632810-3387-11eb-30e7-6ddebeca4a6f
# ╠═51dfa586-3387-11eb-0be7-0799094b9b2e
# ╠═676a5f40-3387-11eb-1c0a-89416df52e62
# ╟─839c8b68-3387-11eb-072c-9942530f5e72
# ╠═9e16d7b2-3387-11eb-2322-b1f34a2af40a
# ╠═a592d89c-3387-11eb-010b-5f70c9d46b28
# ╠═cddc7e66-3387-11eb-01b8-5707d56b09e5
# ╠═cb0ea68c-3387-11eb-28b2-0f64dca334cc
# ╟─e60c7450-3387-11eb-0c86-b598fa05ad74
