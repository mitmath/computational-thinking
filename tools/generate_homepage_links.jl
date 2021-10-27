### A Pluto.jl notebook ###
# v0.16.4

using Markdown
using InteractiveUtils

# ╔═╡ 6b119ccd-03c4-4a21-b263-e848c555c418
using HypertextLiteral

# ╔═╡ ee61fc1e-055d-4286-aa94-f8e6540f737e
struct Section
    chapter::Int
    section::Int
    name::String
    notebook_path::String
    video_id::String
	preview_image_url::String
end

# ╔═╡ 79f614c7-68d4-4537-aa0e-883b3a41c2b1
struct Chapter
    number::Int
    name::String
end

# ╔═╡ b5eaabee-6c96-4aca-a1d4-90383f005d1f
without_dotjl(path) = splitext(path)[1]

# ╔═╡ bd32c59f-0758-4414-8ae0-889ed6a005fc
function card(section::Section)
    notebook_name = basename(without_dotjl(section.notebook_path))
    return """
    <a class="sidebar-nav-item {{ispage /$notebook_name/}}active{{end}}" href="/$notebook_name/"><b>$(section.chapter).$(section.section)</b> - <em>$(section.name)</em></a>
    """
end

# ╔═╡ 63094a6b-b349-491a-b307-23b78e72f500
card(x) = ""


# ╔═╡ e0e709b3-9e27-430a-a1b6-54ca51023337
book_model = Any[
    Chapter(1, "Images, Transformations, Abstractions"),
    Section(
        1,
        1,
        "Images as Data and Arrays",
        "notebooks/week1/images.jl",
        "3zTO3LEY-cM",
        "https://user-images.githubusercontent.com/6933510/136196634-2294d0a7-e79a-40d0-bbb8-81da70f4d398.png",
    ),
    Section(
        1,
        2,
        "Intro to Abstractions",
        "notebooks/week1/abstraction.jl",
        "3zTO3LEY-cM",
        "",
    ),
    Section(
        1,
        3,
        "Transformations & Autodiff",
        "notebooks/week2/transformations_and_autodiff.jl",
        "AAREeuaKCic",
        "https://user-images.githubusercontent.com/6933510/136196632-ad67cb84-a4c9-410e-ab72-f4fcfc26f69a.png",
    ),
    Section(
        1,
        4,
        "Transformations with Images",
        "notebooks/week2/transforming_images.jl",
        "uZYVjDDZW9A",
        "https://user-images.githubusercontent.com/6933510/136196626-194e81c9-00f7-49f6-90c3-09945723b6a3.png",
    ),
    Section(
        1,
        5,
        "Transformations II: Composability, Linearity and Nonlinearity",
        "notebooks/week3/transformations2.jl",
        "VDPf3RjoCpY",
        "https://user-images.githubusercontent.com/6933510/136196619-0750544f-cd6d-4ae3-ace7-60c24443d721.png",
    ),
    Section(
        1,
        6,
        "The Newton Method",
        "notebooks/week3/newton_method.jl",
        "Wjcx9sNSLP8",
        "https://user-images.githubusercontent.com/6933510/136196605-b6119b9d-223c-44bc-97d5-ef7cfce66483.gif",
    ),
    Section(
        1,
        7,
        "Intro to Dynamic Programming",
        "notebooks/week4/dynamicprograms.jl",
        "KyBXJV1zFlo",
        "https://user-images.githubusercontent.com/6933510/136196599-c6ae60f0-9269-4134-bb0d-5bcab928bd2b.gif",
    ),
    Section(
        1,
        8,
        "Seam Carving",
        "notebooks/week4/seamcarving.jl",
        "KyBXJV1zFlo",
        "https://user-images.githubusercontent.com/6933510/136196584-b3c806a8-aa61-48d9-9e73-30583fcc38bf.gif",
    ),
    Section(
        1,
        9,
        "Taking Advantage of Structure",
        "notebooks/week4/structure.jl",
        "wZrVxbmX218",
        "https://user-images.githubusercontent.com/6933510/136196581-ffdf4a3b-f35c-4eb8-85a7-f07560bd421b.png",
    ),
    Chapter(2, "Statistics, Probability, Learning"),
    Section(
        2,
        1,
        "Principal Component Analysis",
        "notebooks/week5/pca.jl",
        "iuKrM_NzxCk",
        "https://user-images.githubusercontent.com/6933510/136196577-512cee99-aebf-48a9-97b8-358d5ca561ca.png",
    ),
    Section(
        2,
        2,
        "Sampling and Random Variables",
        "notebooks/week5/random_vars.jl",
        "7HrpoFZzITI",
        "https://user-images.githubusercontent.com/6933510/136196576-70e45c9d-ef0e-4498-bf61-58d9ae854c3e.png",
    ),
    Section(
        2,
        3,
        "Modeling with Stochastic Simulation",
        "notebooks/week6/simulating_component_failure.jl",
        "d8BohH76C7E",
        "https://user-images.githubusercontent.com/6933510/136196572-b11974d5-7335-4678-9092-630e034bbe8f.png",
    ),
    Section(
        2,
        4,
        "Random Variables as Types",
        "notebooks/week7/random_variables_as_types.jl",
        "xKAO38UsXo0",
        "https://user-images.githubusercontent.com/6933510/136196570-478bbb89-05fb-4799-99a0-0ede06354cb6.png",
    ),
    Section(
        2,
        5,
        "Random Walks",
        "notebooks/week7/random_walks.jl",
        "14hHtGJ4s-g",
        "https://user-images.githubusercontent.com/6933510/136196563-f4b5b44c-5252-4e67-8c82-c550de891c55.png",
    ),
    Section(
        2,
        6,
        "Random Walks II",
        "notebooks/week8/random_walks_II.jl",
        "pIAFHyLmwbM",
        "",
    ),
    Section(
        2,
        7,
        "Discrete and Continuous",
        "notebooks/week8/discrete_and_continuous.jl",
        "H6Dcx3YeTkE",
        "https://user-images.githubusercontent.com/6933510/136196552-ce16c06f-bd12-427f-80e5-aedb1fbc734a.png",
    ),
    Section(
        2,
        8,
        "Linear Model, Data Science, & Simulations",
        "notebooks/week9/linearmodel_datascience.jl",
        "O6NTKsR8TjQ",
        "https://user-images.githubusercontent.com/6933510/136199721-8fd577cb-d6f3-492d-bbdc-37bc74664ca7.png",
    ),
    Section(
        2,
        9,
        "Optimization",
        "notebooks/week9/optimization.jl",
        "44RA9fclTdA",
        "https://user-images.githubusercontent.com/6933510/136199719-a56a217b-cd36-4da2-b407-7285dcec94df.png",
    ),
    Chapter(3, "Differential Equations & Climate Modeling"),
    Section(
        3,
        1,
        "Time stepping",
        "notebooks/week10/time_stepping.jl",
        "3Y5gVyO8KcI",
        "https://user-images.githubusercontent.com/6933510/136199718-ff811eb3-aad6-4d6b-99e0-f6bf922816b4.png",
    ),
    Section(
        3,
        2,
        "ODEs and parameterized types",
        "notebooks/week11/odes_and_parameterized_types.jl",
        "S71YIZ8e7MQ",
        "https://user-images.githubusercontent.com/6933510/136199713-25eb2e90-c5cd-4e11-8463-6f6069a81a51.png",
    ),
    Section(
        3,
        3,
        "Why we can't predict the weather",
        "notebooks/week11/predicting_the_weather.jl",
        "M3udLzIHtsc",
        "https://user-images.githubusercontent.com/6933510/136199708-af8acad2-4172-4fa7-911e-e30300efb5ee.png",
    ),
    Section(
        3,
        4,
        "Our first climate model",
        "notebooks/week12/our_first_climate_model.jl",
        "J1UsMa1cTeE",
        "https://user-images.githubusercontent.com/6933510/136199705-7bdb6bb0-8698-43a1-87e6-c073ab102da5.png",
    ),
    Section(
        3,
        5,
        "How to collaborate on software",
        "notebooks/week12/how_to_collaborate_on_software.jl",
        "7N9Vvc8amGM",
        "https://user-images.githubusercontent.com/6933510/136199704-ba6d0586-34bf-490c-8fd0-6959ab42cd23.png",
    ),
    Section(
        3,
        6,
        "Snowball Earth and hysteresis",
        "notebooks/week13/climate2_snowball_earth.jl",
        "cdIgr_2nUvI",
        "https://user-images.githubusercontent.com/6933510/136199703-5edb4791-f9c0-4872-b0a7-7c9b1b6502d5.png",
    ),
    Section(
        3,
        7,
        "Advection and diffusion in 1D",
        "notebooks/week13/advection_and_diffusion.jl",
        "Xb-iUwXI78A",
        "https://user-images.githubusercontent.com/6933510/136200627-8211654f-7730-4f4a-8933-5b64164806c3.gif",
    ),
    Section(
        3,
        8,
        "Resistors, stencils and climate models",
        "notebooks/week14/resistors_and_stencils.jl",
        "DdTWgBlDgr0",
        "https://user-images.githubusercontent.com/6933510/136200635-33c007ff-89f6-48dc-b1d3-eb56fd16003e.gif",
    ),
    Section(
        3,
        9,
        "Advection and diffusion in 2D",
        "notebooks/week14/2d_advection_diffusion.jl",
        "DdTWgBlDgr0",
        "https://user-images.githubusercontent.com/6933510/136200688-e3c6d6ee-808c-433f-8252-af6ad278fb4d.gif",
    ),
    Section(
        3,
        10,
        "Inverse climate modeling",
        "notebooks/week14/inverse_climate_model.jl",
        "nm86_hDwYTU",
        "https://user-images.githubusercontent.com/6933510/136199660-315b045b-f144-4009-9282-7fe6d1f5d41b.gif",
    ),
    Section(
        3,
        11,
        "Solving inverse problems",
        "notebooks/week14/optimization_with_JuMP.jl",
        "nm86_hDwYTU",
        "https://user-images.githubusercontent.com/6933510/136200827-89647ae8-cb06-42ea-a18d-5f64e9cc2b25.png",
    ),
]

# ╔═╡ ed8e431b-d541-469e-9d39-b372aa866022
result = join(card.(book_model),"\n")

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
for section in book_model if (section isa Section && !isempty(section.preview_image_url))))""") |> clipboard

# ╔═╡ dec0653e-732f-459c-b890-8a35f8b2ec32
any(x>0 for x in 1:10 if x isa Number)

# ╔═╡ c9c3848f-8a57-445b-8a86-561a0ba13ce7
"""
$((x>0 for x in 1:10 if x isa Number))
"""

# ╔═╡ b396d1e9-562c-4c41-bef2-8dac3de6f49e
"""
$(any(x>0 for x in 1:10 if x isa Number))
"""

# ╔═╡ a835d318-6b9b-406a-9ee1-bc5b06c1348c
@htl """
<style>
</style>"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[HypertextLiteral]]
git-tree-sha1 = "5efcf53d798efede8fee5b2c8b09284be359bf24"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.2"
"""

# ╔═╡ Cell order:
# ╠═ee61fc1e-055d-4286-aa94-f8e6540f737e
# ╠═79f614c7-68d4-4537-aa0e-883b3a41c2b1
# ╠═b5eaabee-6c96-4aca-a1d4-90383f005d1f
# ╠═bd32c59f-0758-4414-8ae0-889ed6a005fc
# ╠═63094a6b-b349-491a-b307-23b78e72f500
# ╠═ed8e431b-d541-469e-9d39-b372aa866022
# ╟─e0e709b3-9e27-430a-a1b6-54ca51023337
# ╠═6b119ccd-03c4-4a21-b263-e848c555c418
# ╠═42478294-047b-48db-a770-ff6446706654
# ╠═dec0653e-732f-459c-b890-8a35f8b2ec32
# ╠═c9c3848f-8a57-445b-8a86-561a0ba13ce7
# ╠═b396d1e9-562c-4c41-bef2-8dac3de6f49e
# ╠═a835d318-6b9b-406a-9ee1-bc5b06c1348c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
