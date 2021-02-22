### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ 2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

# ╔═╡ 6b473b2d-4326-46b4-af38-07b61de287fc
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Images", version="0.22.4"), 
			Pkg.PackageSpec(name="ImageMagick", version="0.7"), 
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="HypertextLiteral", version="0.5")
			])

	using Images
	using PlutoUI
	using HypertextLiteral
	using LinearAlgebra
end

# ╔═╡ 4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
img = load(download("https://user-images.githubusercontent.com/6933510/108605549-fb28e180-73b4-11eb-8520-7e29db0cc965.png"));

# ╔═╡ 83d45d42-7406-11eb-2a9c-e75efe62b12c
function add_grids(img::Array{RGBA{Normed{UInt8,8}},2}; sep=50)
	res_img = copy(img)
	stroke = RGBA(1,1,1, 0.75)
	rows, cols = size(res_img)
	i = 0
	while rows÷2 + i*sep < rows
		res_img[rows÷2 + i*sep, :] .= stroke
		res_img[rows÷2 - i*sep, :] .= stroke
		i+=1
	end
	i = 0
	while cols÷2 + i*sep < cols
		res_img[:, cols÷2 + i*sep] .= stroke
		res_img[:, cols÷2 - i*sep] .= stroke
		i+=1
	end
	return res_img
end

# ╔═╡ adbc5fd4-747d-11eb-03d5-c1301894aa1f


# ╔═╡ 6b558238-6283-4583-9940-6da64000c1c6
function trygetpixel(A::AbstractMatrix, i::Int, j::Int)
	rows, cols = size(A)
	if 1 ≤ i ≤ rows && 1 ≤ j ≤ cols
		A[i,j]
	else
		zero(eltype(img))
	end
end

# ╔═╡ f1076e9a-1310-4896-a57c-ed729015ca10
function trygetpixel(A::AbstractMatrix, i::Real, j::Real)
	trygetpixel(A, floor(Int, i), floor(Int, j))
end

# ╔═╡ 60532aa0-740c-11eb-0402-af8ff117f042
md"Add grid lines $(@bind grid_add CheckBox(default=true))"

# ╔═╡ 6d5f9486-740c-11eb-1852-31b6b53654c1
begin
	if grid_add
		comp_img = add_grids(img)
	else
		comp_img = img
	end
	nothing
end

# ╔═╡ 35904b8e-7a28-4dbc-bbf9-b45da448452c
let

	range = -1.5:.01:2
	md"""
	 $(@bind a11 Slider(range; default=1.0, show_value=true))
	
	Scale along the _first dimension_
	
	$(@bind a12 Slider(range; default=0.0, show_value=true))
	
	Shear along the _first dimension_
	
	$(@bind a21 Slider(range; default=0.0, show_value=true))
	
	Scale along the _second dimension_
	
	$(@bind a22 Slider(range; default=1.0, show_value=true))
	
	Shear along the _second dimension_
	
	**Re-run this cell to reset to identity transformation**
	"""
end

# ╔═╡ f085296d-48b1-4db6-bb87-db863bb54049
A = [
	a11 a12
	a21 a22
	]

# ╔═╡ d1757b2c-7400-11eb-1406-d937294d5388
md"**_Det(A)_ = $a11 \* $a22 - $a12 * $a21 =  $(det(A))**"

# ╔═╡ 772d54a1-46a4-43a7-a40b-3d190208e242
res = map(CartesianIndices(comp_img)) do I
	new_coord = pinv(A)*collect(Tuple(I))
	trygetpixel(comp_img, new_coord...)
end

# ╔═╡ 52d8735e-7488-11eb-0e61-2d669af3bc7b
@bind α Slider(0:.01:1 , show_value=true)

# ╔═╡ e239116c-7487-11eb-3d85-65393aa06960
img2 = reverse(img, dims=1)

# ╔═╡ c932e288-7487-11eb-1fac-0348f2d3daf2
 (img .* α   .+ img2 .* (1-α)) 

# ╔═╡ Cell order:
# ╠═6b473b2d-4326-46b4-af38-07b61de287fc
# ╟─2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
# ╠═4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
# ╠═83d45d42-7406-11eb-2a9c-e75efe62b12c
# ╠═adbc5fd4-747d-11eb-03d5-c1301894aa1f
# ╠═6b558238-6283-4583-9940-6da64000c1c6
# ╠═f1076e9a-1310-4896-a57c-ed729015ca10
# ╠═60532aa0-740c-11eb-0402-af8ff117f042
# ╟─6d5f9486-740c-11eb-1852-31b6b53654c1
# ╟─35904b8e-7a28-4dbc-bbf9-b45da448452c
# ╟─f085296d-48b1-4db6-bb87-db863bb54049
# ╟─d1757b2c-7400-11eb-1406-d937294d5388
# ╠═772d54a1-46a4-43a7-a40b-3d190208e242
# ╠═52d8735e-7488-11eb-0e61-2d669af3bc7b
# ╠═c932e288-7487-11eb-1fac-0348f2d3daf2
# ╠═e239116c-7487-11eb-3d85-65393aa06960
