### A Pluto.jl notebook ###
# v0.14.3

using Markdown
using InteractiveUtils

# ╔═╡ f1261dab-6736-4b0a-803b-b2d2836ca24a
Pkg.add("ColorSchemes")

# ╔═╡ 1ccb3a84-88d4-11eb-2499-91af66e78e89
using Plots

# ╔═╡ 3fa5970e-8d82-11eb-302e-d53a453e984f
using SpecialFunctions

# ╔═╡ 2e8a0d14-8d6a-11eb-3a36-01676cf20447
using VegaLite, VegaDatasets

# ╔═╡ a400134c-8dc7-11eb-3a29-f99c5910de8c
using DataFrames

# ╔═╡ 8d4852d8-88d4-11eb-10e6-51c750d36b54
using PlutoUI

# ╔═╡ 47452d72-88d6-11eb-27ef-bbc1d061060d
md"""
## Resources



* Plots Docs [Useful Tips](https://docs.juliaplots.org/latest/basics/#Useful-Tips)
* Plots Docs [Examples](https://docs.juliaplots.org/latest/generated/gr/)
* [Plot Attributes](http://docs.juliaplots.org/latest/generated/attributes_plot/)
* [Axis Attributes](http://docs.juliaplots.org/latest/generated/attributes_axis/#Axis)
* [Color Names](http://juliagraphics.github.io/Colors.jl/stable/namedcolors/)
"""

# ╔═╡ 2a2338e4-88d4-11eb-0e6b-03609b700baa
md"""
## Loading Time 

Plots loading time sucks big time.
This is a known problem.  We know, we know, Julia is fast, just grab some coffee ....
☕☕☕☕☕☕☕☕☕
"""

# ╔═╡ 6a65fab1-35fc-41a7-bb24-03b8cd97f482
md"""
Test 2
"""

# ╔═╡ 4316799c-88d4-11eb-0e83-a7df319711ad
md"""
## Hello World
"""

# ╔═╡ 6fcad280-88d4-11eb-310f-5f89a5d21f9b
plot(rand(4))

# ╔═╡ 63da4054-88d5-11eb-29c9-b3648548c367
md"""
## Adding Stuff
"""

# ╔═╡ 6b55e978-88d5-11eb-1fea-739e61bbb35a
begin
		plot!(rand(4))
		scatter!(rand(4))
end

# ╔═╡ 198eb00c-88d5-11eb-3d3c-3963d197f0e0
md"""
## Removing Stuff
"""

# ╔═╡ 2b4cc1d0-88d5-11eb-0afd-3988abd9a870
plot!(legend=false, axis=false, grid=false, ticks=false )

# ╔═╡ dd81f7a5-1acf-430d-9d25-ab2877bf34cf
md"""
## Lines and points
"""

# ╔═╡ a2114f43-709f-46c2-ba16-8030ec83a2ce


# ╔═╡ cf89db1e-88d7-11eb-2a92-850c7d46a296
md"""
## Square Aspect Ratio
"""

# ╔═╡ da7b4c10-88d7-11eb-011e-dbb639e6fa2b
begin
	v = rand(4)
	plot(v, ratio=1, legend=false)
	scatter!(v)
end

# ╔═╡ cca58686-88d8-11eb-2fe4-d7d378c5408a
md"""
##  Matrices with color (heatmap)
yflip = true places the 2,1 entry where you want it, since you want to interchange xy with ij and i runs down and y runs up.
"""

# ╔═╡ d2c81aec-88d8-11eb-0e25-57a2068c3bf9
A = [ 1 1000 1 ; 1 1 1; 1 1 1]

# ╔═╡ e3f7d1ea-88d8-11eb-21bf-cbcdec1e8810
heatmap(A, ratio=1, yflip=true, legend=false, axis=false, grid=false,  ticks=false)

# ╔═╡ b059780e-88db-11eb-028c-6b07355fb1ab
heatmap( rand(10,10), clim=(0,1), ratio=1, legend=false, axis=false, ticks=false)

# ╔═╡ 48561d5a-8991-11eb-2a55-db793e4c9fea
begin
	MM = [ 0 1 0; 0 0 0; 1 0 0]
	
	whiteblack = [RGBA(1,1,1,0), RGB(0,0,0)]
	 heatmap(c=whiteblack, MM, aspect_ratio = 1, ticks=.5:3.5, lims=(.5,3.5), gridalpha=1, legend=false, axis=false, ylabel="i", xlabel="j")
end

# ╔═╡ 1bc15efe-8a44-11eb-11e4-5349f4279202
begin
	p=plot(1:4,guideposition=:top)
end

# ╔═╡ 63a807fe-8a44-11eb-3a3f-23fdf0804149
begin
	p.attr[:foreground_color] = RGB(1,0,0)
	p.attr[:foreground_color]
end

# ╔═╡ a0cd1d04-8a44-11eb-248c-1f5d699d60d2
p

# ╔═╡ b3aba314-8a44-11eb-0ea1-c9aafbecbd7e
begin
		q = (p.series_list[1]).plotattributes
	    q.explicit[:linecolor]=:green
end

# ╔═╡ 5bb7a350-8a45-11eb-15eb-d76bc70ab2bc
p

# ╔═╡ 15e03bd0-898c-11eb-3424-6fc74206ce9a
md"""
## Colors
"""

# ╔═╡ 855cae06-898e-11eb-36d5-0ddaf08022e9
Colors.color_names

# ╔═╡ 1d8dd040-898c-11eb-387b-3143b3997eee
mycolors = [colorant"lightslateblue",colorant"limegreen",colorant"red"]

# ╔═╡ 3d2c46d0-898b-11eb-3073-e1012b3ebb67
begin
	
	AA = [i for i=50:300, j=1:100]

	heatmap(AA, c=mycolors, clim=(1,300))
	
end

# ╔═╡ 0b8a01aa-8993-11eb-2e43-074f49edc175
md"""
## Area under curves
"""

# ╔═╡ e2046a88-8991-11eb-0906-2f0e89a943c3
begin
	y = rand(10)
	plot(y, fillrange= y.*0 .+ .5, label= "above/below 1/2", legend =:topleft)
end

# ╔═╡ a990150c-8992-11eb-22f5-bfdf98f17298
begin
	x = LinRange(0,2,100)
	y1 = exp.(x)
	y2 = exp.(1.3 .* x)
	
	plot(x, y1, fillrange = y2, fillalpha = 0.35, c = 1, label = "Confidence band", legend = :topleft)
end

# ╔═╡ 940bd6dc-8c12-11eb-09a2-89206356c143
let
	x = -3:.01:3
	areaplot(x, exp.(-x.^2/2)/√(2π),alpha=.25,legend=false)
end

# ╔═╡ 78727c02-8c13-11eb-16b7-bd7d4414577d
begin
	M = [1 2 3; 7 8 9; 4 5 6; 0 .5 1.5]
	areaplot(1:3, M, seriescolor = [:red :green :blue ], fillalpha = [0.2 0.3 0.4])
end

# ╔═╡ b8435896-8d81-11eb-3d44-7db7b987f992
let
	f = x->exp(-x^2/2)/√(2π)
	δ = .01
	plot()
	x = √2 .* erfinv.(2 .*(δ/2 : δ : 1) .- 1)
	areaplot( x, f.(x), seriescolor=[ :red,:blue], legend=false)
	plot!( f, x,c=:black)
end

# ╔═╡ d2c45794-8c12-11eb-17bb-a37bae10d084
md"""
## Shapes
"""

# ╔═╡ dcafeb72-8bce-11eb-23ae-37cad92e0f82
begin
	rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])
	circle(r,x,y) = (θ = LinRange(0,2π,500); (x.+r.*cos.(θ), y.+r.*sin.(θ)))
end

# ╔═╡ d7c8534e-8c12-11eb-211f-6b8718e52dd7
begin
	plot(circle(5,0,0), ratio=1, c=:red, fill=true)
	plot!(rectangle(5*√2,5*√2,-2.5*√2,-2.5*√2),c=:white,fill=true,legend=false)
end

# ╔═╡ c798a01a-8b51-11eb-2517-c7f45234db58
md"""
## Editing Plots manually
"""

# ╔═╡ dbfaa24e-8b51-11eb-3c20-bf7919c3a167
pl = plot(1:4,[1, 4, 9, 16])

# ╔═╡ ebbb02a0-8b51-11eb-08ef-4bb2f55782c1
pl.attr

# ╔═╡ f9490ca8-8b49-11eb-3bab-a3569a181f63
pl.series_list[1]

# ╔═╡ 131aa286-8b4a-11eb-3b4b-fb34a39cc7fb
pl[:size]=(300,200)

# ╔═╡ 111bec42-8b4a-11eb-08ca-e194014175f7
pl

# ╔═╡ f5df0246-8d80-11eb-0fb8-e79a0d5d7a23
md"""
##  VegaLite
"""

# ╔═╡ 78f0c7c6-8d6a-11eb-29f4-af99ddf71960
@vlplot(:point, rand(10), rand(10) )

# ╔═╡ 129de546-8d81-11eb-2ea0-a3e60e88ae13
begin
	dataset("zipcodes") |>
	@vlplot(
	    :circle,
	    width=500, height=300,
	    transform=[{calculate="substring(datum.zip_code, 0, 1)", as=:digit}],
	    projection={type=:albersUsa},
	    longitude=:longitude,
	    latitude=:latitude,
	    size={value=1},
	    color="digit:n"
	)
end

# ╔═╡ 837a7086-8dc7-11eb-3397-e10d6f40481f
 d = DataFrame(dataset("zipcodes"))

# ╔═╡ c0494eba-8dc7-11eb-3c1a-1f19979a4f4a
scatter( d[!,:longitude], d[!,:latitude], m=:., ms=1, xlim=(-150,-50), ylim=(20,55))

# ╔═╡ 3395ee1c-8d81-11eb-3e94-b1373d69dc93


# ╔═╡ 6dbc29fc-8da3-11eb-3196-e1e235eb6e86
begin
	
	struct RankOneMatrix{T} 
	  v::AbstractVector{T}
	   w::AbstractVector{T}
	end
	

	
	
end

# ╔═╡ 2e9d597e-8da5-11eb-114b-5f87731d4ced


# ╔═╡ 41e5e100-8da4-11eb-3bb8-d9d414af8e2a
RankOneMatrix( rand(3) , rand(3) )

# ╔═╡ e9b2b30e-8da4-11eb-04b3-8ba421898f0a
methods(RankOneMatrix)

# ╔═╡ 311ce496-8dad-11eb-330c-d3757a6fac8f
begin
	xx = .1:.1:1
	plot(xx.^2, xaxis=:log, yaxis=:log)
end

# ╔═╡ 5ae674d6-8dad-11eb-3abf-6fdbbb6cfe43
begin
	
	plot(exp.(x), yaxis=:log)
end

# ╔═╡ 71d1e4f0-8dad-11eb-368c-4b8bf284f5ec


# ╔═╡ eb3e721e-88d4-11eb-1f09-cfba69f498d4
TableOfContents()

# ╔═╡ Cell order:
# ╠═1ccb3a84-88d4-11eb-2499-91af66e78e89
# ╟─47452d72-88d6-11eb-27ef-bbc1d061060d
# ╟─2a2338e4-88d4-11eb-0e6b-03609b700baa
# ╠═6a65fab1-35fc-41a7-bb24-03b8cd97f482
# ╟─4316799c-88d4-11eb-0e83-a7df319711ad
# ╠═6fcad280-88d4-11eb-310f-5f89a5d21f9b
# ╟─63da4054-88d5-11eb-29c9-b3648548c367
# ╠═6b55e978-88d5-11eb-1fea-739e61bbb35a
# ╟─198eb00c-88d5-11eb-3d3c-3963d197f0e0
# ╠═2b4cc1d0-88d5-11eb-0afd-3988abd9a870
# ╠═dd81f7a5-1acf-430d-9d25-ab2877bf34cf
# ╠═a2114f43-709f-46c2-ba16-8030ec83a2ce
# ╟─cf89db1e-88d7-11eb-2a92-850c7d46a296
# ╠═da7b4c10-88d7-11eb-011e-dbb639e6fa2b
# ╟─cca58686-88d8-11eb-2fe4-d7d378c5408a
# ╠═d2c81aec-88d8-11eb-0e25-57a2068c3bf9
# ╠═e3f7d1ea-88d8-11eb-21bf-cbcdec1e8810
# ╠═b059780e-88db-11eb-028c-6b07355fb1ab
# ╠═48561d5a-8991-11eb-2a55-db793e4c9fea
# ╠═1bc15efe-8a44-11eb-11e4-5349f4279202
# ╠═63a807fe-8a44-11eb-3a3f-23fdf0804149
# ╠═a0cd1d04-8a44-11eb-248c-1f5d699d60d2
# ╠═b3aba314-8a44-11eb-0ea1-c9aafbecbd7e
# ╠═5bb7a350-8a45-11eb-15eb-d76bc70ab2bc
# ╟─15e03bd0-898c-11eb-3424-6fc74206ce9a
# ╠═855cae06-898e-11eb-36d5-0ddaf08022e9
# ╠═1d8dd040-898c-11eb-387b-3143b3997eee
# ╠═3d2c46d0-898b-11eb-3073-e1012b3ebb67
# ╟─0b8a01aa-8993-11eb-2e43-074f49edc175
# ╠═e2046a88-8991-11eb-0906-2f0e89a943c3
# ╠═a990150c-8992-11eb-22f5-bfdf98f17298
# ╠═940bd6dc-8c12-11eb-09a2-89206356c143
# ╠═78727c02-8c13-11eb-16b7-bd7d4414577d
# ╠═3fa5970e-8d82-11eb-302e-d53a453e984f
# ╠═b8435896-8d81-11eb-3d44-7db7b987f992
# ╟─d2c45794-8c12-11eb-17bb-a37bae10d084
# ╠═dcafeb72-8bce-11eb-23ae-37cad92e0f82
# ╠═d7c8534e-8c12-11eb-211f-6b8718e52dd7
# ╠═c798a01a-8b51-11eb-2517-c7f45234db58
# ╠═dbfaa24e-8b51-11eb-3c20-bf7919c3a167
# ╠═ebbb02a0-8b51-11eb-08ef-4bb2f55782c1
# ╠═f9490ca8-8b49-11eb-3bab-a3569a181f63
# ╠═131aa286-8b4a-11eb-3b4b-fb34a39cc7fb
# ╠═111bec42-8b4a-11eb-08ca-e194014175f7
# ╟─f5df0246-8d80-11eb-0fb8-e79a0d5d7a23
# ╠═2e8a0d14-8d6a-11eb-3a36-01676cf20447
# ╠═78f0c7c6-8d6a-11eb-29f4-af99ddf71960
# ╠═129de546-8d81-11eb-2ea0-a3e60e88ae13
# ╠═837a7086-8dc7-11eb-3397-e10d6f40481f
# ╠═c0494eba-8dc7-11eb-3c1a-1f19979a4f4a
# ╠═a400134c-8dc7-11eb-3a29-f99c5910de8c
# ╟─3395ee1c-8d81-11eb-3e94-b1373d69dc93
# ╠═6dbc29fc-8da3-11eb-3196-e1e235eb6e86
# ╠═2e9d597e-8da5-11eb-114b-5f87731d4ced
# ╠═41e5e100-8da4-11eb-3bb8-d9d414af8e2a
# ╠═e9b2b30e-8da4-11eb-04b3-8ba421898f0a
# ╠═311ce496-8dad-11eb-330c-d3757a6fac8f
# ╠═5ae674d6-8dad-11eb-3abf-6fdbbb6cfe43
# ╠═71d1e4f0-8dad-11eb-368c-4b8bf284f5ec
# ╠═8d4852d8-88d4-11eb-10e6-51c750d36b54
# ╟─eb3e721e-88d4-11eb-1f09-cfba69f498d4
# ╠═f1261dab-6736-4b0a-803b-b2d2836ca24a
