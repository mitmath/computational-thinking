### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

# ╔═╡ 330763c4-f1e2-11ea-071a-b13a3bea37e9
md"# Arrays: Slices and views"

# ╔═╡ 50e2aaa2-f1e2-11ea-37b2-9d23357ab558
md"Since arrays are a very common way of storing data (but by no means the only way!), it is important to know how to manipulate them."

# ╔═╡ 614126a8-f1e2-11ea-08ef-3d787d155416
md"Suppose we start with a vector (1-dimensional array) of all ones:"

# ╔═╡ 6d6e5194-f1e2-11ea-116c-c191e52dd2af
v = ones(Int, 10)

# ╔═╡ 79332324-f1e2-11ea-3c82-39cad3d2391c
md"""We can **index** into the array to extract a certain element using square brackets ("`[`" and "`]`"):"""

# ╔═╡ 8b0fca3e-f1e2-11ea-2b70-011aaeeb94cc
v[3]

# ╔═╡ 8cbf61b6-f1e2-11ea-3b49-cb59792e1fc1
md"And we can modify that element using the same syntax:"

# ╔═╡ a87a0238-f1e2-11ea-272d-0d8cd4795df6
v[3] = 2

# ╔═╡ abbf2a72-f1e2-11ea-3e76-2bbe6e068c59
v

# ╔═╡ b0bafcae-f1e2-11ea-1c5a-a98c25cf6bd4
md"If we want to extract a subset of the array, we can do so by indexing using a **range**:"

# ╔═╡ c8ec70ac-f1e2-11ea-30d6-7fc4e1f3cf63
v[3:5]

# ╔═╡ d6903d5e-f1e2-11ea-1525-35f7f6aa2f66
md"We call this a **slice** of the array."

# ╔═╡ 7c447b7a-f1e3-11ea-0ef2-c996690ae871
md"## Modifying a slice: Broadcasting"

# ╔═╡ cd2c8f1a-f1e2-11ea-1449-73d40f742c60
md"How can we *modify* this slice, say to replace them all by the value 4? Intuitively you might expect to be able to write"

# ╔═╡ edec3322-f1e2-11ea-32b8-ebd1445b18e2
v[3:5] = 4

# ╔═╡ 0ed6e116-f1e3-11ea-38ed-693262492cf2
md"""
But Julia does *not* allow this. The problem is that the two objects on the two sides of the assignment are different types: an array on the left, and a number on the right. What we want to do is modify the array *element by element*; for this we need to **broadcast** the assignment using "`.`":
"""

# ╔═╡ 446a93ba-f1e3-11ea-2957-e9c3bb7b66cd
v[3:5] .= 4

# ╔═╡ 4974c36c-f1e3-11ea-3543-63fce86af871
md"Let's check if this modified the original array:"

# ╔═╡ 86be1e4e-f1e3-11ea-1212-6949dd55b8e8
v

# ╔═╡ 887640e0-f1e3-11ea-2d35-a9a9d1ae1897
md"Success!"

# ╔═╡ 8d6fdcfa-f1e3-11ea-2f50-9783f4cd6339
md"Following the above idea, if we provide a new array of the correct length, we can also modify the array:"

# ╔═╡ 9b504332-f1e3-11ea-35a2-8d33db468a83
v[3:5] = [5, 6, 7]

# ╔═╡ a1685124-f1e3-11ea-396c-cd12b8cdfdbd
v

# ╔═╡ b6e74bf4-f1e3-11ea-1eab-7db865915fe8
md"## Array slices"

# ╔═╡ c1562b4e-f1e3-11ea-2b73-0d18fc361323
md"Now suppose we give a name to that array slice:"

# ╔═╡ d69da0d8-f1e3-11ea-092b-7b7e9fd262ce
w = v[3:5]

# ╔═╡ afbeb970-f1e3-11ea-3658-c973f6808f6d
md"An important question is the following: 

> *What happens if we modify `w`*?

Take a moment to think about this before carrying on. What do you expect to happen? What are the possibilities?
"

# ╔═╡ fc774f0c-f1e3-11ea-0e5a-3141ec04348d
md"(Seriously, think about it!)"

# ╔═╡ ffa05138-f1e3-11ea-280e-bf7da83de269
md"Of course, after thinking about it we should ask Julia what actually happens!"

# ╔═╡ 12dbdf38-f1e4-11ea-0449-b39ed2f5f12d
md"Here's the current situation:"

# ╔═╡ 1123aade-f1e4-11ea-3cce-4534d7a72a60
w

# ╔═╡ 19ca7c32-f1e4-11ea-39a5-3dcf97e6fbcf
md"Now let's change the first element of `w`:"

# ╔═╡ 21a48678-f1e4-11ea-1143-c709ee295e0d
w[1] = 8

# ╔═╡ 25abc85a-f1e4-11ea-156b-7f15f0474e3b
w

# ╔═╡ 2765efc0-f1e4-11ea-1324-ede5df51f047
md"As expected, we modified `w`'s first element. But what happened to `v`?"

# ╔═╡ 3eb46116-f1e4-11ea-29e9-c74e8478d803
v

# ╔═╡ 4084ffca-f1e4-11ea-2d5d-abb022cd41cc
md"We see that *`v` did not get modified!* This is surprising to many people.

What is going on?"

# ╔═╡ 59e92208-f1e4-11ea-30a0-4d6d44bb9ae6
md"What is happening is that the slice syntax `v[3:5]` actually creates a *copy* of the data in a new place in memory. Then `w` is a label, or pointer, for that new piece of memory. So modifying it does not touch the original values at all!

We should be aware of this whenever we are tempted to modify slices."

# ╔═╡ aa48f298-f1e4-11ea-19ef-f120e959faa4
md"## Array views"

# ╔═╡ addcc056-f1e4-11ea-0090-eb82f5545c37
md"Of course, there are times when we do *not* want to make a copy. We might want to give a name to a slice of an array and manipulate the *original* array using the new name.

To do so we need to make a **view** of the array. This is literally like a window that allows us to view (read and write) to the *same data*.

To do this we use the `view` function:
"

# ╔═╡ f5cc5e80-f1e4-11ea-027c-9bef1852423d
z = view(v, 3:5)

# ╔═╡ 218aa662-f1e5-11ea-1516-15ffd9c9ba08
md"Now what happens if we modify `z` element by element using broadcasting?"

# ╔═╡ 2b955ddc-f1e5-11ea-1ca1-e91c81100478
z .= 9

# ╔═╡ 3a957e84-f1e5-11ea-2131-21fdd5d8c5d5
z

# ╔═╡ 3c96558c-f1e5-11ea-2109-79717714c977
md"`z` changed as we expected. But what about the original vector `v`?"

# ╔═╡ 4ed5d79a-f1e5-11ea-1515-3be1b3fa9a2b
v

# ╔═╡ 50259ee6-f1e5-11ea-317b-11a542b6cd9e
md"`v` also changed! This confirms that `z` is a window onto the same underlying data stored inside the block of memory labelled with the name `v`."

# ╔═╡ ff65101a-f1e4-11ea-1b51-f5b09ae1f0eb
md"Let's compare the types of `w` and `z`:"

# ╔═╡ fbd656aa-f1e4-11ea-2de2-61abc56ea71d
typeof(w), typeof(z)

# ╔═╡ 0ab7d32e-f1e5-11ea-048b-a74d7515b0c5
md"We see that they are of similar, but different types. `w` looks like other arrays we have seen, but `z` is a new type, called a `SubArray`."

# ╔═╡ 781e93da-f1e5-11ea-3d3f-57842f69c032
md"## Nicer syntax for views"

# ╔═╡ 83c8711a-f1e5-11ea-30c4-87104a7c1c2a
md"Now we know how to produce views / `SubArray`s. But to do so we had to move away from the nice, compact array slicing syntax, from `v[3:5]` to `view(v, 3:5)`. Could there be a way to combine the two?"

# ╔═╡ fb50b922-f1e5-11ea-0049-773084392b80
md"In fact there is: Julia provides a **macro** `@view` that converts the slicing syntax into a view:"

# ╔═╡ 0d25ffae-f1e6-11ea-05c4-49b25532ae49
z2 = @view v[3:5]

# ╔═╡ 27c47f2a-f1e6-11ea-3aa2-bb05fcd0e566
typeof(z2)

# ╔═╡ 2998132a-f1e6-11ea-3ccc-7951c392e9f3
z2 .= 10

# ╔═╡ 2c010994-f1e6-11ea-0022-79d21e0764b8
v

# ╔═╡ 2d6f84e2-f1e6-11ea-2683-8be3ea0d39ac
md"What is going on here? The macro `@view` literally takes the piece of Julia code `v[3:5]` and *replaces* it with the new piece of code `view(v, 3:5)`. Please see the separate video on macros for more detail!"

# ╔═╡ 4ff57544-f1e6-11ea-0274-15cc7917c3e3
md"Finally, there is also a macro `@views`, which replaces *all* slices by views in an entire expression."

# ╔═╡ ba6e586c-f1e8-11ea-1aba-ab1ba56ace6d
md"## Matrices: slices and views"

# ╔═╡ f0753bec-f1e8-11ea-0776-99b556737a05
md"Slices and views work the same way for matrices. For example, let's start with a matrix:"

# ╔═╡ cdf780b6-f1e8-11ea-2c90-bdae4d1dacaf
M = [10i + j for i in 0:5, j in 1:4]

# ╔═╡ 3464d66e-f1e9-11ea-0e53-e99f5c962594
md"We can make slices and views of matrices using extensions of the syntax we saw above for vectors:"

# ╔═╡ 4f3451e0-f1e9-11ea-07b4-456c5a6fa4c5
M[3:5, 1:2]

# ╔═╡ 5cb68536-f1e9-11ea-272e-179f8dfe8acc
view(M, 3:5, 1:2)

# ╔═╡ 615a74ee-f1e9-11ea-1f71-3be78c5545b2
@view M[3:5, 1:2]

# ╔═╡ 670bbc0e-f1e9-11ea-01a1-93cb78e8cb90
md"You should check that slices and views have the same behaviour that we described above."

# ╔═╡ 94c85c38-f1e9-11ea-3ab8-976569b36e23
md"## Reshaping matrices"

# ╔═╡ eb96a16a-f1e8-11ea-0398-1715aac5fb2d
md"There's something else we would like to be able to do with matrices: **reshape** them. We can do so using the `reshape` function:"

# ╔═╡ 24cefdea-f1e9-11ea-3c37-c3626e555e4e
M2 = reshape(M, 3, 8)

# ╔═╡ cae01608-f1e9-11ea-0878-a7b281aa6113
md"(Note the order in which the elements were taken.)"

# ╔═╡ 2b3cbb88-f1e9-11ea-16f1-436de44841de
md"Given the discussion so far, you are hopefully asking yourself: Is this a copy or a view? We'll leave it to you to find out!"

# ╔═╡ c36d3770-f1e9-11ea-2fa5-5ddb60c2adce
md"Similarly, we might want to turn the matrix into a vector. For this we can use the `vec` function:"

# ╔═╡ ecb7395a-f1e9-11ea-2346-abbd7f1bd73e
vv = vec(M)

# ╔═╡ f0eb9eaa-f1e9-11ea-1bd5-3f47ff24cbf6
md"Again you should check if this is a copy or a view. The order of the elements here is showing us the **storage order** of a matrix, i.e. in which order in the (linear) memory inside the computer the elements of the 2D matrix are being stored."

# ╔═╡ 648b17b6-f1e6-11ea-3351-23b46a2e265d
md"## Summary"

# ╔═╡ 689e4c60-f1e6-11ea-3782-43decd275b5f
md"In summary, we need to be aware of when we want to copy data from an array, and when we actually want to avoid copying and make views instead. A slice like `v[1:3]` makes a copy *unless* there's an `@view` or `@views` macro telling you otherwise.

For other operations like `reshape` and `vec` it's also critical to know if they make copies or views.
"

# ╔═╡ Cell order:
# ╟─330763c4-f1e2-11ea-071a-b13a3bea37e9
# ╟─50e2aaa2-f1e2-11ea-37b2-9d23357ab558
# ╟─614126a8-f1e2-11ea-08ef-3d787d155416
# ╠═6d6e5194-f1e2-11ea-116c-c191e52dd2af
# ╟─79332324-f1e2-11ea-3c82-39cad3d2391c
# ╠═8b0fca3e-f1e2-11ea-2b70-011aaeeb94cc
# ╟─8cbf61b6-f1e2-11ea-3b49-cb59792e1fc1
# ╠═a87a0238-f1e2-11ea-272d-0d8cd4795df6
# ╠═abbf2a72-f1e2-11ea-3e76-2bbe6e068c59
# ╟─b0bafcae-f1e2-11ea-1c5a-a98c25cf6bd4
# ╠═c8ec70ac-f1e2-11ea-30d6-7fc4e1f3cf63
# ╟─d6903d5e-f1e2-11ea-1525-35f7f6aa2f66
# ╟─7c447b7a-f1e3-11ea-0ef2-c996690ae871
# ╟─cd2c8f1a-f1e2-11ea-1449-73d40f742c60
# ╠═edec3322-f1e2-11ea-32b8-ebd1445b18e2
# ╟─0ed6e116-f1e3-11ea-38ed-693262492cf2
# ╠═446a93ba-f1e3-11ea-2957-e9c3bb7b66cd
# ╟─4974c36c-f1e3-11ea-3543-63fce86af871
# ╠═86be1e4e-f1e3-11ea-1212-6949dd55b8e8
# ╟─887640e0-f1e3-11ea-2d35-a9a9d1ae1897
# ╟─8d6fdcfa-f1e3-11ea-2f50-9783f4cd6339
# ╠═9b504332-f1e3-11ea-35a2-8d33db468a83
# ╠═a1685124-f1e3-11ea-396c-cd12b8cdfdbd
# ╟─b6e74bf4-f1e3-11ea-1eab-7db865915fe8
# ╟─c1562b4e-f1e3-11ea-2b73-0d18fc361323
# ╠═d69da0d8-f1e3-11ea-092b-7b7e9fd262ce
# ╟─afbeb970-f1e3-11ea-3658-c973f6808f6d
# ╟─fc774f0c-f1e3-11ea-0e5a-3141ec04348d
# ╟─ffa05138-f1e3-11ea-280e-bf7da83de269
# ╟─12dbdf38-f1e4-11ea-0449-b39ed2f5f12d
# ╠═1123aade-f1e4-11ea-3cce-4534d7a72a60
# ╟─19ca7c32-f1e4-11ea-39a5-3dcf97e6fbcf
# ╠═21a48678-f1e4-11ea-1143-c709ee295e0d
# ╠═25abc85a-f1e4-11ea-156b-7f15f0474e3b
# ╟─2765efc0-f1e4-11ea-1324-ede5df51f047
# ╠═3eb46116-f1e4-11ea-29e9-c74e8478d803
# ╟─4084ffca-f1e4-11ea-2d5d-abb022cd41cc
# ╟─59e92208-f1e4-11ea-30a0-4d6d44bb9ae6
# ╟─aa48f298-f1e4-11ea-19ef-f120e959faa4
# ╟─addcc056-f1e4-11ea-0090-eb82f5545c37
# ╠═f5cc5e80-f1e4-11ea-027c-9bef1852423d
# ╟─218aa662-f1e5-11ea-1516-15ffd9c9ba08
# ╠═2b955ddc-f1e5-11ea-1ca1-e91c81100478
# ╠═3a957e84-f1e5-11ea-2131-21fdd5d8c5d5
# ╟─3c96558c-f1e5-11ea-2109-79717714c977
# ╠═4ed5d79a-f1e5-11ea-1515-3be1b3fa9a2b
# ╟─50259ee6-f1e5-11ea-317b-11a542b6cd9e
# ╟─ff65101a-f1e4-11ea-1b51-f5b09ae1f0eb
# ╠═fbd656aa-f1e4-11ea-2de2-61abc56ea71d
# ╟─0ab7d32e-f1e5-11ea-048b-a74d7515b0c5
# ╟─781e93da-f1e5-11ea-3d3f-57842f69c032
# ╟─83c8711a-f1e5-11ea-30c4-87104a7c1c2a
# ╟─fb50b922-f1e5-11ea-0049-773084392b80
# ╠═0d25ffae-f1e6-11ea-05c4-49b25532ae49
# ╠═27c47f2a-f1e6-11ea-3aa2-bb05fcd0e566
# ╠═2998132a-f1e6-11ea-3ccc-7951c392e9f3
# ╠═2c010994-f1e6-11ea-0022-79d21e0764b8
# ╟─2d6f84e2-f1e6-11ea-2683-8be3ea0d39ac
# ╟─4ff57544-f1e6-11ea-0274-15cc7917c3e3
# ╟─ba6e586c-f1e8-11ea-1aba-ab1ba56ace6d
# ╟─f0753bec-f1e8-11ea-0776-99b556737a05
# ╠═cdf780b6-f1e8-11ea-2c90-bdae4d1dacaf
# ╟─3464d66e-f1e9-11ea-0e53-e99f5c962594
# ╠═4f3451e0-f1e9-11ea-07b4-456c5a6fa4c5
# ╠═5cb68536-f1e9-11ea-272e-179f8dfe8acc
# ╠═615a74ee-f1e9-11ea-1f71-3be78c5545b2
# ╟─670bbc0e-f1e9-11ea-01a1-93cb78e8cb90
# ╟─94c85c38-f1e9-11ea-3ab8-976569b36e23
# ╟─eb96a16a-f1e8-11ea-0398-1715aac5fb2d
# ╠═24cefdea-f1e9-11ea-3c37-c3626e555e4e
# ╟─cae01608-f1e9-11ea-0878-a7b281aa6113
# ╟─2b3cbb88-f1e9-11ea-16f1-436de44841de
# ╟─c36d3770-f1e9-11ea-2fa5-5ddb60c2adce
# ╠═ecb7395a-f1e9-11ea-2346-abbd7f1bd73e
# ╟─f0eb9eaa-f1e9-11ea-1bd5-3f47ff24cbf6
# ╟─648b17b6-f1e6-11ea-3351-23b46a2e265d
# ╟─689e4c60-f1e6-11ea-3782-43decd275b5f
