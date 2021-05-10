### A Pluto.jl notebook ###
# v0.14.5

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

# ╔═╡ 26e1879d-ab57-452a-a09f-49493e65b774
md"""
### Julia

### `sign(x)`
"""

# ╔═╡ fd12468f-de16-47cc-8210-9266ca9548c2
md"""
### The sign function
"""

# ╔═╡ 30969341-9079-4732-bf55-d6bba2c2c16c
md"""
`sign(x)` returns 0 if x is 0, or ±1 for positive/negative x.
"""

# ╔═╡ af7f36d9-adca-48b8-95bb-ac620e6f1b4f
sign(Inf)

# ╔═╡ 790add0f-c83f-4824-92ae-53159ce58f64
sign(-Inf)

# ╔═╡ 978e5fc0-ddd1-4e93-a243-a95d414123b9
md"""
The function  $f(y,a) = {\rm sign}(y) + a -y$ can be written

``f(y,a)= \left\{ \begin{array}{l} -1+a-y \ \ {\rm if} \ y<0  \ \ 
\textrm{(root at } a-1 \textrm{ if } a<1 )\\ 
\ \  \ 1+a-y \ \ {\rm if} \ y>0  
\ \ \textrm{(root at } a+1 \textrm{ if } a>-1 )
\end{array} \right.``

(we will ignore y=0).  Notice that for -1<a<1 there are two roots.
"""

# ╔═╡ 6139554e-c6c9-4252-9d64-042074f68391
f(y,a,t) =   sign(y)  + a -  y  # t is not used but in the argument list for the dif equation solver

# ╔═╡ e115cbbc-9d49-4fa1-8701-fa48289a0916
md"""
The graph of `z=f(y,a)`  consists of two parallel half-planes. On the left below we intersect that graph with planes of constant `a`.  On the right, we have the intersection with `z=0`. 
"""

# ╔═╡ 61960e99-2932-4a8f-9e87-f64a7a043489
md"""
a = $(@bind a Slider(-5:.1:5, show_value=true, default=0) )


"""

# ╔═╡ bd65e7f9-ecf2-43ac-b5a8-99b03866a5c8
begin
	plot( y->f(y,a, 0), -9, -eps(), xlabel="y" , ylabel="sign(y)-y+a", lw=3,color=:blue)
	plot!(y->f(y,a, 0), eps() ,9, lw=3, color=:blue)
	ylims!(-5,10)
	xlims!(-9,9)
	hline!([0], ls=:dash, color=:pink, legend=false)
    
	
	if a< 1
	 
	  annotate!( -2.2+a, -4, text(round(-1+a,digits=1), position=:right,11,:red))
	  scatter!([-1+a],[0],m=:circle,ms=10,color=:red)
	end
	if a>-1
	  
	  annotate!( 1+a, -4, text(round(1+a,digits=1), position=:right,11,:blue))
		 scatter!([1+a],[0],m=:circle,ms=10,color=:blue)
	end
	vline!([ 1+a], ls=:dash, color=:gray)
	 vline!([-1+a], ls=:dash, color=:gray)
	vline!([0],ls=:dash, color=:pink)
	P1 = title!("a=$a  Plot of f(y) given a")
	
	begin
	plot(a->a-1, -5:1, lw=2, c=:blue)
	plot!(a->a+1, -1:5, lw=2,  c=:blue, legend=false)
	xlabel!("a")
	ylabel!("equilibrum y=roots")
	title!("Roots as a function of a") 
		
		if a<1
			annotate!(-4,  -.7+a,  text(round(-1+a,digits=1), position=:center,11,:red))
			hline!([-1+a],c=:gray,ls=:dash)
			scatter!([a],[-1+a],m=:circle,ms=10,color=:red)
		end
		if a> -1
						annotate!(-4,  1.3+a,  text(round(1+a,digits=1), position=:center,11,:blue))
			hline!([1+a],c=:gray,ls=:dash)
			scatter!([a],[1+a],m=:circle,ms=10,color=:blue)
		end
		ylims!(-5,5)
	P2 = annotate!(0,-4.7, text("Two roots if -1<a<1",6,:blue) )
		vline!([a],c=:gray,ls=:dash)
	plot( P1 ,P2,layout=(1,2))
end
end

# ╔═╡ 5027e1f8-8c50-4538-949e-6c95c550016e
md"""
### Solution to y' = f(y,a) 
with y(0)=y₀
"""

# ╔═╡ 465f637c-0555-498b-a881-a2f6e5714cbb
md"""
y₀ = $(@bind y₀ Slider(-6:.01:6, show_value=true, default=2.0) )
"""

# ╔═╡ a09a0064-c6ab-4912-bc9f-96ab72b8bbca
sol = solve(  ODEProblem( f, y₀, (0,10.0), a ));

# ╔═╡ f8ee2373-6af0-4d81-98fb-23bde10198ef
function plotit(y₀, a)
	
	sol = solve(  ODEProblem( f, y₀, (0,10.0), a ));
	p = plot( sol , legend=false, background_color_inside=:black , ylims=(-7,7), lw=3, c=:red)
	
	# plot direction field:
		xs = Float64[]
		ys = Float64[]
		
	    lrx = LinRange( xlims(p)..., 30)
		for x in  lrx
			for y in LinRange( ylims(p)..., 30)
				v = [1, f(y, a ,x) ]
				v ./=  (100* (lrx[2]-lrx[1]))
	
				
				push!(xs, x - v[1], x + v[1], NaN)
				push!(ys, y - v[2], y + v[2], NaN)
			
			end
		end
	
	if a<1 hline!( [-1+a],c=:white,ls=:dash); end
	if a>-1  hline!( [1+a],c=:white,ls=:dash);end
	    hline!( [0 ],c=:pink,ls=:dash)
		plot!(xs, ys, alpha=0.7, c=:yellow)
	    ylabel!("y")
	    annotate!(-.5,y₀,text("y₀",color=:red))
	if a>-1
	   annotate!(5,1+a,text(round(1+a,digits=3),color=:white))
	end
	if a<1
	   annotate!(5,-1+a-.4,text(round(-1+a,digits=3),color=:white))
	end
    title!("Solution to y'=f(y,a)")
return(p)
end

# ╔═╡ a4686bca-90d6-4e02-961c-59f08fc37553
plotit(y₀, a)

# ╔═╡ ddcd8c23-9143-4053-a108-aae908dd5cc8
md"""
Root plot as a function of a
"""

# ╔═╡ 95444a7f-c2f9-4823-a5ca-7177476eb033
begin
	plot(a->a-1, -3:1, lw=2, c=:blue)
	plot!(a->a+1, -1:3, lw=2,  c=:blue, legend=false)
	xlabel!("a")
	ylabel!("equilibrum y=roots")
	title!("Roots of f(y,a) as a function of a") 
	annotate!(0,-4, text("Two roots if -1<a<1",12,:blue) )
end

# ╔═╡ a94b5160-f4bf-4ddc-9ee6-581ea20c8b90
md"""
#### Increasing a then decreasing a
Let's increase a by .25 from -4 to 4 then decrease from -4 to 4.
Every time we change a, we let 10 units of time evolve, enough
to reach the equilibriumf for that a, and watch the y values.

We see that when -1<a<1 it's possible to be at the "negative" equilibrium
or the "positive" equilibrium, depending on how you got there.
"""

# ╔═╡ fd882095-6cc4-4927-967c-6b02d5b1ad95
let
    Δt = 10
    t = 0.0
	y₀ =-5
	a = -4
	sol = solve(  ODEProblem( f, y₀, (t,t+Δt), a ))
	p=plot(sol)
	annotate!(10,-5,text("a=",7))
	
	
	
	for i= 1:32
		a += .25
		t += Δt
		y₀ = sol(t)
		sol = solve(  ODEProblem( f, y₀, (t,t+Δt), a ))
		
		if -1≤a ≤1
		  p=plot!(sol,xlims=(0,t), legend=false, fillrange=-5,fillcolor=:gray,alpha=.5)
		else
		  p=plot!(sol,xlims=(0,t), legend=false)
		end
		
		if i%4==0
			annotate!(t,-5,text( round(a,digits=1), 7, :blue))
		end
		
	
	end
	for i= 1:32
		a -= .25
		t += Δt
		y₀ = sol(t)
		sol = solve(  ODEProblem( f, y₀, (t,t+Δt), a ))
		
		if -1≤a≤1
		  p=plot!(sol,xlims=(0,t), legend=false, fillrange=-5,fillcolor=:gray,alpha=.5)
		else
		  p=plot!(sol,xlims=(0,t), legend=false)
		end
		
		if i%4==0
			annotate!(t,-5,text( round(a,digits=1), 7, :red))
		end
	end
	ylabel!("y")
	
	as_svg(plot!())
end

# ╔═╡ Cell order:
# ╠═a0b3813e-adab-11eb-2983-616cf2bb6f5e
# ╠═ef8d6690-720d-4772-a41f-b260d306b5b2
# ╠═26e1879d-ab57-452a-a09f-49493e65b774
# ╟─fd12468f-de16-47cc-8210-9266ca9548c2
# ╠═30969341-9079-4732-bf55-d6bba2c2c16c
# ╠═af7f36d9-adca-48b8-95bb-ac620e6f1b4f
# ╠═790add0f-c83f-4824-92ae-53159ce58f64
# ╟─978e5fc0-ddd1-4e93-a243-a95d414123b9
# ╠═6139554e-c6c9-4252-9d64-042074f68391
# ╟─e115cbbc-9d49-4fa1-8701-fa48289a0916
# ╟─bd65e7f9-ecf2-43ac-b5a8-99b03866a5c8
# ╟─61960e99-2932-4a8f-9e87-f64a7a043489
# ╠═a09a0064-c6ab-4912-bc9f-96ab72b8bbca
# ╟─5027e1f8-8c50-4538-949e-6c95c550016e
# ╟─465f637c-0555-498b-a881-a2f6e5714cbb
# ╠═a4686bca-90d6-4e02-961c-59f08fc37553
# ╟─f8ee2373-6af0-4d81-98fb-23bde10198ef
# ╟─ddcd8c23-9143-4053-a108-aae908dd5cc8
# ╠═95444a7f-c2f9-4823-a5ca-7177476eb033
# ╟─a94b5160-f4bf-4ddc-9ee6-581ea20c8b90
# ╠═fd882095-6cc4-4927-967c-6b02d5b1ad95
