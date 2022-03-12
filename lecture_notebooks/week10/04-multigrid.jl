### A Pluto.jl notebook ###
# v0.12.18

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

# ╔═╡ 9a012a40-51bb-11eb-3cf5-c1f18fa24e81
begin
	using Plots
	using PlutoUI
end

# ╔═╡ 523edf3c-51bf-11eb-06e0-2da64c65d871
function add_heaters!(T::AbstractMatrix; t_left_heater=40, t_right_heater=40)
	m, n = size(T)
	
	xdheater = n÷8#n÷8
	ydheater = n÷6

	T[(3*n÷8+1):(n÷2+1), 1:(xdheater)] .= t_left_heater 
	T[(n÷2+1):(5*n÷8+1), (n - xdheater+1):n] .= t_right_heater
	return T
end
	
	

# ╔═╡ b8dc007a-51bb-11eb-1929-8bbd024094f8
function grid_with_boundary(k; t_window = 5, 
	t_corner = 13, 
	t_wall = 21, 
	t_left_heater = 40, 
	t_right_heater = 40)
	
	n = 2^k
	xdheater = n÷16#n÷8
	ydheater = n÷6
	
	
	
	f = zeros(n+1, n+1)
	
	
	#window side
	f[1, 1:(n÷2 +1)] .= range(t_corner, t_window; length=n÷2 + 1)
	f[1, (n÷2+1):(3*n÷4)] .= 5
	f[1, (3*n÷4+1):(n+1)] .= range(t_window, t_corner; length=n÷4+1)
	
	# no-window-wall-side
	f[n+1, 1:n+1] .= t_wall
	 
	# left side, heater at 
	l_heater = 0
	f[1:(3*n÷8+1),1] .= range(t_corner, t_left_heater; length=3*n÷8+1)
	f[(n÷2+1):(n+1),1] .= range(t_left_heater, t_wall; length=n÷2+1)
	#right side
	f[1:(n÷2+1), n+1] .= range(t_corner, t_right_heater; length=n÷2+1)
	f[(5*n÷8+1):n+1, n+1] .= range(t_right_heater, t_wall; length=3*n÷8+1)

	# heaters
	add_heaters!(f)
	f
end

# ╔═╡ 57a2c18e-51bd-11eb-2ab6-2196bc31826d
T = grid_with_boundary(5)

# ╔═╡ 645b67be-51bd-11eb-100f-a33067209967
heatmap(T, yflip=true, ratio=1)

# ╔═╡ 979464d0-51bf-11eb-2b6f-c57ce3c4a177
function initial_condition(T)
	m, n = size(T)
	
	Tp = copy(T)
	for i in 2:m-1, j in 2:n-1
		Tp[i, j] = (j*T[i,n]+(n+1-j)*T[i,1] + 
			(m+1-i)*T[1,j] + i*T[m,j])/(m+n+2)
	end
	add_heaters!(Tp)
	return Tp
end

# ╔═╡ ddf84e50-51bf-11eb-2275-5b1c191fd86c
TT = initial_condition(T)

# ╔═╡ eb877780-51bf-11eb-29f4-eb6b19c70dab
heatmap(TT, yflip=true, ratio=1)

# ╔═╡ 1172be62-51bf-11eb-33a2-0bcc684aabc4
function jacobi_step(T::AbstractMatrix)
	m, n = size(T)
	T′ = deepcopy(T)	
	add_heaters!(T′)
	
	for i in 2:m-1, j in 2:n-1
		T′[i,j] = (T[i+1, j] + T[i-1, j] + T[i, j-1]+ T[i, j+1])/4 
	end
	return T′
end

# ╔═╡ b9f29b7c-51be-11eb-2397-75740f99afdb
function simulation(T, ϵ=1e-3; num_steps=200)
	results = [T]
	
	for i in 1:num_steps
		T′ = jacobi_step(T)
	#	add_heaters!(T′)
		
		push!(results, copy(T′))
		
		if maximum(abs.(T′-T)) < ϵ
			return results
		end
			
		T = copy(T′)
	end
	return results
end		

# ╔═╡ f2c1dc6a-51c0-11eb-0f74-0d40adb510d6
sim = simulation(initial_condition(grid_with_boundary(8)))

# ╔═╡ 3b721b6e-51c1-11eb-3b22-e71b9c9e779b
@bind i Slider(1:length(sim), show_value=true)

# ╔═╡ 146979f4-51c1-11eb-34c5-4b0b8f7faa77
heatmap(sim[i], yflip=true, ratio=1)

# ╔═╡ 3995d47a-51c1-11eb-2777-496d7aae22ae
md"""
# Better initial conditions
"""

# ╔═╡ ce5baa50-51c4-11eb-2931-37ac106dee50
coarse = initial_condition(grid_with_boundary(4))

# ╔═╡ 64fa3986-51c5-11eb-22a8-0b6e91141463
md"""
note this grid is not fine enough to resolve "european" radiators. Edit add_heaters!
"""

# ╔═╡ 06264738-51c5-11eb-12fa-d3e39cb2974a
heatmap(coarse, yflip=true, ratio=1)

# ╔═╡ a282dcf4-51c5-11eb-11c0-251708544c27
coarse_results = simulation(coarse, 1e-10, num_steps=5000); 

# ╔═╡ bf653d76-51c5-11eb-02ea-fd083318ad69
heatmap(coarse_results[end], yflip=true, ratio=1)

# ╔═╡ ce76d0e0-51c5-11eb-39e3-f1e309862f86
function uplevel(T)
	
	n = size(T, 1)
	k = floor(Int, log2(n-1))
	Tp = grid_with_boundary(k+1)
	add_heaters!(Tp)
	
	new_n = size(Tp, 1)
	
	for i in 2:new_n-1, j in 2:new_n-1
		
#		Tp[i, j] = T[i÷2, j÷2]
		Tp[i,j] = 1/4*(T[Int(floor((i+1)/2)), Int(floor((j+1)/2))] + 
			T[Int(ceil((i+1)/2)), Int(floor((j+1)/2))] + 
			T[Int(floor((i+1)/2)), Int(ceil((j+1)/2))] + 
			T[Int(ceil((i+1)/2)), Int(ceil((j+1)/2))]
		)
	end
	return Tp
end

# ╔═╡ 36355710-51c6-11eb-2c9f-49aafa1299f4
fine_init = uplevel(coarse_results[end])

# ╔═╡ 1561349a-51c7-11eb-0680-a3583182ed0e
heatmap(fine_init, yflip=true, ratio=1)

# ╔═╡ 2a89b496-51c7-11eb-23c4-13468d2dafc4
function multilevel(T, k_final)
	
	n = size(T,1)
	k_start = floor(Int, log2(n-1))
	ks = Int[]
	iterations = Int[]
	
	for k in k_start:k_final
		push!(ks, k)
		
		results = simulation(T, 1e-2; num_steps=5000)
		push!(iterations, length(results))
		
		T = results[end]
		
		if k < k_final
			T = uplevel(T)
		end
	end
	return T, ks, iterations
end

# ╔═╡ 6fc2ef0a-51c7-11eb-0e7f-bb814652e55b
starting_point = initial_condition(grid_with_boundary(4)); 

# ╔═╡ 7bc0793a-51c7-11eb-2351-07de34312ca0
heatmap(starting_point, yflip=true, ratio=1)

# ╔═╡ 8b23aa78-51c7-11eb-04e8-e597978443bc
@elapsed last, ks, iterations = multilevel(starting_point, 10)

# ╔═╡ 9abbf7d0-51c7-11eb-22fe-b7571e67d774
ks

# ╔═╡ 9d4e7f02-51c7-11eb-35b0-196fe82c0926
iterations

# ╔═╡ a939045e-51c7-11eb-1838-3712862e37e3
cost = sum([iterations[i]/(2^(j)) for (i,j) in zip(7:-1:1,0:2:11)])

# ╔═╡ 0c4e53f6-51c9-11eb-20dd-9586c6741f65
cost2 = iterations[7]/1 + iterations[6]/4 + iterations[5]/2^4 + iterations[4]/2^6 + iterations[3]/2^8 +iterations[2]/2^10 + iterations[1]/2^11

# ╔═╡ ab32bccc-51c8-11eb-135d-554aa86de7a7
for (i,j) in zip(1:5, 5:1) @debug(i,j) end

# ╔═╡ 5cb7e206-51c9-11eb-04dd-9b1632a51c74
heatmap(last, yflip=true, ratio=1)

# ╔═╡ Cell order:
# ╠═9a012a40-51bb-11eb-3cf5-c1f18fa24e81
# ╠═b8dc007a-51bb-11eb-1929-8bbd024094f8
# ╠═57a2c18e-51bd-11eb-2ab6-2196bc31826d
# ╠═645b67be-51bd-11eb-100f-a33067209967
# ╠═979464d0-51bf-11eb-2b6f-c57ce3c4a177
# ╠═ddf84e50-51bf-11eb-2275-5b1c191fd86c
# ╠═eb877780-51bf-11eb-29f4-eb6b19c70dab
# ╠═b9f29b7c-51be-11eb-2397-75740f99afdb
# ╠═1172be62-51bf-11eb-33a2-0bcc684aabc4
# ╠═523edf3c-51bf-11eb-06e0-2da64c65d871
# ╠═f2c1dc6a-51c0-11eb-0f74-0d40adb510d6
# ╠═3b721b6e-51c1-11eb-3b22-e71b9c9e779b
# ╠═146979f4-51c1-11eb-34c5-4b0b8f7faa77
# ╟─3995d47a-51c1-11eb-2777-496d7aae22ae
# ╠═ce5baa50-51c4-11eb-2931-37ac106dee50
# ╟─64fa3986-51c5-11eb-22a8-0b6e91141463
# ╠═06264738-51c5-11eb-12fa-d3e39cb2974a
# ╠═a282dcf4-51c5-11eb-11c0-251708544c27
# ╠═bf653d76-51c5-11eb-02ea-fd083318ad69
# ╠═ce76d0e0-51c5-11eb-39e3-f1e309862f86
# ╠═36355710-51c6-11eb-2c9f-49aafa1299f4
# ╠═1561349a-51c7-11eb-0680-a3583182ed0e
# ╠═2a89b496-51c7-11eb-23c4-13468d2dafc4
# ╠═6fc2ef0a-51c7-11eb-0e7f-bb814652e55b
# ╠═7bc0793a-51c7-11eb-2351-07de34312ca0
# ╠═8b23aa78-51c7-11eb-04e8-e597978443bc
# ╠═9abbf7d0-51c7-11eb-22fe-b7571e67d774
# ╠═9d4e7f02-51c7-11eb-35b0-196fe82c0926
# ╠═a939045e-51c7-11eb-1838-3712862e37e3
# ╠═0c4e53f6-51c9-11eb-20dd-9586c6741f65
# ╠═ab32bccc-51c8-11eb-135d-554aa86de7a7
# ╠═5cb7e206-51c9-11eb-04dd-9b1632a51c74
