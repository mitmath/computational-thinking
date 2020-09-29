### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ eb68872e-01ee-11eb-22e4-b1f20b71faff
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add("Combinatorics")
	using Combinatorics
end
	

# ╔═╡ 9a4603ea-01f2-11eb-00f0-591422bc7142
md" Given 20 people, what is the probability that,
among the 12 months in the year, there are 4
months containing exactly 2 birthdays and 4 containing exactly 3 birthdays?

(For simplicity, assume that it is equally like that a birthday falls in one of the 12 months.) 
(from A First Course in Probablity - Sheldon Ross)


"

# ╔═╡ 0cfeea3c-01ee-11eb-26f1-f1815eccdd10
md"Create twenty birthday months"

# ╔═╡ 015393e0-01ee-11eb-2feb-d7db4236368a
months = rand(1:12,20)

# ╔═╡ 1a6a603e-01ee-11eb-39f6-efc09168a3ba
counts =  [sum(months.==i) for i=1:12]

# ╔═╡ 67c25428-0251-11eb-04b0-cb201bbefa6b
sum(counts)

# ╔═╡ 6f1890a6-01ee-11eb-1524-1da938de93f3
sum(counts.==2),sum(counts.==3)

# ╔═╡ af424780-01ee-11eb-3d5f-4f4ba6a372b4
sum(counts.==2)==4 & sum(counts.==3)==4

# ╔═╡ d8b5158e-01ee-11eb-393f-0d51ea1fc19b
function birthday_problem(n)
  success = 0
  for t=1:n
     months = rand(1:12,20)
     counts = [sum(months.==i) for i=1:12]
     success += sum(counts.==2) == 4  &&  sum(counts.==3)==4
   end
   success/n
end

# ╔═╡ dea5c880-01ee-11eb-066d-8105b2196548
birthday_problem(20_000_000)

# ╔═╡ d74e2646-01f2-11eb-2b25-158bf9419ecd
@elapsed birthday_problem(20_000_000)

# ╔═╡ 006a84ee-01ef-11eb-2db7-5792cb4d0198
multinomial(4,4,4) * multinomial(2,2,2,2,3,3,3,3) / 12.0^20

# ╔═╡ Cell order:
# ╟─9a4603ea-01f2-11eb-00f0-591422bc7142
# ╟─0cfeea3c-01ee-11eb-26f1-f1815eccdd10
# ╠═015393e0-01ee-11eb-2feb-d7db4236368a
# ╠═1a6a603e-01ee-11eb-39f6-efc09168a3ba
# ╠═67c25428-0251-11eb-04b0-cb201bbefa6b
# ╠═6f1890a6-01ee-11eb-1524-1da938de93f3
# ╠═af424780-01ee-11eb-3d5f-4f4ba6a372b4
# ╠═d8b5158e-01ee-11eb-393f-0d51ea1fc19b
# ╠═dea5c880-01ee-11eb-066d-8105b2196548
# ╠═d74e2646-01f2-11eb-2b25-158bf9419ecd
# ╠═eb68872e-01ee-11eb-22e4-b1f20b71faff
# ╠═006a84ee-01ef-11eb-2db7-5792cb4d0198
