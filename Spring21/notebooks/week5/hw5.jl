### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 8c8388cf-9891-423c-8db2-d40d870bb38e
using PlutoUI

# ╔═╡ 54778212-3702-467d-8a96-4fa18b3ccd63
using LinearAlgebra

# ╔═╡ 6f4274b5-87e2-420d-83d2-83a8408650cd
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ ea28bf57-ba62-41ce-8be6-d38ca2c5caa3


# ╔═╡ 8efcaaeb-4900-404b-ae59-65db0bde8790


# ╔═╡ a5be0775-68de-41ce-95cd-1465723d099b


# ╔═╡ 4abec609-09cd-4f86-8d86-a7d02325cc7b


# ╔═╡ 32e073bb-943f-4fa9-b15f-5ec18feecf15


# ╔═╡ d221c61c-a4ab-4a82-b89d-52735d957cae


# ╔═╡ c3d49b98-a9c1-4aba-becc-7fa84f4bbc75


# ╔═╡ 7b33c09c-2ef2-4b97-b5a5-5fdf9268f76b


# ╔═╡ 615b88b6-8505-11eb-0a7c-294ee5ae7474
begin
	struct FirstRankOneMatrix
		# Your code here
		v::Vector{Float64}
		w::Vector{Float64}
	end
	
	# Add the extra constructor here
	FirstRankOneMatrix(v) = FirstRankOneMatrix(v, v)

end

# ╔═╡ b0db7388-850c-11eb-0915-597f1fa5ab93
ten_twelve = missing # Your code here

# ╔═╡ 2dfc2ef9-3efa-4b82-960f-f2ef0171e9eb
sqrt === Base.sqrt

# ╔═╡ d4a0baea-cc02-4d91-a938-8181dea7b47a
filter === Base.filter

# ╔═╡ 7adbcbab-66e7-4b58-b197-5c220ba1e9a2
# methods(size)

# ╔═╡ fada4734-8505-11eb-3f2b-d1f1ef391ba4
function Base.size(M::FirstRankOneMatrix)
	
	return missing # Your code here
end

# ╔═╡ 590dfe1a-8506-11eb-0069-d7cd91f02a65
function Base.getindex(M::FirstRankOneMatrix, i, j)
	
	return missing # Your code here
end

# ╔═╡ 941b6b10-8ae9-11eb-3bf8-b732f5f60af3
ten_twelve

# ╔═╡ a243a400-8af3-11eb-0637-cf8f80aae86d
ones(10, 12) # An example matrix (two-dimensional array)

# ╔═╡ c7a15c5e-8505-11eb-3af2-2fa84b74b590
function print_as_matrix(M::FirstRankOneMatrix)
	
	# Your code here
	
end

# ╔═╡ b0a0b9a4-850b-11eb-30f1-11f5270efe02
with_terminal() do
	print_as_matrix(ten_twelve)
end

# ╔═╡ b577420c-8501-11eb-267a-719125315fe1
begin
	struct RankOneMatrix{T} <: AbstractMatrix{T}
		v::AbstractVector{T}
		w::AbstractVector{T}
	end
	
	# Add the two extra constructors
	# (Should we make these missing by default? if so - remove hint below)
	RankOneMatrix(v) = RankOneMatrix(v, v)
end

# ╔═╡ eb612772-8b06-44bb-a36a-827435cbb2ee


# ╔═╡ d3e7c8d1-4b4a-47b6-9c96-150333078f42


# ╔═╡ f2d8b45c-8501-11eb-1c6a-5f819c240d9d
function Base.size(M::RankOneMatrix)
	
	return missing # Your code here
end

# ╔═╡ ed72e880-8afa-11eb-3a4a-175a838188d9
function Base.getindex(M::RankOneMatrix, i, j)
	
	return missing # Your code here
end

# ╔═╡ 7b3fb0ef-9a9e-401c-8c09-e5615134a4ad
R2 = RankOneMatrix([1,2], [3,4,5])

# ╔═╡ fc962c72-8501-11eb-2821-cbb7a52d5f61
M = RankOneMatrix(1:10) # missing # Your code here

# ╔═╡ 0887ee78-0e8a-41c7-90e7-44237acc1477
collect(M)

# ╔═╡ 1705dc7b-9f93-440b-acbb-ecb362d08125
typeof(collect(M))

# ╔═╡ ee58251a-8511-11eb-074c-5b1e27c4ebd4
function matvec(M::RankOneMatrix, x)
	
	return missing # Your code here
end

# ╔═╡ ba3cb45a-8502-11eb-2141-6369b0e08807
begin
	struct RankTwoMatrix{T} <: AbstractMatrix{T}
		# Your code here
		A::RankOneMatrix{T}
		B::RankOneMatrix{T}
	end
	
	# Add a constructor that uses two vectors/ranges
	RankTwoMatrix(v1, v2) = RankTwoMatrix(RankOneMatrix(v1), RankOneMatrix(v2))
end

# ╔═╡ f5a95dd8-850d-11eb-2aa7-2dcb1868577f


# ╔═╡ c784e02c-8502-11eb-3efa-7f4c45f4274c
function Base.getindex(M::RankTwoMatrix, i, j)

	return missing # Your code here
end

# ╔═╡ 0bab818e-8503-11eb-02b3-178098599847
function Base.size(M::RankTwoMatrix)
	
	return missing # Your code here
end

# ╔═╡ b6717812-8503-11eb-2729-39bfdc1fd2f9
struct LowRankMatrix <: AbstractMatrix{Float64}
	# Your code here
	Ms::Vector{RankOneMatrix}
	rank::Int
end

# ╔═╡ c49e350e-8503-11eb-15de-7308dd03dc08
function Base.getindex(M::LowRankMatrix, i, j)
	
	return missing # Your code here
end

# ╔═╡ eadb174e-2c1d-48c8-9de2-99cdc2b38d32
md"_homework 5, version 3_"

# ╔═╡ 0560cf7b-9986-402a-9c40-779ea7a7292d
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 082542fe-f89d-4774-be20-1e1a78f21291
md"""

# **Homework 5**: _Structure_
`18.S191`, Spring 2021

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ aaa41509-a62d-417b-bca7-a120e3a5e5b2
md"""
#### Intializing packages
_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ ac35c6b3-a142-4b7a-921b-a2bfe1d84713
md"""
## **Exercise 1:** _When is zero not quite zero?_
Students used to pure math are sometimes surprised to see numbers like `1e-15`, `1e-16`, or `1e-17` appearing in computations when `0` might have been expected. At first glance, this behaviour seems 'random' or 'noisy', but in this exercise, we will try to demonstrate some structure behind floating point artihmetic.

#### Exercise 1.1
👉 Find all integers $j$ with $1 ≤ j ≤ 1000$ for which Julia's result satisfies `j*(1/j) ≠ 1`.

"""

# ╔═╡ a5901f93-007f-4a30-97fc-29b367ec47c6
md"""
Notice that when you re-run the computation, the result does not change. Floating-point arithmetic is not random!

#### Exercise 1.2

👉 Take the smallest number `j` you found above and compute the error, i.e. the distance between `j*(1/j)` and `1`.  

Is this an integer power of 2?  Which one? (`log2` might help.)
"""

# ╔═╡ 7d1e1724-cd1a-483b-af40-f24ae5301849
md"""
#### Exercise 1.3
Caculate all of the following:
* 32 * 23  - 736
* 3.2 * 23 - 73.6
* 3.2 * 2.3 - 7.36
"""

# ╔═╡ 224acb51-c0db-4f04-b865-8349d6a28e98
md"""
We wanted to show you that floating point arithmetic has structure to it.  It is not the fuzz or slop that you may have seen as experimental errors in maybe a chemistry or physics class.  If you are interested, we may show more later in the semester.
"""

# ╔═╡ a7e9ab20-8501-11eb-2a7a-af8fd495b21e
md"""
## **Exercise 2:** _Rank-one matrices_
In this exercise we will go into some more detail about how to define types in Julia in order to make a structured-matrix type, similar to the `OneHotVector` type from class.

To begin, we will make a type to represent a rank-1 matrix. A *rank-1 matrix* is a matrix whose columns are all multiples of each other. This already tells us a lot about the matrix; in fact, we can represent any such matrix as the outer product of two vectors `v` and `w`. *Only* the two vectors will be stored; the matrix elements will be *calculated* on demand, i.e. when we *index* into the object.
"""

# ╔═╡ 8ce8c4bc-8505-11eb-2357-c50a70b8745c
md"""
#### Exercise 2.1
Let's make a `FirstRankOneMatrix` type that contains two vectors of floats, `v` and `w`. Here `v` represents a column and `w` the multpliers for each column.

We include (in the same cell, due to requirements of Pluto) a constructor that takes a single vector `v` and duplicates it.
"""

# ╔═╡ 9f534aa0-8505-11eb-3476-4d326fb19d42
md"""
👉 Create an object of type `FirstRankOneMatrix` representing the multiplication table of the numbers from 1 to 10 and the numbers from 1 to 12. Call it `ten_twelve`.
"""

# ╔═╡ 7aac43b3-49ce-46ea-854b-d292ac0591c7
md"""
#### Exercise 2.2 - _extending Base methods_
Right now, our `FirstRankOneMatrix` is just a container for two arrays. To make it _behave_ like a matrix, we add methods to functions in `Base`, Julia's standard set of functions. Most of the functions you have used so far come from base, for example:
"""

# ╔═╡ ce6e648c-ade5-4882-9f92-1ae3f878a5a3
md"""
These are built-in functions, and each function comes with a set of methods pre-defined (in Julia's source code _(which is mostly written in Julia)_). Uncomment the next cell to see the full list of methods for `size`. We will add a method to this list!
"""

# ╔═╡ 87fce3d8-765c-410c-a059-4dd51bd97254
md"""

Let's extend the `size` and `getindex` methods so that they can also work with our rank-1 matrices. This will allow us to easily access the size and entries of the matrix.
"""

# ╔═╡ e86d8ab6-8505-11eb-1995-137dfbff0191
md"""
👉 Extend `Base.size` for the type `FirstRankOneMatrix` to return the size as a tuple of values corresponding to each direction.
"""

# ╔═╡ 545a5916-8506-11eb-1a31-078957d791f8
md"""
👉 Extend `Base.getindex` for the type `FirstRankOneMatrix` to return the $(i, j)$th entry of the outer product.
"""

# ╔═╡ fe6df9bf-6059-4b76-af39-385d395ece72
Base.getindex(ten_twelve, 5, 11)

# ╔═╡ b9cb6192-8505-11eb-3d2c-790654bbc9a1
md"""
#### Exercise 2.3

If you ask Julia to display the value of an object of type `FirstRankOneMatrix`, you will notice that it doesn't do what we are used to, which is probably to display the whole matrix that it corresponds to. Let's see:
""" 

# ╔═╡ 1b3cc404-9da8-4acd-9df5-5815ce167c34
md"""
This is what matrices normally look like in Julia:
"""

# ╔═╡ 4e926bfe-8734-11eb-1355-e1d1d9b36929
md"""
One possible workaround for this is to create a new function specifically to display a matrix of our custom type.

👉 Make a function `print_as_matrix` that prints the entries of a matrix of type `FirstRankOneMatrix` in a grid format. We'll test that it works below with the matrix `R` we already created.
"""

# ╔═╡ 9eb846c0-8737-11eb-101b-0191f715d8c9
md"""
We should now be able to see our `FirstRankOneMatrix`-type matrix displayed in the terminal! In Pluto, we have to use `with_terminal` to capture and display output printed to the _terminal_.
"""

# ╔═╡ a75f3c76-8506-11eb-1d83-cf5781b656a3
md"""
#### Exercise 2.4 - _AbstractMatrix_
In fact, Julia (together with Pluto) can do some of this work for us! Julia provides facilities to make our life easier when we tell Julia that our type *behaves like* an array. We do so by making the type a *subtype of* `AbstractMatrix`. This will let our type **inherit** the methods and attributes that come with the `AbstractMatrix` type by default - including some display functions that Pluto notebooks use.

Let's do all this on a new rank-one matrix type: `RankOneMatrix`. As we do this, we will also remove the restriction to `Float64`-type entries by using a *parametrised type* `T`. Parametrised types allow us flexibility to handle different types of entries without repeating a lot of code; we won't go too in-depth about these for now.
"""

# ╔═╡ 1d16e228-850e-11eb-1dca-41df85b706da
md"""
In the cell above, we added a second ('outer') constructor that takes a single vector as argument. 

👉 Make sure that you can use both constructors by trying them out below.
"""

# ╔═╡ 3ed18ba0-850b-11eb-3e90-f188c54d9ce9
md"""
👉 Add `getindex` and `size` methods for this new type. These will allow us to access entries of our custom matrices with the usual index notation `M[i,j]`, as well as quickly retrieving their dimensions.
"""

# ╔═╡ 5a6dd3bc-af85-4e7d-b03c-b8c1bc88d850
Base.getindex(R2, 2, 3)

# ╔═╡ 91b1125a-850b-11eb-1a21-c7af293332fd
md"""
👉 Create an object of the new type for the $10 \times 10$ multiplication matrix, using a single range.
"""

# ╔═╡ 8f5c7c9c-850b-11eb-3d97-bf9c6b5d7d2e
md"""
You should see two things: Firstly, the matrix now contains integers, instead of floats (this is thanks to our parametrised type!). And secondly, Julia *automatically* displays the matrix as we wanted, once you have defined `getindex` and `size`, provided you have told Julia that your type is a subtype of `AbstractArray`!
"""

# ╔═╡ 248ab23e-850c-11eb-396f-5ba365f0f743
md"""
Julia also allows us to automatically convert the matrix to a normal ("dense") matrix, using either `collect` or `Array`. Let's try these out. You may need to re-run the cell below after completing the exercises.
"""

# ╔═╡ 8cab8d7d-32fc-4b43-bd54-fb0c78fa5d00
md"""
> Fun fact: we did not define a method for `Base.collect`, and yet it works! This is because we told Julia that our `RankOneMatrix` is a subtype of `AbstractMatrix`, for which `Base.collect` already has a method defined in Julia's source code. This fallback method uses `Base.getindex` and `Base.size`, which we did define.
"""

# ╔═╡ 6a08cb74-8510-11eb-2212-2f1f676f3d5d
md"""
#### Exercise 2.5

Why do we need a special type to represent special types of structured matrices? One reason is that not only do they give a more efficient representation in space (requiring less memory to store), they can also be more efficient in time, i.e. *faster*.

   For example, let's look at **matrix--vector mutiplication**. This is a *fundamental* part of many, *many* algorithms in scientific computing, and because of this, we usually want it to be as fast as possible.

   For a rank-one matrix given by $M = v w^T$, the matrix--vector product $M \cdot x$ is given by $(w \cdot x) v$. Note that $w \cdot x$ is a number (scalar) which is multiplying the vector element by element. This computation is much faster than the usual matrix-vector multiplication: we are taking advantage of structure!
   
"""

# ╔═╡ 61cbfc80-86f5-11eb-316f-6307cac7cbbb
md"""
👉 Define a function `matvec` that takes a `RankOneMatrix` `M` and a `Vector` `x` and carries out matrix-vector multiplication. We will be able to compare the result with doing the matrix--vector product using the corresponding dense matrix.
"""

# ╔═╡ 4864e4d6-850c-11eb-210c-0318b8660a9a
md"""
## Exercise 3: Low-rank matrices
"""

# ╔═╡ 58ce8d2a-850c-11eb-29e9-3fc966e129b1
md"""
In this exercise we will combine rank-1 matrices into low-rank matrices, which are sums of rank-1 matrices. Just like in the previous exercise, we will make custom types for these matrices, and we will be able to compute the entries of a matrix on-demand as we request them (instead of storing all of them always).
"""

# ╔═╡ 9d4d943e-8502-11eb-31cb-e11824b2dce0
md"""
#### Exercise 3.1

👉 Make a rank-2 matrix type `RankTwoMatrix` that contains two rank-1 matrices `A` and `B`.  For simplicity, you can use the `FirstRankOneMatrix` type.

   Include in the same cell a constructor for `RankTwoMatrix` that takes two vectors and makes the rank-one matrices from those vectors.

*Note*: In principle we should check when constructing the type that the input matrices have the same dimensions, but we will just assume that they do.
"""

# ╔═╡ 92a91904-850c-11eb-010e-c58ae218f541
md"""
#### Exercise 3.2
👉 Construct a rank two matrix out of the rank-1 matrix representing the multiplication table of $1.0:10.0$, together with the multiplication table of $0.0:0.1:0.9$.

   (Note that both range arguments must contain floats, so that we can add up entries.)
"""

# ╔═╡ dc714540-8afa-11eb-205b-7770074771c8
md"""
#### Exercise 3.3
👉 As with last time, extend the `getindex` and `size` methods for the `RankTwoMatrix` type. Keep in mind they are already defined for `RankOneMatrix`.
"""

# ╔═╡ aca709f0-8503-11eb-1144-1fc01cb85c39
md"""
#### Exercise 3.4

Making a custom type for rank-2 matrices is a step forward from rank-1 matrices: instead of storing two vectors, we store two rank-1 matrices themselves. What if we want to represent a rank-3 matrix? We would need to store *three* rank-1 matrices, instead of just two. What about rank-4, rank-5, and so on?

We can go even further and make a general custom type `LowRankMatrix` for rank-$k$ matrices, for general (ideally low) $k$. In this case, we should store two main things: the list of rank-1 matrices that our low-rank matrix is made up of, and also the *rank* of the matrix (which is how many rank-1 matrices we are storing).

👉 Complete the definition for the type `LowRankMatrix`. Remember to store both the rank-1 matrices and the rank of the matrix itself.
"""

# ╔═╡ 6e280730-8b00-11eb-04b7-615a389e792f
md"""
#### Exercise 3.5
👉 Extend the `getindex` and `size` methods to work with the `LowRankMatrix` type. As before, remember that these are already defined for `RankOneMatrix`.
"""

# ╔═╡ dd27f508-8503-11eb-36b9-33f5f99f78b0
function Base.size(M::LowRankMatrix)
	
	return missing # Your code here
end

# ╔═╡ ead4c008-0e7e-4414-aced-d4a576423bd3
size === Base.size

# ╔═╡ 0b7c6cbe-57de-419d-adcb-8724791f9c89
Base.size(ten_twelve)

# ╔═╡ 52451232-2c3d-4425-a94a-da1a955cf784
Base.size(R2)

# ╔═╡ 93a75ea0-8b0c-11eb-3946-3d5d92487fb5
let
	comp1, comp2 = RankOneMatrix(1.0:1.0:10.0), RankOneMatrix(0.0:0.1:0.9)
	ex3 = LowRankMatrix([comp1, comp2], 2)
end

# ╔═╡ 1083d5ee-8512-11eb-0fdc-ab3987f94bc5
md"""
#### Exercise 3.6
👉 Extend the method `matvec` to work with our custom type `LowRankMatrix` (and a `Vector`). Remember that `matvec` is already defined for `RankOneMatrix`.
"""

# ╔═╡ 3fed837a-8512-11eb-1fdd-c1b72b48d07b
function matvec(M::LowRankMatrix, x)
	
	return missing # Your code here
end

# ╔═╡ 2d65bd1a-8512-11eb-1bd2-0313588dfa0e
md"""
#### Exercise 3.7
One of the big advantages of our rank-1 matrices is its space efficiency: to "store" a $n\times n$ matrix, we only need to *actually* store two vectors of $n$ entries, as opposed of $n^2$ total entries. Rank-2 matrices are a litte less efficient: we store two rank-1 matrices, or four vectors of $n$ vertices. As we increase the rank, we lose space efficiency, at the cost of being able to represent more kinds of matrices.

👉 For what rank will a matrix of rank $k$ need the same amount of storage as the dense version? Explain your answer.
"""

# ╔═╡ f9556098-8504-11eb-08a0-39fbe00892da
answer = md"""

From rank ...

Because ....
"""

# ╔═╡ 295acdac-880a-402e-9f7e-19b0fc801130
md"""
## **Exercise 4:** _The SVD for structured matrices_
In a math class, you may or may not learn about the *singular value decomposition (SVD)*. From a computational thinking point of view, whether you have seen this before or not we hope will not matter.  Here we would like you to _get to "know" the SVD_, through experience, rather than through a math lecture.  This is how we see "computational thinking" after all. (Definitely do not look up some eigenvalue definition.)
"""

# ╔═╡ 3ba3ae50-b9ed-416e-bb47-a14f82eb4e19
md"""
#### Exercise 4.1

The `LinearAlgebra` package defines a function `svd` that computes the decomposition for us. Have a look at the result of calling the `svd` function. Try not to get intimidated by the large output (you may need to scroll the cell output), and look at the docs for `svd`.
"""

# ╔═╡ bdf3954e-2a05-4a0d-899b-1f6f59119550
biggie = rand(100,100)

# ╔═╡ a58c1c54-4f17-4ca4-ac78-22773b526dfb
md"""
👉 What are the _singular values_ of `biggie`?
"""

# ╔═╡ 210392ff-0a22-4e55-be08-9f58804282cf
singular_values_of_biggie = missing

# ╔═╡ bb649c89-709c-49c8-8111-53044e8e682a
md"""

#### Exercise 4.2

If we try to run the `svd` function on a `RankOneMatrix`, you will see that it does not work. The error is telling us that **no `svd` method has been defined for our type**. Let's extend the `svd` function to work on objects of our type.
"""

# ╔═╡ 6f78b3bb-5440-4f34-849a-fa8e21972fa8
A = RankOneMatrix(rand(3),rand(4))

# ╔═╡ 44b8fbf1-411f-4ce4-b5d7-e12f2d6be51b
md"""
👉 Extend `svd` to work directly on a rank-one matrix, by writing a new method.

Keep things simple. Inside your method, call `LinearAlgebra.svd` on a type that it is _already defined for_.

"""

# ╔═╡ 6c9ae344-084e-459c-841c-8377451507fd
function LinearAlgebra.svd(A::RankOneMatrix)
	
	return missing
end

# ╔═╡ 167b9580-fa18-4248-8643-a0fde723ecc4
svd(biggie)

# ╔═╡ bbc4a595-a63e-4a12-9690-f39a23b30ae1
svd(A)

# ╔═╡ 9ae28bc5-d9cb-479d-8c22-7c9248cd5fa0
LinearAlgebra.svd(A)

# ╔═╡ 0cf29d7e-bd83-4c5f-bd41-e8e7c2587188
md"""
#### Exercise 4.3
👉 Look at the singular values, how many of them are approximately non-zero? Does that make sense?
"""

# ╔═╡ ed4b7ea5-3266-466d-a817-7ab2cc82ac9c


# ╔═╡ 5c6aee48-017b-49ff-af1a-a31af30a45a9
md"""

This number (the number of singular values that are positive) is something you will (or have) learn(ed) in a linear algebra class: it is known as the *rank* of a matrix, and is usually defined through a complicated elimination procedure.

👉 Write a function `numerical_rank` that calculates the singular values of a matrix `A`, and returns how many of them are approximately zero.

To keep things simple, you can assume that "approximately zero" means: less than `tol=1e5`.
"""

# ╔═╡ a2b7f0c3-488b-4ce9-aed6-b8ccddac6a57
function numerical_rank(A::AbstractMatrix; tol=1e-5)
	
	return missing
end

# ╔═╡ d3420859-d558-47cb-aaf7-d51a5e2d1f6e
numerical_rank(A)

# ╔═╡ 207d2f4c-cbe8-4828-ab3f-100809bb93e9
numerical_rank(rand(3,3))

# ╔═╡ 7fdc110a-a3e3-44e5-a547-b75e03e0d21e
md"""
#### Exercise 4.4
👉 Write a function that takes an argument $k$ and generates the sum of $k$ random rank-one matrices of size mxn, and counts the number of essentially non-zero singular values. 

   Hint: you can do this with a `for` loop, but it can also be done with `sum`, e.g.

   `sum(i for i=1:10)`.

"""

# ╔═╡ 01b12200-2e7e-4f19-96b9-5b6d6cb03233
function k_rank_ones(k, m, n)
	
	return missing
end

# ╔═╡ e1e1067b-93ba-40df-bd09-7599538e6181
k_rank_ones(1, 3, 3)

# ╔═╡ 00f5bea8-b808-483a-ad70-332f521481f5
md"""
#### Exercise 4.5
👉 What is the answer when $m$ and $n$ are both $≥ k$?  What if one of $m$ or $n$ is $< k$?
"""

# ╔═╡ a6bb92f9-0cb2-4fdd-8b67-f286edbbdcb6


# ╔═╡ 57c19601-122b-414f-bc99-56f98c794e61


# ╔═╡ 9813e9f9-9970-4a8b-b3ca-e6a699e6fda4


# ╔═╡ c8829a12-917a-4ff4-87c9-fe2b25aaa99c


# ╔═╡ 5aabbec1-a079-4936-9cd1-9c25fe5700e6
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 42d6b87d-b4c3-4ccb-aceb-d1b020135f47
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ a759c4d5-ca00-4dda-b39c-1093ba9bef0e
md"""
Try writing this without a `for` loop. Ideas:

☝️ Use `filter`.

☝️ Comprehensions can have `if` clauses, as in `[j for j=1:1000 if 5 < j < 17]`.
""" |> hint

# ╔═╡ e9a53ca0-86f2-11eb-2970-5d0996d1603e
hint(md"""
The extra constructor should have the same name as the type; it should take in a single argument `v`, and use it for both the column and the multipliers.
""")

# ╔═╡ 5e85ac82-8734-11eb-2f69-cda569326f68
hint(md"""
Check the docs for functions like `print`, `println`, `lpad` and `rpad`. Also, you don't have to know exactly how the `do` keyword works for now, but feel free to read about it - it can be useful with iterating!	
""")

# ╔═╡ 7493be50-8738-11eb-37e7-990f1656998a
hint(md"""
If you want to specify that your argument is a range, use the `AbstractRange` type.
""")

# ╔═╡ f7fb3b32-8b00-11eb-0c0e-8f8d68f849a6
hint(md"""
How would we implement `matvec` for a rank-2 matrix - making use of the two stored rank-1 matrices? Can you generalize this to the rank-$k$ case, when we have many rank-1 matrices?
""")

# ╔═╡ 8fd9e34c-8f20-4979-8f8a-e3e2ae7d6c65
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ d375c52d-2126-4594-b819-aba9d34fe77f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ cd02acd0-8af4-11eb-3726-d7a360b98433
let
	example = FirstRankOneMatrix([1,2], [3,4])
	if ismissing(print_as_matrix(example))
		still_missing()
	end
end

# ╔═╡ 2d7565d4-88da-4e41-aad6-958ed6b3b2e0
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ d7f45d51-f426-4353-af58-858395295ce0
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next question."]

# ╔═╡ 9b2aa95d-4583-40ec-893c-9fc751ea22a1
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 29db89d6-ac40-4121-b996-e083555bc5db
try
	A = RankOneMatrix([1,2,3], [5,6,7])
	result = LinearAlgebra.svd(A)
	
	if result isa Missing
		still_missing()
	elseif !(result isa LinearAlgebra.SVD)
		almost(md"Like all other `svd` methods (implemented in `LinearAlgebra`), your method should return an SVD factorization (of type `LinearAlgebra.SVD`).")
	else
		reconstructed = result.U[:,1:1] * result.S[1:1] * result.Vt[1:1,:]
	
	
		if sum(abs.(A .- reconstructed)) < 1e-5
			correct()
		else
			keep_working()
		end
	end
catch e
	if (e isa MethodError) && e.f === LinearAlgebra.svd
		still_missing(md"Define a new method for `LinearAlgebra.svd` that takes a `RankOneMatrix` as argument.")
	else
		rethrow(e)
	end
end

# ╔═╡ 5dca2bb3-24e6-49ae-a6fc-d3912da4f82a
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 30e5a813-9ea1-48d9-9039-012b8b267256
let
	if !@isdefined(ten_twelve)
		not_defined(:ten_twelve)
	else
		if ten_twelve isa Missing
			still_missing()
		elseif !(ten_twelve isa FirstRankOneMatrix)
			keep_working(md"`ten_twelve` should be a `FirstRankOneMatrix`.")
		elseif (ten_twelve.v == 1:10 && ten_twelve.w == 1:12) ||
				(ten_twelve.w == 1:10 && ten_twelve.v == 1:12)
			
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 06040694-b324-4e6b-8314-3bffc7b8010f
let
	if !@isdefined(RankOneMatrix)
		not_defined(:RankOneMatrix)
	else
		R2 = FirstRankOneMatrix([1,2], [3,4,5])


		if ismissing(Base.size(R2))
			still_missing()	
		elseif size(R2) != (2, 3)
			keep_working(md"`Base.size` is not implemented correctly.")
		else
			correct()
		end
	end
end

# ╔═╡ 4ba8a0f2-850b-11eb-1c09-b7bba1763ed7
let
	if !@isdefined(FirstRankOneMatrix)
		not_defined(:FirstRankOneMatrix)
	else
		R2 = FirstRankOneMatrix([1,2], [3,4,5])


		if ismissing(Base.getindex(R2, 1, 1))
			still_missing(md"Implement both `Base.size` and `Base.getindex`.")	
		elseif ismissing(Base.size(R2))
			still_missing(md"Implement both `Base.size` and `Base.getindex`.")
		elseif size(R2) != (2, 3)
			keep_working(md"`Base.size` is not implemented correctly.")
		else
			shouldbe = [
					3 4 5
					6 8 10
				]
			r = all(CartesianIndices(shouldbe)) do I
				isapprox(R2[Tuple(I)...], shouldbe[I], rtol=1-3)
			end
			if r
				correct()
			else
				keep_working(md"`Base.getindex` is not implemented correctly.")
			end
		end
	end
end

# ╔═╡ 111a8db4-a808-4f37-a75e-08d418bdfc98
let
	if !@isdefined(RankOneMatrix)
		not_defined(:RankOneMatrix)
	else
		R2 = RankOneMatrix([1,2], [3,4,5])


		if ismissing(Base.size(R2))
			still_missing()	
		elseif size(R2) != (2, 3)
			keep_working(md"`Base.size` is not implemented correctly.")
		else
			correct()
		end
	end
end

# ╔═╡ 47f17b30-d87b-4d71-abf1-7a8b7f938095
let
	if !@isdefined(RankOneMatrix)
		not_defined(:RankOneMatrix)
	else
		R2 = RankOneMatrix([1,2], [3,4,5])


		if ismissing(Base.getindex(R2, 1, 1))
			still_missing(md"Implement both `Base.size` and `Base.getindex`.")	
		elseif ismissing(Base.size(R2))
			still_missing(md"Implement both `Base.size` and `Base.getindex`.")
		elseif size(R2) != (2, 3)
			keep_working(md"`Base.size` is not implemented correctly.")
		else
			shouldbe = [
					3 4 5
					6 8 10
				]
			r = all(CartesianIndices(shouldbe)) do I
				isapprox(R2[Tuple(I)...], shouldbe[I], rtol=1-3)
			end
			if r
				correct()
			else
				keep_working(md"`Base.getindex` is not implemented correctly.")
			end
		end
	end
end

# ╔═╡ 3e72f920-8739-11eb-1354-57b18fa53103
if !@isdefined(matvec)
	not_defined(:matvec)
else
	let
		M = RankOneMatrix(1:10)

		if ismissing(matvec(M, ones(10)))
			still_missing()
		end

		incorrect = false
		for i in 1:5
			r = ones(10).*i
			for j in 1:10
				if matvec(M, r)[j] != (collect(M) * r)[j]
					incorrect = true
				end
			end
		end
		
		if incorrect
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 0d81b3d3-cfb4-4c27-bb00-18a55e00ab7a
let
	if !@isdefined(RankTwoMatrix)
		not_defined(:RankTwoMatrix)
	else
		R1 = RankOneMatrix([1,2], [3,4,5])
		R2 = RankTwoMatrix(R1, R1)


		if ismissing(Base.size(R2))
			still_missing()	
		elseif size(R2) != (2, 3)
			keep_working(md"`Base.size` is not implemented correctly.")
		else
			correct()
		end
	end
end

# ╔═╡ 2e2f503f-c1ad-4d7f-8c0d-cd41fad1f334
let
	if !@isdefined(RankTwoMatrix)
		not_defined(:RankTwoMatrix)
	else
		R1a = RankOneMatrix([1,2], [3,4,5])
		R1b = RankOneMatrix([2,1], [3,4,5])
		R2 = RankTwoMatrix(R1a, R1b)

		if ismissing(Base.getindex(R2, 1, 1))
			still_missing(md"Implement both `Base.size` and `Base.getindex`.")	
		elseif ismissing(Base.size(R2))
			still_missing(md"Implement both `Base.size` and `Base.getindex`.")
		elseif size(R2) != (2, 3)
			keep_working(md"`Base.size` is not implemented correctly.")
		else
			shouldbe = [
					3 4 5
					6 8 10
				]
			s2 = shouldbe + shouldbe[[2,1],:]
			r = all(CartesianIndices(s2)) do I
				isapprox(R2[Tuple(I)...], s2[I], rtol=1-3)
			end
			if r
				correct()
			else
				keep_working(md"`Base.getindex` is not implemented correctly.")
			end
		end
	end
end

# ╔═╡ 84d7bc07-e211-4296-98e6-f03723481e37
let
	if !@isdefined(LowRankMatrix)
		not_defined(:LowRankMatrix)
	else
		R1 = RankOneMatrix([1,2], [3,4,5])
		R2 = LowRankMatrix([R1, R1],2)


		if ismissing(Base.size(R2))
			still_missing()	
		elseif size(R2) != (2, 3)
			keep_working(md"`Base.size` is not implemented correctly.")
		else
			correct()
		end
	end
end

# ╔═╡ 4ed7c189-3130-4f6a-b57b-5322fdd4cef6
let
	if !@isdefined(LowRankMatrix)
		not_defined(:LowRankMatrix)
	else
		R1a = RankOneMatrix([1,2], [3,4,5])
		R1b = RankOneMatrix([2,1], [3,4,5])
		R2 = LowRankMatrix([R1a, R1b],2)

		if ismissing(Base.getindex(R2, 1, 1))
			still_missing(md"Implement both `Base.size` and `Base.getindex`.")	
		elseif ismissing(Base.size(R2))
			still_missing(md"Implement both `Base.size` and `Base.getindex`.")
		elseif size(R2) != (2, 3)
			keep_working(md"`Base.size` is not implemented correctly.")
		else
			shouldbe = [
					3 4 5
					6 8 10
				]
			s2 = shouldbe + shouldbe[[2,1],:]
			r = all(CartesianIndices(s2)) do I
				isapprox(R2[Tuple(I)...], s2[I], rtol=1-3)
			end
			if r
				correct()
			else
				keep_working(md"`Base.getindex` is not implemented correctly.")
			end
		end
	end
end

# ╔═╡ 863f4490-8b06-11eb-352b-61cec188ae57
if !@isdefined(matvec)
	not_defined(:matvec)
else
	
	let
		
		comp1, comp2 = RankOneMatrix(1.0:1.0:10.0), RankOneMatrix(0.0:0.1:0.9)
		if ismissing(comp1) | ismissing(comp2)
			still_missing()
		end
		
		ex4 = LowRankMatrix([comp1, comp2], 2)
		if ismissing(ex4)
			still_missing
		end
		
		if ismissing(matvec(ex4, ones(10)))
			still_missing()
		end
		
		incorrect = false
		for i in 1:10
			r = ones(10).*i
			v, c = matvec(ex4, r), collect(ex4) * r
			for j in 1:10
				if abs(v[j] - c[j]) > 1e-10
					incorrect = true
					break
				end
			end
		end
		
		if incorrect
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ bec548dd-e2b9-4057-b0ac-1ab4e5b441d4
if !@isdefined(singular_values_of_biggie)
	not_defined(:singular_values_of_biggie)
else
	if singular_values_of_biggie isa Missing
		still_missing()
	elseif !(singular_values_of_biggie isa AbstractVector)
		keep_working(md"Return the singular values as a _vector_.")
	elseif isapprox(singular_values_of_biggie, svdvals(biggie), rtol=1e-5)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 2f5eadb0-4fdb-45b6-83fd-116dd4c1f9be
let
	if !@isdefined(numerical_rank)
		not_defined(:numerical_rank)
	else
		result1 = numerical_rank([
				1 2 0
				0 0 1e-10
				-5 -10 0
				])
		
		if result1 isa Missing
			still_missing()
		elseif !(result1 isa Integer)
			keep_working(md"You should return a number.")
		elseif result1 != 1
			keep_working()
		else
			result2 = numerical_rank([
				1 3 0
				0 0 1e-10
				-5 -10 0
				])
			if result2 == 2
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ 1276103b-8c58-4757-ae80-5ffb7f870d09
let
	if !@isdefined(k_rank_ones)
		not_defined(:k_rank_ones)
	else
		result = k_rank_ones(1, 3, 4)
		
		if result isa Missing
			still_missing()
		elseif !(result isa AbstractMatrix)
			keep_working(md"Make sure that you return a matrix.")
		elseif size(result) != (3, 4)
			keep_working(md"Make sure that you return a matrix of the correct size.")
		else
			
			numerical_rank(A) = count(>(1e-5), svdvals(A))
			
			if numerical_rank(result) == 1
				correct()
			else
				result2 = k_rank_ones(2, 10, 4)
				
				if !(result2 isa AbstractMatrix)
					keep_working(md"Make sure that you return a matrix.")
				elseif size(result2) != (10, 4)
					keep_working(md"Make sure that you return a matrix of the correct size.")
				elseif numerical_rank(result2) == 2
					correct()
				else
					keep_working()
				end
			end
			
			
		end
	end
end

# ╔═╡ ddf2a828-7823-4fc0-b944-72b60b391247
todo(text) = HTML("""<div
	style="background: rgb(220, 200, 255); padding: 2em; border-radius: 1em;"
	><h1>TODO</h1>$(repr(MIME"text/html"(), text))</div>""")

# ╔═╡ a7feaaa4-618b-4afe-8050-4bf7cc609c17
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 4ce0e43d-63d6-4cb2-88b8-8ba80e17012a
bigbreak

# ╔═╡ 36a63540-8739-11eb-21b2-a9d5ee60a0e5
bigbreak

# ╔═╡ 35d22fd9-9cfc-47c5-8adb-a01f14586be3
bigbreak

# ╔═╡ 0d1dac23-bdbd-4a90-ab13-e4c33d83777e
bigbreak

# ╔═╡ a5234680-8b02-11eb-2574-15489d0d49ea
bigbreak

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "63d1e802de0c4882c00aee5cb16f9dd4d6d7c59c"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.1"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─eadb174e-2c1d-48c8-9de2-99cdc2b38d32
# ╟─0560cf7b-9986-402a-9c40-779ea7a7292d
# ╟─082542fe-f89d-4774-be20-1e1a78f21291
# ╠═6f4274b5-87e2-420d-83d2-83a8408650cd
# ╟─aaa41509-a62d-417b-bca7-a120e3a5e5b2
# ╠═8c8388cf-9891-423c-8db2-d40d870bb38e
# ╟─4ce0e43d-63d6-4cb2-88b8-8ba80e17012a
# ╟─ac35c6b3-a142-4b7a-921b-a2bfe1d84713
# ╠═ea28bf57-ba62-41ce-8be6-d38ca2c5caa3
# ╟─a759c4d5-ca00-4dda-b39c-1093ba9bef0e
# ╟─a5901f93-007f-4a30-97fc-29b367ec47c6
# ╠═8efcaaeb-4900-404b-ae59-65db0bde8790
# ╠═a5be0775-68de-41ce-95cd-1465723d099b
# ╠═4abec609-09cd-4f86-8d86-a7d02325cc7b
# ╠═32e073bb-943f-4fa9-b15f-5ec18feecf15
# ╟─7d1e1724-cd1a-483b-af40-f24ae5301849
# ╠═d221c61c-a4ab-4a82-b89d-52735d957cae
# ╠═c3d49b98-a9c1-4aba-becc-7fa84f4bbc75
# ╠═7b33c09c-2ef2-4b97-b5a5-5fdf9268f76b
# ╟─224acb51-c0db-4f04-b865-8349d6a28e98
# ╟─a7e9ab20-8501-11eb-2a7a-af8fd495b21e
# ╟─8ce8c4bc-8505-11eb-2357-c50a70b8745c
# ╠═615b88b6-8505-11eb-0a7c-294ee5ae7474
# ╟─e9a53ca0-86f2-11eb-2970-5d0996d1603e
# ╟─9f534aa0-8505-11eb-3476-4d326fb19d42
# ╠═b0db7388-850c-11eb-0915-597f1fa5ab93
# ╟─30e5a813-9ea1-48d9-9039-012b8b267256
# ╟─7aac43b3-49ce-46ea-854b-d292ac0591c7
# ╠═2dfc2ef9-3efa-4b82-960f-f2ef0171e9eb
# ╠═ead4c008-0e7e-4414-aced-d4a576423bd3
# ╠═d4a0baea-cc02-4d91-a938-8181dea7b47a
# ╟─ce6e648c-ade5-4882-9f92-1ae3f878a5a3
# ╠═7adbcbab-66e7-4b58-b197-5c220ba1e9a2
# ╟─87fce3d8-765c-410c-a059-4dd51bd97254
# ╟─e86d8ab6-8505-11eb-1995-137dfbff0191
# ╠═fada4734-8505-11eb-3f2b-d1f1ef391ba4
# ╠═0b7c6cbe-57de-419d-adcb-8724791f9c89
# ╟─06040694-b324-4e6b-8314-3bffc7b8010f
# ╟─545a5916-8506-11eb-1a31-078957d791f8
# ╠═590dfe1a-8506-11eb-0069-d7cd91f02a65
# ╠═fe6df9bf-6059-4b76-af39-385d395ece72
# ╟─4ba8a0f2-850b-11eb-1c09-b7bba1763ed7
# ╟─b9cb6192-8505-11eb-3d2c-790654bbc9a1
# ╠═941b6b10-8ae9-11eb-3bf8-b732f5f60af3
# ╟─1b3cc404-9da8-4acd-9df5-5815ce167c34
# ╠═a243a400-8af3-11eb-0637-cf8f80aae86d
# ╟─4e926bfe-8734-11eb-1355-e1d1d9b36929
# ╠═c7a15c5e-8505-11eb-3af2-2fa84b74b590
# ╟─9eb846c0-8737-11eb-101b-0191f715d8c9
# ╠═b0a0b9a4-850b-11eb-30f1-11f5270efe02
# ╟─cd02acd0-8af4-11eb-3726-d7a360b98433
# ╟─5e85ac82-8734-11eb-2f69-cda569326f68
# ╟─a75f3c76-8506-11eb-1d83-cf5781b656a3
# ╠═b577420c-8501-11eb-267a-719125315fe1
# ╟─1d16e228-850e-11eb-1dca-41df85b706da
# ╠═eb612772-8b06-44bb-a36a-827435cbb2ee
# ╠═d3e7c8d1-4b4a-47b6-9c96-150333078f42
# ╟─7493be50-8738-11eb-37e7-990f1656998a
# ╟─3ed18ba0-850b-11eb-3e90-f188c54d9ce9
# ╠═f2d8b45c-8501-11eb-1c6a-5f819c240d9d
# ╠═ed72e880-8afa-11eb-3a4a-175a838188d9
# ╠═7b3fb0ef-9a9e-401c-8c09-e5615134a4ad
# ╠═5a6dd3bc-af85-4e7d-b03c-b8c1bc88d850
# ╠═52451232-2c3d-4425-a94a-da1a955cf784
# ╟─111a8db4-a808-4f37-a75e-08d418bdfc98
# ╟─47f17b30-d87b-4d71-abf1-7a8b7f938095
# ╟─91b1125a-850b-11eb-1a21-c7af293332fd
# ╠═fc962c72-8501-11eb-2821-cbb7a52d5f61
# ╟─8f5c7c9c-850b-11eb-3d97-bf9c6b5d7d2e
# ╟─248ab23e-850c-11eb-396f-5ba365f0f743
# ╠═0887ee78-0e8a-41c7-90e7-44237acc1477
# ╠═1705dc7b-9f93-440b-acbb-ecb362d08125
# ╟─8cab8d7d-32fc-4b43-bd54-fb0c78fa5d00
# ╟─6a08cb74-8510-11eb-2212-2f1f676f3d5d
# ╟─61cbfc80-86f5-11eb-316f-6307cac7cbbb
# ╠═ee58251a-8511-11eb-074c-5b1e27c4ebd4
# ╟─3e72f920-8739-11eb-1354-57b18fa53103
# ╟─36a63540-8739-11eb-21b2-a9d5ee60a0e5
# ╟─4864e4d6-850c-11eb-210c-0318b8660a9a
# ╟─58ce8d2a-850c-11eb-29e9-3fc966e129b1
# ╟─9d4d943e-8502-11eb-31cb-e11824b2dce0
# ╠═ba3cb45a-8502-11eb-2141-6369b0e08807
# ╟─92a91904-850c-11eb-010e-c58ae218f541
# ╠═f5a95dd8-850d-11eb-2aa7-2dcb1868577f
# ╟─dc714540-8afa-11eb-205b-7770074771c8
# ╠═c784e02c-8502-11eb-3efa-7f4c45f4274c
# ╠═0bab818e-8503-11eb-02b3-178098599847
# ╟─0d81b3d3-cfb4-4c27-bb00-18a55e00ab7a
# ╟─2e2f503f-c1ad-4d7f-8c0d-cd41fad1f334
# ╟─aca709f0-8503-11eb-1144-1fc01cb85c39
# ╠═b6717812-8503-11eb-2729-39bfdc1fd2f9
# ╟─6e280730-8b00-11eb-04b7-615a389e792f
# ╠═c49e350e-8503-11eb-15de-7308dd03dc08
# ╠═dd27f508-8503-11eb-36b9-33f5f99f78b0
# ╠═93a75ea0-8b0c-11eb-3946-3d5d92487fb5
# ╟─84d7bc07-e211-4296-98e6-f03723481e37
# ╟─4ed7c189-3130-4f6a-b57b-5322fdd4cef6
# ╟─1083d5ee-8512-11eb-0fdc-ab3987f94bc5
# ╠═3fed837a-8512-11eb-1fdd-c1b72b48d07b
# ╟─863f4490-8b06-11eb-352b-61cec188ae57
# ╟─f7fb3b32-8b00-11eb-0c0e-8f8d68f849a6
# ╟─2d65bd1a-8512-11eb-1bd2-0313588dfa0e
# ╠═f9556098-8504-11eb-08a0-39fbe00892da
# ╟─35d22fd9-9cfc-47c5-8adb-a01f14586be3
# ╟─295acdac-880a-402e-9f7e-19b0fc801130
# ╠═54778212-3702-467d-8a96-4fa18b3ccd63
# ╟─3ba3ae50-b9ed-416e-bb47-a14f82eb4e19
# ╠═bdf3954e-2a05-4a0d-899b-1f6f59119550
# ╠═167b9580-fa18-4248-8643-a0fde723ecc4
# ╟─a58c1c54-4f17-4ca4-ac78-22773b526dfb
# ╠═210392ff-0a22-4e55-be08-9f58804282cf
# ╟─bec548dd-e2b9-4057-b0ac-1ab4e5b441d4
# ╟─0d1dac23-bdbd-4a90-ab13-e4c33d83777e
# ╟─bb649c89-709c-49c8-8111-53044e8e682a
# ╠═6f78b3bb-5440-4f34-849a-fa8e21972fa8
# ╠═bbc4a595-a63e-4a12-9690-f39a23b30ae1
# ╟─44b8fbf1-411f-4ce4-b5d7-e12f2d6be51b
# ╠═6c9ae344-084e-459c-841c-8377451507fd
# ╠═9ae28bc5-d9cb-479d-8c22-7c9248cd5fa0
# ╟─29db89d6-ac40-4121-b996-e083555bc5db
# ╟─0cf29d7e-bd83-4c5f-bd41-e8e7c2587188
# ╠═ed4b7ea5-3266-466d-a817-7ab2cc82ac9c
# ╟─5c6aee48-017b-49ff-af1a-a31af30a45a9
# ╠═a2b7f0c3-488b-4ce9-aed6-b8ccddac6a57
# ╠═d3420859-d558-47cb-aaf7-d51a5e2d1f6e
# ╠═207d2f4c-cbe8-4828-ab3f-100809bb93e9
# ╟─2f5eadb0-4fdb-45b6-83fd-116dd4c1f9be
# ╟─7fdc110a-a3e3-44e5-a547-b75e03e0d21e
# ╠═01b12200-2e7e-4f19-96b9-5b6d6cb03233
# ╠═e1e1067b-93ba-40df-bd09-7599538e6181
# ╟─1276103b-8c58-4757-ae80-5ffb7f870d09
# ╟─00f5bea8-b808-483a-ad70-332f521481f5
# ╠═a6bb92f9-0cb2-4fdd-8b67-f286edbbdcb6
# ╠═57c19601-122b-414f-bc99-56f98c794e61
# ╠═9813e9f9-9970-4a8b-b3ca-e6a699e6fda4
# ╠═c8829a12-917a-4ff4-87c9-fe2b25aaa99c
# ╟─a5234680-8b02-11eb-2574-15489d0d49ea
# ╟─5aabbec1-a079-4936-9cd1-9c25fe5700e6
# ╟─42d6b87d-b4c3-4ccb-aceb-d1b020135f47
# ╟─8fd9e34c-8f20-4979-8f8a-e3e2ae7d6c65
# ╟─d375c52d-2126-4594-b819-aba9d34fe77f
# ╟─2d7565d4-88da-4e41-aad6-958ed6b3b2e0
# ╟─d7f45d51-f426-4353-af58-858395295ce0
# ╟─9b2aa95d-4583-40ec-893c-9fc751ea22a1
# ╟─5dca2bb3-24e6-49ae-a6fc-d3912da4f82a
# ╟─ddf2a828-7823-4fc0-b944-72b60b391247
# ╟─a7feaaa4-618b-4afe-8050-4bf7cc609c17
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
