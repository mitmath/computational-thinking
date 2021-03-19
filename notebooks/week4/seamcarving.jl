### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ c09fe642-887e-11eb-1164-a3dc222d0f3d
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
padding-top: 10px;
">
<span style="    # file_stream = open(path, "w+")O3LEY-cM
"> <p style="
font-size: 1.5rem;
opacity: .8;
"><em>Section 1.8</em></p>
<p style="text-align: center; font-size: 2rem;">
<em>Seam Carving</em>
</p>
<br/>
<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/KyBXJV1zFlo" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>
"""


# ╔═╡ e7a77e52-8104-11eb-1b51-a9f8312e9d95
md"""
# Seam carving on images
"""

# ╔═╡ fb6b8564-8104-11eb-2e10-1f28be9a6ce7
md"""
Scroll through the images in this notebook. The idea of **seam carving** is to shrink an image by removing the "least interesting" parts of the image, but *without* resizing the objects within the image. We want to remove the "dead space" within the image.

We try to find a "seam", i.e. a connected path of pixels from top to bottom of the image, which consists of the "least important" pixels, by some measure. 
We then remove the pixels in that seam to give an image that is one pixel narrower.
	
In order to do this, we need to decide how to measure which pixels are "important".
"""

# ╔═╡ bb44122a-80fb-11eb-0593-8d2a6f1e816e
md"""
### Fall 2020 MIT Class Video from Grant Sanderson

Here is Grant Sanderson (3Blue1Brown) explaining seam carving using this notebook from the Fall 2020 edition of this class.
"""

# ╔═╡ 1e132972-80fc-11eb-387a-9b251ee572f8
html"""
<div notthestyle="position: relative; right: 0; top: 0; z-index: 300;"><iframe src="https://www.youtube.com/embed/rpB6zQNsbQU" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
"""

# ╔═╡ 405a4f82-8116-11eb-1b35-2563b06b02a7
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		Pkg.PackageSpec(name="ImageIO", version="0.5"),
		Pkg.PackageSpec(name="ImageShow", version="0.2"),
		Pkg.PackageSpec(name="FileIO", version="1.6"),
		Pkg.PackageSpec(name="PNGFiles", version="0.3.6"),
		Pkg.PackageSpec(name="ImageMagick", version="1"),
        Pkg.PackageSpec(name="ImageFiltering", version="0.6"),
		Pkg.PackageSpec(name="Colors", version="0.12"),
		Pkg.PackageSpec(name="ColorVectorSpace", version="0.8"),
			
		Pkg.PackageSpec(name="PlutoUI", version="0.7"),  
		Pkg.PackageSpec(name="Plots", version="1"),  
	])

	using Colors, ColorVectorSpace, ImageShow, FileIO
	using ImageFiltering
	using Plots, PlutoUI

	using Statistics, LinearAlgebra  # standard libraries available in any environment
end

# ╔═╡ cb335074-eef7-11ea-24e8-c39a325166a1
md"""
## The seam carving algorithm

We need to specify a notion of **importance** of pixels. The seam will then sum up the importance of pixels over the seam and pick the seam which minimizes this total importance.

We will assign importance as "the extent to which a pixel sits inside an edge".
So we need to calculate the "edgeness" of each pixel.
"""

# ╔═╡ 7b0cee56-8106-11eb-0979-e7fead945a6f
md"""

1. We will use convolution with **Sobel filters** for edge detection.
2. Then we will use that to write an algorithm that removes "uninteresting"
   bits of an image in order to shrink it.
"""

# ╔═╡ 3721e7f9-83fa-48cd-a1f5-e72e07b0f7a2
image_urls = [
"https://wisetoast.com/wp-content/uploads/2015/10/The-Persistence-of-Memory-salvador-deli-painting.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Gustave_Caillebotte_-_Paris_Street%3B_Rainy_Day_-_Google_Art_Project.jpg/1014px-Gustave_Caillebotte_-_Paris_Street%3B_Rainy_Day_-_Google_Art_Project.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Gustave_Caillebotte_-_Paris_Street%3B_Rainy_Day_-_Google_Art_Project.jpg/1014px-Gustave_Caillebotte_-_Paris_Street%3B_Rainy_Day_-_Google_Art_Project.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Grant_Wood_-_American_Gothic_-_Google_Art_Project.jpg/480px-Grant_Wood_-_American_Gothic_-_Google_Art_Project.jpg",
		"https://wisetoast.com/wp-content/uploads/2015/10/The-Persistence-of-Memory-salvador-deli-painting.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/A_Sunday_on_La_Grande_Jatte%2C_Georges_Seurat%2C_1884.jpg/640px-A_Sunday_on_La_Grande_Jatte%2C_Georges_Seurat%2C_1884.jpg",

"https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/758px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg",
		"https://web.mit.edu/facilities/photos/construction/Projects/stata/1_large.jpg",
	]

# ╔═╡ 90f44be8-f35c-11ea-2fc6-c361fd4966af
image_url = image_urls[1]

# ╔═╡ d2ae6dd2-eef9-11ea-02df-255ec3b46a36
img = load(download(image_url))

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

(Spoiler alert!) We use the Sobel edge detection filter we created in our Homework.

```math
\begin{align}

G_x &= \begin{bmatrix}
1 & 0 & -1 \\
2 & 0 & -2 \\
1 & 0 & -1 \\
\end{bmatrix} \star A\\[10pt]
G_y &= \begin{bmatrix}
1 & 2 & 1 \\
0 & 0 & 0 \\
-1 & -2 & -1 \\
\end{bmatrix} \star A
\end{align}
```

Here, $\star$ denotes convolution.

Here $A$ is the array corresponding to your image.
We can think of $G_x$ and $G_y$ as calculating (discretized) **derivatives** in the $x$ and $y$ directions.

Then we combine them by finding the magnitude of the (discretized) **gradient**, in the sense of multivariate calculus, by defining

$$G_\text{total} = \sqrt{G_x^2 + G_y^2}.$$
"""

# ╔═╡ ffc9ede2-8106-11eb-2218-79307d6b4515
md"""
Here are the Sobel kernels for the derivatives in each direction:
"""

# ╔═╡ da726954-eff0-11ea-21d4-a7f4ae4a6b09
Sy, Sx = Kernel.sobel()

# ╔═╡ a21a886e-80eb-11eb-35ab-3dd3fb0a8a2c
hbox(show_colored_array(Sx).parent, show_colored_array(Sy).parent ,10)

# ╔═╡ abf6944e-f066-11ea-18e2-0b92606dab85
(collect(Int.(8 .* Sx)), collect(Int.(8 .* Sy)))

# ╔═╡ 44192a40-eff2-11ea-0ec7-05cdadb0c29a
begin
	img_brightness = brightness.(img)
	∇x = convolve(img_brightness, Sx)
	∇y = convolve(img_brightness, Sy)
	hbox(show_colored_array(∇x), show_colored_array(∇y))
end

# ╔═╡ 42f2105a-810b-11eb-0e47-2dbb5ea2f566
plotly()

# ╔═╡ 406a65c0-810a-11eb-3c57-6d5be524ee3f
surface(brightness.(img))

# ╔═╡ ac8d6902-f069-11ea-0f1d-9b0fa706d769
md"""
- blue shows positive values
- red shows negative values
 $G_x \hspace{180pt} G_y$
"""

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

# ╔═╡ 6f7bd064-eff4-11ea-0260-f71aa7f4f0e5
function edgeness(img)
	Sy, Sx = Kernel.sobel()
	b = brightness.(img)

	∇y = convolve(b, Sy)
	∇x = convolve(b, Sx)

	sqrt.(∇x.^2 + ∇y.^2)
end

# ╔═╡ d6a268c0-eff4-11ea-2c9e-bfef19c7f540
begin
	edged = edgeness(img)
	# hbox(img, pencil(edged))
	hbox(img, Gray.(edgeness(img)) / maximum(abs.(edged)))
end

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

# ╔═╡ dec62538-efee-11ea-1e03-0b801e61e91c
	function show_colored_array(array)
		pos_color = RGB(0.36, 0.82, 0.8)
		neg_color = RGB(0.99, 0.18, 0.13)
		to_rgb(x) = max(x, 0) * pos_color + max(-x, 0) * neg_color
		to_rgb.(array) / maximum(abs.(array))
	end

# ╔═╡ f8283a0e-eff4-11ea-23d3-9f1ced1bafb4
md"""

## Seam carving idea

The idea of seam carving is to find a path from the top of the image to the bottom of the image where the path minimizes the edgness. 
In other words, this path **minimizes the number of edges in the image that it crosses**.

We will call the edgeness the **energy**.

"""

# ╔═╡ 025e2c94-eefb-11ea-12cb-f56f34886334
md"""

At every step in going down, the path is allowed to go south-west, south or south-east. We want to find a connected path, or **seam**, with the minimum possible sum of "energies" along the path.

We start by writing a `least_edgy` function which takes a matrix of energies and returns
a new matrix. The new matrix has entries $M_{i, j}$ which gives the minimum possible energy when starting from the pixel $(i, j)$ and going from there down to a pixel in the bottom row.
"""

# ╔═╡ acc1ee8c-eef9-11ea-01ac-9b9e9c4167b3
#            e[x,y] 
#          ↙   ↓   ↘       <-- pick the next path which gives the least overall energy
#  e[x-1,y+1] e[x,y+1]  e[x+1,y+1]     
#
# Basic calculation:   e[x,y] += min( e[x-1,y+1], e[x,y], e[x+1,y] )
#               `dirs` records which direction we take from (-1==SW, 0==S, 1==SE)

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
	
	return least_E, dirs
end

# ╔═╡ 8b204a2a-eff6-11ea-25b0-13f230037ee1
# The bright areas are screaming "AVOID ME!"

least_e, dirs = least_edgy(edgeness(img))

# ╔═╡ 84d3afe4-eefe-11ea-1e31-bf3b2af4aecd
show_colored_array(least_e)

# ╔═╡ dd71c2a4-8108-11eb-18ce-838c53eac3ef
md"""
Here are the directions that we should take at each step:
"""

# ╔═╡ b507480a-ef01-11ea-21c4-63d19fac19ab
# direction the path should take at every pixel.
reduce( (x,y) -> x*y*"\n",
	reduce(*, getindex.(([" ", "↙", "↓", "↘"],), dirs[1:25, 1:60].+3), dims=2, 	init=""), init="") |> Text

# ╔═╡ 7d8b20a2-ef03-11ea-1c9e-fdf49a397619
md"## Remove seams"

# ╔═╡ f690b06a-ef31-11ea-003b-4f2b2f82a9c3
md"""
We now compress an image horizontally by successively removing a number of seams of lowest energy.
"""

# ╔═╡ 977b6b98-ef03-11ea-0176-551fc29729ab
function get_seam_at(dirs, j)
	m = size(dirs, 1)
	js = fill(0, m)
	js[1] = j
	
	for i=2:m
		js[i] = js[i-1] + dirs[i-1, js[i-1]]
	end
	
	return tuple.(1:m, js)
end

# ╔═╡ 9abbb158-ef03-11ea-39df-a3e8aa792c50
get_seam_at(dirs, 2)

# ╔═╡ 772a4d68-ef04-11ea-366a-f7ae9e1634f6
path = get_seam_at(dirs, start_column)

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
	
	return img′
end

# ╔═╡ 22c851c4-8109-11eb-3950-35a75857c3c3
md"""
In the visualization below, the slider specifies which column we start with at the top. The pink seam is the best (least total energy) that will be snipped out.
"""

# ╔═╡ cf9a9124-ef04-11ea-14a4-abf930edc7cc
@bind start_column Slider(1:size(img, 2), show_value=true)

# ╔═╡ 552fb92e-ef05-11ea-0a79-dd7a6760089a
hbox(mark_path(img, path), mark_path(show_colored_array(least_e), path))

# ╔═╡ 081a98cc-f06e-11ea-3664-7ba51d4fd153
function pencil(X)
	f(x) = RGB(1-x,1-x,1-x)
	map(f, X ./ maximum(X))
end

# ╔═╡ 237647e8-f06d-11ea-3c7e-2da57e08bebc
e = edgeness(img);

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

# ╔═╡ 5d6c1d74-8109-11eb-3529-bf2f23554b02
md"""
### Seam carving in action
"""

# ╔═╡ 48593d7c-8109-11eb-1b8b-6f15155d6ec9
md"""
Here is the algorithm in action. Now the slider tells us on which step of the algorithm we are, having removed each least-energy seam at each step:
"""

# ╔═╡ 7038abe4-ef36-11ea-11a5-75e57ab51032
@bind n Slider(1:length(carved))

# ╔═╡ 2d6c6820-ef2d-11ea-1704-49bb5188cfcc
md"shrunk by $n:"

# ╔═╡ fa6a2152-ef0f-11ea-0e67-0d1a6599e779
hbox(img, marked_carved[n], sy=size(img))

# ╔═╡ 71b16dbe-f08b-11ea-2343-5f1583074029
vbox(x,y, gap=16) = hbox(x', y')'

# ╔═╡ 1fd26a60-f089-11ea-1f56-bb6eba7d9651
function hbox(x, y, gap=16; sy=size(y), sx=size(x))
	w,h = (max(sx[1], sy[1]),
		   gap + sx[2] + sy[2])
	
	slate = fill(RGB(1,1,1), w,h)
	slate[1:size(x,1), 1:size(x,2)] .= RGB.(x)
	slate[1:size(y,1), size(x,2) + gap .+ (1:size(y,2))] .= RGB.(y)
	slate
end

# ╔═╡ 15d1e5dc-ef2f-11ea-093a-417108bcd495
[size(img) size(carved[n])]

# ╔═╡ Cell order:
# ╟─c09fe642-887e-11eb-1164-a3dc222d0f3d
# ╟─e7a77e52-8104-11eb-1b51-a9f8312e9d95
# ╟─fb6b8564-8104-11eb-2e10-1f28be9a6ce7
# ╟─bb44122a-80fb-11eb-0593-8d2a6f1e816e
# ╟─1e132972-80fc-11eb-387a-9b251ee572f8
# ╠═405a4f82-8116-11eb-1b35-2563b06b02a7
# ╟─cb335074-eef7-11ea-24e8-c39a325166a1
# ╟─7b0cee56-8106-11eb-0979-e7fead945a6f
# ╟─3721e7f9-83fa-48cd-a1f5-e72e07b0f7a2
# ╠═90f44be8-f35c-11ea-2fc6-c361fd4966af
# ╟─d2ae6dd2-eef9-11ea-02df-255ec3b46a36
# ╟─0b6010a8-eef6-11ea-3ad6-c1f10e30a413
# ╠═fc1c43cc-eef6-11ea-0fc4-a90ac4336964
# ╟─82c0d0c8-efec-11ea-1bb9-83134ecb877e
# ╟─ffc9ede2-8106-11eb-2218-79307d6b4515
# ╠═da726954-eff0-11ea-21d4-a7f4ae4a6b09
# ╠═a21a886e-80eb-11eb-35ab-3dd3fb0a8a2c
# ╠═abf6944e-f066-11ea-18e2-0b92606dab85
# ╠═44192a40-eff2-11ea-0ec7-05cdadb0c29a
# ╠═42f2105a-810b-11eb-0e47-2dbb5ea2f566
# ╠═406a65c0-810a-11eb-3c57-6d5be524ee3f
# ╟─ac8d6902-f069-11ea-0f1d-9b0fa706d769
# ╟─ddac52ea-f148-11ea-2860-21cff4c867e6
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
# ╟─dd71c2a4-8108-11eb-18ce-838c53eac3ef
# ╟─b507480a-ef01-11ea-21c4-63d19fac19ab
# ╟─7d8b20a2-ef03-11ea-1c9e-fdf49a397619
# ╟─f690b06a-ef31-11ea-003b-4f2b2f82a9c3
# ╠═977b6b98-ef03-11ea-0176-551fc29729ab
# ╠═9abbb158-ef03-11ea-39df-a3e8aa792c50
# ╠═772a4d68-ef04-11ea-366a-f7ae9e1634f6
# ╟─14f72976-ef05-11ea-2ad5-9f0914f9cf58
# ╟─22c851c4-8109-11eb-3950-35a75857c3c3
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
# ╟─5d6c1d74-8109-11eb-3529-bf2f23554b02
# ╟─48593d7c-8109-11eb-1b8b-6f15155d6ec9
# ╠═7038abe4-ef36-11ea-11a5-75e57ab51032
# ╟─2d6c6820-ef2d-11ea-1704-49bb5188cfcc
# ╠═fa6a2152-ef0f-11ea-0e67-0d1a6599e779
# ╟─71b16dbe-f08b-11ea-2343-5f1583074029
# ╟─1fd26a60-f089-11ea-1f56-bb6eba7d9651
# ╟─15d1e5dc-ef2f-11ea-093a-417108bcd495
