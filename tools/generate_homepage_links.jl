### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 6b119ccd-03c4-4a21-b263-e848c555c418
using HypertextLiteral

# ╔═╡ 11516757-8963-432e-89cd-d38574c4e566
module Loaded
include("./types.jl")
include("./book_model.jl")
end

# ╔═╡ 8456489f-bced-48b1-8b51-049c746988d0
book_model = Loaded.book_model

# ╔═╡ b5eaabee-6c96-4aca-a1d4-90383f005d1f
without_dotjl(path) = splitext(path)[1]

# ╔═╡ 42478294-047b-48db-a770-ff6446706654
@htl("""$((let
	notebook_name = basename(without_dotjl(section.notebook_path))
    @htl """
    <a class="no-decoration" href="../$notebook_name/">
		<h3>$(section.name)</h3>
		<img src=$(section.preview_image_url)>
	</a>
	"""
	
end
for section in book_model if (section isa Loaded.Section && !isempty(section.preview_image_url))))""") |> clipboard

# ╔═╡ a835d318-6b9b-406a-9ee1-bc5b06c1348c
@htl """
<style>
</style>"""

# ╔═╡ 254e3078-ac08-47ac-8c59-5ade21561895
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"
"""

# ╔═╡ Cell order:
# ╠═11516757-8963-432e-89cd-d38574c4e566
# ╠═8456489f-bced-48b1-8b51-049c746988d0
# ╠═b5eaabee-6c96-4aca-a1d4-90383f005d1f
# ╠═6b119ccd-03c4-4a21-b263-e848c555c418
# ╠═42478294-047b-48db-a770-ff6446706654
# ╠═a835d318-6b9b-406a-9ee1-bc5b06c1348c
# ╠═254e3078-ac08-47ac-8c59-5ade21561895
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
