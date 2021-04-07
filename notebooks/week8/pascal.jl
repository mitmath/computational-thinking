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

# ╔═╡ e73aaef4-97e7-11eb-1722-9d275d445f1c
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
"><em>Section 2.8</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Pascal </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 568374de-9717-11eb-3ad1-571475dfe65c
function pascal_row(n)
	if n == 1
		[1]
	else
		prev = pascal_row(n-1)
		[prev; 0] .+ [0; prev]
	end
end

# ╔═╡ a5cb88e1-95de-4a01-8738-1761052d4886
pascal_row(3)

# ╔═╡ 4c6bdeec-cb3b-42da-9cba-f625818bc9c5
pascal(n) = pascal_row.(1:n)

# ╔═╡ 1a651f93-5df0-4ce6-991d-9720da29a7e3
@bind N Slider(1:17; default=5)

# ╔═╡ 3c0baae7-6a34-4126-8d19-5915cf64d7bd
pascal(N)

# ╔═╡ 3a765d51-95d0-444d-adab-f794190914f2
pyramid(pascal(N))

# ╔═╡ fec4bcfb-b88a-4008-82fa-194b8f7264e0
md"""
We need this magical mini-package
"""

# ╔═╡ 116ffb13-8b9a-40b4-aa1e-88d645d1124a
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="HypertextLiteral", version="0.6"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
    ])
    using HypertextLiteral, PlutoUI
end

# ╔═╡ 8de19918-2a32-4b74-a6c4-3fa229c36afd
rand_triangle = [round.(vi,digits=5) for vi ∈ [rand(i) for i=1:6]]

# ╔═╡ dd50d34b-edb3-4e3f-9a2f-77bfe0ed3fd0
pyramid(rand_triangle)

# ╔═╡ bdbd30d7-8714-44bb-a81f-adf988a225a4
md"""
### Vertical and horizontal padding
"""

# ╔═╡ 87b16571-05a3-4bf0-bc12-3f7bb302e364
pyramid(rand_triangle; padding_y = 20)

# ╔═╡ 2b4bd381-87ce-4b0c-8753-4b5a68a7389e
pyramid(rand_triangle; padding_x = 40)

# ╔═╡ 76f08f06-9351-4815-8881-dc978b0e2031
md"""
### Horizontal pyramid
"""

# ╔═╡ c6b3192f-efa3-4ad5-92c0-2eac700f6b26
pyramid(rand_triangle; horizontal=true)

# ╔═╡ 35f75f0a-08c5-47ea-9930-e70f20b8a64a
function pyramid(rows::Vector{<:Vector}; 
		horizontal=false,
		padding_x=8,
		padding_y=2,
	)
	
	style = (; padding = "$(padding_y)px $(padding_x)px")
	render_row(xs) = @htl("""<div><padder></padder>$([@htl("<span style=$(style)>$(x)</span>") for x in xs])<padder></padder></div>""")
	
	@htl("""
		<style>
		.pyramid {
			flex-direction: column;
			display: flex;
		}
		.pyramid.horizontal {
			flex-direction: row;
		}
		.pyramid div {
			display: flex;
			flex-direction: row;
		}
		.pyramid.horizontal div {
			flex-direction: column;
		}
		.pyramid div>span:hover {
			background: rgb(255, 220, 220);
			font-weight: 900;
		}
		.pyramid div padder {
			flex: 1 1 auto;
		}
		.pyramid div span {
			text-align: center;
		}
		
		
		</style>
		<div class=$(["pyramid", (horizontal ? "horizontal" : "vertical")])>
		$(render_row.(rows))
		</div>
		
		""")
end

# ╔═╡ Cell order:
# ╠═e73aaef4-97e7-11eb-1722-9d275d445f1c
# ╠═568374de-9717-11eb-3ad1-571475dfe65c
# ╠═a5cb88e1-95de-4a01-8738-1761052d4886
# ╠═4c6bdeec-cb3b-42da-9cba-f625818bc9c5
# ╠═1a651f93-5df0-4ce6-991d-9720da29a7e3
# ╠═3c0baae7-6a34-4126-8d19-5915cf64d7bd
# ╠═3a765d51-95d0-444d-adab-f794190914f2
# ╟─fec4bcfb-b88a-4008-82fa-194b8f7264e0
# ╠═116ffb13-8b9a-40b4-aa1e-88d645d1124a
# ╠═8de19918-2a32-4b74-a6c4-3fa229c36afd
# ╠═dd50d34b-edb3-4e3f-9a2f-77bfe0ed3fd0
# ╟─bdbd30d7-8714-44bb-a81f-adf988a225a4
# ╠═87b16571-05a3-4bf0-bc12-3f7bb302e364
# ╠═2b4bd381-87ce-4b0c-8753-4b5a68a7389e
# ╟─76f08f06-9351-4815-8881-dc978b0e2031
# ╠═c6b3192f-efa3-4ad5-92c0-2eac700f6b26
# ╠═35f75f0a-08c5-47ea-9930-e70f20b8a64a
