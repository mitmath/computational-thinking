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

# ╔═╡ 10b19f7a-1f8b-11eb-128e-11743ce72ef5
using PlutoUI, Plots

# ╔═╡ e5a688ac-1f91-11eb-104a-2753c9263f14
md"""
 # Floating Point Arithmetic
"""

# ╔═╡ 2df31082-1f8b-11eb-145a-93fa6e01e345
@bind f Slider(1:100)

# ╔═╡ 37c0afe8-1f8b-11eb-1154-31f5954ca4ff
f

# ╔═╡ 8d2203e8-1f8a-11eb-0332-7d512d831ec1
bitstring(f)

# ╔═╡ 4aa7bc3c-1f8b-11eb-30dd-89d64f42fc27
length(bitstring(f))

# ╔═╡ c90f7b06-1f8a-11eb-17d7-35a09af858f1
float(f)

# ╔═╡ d4cd33f2-1f8a-11eb-1af7-bdbc1fb236da
bitstring(float(f))

# ╔═╡ 4f354440-1f8b-11eb-225a-f55552bc9e29
length(bitstring(float(f)))

# ╔═╡ b7eb6210-1f9e-11eb-2a57-95b4fab4187f
md"""
IEEE 64 bit representation (double precision) (64 bits0
"""

# ╔═╡ 2ee2a8ec-1f8e-11eb-23e6-9d5e2bb00d1e
ieee0(x::Float64) = [bitstring(x)[1:1], bitstring(x)[2:12], bitstring(x)[13:64]] 

# ╔═╡ d6b5d1f6-1f9e-11eb-0c32-9b9cb51352a0
md"""
## Let me work with numbers from 1 to 2
"""

# ╔═╡ e0cd119a-1f9e-11eb-1181-3d3fa6e0653f
 nextfloat(1.0)-1.0

# ╔═╡ f3357c5a-1f9e-11eb-270d-d3b5fd6bd542
2.0 ^(-52)

# ╔═╡ fbe68df8-1f9e-11eb-1278-a102df99c88c


# ╔═╡ 0bf5f86a-1f8f-11eb-17fd-75f4b45f16d5
@bind j Slider(1: 2^(52), show_value = true)

# ╔═╡ 2ff48c68-1f8f-11eb-0bd0-cde93f2cc18b
g = 1 + j/2^52

# ╔═╡ 316b7dd0-1f8e-11eb-0da9-9fc5b63a4e80
ieee0(g)


# ╔═╡ 56e8258a-1f8f-11eb-3249-6592feed84b3
ieee0(1.0)

# ╔═╡ 5d7dcbe0-1f8f-11eb-05e9-1b2ae35cf681
ieee0(-1.0)

# ╔═╡ bf3bd13c-1f95-11eb-3187-a7311125be18
nextfloat(1.0)-1

# ╔═╡ d3a6bbaa-1f95-11eb-27de-e99b0e230d21
eps(1.0)

# ╔═╡ c6d813ba-1f95-11eb-1be6-55cb3ffeb358
nextfloat(1.0f0)-1

# ╔═╡ d66f2a16-1f95-11eb-3edc-4182c1a4b8ad
eps(1.0f0)

# ╔═╡ d31baed4-1f95-11eb-19df-15ff5c378487
eps(1.0f0) * 2^23

# ╔═╡ 81a7921c-1f8f-11eb-33c6-397d38b57a75
ieee(x) = [ parse.(Int,ieee0(x),base=2)      ieee0(x)]

# ╔═╡ 85c8f822-1f8f-11eb-15a1-7956d269779a
ieee(g)

# ╔═╡ dd3031d8-1f9f-11eb-39b2-cb7ac57c6bdf
ieee(1.0)

# ╔═╡ e4b2733a-1f9f-11eb-30ac-0dc5305b8938
ieee(-1.0)

# ╔═╡ ff15233a-1f9f-11eb-0012-f198e05abaf9
md"""
# s, e, m  (sign, exponent, mantissa)  =  (-1)^s  * 2^(e-1023) * (1 + m/2^52)
"""

# ╔═╡ 3f36e4a8-1fa0-11eb-1c46-97ff95905b41
ieee(prevfloat(1.0))

# ╔═╡ f8612fa6-1f91-11eb-36d6-cbd0f9b5b0ea
float2ieee(x::Float64) =  parse.(Int,ieee0(x),base=2)

# ╔═╡ 66f85a94-1fa0-11eb-32bd-178184d8aef9
2^52-1

# ╔═╡ 0a44c782-1f92-11eb-1b67-eb93f1dfe1ff
float2ieee(1.0)

# ╔═╡ 37039e06-1f92-11eb-192e-e59ffb46a368
begin
	i =-2:2
	x =  2.0 .^i
	plot(yticks=[],xticks=round.(x,digits=2),size=(500,100))
	for xx∈x
	   
	
		
		z = (1+1/16):(1/16):(2-1/16)
		for zz∈ xx.*z
			
			   
	  plot!( [zz, zz], [-.1, 0.0], color=:red, ratio=10, legend=false, ylims=(-.1,.1),tickfontsize=1)
			
		end
		  plot!( [xx, xx], [-.1, .1], color=:blue, ratio=5, legend=false, ylims=(-.1,.1),tickfontsize=4)
	end
	
	plot!()
end

# ╔═╡ c51ad4de-1fa1-11eb-3e01-fb46ed72f493
(1 + 1.000001*eps(1.0)/2)-1

# ╔═╡ 79e5e5ca-1fa0-11eb-087f-9fad526c1b0e
ieee(0.0) ## does not follow the same rule

# ╔═╡ 8fd89a82-1fa0-11eb-2921-0d3c31c93cbc
ieee(-0.0) ## is this the same as 0.0?

# ╔═╡ a207d416-1fa0-11eb-3bf0-bdc40925736e
1.0 / 0.0

# ╔═╡ c7473096-1fa0-11eb-39fd-31c4c4b1eb04
ieee(Inf)

# ╔═╡ d08a02dc-1fa0-11eb-3369-a7c84dad581a
ieee(1.0/-0.0)

# ╔═╡ f072cf66-1fa0-11eb-0789-733f904d41d0
0.0 / 0.0

# ╔═╡ ff8975cc-1fa0-11eb-1fa6-514db7898e52
md"""
# Not a Number
"""

# ╔═╡ 0b340f86-1fa1-11eb-37bd-839bd7525dc9
NaN == NaN

# ╔═╡ 0d1c1902-1f96-11eb-0734-1bb3dda2aa7d
md"""
Why do we need this floating point representation?
"""

# ╔═╡ a40c4352-1f94-11eb-263e-632828cb6079
float2ieee(0.0)

# ╔═╡ b7b6a198-1f94-11eb-0093-8f3ab007d770
float2ieee(-0.0)

# ╔═╡ bb04eb2c-1f94-11eb-0a4a-3d2765531e94
float2ieee(Inf)

# ╔═╡ c0e4f8f2-1f94-11eb-1305-d9028395ab2f
float2ieee(-Inf)

# ╔═╡ c500ec66-1f94-11eb-079a-1b5b4befade2
1/-0.0

# ╔═╡ 1e37c20a-1f95-11eb-37f9-11c5a6041e1b
Inf - Inf

# ╔═╡ 25be9fbc-1f95-11eb-294a-1dd62a135bfa
0.0/0.0

# ╔═╡ 7345c08e-1f96-11eb-0bf1-c50d0108facd
md"""
$$\begin{matrix}   \text{exponent\\mantissa} & 0 & ≠0  \\ \hline 0 & ±0  &  \text{denormal} \\ 
\text{regular} &  2^k & \text{general} \\ \text{max} &  \pm\infty &  \text{NaN} \end{matrix}$$
"""

# ╔═╡ b22dc266-1f9a-11eb-199b-170ef50b702c
md"""
Rules of IEEE arithmetic
"""

# ╔═╡ 3f2943c6-1f95-11eb-0342-6569169f32ca
Float32(1.0)

# ╔═╡ 47153ebe-1f95-11eb-2224-716d2e152db0
bitstring(Float32(1.0))

# ╔═╡ 60135b2e-1f95-11eb-293d-4f8a96a677b2
float32ieee0(x::Float32) = [bitstring(x)[1:1], bitstring(x)[2:9], bitstring(x)[10:32]]

# ╔═╡ 77de76f8-1f95-11eb-00bc-915dd7977c75
float32ieee0(1.0f0)

# ╔═╡ 65ef756c-1f96-11eb-2546-35b37cb7f54c
## The rules of +, -, / , * and √

# ╔═╡ f707de2e-1fa1-11eb-0147-3fca8c03ab5f


# ╔═╡ 2b0265d4-1f96-11eb-1553-ef2ecb7d451b
md"""
What precision do you need? 
 - Small absolute precision?
 - Small relative precision?
 - Neither?
"""

# ╔═╡ c5f5c97c-1f97-11eb-3683-55c16be8274e
md"""
What is displayed? What can you represent?
"""

# ╔═╡ b86c366c-1f95-11eb-0a18-a52cdf00da4c
1/5

# ╔═╡ d400e394-1f97-11eb-0f74-476c32bdd9d0
bitstring(1/5)

# ╔═╡ f5e3b162-1f97-11eb-2879-f7c7954143a0
big(1/5)

# ╔═╡ 000c656c-1f98-11eb-0f0e-657b9651f0bd
big(1)/5

# ╔═╡ 149b4c9e-1f98-11eb-19b7-eb9988c9333a
BigFloat(1//5,precision=1000)

# ╔═╡ 3aae6bac-1f98-11eb-22a5-bdc5e5de3f4c
BigFloat(π,precision=1000)

# ╔═╡ 43bed31c-1f98-11eb-1131-f5dd8dd27086
BigFloat(float(pi),precision=1000)

# ╔═╡ 56fb9c94-1f98-11eb-216e-f9e6e04d6f45
md"""
Note that every IEEE number terminates (is not a repeating expansion)
"""

# ╔═╡ 32cf8afa-1f99-11eb-0193-e969cca12f86
md"""
Find the first floating point number bigger than 1 such that x * (1/x) ≠ 1
"""

# ╔═╡ 51baa858-1f99-11eb-3329-4d9bf850b1c0
begin
	t = 1+rand()
	t,ieee(t*1/t)
end

# ╔═╡ 64c9235e-1f99-11eb-24f3-d940be06c7c8
let
	 α = 1.0
     while( α * (1/α) == 1.0)
		α = nextfloat(α)
	 end
	 Int((α-1)/eps(1.0))
end

# ╔═╡ ecc5c55a-1f99-11eb-3f44-4161850426cc
α= 1 + 257736490*eps()

# ╔═╡ 40575ec2-1f9a-11eb-2d29-5b517d1f3b18
α*(1/α)

# ╔═╡ 0b0719c2-1f9c-11eb-3ed6-6927c927145d


# ╔═╡ 11ebb920-1f9c-11eb-061a-8df3899e8945


# ╔═╡ Cell order:
# ╟─e5a688ac-1f91-11eb-104a-2753c9263f14
# ╠═2df31082-1f8b-11eb-145a-93fa6e01e345
# ╠═37c0afe8-1f8b-11eb-1154-31f5954ca4ff
# ╠═8d2203e8-1f8a-11eb-0332-7d512d831ec1
# ╠═4aa7bc3c-1f8b-11eb-30dd-89d64f42fc27
# ╠═c90f7b06-1f8a-11eb-17d7-35a09af858f1
# ╠═d4cd33f2-1f8a-11eb-1af7-bdbc1fb236da
# ╠═4f354440-1f8b-11eb-225a-f55552bc9e29
# ╟─b7eb6210-1f9e-11eb-2a57-95b4fab4187f
# ╠═2ee2a8ec-1f8e-11eb-23e6-9d5e2bb00d1e
# ╟─d6b5d1f6-1f9e-11eb-0c32-9b9cb51352a0
# ╠═e0cd119a-1f9e-11eb-1181-3d3fa6e0653f
# ╠═f3357c5a-1f9e-11eb-270d-d3b5fd6bd542
# ╠═fbe68df8-1f9e-11eb-1278-a102df99c88c
# ╠═0bf5f86a-1f8f-11eb-17fd-75f4b45f16d5
# ╠═2ff48c68-1f8f-11eb-0bd0-cde93f2cc18b
# ╠═316b7dd0-1f8e-11eb-0da9-9fc5b63a4e80
# ╠═56e8258a-1f8f-11eb-3249-6592feed84b3
# ╠═5d7dcbe0-1f8f-11eb-05e9-1b2ae35cf681
# ╠═bf3bd13c-1f95-11eb-3187-a7311125be18
# ╠═d3a6bbaa-1f95-11eb-27de-e99b0e230d21
# ╠═c6d813ba-1f95-11eb-1be6-55cb3ffeb358
# ╠═d66f2a16-1f95-11eb-3edc-4182c1a4b8ad
# ╠═d31baed4-1f95-11eb-19df-15ff5c378487
# ╠═81a7921c-1f8f-11eb-33c6-397d38b57a75
# ╠═85c8f822-1f8f-11eb-15a1-7956d269779a
# ╠═dd3031d8-1f9f-11eb-39b2-cb7ac57c6bdf
# ╠═e4b2733a-1f9f-11eb-30ac-0dc5305b8938
# ╠═ff15233a-1f9f-11eb-0012-f198e05abaf9
# ╠═3f36e4a8-1fa0-11eb-1c46-97ff95905b41
# ╠═f8612fa6-1f91-11eb-36d6-cbd0f9b5b0ea
# ╠═66f85a94-1fa0-11eb-32bd-178184d8aef9
# ╠═0a44c782-1f92-11eb-1b67-eb93f1dfe1ff
# ╠═37039e06-1f92-11eb-192e-e59ffb46a368
# ╠═c51ad4de-1fa1-11eb-3e01-fb46ed72f493
# ╠═79e5e5ca-1fa0-11eb-087f-9fad526c1b0e
# ╠═8fd89a82-1fa0-11eb-2921-0d3c31c93cbc
# ╠═a207d416-1fa0-11eb-3bf0-bdc40925736e
# ╠═c7473096-1fa0-11eb-39fd-31c4c4b1eb04
# ╠═d08a02dc-1fa0-11eb-3369-a7c84dad581a
# ╠═f072cf66-1fa0-11eb-0789-733f904d41d0
# ╟─ff8975cc-1fa0-11eb-1fa6-514db7898e52
# ╠═0b340f86-1fa1-11eb-37bd-839bd7525dc9
# ╟─0d1c1902-1f96-11eb-0734-1bb3dda2aa7d
# ╠═a40c4352-1f94-11eb-263e-632828cb6079
# ╠═b7b6a198-1f94-11eb-0093-8f3ab007d770
# ╠═bb04eb2c-1f94-11eb-0a4a-3d2765531e94
# ╠═c0e4f8f2-1f94-11eb-1305-d9028395ab2f
# ╠═c500ec66-1f94-11eb-079a-1b5b4befade2
# ╠═1e37c20a-1f95-11eb-37f9-11c5a6041e1b
# ╠═25be9fbc-1f95-11eb-294a-1dd62a135bfa
# ╠═7345c08e-1f96-11eb-0bf1-c50d0108facd
# ╟─b22dc266-1f9a-11eb-199b-170ef50b702c
# ╠═3f2943c6-1f95-11eb-0342-6569169f32ca
# ╠═47153ebe-1f95-11eb-2224-716d2e152db0
# ╠═60135b2e-1f95-11eb-293d-4f8a96a677b2
# ╠═77de76f8-1f95-11eb-00bc-915dd7977c75
# ╠═65ef756c-1f96-11eb-2546-35b37cb7f54c
# ╠═f707de2e-1fa1-11eb-0147-3fca8c03ab5f
# ╠═2b0265d4-1f96-11eb-1553-ef2ecb7d451b
# ╟─c5f5c97c-1f97-11eb-3683-55c16be8274e
# ╠═b86c366c-1f95-11eb-0a18-a52cdf00da4c
# ╠═d400e394-1f97-11eb-0f74-476c32bdd9d0
# ╠═f5e3b162-1f97-11eb-2879-f7c7954143a0
# ╠═000c656c-1f98-11eb-0f0e-657b9651f0bd
# ╠═149b4c9e-1f98-11eb-19b7-eb9988c9333a
# ╠═3aae6bac-1f98-11eb-22a5-bdc5e5de3f4c
# ╠═43bed31c-1f98-11eb-1131-f5dd8dd27086
# ╟─56fb9c94-1f98-11eb-216e-f9e6e04d6f45
# ╟─32cf8afa-1f99-11eb-0193-e969cca12f86
# ╠═51baa858-1f99-11eb-3329-4d9bf850b1c0
# ╠═64c9235e-1f99-11eb-24f3-d940be06c7c8
# ╠═ecc5c55a-1f99-11eb-3f44-4161850426cc
# ╠═40575ec2-1f9a-11eb-2d29-5b517d1f3b18
# ╠═0b0719c2-1f9c-11eb-3ed6-6927c927145d
# ╠═11ebb920-1f9c-11eb-061a-8df3899e8945
# ╠═10b19f7a-1f8b-11eb-128e-11743ce72ef5
