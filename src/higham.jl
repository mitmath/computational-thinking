### A Pluto.jl notebook ###
# v0.19.42

#> [frontmatter]
#> image = "https://github.com/user-attachments/assets/73ed934a-7877-4772-860e-3733987f16c4"
#> order = "99"
#> title = "Tribute to Nick Higham (1961-2024)"
#> date = "2024-09-03"
#> tags = ["interactive", "obituary", "track_math", "dataframe", "matrix", "linear algebra", "welcome"]
#> layout = "layout.jlhtml"
#> description = "Computational Numerical Linear Algebra lost Nick Higham way too early. This graphic captures his life by placing his papers into (somewhat arbitrary) subject categories, collected per year."
#> 
#>     [[frontmatter.author]]
#>     name = "Alan Edelman"
#>     url = "https://github.com/alanedelman"
#>     [[frontmatter.author]]
#>     name = "Fons van der Plas"
#>     url = "https://github.com/fonsp"

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ec2ff75c-3164-43a8-b7e0-6047e074450b
using LinearAlgebra

# ╔═╡ f9770b24-50d2-11ef-0220-d70a8d2884de
using DataFrames, CSV

# ╔═╡ 3ba61e71-2ebc-4a69-a632-502ebb84ac46
using PlutoUI

# ╔═╡ 28eb6025-af86-4a66-bbc5-f44487838d8d
using ColorTypes, FixedPointNumbers

# ╔═╡ 9d42e4c7-1cb0-4e4f-9d87-56c255261436
using HypertextLiteral

# ╔═╡ aa21898b-3abb-4cc5-b52d-51d4673e3047
md"""
# Tribute to Nick Higham *(1961-2024)*

Computational Numerical Linear Algebra lost Nick Higham way too early. The graphic below captures his life by placing his papers into (somewhat arbitrary) subject categories, collected per year. 

Hover over a square to see the list of papers.

*– Alan Edelman*
"""

# ╔═╡ a1574267-89e1-42ce-9e6f-e784116bb3cf
(
var"1 paper "=@bind(c1, ColorPicker(default=RGB{N0f8}(0.8,0.902,1.0))),
var"2 papers"=@bind(c2, ColorPicker(default=RGB{N0f8}(0.627,0.647,0.933))),
var"3 papers"=@bind(c3, ColorPicker(default=RGB{N0f8}(0.329,0.42,0.627))),
var"4 papers"=@bind(c4, ColorPicker(default=RGB{N0f8}(0.678,0.349,0.078))),
var"5 papers"=@bind(c5, ColorPicker(default=RGB{N0f8}(0.525,0.369,0.035))),
var"6 papers"=@bind(c6, ColorPicker(default=RGB{N0f8}(0.78,0.0,0.0)))
)

# ╔═╡ 4555e853-2535-46a2-b5fd-2501f69e5dd7
md"""
### Sorting papers

You can pick how the categories are sorted:
"""

# ╔═╡ b86212c7-175e-4d1e-bd48-634496584e09
@bindname sort_categories_by Select([1=>"First appearance", 2=>"Total count", 3=>"Alphabetic order"])

# ╔═╡ 040b283d-b1a0-417c-9c75-5dbfe824c880
md"""
Bundle multiple years:
"""

# ╔═╡ 9b7a819c-ab9f-4570-9d7c-66073fe140a5
@bindname yearbundlesize Slider(1:10; show_value=true)

# ╔═╡ 5ff7ad16-ecf6-48c6-a6f6-5bf0f9cda221
all_colors = [c1, c2, c3 ,c4 , c5, c6];

# ╔═╡ ed664225-db50-40ef-9b34-a07d58dff657
md"""
## Higham legacy matrix
Rows are categories, columns are years:
"""

# ╔═╡ 5ca24e51-91f6-46f4-8654-746e4a6f1163
md"""
We think that Nick might have liked the below:
"""

# ╔═╡ de811896-927c-4e43-9c32-47c78cb695a1
html"""
<br>
<br>
<br>
<br>
<br>
"""

# ╔═╡ e2605eb3-3185-47bd-950c-cd04d66f874c
md"""
# Behind the scenes

This visualisation was implemented in a [Pluto notebook](https://plutojl.org). The code is below.

## Data reading
"""

# ╔═╡ a65b429c-2a02-4dd0-b7b4-83eee020ac8f
csvfilepath = download("https://docs.google.com/spreadsheets/d/1xs8UGssC0agiYduqizD0LJybF5DwfaNYcxY34CC3dbY/pub?gid=134537666&single=true&output=csv")

# ╔═╡ aaf4fa35-bf96-430e-9475-eac3fd5cc435
dataraw = CSV.read(csvfilepath, DataFrame; header=false);

# ╔═╡ e5cea113-0d14-4013-89c3-906fab100332
withyear = filter(dataraw) do row
	s = row.Column7
	s isa AbstractString && tryparse(Int, s) !== nothing
end;

# ╔═╡ bf83d8c0-7bcd-4a0c-9b47-a6aa692aebc3
begin
	const data = rename(withyear, 
		:Column2 => :title, 
		:Column3 => :cat, 
		:Column4 => :cat2, 
		:Column5 => :cat3, 
		:Column7 => :year
	)
	data.year = parse.(Int64, data.year)
	data
end

# ╔═╡ 8babcdbd-c78f-41ad-a757-14334b05867e
function sort_category_by(cat)
	papers = filter(row -> row.cat === cat, eachrow(data))
	
		
	# most papers
	# length(papers)

	# mean paper publish date
	avg = sum(p.year for p in papers) / length(papers)
	
	# minimum paper publish date
	first_publish = minimum(p.year for p in papers)


	if sort_categories_by == 1
		(first_publish, avg)
	elseif sort_categories_by == 2
		-length(papers)
	elseif sort_categories_by == 3
		cat
	else
		error()
	end
end

# ╔═╡ 1b191616-1594-4fd4-a2fd-15c207963b2e
categories = let
	cs = data.cat |> unique
	sort(cs; by=sort_category_by, rev=false)
end

# ╔═╡ da8568ff-3ba1-40f2-9ab0-2a6dbaaeb59a
year_range = minimum(data.year):maximum(data.year)

# ╔═╡ 5c4849b3-ba52-4015-bce6-e972db1983ca
years = [
	start:(start+yearbundlesize-1)
	for start in year_range[begin]:yearbundlesize:year_range[end]
]

# ╔═╡ 9aac71ce-c49a-4a5d-bda4-54d7ce1e2443
function findpapers(year::Integer, cat)
	filter(row -> row.year === year && row.cat === cat, eachrow(data))
end

# ╔═╡ 6cce5acc-53ff-4c14-8fc4-55c348498fa9
function findpapers(years, cat)
	filter(row -> row.year ∈ years && row.cat === cat, eachrow(data))
end

# ╔═╡ 698d2f19-9257-4a18-bc36-55803f1b0281
higham_legacy = [
	length(findpapers(y, c))
	for c in categories, y in years
]

# ╔═╡ 3cd3f595-1f8b-4fc8-9388-b8782fa581f6
cond(higham_legacy)

# ╔═╡ e0f35d10-93b7-48f1-9e0e-6f367d16dbc9
svdvals(higham_legacy)

# ╔═╡ f1f2ab43-1b97-4524-8f8a-8d6b91a859cb
const maxcount = maximum((length(findpapers(year, cat)) for year in years, cat in categories))

# ╔═╡ 580dffd6-3bca-414b-94b6-3d2673210065
md"""
## Visualisation
"""

# ╔═╡ 27b2458d-7521-4fd8-b57f-e54250863549
import Colors, ColorSchemes

# ╔═╡ b95ed7a3-97bd-491b-a6ff-228fb65e663f
# you can pick a color scheme from the catalogue:
# http://juliagraphics.github.io/ColorSchemes.jl/stable/catalogue/
const fav_scheme = ColorSchemes.solar

# ╔═╡ 0c79d2db-d85e-4252-b8e1-f74487b909e5
function cellcolor(n)
	if n == 0
		Colors.ColorTypes.RGB{Float64}(.95,.95,.95)
	else
		all_colors[min(end,n)]
	# 	get(fav_scheme, 1.0 - n / maxcount)
	end
end

# ╔═╡ 7962c7e5-b782-4f03-9cf3-552d8e69deb9
function cell(year, cat)
	papers = findpapers(year, cat)

	n = length(papers)
	color = "#$(Colors.hex(cellcolor(n)))"
	title = join(("$i: $t" for (i,t) in enumerate(papers.title)), "\n")

	@htl """<div class="papercell" title=$title style="background: $color;"></div>"""
end

# ╔═╡ 0d653801-4358-435a-8292-d8e7cdb10a0b
@htl """
<style>
.thegrid {
	display: grid;
	grid-template-columns: max-content repeat($(length(years)), 1em);
	grid-template-rows: auto repeat($(length(categories)), 1em);
	grid-auto-flow: column;
	gap: 3px;
	padding: 1em;
	min-width: max-content;
	min-height: max-content;
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
	background: white;
	border-radius: .3em;
	color: black;
}

.papercell {
	width: 1em;
	border-radius: .1em;
}

.year {
	font-size: .7rem;
	text-align: center;
}

.categorytitle {
	background: #eee;
	border-radius: .1em;
	line-height: 1em;
}

</style>

<div class="thegrid" contain=all>
<div></div>

$((
@htl("""<div class="categorytitle">$cat</div>""") for cat in categories
))

$((
@htl("""
<div class="year">'$(string(minimum(year))[3:4])</div>
$((
cell(year, cat) for cat in categories
))

""") for year in years
))

</div>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
ColorSchemes = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
ColorTypes = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
FixedPointNumbers = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CSV = "~0.10.14"
ColorSchemes = "~3.26.0"
ColorTypes = "~0.11.5"
Colors = "~0.12.11"
DataFrames = "~1.6.1"
FixedPointNumbers = "~0.8.5"
HypertextLiteral = "~0.9.5"
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "0a1b1c0c7b270e04dd07be34e5f588a039e2de7e"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "7878ff7172a8e6beedd1dea14bd27c3c6340d361"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.22"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InlineStrings]]
git-tree-sha1 = "45521d31238e87ee9f9732561bfee12d4eebd52d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.2"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "66b20dd35966a748321d3b2537c4584cf40387c7"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "ff11acffdb082493657550959d4feb4b6149e73a"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.5"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "e84b3a11b9bece70d14cce63406bbc79ed3464d2"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.2"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─aa21898b-3abb-4cc5-b52d-51d4673e3047
# ╟─0d653801-4358-435a-8292-d8e7cdb10a0b
# ╟─a1574267-89e1-42ce-9e6f-e784116bb3cf
# ╟─4555e853-2535-46a2-b5fd-2501f69e5dd7
# ╟─b86212c7-175e-4d1e-bd48-634496584e09
# ╟─040b283d-b1a0-417c-9c75-5dbfe824c880
# ╟─9b7a819c-ab9f-4570-9d7c-66073fe140a5
# ╟─5ff7ad16-ecf6-48c6-a6f6-5bf0f9cda221
# ╟─ed664225-db50-40ef-9b34-a07d58dff657
# ╠═698d2f19-9257-4a18-bc36-55803f1b0281
# ╟─5ca24e51-91f6-46f4-8654-746e4a6f1163
# ╠═3cd3f595-1f8b-4fc8-9388-b8782fa581f6
# ╠═e0f35d10-93b7-48f1-9e0e-6f367d16dbc9
# ╠═ec2ff75c-3164-43a8-b7e0-6047e074450b
# ╟─de811896-927c-4e43-9c32-47c78cb695a1
# ╟─e2605eb3-3185-47bd-950c-cd04d66f874c
# ╠═f9770b24-50d2-11ef-0220-d70a8d2884de
# ╟─a65b429c-2a02-4dd0-b7b4-83eee020ac8f
# ╠═aaf4fa35-bf96-430e-9475-eac3fd5cc435
# ╠═e5cea113-0d14-4013-89c3-906fab100332
# ╠═bf83d8c0-7bcd-4a0c-9b47-a6aa692aebc3
# ╟─8babcdbd-c78f-41ad-a757-14334b05867e
# ╟─1b191616-1594-4fd4-a2fd-15c207963b2e
# ╟─da8568ff-3ba1-40f2-9ab0-2a6dbaaeb59a
# ╟─5c4849b3-ba52-4015-bce6-e972db1983ca
# ╟─f1f2ab43-1b97-4524-8f8a-8d6b91a859cb
# ╟─9aac71ce-c49a-4a5d-bda4-54d7ce1e2443
# ╟─6cce5acc-53ff-4c14-8fc4-55c348498fa9
# ╟─580dffd6-3bca-414b-94b6-3d2673210065
# ╠═3ba61e71-2ebc-4a69-a632-502ebb84ac46
# ╠═28eb6025-af86-4a66-bbc5-f44487838d8d
# ╠═9d42e4c7-1cb0-4e4f-9d87-56c255261436
# ╠═27b2458d-7521-4fd8-b57f-e54250863549
# ╠═b95ed7a3-97bd-491b-a6ff-228fb65e663f
# ╟─7962c7e5-b782-4f03-9cf3-552d8e69deb9
# ╟─0c79d2db-d85e-4252-b8e1-f74487b909e5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
