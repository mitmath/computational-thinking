### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7022d960-2901-11eb-2528-87791813b415
using OffsetArrays

# ╔═╡ afa4a77e-28fc-11eb-1ab0-bbba1b653e46
data = reshape(rand(1:9,36),6,6)

# ╔═╡ 0019e726-28fd-11eb-0e86-31ec28b3c1a9
I = CartesianIndices(data)

# ╔═╡ 15548ecc-28fd-11eb-1206-476c5f44efdf
[ data[i] for i∈I]

# ╔═╡ 5fb6e7b6-2901-11eb-0e94-aba290fd0bae
A = OffsetArray(zeros(Int,8,8), 0:7 ,0:7)

# ╔═╡ 87c260a2-2901-11eb-1060-b1e4b6b5b02b
for i ∈ I
	A[i] = data[i]  # copy data
end

# ╔═╡ a5c7693a-2901-11eb-1083-0da8138a73c2
A

# ╔═╡ b6fde83c-2901-11eb-0e3b-4b3766579cc8
neighborhood = CartesianIndices((-1:1, -1:1))

# ╔═╡ babe3c24-2901-11eb-2d30-51256eb97e11
[ A[i.+neighborhood] for i ∈ I]

# ╔═╡ e6bd9dea-2901-11eb-1100-ad10705f41cc
stencil =  [ 0  -1   0
            -1   4  -1
            0  -1   0]

# ╔═╡ fe4f6df0-2901-11eb-1945-27e3f041ed1f
[  sum(A[i.+neighborhood].*stencil) for i ∈ I]

# ╔═╡ 77c06ce6-2902-11eb-30a7-51f210dbd723
begin
 B = copy(A)
	
 B[0,:] = B[6,:]  ## periodic
 B[7,:] = B[1,:]
 B[:,0] = B[:,6]
 B[:,7] = B[:,1]
	
	
 #B[0,:] = B[1,:]  ## zero derivative
 #B[7,:] = B[6,:]
 #B[:,0] = B[:,1]
 #B[:,7] = B[:,6]
		
 B
end

# ╔═╡ 4f342744-2902-11eb-1401-55e770d9d751

for i∈I
	B[i] = sum(A[i.+neighborhood].*stencil)
end


# ╔═╡ 6223e374-2902-11eb-3bb2-4d2d0d352801
B

# ╔═╡ Cell order:
# ╠═afa4a77e-28fc-11eb-1ab0-bbba1b653e46
# ╠═0019e726-28fd-11eb-0e86-31ec28b3c1a9
# ╠═15548ecc-28fd-11eb-1206-476c5f44efdf
# ╠═7022d960-2901-11eb-2528-87791813b415
# ╠═5fb6e7b6-2901-11eb-0e94-aba290fd0bae
# ╠═87c260a2-2901-11eb-1060-b1e4b6b5b02b
# ╠═a5c7693a-2901-11eb-1083-0da8138a73c2
# ╠═b6fde83c-2901-11eb-0e3b-4b3766579cc8
# ╠═babe3c24-2901-11eb-2d30-51256eb97e11
# ╠═e6bd9dea-2901-11eb-1100-ad10705f41cc
# ╠═fe4f6df0-2901-11eb-1945-27e3f041ed1f
# ╠═77c06ce6-2902-11eb-30a7-51f210dbd723
# ╠═4f342744-2902-11eb-1401-55e770d9d751
# ╠═6223e374-2902-11eb-3bb2-4d2d0d352801
