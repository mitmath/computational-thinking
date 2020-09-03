### A Pluto.jl notebook ###
# v0.11.12

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

# ╔═╡ 5e688928-e939-11ea-0e16-fbc80af390ab
using LinearAlgebra

# ╔═╡ a50b5f48-e8d5-11ea-1f05-a3741b5d15ba
html"<button onclick=present()>Present</button>"

# ╔═╡ 8a6fed4c-e94b-11ea-1113-d56f56fb293b
br = HTML("<br>")

# ╔═╡ dc53f316-e8c8-11ea-150f-1374dbce114a
md"""# Welcome to 18.S191 -- Fall 2020!

### Introduction to Computational Thinking for Real-World Problems"""

# ╔═╡ c3f43d66-e94b-11ea-02bd-23cfeb878ff1
br

# ╔═╡ c6c77738-e94b-11ea-22f5-1dce3dbcc3ca
md"### <https://github.com/mitmath/18S191>"

# ╔═╡ cf80793a-e94b-11ea-0120-f7913ae06f22
br

# ╔═╡ d1638d96-e94b-11ea-2ff4-910e399f864d
md"##### Alan Edelman, David P. Sanders, Grant Sanderson, James Schloss"

# ╔═╡ 0117246a-e94c-11ea-1a76-c981ce8e725d
md"##### & Philip the Corgi"

# ╔═╡ 27060098-e8c9-11ea-2fe0-03b39b1ddc32
md"""# Class outline

### Data and computation 

- Module 1: Analyzing images

- Module 2: Particles and ray tracing

- Module 3: Epidemic spread

- Module 4: Climate change
"""

# ╔═╡ 4fc58814-e94b-11ea-339b-cb714a63f9b6
md"## Tools

- Julia programming language: <http://www.julialang.org/learning>

- Pluto notebook environment
"

# ╔═╡ f067d3b8-e8c8-11ea-20cb-474709ffa99a
md"""# Module 1: Images"""

# ╔═╡ 37c1d012-ebc9-11ea-2dfe-8b86bb78f283
4 + 4

# ╔═╡ a0a97214-e8d2-11ea-0f46-0bfaf016ab6d
md"""## Data takes many forms

- Time series: 
  - Number of infections per day
  - Stock price each minute
  - A piece for violin broadcast over the radio
$(HTML("<br>"))

- Video:
  - The view from a window of a self-driving car
  - A hurricane monitoring station
$(HTML("<br>"))

- Images:
  - Diseased versus healthy tissue in a scan
  - Deep space via the Hubble telescope
  - Can your social media account recognise your friends?
"""

# ╔═╡ 1697a756-e93d-11ea-0b6e-c9c78d527993
md"## Capture your own image!"

# ╔═╡ af28faca-ebb7-11ea-130d-0f94bf9bd836


# ╔═╡ ee1d1596-e94a-11ea-0fb4-cd05f62471d3
md"##"

# ╔═╡ 8ab9a978-e8c9-11ea-2476-f1ef4ba1b619
md"""## What is an image?"""

# ╔═╡ 38c54bfc-e8cb-11ea-3d52-0f02452f8ba1
md"Albrecht Dürer:"

# ╔═╡ 983f8270-e8c9-11ea-29d2-adeccb5a7ffc
# md"# begin 
# 	using Images

# 	download("https://i.stack.imgur.com/QQL8X.jpg", "durer.jpg")
	
# 	load("durer.jpg")
# end

md"![](https://i.stack.imgur.com/QQL8X.jpg)"

# ╔═╡ 2fcaef88-e8ca-11ea-23f7-29c48580f43c
md"""## 

An image is:

- A 2D representation of a 3D world

- An approximation

"""

# ╔═╡ 7636c4b0-e8d1-11ea-2051-757a850a9d30
begin
	image_text = 
	md"""
	## What *is* an image, though?

	- A grid of coloured squares called **pixels**
	
	- A colour for each pair $(i, j)$ of indices
	
	- A **discretization**

	"""
	
	image_text
end

# ╔═╡ bca22176-e8ca-11ea-2004-ebeb103116b5
md"""
## How can we store an image in the computer?

- Is it a 1D array (`Vector`)?

- A 2D array (`Matrix`)?

- A 3D array (`tensor`)? 
"""

# ╔═╡ 0ad91f1e-e8d2-11ea-2c18-93f66c906a8b
md"""## If in doubt: Ask Julia!

- Let's use the `Images.jl` package to load an image and see what we get
"""

# ╔═╡ de373816-ec79-11ea-2772-ebdca52246ac
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 552129ae-ebca-11ea-1fa1-3f9fa00a2601
begin
	Pkg.add(["Images", "ImageIO", "ImageMagick"])
	using Images
end

# ╔═╡ fbe11200-e938-11ea-12e9-6125c1b56b25
begin
	Pkg.add("PlutoUI")
	using PlutoUI
end

# ╔═╡ 54c1ba3c-e8d2-11ea-3564-bdaca8563738
# defines a variable called `url`
# whose value is a string (written inside `"`):

url = "https://i.imgur.com/VGPeJ6s.jpg"  

# ╔═╡ 6e0fefb6-e8d4-11ea-1f9b-e7a3db40df39
philip_file = download(url, "philip.jpg")  # download to a local file

# ╔═╡ 9c359212-ec79-11ea-2d7e-0124dad5f127
philip = load(philip_file)

# ╔═╡ 7703b032-ebca-11ea-3074-0b80a077078e
philip

# ╔═╡ 7eff3522-ebca-11ea-1a65-59e66a4e72ab
typeof(philip)

# ╔═╡ c9cd6c04-ebca-11ea-0990-5fa19ff7ed97
RGBX(0.9, 0.1, 0.1)

# ╔═╡ 0d873d9c-e93b-11ea-2425-1bd79677fb97
md"##"

# ╔═╡ 6b09354a-ebb9-11ea-2d5a-3b75c5ae7aa9


# ╔═╡ 2d6c434e-e93b-11ea-2678-3b9db4975089
md"##"

# ╔═╡ 2b14e93e-e93b-11ea-25f1-5f565f80e778
typeof(philip)

# ╔═╡ 0bdc6058-e8d5-11ea-1889-3f706cea7a1f
md"""##

- According to Julia / Pluto, the variable `philip` *is* an image

- Julia always returns output

- The output can be displayed in a "rich" way

$(HTML("<br>"))

- Arthur C. Clarke:

> Any sufficiently advanced technology is indistinguishable from magic.
"""

# ╔═╡ e61db924-ebca-11ea-2f79-f9f1c121b7f5
size(philip)

# ╔═╡ ef60fcc4-ebca-11ea-3f69-155afffe8ea8
philip

# ╔═╡ fac550ec-ebca-11ea-337a-dbc16848c617
philip[1:1000, 1:400]

# ╔═╡ 42aa8cfe-e8d5-11ea-3cb9-c365b98e7a8c
md"
## How big is Philip?

- He's pretty big:
"

# ╔═╡ 4eea5710-e8d5-11ea-3978-af66ee2a137e
size(philip)

# ╔═╡ 57b3a0c2-e8d5-11ea-15aa-8da4549f849b
md"- Which number is which?"

# ╔═╡ 03a7c0fc-ebba-11ea-1c71-79d750c97b16
philip

# ╔═╡ e6fd68fa-e8d8-11ea-3dc4-274caceda222
md"# So, what *is* an image?"

# ╔═╡ 63a1d282-e8d5-11ea-0bba-b9cdd32a218b
typeof(philip)

# ╔═╡ fc5e1af0-e8d8-11ea-1077-07216ff96d29
md"""
- It's an `Array`

- The `2` means that it has **2 dimensions** (a **matrix**)

$(HTML("<br>"))

- `RGBX{Normed{UInt8,8}}` is the type of object stored in the array

- A Julia object representing a colour

- RGB = Red, Green, Blue
"""

# ╔═╡ c79dd836-e8e8-11ea-029d-57be9899979a
md"## Getting pieces of an image"



# ╔═╡ ae260168-e932-11ea-38fd-4f2c6f43e21c
begin 
	(h, w) = size(philip)
	head = philip[(h ÷ 2):h, (w ÷ 10): (9w ÷ 10)]
	# `÷` is typed as \div <TAB>  -- integer division
end

# ╔═╡ 47d1bc04-ebcb-11ea-3643-d1ba8dea57c8
size(head)

# ╔═╡ 72400458-ebcb-11ea-26b6-678ae1de8e23
size(philip)

# ╔═╡ f57ea7c2-e932-11ea-0d52-4112187bcb38
md"## Manipulating matrices

- An image is just a matrix, so we can manipulate *matrices* to manipulate the *image*
"

# ╔═╡ 740ed2e2-e933-11ea-236c-f3c3f09d0f8b
[head head]

# ╔═╡ 6128a5ba-e93b-11ea-03f5-f170c7b90b25
md"##"

# ╔═╡ 78eafe4e-e933-11ea-3539-c13feb894ef6
[
 head                   reverse(head, dims=2)
 reverse(head, dims=1)  reverse(reverse(head, dims=1), dims=2)
]

# ╔═╡ bf3f9050-e933-11ea-0df7-e5dcff6bb3ee
md"## Manipulating an image

- How can we get inside the image and change it?

- There are two possibilities:

  - **Modify** (**mutate**) numbers inside the array -- useful to change a small piece

  - Create a new **copy** of the array -- useful to alter everything together
"

# ╔═╡ 212e1f12-e934-11ea-2f35-51c7a6c8dff1
md"## Painting a piece of an image

- Let's paint a corner red

- We'll copy the image first so we don't destroy the original
"

# ╔═╡ 117a98c0-e936-11ea-3aac-8f66337cea68
new_phil = copy(head)

# ╔═╡ 8004d076-e93b-11ea-29cc-a1bfcc75e87f
md"##"

# ╔═╡ 3ac63296-e936-11ea-2144-f94bdbd60eaf
red = RGB(1, 0, 0)

# ╔═╡ 3e3f841a-e936-11ea-0a81-1b95fe0faa83
for i in 1:100
	for j in 1:300
		new_phil[i, j] = red
	end
end

# ╔═╡ 5978db50-e936-11ea-3145-059a51be2281
md"Note that `for` loops *do not return anything* (or, rather, they return `nothing`)"

# ╔═╡ 21638b14-ebcc-11ea-1761-bbd2f4306a96
new_phil

# ╔═╡ 70cb0e36-e936-11ea-3ade-49fde77cb696
md"""## Element-wise operations: "Broadcasting"

- Julia provides powerful technology for operating element by element: **broadcasting** 

- Adding "`.`" applies an operation element by element
"""

# ╔═╡ b3ea975e-e936-11ea-067d-81339575a3cb
begin 
	new_phil2 = copy(new_phil)
	new_phil2[100:200, 1:100] .= RGB(0, 1, 0)
	new_phil2
end

# ╔═╡ 918a0762-e93b-11ea-1115-71dbfdb03f27
md"##"

# ╔═╡ daabe66c-e937-11ea-3bc3-d77f2bce406c
new_phil2

# ╔═╡ 095ced62-e938-11ea-1169-939dc7136fd0
md"## Modifying the whole image at once

- We can use the same trick to modify the whole image at once

- Let's **redify** the image

- We define a **function** that turns a colour into just its red component
"

# ╔═╡ 31f3605a-e938-11ea-3a6d-29a185bbee31
function redify(c)
	return RGB(c.r, 0, 0)
end

# ╔═╡ 2744a556-e94f-11ea-2434-d53c24e59285
begin
	color = RGB(0.9, 0.7, 0.2)
	
	[color, redify(color)]
end

# ╔═╡ 98412a36-e93b-11ea-1954-f1c105c6ed4a
md"##"

# ╔═╡ 3c32efde-e938-11ea-1ae4-5d88290f5311
redify.(philip)

# ╔═╡ 4b26e4e6-e938-11ea-2635-6d4fc15e13b7
md"## Transforming an image

- The main goal of this week will be to transfrom images in more interesting ways

- First let's **decimate** poor Phil
"



# ╔═╡ c12e0928-e93b-11ea-0922-2b590a99ee89
md"##"

# ╔═╡ ff5dc538-e938-11ea-058f-693d6b016640
md"## Experiments come alive with interaction

- We start to get a feel for things when we can **experiment**!
"

# ╔═╡ fa24f4a8-e93b-11ea-06bd-25c9672166d6
md"##"

# ╔═╡ 15ce202e-e939-11ea-2387-93be0ec4cf1f
@bind repeat_count Slider(1:10, show_value=true)

# ╔═╡ bf2167a4-e93d-11ea-03b2-cdd24b459ba9
md"## Summary

- Images are readily-accessible data about the world

- We want to process them to extract information

- Relatively simple mathematical operations can transform images in useful ways
"

# ╔═╡ 58184d88-e939-11ea-2fc8-73b3476ebe92
expand(image, ratio=5) = kron(image, ones(ratio, ratio))

# ╔═╡ 2dd09f16-e93a-11ea-2cdc-13f558e3391d
extract_red(c) = c.r

# ╔═╡ df1b7996-e93b-11ea-1a3a-81b4ec520679
decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]

# ╔═╡ 41fa85c0-e939-11ea-1ad8-79805a2083bb
poor_phil = decimate(head, 5)

# ╔═╡ cd5721d0-ede6-11ea-0918-1992c69bccc6
repeat(poor_phil, repeat_count, repeat_count)

# ╔═╡ b8daeea0-ec79-11ea-34b5-3f13e8a56a42
md"# Appendix"

# ╔═╡ bf1bb2c8-ec79-11ea-0671-3ffb34828f3c
md"## Package environment"

# ╔═╡ 69e3aa82-e93c-11ea-23fe-c1103d989cba
md"## Camera input"

# ╔═╡ 739c3bb6-e93c-11ea-127b-efb6a8ab9379
function camera_input(;max_size=200, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)

	const span = this.currentScript.parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end


# ╔═╡ 9529bc40-e93c-11ea-2587-3186e0978476
@bind raw_camera_data camera_input(;max_size=2000)

# ╔═╡ 832ebd1a-e93c-11ea-1d18-d784f3184ebe

function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ 9a843af8-e93c-11ea-311b-1bc6d5b58492
grant = decimate(process_raw_camera_data(raw_camera_data), 2)

# ╔═╡ 6aa73286-ede7-11ea-232b-63e052222ecd
[
	grant             grant[:,end:-1:1]
	grant[end:-1:1,:] grant[end:-1:1,end:-1:1]
]

# ╔═╡ Cell order:
# ╟─a50b5f48-e8d5-11ea-1f05-a3741b5d15ba
# ╟─8a6fed4c-e94b-11ea-1113-d56f56fb293b
# ╟─dc53f316-e8c8-11ea-150f-1374dbce114a
# ╟─c3f43d66-e94b-11ea-02bd-23cfeb878ff1
# ╟─c6c77738-e94b-11ea-22f5-1dce3dbcc3ca
# ╟─cf80793a-e94b-11ea-0120-f7913ae06f22
# ╟─d1638d96-e94b-11ea-2ff4-910e399f864d
# ╟─0117246a-e94c-11ea-1a76-c981ce8e725d
# ╟─27060098-e8c9-11ea-2fe0-03b39b1ddc32
# ╟─4fc58814-e94b-11ea-339b-cb714a63f9b6
# ╟─f067d3b8-e8c8-11ea-20cb-474709ffa99a
# ╠═37c1d012-ebc9-11ea-2dfe-8b86bb78f283
# ╟─a0a97214-e8d2-11ea-0f46-0bfaf016ab6d
# ╟─1697a756-e93d-11ea-0b6e-c9c78d527993
# ╟─af28faca-ebb7-11ea-130d-0f94bf9bd836
# ╠═9529bc40-e93c-11ea-2587-3186e0978476
# ╟─ee1d1596-e94a-11ea-0fb4-cd05f62471d3
# ╠═6aa73286-ede7-11ea-232b-63e052222ecd
# ╠═9a843af8-e93c-11ea-311b-1bc6d5b58492
# ╟─8ab9a978-e8c9-11ea-2476-f1ef4ba1b619
# ╟─38c54bfc-e8cb-11ea-3d52-0f02452f8ba1
# ╟─983f8270-e8c9-11ea-29d2-adeccb5a7ffc
# ╟─2fcaef88-e8ca-11ea-23f7-29c48580f43c
# ╟─7636c4b0-e8d1-11ea-2051-757a850a9d30
# ╟─bca22176-e8ca-11ea-2004-ebeb103116b5
# ╟─0ad91f1e-e8d2-11ea-2c18-93f66c906a8b
# ╠═de373816-ec79-11ea-2772-ebdca52246ac
# ╠═552129ae-ebca-11ea-1fa1-3f9fa00a2601
# ╠═54c1ba3c-e8d2-11ea-3564-bdaca8563738
# ╠═6e0fefb6-e8d4-11ea-1f9b-e7a3db40df39
# ╠═9c359212-ec79-11ea-2d7e-0124dad5f127
# ╠═7703b032-ebca-11ea-3074-0b80a077078e
# ╠═7eff3522-ebca-11ea-1a65-59e66a4e72ab
# ╠═c9cd6c04-ebca-11ea-0990-5fa19ff7ed97
# ╟─0d873d9c-e93b-11ea-2425-1bd79677fb97
# ╠═6b09354a-ebb9-11ea-2d5a-3b75c5ae7aa9
# ╟─2d6c434e-e93b-11ea-2678-3b9db4975089
# ╠═2b14e93e-e93b-11ea-25f1-5f565f80e778
# ╟─0bdc6058-e8d5-11ea-1889-3f706cea7a1f
# ╠═e61db924-ebca-11ea-2f79-f9f1c121b7f5
# ╠═ef60fcc4-ebca-11ea-3f69-155afffe8ea8
# ╠═fac550ec-ebca-11ea-337a-dbc16848c617
# ╟─42aa8cfe-e8d5-11ea-3cb9-c365b98e7a8c
# ╠═4eea5710-e8d5-11ea-3978-af66ee2a137e
# ╟─57b3a0c2-e8d5-11ea-15aa-8da4549f849b
# ╠═03a7c0fc-ebba-11ea-1c71-79d750c97b16
# ╟─e6fd68fa-e8d8-11ea-3dc4-274caceda222
# ╠═63a1d282-e8d5-11ea-0bba-b9cdd32a218b
# ╟─fc5e1af0-e8d8-11ea-1077-07216ff96d29
# ╟─c79dd836-e8e8-11ea-029d-57be9899979a
# ╠═ae260168-e932-11ea-38fd-4f2c6f43e21c
# ╠═47d1bc04-ebcb-11ea-3643-d1ba8dea57c8
# ╠═72400458-ebcb-11ea-26b6-678ae1de8e23
# ╟─f57ea7c2-e932-11ea-0d52-4112187bcb38
# ╠═740ed2e2-e933-11ea-236c-f3c3f09d0f8b
# ╟─6128a5ba-e93b-11ea-03f5-f170c7b90b25
# ╠═78eafe4e-e933-11ea-3539-c13feb894ef6
# ╟─bf3f9050-e933-11ea-0df7-e5dcff6bb3ee
# ╟─212e1f12-e934-11ea-2f35-51c7a6c8dff1
# ╠═117a98c0-e936-11ea-3aac-8f66337cea68
# ╟─8004d076-e93b-11ea-29cc-a1bfcc75e87f
# ╠═3ac63296-e936-11ea-2144-f94bdbd60eaf
# ╠═3e3f841a-e936-11ea-0a81-1b95fe0faa83
# ╟─5978db50-e936-11ea-3145-059a51be2281
# ╠═21638b14-ebcc-11ea-1761-bbd2f4306a96
# ╟─70cb0e36-e936-11ea-3ade-49fde77cb696
# ╠═b3ea975e-e936-11ea-067d-81339575a3cb
# ╟─918a0762-e93b-11ea-1115-71dbfdb03f27
# ╠═daabe66c-e937-11ea-3bc3-d77f2bce406c
# ╟─095ced62-e938-11ea-1169-939dc7136fd0
# ╠═31f3605a-e938-11ea-3a6d-29a185bbee31
# ╠═2744a556-e94f-11ea-2434-d53c24e59285
# ╟─98412a36-e93b-11ea-1954-f1c105c6ed4a
# ╠═3c32efde-e938-11ea-1ae4-5d88290f5311
# ╟─4b26e4e6-e938-11ea-2635-6d4fc15e13b7
# ╠═41fa85c0-e939-11ea-1ad8-79805a2083bb
# ╟─c12e0928-e93b-11ea-0922-2b590a99ee89
# ╟─ff5dc538-e938-11ea-058f-693d6b016640
# ╠═fbe11200-e938-11ea-12e9-6125c1b56b25
# ╟─fa24f4a8-e93b-11ea-06bd-25c9672166d6
# ╠═15ce202e-e939-11ea-2387-93be0ec4cf1f
# ╠═cd5721d0-ede6-11ea-0918-1992c69bccc6
# ╟─bf2167a4-e93d-11ea-03b2-cdd24b459ba9
# ╟─5e688928-e939-11ea-0e16-fbc80af390ab
# ╟─58184d88-e939-11ea-2fc8-73b3476ebe92
# ╟─2dd09f16-e93a-11ea-2cdc-13f558e3391d
# ╟─df1b7996-e93b-11ea-1a3a-81b4ec520679
# ╟─b8daeea0-ec79-11ea-34b5-3f13e8a56a42
# ╟─bf1bb2c8-ec79-11ea-0671-3ffb34828f3c
# ╟─69e3aa82-e93c-11ea-23fe-c1103d989cba
# ╟─739c3bb6-e93c-11ea-127b-efb6a8ab9379
# ╟─832ebd1a-e93c-11ea-1d18-d784f3184ebe
