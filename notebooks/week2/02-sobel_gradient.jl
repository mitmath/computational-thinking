### A Pluto.jl notebook ###
# v0.11.10

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

# ╔═╡ 15a4ba3e-f0d1-11ea-2ef1-5ff1dee8795f
using Pkg

# ╔═╡ 21e744b8-f0d1-11ea-2e09-7ffbcdf43c37
begin
	Pkg.activate(mktempdir())
	
	Pkg.add("Gadfly")
	Pkg.add("Compose")
	Pkg.add("Statistics")
	Pkg.add("Hyperscript")
	Pkg.add("Colors")
	Pkg.add("Images")
	Pkg.add("ImageMagick")
	Pkg.add("ImageFiltering")
	
	using Gadfly
	using Images
	using Compose
	using Hyperscript
	using Colors
	using Statistics
	using PlutoUI
	using ImageMagick
	using ImageFiltering
end

# ╔═╡ 1ab1c808-f0d1-11ea-03a7-e9854427d45f


# ╔═╡ 10f850fc-f0d1-11ea-2a58-2326a9ea1e2a
set_default_plot_size(12cm, 12cm)

# ╔═╡ 7b4d5270-f0d3-11ea-0b48-79005f20602c
function convolve(M, kernel)
    height, width = size(kernel)
    
    half_height = height ÷ 2
    half_width = width ÷ 2
    
    new_image = similar(M)
	
    # (i, j) loop over the original image
	m, n = size(M)
    @inbounds for i in 1:m
        for j in 1:n
            # (k, l) loop over the neighbouring pixels
			accumulator = 0 * M[1, 1]
			for k in -half_height:-half_height + height - 1
				for l in -half_width:-half_width + width - 1
					Mi = i - k
					Mj = j - l
					# First index into M
					if Mi < 1
						Mi = 1
					elseif Mi > m
						Mi = m
					end
					# Second index into M
					if Mj < 1
						Mj = 1
					elseif Mj > n
						Mj = n
					end
					
					accumulator += kernel[k, l] * M[Mi, Mj]
				end
			end
			new_image[i, j] = accumulator
        end
    end
    
    return new_image
end

# ╔═╡ 6fd3b7a4-f0d3-11ea-1f26-fb9740cd16e0
function disc(n, r1=0.8, r2=0.8)
	white = RGB{Float64}(1,1,1)
	blue = RGB{Float64}(colorant"#4EC0E3")
	convolve(
		[(i-n/2)^2 + (j-n/2)^2 <= (n/2-5)^2 ? white : blue for i=1:n, j=1:n],
		Kernel.gaussian((1,1))
	)
end

# ╔═╡ fe3559e0-f13b-11ea-06c8-a314e44c20d6
brightness(c) = 0.3 * c.r + 0.59 * c.g + 0.11 * c.b

# ╔═╡ 0ccf76e4-f0d9-11ea-07c9-0159e3d4d733
@bind img_select Radio(["disc", "mario"], default="disc")

# ╔═╡ 236dab08-f13d-11ea-1922-a3b82cfc7f51
begin
	url = "http://files.softicons.com/download/game-icons/super-mario-icons-by-sandro-pereira/png/32/Retro%20Mario.png"
	img = Dict(
		"disc" => disc(25),
		"mario" => load(download(url))
	)[img_select]
end

# ╔═╡ 03434682-f13b-11ea-2b6e-11ad781e9a51
md"""Show $G_x$ $(@bind Gx CheckBox())

     Show $G_y$ $(@bind Gy CheckBox())"""

# ╔═╡ ca13597a-f168-11ea-1a2c-ff7b98b7b2c7
function partial_derivatives(img)
	Sy,Sx = Kernel.sobel()
	∇x, ∇y = zeros(size(img)), zeros(size(img))

	if Gx
		∇x = convolve(brightness.(img), Sx)
	end
	if Gy
		∇y = convolve(brightness.(img), Sy)
	end
	return ∇x, ∇y
end

# ╔═╡ b369584c-f183-11ea-260a-35dc797e63ad


# ╔═╡ b2cbe058-f183-11ea-39dc-23d4a5b92796


# ╔═╡ 9d9cccb2-f118-11ea-1638-c76682e636b2
function arrowhead(θ)
	eq_triangle = [(0, 1/sqrt(3)),
		           (-1/3, -2/(2 * sqrt(3))),
		           (1/3, -2/(2 * sqrt(3)))]

	compose(context(units=UnitBox(-1,-1,2,2), rotation=Rotation(θ, 0, 0)),
				polygon(eq_triangle))
end

# ╔═╡ b7ea8a28-f0d7-11ea-3e98-7b19a1f58304
function quiver(points, vecs)
	xmin = minimum(first.(points))
	ymin = minimum(last.(points))
	xmax = maximum(first.(points))
	ymax = maximum(last.(points))
	hs = map(x->hypot(x...), vecs)
	hs = hs / maximum(hs)

	vector(p, v, h) = all(iszero, v) ? context() :
		(context(),
		    (context((p.+v.*6 .- .2)..., .4,.4),
				arrowhead(atan(v[2], v[1]) - pi/2)),
		stroke(RGBA(90/255,39/255,41/255,h)),
		fill(RGBA(90/255,39/255,41/255,h)),
		line([p, p.+v.*8]))

	compose(context(units=UnitBox(xmin,ymin,xmax,ymax)),
         vector.(points, vecs, hs)...)
end

# ╔═╡ c821b906-f0d8-11ea-2df0-8f2d06964aa2
function sobel_quiver(img, ∇x, ∇y)
    quiver([(j-1,i-1) for i=1:size(img,1), j=1:size(img,2)],
           [(∇x[i,j], ∇y[i,j]) for i=1:size(img,1), j=1:size(img,2)])
end

# ╔═╡ 6da3fdfe-f0dd-11ea-2407-7b85217b35cc
# render an Image using squares in Compose
function compimg(img)
	xmax, ymax = size(img)
	xmin, ymin = 0, 0
	arr = [(j-1, i-1) for i=1:ymax, j=1:xmax]

	compose(context(units=UnitBox(xmin, ymin, xmax, ymax)),
		fill(vec(img)),
		rectangle(
			first.(arr),
			last.(arr),
			fill(1.0, length(arr)),
			fill(1.0, length(arr))))
end

# ╔═╡ f22aa34e-f0df-11ea-3053-3dcdc070ec2f
let
	∇x, ∇y = partial_derivatives(img)

	compose(context(),
		sobel_quiver(img, ∇x, ∇y),
		compimg(img))
end

# ╔═╡ 885ec336-f146-11ea-00c4-c1d1ab4c0001
	function show_colored_array(array)
		pos_color = RGB(0.36, 0.82, 0.8)
		neg_color = RGB(0.99, 0.18, 0.13)
		to_rgb(x) = max(x, 0) * pos_color + max(-x, 0) * neg_color
		to_rgb.(array) / maximum(abs.(array))
	end

# ╔═╡ 9232dcc8-f188-11ea-08fe-b787ea93c598
begin
	Sy, Sx = Kernel.sobel()
	show_colored_array(Sx)
	Sx
end

# ╔═╡ 7864bd00-f146-11ea-0020-7fccb3913d8b
let
	∇x, ∇y = partial_derivatives(img)

	to_show = (x -> RGB(0, 0, 0)).(zeros(size(img)))
	if Gx && Gy
		edged = sqrt.(∇x.^2 + ∇y.^2)
		to_show = Gray.(edged) / maximum(edged)
	elseif Gx
		to_show = show_colored_array(∇x)
	elseif Gy
		to_show = show_colored_array(∇y)
	end
	compose(
		context(),
		compimg(to_show)
	)
end

# ╔═╡ Cell order:
# ╠═15a4ba3e-f0d1-11ea-2ef1-5ff1dee8795f
# ╠═1ab1c808-f0d1-11ea-03a7-e9854427d45f
# ╟─21e744b8-f0d1-11ea-2e09-7ffbcdf43c37
# ╠═10f850fc-f0d1-11ea-2a58-2326a9ea1e2a
# ╟─7b4d5270-f0d3-11ea-0b48-79005f20602c
# ╠═6fd3b7a4-f0d3-11ea-1f26-fb9740cd16e0
# ╟─fe3559e0-f13b-11ea-06c8-a314e44c20d6
# ╟─b7ea8a28-f0d7-11ea-3e98-7b19a1f58304
# ╟─0ccf76e4-f0d9-11ea-07c9-0159e3d4d733
# ╟─236dab08-f13d-11ea-1922-a3b82cfc7f51
# ╟─03434682-f13b-11ea-2b6e-11ad781e9a51
# ╟─ca13597a-f168-11ea-1a2c-ff7b98b7b2c7
# ╟─f22aa34e-f0df-11ea-3053-3dcdc070ec2f
# ╟─9232dcc8-f188-11ea-08fe-b787ea93c598
# ╠═7864bd00-f146-11ea-0020-7fccb3913d8b
# ╠═b369584c-f183-11ea-260a-35dc797e63ad
# ╠═b2cbe058-f183-11ea-39dc-23d4a5b92796
# ╟─9d9cccb2-f118-11ea-1638-c76682e636b2
# ╟─c821b906-f0d8-11ea-2df0-8f2d06964aa2
# ╟─6da3fdfe-f0dd-11ea-2407-7b85217b35cc
# ╠═885ec336-f146-11ea-00c4-c1d1ab4c0001
