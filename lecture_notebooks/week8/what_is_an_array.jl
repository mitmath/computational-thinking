### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ e1a3f480-12e7-11eb-01db-71003ec47f08
md"""
## What *is* an array, actually?

We have seen several examples of arrays. 
When you think about an array, you probably think of a chain of boxes with the same shape, stored one after the other, consecutively in memory. And indeed this is the original meaning of the word "array".

However, as a user, we don't actually care about how the data is actually stored! All we really care about is the functionality of an array. Namely, we want the following properties:

- Elements have an integer index (from 1 to `n`);
- An element at position `i` can be accessed using the syntax `A[i]`;
- An element at position `i` can be stored using `A[i] = i` (if the array is mutable)
- We should be able to see the size of an array.
"""

# ╔═╡ 51a660b4-12f3-11eb-2b8a-f5544e650b1c
md"""
Julia provides an **abstraction** of an array called `AbstractArray`. We can define new types of array that "behave like" arrays but are stored differently.
"""

# ╔═╡ 853ac7d0-12f3-11eb-1b1c-993e336cf23a
md"""
## How does indexing work?
"""

# ╔═╡ 94bb1e6c-12f3-11eb-2e18-bb232d2c9cfe
md"""
First let's think about indexing, which is really the key operation on an array.
Let's define a vector:
"""

# ╔═╡ 314ba27a-12ec-11eb-12ce-67650c0020b7
arr = [34,45,67]

# ╔═╡ ab3afe6e-12f3-11eb-196a-79d26b66f681
md"""
We know that we can index into it using square brackets:
"""

# ╔═╡ b32acfda-12f3-11eb-323d-ef91b9ff9f0d
arr[2]

# ╔═╡ b53bc5ba-12f3-11eb-2b09-d38cc266b069
md"""
This is just syntax? What is actually going on? We can see this by looking at the **lowered** form:
"""

# ╔═╡ 3a202684-12ec-11eb-26fc-df7b7484e671
Meta.@lower arr[2]

# ╔═╡ c225d324-12f3-11eb-23d7-45548e7b32b6
md"""
We see that `arr[2]` is just "syntactic sugar" for calling the `getindex` function as `getindex(arr, 2)`; in other words, it's just a nice short and suggestive way to write the same thing.
"""

# ╔═╡ d92c5aa2-12f3-11eb-286e-8769ecdf03cb
md"""
So to implement our own objects that behave like arrays, we will define a new type and extend `getindex` on that type. 
"""

# ╔═╡ f10cf87a-12f3-11eb-1104-0186b9e43757
md"""
## Example: A zero-based vector
"""

# ╔═╡ f7cadd08-12f3-11eb-1882-8dd4ce8ee2c2
md"""
There are interminable discussions online about whether zero-based indexing (i.e. array indices starting at 0) or one-based indexing (starting at 1) is superior. The answer is that *neither* is -- each is more suitable in different contexts.

Fortunately Julia is flexible enough to allow you to use *any* type of indexing that suits you -- see e.g. the `OffsetArrays.jl` package.

Let's see how to implement the simplest case, namely a zero-based vector.

So we define a new type and extend `getindex` on it. In order to use the full Julia machinery we need to extend a couple of other functions too:
"""

# ╔═╡ 1ac0095e-12eb-11eb-3df2-e98d0ff66dd5
struct ZeroFirstVector{T} <: AbstractVector{T}
	array::Vector{T}
end

# ╔═╡ a66afe14-12eb-11eb-3afc-fdac2325ff84
Base.size(vec::ZeroFirstVector) = size(vec.array)

# ╔═╡ e86c53fa-12eb-11eb-0ee4-41455a218d84
Base.axes(vec::ZeroFirstVector) = (0:length(vec.array)-1,)

# ╔═╡ 69b10842-12eb-11eb-381a-0bda698a59ed
Base.getindex(vec::ZeroFirstVector, i::Int) = vec.array[i+1]

# ╔═╡ 9c57e4aa-12eb-11eb-16fb-c7a18c238192
zarr = ZeroFirstVector([1, 3, 4])

# ╔═╡ 3cf51826-12f4-11eb-2405-db9616fa3152
md"""
Now we are able to use zero-based indexing!:
"""

# ╔═╡ fed5e2e4-12eb-11eb-169f-8b050f9eea4a
zarr[0]

# ╔═╡ 464c22f2-12f4-11eb-0b3c-872621c385f6
md"""
## Modifying elements: `setindex!`
"""

# ╔═╡ 4dec992e-12f4-11eb-1f20-b96632769bed
md"""
In a similar way to `getindex`, modifying elements of an array uses the mutating function `setindex!`:
"""

# ╔═╡ 5b8f3508-12ec-11eb-0a31-61ddf796ac74
Meta.@lower arr[2] = 3

# ╔═╡ 0c8ebad2-12ec-11eb-03f1-c5b9c79bb4da
Base.setindex!(vec::ZeroFirstVector, val, i::Int) = (vec.array[i+1] = val)

# ╔═╡ 8438424c-12ec-11eb-1de2-0bb3924ec78c
zarr[0] = 55

# ╔═╡ 9cee3206-12ec-11eb-09c7-1f0ebad11b8e
zarr

# ╔═╡ b0ab2844-12ec-11eb-1908-0318510b3292
md"""
### Julia gives you added bonuses here:
"""

# ╔═╡ bc8154b8-12ec-11eb-1fcc-4765fcd0796d
zarr[0:1]

# ╔═╡ 8c0c8188-12f4-11eb-1576-23958903a69a
@which zarr[0:1]

# ╔═╡ 7425ef6e-12f4-11eb-21c3-19c221c1ebdb
md"""
We never defined how to index using a *range*, only an integer. Julia has a generic fallback mechanism that understands how to do this once you have implemented `getindex` for a single element.

Similarly:
"""

# ╔═╡ c67fbbbc-12ec-11eb-32be-2ff720964fe6
zarr[ [2, 1, 0] ]

# ╔═╡ d13a65b6-12ec-11eb-2996-37987cfae782
zarr[0:1] .= [7,8];

# ╔═╡ dbb95f42-12ec-11eb-01d5-df2e21affd86
zarr

# ╔═╡ e6428aa6-12ec-11eb-06d0-95404a8a4039
zarr[ [2, 1, 0] ] .= [1, 2, 3];

# ╔═╡ e21658ec-12ef-11eb-06fd-b1d282edf7b6
zarr

# ╔═╡ b405b9ac-12f4-11eb-12fa-f7575ff1fa73
md"""
Various other functions also automatically work, e.g.:
"""

# ╔═╡ e57329a2-12ef-11eb-165d-51f080c73652
sort!(zarr)

# ╔═╡ e8b34188-12ef-11eb-2d7f-fde100b582d1
md"""
### Some more examples

"""

# ╔═╡ bd6bfd10-12f4-11eb-17fe-6f9ce83f0ce8
md"""
We have already seen some other examples of array types in the course, e.g. ranges:
"""

# ╔═╡ f0d952da-12ef-11eb-2452-471b184bc529
r = 53:83

# ╔═╡ 0fc7e3e6-12f0-11eb-1b49-e37196154ec6
size(r)

# ╔═╡ 03b23fe0-12f0-11eb-0970-33b3b973e902
r[20]

# ╔═╡ 00088cda-12f0-11eb-36b7-9b900fa6d0bf
typeof(r)

# ╔═╡ f6024924-12ef-11eb-1d6c-3ffff2546914
supertypes(typeof(r))

# ╔═╡ cdf3e532-12f4-11eb-1ce0-873bcf0dea58
md"""
Let's also look at what happens if we reshape an array:
"""

# ╔═╡ f9bf5200-12ef-11eb-30ee-9b3cbbccc886
A = reshape(1:12, 3, 4)

# ╔═╡ 07c1cdb6-12f1-11eb-0b31-15b5c88caac6
typeof(A)

# ╔═╡ 09d69238-12f1-11eb-1d9f-f72e8c6c14d9
supertypes(typeof(A))

# ╔═╡ ff598e1c-12f0-11eb-24f6-bdaa74db2ad7
size(A)

# ╔═╡ 2f23dd4e-12f0-11eb-01fc-53f66d2a55e4
Aᵀ = transpose(A)

# ╔═╡ ea8e0794-12f0-11eb-2194-bdc46224dc69
size(Aᵀ)

# ╔═╡ 2a76a87a-12f1-11eb-3e58-e5f919ba81e8
@which Aᵀ[2,3]

# ╔═╡ 892e7c40-12f0-11eb-2871-0d308063f025
md"The `getindex` method for `Transpose` is defined [here](https://github.com/JuliaLang/julia/blob/master/stdlib/LinearAlgebra/src/adjtrans.jl#L190)"

# ╔═╡ da41895c-12f4-11eb-2ee4-f1ffc4344f61
md"""
## Conclusions
"""

# ╔═╡ dfac92ea-12f4-11eb-1253-b74be632de64
md"""
Summarising, we see that we -- and Julia -- can think of an array as "anything that behaves like an array", i.e. which you can index into.

What does it mean for something to behave like an array? In the end it means that we *could* "materialise" it to produce an actual array that did live as data stored linearly in memory, and our program would behave in exactly the same way.

But Julia provides a mechanism by which we can store less data, or store it in a more convenient way, and have indexing be almost as efficient.
"""

# ╔═╡ Cell order:
# ╟─e1a3f480-12e7-11eb-01db-71003ec47f08
# ╟─51a660b4-12f3-11eb-2b8a-f5544e650b1c
# ╟─853ac7d0-12f3-11eb-1b1c-993e336cf23a
# ╟─94bb1e6c-12f3-11eb-2e18-bb232d2c9cfe
# ╠═314ba27a-12ec-11eb-12ce-67650c0020b7
# ╟─ab3afe6e-12f3-11eb-196a-79d26b66f681
# ╠═b32acfda-12f3-11eb-323d-ef91b9ff9f0d
# ╟─b53bc5ba-12f3-11eb-2b09-d38cc266b069
# ╠═3a202684-12ec-11eb-26fc-df7b7484e671
# ╟─c225d324-12f3-11eb-23d7-45548e7b32b6
# ╟─d92c5aa2-12f3-11eb-286e-8769ecdf03cb
# ╟─f10cf87a-12f3-11eb-1104-0186b9e43757
# ╟─f7cadd08-12f3-11eb-1882-8dd4ce8ee2c2
# ╠═1ac0095e-12eb-11eb-3df2-e98d0ff66dd5
# ╠═a66afe14-12eb-11eb-3afc-fdac2325ff84
# ╠═e86c53fa-12eb-11eb-0ee4-41455a218d84
# ╠═69b10842-12eb-11eb-381a-0bda698a59ed
# ╠═9c57e4aa-12eb-11eb-16fb-c7a18c238192
# ╟─3cf51826-12f4-11eb-2405-db9616fa3152
# ╠═fed5e2e4-12eb-11eb-169f-8b050f9eea4a
# ╟─464c22f2-12f4-11eb-0b3c-872621c385f6
# ╟─4dec992e-12f4-11eb-1f20-b96632769bed
# ╠═5b8f3508-12ec-11eb-0a31-61ddf796ac74
# ╠═0c8ebad2-12ec-11eb-03f1-c5b9c79bb4da
# ╠═8438424c-12ec-11eb-1de2-0bb3924ec78c
# ╠═9cee3206-12ec-11eb-09c7-1f0ebad11b8e
# ╟─b0ab2844-12ec-11eb-1908-0318510b3292
# ╠═bc8154b8-12ec-11eb-1fcc-4765fcd0796d
# ╠═8c0c8188-12f4-11eb-1576-23958903a69a
# ╟─7425ef6e-12f4-11eb-21c3-19c221c1ebdb
# ╠═c67fbbbc-12ec-11eb-32be-2ff720964fe6
# ╠═d13a65b6-12ec-11eb-2996-37987cfae782
# ╠═dbb95f42-12ec-11eb-01d5-df2e21affd86
# ╠═e6428aa6-12ec-11eb-06d0-95404a8a4039
# ╠═e21658ec-12ef-11eb-06fd-b1d282edf7b6
# ╟─b405b9ac-12f4-11eb-12fa-f7575ff1fa73
# ╠═e57329a2-12ef-11eb-165d-51f080c73652
# ╟─e8b34188-12ef-11eb-2d7f-fde100b582d1
# ╟─bd6bfd10-12f4-11eb-17fe-6f9ce83f0ce8
# ╠═f0d952da-12ef-11eb-2452-471b184bc529
# ╠═0fc7e3e6-12f0-11eb-1b49-e37196154ec6
# ╠═03b23fe0-12f0-11eb-0970-33b3b973e902
# ╠═00088cda-12f0-11eb-36b7-9b900fa6d0bf
# ╠═f6024924-12ef-11eb-1d6c-3ffff2546914
# ╟─cdf3e532-12f4-11eb-1ce0-873bcf0dea58
# ╠═f9bf5200-12ef-11eb-30ee-9b3cbbccc886
# ╠═07c1cdb6-12f1-11eb-0b31-15b5c88caac6
# ╠═09d69238-12f1-11eb-1d9f-f72e8c6c14d9
# ╠═ff598e1c-12f0-11eb-24f6-bdaa74db2ad7
# ╠═2f23dd4e-12f0-11eb-01fc-53f66d2a55e4
# ╠═ea8e0794-12f0-11eb-2194-bdc46224dc69
# ╠═2a76a87a-12f1-11eb-3e58-e5f919ba81e8
# ╟─892e7c40-12f0-11eb-2871-0d308063f025
# ╟─da41895c-12f4-11eb-2ee4-f1ffc4344f61
# ╟─dfac92ea-12f4-11eb-1253-b74be632de64
