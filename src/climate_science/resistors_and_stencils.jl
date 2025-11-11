### A Pluto.jl notebook ###
# v0.19.45

#> [frontmatter]
#> chapter = 3
#> video = "https://www.youtube.com/watch?v=DdTWgBlDgr0"
#> image = "https://user-images.githubusercontent.com/6933510/136200635-33c007ff-89f6-48dc-b1d3-eb56fd16003e.gif"
#> section = 8
#> order = 8
#> title = "Resistors, stencils and climate models"
#> layout = "layout.jlhtml"
#> youtube_id = "DdTWgBlDgr0"
#> description = ""
#> tags = ["lecture", "module3", "PDE", "differential equation", "ghost cell", "boundary condition", "climate", "modeling", "track_climate", "track_math", "stencil"]

using Markdown
using InteractiveUtils

# ╔═╡ 89b4bb1b-0d49-4cf2-9013-3d320711577f
using PlutoUI, OffsetArrays

# ╔═╡ 7e939280-ccb3-4d64-8799-82630fbb7811
TableOfContents()

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

<script src="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.4/src/lite-yt-embed.js" integrity="sha256-UyTkvYZC/3h/rCA7QBuOG/oGQCKOOJ4WOotzj/Dd70Y=" crossorigin="anonymous" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.4/src/lite-yt-embed.css" integrity="sha256-w5MMSroouA6UcvWn3fonDvoZPvDX3dhQM0Vltk00dPs=" crossorigin="anonymous">

<lite-youtube videoid=UKG-xk2F3Ak params="modestbranding=1&rel=0"></lite-youtube>
"""

# ╔═╡ ea8801ad-275e-4cb8-b383-e2d80fb920ec
md"""
# Stencils (first 2.5 minutes or so)

Don't miss the fun video effects!  
"""

# ╔═╡ c9c62724-4c0e-4858-9419-828289ec1f45
html"""

<script src="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.4/src/lite-yt-embed.js" integrity="sha256-UyTkvYZC/3h/rCA7QBuOG/oGQCKOOJ4WOotzj/Dd70Y=" crossorigin="anonymous" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.4/src/lite-yt-embed.css" integrity="sha256-w5MMSroouA6UcvWn3fonDvoZPvDX3dhQM0Vltk00dPs=" crossorigin="anonymous">

<lite-youtube videoid=sbqPVPLHl5Q params="modestbranding=1&rel=0&end=180"></lite-youtube>
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


<script src="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.4/src/lite-yt-embed.js" integrity="sha256-UyTkvYZC/3h/rCA7QBuOG/oGQCKOOJ4WOotzj/Dd70Y=" crossorigin="anonymous" defer></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lite-youtube-embed@0.3.4/src/lite-yt-embed.css" integrity="sha256-w5MMSroouA6UcvWn3fonDvoZPvDX3dhQM0Vltk00dPs=" crossorigin="anonymous">

<lite-youtube videoid=mOJ0jABAhq4 params="modestbranding=1&rel=0"></lite-youtube>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
OffsetArrays = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
OffsetArrays = "~1.14.1"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[OffsetArrays]]
git-tree-sha1 = "1a27764e945a152f7ca7efa04de513d473e9542e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.1"

    [OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

    [OffsetArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
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
