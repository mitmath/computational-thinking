### A Pluto.jl notebook ###
# v0.16.0

using Markdown
using InteractiveUtils

# ╔═╡ 89b4bb1b-0d49-4cf2-9013-3d320711577f
using PlutoUI, OffsetArrays

# ╔═╡ 8c1de468-b339-11eb-2c9a-fb5d7065bf78
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
"><em>Section 3.8</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Resistors, stencils and climate models </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/DdTWgBlDgr0" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 7e939280-ccb3-4d64-8799-82630fbb7811
TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)

# ╔═╡ 8b3da08b-d900-4736-955a-d25f8c7b70a9
md"""
Julia
* `CartesianIndex`
* `OffsetArray` from `OffsetArrays`
"""

# ╔═╡ 1945c286-c9a3-41f0-b3dc-e3a7c10334ab
md"""
#  Resistors, Equilibrium, and Poisson's equation. (17:48 minute video)
"""

# ╔═╡ 87ff0226-a249-419d-bd86-62331be6a538
md"""
This video is really about the interaction of the discrete and the continuous.
We set up a grid of resistor problem, and we show that solving this problem is the discretized version of solving a partial differential equation
known as Poisson's equation.

There are some references to fall 2020 which date this lecture, including
a reference to the Biden/Trump election, and a reference to John Urschel's lecture
which some of you might want to check out:

[John Urschel's video](https://youtu.be/rRCGNvMdLEY)
"""

# ╔═╡ a4d5fe96-5fed-4c26-b3ad-7637246cbb87
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/UKG-xk2F3Ak" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ ea8801ad-275e-4cb8-b383-e2d80fb920ec
md"""
# Stencils (first 2.5 minutes or so)

Don't miss the fun video effects!  
"""

# ╔═╡ c9c62724-4c0e-4858-9419-828289ec1f45
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/sbqPVPLHl5Q" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ d0c01582-8499-4458-894c-cb23cf31094f
md"""
In the remainder of this notebook, we will show how to set up ghost cells in Julia so as to be able to apply a stencil.
"""

# ╔═╡ b1148b31-fb3b-434d-984f-dfc439c0e5c7
md"""
# Cartesian Indices
"""

# ╔═╡ fff37e11-d618-4271-b48c-12b7d1ef8472
md"""
Grab a 6x7 matrix that we'd like to apply a stencil to.
"""

# ╔═╡ afa4a77e-28fc-11eb-1ab0-bbba1b653e46
data = rand(1:9,6,7)

# ╔═╡ 17b7f5e6-83d5-43e0-8b56-93e67e3af747
md"""
A "Cartesian index" lets you access an element with one index variable:
"""

# ╔═╡ e970a572-12f6-4b72-8a60-5cd70e1b7260
i = CartesianIndex(2,3)

# ╔═╡ 2a0c666f-f3fa-49ab-8ffc-45323e7cba15
data[i]

# ╔═╡ af8c6b1e-5f72-4547-bd9f-1a1fc7264dc8
md"""
Obtain all the Cartesian Indices of your data matrix.
"""

# ╔═╡ 0019e726-28fd-11eb-0e86-31ec28b3c1a9
I = CartesianIndices(data)

# ╔═╡ 681c3d00-2f1e-4a84-b67e-c14fffbe2549
Dump(I)

# ╔═╡ e4e51762-7010-4afe-9599-3746acbe9143
md"""
# Offset Arrays
"""

# ╔═╡ 4d03b75f-e43a-484b-8020-43244b7700d5
md"""
An offset array lets you index in ways other than the standard 1:m, 1:n
"""

# ╔═╡ 5fb6e7b6-2901-11eb-0e94-aba290fd0bae
A = OffsetArray(zeros(Int,8,9), 0:7 ,0:8)

# ╔═╡ 87c260a2-2901-11eb-1060-b1e4b6b5b02b
for i ∈ I
	A[i] = data[i]  # copy data
end

# ╔═╡ a5c7693a-2901-11eb-1083-0da8138a73c2
A

# ╔═╡ f2903f3f-9697-4cac-af87-b2cfee362638
A[1,1]

# ╔═╡ 4fb21151-fc95-40e2-b2b7-7d0a05c5a60a
A[0,0]

# ╔═╡ 52c8ec62-0d04-4945-a08f-3dd1cffd5395
A[I].=data[I]

# ╔═╡ 423f22c0-336a-4640-bbd2-2649e6021de6
md"""
# Neighborhood: a 3x3 window built from Cartesian Indices
"""

# ╔═╡ b6fde83c-2901-11eb-0e3b-4b3766579cc8
neighborhood = CartesianIndices((-1:1, -1:1))

# ╔═╡ 0eacc41c-89f7-4c11-b727-1769a6e7f5d5
md"""
Grab all the neighborhoods of `A`.
"""

# ╔═╡ babe3c24-2901-11eb-2d30-51256eb97e11
[ A[i.+neighborhood] for i ∈ I]

# ╔═╡ 7bd3671d-e59d-4d04-a60c-4524b2057972
md"""
# Stencil
"""

# ╔═╡ e6bd9dea-2901-11eb-1100-ad10705f41cc
stencil =  [ 0  -1   0
            -1   4  -1
            0  -1   0]

# ╔═╡ fe4f6df0-2901-11eb-1945-27e3f041ed1f
[  sum(A[i.+neighborhood].*stencil) for i ∈ I]

# ╔═╡ 48374720-6c79-4c2b-8b81-86565cbf19a2
md"""
Notice the result is the same size as the original data, and the stencil
"worked" on the edges.
"""

# ╔═╡ a7615570-0826-4ef1-80b2-da21c0c640b6
md"""
# Other boundary conditions.
We just saw 0 boundary conditions, what about periodic or zero derivative?
"""

# ╔═╡ 77c06ce6-2902-11eb-30a7-51f210dbd723
begin
 B = copy(A)
	
 B[0,:] = B[6,:]  ## periodic
 B[7,:] = B[1,:]
 B[:,0] = B[:,7]
 B[:,8] = B[:,1]
	
	
 # B[0,:] = B[1,:]  ## zero derivative
 # B[7,:] = B[7:]
 # B[:,0] = B[:,1]
 # B[:,8] = B[:,7]
		
 B
end

# ╔═╡ 4f342744-2902-11eb-1401-55e770d9d751

for i∈I
	B[i] = sum(A[i.+neighborhood].*stencil)
end


# ╔═╡ 6223e374-2902-11eb-3bb2-4d2d0d352801
B

# ╔═╡ e107dc1b-ee6d-46ea-9ce3-2a7ff79739dd
md"""
# Climate Models in the Real World
"""

# ╔═╡ f9c4c5d5-6c5f-4443-8a92-bdaddf1d5cb9
md"""
(play from t=28:122,330:1200)
"""

# ╔═╡ 9ac4218a-b71f-448c-a375-3969e15dfb86
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/mOJ0jABAhq4?start=28" width=400 height=250 frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
OffsetArrays = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
OffsetArrays = "~1.10.6"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "c870a0d713b51e4b49be6432eff0e26a4325afee"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.6"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─8c1de468-b339-11eb-2c9a-fb5d7065bf78
# ╠═89b4bb1b-0d49-4cf2-9013-3d320711577f
# ╠═7e939280-ccb3-4d64-8799-82630fbb7811
# ╟─8b3da08b-d900-4736-955a-d25f8c7b70a9
# ╟─1945c286-c9a3-41f0-b3dc-e3a7c10334ab
# ╟─87ff0226-a249-419d-bd86-62331be6a538
# ╟─a4d5fe96-5fed-4c26-b3ad-7637246cbb87
# ╟─ea8801ad-275e-4cb8-b383-e2d80fb920ec
# ╟─c9c62724-4c0e-4858-9419-828289ec1f45
# ╟─d0c01582-8499-4458-894c-cb23cf31094f
# ╟─b1148b31-fb3b-434d-984f-dfc439c0e5c7
# ╟─fff37e11-d618-4271-b48c-12b7d1ef8472
# ╠═afa4a77e-28fc-11eb-1ab0-bbba1b653e46
# ╟─17b7f5e6-83d5-43e0-8b56-93e67e3af747
# ╠═e970a572-12f6-4b72-8a60-5cd70e1b7260
# ╠═2a0c666f-f3fa-49ab-8ffc-45323e7cba15
# ╟─af8c6b1e-5f72-4547-bd9f-1a1fc7264dc8
# ╠═0019e726-28fd-11eb-0e86-31ec28b3c1a9
# ╠═681c3d00-2f1e-4a84-b67e-c14fffbe2549
# ╟─e4e51762-7010-4afe-9599-3746acbe9143
# ╟─4d03b75f-e43a-484b-8020-43244b7700d5
# ╠═5fb6e7b6-2901-11eb-0e94-aba290fd0bae
# ╠═87c260a2-2901-11eb-1060-b1e4b6b5b02b
# ╠═a5c7693a-2901-11eb-1083-0da8138a73c2
# ╠═f2903f3f-9697-4cac-af87-b2cfee362638
# ╠═4fb21151-fc95-40e2-b2b7-7d0a05c5a60a
# ╠═52c8ec62-0d04-4945-a08f-3dd1cffd5395
# ╟─423f22c0-336a-4640-bbd2-2649e6021de6
# ╠═b6fde83c-2901-11eb-0e3b-4b3766579cc8
# ╟─0eacc41c-89f7-4c11-b727-1769a6e7f5d5
# ╠═babe3c24-2901-11eb-2d30-51256eb97e11
# ╟─7bd3671d-e59d-4d04-a60c-4524b2057972
# ╠═e6bd9dea-2901-11eb-1100-ad10705f41cc
# ╠═fe4f6df0-2901-11eb-1945-27e3f041ed1f
# ╟─48374720-6c79-4c2b-8b81-86565cbf19a2
# ╟─a7615570-0826-4ef1-80b2-da21c0c640b6
# ╠═77c06ce6-2902-11eb-30a7-51f210dbd723
# ╠═4f342744-2902-11eb-1401-55e770d9d751
# ╠═6223e374-2902-11eb-3bb2-4d2d0d352801
# ╟─e107dc1b-ee6d-46ea-9ce3-2a7ff79739dd
# ╟─f9c4c5d5-6c5f-4443-8a92-bdaddf1d5cb9
# ╟─9ac4218a-b71f-448c-a375-3969e15dfb86
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
