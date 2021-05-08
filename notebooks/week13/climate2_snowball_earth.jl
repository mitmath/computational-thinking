### A Pluto.jl notebook ###
# v0.14.4

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

# ╔═╡ a0b3813e-adab-11eb-2983-616cf2bb6f5e
using DifferentialEquations, Plots, PlutoUI, LinearAlgebra

# ╔═╡ ef8d6690-720d-4772-a41f-b260d306b5b2
TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)

# ╔═╡ 61960e99-2932-4a8f-9e87-f64a7a043489
md"""
a = $(@bind a Slider(-5:.1:5, show_value=true, default=0) )
b = $(@bind b Slider(-54:.01:10, show_value=true, default=0) )


y₀ = $(@bind y₀ Slider(-1.5:.01:5, show_value=true, default=2.0) )
"""

# ╔═╡ 6139554e-c6c9-4252-9d64-042074f68391
#f(y,(a,b),t) =  c*((y<7.55) ? b : 0 ) + (14-y)

f(y,(a,b),t) =  ((y<0) ? -1 : 1 )  - y + a

# ╔═╡ a09a0064-c6ab-4912-bc9f-96ab72b8bbca
sol = solve(  ODEProblem( f, y₀, (0,10.0), (a,b) ) );

# ╔═╡ bd65e7f9-ecf2-43ac-b5a8-99b03866a5c8
begin
	plot(y->f(y,(a,b),0), -2,-.01, xlabel="Temperature" , ylabel="dT/dt")
	plot!(y->f(y,(a,b),0), 0,2, xlabel="Temperature" , ylabel="dT/dt")
	
	hline!([0])
end

# ╔═╡ f8ee2373-6af0-4d81-98fb-23bde10198ef
begin
	p = plot( sol , legend=false, background_color_inside=:black , ylims=(-1.5+a,1.5+a), lw=3, c=:red)
	# plot direction field:
		xs = Float64[]
		ys = Float64[]
		
	    lrx = LinRange( xlims(p)..., 30)
		for x in  lrx
			for y in LinRange( ylims(p)..., 30)
				v = [1, f(y, (a,b) ,x) ]
				v ./=  (100* (lrx[2]-lrx[1]))
	
				
				push!(xs, x - v[1], x + v[1], NaN)
				push!(ys, y - v[2], y + v[2], NaN)
			
			end
		end
	if a<40 hline!( [-1+a],c=:white,ls=:dash); end
	    hline!( [1+a],c=:white,ls=:dash)
	    hline!( [0 ],c=:pink,ls=:dash)
		plot!(xs, ys, alpha=0.7, c=:yellow)
	    ylabel!("y")
	    annotate!(-.5,y₀,text("y₀",color=:red))
	    title!("Solution to y'(t) = a - by")
end

# ╔═╡ Cell order:
# ╠═a0b3813e-adab-11eb-2983-616cf2bb6f5e
# ╠═ef8d6690-720d-4772-a41f-b260d306b5b2
# ╠═61960e99-2932-4a8f-9e87-f64a7a043489
# ╟─6139554e-c6c9-4252-9d64-042074f68391
# ╠═a09a0064-c6ab-4912-bc9f-96ab72b8bbca
# ╠═bd65e7f9-ecf2-43ac-b5a8-99b03866a5c8
# ╠═f8ee2373-6af0-4d81-98fb-23bde10198ef
