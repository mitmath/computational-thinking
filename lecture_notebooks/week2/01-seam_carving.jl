### A Pluto.jl notebook ###
# v0.11.13

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

# ╔═╡ 877df834-f078-11ea-303b-e98273ef98a4
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 0316b94c-eef6-11ea-19bc-dbc959901bb5
begin
	# Poor man's Project.toml
	Pkg.add(["Images", "ImageMagick", "PlutoUI", "ImageFiltering"])
	
	using Images
	using PlutoUI
	using ImageFiltering
	
	# these are "Standard Libraries" - they are included in every environment
	using Statistics
	using LinearAlgebra
end

# ╔═╡ cb335074-eef7-11ea-24e8-c39a325166a1
md"""
# Seam Carving

1. We use convolution with Sobel filters for "edge detection".
2. We use that to write an algorithm that removes "uninteresting"
   bits of an image in order to shrink it.
"""

# ╔═╡ bf750d0e-f35c-11ea-0245-713584583fcf
md"Select an image below!"

# ╔═╡ 90f44be8-f35c-11ea-2fc6-c361fd4966af
@bind image_url Select([
"https://wisetoast.com/wp-content/uploads/2015/10/The-Persistence-of-Memory-salvador-deli-painting.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Gustave_Caillebotte_-_Paris_Street%3B_Rainy_Day_-_Google_Art_Project.jpg/1014px-Gustave_Caillebotte_-_Paris_Street%3B_Rainy_Day_-_Google_Art_Project.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Gustave_Caillebotte_-_Paris_Street%3B_Rainy_Day_-_Google_Art_Project.jpg/1014px-Gustave_Caillebotte_-_Paris_Street%3B_Rainy_Day_-_Google_Art_Project.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Grant_Wood_-_American_Gothic_-_Google_Art_Project.jpg/480px-Grant_Wood_-_American_Gothic_-_Google_Art_Project.jpg",
		"https://wisetoast.com/wp-content/uploads/2015/10/The-Persistence-of-Memory-salvador-deli-painting.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/A_Sunday_on_La_Grande_Jatte%2C_Georges_Seurat%2C_1884.jpg/640px-A_Sunday_on_La_Grande_Jatte%2C_Georges_Seurat%2C_1884.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/758px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg",
		"https://web.mit.edu/facilities/photos/construction/Projects/stata/1_large.jpg",
	])

# ╔═╡ d2ae6dd2-eef9-11ea-02df-255ec3b46a36
img = load(download(image_url))

# ╔═╡ 8ded023c-f35c-11ea-317c-11f5d1b67998


# ╔═╡ 0b6010a8-eef6-11ea-3ad6-c1f10e30a413
# arbitrarily choose the brightness of a pixel as mean of rgb
# brightness(c::AbstractRGB) = mean((c.r, c.g, c.b))

# Use a weighted sum of rgb giving more weight to colors we perceive as 'brighter'
# Based on https://www.tutorialspoint.com/dip/grayscale_to_rgb_conversion.htm
brightness(c::AbstractRGB) = 0.3 * c.r + 0.59 * c.g + 0.11 * c.b

# ╔═╡ fc1c43cc-eef6-11ea-0fc4-a90ac4336964
Gray.(brightness.(img))

# ╔═╡ 82c0d0c8-efec-11ea-1bb9-83134ecb877e
md"""
# Edge detection filter

(Spoiler alert!) Here, we use the Sobel edge detection filter we created in Homework 1.

```math
\begin{align}

G_x &= \begin{bmatrix}
1 & 0 & -1 \\
2 & 0 & -2 \\
1 & 0 & -1 \\
\end{bmatrix}*A\\
G_y &= \begin{bmatrix}
1 & 2 & 1 \\
0 & 0 & 0 \\
-1 & -2 & -1 \\
\end{bmatrix}*A
\end{align}
```
Here $A$ is the array corresponding to your image.
We can think of these as derivatives in the $x$ and $y$ directions.

Then we combine them by finding the magnitude of the **gradient** (in the sense of multivariate calculus) by defining

$$G_\text{total} = \sqrt{G_x^2 + G_y^2}.$$
"""

# ╔═╡ da726954-eff0-11ea-21d4-a7f4ae4a6b09
Sy, Sx = Kernel.sobel()

# ╔═╡ abf6944e-f066-11ea-18e2-0b92606dab85
(collect(Int.(8 .* Sy)), collect(Int.(8 .* Sx)))

# ╔═╡ ac8d6902-f069-11ea-0f1d-9b0fa706d769
md"""
- blue shows positive values
- red shows negative values
 $G_x \hspace{180pt} G_y$
"""

# ╔═╡ 172c7612-efee-11ea-077a-5d5c6e2505a4
function shrink_image(image, ratio=5)
	(height, width) = size(image)
	new_height = height ÷ ratio - 1
	new_width = width ÷ ratio - 1
	list = [
		mean(image[
			ratio * i:ratio * (i + 1),
			ratio * j:ratio * (j + 1),
		])
		for j in 1:new_width
		for i in 1:new_height
	]
	reshape(list, new_height, new_width)
end

# ╔═╡ fcf46120-efec-11ea-06b9-45f470899cb2
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

# ╔═╡ 6f7bd064-eff4-11ea-0260-f71aa7f4f0e5
function edgeness(img)
	Sy, Sx = Kernel.sobel()
	b = brightness.(img)

	∇y = convolve(b, Sy)
	∇x = convolve(b, Sx)

	sqrt.(∇x.^2 + ∇y.^2)
end

# ╔═╡ dec62538-efee-11ea-1e03-0b801e61e91c
	function show_colored_array(array)
		pos_color = RGB(0.36, 0.82, 0.8)
		neg_color = RGB(0.99, 0.18, 0.13)
		to_rgb(x) = max(x, 0) * pos_color + max(-x, 0) * neg_color
		to_rgb.(array) / maximum(abs.(array))
	end

# ╔═╡ da39c824-eff0-11ea-375b-1b6c6e186182
# Sx
# collect(Int.(8 .* Sx))
show_colored_array(Sx)

# ╔═╡ 074a58be-f146-11ea-382c-b7ae6c44bf75
# Sy
# collect(Int.(8 .* Sy))
show_colored_array(Sy)

# ╔═╡ f8283a0e-eff4-11ea-23d3-9f1ced1bafb4
md"""

## Seam carving idea

The idea of seam carving is to find a path from the top of the image to the bottom of the image where the path minimizes the edgness.

In other words, this path **minimizes the number of edges it crosses**
"""

# ╔═╡ 025e2c94-eefb-11ea-12cb-f56f34886334
md"""

At every step in going down, the path is allowed to go south west, south or south east. We want to find a seam with the minimum possible sum of energies.

We start by writing a `least_edgy` function which given a matrix of energies, returns
a matrix of minimum possible energy starting from that pixel going up to a pixel in the bottom most row.
"""

# ╔═╡ acc1ee8c-eef9-11ea-01ac-9b9e9c4167b3
#            e[x,y] 
#          ↙   ↓   ↘       <--pick the next path which gives the least overall energy
#  e[x-1,y+1] e[x,y+1]  e[x+1,y+1]     
#
# Basic Comp:   e[x,y] += min( e[x-1,y+1],e[x,y],e[x+1,y])
#               dirs records which one from (-1==SW,0==S,1==SE)

function least_edgy(E)
	least_E = zeros(size(E))
	dirs = zeros(Int, size(E))
	least_E[end, :] .= E[end, :] # the minimum energy on the last row is the energy
	                             # itself

	m, n = size(E)
	# Go from the last row up, finding the minimum energy
	for i in m-1:-1:1
		for j in 1:n
			j1, j2 = max(1, j-1), min(j+1, n)
			e, dir = findmin(least_E[i+1, j1:j2])
			least_E[i,j] += e
			least_E[i,j] += E[i,j]
			dirs[i, j] = (-1,0,1)[dir + (j==1)]
		end
	end
	least_E, dirs
end

# ╔═╡ 8b204a2a-eff6-11ea-25b0-13f230037ee1
# The bright areas are screaming "AVOID ME!!!"
least_e, dirs = least_edgy(edgeness(img))

# ╔═╡ 84d3afe4-eefe-11ea-1e31-bf3b2af4aecd
show_colored_array(least_e)

# ╔═╡ b507480a-ef01-11ea-21c4-63d19fac19ab
# direction the path should take at every pixel.
reduce((x,y)->x*y*"\n",
	reduce(*, getindex.(([" ", "↙", "↓", "↘"],), dirs[1:25, 1:60].+3), dims=2, init=""), init="") |> Text

# ╔═╡ 7d8b20a2-ef03-11ea-1c9e-fdf49a397619
md"## Remove seams"

# ╔═╡ f690b06a-ef31-11ea-003b-4f2b2f82a9c3
md"""
Compressing an image horizontally involves a number of seams of lowest energy successively.
"""

# ╔═╡ 977b6b98-ef03-11ea-0176-551fc29729ab
function get_seam_at(dirs, j)
	m = size(dirs, 1)
	js = fill(0, m)
	js[1] = j
	for i=2:m
		js[i] = js[i-1] + dirs[i-1, js[i-1]]
	end
	tuple.(1:m, js)
end

# ╔═╡ 9abbb158-ef03-11ea-39df-a3e8aa792c50
get_seam_at(dirs, 2)

# ╔═╡ 14f72976-ef05-11ea-2ad5-9f0914f9cf58
function mark_path(img, path)
	img′ = copy(img)
	m = size(img, 2)
	for (i, j) in path
		# To make it easier to see, we'll color not just
		# the pixels of the seam, but also those adjacent to it
		for j′ in j-1:j+1
			img′[i, clamp(j′, 1, m)] = RGB(1,0,1)
		end
	end
	img′
end

# ╔═╡ cf9a9124-ef04-11ea-14a4-abf930edc7cc
@bind start_column Slider(1:size(img, 2))

# ╔═╡ 772a4d68-ef04-11ea-366a-f7ae9e1634f6
path = get_seam_at(dirs, start_column)

# ╔═╡ 081a98cc-f06e-11ea-3664-7ba51d4fd153
function pencil(X)
	f(x) = RGB(1-x,1-x,1-x)
	map(f, X ./ maximum(X))
end

# ╔═╡ 237647e8-f06d-11ea-3c7e-2da57e08bebc
e = edgeness(img);

# ╔═╡ 4f23bc54-ef0f-11ea-06a9-35ca3ece421e
function rm_path(img, path)
	img′ = img[:, 1:end-1] # one less column
	for (i, j) in path
		img′[i, 1:j-1] .= img[i, 1:j-1]
		img′[i, j:end] .= img[i, j+1:end]
	end
	img′
end

# ╔═╡ b401f398-ef0f-11ea-38fe-012b7bc8a4fa
function shrink_n(img, n)
	imgs = []
	marked_imgs = []

	e = edgeness(img)
	for i=1:n
		least_E, dirs = least_edgy(e)
		_, min_j = findmin(@view least_E[1, :])
		seam = get_seam_at(dirs, min_j)
		img = rm_path(img, seam)
		# Recompute the energy for the new image
		# Note, this currently involves rerunning the convolution
		# on the whole image, but in principle the only values that
		# need recomputation are those adjacent to the seam, so there
		# is room for a meanintful speedup here.
#		e = edgeness(img)
		e = rm_path(e, seam)

 		push!(imgs, img)
 		push!(marked_imgs, mark_path(img, seam))
	end
	imgs, marked_imgs
end

# ╔═╡ b1b6b7fc-f153-11ea-224a-2578e8298775
n_examples = min(200, size(img, 2))

# ╔═╡ 2eb459d4-ef36-11ea-1f74-b53ffec7a1ed
# returns two vectors of n successively smaller images
# The second images have markings where the seam is cut out
carved, marked_carved = shrink_n(img, n_examples);

# ╔═╡ 7038abe4-ef36-11ea-11a5-75e57ab51032
@bind n Slider(1:length(carved))

# ╔═╡ 2d6c6820-ef2d-11ea-1704-49bb5188cfcc
md"shrunk by $n:"

# ╔═╡ 1fd26a60-f089-11ea-1f56-bb6eba7d9651
function hbox(x, y, gap=16; sy=size(y), sx=size(x))
	w,h = (max(sx[1], sy[1]),
		   gap + sx[2] + sy[2])
	
	slate = fill(RGB(1,1,1), w,h)
	slate[1:size(x,1), 1:size(x,2)] .= RGB.(x)
	slate[1:size(y,1), size(x,2) + gap .+ (1:size(y,2))] .= RGB.(y)
	slate
end

# ╔═╡ 44192a40-eff2-11ea-0ec7-05cdadb0c29a
begin
	img_brightness = brightness.(img)
	∇x = convolve(img_brightness, Sx)
	∇y = convolve(img_brightness, Sy)
	hbox(show_colored_array(∇x), show_colored_array(∇y))
end

# ╔═╡ d6a268c0-eff4-11ea-2c9e-bfef19c7f540
begin
	edged = edgeness(img)
	# hbox(img, pencil(edged))
	hbox(img, Gray.(edgeness(img)) / maximum(abs.(edged)))
end

# ╔═╡ 552fb92e-ef05-11ea-0a79-dd7a6760089a
hbox(mark_path(img, path), mark_path(show_colored_array(least_e), path))

# ╔═╡ dfd03c4e-f06c-11ea-1e2a-89233a675138
let
	hbox(mark_path(img, path), mark_path(pencil(e), path));
end

# ╔═╡ ca4a87e8-eff8-11ea-3d57-01dfa34ff723
let
	# least energy path of them all:
	_, k = findmin(least_e[1, :])
	path = get_seam_at(dirs, k)
	hbox(
		mark_path(img, path),
		mark_path(show_colored_array(least_e), path)
	)
end

# ╔═╡ fa6a2152-ef0f-11ea-0e67-0d1a6599e779
hbox(img, marked_carved[n], sy=size(img))

# ╔═╡ 71b16dbe-f08b-11ea-2343-5f1583074029
vbox(x,y, gap=16) = hbox(x', y')'

# ╔═╡ ddac52ea-f148-11ea-2860-21cff4c867e6
let
	∇y = convolve(brightness.(img), Sy)
	∇x = convolve(brightness.(img), Sx)
	# zoom in on the clock
	vbox(
		hbox(img[300:end, 1:300], img[300:end, 1:300]), 
	 	hbox(show_colored_array.((∇x[300:end,  1:300], ∇y[300:end, 1:300]))...)
	)
end

# ╔═╡ 15d1e5dc-ef2f-11ea-093a-417108bcd495
[size(img) size(carved[n])]

# ╔═╡ Cell order:
# ╠═877df834-f078-11ea-303b-e98273ef98a4
# ╠═0316b94c-eef6-11ea-19bc-dbc959901bb5
# ╟─cb335074-eef7-11ea-24e8-c39a325166a1
# ╟─bf750d0e-f35c-11ea-0245-713584583fcf
# ╟─90f44be8-f35c-11ea-2fc6-c361fd4966af
# ╟─d2ae6dd2-eef9-11ea-02df-255ec3b46a36
# ╠═8ded023c-f35c-11ea-317c-11f5d1b67998
# ╟─0b6010a8-eef6-11ea-3ad6-c1f10e30a413
# ╠═fc1c43cc-eef6-11ea-0fc4-a90ac4336964
# ╟─82c0d0c8-efec-11ea-1bb9-83134ecb877e
# ╠═da726954-eff0-11ea-21d4-a7f4ae4a6b09
# ╠═da39c824-eff0-11ea-375b-1b6c6e186182
# ╠═074a58be-f146-11ea-382c-b7ae6c44bf75
# ╠═abf6944e-f066-11ea-18e2-0b92606dab85
# ╠═44192a40-eff2-11ea-0ec7-05cdadb0c29a
# ╟─ac8d6902-f069-11ea-0f1d-9b0fa706d769
# ╠═ddac52ea-f148-11ea-2860-21cff4c867e6
# ╠═6f7bd064-eff4-11ea-0260-f71aa7f4f0e5
# ╟─d6a268c0-eff4-11ea-2c9e-bfef19c7f540
# ╟─172c7612-efee-11ea-077a-5d5c6e2505a4
# ╟─fcf46120-efec-11ea-06b9-45f470899cb2
# ╟─dec62538-efee-11ea-1e03-0b801e61e91c
# ╟─f8283a0e-eff4-11ea-23d3-9f1ced1bafb4
# ╟─025e2c94-eefb-11ea-12cb-f56f34886334
# ╠═acc1ee8c-eef9-11ea-01ac-9b9e9c4167b3
# ╠═8b204a2a-eff6-11ea-25b0-13f230037ee1
# ╠═84d3afe4-eefe-11ea-1e31-bf3b2af4aecd
# ╠═b507480a-ef01-11ea-21c4-63d19fac19ab
# ╟─7d8b20a2-ef03-11ea-1c9e-fdf49a397619
# ╠═f690b06a-ef31-11ea-003b-4f2b2f82a9c3
# ╠═977b6b98-ef03-11ea-0176-551fc29729ab
# ╠═9abbb158-ef03-11ea-39df-a3e8aa792c50
# ╠═772a4d68-ef04-11ea-366a-f7ae9e1634f6
# ╠═14f72976-ef05-11ea-2ad5-9f0914f9cf58
# ╠═cf9a9124-ef04-11ea-14a4-abf930edc7cc
# ╠═552fb92e-ef05-11ea-0a79-dd7a6760089a
# ╠═081a98cc-f06e-11ea-3664-7ba51d4fd153
# ╠═237647e8-f06d-11ea-3c7e-2da57e08bebc
# ╠═dfd03c4e-f06c-11ea-1e2a-89233a675138
# ╠═ca4a87e8-eff8-11ea-3d57-01dfa34ff723
# ╠═4f23bc54-ef0f-11ea-06a9-35ca3ece421e
# ╠═b401f398-ef0f-11ea-38fe-012b7bc8a4fa
# ╠═b1b6b7fc-f153-11ea-224a-2578e8298775
# ╠═2eb459d4-ef36-11ea-1f74-b53ffec7a1ed
# ╠═7038abe4-ef36-11ea-11a5-75e57ab51032
# ╟─2d6c6820-ef2d-11ea-1704-49bb5188cfcc
# ╠═fa6a2152-ef0f-11ea-0e67-0d1a6599e779
# ╟─71b16dbe-f08b-11ea-2343-5f1583074029
# ╟─1fd26a60-f089-11ea-1f56-bb6eba7d9651
# ╟─15d1e5dc-ef2f-11ea-093a-417108bcd495
