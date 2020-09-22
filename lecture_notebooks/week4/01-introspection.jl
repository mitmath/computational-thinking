### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ c63c2fbc-f1dd-11ea-3081-cd1f11630f23
using Pkg

# ╔═╡ bdbb7f1e-f1dd-11ea-1219-91d906455e4a
begin
	Pkg.add("Suppressor")
	using Suppressor
end

# ╔═╡ ca0e570a-f1dd-11ea-1655-29faf543c20a
Pkg.activate(mktempdir())

# ╔═╡ 41e94dd4-f1d9-11ea-2d2f-4b521ddb2284
md"""

# Looking under the hood

This segment introduces the tools available in Julia to **find and inspect** Julia code.

"""

# ╔═╡ 8983cd52-f1d9-11ea-1be0-c9d7d64e8942
md"""
## Finding the implementation of functions
"""

# ╔═╡ b00ae624-f1d9-11ea-003a-a149946054a9
a = 1.0 + 2.0im

# ╔═╡ c3433912-f1d9-11ea-1198-095259b8c36a
b = -2.0 + 2im

# ╔═╡ a81c0d26-f1d9-11ea-3319-19c78805c432
@which angle(a)

# ╔═╡ e779062e-f1d9-11ea-11c2-678f14dcd4a0
md"""**Tip:** infix operations like `+` are also functions.

`1 + 2` is the same as `+(1,2)`
"""

# ╔═╡ 2a66f8cc-f1da-11ea-3e26-cbe02936adb5
@which a * 2

# ╔═╡ 1b72c758-f1da-11ea-2a63-e164d7e0c63b
@which a * b

# ╔═╡ ef1f280e-fcd6-11ea-17c2-873d329119e7
md"Count the multiplies and adds in each case."

# ╔═╡ 56398582-f1da-11ea-2ae7-6f55de7e9e82
md"""
**Tip:** If you're using the default Julia REPL, you can type `@edit a * 2` and go to this line of code within your editor.

## Specialized implementations of functions

By now you may have guessed: there are many implementations of the same function and they are chosen based on the types of its arguments.

These implementations are called "**methods**".

You will see that it's very common for functions to have many methods, in fact the `*` function has a total of 364 methods!! Try to see them with `methods(*)`!
"""

# ╔═╡ 3e455938-f1da-11ea-1dc3-778cef1b6189
methods(*)


# ╔═╡ 73bef402-f1df-11ea-36d5-13e346ee1d59
md"""

Further, any other function which uses `*` will be able to make use of the correct implementation based on the types used!

For example, `prod` function which finds the product of an array uses `*` within itself.

"""

# ╔═╡ de7f0034-f1df-11ea-36e8-1d9720219a30
prod([a,b,a,b])

# ╔═╡ f0325696-f1df-11ea-2fc0-236d41409f16
prod([1,2,3,4])

# ╔═╡ dc718976-fce6-11ea-31fe-478aec584c33
prod( [rand(2,2) for i=1:4] )

# ╔═╡ f8fdbc82-fcd4-11ea-2c4f-0bd4db86b30e
md"This is a big deal, and it's called *Generic Programming* "

# ╔═╡ ba55539c-f1db-11ea-1744-41d9fc14d417
md"""

## Looking under the hood at code specialization

Julia takes a number of steps to run your code on a computer.

This involves transforming the requested Julia code into various forms of code and eventually machine code.

These are the forms your code will take in order:

- Julia code
- `@code_lowered`: Lowered Julia code ([syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar#:~:text=In%20computer%20science%2C%20syntactic%20sugar,style%20that%20some%20may%20prefer.)  is removed)
- `@code_typed`: Typed julia code (types are propagated depending on types of the arguments to the function)
- `@code_llvm`: Code compiled for the compiler infrastructure
- `@code_native`: Assembly code compiled for your specific machine!

"""

# ╔═╡ 7ab12188-fcd7-11ea-3d1b-db3bcb8c93e2
 #  c = 2
  c = 3.0 + 4.0im
 # c = [1 2 3]


# ╔═╡ ff22427c-fcd6-11ea-01a4-0d8fd0be3633
@code_lowered a * c

# ╔═╡ e6054270-f1dd-11ea-2c15-3f63ac42feca
md"""

**Notes on `@code_lowered` output**:

You can see that it has turned the function into a straight-line code.

- Each line does only 1 function call.
- The result of each line is assigned to a variable `%N`
"""

# ╔═╡ 32bc8b2e-f1dd-11ea-1ac2-5b2e6f2c213f
@code_typed a * c

# ╔═╡ 282d2bfe-f1de-11ea-3acc-9b4d284b99b3
md"""

**Notes on `@code_typed` output**:

Compared to `@code_lowered`, this code is more low level: it has chosen specific functions which will emit floating point instructions.
"""

# ╔═╡ 5e5f78c6-f1de-11ea-0156-25f96ef2b812
md"""
**Notes on the `@code_llvm` output**

Notice that here not only the variable names, but the field names are also gone!
"""

# ╔═╡ aa907166-f1de-11ea-00cc-a935c275eebd
md"""
**Notes on the `@code_native` output**

This is specific to your computer.

## Conclusion

Julia  allows you to look all the way to the exact instructions which will run on your CPU. Isn't that cool?

We hope you also got a feeling for the kind of specialization of code that Julia performs in order to get the fast performance for your code!

In a language without types this would not be possible! Or at least very hard!
"""

# ╔═╡ 4c131066-f1dd-11ea-3e4f-4122c5feb20a
function with_terminal(f)
	local spam_out, spam_err
	@color_output false begin
		spam_out = @capture_out begin
			spam_err = @capture_err begin
				f()
			end
		end
	end
	spam_out, spam_err
	
	HTML("""
		<style>
		div.vintage_terminal {
			
		}
		div.vintage_terminal pre {
			color: #ddd;
			background-color: #333;
			border: 5px solid pink;
			font-size: .75rem;
		}
		
		</style>
	<div class="vintage_terminal">
		<pre>$(Markdown.htmlesc(spam_out))</pre>
	</div>
	""")
end

# ╔═╡ 3c9f179c-f1dd-11ea-1c63-59429d7fa23a
with_terminal() do
	@code_llvm debuginfo=:none a * c
end

# ╔═╡ dd322a8c-f1dd-11ea-245e-e54922c0f355
with_terminal() do
	@code_native a * c
end

# ╔═╡ 293c8888-fcd7-11ea-34f6-4b994aa6baf4
with_terminal() do
	@code_native a * c
end

# ╔═╡ Cell order:
# ╠═c63c2fbc-f1dd-11ea-3081-cd1f11630f23
# ╠═ca0e570a-f1dd-11ea-1655-29faf543c20a
# ╠═bdbb7f1e-f1dd-11ea-1219-91d906455e4a
# ╟─41e94dd4-f1d9-11ea-2d2f-4b521ddb2284
# ╟─8983cd52-f1d9-11ea-1be0-c9d7d64e8942
# ╠═b00ae624-f1d9-11ea-003a-a149946054a9
# ╠═c3433912-f1d9-11ea-1198-095259b8c36a
# ╠═a81c0d26-f1d9-11ea-3319-19c78805c432
# ╟─e779062e-f1d9-11ea-11c2-678f14dcd4a0
# ╠═2a66f8cc-f1da-11ea-3e26-cbe02936adb5
# ╠═1b72c758-f1da-11ea-2a63-e164d7e0c63b
# ╟─ef1f280e-fcd6-11ea-17c2-873d329119e7
# ╟─56398582-f1da-11ea-2ae7-6f55de7e9e82
# ╠═3e455938-f1da-11ea-1dc3-778cef1b6189
# ╟─73bef402-f1df-11ea-36d5-13e346ee1d59
# ╠═de7f0034-f1df-11ea-36e8-1d9720219a30
# ╠═f0325696-f1df-11ea-2fc0-236d41409f16
# ╠═dc718976-fce6-11ea-31fe-478aec584c33
# ╟─f8fdbc82-fcd4-11ea-2c4f-0bd4db86b30e
# ╟─ba55539c-f1db-11ea-1744-41d9fc14d417
# ╠═7ab12188-fcd7-11ea-3d1b-db3bcb8c93e2
# ╠═ff22427c-fcd6-11ea-01a4-0d8fd0be3633
# ╟─e6054270-f1dd-11ea-2c15-3f63ac42feca
# ╠═32bc8b2e-f1dd-11ea-1ac2-5b2e6f2c213f
# ╟─282d2bfe-f1de-11ea-3acc-9b4d284b99b3
# ╠═3c9f179c-f1dd-11ea-1c63-59429d7fa23a
# ╟─5e5f78c6-f1de-11ea-0156-25f96ef2b812
# ╠═dd322a8c-f1dd-11ea-245e-e54922c0f355
# ╠═293c8888-fcd7-11ea-34f6-4b994aa6baf4
# ╟─aa907166-f1de-11ea-00cc-a935c275eebd
# ╟─4c131066-f1dd-11ea-3e4f-4122c5feb20a
