### A Pluto.jl notebook ###
# v0.12.4

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

# ╔═╡ 89ab29f2-1ad2-11eb-2aa1-a7fae56d7fd8
begin
	using Plots
	using PlutoUI
end

# ╔═╡ 32e91c48-1ad2-11eb-262e-e97ac9fa9a2d
function grid_with_boundary(k)

    n = 2^k
    
    # Grid:
    f = zeros(n+1, n+1)
    
    # Boundary Conditions:
	
	# Bottom
	f[1, 1:(n÷2 +1)] .= range(13,5;length= n÷2 +1)
	f[1, (n÷2+1):(3*n÷4)] .= 5
	f[1, (3*n÷4+1):(n+1)] .= range(5,13;length=n÷4+1)
    
    # Top
    f[n+1, 1:n+1] .= 21
    
    # Left
    f[1:(3*n÷8+1), 1] .= range(13,40;length=3*n÷8+1)
    f[(n÷2+1):n+1, 1] .= range(40,21,length=n÷2+1)
    
    # Right
    f[1:(n÷2+1), n+1] .= range(13,40;length=n÷2+1)
    f[(5*n÷8+1):n+1, n+1] .= range(40,21;length=3*n÷8+1)

    # Heaters:
    f[(3*n÷8+1):(n÷2+1), 1:(n÷8+1)] .= 40
    f[(n÷2+1):(5*n÷8+1), (7*n÷8+1):n+1] .= 40

    return f

end

# ╔═╡ 79741a14-1ad2-11eb-34e1-7feadae4168e
function jacobi_step(T::AbstractMatrix)

    m, n = size(T)

    T′ = deepcopy(T)

    # iterate over interior:
    for i in 2:m-1, j in 2:n-1
        
		# Jacobi update
        T′[i, j] = (T[i+1, j] + T[i-1, j] + T[i, j-1] + T[i, j+1]) / 4  
		 
    end

    return T′

end

# ╔═╡ 664637ba-1ad2-11eb-0382-b99596159809
function add_heaters!(T)

    n = size(T, 1)-1
	
    T[(3*n÷8+1):(n÷2+1), 1:(n÷8+1)] .= 40
    T[(n÷2+1):(5*n÷8+1), (7*n÷8+1):n+1] .= 40
	
end

# ╔═╡ 5805d042-1ad5-11eb-0f93-110cd0c6d41e
function simulation(T, ϵ=1e-3, num_steps=200)

    results = [T]

    for i in 1:num_steps

        T′ = jacobi_step(T)
        add_heaters!(T′)

        push!(results, copy(T′))
		
		if maximum(abs.(T′ - T)) < ϵ
			return results
		end

        T = copy(T′)

    end

    return results
end

# ╔═╡ 9a57746c-1ad0-11eb-3b48-c1d7877ef61a
T = grid_with_boundary(5)

# ╔═╡ bf076518-1ad0-11eb-3b74-5bb405031a2b
@elapsed results = simulation(T,1e-10, 5000)

# ╔═╡ 9997a2de-1ad2-11eb-2eaa-6dcd337db44d
@bind i Slider(1:length(results), show_value=true)

# ╔═╡ ab4b6a1a-1ad2-11eb-0536-873dab9733ee
i

# ╔═╡ 5d594710-1b80-11eb-0c14-8b824654c196
showp(h) = PlutoUI.Show(MIME"image/svg+xml"(), repr(MIME"image/svg+xml"(), h))

# ╔═╡ 98fb5f6a-1c7f-11eb-0b2e-a5185e8d7649
myheatmap(T) = heatmap(T, yflip=true, ratio=1)

# ╔═╡ af8777ae-1ad2-11eb-14b4-9d557cb5efa2
showp(myheatmap(results[i]))

# ╔═╡ 113b8616-1ad3-11eb-1099-ebfe49db3815
extrema((results[end] - results[end-1]))

# ╔═╡ 449547f4-1ad3-11eb-23e4-39b0d4e8f0f7
md"""
## Better initial condition
"""

# ╔═╡ 95da5910-1ad3-11eb-1872-155aad1d8ae2
md"""
We've seen that Jacobi is a *local* method.

Putting zeros everywhere is a terrible initial condition.
"""

# ╔═╡ d0f8cda6-1ad3-11eb-0717-57ce76bfd3c8
function initial_condition(T)
	
	m, n = size(T)
	
	T′ = copy(T)
	
	for i in 2:m-1
		for j in 2:n-1
	
		# weighted average of boundaries:
		T′[i, j] = ( j * T[i, n] + (n + 1 - j) * T[i, 1] + 
					(m + 1 - i) * T[1, j] + i * T[m, j]) / (m + n + 2)
			
		end
	end
	
	return T′
	
end

# ╔═╡ 6a7a1656-1ad4-11eb-2fd0-3fe69d6c6c4d
TT = grid_with_boundary(10);

# ╔═╡ 74e6e18a-1ad4-11eb-389e-6b95f00eac8c
TT′ = initial_condition(TT);

# ╔═╡ 923bd7c6-1ad4-11eb-35ce-55d99debaa5e
add_heaters!(TT′);

# ╔═╡ 857aebe2-1ad4-11eb-373c-bb0039279a74
heatmap(TT′, yflip=true, ratio=1)

# ╔═╡ 9877d516-1ad4-11eb-096b-75d3e8811259
@elapsed results2 = simulation(TT′, 1e-2,500)

# ╔═╡ aa80f116-1ad4-11eb-0742-a992b8278c4b
@bind i2 Slider(1:length(results2), show_value=true)

# ╔═╡ b5af2d1e-1ad4-11eb-01bb-3ffe82f8bbb0
showp(heatmap(results2[i2], yflip=true, ratio=1))

# ╔═╡ 861efa52-1c82-11eb-3e5f-9f45aadd3054
extrema((results2[end] - results2[end-1]))

# ╔═╡ 3047db8e-1ad5-11eb-0b3c-6da3fc2251b0
md"""
## Thinking Hierarchically: Coarse to fine grid

Solve the problem almost exactly on a coarse grid
"""

# ╔═╡ 8d946d20-1c7e-11eb-1d87-3d7228c4945e
coarse = initial_condition(grid_with_boundary(4));

# ╔═╡ 4dc4ec56-1ad5-11eb-0969-c7cd1728bb68
add_heaters!(coarse);

# ╔═╡ debadd2e-1ad5-11eb-0bb6-99037ade1f6f
heatmap(coarse, yflip=true, ratio=1)

# ╔═╡ 96032a3c-1ad5-11eb-242b-b7d2b6c54568
coarse_results = simulation(coarse, 1e-10, 5000);

# ╔═╡ b01fbeee-1ad5-11eb-0c27-359d42df7775
length(coarse_results)

# ╔═╡ 1a04f8ce-1ad6-11eb-3e8b-ad10bbc2a217
myheatmap(coarse_results[end])

# ╔═╡ 27b3c57c-1ad6-11eb-2546-0fe68a40bf06
begin 
	fine_size = 2^10
	coarse_size = 2^4
	
	fine_size^2 / coarse_size^2
end

# ╔═╡ 4325b748-1ad6-11eb-20cc-d75cdbb1fbe5
md"""
So the whole Jacobi calculation on the coarse grid corresponds to <1 step on the fine grid.
"""

# ╔═╡ 4fada552-1ad6-11eb-0e25-77b981c007c2
function uplevel(T)

	n = size(T, 1)
	k = floor(Int, log2(n - 1))
	
	T′ = grid_with_boundary(k + 1)
	
	add_heaters!(T′)
	
	new_n = size(T′, 1)
	
	for i in 2:new_n-1
		for j in 2:new_n-1
			
			# T'[i,j] = T[i÷2,j÷2]
			
			T′[i, j] = (T[Int(floor((i+1)/2)), Int(floor((j+1)/2))] 
						+ T[Int(ceil((i+1)/2)), Int(floor((j+1)/2))] 
						+ T[Int(floor((i+1)/2)), Int(ceil((j+1)/2))] 
						+ T[Int(ceil((i+1)/2)), Int(ceil((j+1)/2))])/4
			
		end
	end
	
	return T′
end
			
			

# ╔═╡ bdf66322-1ad7-11eb-1fc4-05c6877a1782
next = uplevel(coarse_results[end]);

# ╔═╡ 521c2858-1c80-11eb-0b03-c90d72040f5c
add_heaters!(next);

# ╔═╡ c45f7ec2-1ad7-11eb-0ff1-890a3dac8e95
myheatmap(next)

# ╔═╡ 1ab1b858-1ad8-11eb-09e8-47133b186c2b
function multilevel(T, k_final)
	
	n = size(T, 1)
	k_start = floor(Int, log2(n - 1))
	
	ks = Int[]
	iterations = Int[]
	
	for k in k_start: k_final
		push!(ks, k)
		
		results = simulation(T, 1e-2, 5000)
		push!(iterations, length(results))
		
		T = results[end]
		
		if k < k_final
			T = uplevel(T)
			add_heaters!(T)
		end
	end
	
	return T, ks, iterations
end
	

# ╔═╡ 882bf17a-1ad8-11eb-254e-1bafa2b2f599
starting_point = initial_condition(grid_with_boundary(4));

# ╔═╡ fcfebd94-1c80-11eb-35a5-4b6c26df5913
add_heaters!(starting_point);

# ╔═╡ 4e3e2892-1ad9-11eb-1cf8-61058302f3cb
@elapsed last, ks, iterations = multilevel(starting_point, 10)

# ╔═╡ 77d779a2-1c81-11eb-14fc-bd9a86cb7090
ks

# ╔═╡ 302dc78c-1c81-11eb-09c5-355d90caf574
iterations

# ╔═╡ b6802886-1c81-11eb-0f02-db9fd5c65a4d
cost = iterations[7] + iterations[6]/4 + iterations[5]/16 + iterations[4]/64 + iterations[3]/256 + iterations[2]/1024 + iterations[1]/2048

# ╔═╡ 7bb49244-1c81-11eb-1c7e-8bd4b88d9214
myheatmap(last)

# ╔═╡ Cell order:
# ╠═89ab29f2-1ad2-11eb-2aa1-a7fae56d7fd8
# ╠═32e91c48-1ad2-11eb-262e-e97ac9fa9a2d
# ╠═5805d042-1ad5-11eb-0f93-110cd0c6d41e
# ╠═79741a14-1ad2-11eb-34e1-7feadae4168e
# ╟─664637ba-1ad2-11eb-0382-b99596159809
# ╠═9a57746c-1ad0-11eb-3b48-c1d7877ef61a
# ╠═bf076518-1ad0-11eb-3b74-5bb405031a2b
# ╠═9997a2de-1ad2-11eb-2eaa-6dcd337db44d
# ╠═ab4b6a1a-1ad2-11eb-0536-873dab9733ee
# ╟─5d594710-1b80-11eb-0c14-8b824654c196
# ╠═98fb5f6a-1c7f-11eb-0b2e-a5185e8d7649
# ╠═af8777ae-1ad2-11eb-14b4-9d557cb5efa2
# ╠═113b8616-1ad3-11eb-1099-ebfe49db3815
# ╟─449547f4-1ad3-11eb-23e4-39b0d4e8f0f7
# ╟─95da5910-1ad3-11eb-1872-155aad1d8ae2
# ╠═d0f8cda6-1ad3-11eb-0717-57ce76bfd3c8
# ╠═6a7a1656-1ad4-11eb-2fd0-3fe69d6c6c4d
# ╠═74e6e18a-1ad4-11eb-389e-6b95f00eac8c
# ╠═923bd7c6-1ad4-11eb-35ce-55d99debaa5e
# ╠═857aebe2-1ad4-11eb-373c-bb0039279a74
# ╠═9877d516-1ad4-11eb-096b-75d3e8811259
# ╠═aa80f116-1ad4-11eb-0742-a992b8278c4b
# ╠═b5af2d1e-1ad4-11eb-01bb-3ffe82f8bbb0
# ╠═861efa52-1c82-11eb-3e5f-9f45aadd3054
# ╠═3047db8e-1ad5-11eb-0b3c-6da3fc2251b0
# ╠═8d946d20-1c7e-11eb-1d87-3d7228c4945e
# ╠═4dc4ec56-1ad5-11eb-0969-c7cd1728bb68
# ╠═debadd2e-1ad5-11eb-0bb6-99037ade1f6f
# ╠═96032a3c-1ad5-11eb-242b-b7d2b6c54568
# ╠═b01fbeee-1ad5-11eb-0c27-359d42df7775
# ╠═1a04f8ce-1ad6-11eb-3e8b-ad10bbc2a217
# ╠═27b3c57c-1ad6-11eb-2546-0fe68a40bf06
# ╟─4325b748-1ad6-11eb-20cc-d75cdbb1fbe5
# ╠═4fada552-1ad6-11eb-0e25-77b981c007c2
# ╠═bdf66322-1ad7-11eb-1fc4-05c6877a1782
# ╠═521c2858-1c80-11eb-0b03-c90d72040f5c
# ╠═c45f7ec2-1ad7-11eb-0ff1-890a3dac8e95
# ╠═1ab1b858-1ad8-11eb-09e8-47133b186c2b
# ╠═882bf17a-1ad8-11eb-254e-1bafa2b2f599
# ╠═fcfebd94-1c80-11eb-35a5-4b6c26df5913
# ╠═4e3e2892-1ad9-11eb-1cf8-61058302f3cb
# ╠═77d779a2-1c81-11eb-14fc-bd9a86cb7090
# ╠═302dc78c-1c81-11eb-09c5-355d90caf574
# ╠═b6802886-1c81-11eb-0f02-db9fd5c65a4d
# ╠═7bb49244-1c81-11eb-1c7e-8bd4b88d9214
