### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 864e1180-f693-11ea-080e-a7d5aabc9ca5
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using ImageShow.ImageCore
	using ColorSchemes
	
	using InteractiveUtils, PlutoUI
	using LinearAlgebra, SparseArrays, Statistics

	# Small patch to make images look more crisp:
	# https://github.com/JuliaImages/ImageShow.jl/pull/50
	Base.showable(::MIME"text/html", ::AbstractMatrix{<:Colorant}) = false
end

# ╔═╡ 0db6ee04-81b7-11eb-330c-11b578b72c90
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
"><em>Section 1.9</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Taking Advantage of Structure </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/wZrVxbmX218" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ ca1a1072-81b6-11eb-1fee-e7df687cc314
PlutoUI.TableOfContents(aside = true)

# ╔═╡ fe2028ba-f6dc-11ea-0228-938a81a91ace
myonehatvector = [0, 1, 0, 0, 0, 0]

# ╔═╡ 0a902426-f6dd-11ea-0ae4-fb0c47863fe7
# also one "cold"
1 .- myonehatvector

# ╔═╡ 4624cd26-f5d3-11ea-1cf8-7d6555eae5fa
struct OneHot <: AbstractVector{Int}
	n::Int
	k::Int
end

# ╔═╡ 397ac764-f5fe-11ea-20cc-8d7cab19d410
Base.size(x::OneHot) = (x.n,)

# ╔═╡ 82c7046c-f5d3-11ea-04e2-ef7c0f4db5da
Base.getindex(x::OneHot, i::Int) = Int(x.k == i)

# ╔═╡ b0ba5b8c-f5d1-11ea-1304-3f0e47f935fe
md"# Examples of structure"

# ╔═╡ 261c4df2-f5d2-11ea-2c72-7d4b09c46098
md"""
# One-hot vectors
This example comes from machine learning.
"""

# ╔═╡ 3cada3a0-81cc-11eb-04c8-bde26d36a84e
md"""
A **one-hot** vector has a single "hot" element, i.e. a single 1 in a sea of zeros. For example:
"""

# ╔═╡ 8d2c6910-f5d4-11ea-1928-1baf09815687
md"""How much "information" (numbers) do you need to represent a one-hot vector? Is it $n$ or is it two?
"""

# ╔═╡ 54649792-81cc-11eb-1038-9161a4037acf
md"""
(There are also "1-cold" vectors:)
"""

# ╔═╡ 4794e860-81b7-11eb-2c91-8561c20f308a
md"""
## Julia: `structs` (creating a new type in Julia)
"""

# ╔═╡ 67827da8-81cc-11eb-300e-278104d2d958
md"""
We can create our own new types in Julia. Let's create a new type to represent one-hot vectors. It will be a subtype of `AbstractVector`, meaning that it *behaves like* a vector.
"""

# ╔═╡ 9bdabef8-81cc-11eb-14a1-67a9a7d968c0
md"""
We need to specify how long the vector is:
"""

# ╔═╡ a22dcd2c-81cc-11eb-1252-13ace134192d
md"""
and how to extract the $i$th component:
"""

# ╔═╡ b024c318-81cc-11eb-018c-e1f7830ff51b
md"""
(Note that `x.k == i` returns a Boolean value, `true` or `false`, which we are then converting to an `Int`.)
"""

# ╔═╡ 93bfe3ac-f756-11ea-20fb-8f7d586b42f3
myonehotvector = OneHot(6,2)

# ╔═╡ 175039aa-f758-11ea-251a-5db57d7c4b32
myonehotvector[3]

# ╔═╡ c2a4b0a2-81cc-11eb-37a7-db601a6ddfdf
myonehotvector[2]

# ╔═╡ c5ed7d3e-81cc-11eb-3386-15b72db8155d
md"""
This behaves as if it were the original vector, but we are storing only 2 integers.
This is an example of taking advantage of structure.
"""

# ╔═╡ e2e354a8-81b7-11eb-311a-35151063c2a7
md"""
## Julia: dump and Dump
"""

# ╔═╡ dc5a96ba-81cc-11eb-3189-25920df48afa
md"""
`dump` shows the internal data stored inside a given object:
"""

# ╔═╡ af0d3c22-f756-11ea-37d6-11b630d2314a
with_terminal() do
	dump(myonehotvector)
end

# ╔═╡ 06e3a842-26b8-4417-9cf5-8a083ccdb264
md"""
Since `dump` writes to a terminal, you can't use it directly inside Pluto, which is why we wrap it inside a `with_terminal` block. You can also use the function `Dump` from `PlutoUI`:
"""

# ╔═╡ 91172a3e-81b7-11eb-0953-9f5e0207f863
Dump(myonehotvector)

# ╔═╡ 4bbf3f58-f788-11ea-0d24-6b0fb070829e
myonehotvector

# ╔═╡ fe70d104-81b7-11eb-14d0-eb5237d8ea6c
md"""
### Visualizing a one-hot vector
"""

# ╔═╡ ef8f44b2-f5fc-11ea-1e4d-bd873cd39d6c
md"""
n=$(@bind nn Slider(1:20, show_value=true))
"""

# ╔═╡ fd9211c0-f5fc-11ea-1745-7f2dae88af9e
md"""
k=$(@bind kk Slider(1:nn, default=1, show_value=true))
"""

# ╔═╡ f1154df8-f693-11ea-3b16-f32835fcc470
x = OneHot(nn, kk)

# ╔═╡ 81c35324-f5d4-11ea-2338-9f982d38732c
md"# Diagonal matrices"

# ╔═╡ 2cfda0dc-f5d5-11ea-16c4-b5a33b90e37f
md"Another example is diagonal matrices. Here's how you might see them in high school:"

# ╔═╡ 150432d4-f5d5-11ea-32b2-19a2a91d9637
denseD = [5 0 0 
	    0 6 0
	    0 0 -10]	

# ╔═╡ 44215aa4-f695-11ea-260e-b564c6fbcd4a
md"Julia has a better way of representing them:"

# ╔═╡ 21328d1c-f5d5-11ea-288e-4171ad35326d
D = Diagonal(denseD)

# ╔═╡ 75761cc0-81cd-11eb-1186-7d47debd68ca
md"""
It even displays nicely, with dots instead of zeros. 

We can also create a diagonal matrix from the values on the diagonal:
"""

# ╔═╡ 6bd8a886-f758-11ea-2587-870a3fa9d710
Diagonal([5, 6, -10])

# ╔═╡ 4c533ac6-f695-11ea-3724-b955eaaeee49
md"How much information is stored for each representation? We can use Julia's `dump` function to find out:"

# ╔═╡ 466901ea-f5d5-11ea-1db5-abf82c96eabf
Dump(denseD)

# ╔═╡ b38c4aae-f5d5-11ea-39b6-7b0c7d529019
Dump(D)

# ╔═╡ 93e04ed8-81cd-11eb-214a-a761ef8c406f
md"""
We see that `Diagonal` stores only the diagonal entries, not the zeros!
"""

# ╔═╡ e90c55fc-f5d5-11ea-10f1-470ff772985d
md"""We should always look for *structure* where it exists!"""

# ╔═╡ 19775c3c-f5d6-11ea-15c2-89618e654a1e
md"# Sparse matrices"

# ╔═╡ 653792a8-f695-11ea-1ae0-43761c502583
md"A *sparse* matrix is a matrix that has many zeros, and is hence worth storing in a *sparse* representation:"

# ╔═╡ 79c94d2a-f75a-11ea-031d-09d70d229e15
denseM = [0 0 9; 0 0 0;12 0 4]

# ╔═╡ 10bc5d50-81b9-11eb-2ac7-354a6c6c826b
md"""
The above displays a sparse matrix in so-called `(i, j, value)` form.  We could
store sparse matrices in this way:
"""

# ╔═╡ 77d6a952-81ba-11eb-24e3-cb6510a59455
M = sparse(denseM)

# ╔═╡ 1f3ba55a-81b9-11eb-001f-593b9d8639ca
md"""
Although it looks like it's stored like this, in fact the actual storage format is different. In the Julia `SparseArrays.jl` package, the storage format
is **compressed sparse column** (CSC) format,
which is generally considered favorable for arithmetic, matrix-vector
	products and column slicing.  Of course, for specific matrices, other
		formats might be better.

* `nzval` contains the nonzero matrix entries
* `rowval` is the "i" or row entry for the corresponding value in nzval
  * length(rowval) == length(nzval)
* `colptr[j]` points into nzval and tells you the first nonzero in or after column j
* The last entry of colptr points beyond the end of nzval to indicate no more columns.
  * length(colptr) == number of columns + 1
"""

# ╔═╡ 3d4a702e-f75a-11ea-031c-333d591fc442
Dump(sparse(M))

# ╔═╡ 80ff4010-81bb-11eb-374e-215a57defb0b
md"""
 An example where CSC may not be a great choice is the following. The reason is that  `colptr` must have an entry in each column:
"""

# ╔═╡ 5de72b7c-f5d6-11ea-1b6f-35b830b5fb34
M2 = sparse([1, 2, 10^6], [4, 9, 10^6], [7, 8, 9])

# ╔═╡ 8b60629e-f5d6-11ea-27c8-d934460d3a57
with_terminal() do
	dump(M2)
end

# ╔═╡ 2fd7e52e-f5d7-11ea-3b5a-1f338e2451e0
M3 = [1 0 2 0 10; 0 3 4 0 9; 0 0 0 5 8; 0 0 0 0 7] 

# ╔═╡ 2e87d4fe-81bc-11eb-0d16-b988bcedcc73
M4 = M3 .* 0

# ╔═╡ cde79f38-f5d6-11ea-3297-0b5b240f7b9e
Dump(sparse(M4))

# ╔═╡ aa09c008-f5d8-11ea-1bdc-b51ee6eb2478
sparse(M4)

# ╔═╡ 62a6ec62-f5d9-11ea-071e-ed33c5dea0cd
md"""# Random vectors
"""

# ╔═╡ 7f63daf6-f695-11ea-0b80-8702a83103a4
md"How much structure is there in a *random* vector?"

# ╔═╡ 67274c3c-f5d9-11ea-3475-c9d228e3bd5a
v = rand(1:9, 1_000_000)

# ╔═╡ 765c6552-f5d9-11ea-29d3-bfe7b4b04612
md"""You might guess that there is "no structure". But you can actually think of randomness itself as a structure.

For example, take the mean and standard deviation -- some would say that's the structure.

"""

# ╔═╡ 126fb3ea-f5da-11ea-2f7d-0b3259a296ce
mean(v), std(v), 5, sqrt(10 * 2/3)

# ╔═╡ ed0b2358-81ce-11eb-3339-93abcc06fd91
md"""
If you repeat the calculation, to 3 or 4 digits the mean and standard deviation don't change, and are approximately equal to the theoretical values on the right.
"""

# ╔═╡ 24ce92fa-81cf-11eb-30f0-b1e357d79d53
md"""
We can also count how many times each digit occurs in the data set:
"""

# ╔═╡ 2d4500e0-81cf-11eb-1699-d310074fddf5
[sum(v .== i) for i in 1:9]

# ╔═╡ 3546ff30-81cf-11eb-3afc-05c5db61366f
md"""
We see that each number occurs roughly the same number of times.
"""

# ╔═╡ 9b9e2c2a-f5da-11ea-369b-b513b196515b
md"Statisticians (and professors who've just graded exams) might say that under certain circumstances the mean and the variance give you the necessary structure, and the rest can be thrown away."

# ╔═╡ e68b98ea-f5da-11ea-1a9d-db45e4f80241
m = sum(v) / length(v)  # mean

# ╔═╡ f20ccac4-f5da-11ea-0e69-413b5e49f423
σ² = sum( (v .- m) .^ 2 ) / (length(v) - 1)

# ╔═╡ 12a2e96c-f5db-11ea-1c3e-494ae7446886
σ = sqrt(σ²)

# ╔═╡ 22487ce2-f5db-11ea-32e9-6f70ab2c0353
std(v)

# ╔═╡ 389ae62e-f5db-11ea-1557-c3adbbee0e5c
md"Sometimes the summary statistics are all you want. (But sometimes not.)"

# ╔═╡ 0c2b6408-f5d9-11ea-2b7f-7fece2eecc1f
md"# Multiplication tables"

# ╔═╡ 5d767290-f5dd-11ea-2189-81198fd216ce
outer(v, w) = [x * y for x ∈ v, y ∈ w]  # just a multiplication table

# ╔═╡ 587790ce-f6de-11ea-12d9-fde2a17ae314
outer(1:10, 1:10)

# ╔═╡ a39e8256-f6de-11ea-3170-c923b56609da
md"Did you memorize this in third grade?"

# ╔═╡ 8c84edd0-f6de-11ea-2180-61c6b81aac3b
@bind k Slider(1:14, show_value=true)

# ╔═╡ 22b73baa-f6df-11ea-197f-bbb4bd1a7ef5
outer(1:k, 1:k)

# ╔═╡ b2332814-f6e6-11ea-1c7d-556c7d4687f1
outer([2,4,6], [10,100,1000])

# ╔═╡ 9ab7a72e-81cf-11eb-2b78-073ff51cae58
md"""
A multiplication table is clearly a structure, but it's not sparse -- there are no zeros. Nonetheless you need much less information to reconstruct the matrix.
"""

# ╔═╡ fd8dd108-f6df-11ea-2f7c-3d99d054ac15
md"In the context of 1:k times 1:k, just one number k is needed."

# ╔═╡ 165788b2-f601-11ea-3e69-cdbbb6558e54
md"If you look at the following matrix? Does it have any structure? It's certainly more hidden."

# ╔═╡ 22941bb8-f601-11ea-1d6e-0d955297bc2e
outer( rand(3), rand(4) )  # but it's just a multiplication table

# ╔═╡ c33bf00e-81cf-11eb-1e1a-e5a879a45093
md"""
You might guess by visualizing the matrix that it is a multiplication table:
"""

# ╔═╡ 7ff664f0-f74b-11ea-0d2d-b53f19e4f4bf
md"We can factor out a multiplication table, if it's there:"

# ╔═╡ a0611eaa-81bc-11eb-1d23-c12ab14138b1
md"""
### Julia: Exceptions are thrown (generated) using `error`

An exception is anything that can interrupt a program, e.g. invalid input data.
"""

# ╔═╡ a4728944-f74b-11ea-03c3-9123908c1f8e
function factor( mult_table ) 
	v = mult_table[:, 1]
	w = mult_table[1, :]
	
	if v[1] ≠ 0 
		w /= v[1] 
	end
	
	# Good code has a check:
	if outer(v, w) ≈ mult_table
	   return v, w
	else
		error("Input is not a multiplication table")
	end
end

# ╔═╡ 05c35402-f752-11ea-2708-59cf5ef74fb4
factor( outer([1, 2, 3], [2, 2, 2] ) )

# ╔═╡ 8c11b19e-81bc-11eb-184b-bf6ffefe29de
md"""
A random 2x2 matrix is not a multiplication table. Most matrices are not given by multiplication tables.
"""

# ╔═╡ 8baaa994-f752-11ea-18d9-b3d0a6b9f7d9
factor( rand(2,2) )

# ╔═╡ d92bece4-f754-11ea-0242-99f198bb5b7b
md" Let's add two (or more) multiplication tables:"

# ╔═╡ e740999c-f754-11ea-2089-4b7a9aec6030
A = sum( outer(rand(3),rand(3)) for i=1:2 )

# ╔═╡ 0a79a7b4-f755-11ea-1b2d-21173567b257
md"Is it possible, given the matrix, to find the structure? E.g. to show that a matrix is a sum of outer products (multiplication table)."

# ╔═╡ 5adb98c2-f6e0-11ea-1fde-53b0fd6639c3
md"The answer is yes: The **Singular-Value Decomposition** (SVD) from algebra can find the structure!"

# ╔═╡ 487d6f9c-81d0-11eb-3bb0-336a4beb9b38
md"""
Let's take the SVD and calculate the sum of two outer products:
"""

# ╔═╡ 5a493052-f601-11ea-2f5f-f940412905f2
begin
	U, Σ, V = svd(A)
	
    outer( U[:, 1], V[:, 1] * Σ[1] ) + outer( U[:, 2], V[:, 2] * Σ[2] )
end

# ╔═╡ 55b76aee-81d0-11eb-0bcc-413f5bd14360
md"""
We see that we reconstruct the original matrix!"
"""

# ╔═╡ 709bf30a-f755-11ea-2e82-bd511e598c77
B = rand(3,3)

# ╔═╡ 782532b0-f755-11ea-1385-cd1a28c4b9d5
begin
	UU, ΣΣ, VV = svd( B )
    outer( UU[:,1], VV[:,1] * ΣΣ[1] ) + outer( UU[:,2], VV[:,2] * ΣΣ[2] ) 
end

# ╔═╡ 5bc4ab0a-f755-11ea-0fad-4987ad9fc02f
md"and it can approximate too!"

# ╔═╡ a5d637ea-f5de-11ea-3b70-877e876bc9c9
flag = outer([1,1,1,2,2,2,1,1,1], [1,1,1,1,1,1,1,1,1])

# ╔═╡ 21bbb60a-f5df-11ea-2c1b-dd716a657df8
cs = distinguishable_colors(100)

# ╔═╡ 2668e100-f5df-11ea-12b0-073a578a5edb
cs[flag]

# ╔═╡ e8d727f2-f5de-11ea-1456-f72602e81e0d
cs[flag + flag']

# ╔═╡ f5fcdeea-f75c-11ea-1fc3-731f0ef1ad14
outer([1,1,1,2,2,2,1,1,1], [1,1,1,1,1,1,1,1,1]) + outer([1,1,1,1,1,1,1,1,1], [1,1,1,2,2,2,1,1,1])

# ╔═╡ 0373fbf6-f75d-11ea-2a9e-cbb714d69cf4
cs[outer([1,1,1,2,2,2,1,1,1], [1,1,1,1,1,1,1,1,1]) + outer([1,1,1,1,1,1,1,1,1], [1,1,1,2,2,2,1,1,1])]

# ╔═╡ ebd72fb8-f5e0-11ea-0630-573337dff753
md"""
# Singular Value Decomposition (SVD): A tool to find structure
"""

# ╔═╡ b6478e1a-f5f6-11ea-3b92-6d4f067285f4
tree_url = "https://user-images.githubusercontent.com/6933510/110924885-d7f1b200-8322-11eb-9df7-7abf29c8db7d.png"

# ╔═╡ f2c11f88-f5f8-11ea-3e02-c1d4fa22031e
image = load(download(tree_url))

# ╔═╡ 29062f7a-f5f9-11ea-2682-1374e7694e32
picture = Float64.(channelview(image));

# ╔═╡ 5471fd30-f6e2-11ea-2cd7-7bd48c42db99
size(picture)

# ╔═╡ 6156fd1e-f5f9-11ea-06a9-211c7ab813a4
pr, pg, pb = eachslice(picture, dims=1)

# ╔═╡ a9766e68-f5f9-11ea-0019-6f9d02050521
[RGB.(pr, 0, 0) RGB.(0, pg, 0) RGB.(0, 0, pb)]

# ╔═╡ 0c0ee362-f5f9-11ea-0f75-2d2810c88d65
begin
	Ur, Σr, Vr = svd(pr)
	Ug, Σg, Vg = svd(pg)
	Ub, Σb, Vb = svd(pb)
end;

# ╔═╡ b95ce51a-f632-11ea-3a64-f7c218b9b3c9
@bind n Slider(1:200, show_value=true)

# ╔═╡ 7ba6e6a6-f5fa-11ea-2bcd-616d5a3c898b
RGB.(sum(outer(Ur[:,i], Vr[:,i]) .* Σr[i] for i in 1:n), 
	 sum(outer(Ug[:,i], Vg[:,i]) .* Σg[i] for i in 1:n),
	 sum(outer(Ub[:,i], Vb[:,i]) .* Σb[i] for i in 1:n))

# ╔═╡ 8df84fcc-f5d5-11ea-312f-bf2a3b3ce2ce
md"# Appendix"

# ╔═╡ 0edd7cca-834f-11eb-0232-ff0850027f76
md"## Syntax Learned"

# ╔═╡ 69be8194-81b7-11eb-0452-0bc8b9f22286
md"""
Syntax to be learned:

* A `struct` is a great way to embody structure.
* `dump` and `Dump`: to see what's inside a data structure.
* `Diagonal`, `sparse`
* `error` (throws an exception)
* `svd` (Singular Value Decomposition)
"""

# ╔═╡ 1c462f68-834f-11eb-1447-85848814769b
[ dump, Diagonal, error, svd]

# ╔═╡ 5813e1b2-f5ff-11ea-2849-a1def74fc065
begin
	show_image(M) = get.([ColorSchemes.rainbow], M ./ maximum(M))
	show_image(x::AbstractVector) = show_image(x')
end

# ╔═╡ 982590d4-f5ff-11ea-3802-73292c75ad6c
show_image(x)

# ╔═╡ 2f75df7e-f601-11ea-2fc2-aff4f335af33
show_image( outer( rand(10), rand(10) ))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorSchemes = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
ColorSchemes = "~3.18.0"
ColorVectorSpace = "~0.9.8"
Colors = "~0.12.8"
FileIO = "~1.14.0"
ImageIO = "~0.6.2"
ImageShow = "~0.3.4"
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "63d1e802de0c4882c00aee5cb16f9dd4d6d7c59c"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.1"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "539682309e12265fbe75de8d83560c307af975bd"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.2"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "25f7784b067f699ae4e4cb820465c174f7022972"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.4"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "aee446d0b3d5764e35289762f6a18e8ea041a592"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.11.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "e925a64b8585aa9f4e3047b8d2cdc3f0e79fd4e4"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.16"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─0db6ee04-81b7-11eb-330c-11b578b72c90
# ╟─ca1a1072-81b6-11eb-1fee-e7df687cc314
# ╟─b0ba5b8c-f5d1-11ea-1304-3f0e47f935fe
# ╠═864e1180-f693-11ea-080e-a7d5aabc9ca5
# ╟─261c4df2-f5d2-11ea-2c72-7d4b09c46098
# ╟─3cada3a0-81cc-11eb-04c8-bde26d36a84e
# ╠═fe2028ba-f6dc-11ea-0228-938a81a91ace
# ╟─8d2c6910-f5d4-11ea-1928-1baf09815687
# ╟─54649792-81cc-11eb-1038-9161a4037acf
# ╠═0a902426-f6dd-11ea-0ae4-fb0c47863fe7
# ╟─4794e860-81b7-11eb-2c91-8561c20f308a
# ╟─67827da8-81cc-11eb-300e-278104d2d958
# ╠═4624cd26-f5d3-11ea-1cf8-7d6555eae5fa
# ╟─9bdabef8-81cc-11eb-14a1-67a9a7d968c0
# ╠═397ac764-f5fe-11ea-20cc-8d7cab19d410
# ╟─a22dcd2c-81cc-11eb-1252-13ace134192d
# ╠═82c7046c-f5d3-11ea-04e2-ef7c0f4db5da
# ╟─b024c318-81cc-11eb-018c-e1f7830ff51b
# ╠═93bfe3ac-f756-11ea-20fb-8f7d586b42f3
# ╠═175039aa-f758-11ea-251a-5db57d7c4b32
# ╠═c2a4b0a2-81cc-11eb-37a7-db601a6ddfdf
# ╟─c5ed7d3e-81cc-11eb-3386-15b72db8155d
# ╟─e2e354a8-81b7-11eb-311a-35151063c2a7
# ╟─dc5a96ba-81cc-11eb-3189-25920df48afa
# ╠═af0d3c22-f756-11ea-37d6-11b630d2314a
# ╟─06e3a842-26b8-4417-9cf5-8a083ccdb264
# ╠═91172a3e-81b7-11eb-0953-9f5e0207f863
# ╠═4bbf3f58-f788-11ea-0d24-6b0fb070829e
# ╟─fe70d104-81b7-11eb-14d0-eb5237d8ea6c
# ╟─ef8f44b2-f5fc-11ea-1e4d-bd873cd39d6c
# ╟─fd9211c0-f5fc-11ea-1745-7f2dae88af9e
# ╠═f1154df8-f693-11ea-3b16-f32835fcc470
# ╠═982590d4-f5ff-11ea-3802-73292c75ad6c
# ╟─81c35324-f5d4-11ea-2338-9f982d38732c
# ╟─2cfda0dc-f5d5-11ea-16c4-b5a33b90e37f
# ╠═150432d4-f5d5-11ea-32b2-19a2a91d9637
# ╟─44215aa4-f695-11ea-260e-b564c6fbcd4a
# ╠═21328d1c-f5d5-11ea-288e-4171ad35326d
# ╟─75761cc0-81cd-11eb-1186-7d47debd68ca
# ╟─6bd8a886-f758-11ea-2587-870a3fa9d710
# ╟─4c533ac6-f695-11ea-3724-b955eaaeee49
# ╠═466901ea-f5d5-11ea-1db5-abf82c96eabf
# ╠═b38c4aae-f5d5-11ea-39b6-7b0c7d529019
# ╟─93e04ed8-81cd-11eb-214a-a761ef8c406f
# ╟─e90c55fc-f5d5-11ea-10f1-470ff772985d
# ╟─19775c3c-f5d6-11ea-15c2-89618e654a1e
# ╟─653792a8-f695-11ea-1ae0-43761c502583
# ╠═79c94d2a-f75a-11ea-031d-09d70d229e15
# ╟─10bc5d50-81b9-11eb-2ac7-354a6c6c826b
# ╠═77d6a952-81ba-11eb-24e3-cb6510a59455
# ╟─1f3ba55a-81b9-11eb-001f-593b9d8639ca
# ╠═3d4a702e-f75a-11ea-031c-333d591fc442
# ╟─80ff4010-81bb-11eb-374e-215a57defb0b
# ╠═5de72b7c-f5d6-11ea-1b6f-35b830b5fb34
# ╠═8b60629e-f5d6-11ea-27c8-d934460d3a57
# ╠═2fd7e52e-f5d7-11ea-3b5a-1f338e2451e0
# ╠═2e87d4fe-81bc-11eb-0d16-b988bcedcc73
# ╠═cde79f38-f5d6-11ea-3297-0b5b240f7b9e
# ╠═aa09c008-f5d8-11ea-1bdc-b51ee6eb2478
# ╟─62a6ec62-f5d9-11ea-071e-ed33c5dea0cd
# ╟─7f63daf6-f695-11ea-0b80-8702a83103a4
# ╠═67274c3c-f5d9-11ea-3475-c9d228e3bd5a
# ╟─765c6552-f5d9-11ea-29d3-bfe7b4b04612
# ╠═126fb3ea-f5da-11ea-2f7d-0b3259a296ce
# ╟─ed0b2358-81ce-11eb-3339-93abcc06fd91
# ╟─24ce92fa-81cf-11eb-30f0-b1e357d79d53
# ╠═2d4500e0-81cf-11eb-1699-d310074fddf5
# ╟─3546ff30-81cf-11eb-3afc-05c5db61366f
# ╟─9b9e2c2a-f5da-11ea-369b-b513b196515b
# ╠═e68b98ea-f5da-11ea-1a9d-db45e4f80241
# ╠═f20ccac4-f5da-11ea-0e69-413b5e49f423
# ╠═12a2e96c-f5db-11ea-1c3e-494ae7446886
# ╠═22487ce2-f5db-11ea-32e9-6f70ab2c0353
# ╟─389ae62e-f5db-11ea-1557-c3adbbee0e5c
# ╟─0c2b6408-f5d9-11ea-2b7f-7fece2eecc1f
# ╠═5d767290-f5dd-11ea-2189-81198fd216ce
# ╠═587790ce-f6de-11ea-12d9-fde2a17ae314
# ╟─a39e8256-f6de-11ea-3170-c923b56609da
# ╠═8c84edd0-f6de-11ea-2180-61c6b81aac3b
# ╠═22b73baa-f6df-11ea-197f-bbb4bd1a7ef5
# ╠═b2332814-f6e6-11ea-1c7d-556c7d4687f1
# ╟─9ab7a72e-81cf-11eb-2b78-073ff51cae58
# ╟─fd8dd108-f6df-11ea-2f7c-3d99d054ac15
# ╟─165788b2-f601-11ea-3e69-cdbbb6558e54
# ╠═22941bb8-f601-11ea-1d6e-0d955297bc2e
# ╟─c33bf00e-81cf-11eb-1e1a-e5a879a45093
# ╠═2f75df7e-f601-11ea-2fc2-aff4f335af33
# ╟─7ff664f0-f74b-11ea-0d2d-b53f19e4f4bf
# ╟─a0611eaa-81bc-11eb-1d23-c12ab14138b1
# ╠═a4728944-f74b-11ea-03c3-9123908c1f8e
# ╠═05c35402-f752-11ea-2708-59cf5ef74fb4
# ╟─8c11b19e-81bc-11eb-184b-bf6ffefe29de
# ╠═8baaa994-f752-11ea-18d9-b3d0a6b9f7d9
# ╟─d92bece4-f754-11ea-0242-99f198bb5b7b
# ╠═e740999c-f754-11ea-2089-4b7a9aec6030
# ╟─0a79a7b4-f755-11ea-1b2d-21173567b257
# ╟─5adb98c2-f6e0-11ea-1fde-53b0fd6639c3
# ╟─487d6f9c-81d0-11eb-3bb0-336a4beb9b38
# ╟─5a493052-f601-11ea-2f5f-f940412905f2
# ╟─55b76aee-81d0-11eb-0bcc-413f5bd14360
# ╠═709bf30a-f755-11ea-2e82-bd511e598c77
# ╠═782532b0-f755-11ea-1385-cd1a28c4b9d5
# ╟─5bc4ab0a-f755-11ea-0fad-4987ad9fc02f
# ╠═a5d637ea-f5de-11ea-3b70-877e876bc9c9
# ╠═21bbb60a-f5df-11ea-2c1b-dd716a657df8
# ╠═2668e100-f5df-11ea-12b0-073a578a5edb
# ╠═e8d727f2-f5de-11ea-1456-f72602e81e0d
# ╠═f5fcdeea-f75c-11ea-1fc3-731f0ef1ad14
# ╠═0373fbf6-f75d-11ea-2a9e-cbb714d69cf4
# ╟─ebd72fb8-f5e0-11ea-0630-573337dff753
# ╠═b6478e1a-f5f6-11ea-3b92-6d4f067285f4
# ╠═f2c11f88-f5f8-11ea-3e02-c1d4fa22031e
# ╠═29062f7a-f5f9-11ea-2682-1374e7694e32
# ╠═5471fd30-f6e2-11ea-2cd7-7bd48c42db99
# ╠═6156fd1e-f5f9-11ea-06a9-211c7ab813a4
# ╠═a9766e68-f5f9-11ea-0019-6f9d02050521
# ╠═0c0ee362-f5f9-11ea-0f75-2d2810c88d65
# ╠═b95ce51a-f632-11ea-3a64-f7c218b9b3c9
# ╠═7ba6e6a6-f5fa-11ea-2bcd-616d5a3c898b
# ╟─8df84fcc-f5d5-11ea-312f-bf2a3b3ce2ce
# ╟─0edd7cca-834f-11eb-0232-ff0850027f76
# ╟─69be8194-81b7-11eb-0452-0bc8b9f22286
# ╠═1c462f68-834f-11eb-1447-85848814769b
# ╟─5813e1b2-f5ff-11ea-2849-a1def74fc065
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
