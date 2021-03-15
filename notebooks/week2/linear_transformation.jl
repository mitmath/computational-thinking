### A Pluto.jl notebook ###
# v0.14.0

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

# ╔═╡ 6b473b2d-4326-46b4-af38-07b61de287fc
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		Pkg.PackageSpec(name="ImageIO", version="0.5"),
		Pkg.PackageSpec(name="ImageShow", version="0.2"),
		Pkg.PackageSpec(name="FileIO", version="1.6"),
		Pkg.PackageSpec(name="PNGFiles", version="0.3.6"),
		Pkg.PackageSpec(name="Colors", version="0.12"),
		Pkg.PackageSpec(name="ColorVectorSpace", version="0.8"),
		Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
		Pkg.PackageSpec(name="HypertextLiteral", version="0.5")
	])

	using Colors, ColorVectorSpace, ImageShow, FileIO
	using PlutoUI
	using HypertextLiteral
	using LinearAlgebra
end

# ╔═╡ 2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

# ╔═╡ 60532aa0-740c-11eb-0402-af8ff117f042
md"Show grid lines $(@bind show_grid CheckBox(default=true))"

# ╔═╡ 35904b8e-7a28-4dbc-bbf9-b45da448452c
let

	range = -2:.1:2
	md"""
	
	a $(@bind a Slider(range; default=1.0, show_value=true))
	
	b $(@bind b Slider(range; default=0.0, show_value=true))
	
	c $(@bind c Slider(range; default=0.0, show_value=true))
	
	d $(@bind d Slider(range; default=1.0, show_value=true))
	
	**Re-run this cell to reset to identity transformation**
	"""
end

# ╔═╡ f085296d-48b1-4db6-bb87-db863bb54049
A = [
	a b
	c d
	]

# ╔═╡ d1757b2c-7400-11eb-1406-d937294d5388
md"**_Det(A)_ = $a * $d - $c * $b =  $(det(A))**"

# ╔═╡ c536dafb-4206-4689-ad6d-6935385d8fdf
md"""
## Appendix
"""

# ╔═╡ fb509fb4-9608-421d-9c40-a4375f459b3f
det_A = det(A)

# ╔═╡ 0ec60f6e-7627-11eb-17e5-f965a81f3545
if det_A != 0
	invA = inv(A)
end

# ╔═╡ 40655bcc-6d1e-4d1e-9726-41eab98d8472
img_sources = [
	"https://user-images.githubusercontent.com/6933510/108605549-fb28e180-73b4-11eb-8520-7e29db0cc965.png" => "Corgis",
	"https://user-images.githubusercontent.com/6933510/108883855-39690f80-7606-11eb-8eb1-e595c6c8d829.png" => "Arrows",
	"https://images.squarespace-cdn.com/content/v1/5cb62a904d546e33119fa495/1589302981165-HHQ2A4JI07C43294HVPD/ke17ZwdGBToddI8pDm48kA7bHnZXCqgRu4g0_U7hbNpZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PISCdr-3EAHMyS8K84wLA7X0UZoBreocI4zSJRMe1GOxcKMshLAGzx4R3EDFOm1kBS/fluffy+corgi?format=2500w" => "Alan"
]

# ╔═╡ c0c90fec-0e55-4be3-8ea2-88b8705ee258
md"""
### Choose an image:

$(@bind img_source Select(img_sources))
"""

# ╔═╡ 4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
img_original = load(download(img_source));

# ╔═╡ 52a8009e-761c-11eb-2dc9-dbccdc5e7886
typeof(img_original)

# ╔═╡ 7d0096ad-d89a-4ade-9679-6ee95f7d2044
function trygetpixel(img::AbstractMatrix, x::Float64, y::Float64)
	rows, cols = size(img)
	
	"The linear map [-1,1] ↦ [0,1]"
	f = t -> (t - -1.0)/(1.0 - -1.0)
	
	i = floor(Int, rows * f(-y))
	j = floor(Int, cols * f(x * (rows / cols)))
 
	if 1 < i ≤ rows && 1 < j ≤ cols
		img[i,j]
	else
		zero(eltype(img))
	end
end

# ╔═╡ 83d45d42-7406-11eb-2a9c-e75efe62b12c
function with_gridlines(img::Array{<:Any,2}; n=8)
	
	sep_i = size(img, 1) ÷ n
	sep_j = size(img, 2) ÷ n
	
	result = copy(img)
	# stroke = zero(eltype(img))#RGBA(RGB(1,1,1), 0.75)
	
	stroke = RGBA(1, 1, 1, 0.75)
	
	result[1:sep_i:end, :] .= stroke
	result[:, 1:sep_j:end] .= stroke

	# a second time, to create a line 2 pixels wide
	result[2:sep_i:end, :] .= stroke
	result[:, 2:sep_j:end] .= stroke
	
	return result
end

# ╔═╡ 55898e88-36a0-4f49-897f-e0850bd2b0df
img = if show_grid
	with_gridlines(img_original)
else
	img_original
end;

# ╔═╡ 8e0505be-359b-4459-9de3-f87ec7b60c23
[
	if det_A == 0
		RGB(1.0, 1.0, 1.0)
	else
		in_x, in_y = invA*[out_x, out_y]
		trygetpixel(img, in_x, in_y)
	end
	
	for out_y in LinRange(2, -2, 300),
		out_x in LinRange(-2, 2, 300)
]

# ╔═╡ Cell order:
# ╠═6b473b2d-4326-46b4-af38-07b61de287fc
# ╟─2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
# ╟─c0c90fec-0e55-4be3-8ea2-88b8705ee258
# ╟─60532aa0-740c-11eb-0402-af8ff117f042
# ╠═8e0505be-359b-4459-9de3-f87ec7b60c23
# ╠═35904b8e-7a28-4dbc-bbf9-b45da448452c
# ╟─f085296d-48b1-4db6-bb87-db863bb54049
# ╟─d1757b2c-7400-11eb-1406-d937294d5388
# ╟─c536dafb-4206-4689-ad6d-6935385d8fdf
# ╟─fb509fb4-9608-421d-9c40-a4375f459b3f
# ╟─0ec60f6e-7627-11eb-17e5-f965a81f3545
# ╟─40655bcc-6d1e-4d1e-9726-41eab98d8472
# ╠═4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
# ╠═52a8009e-761c-11eb-2dc9-dbccdc5e7886
# ╠═55898e88-36a0-4f49-897f-e0850bd2b0df
# ╠═7d0096ad-d89a-4ade-9679-6ee95f7d2044
# ╠═83d45d42-7406-11eb-2a9c-e75efe62b12c
