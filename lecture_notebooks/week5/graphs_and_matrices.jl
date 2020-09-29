### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ 6e986f20-0270-11eb-071e-e14defbf6af7
using GraphPlot,LightGraphs

# ╔═╡ 9243aa1e-0272-11eb-0194-eda488d2736a
using PlutoUI

# ╔═╡ 66c4bda2-0271-11eb-3447-87dd5a3904bd
md"Graphs from [SpecialGraphs.jl](https://github.com/JuliaGraphs/SpecialGraphs.jl/tree/master/src)"

# ╔═╡ fbe17668-0272-11eb-1085-e98901c9ca7d
@bind choice PlutoUI.Select(["cycle", "wheel", "complete", "path"])

# ╔═╡ 0adfb774-0273-11eb-29c7-7bab996d8314
@bind n Slider(2:10, show_value=true)

# ╔═╡ 2446ba56-0272-11eb-2ad1-3d16e6334601

	
    f = Dict("cycle" => cycle_graph, "wheel" => wheel_graph, "complete" => complete_graph, "path" => path_graph)[choice]


# ╔═╡ 9e153cba-0270-11eb-03fc-17dd33397b80
begin
	 g = f(n);
end

# ╔═╡ 83bcda80-0270-11eb-2c17-533a150fd29f
begin	
	nodelabel = 1:nv(g)
	edgelabel = 1:ne(g)
	gplot(g, nodelabel=nodelabel, edgelabel=edgelabel)
end

# ╔═╡ d0db318e-0270-11eb-2773-0b01a4ff6e8b
am = Matrix(adjacency_matrix(g))

# ╔═╡ Cell order:
# ╠═6e986f20-0270-11eb-071e-e14defbf6af7
# ╟─66c4bda2-0271-11eb-3447-87dd5a3904bd
# ╠═fbe17668-0272-11eb-1085-e98901c9ca7d
# ╠═0adfb774-0273-11eb-29c7-7bab996d8314
# ╟─9e153cba-0270-11eb-03fc-17dd33397b80
# ╠═83bcda80-0270-11eb-2c17-533a150fd29f
# ╠═d0db318e-0270-11eb-2773-0b01a4ff6e8b
# ╟─2446ba56-0272-11eb-2ad1-3d16e6334601
# ╟─9243aa1e-0272-11eb-0194-eda488d2736a
