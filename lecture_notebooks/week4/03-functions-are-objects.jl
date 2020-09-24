### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 32465c0e-fcd4-11ea-1544-df26081c7fa7
md"""
# Functions are objects
"""

# ╔═╡ 65c59b14-fcd7-11ea-2a19-3d084b3bca56
square_root = sqrt

# ╔═╡ 249cf7dc-fcdb-11ea-3630-ed2369d20041
square_root(123)

# ╔═╡ 6b91914a-fcd4-11ea-0d27-c99e7ef99354
function double(x)
	x * 2
end

# ╔═╡ b5614d1a-fcd4-11ea-19b9-45043b16b332
function half(x)
	x / 2
end

# ╔═╡ 0991e74c-fce3-11ea-0616-336e1d5d83e9
things = [double, half]

# ╔═╡ 10fe7950-fce3-11ea-1ace-e1676961935e
rand(things)(123)

# ╔═╡ 2424dd62-fce3-11ea-14a6-81792a7dee89
function applyboth(f, g, x)
	f(g(x))
end

# ╔═╡ 2fb8117e-fce3-11ea-2492-55e4768f6e37
applyboth(double, half, 10)

# ╔═╡ a34557ac-fce3-11ea-1391-3d0cddd4201b
md"""
# _map_ and _filter_
"""

# ╔═╡ 70aa854a-fce5-11ea-3477-6df2b0ca1d22
struct Dog
	name
	age
	photo
end

# ╔═╡ cbfc5ede-fce3-11ea-2044-15b8a07ef5f2
data = [
	Dog("Floep", 13, md"![](https://i.imgur.com/4PHFyIE.jpg)"),
	Dog("Hannes", 5, md"![](https://i.imgur.com/nD5c6yF.jpg)"),
	Dog("Fred", 8, md"![](https://i.imgur.com/aYTy1QN.jpg)"),
	Dog("Lily", 3, md"![](https://i.imgur.com/2monPgX.jpg)"),
	Dog("Robert", 15, md"![](https://i.imgur.com/jEwm3Q0.jpg)"),
	Dog("Kit", 2, md"![](https://i.imgur.com/KKtlIEe.jpg)"),
	Dog("Spot", 10, md"![](https://i.imgur.com/hNadBtk.jpg)"),
	]

# ╔═╡ 74f63e2c-fce9-11ea-2145-dd96e9cda96c
md"👉 Show the **photos** of all dogs older than **7 years**."

# ╔═╡ 9b688c4a-fceb-11ea-10b1-590b77c7bfe3
function isold(dog)
	dog.age > 7
end

# ╔═╡ ef6ebf86-fcea-11ea-1118-4f4b4960692b
filter(isold, data)

# ╔═╡ b7608b28-fceb-11ea-3742-a7828971d170
filter(dog -> dog.age > 7, data)

# ╔═╡ c53212da-fceb-11ea-0eeb-617a18323021
special_dogs = filter(data) do dog
	dog.age > 7
end

# ╔═╡ ea0ca73c-fceb-11ea-348a-5df7974b4aba
map(special_dogs) do dog
	dog.photo
end

# ╔═╡ 0758eff0-fcd4-11ea-3186-e1f76a06b91c
bigbreak = html"""
<div style="height: 100vh;"></div>
"""

# ╔═╡ 175cb644-fcd5-11ea-22f2-3f96d6d2e637
bigbreak

# ╔═╡ d5c31a1a-fcd8-11ea-0841-1f4a056c048e
bigbreak

# ╔═╡ c8fc9460-fce3-11ea-0f2a-1b87abdd12b7
bigbreak

# ╔═╡ Cell order:
# ╟─32465c0e-fcd4-11ea-1544-df26081c7fa7
# ╠═65c59b14-fcd7-11ea-2a19-3d084b3bca56
# ╠═249cf7dc-fcdb-11ea-3630-ed2369d20041
# ╟─175cb644-fcd5-11ea-22f2-3f96d6d2e637
# ╠═6b91914a-fcd4-11ea-0d27-c99e7ef99354
# ╠═b5614d1a-fcd4-11ea-19b9-45043b16b332
# ╠═0991e74c-fce3-11ea-0616-336e1d5d83e9
# ╠═10fe7950-fce3-11ea-1ace-e1676961935e
# ╠═2424dd62-fce3-11ea-14a6-81792a7dee89
# ╠═2fb8117e-fce3-11ea-2492-55e4768f6e37
# ╟─d5c31a1a-fcd8-11ea-0841-1f4a056c048e
# ╟─a34557ac-fce3-11ea-1391-3d0cddd4201b
# ╠═70aa854a-fce5-11ea-3477-6df2b0ca1d22
# ╟─cbfc5ede-fce3-11ea-2044-15b8a07ef5f2
# ╟─74f63e2c-fce9-11ea-2145-dd96e9cda96c
# ╠═9b688c4a-fceb-11ea-10b1-590b77c7bfe3
# ╠═ef6ebf86-fcea-11ea-1118-4f4b4960692b
# ╠═b7608b28-fceb-11ea-3742-a7828971d170
# ╠═c53212da-fceb-11ea-0eeb-617a18323021
# ╠═ea0ca73c-fceb-11ea-348a-5df7974b4aba
# ╟─c8fc9460-fce3-11ea-0f2a-1b87abdd12b7
# ╟─0758eff0-fcd4-11ea-3186-e1f76a06b91c
