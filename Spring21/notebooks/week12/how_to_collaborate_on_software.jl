### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 75c8f825-d988-4f9e-8038-6b4dd2e24181
begin
    using HypertextLiteral
	using PlutoTest
	using PlutoUI
end

# ╔═╡ 10ebd434-adba-11eb-048f-2d084049d48f
html"""
<div style="
position: absolute;
width: calc(100% - 30px);
border: 50vw solid #282936;
border-top: 500px solid #282936;
border-bottom: none;
box-sizing: content-box;
left: calc(-50vw + 15px);
top: -500px;
height: 500px;
pointer-events: none;
"></div>

<div style="
height: 500px;
width: 100%;
background: #282936;
color: #fff;
padding-top: 68px;
">
<span style="
font-family: Vollkorn, serif;
font-weight: 700;
font-feature-settings: 'lnum', 'pnum';
"> <p style="
font-size: 1.5rem;
opacity: .8;
"><em>Section 3.5</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> How to collaborate on software </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/7N9Vvc8amGM" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ ef4eea24-bc1c-43be-b9b6-d073ac2433cf
md"""


# How to collaborate on software



What is the simplest way to collaborate on project online? You can _email files to each other!_ This works for small projects, but at some point, you will need something more suited to the task. For example:

- Encyclopedia -- a wiki system
- School essay -- Google Drive
- **Software project -- GitHub**

For software projects, people of use GitHub, or similar (git-based) tools to collaborate on their work. Why is that?

"""

# ╔═╡ 69b8490f-cf04-4e73-bc7b-639b1fc0e2d6
TableOfContents(; aside=false, depth=1)

# ╔═╡ cbe5fcba-3ed7-41a6-8932-2693e370c16c
md"""

# Why not Google Drive?
"""

# ╔═╡ 56db20a5-0e8d-4d34-b3ba-c3ab1b8de58e
md"""
Google Drive (or Dropbox, Nextcloud, etc) is a platform for _realtime collaboration_ on files. Besides synchronizing single files (like the video above), Google Drive also allows you to synchronize entire folders between multiple computers and the cloud. That's awesome! So do people use it for collaborative software projects?

Well, generally not. Software projects have some unique properties that require different tools. **As today's introduction into _git_, let's look at the differences between a software project and a non-software project**, and why platforms like Google Drive don't work well for collaborating on code.

Note that we will take a different perspective that other introductions to _git_. Let's start out with a realtime-synchronization system like Google Drive as our default, and think about why we might want to change its functionality to make it more suitable for software.

"""

# ╔═╡ 83d0162f-5960-4938-8353-91c4cd220459
md"""

## Reason 1: sensitive to change

> **Reason 1:** In software projects, small changes often make a big difference. **Changes to one file affect the entire program.**

For example, here is what Pluto.jl looks like after adding **a single character** to the source code:

"""

# ╔═╡ 604837c5-b017-4d6c-a5c5-dab50d5f3f61
md"""
While a single character can mean disaster, this _sensitivity_ also means that programming languages are quite powerful! A small change will often do the trick.
"""

# ╔═╡ 8678b5e1-0b67-4097-82ba-0daa4e878032
md"""
### Synchronizing every change

This sensitivity to changes makes realtime synchronization unsuitable for software projects. To see why, let's say that I want to change `sqrt` to `log` in the following code:
"""

# ╔═╡ 02905480-8864-4e56-af3a-6c7c0789ce6f


# ╔═╡ 2ef5db21-0092-4523-b930-0ec99c459ffa
md"""
If you would synchronize every change while making that edit (removing the letters `s`, `q`, `r`, `t`, typing `l`, `o`, `g`), then you are **publishing broken code** to your online code repository. If you were sharing changes in realtime (like Google Drive), then other people would get those broken states while working on their features.
"""

# ╔═╡ 51114dc9-cb32-4d31-b780-6f5e372f8763
md"""
##### Synchronizing every _keystroke_
"""

# ╔═╡ 3c8abdfc-cf68-4f10-a3e9-08d24803535b


# ╔═╡ dfb316ca-0502-4419-93c2-6d455b7b2f98
md"""
However, if we only publish code _manually_, we can make sure that we never publish broken code. This means that my collaborators, who might be working on the project at the same time, will not have to deal with errors that are coming from my work-in-progress changes.
"""

# ╔═╡ ae28cad6-2ffe-48b4-895b-fab1bd2f2443
md"""
##### Synchronizing manually
"""

# ╔═╡ ee5a3219-4547-4a9d-b527-3489a2925f68
md"""
### Even larger chunks

In the previous example, we found that we can avoid publishing _invalid syntax_ by not synchronizing on every keystroke like Google Docs, but by synchronizing manually.

We also don't want to synchronize the file every time it is _saved_, because you often try multiple things before finding something that works.
"""

# ╔═╡ e5f2b4e1-f05a-4457-b2e9-091a86ef86bb
md"""
##### Synchronizing every _save_
"""

# ╔═╡ 1421f832-9f97-4ec3-b967-64618983349b
md"""
##### Synchronizing manually
"""

# ╔═╡ e5bab2e1-be9e-4654-844a-d50285e330c8
pass2 = html"<span style='opacity: .3'>✅</span>"

# ╔═╡ 47c67fa6-1490-4134-9e0c-5754cb273d1e
pass = "✅" |> HTML

# ╔═╡ 79ab206d-2140-4c78-8fd4-a874fe2551e1
fail = "❌" |> HTML

# ╔═╡ 38261f04-f410-440e-a1cf-218fa240a0ae
md"""

### Reason 2: _branches_ and _forks_

> **Reason 2:** It should be easy to split a project into multiple _branches_: **copies of the codebase** that can be worked on independently. And after some time, we want to **compare branches** and merge the new additions into one.

Something that you may have done: create a copy of your `presentation.ppt` called `presentation-with-pictures.ppt` before adding your pictures, and if it didn't work, you can go back to yesterday's backup.

Now that's great, but what if your teammate also made a copy `presentation-with-titlepage.ppt` where they also made a change? In this situation, you have created two _branches_ of the same file in parallel, and it will be **difficult to combine those changes** back into a single `presentation-this-one-really.ppt` file.


"""

# ╔═╡ a0a97cd2-838c-4a2c-9233-969b3274764c
md"""
### Reason 3: automation

> **Reason 3:** Git is a platform for **automation**, and can be a mechanism to automatically test and review changes, release weekly versions, etc etc.

Programmers _love_ to automate things, and git allows all sorts of automation. At first, this can be **intimidating**, and it will take years of experience to learn all the possible tricks. Someone who does 'git magic' as a profession is called a _[DevOps](https://en.wikipedia.org/wiki/DevOps) engineer_. Don't worry about this too much when getting started with GitHub, and ask others for help if necessary.
"""

# ╔═╡ 0faa4042-42f5-4c74-9270-fbf2205920ca
md"""
##### Automatic testing

While we don't recommend learning about _git automation_ right away, one thing you will probably encounter when contributing to an open source project is **automatic testing**. More on this later!
"""

# ╔═╡ 167cbd94-851f-4147-9b9d-9b46c7959785
bigbreak = html"""
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
"""

# ╔═╡ 4ce38ec8-4084-4fe8-a248-87408cd0d39b
bigbreak

# ╔═╡ 93ce9618-5484-4572-97f1-1cb9c9367989
bigbreak

# ╔═╡ e3fe649e-2733-455a-897d-d4d2d70b9dc6
md"""
# Our first contribution: _documentation_

Today will be a kick-start into contributing to open source projects! The easiest way to make a great contribution to packages is to contribute a _documentation improvement_. For our example today, we will look at the package [ClimateMARGO.jl](https://github.com/ClimateMARGO/ClimateMARGO.jl), a climate-economic model.

This package is hosted on GitHub, which means that all code and previous versions of code is available at [github.com/ClimateMARGO/ClimateMARGO.jl](https://github.com/ClimateMARGO/ClimateMARGO.jl). The authors also use the same GitHub site to manage their TO-DOs — called [Issues](https://github.com/ClimateMARGO/ClimateMARGO.jl/issues) — and to accept contributions from others — called [Pull Requests](https://github.com/ClimateMARGO/ClimateMARGO.jl/pulls). Today, we are going to make a Pull Request!


"""

# ╔═╡ 2dd5d359-eb44-4696-bc83-f257eff95618
md"""
### What is a Pull Request?

Julia packages are _open source_, which means that you are allowed (and encouraged) to make your own copy of the source code (we call this a _**fork**_) and modify it. 

If you made some good changes on your fork then you can suggest to changes to the original project by submitting your code as a _**Pull Request (PR)**_. This is a feature built-in to GitHub, and this is how most code collaboration happens online.
"""

# ╔═╡ 3229f0aa-54d1-43f4-a6aa-cf212620ae13
md"""
> Video tutorial will be available here after the live lecture.
"""

# ╔═╡ bbb59b45-de20-41c1-b5dd-079fc51655f2
md"""
## _After_ the Pull Request

Submitting your Pull Request is a great feeling, but it's not the last step! After your submission, the PR will be reviewed by the project authors, and they will leave their feedback. It is common that a PR is not _merged_ (accepted) directly, but that you are asked to make some small changes.

This is possible because a Pull Request is not static — you can make changes to the PR after submitting it! Remember that a PR is _from one branch to another_. You can make changes to your PR simply by adding additional commits to the _from_ branch. 

"""

# ╔═╡ b83ade3d-6f8d-4ac8-9255-956d0a348416
md"""
As an example of a Pull Request in the wild, let's look at this PR to `JuliaLang/julia`: [github.com/JuliaLang/julia/pull/40596](https://github.com/JuliaLang/julia/pull/40596). The code change is not so important to us right now, but pay attention to the communication around the code change.


"""

# ╔═╡ 4d303641-0299-44d7-ba74-6daea0026b09
md"""
# How to use GitHub

Enough talk, let's create our first repository!
"""

# ╔═╡ 2c456900-047d-432c-a62a-87f8eeaba8d5
md"""
##### Requirements

To follow this introduction, you will need:
- Create an account at [github.com](github.com). Add a friendly profile picture!
- For Windows & MacOS users, download [GitHub Desktop](https://desktop.github.com/), a graphical program to easily manage git repositories on your disk. Linux users can use the slightly more advanced program [GitKraken](https://www.gitkraken.com/).
- A code editor. If you don't have a code editor yet, or if you are using Notepad, gedit or Notepad++, we highly recommend [VS Code](https://code.visualstudio.com/), an open source, beginner-friendly programming environment. _It may seem like something new and difficult to learn, but it is easy to use, and because it **understands** the code that you are writing, it will help you as a beginner programmer._
"""

# ╔═╡ dc112303-061e-4e53-8f58-cf9ea0f556f1
md"""
> Video tutorial will be available here after the live lecture.
"""

# ╔═╡ d400d538-4f73-4490-ad68-aedbb57cd70f


# ╔═╡ 67cf205a-3d89-4cd9-ab5e-febc85ea8af1
md"""
## ⛑ Git trouble!

Sooner or later, you will find yourself in _git trouble_. Unlike Google Drive, it can happen that synchronization requires manual intervention, for example, git might say:

#### `🤐 merge conflict`

Which means that someone changed a file right before you were going to commit.

"""

# ╔═╡ c4442667-072a-4e17-94a4-104a8ec33bd0


# ╔═╡ d8c5273f-7ebc-4399-b893-36f742162938
md"""
### Fonsi's Git Trouble Fix™

Many git problems have an 'official' solution, and it will take time to learn all of these techniques. In the meantime, here is my fool-proof way of solving many tricky git situations:
"""

# ╔═╡ cc1149de-4895-48aa-8335-6dcc78d882c9
md"""
##### Step 1

Use GitHub Desktop to find out which files you have changed. Are the changes important?

##### Step 2

Take any files that you want to keep, and copy them to a different folder, e.g. your desktop.

##### Step 3

**Remove your local clone of the repository, and move any leftover files to the trash.**

##### Step 4

Clone the repository again, and copy your files back to their original place, overwriting the cloned files.
"""

# ╔═╡ a7df39f0-0e97-4fff-9202-cfc629b68f46
bigbreak

# ╔═╡ d1e48204-79b8-4b0f-8dc7-eb69244068de
md"""
# How to fork and contribute code


"""

# ╔═╡ ea12c669-5429-4bf3-af03-378843ca8838
md"""
> Video tutorial will be available here after the live lecture.
"""

# ╔═╡ aeafbdbb-4aeb-452e-a21b-d2c8ec48c64e
md"""
### Tests

People often write _tests_ for their code! As part of the codebase, there will be a `test` folder containing scripts that will import the project and run some basic checks.
"""

# ╔═╡ 40f9fe4d-ddae-4bdb-aee2-7999e288931a
function double(x)
	x + x
end

# ╔═╡ f7425775-55aa-4e46-a11f-7d981a4cfacc
@test double(3) == 6

# ╔═╡ 91b6151d-284e-4f06-954c-ce648fec3327
@test double(0) == 0

# ╔═╡ ddab6132-7d4d-41e8-81f3-ab0fc24cbeeb
md"""
One reason to write tests is to _pin_ specific behaviour, protecting yourself from accidentally changing it later. For example, if you fix a bug that `double(2)` returns `40` instead of `4`, you would also add a test for `double(2) == 4`. Months later, when you are changing `double` for another use case, the old test insures that you are not accidentally breaking something that was once fixed.
"""

# ╔═╡ 0d76ea2f-18a9-46d1-8328-f077482d5d1f
md"""
#### Running tests

You can run the tests of any Julia package by opening the Julia REPL, and typing:
```julia
julia> ]

(v1.6) pkg> test Example
```

As mentioned before, many project use _github magic_ to automatically run their tests on a server for every change, and you can view the test results online. An important application is running tests for every Pull Request. This means that package authors can quickly review your changes, knowing that it does not break anything.
"""

# ╔═╡ de95e033-932a-4de9-8e1b-36fcf22c7e20
bigbreak

# ╔═╡ 6efa4ee8-b477-4d47-8d42-5b87f3aa02d2
md"""
# Extra tips
"""

# ╔═╡ f26e39cc-c175-4439-868a-0686250e8e29
md"""




Contributing does not only mean contributing code! [https://opensource.guide/how-to-contribute/](https://opensource.guide/how-to-contribute/)


"""

# ╔═╡ b16a228e-5056-44a0-ab57-0dea5082669d
md"""

Create a "test" repository! Create multiple!

"""

# ╔═╡ 436c9fa2-b770-4dee-82a6-23e9baa551e4
md"""
# Appendix
"""

# ╔═╡ d92d55a3-8fbc-4178-81b4-7ddc379ef7c7
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 089c9a6c-f4ef-4815-9a99-cb4023b42225
# Layout = ingredients(download("https://raw.githubusercontent.com/fonsp/disorganised-mess/5a59ad7cff1e760b997a54ffa0f8fa202ac16db3/Layout.jl"))

# ╔═╡ 4ea69625-0064-42da-a75a-a54fbd106f78
stackrows(x) = permutedims(hcat(x...),(2, 1))

# ╔═╡ dd4855a0-0b7c-40a5-8565-94b40948f86d
flex(x::Union{AbstractVector,Base.Generator}; kwargs...) = flex(x...; kwargs...)

# ╔═╡ d31f0e84-dce9-4f81-8643-ef08684530d2
begin
	Base.@kwdef struct Div
		contents
		style=Dict()
	end
	
	Div(x) = Div(contents=x)
	
	function Base.show(io::IO, m::MIME"text/html", d::Div)
		h = @htl("""
			<div style=$(d.style)>
			$(d.contents)
			</div>
			""")
		show(io, m, h)
	end
end

# ╔═╡ 3c0059b7-7a99-4c1c-a2bf-e47bdd06a252
outline(x) = Div(x, Dict(
		"border" => "3px solid rgba(0,0,0,.3)",
		"border-radius" => "3px",
		"padding" => "5px",
		))

# ╔═╡ 0bf51d8c-7adf-4231-8b2d-c976484a3e7c
Div(
	[md"""
	```julia
	function height(p)
		c1 * sqrt(p * c2)
	end
	```
	""",
	md"to",
	md"""
	```julia
	function height(p)
		c1 * log(p * c2)
	end
	```
	"""],
	Dict(
		"display" => "flex",
		"justify-content" => "space-evenly",
		"align-items" => "center",
	))

# ╔═╡ 574448b8-2ff1-4bff-8580-33bfcba860e8
function flex(args...; kwargs...)
	Div(;
		contents=collect(args),
		style=Dict("display" => "flex", ("flex-" * String(k) => string(v) for (k, v) in kwargs)...)
		)
end

# ╔═╡ 51448106-3e0e-4abf-84fc-7e6e81425d12
flex(
	md"""
	#### Before:
	
	![Schermafbeelding 2021-05-04 om 18 51 27](https://user-images.githubusercontent.com/6933510/117040056-c10b8280-ad09-11eb-9384-d211156440b1.png)
	""",
	md"""
	#### After a single change:
	
	![Schermafbeelding 2021-05-04 om 18 50 00](https://user-images.githubusercontent.com/6933510/117039958-a46f4a80-ad09-11eb-90fa-c1264d896648.png)
	"""
	) |> outline

# ╔═╡ 676ac6ff-1b7e-4c88-b850-45f4375a8d58
function grid(items::AbstractMatrix; fill_width::Bool=true)
	Div(
		contents=Div.(vec(permutedims(items, [2,1]))), 
		style=Dict(
			"display" => fill_width ? "grid" : "inline-grid", 
			"grid-template-columns" => "repeat($(size(items,2)), auto)",
			"column-gap" => "1em",
		),
	)
end

# ╔═╡ 8b24ce23-4ead-4fbc-875e-a8261f671abe
grid([
	nothing                  md"`sqrt`" md"`sq`" md"` `" md"`lo`" md"`log`"
	"Your computer (local):" pass fail fail fail pass
	"Online (remote): " pass fail fail fail pass
		])

# ╔═╡ 86e4b0dd-9bf5-4711-bf3f-b55ed2627a03
grid([
	nothing                  md"`sqrt`" md"`sq`" md"` `" md"`lo`" md"`log`"
	md"Your computer _(local)_:" pass fail fail fail pass
	md"Online _(remote)_: " pass nothing nothing nothing pass
		])

# ╔═╡ efbd6d1c-d2c9-48a9-9d6c-dc9ce6af0b5b
grid([
	nothing                  md"`sqrt`" md"Let's try `sin`" md"Let's try `cos`" md"Try `log`"
	"Your computer (local):" pass fail fail pass
	"Online (remote): " pass fail fail pass
		])

# ╔═╡ b139e8ea-88ad-4df4-9f13-c867edfc2db0
grid([
	nothing                  md"`sqrt`" md"Let's try `sin`" md"Let's try `cos`" md"Try `log`"
	"Your computer (local):" pass fail fail pass
	"Online (remote): " pass nothing nothing pass
		])

# ╔═╡ 13c0fbf3-08c6-4515-b710-f16b55165a2d
vocabulary(x) = grid(stackrows((
		[@htl("<span style='font-size: 1.2rem; font-weight: 700;'><code>$(k)</code></span>"), v]
		for (k, v) in x
		)); fill_width=false)

# ╔═╡ b2e49cd5-49d5-4ac7-a3ae-9820a97720fb
[
	@htl("<em>remote</em>") => md"The version that is on the internet, you browse the remote on github.com.",
	@htl("<em>local</em>") => md"What's on your computer. Use `pull`, `commit` and `push` to synchronize this with the remote. Google Drive does this all the time."
	] |> vocabulary

# ╔═╡ a98993b9-a5c0-4260-b96e-2655c472ccba
[
	"fetch" => md"Make your local git aware of any changes online. Do this often!",
	"pull" => md"Apply any changes on the remote version to your local copy. This will get the two _in sync_. Do this often!",
	"commit" => md"Create a collection of changes to files, ready to be `push`ed.",
	"push" => md"Publish any local `commit`s to the remote version.",
	] |> vocabulary

# ╔═╡ d43abe78-5a9d-4a22-999d-0ee85eb5ab7f
function aside(x)
	@htl("""
		<style>
		
		
		@media (min-width: calc(700px + 30px + 300px)) {
			aside.plutoui-aside-wrapper {
				position: absolute;
				right: -11px;
				width: 0px;
				transform: translate(0, -40%);
			}
			aside.plutoui-aside-wrapper > div {
				width: 300px;
			}
		}
		</style>
		
		<aside class="plutoui-aside-wrapper">
		<div>
		$(x)
		</div>
		</aside>
		
		""")
end

# ╔═╡ 812002d3-8603-4ffa-8695-2b2da7f0766a
html"""
<p>
If you have not used Google Drive before, here is a small demonstration:</p>
<video src="https://user-images.githubusercontent.com/6933510/117038375-d8497080-ad07-11eb-8260-34e96414131a.mov" data-canonical-src="https://user-images.githubusercontent.com/6933510/117038375-d8497080-ad07-11eb-8260-34e96414131a.mov" controls="controls" muted="muted" class="d-block rounded-bottom-2 width-fit" style="max-height:640px;"></video>
""" |> aside

# ╔═╡ 8ea1ca6b-4bb7-4f53-907d-0e5ca83e5761
md"""
[^sidenote]:

    _Language design side note:_ There _are_ languages that are designed to be robust against small changes, and you can actually use realtime collaboration with those! Examples are [glitch.com](glitch.com) for collaborative HTML and CSS editing _(these languages can ignore syntax errors and continue)_, and the more experimental language [_Dark_](https://darklang.com/) _(which uses a special editor that does not allow you to type errors)_.
""" |> aside

# ╔═╡ 7af9e69c-2b81-4a90-861c-ed737a4a9ec4
md"""
[^1]:
    If you are working on a _fork_, then by creating a PR, you also give the original project authors access to make changes to the _from_ branch of the PR. This is a useful feature, allowing you to work together on the same codebase.
""" |> aside

# ╔═╡ 7174076d-5eba-4380-8d76-292935014d90
md"""
> ##### Test-driven design
> 
> Some people like to _first_ write their tests, which will fail initially, and _then_ write the code to solve the problem. While working on the code, they keep re-running the tests, until all checks are green! This can be an effective and rewarding way to work on a software problem!
> 
> If you are following this course, then you will already be familiar with this concept! The homework exercises were all designed with the test-driven principle.
""" |> aside

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
PlutoTest = "~0.2.2"
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "63d1e802de0c4882c00aee5cb16f9dd4d6d7c59c"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.1"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─10ebd434-adba-11eb-048f-2d084049d48f
# ╟─ef4eea24-bc1c-43be-b9b6-d073ac2433cf
# ╟─69b8490f-cf04-4e73-bc7b-639b1fc0e2d6
# ╟─cbe5fcba-3ed7-41a6-8932-2693e370c16c
# ╟─812002d3-8603-4ffa-8695-2b2da7f0766a
# ╟─56db20a5-0e8d-4d34-b3ba-c3ab1b8de58e
# ╟─83d0162f-5960-4938-8353-91c4cd220459
# ╟─51448106-3e0e-4abf-84fc-7e6e81425d12
# ╟─3c0059b7-7a99-4c1c-a2bf-e47bdd06a252
# ╟─604837c5-b017-4d6c-a5c5-dab50d5f3f61
# ╟─8678b5e1-0b67-4097-82ba-0daa4e878032
# ╟─0bf51d8c-7adf-4231-8b2d-c976484a3e7c
# ╟─02905480-8864-4e56-af3a-6c7c0789ce6f
# ╟─2ef5db21-0092-4523-b930-0ec99c459ffa
# ╟─51114dc9-cb32-4d31-b780-6f5e372f8763
# ╟─8b24ce23-4ead-4fbc-875e-a8261f671abe
# ╟─3c8abdfc-cf68-4f10-a3e9-08d24803535b
# ╟─dfb316ca-0502-4419-93c2-6d455b7b2f98
# ╟─ae28cad6-2ffe-48b4-895b-fab1bd2f2443
# ╟─86e4b0dd-9bf5-4711-bf3f-b55ed2627a03
# ╟─8ea1ca6b-4bb7-4f53-907d-0e5ca83e5761
# ╟─ee5a3219-4547-4a9d-b527-3489a2925f68
# ╟─e5f2b4e1-f05a-4457-b2e9-091a86ef86bb
# ╟─efbd6d1c-d2c9-48a9-9d6c-dc9ce6af0b5b
# ╟─1421f832-9f97-4ec3-b967-64618983349b
# ╟─b139e8ea-88ad-4df4-9f13-c867edfc2db0
# ╟─e5bab2e1-be9e-4654-844a-d50285e330c8
# ╟─47c67fa6-1490-4134-9e0c-5754cb273d1e
# ╟─79ab206d-2140-4c78-8fd4-a874fe2551e1
# ╟─4ce38ec8-4084-4fe8-a248-87408cd0d39b
# ╟─38261f04-f410-440e-a1cf-218fa240a0ae
# ╟─93ce9618-5484-4572-97f1-1cb9c9367989
# ╟─a0a97cd2-838c-4a2c-9233-969b3274764c
# ╟─0faa4042-42f5-4c74-9270-fbf2205920ca
# ╟─167cbd94-851f-4147-9b9d-9b46c7959785
# ╟─e3fe649e-2733-455a-897d-d4d2d70b9dc6
# ╟─2dd5d359-eb44-4696-bc83-f257eff95618
# ╟─3229f0aa-54d1-43f4-a6aa-cf212620ae13
# ╟─bbb59b45-de20-41c1-b5dd-079fc51655f2
# ╟─7af9e69c-2b81-4a90-861c-ed737a4a9ec4
# ╟─b83ade3d-6f8d-4ac8-9255-956d0a348416
# ╟─4d303641-0299-44d7-ba74-6daea0026b09
# ╟─2c456900-047d-432c-a62a-87f8eeaba8d5
# ╟─dc112303-061e-4e53-8f58-cf9ea0f556f1
# ╟─b2e49cd5-49d5-4ac7-a3ae-9820a97720fb
# ╟─d400d538-4f73-4490-ad68-aedbb57cd70f
# ╟─a98993b9-a5c0-4260-b96e-2655c472ccba
# ╟─67cf205a-3d89-4cd9-ab5e-febc85ea8af1
# ╟─c4442667-072a-4e17-94a4-104a8ec33bd0
# ╟─d8c5273f-7ebc-4399-b893-36f742162938
# ╟─cc1149de-4895-48aa-8335-6dcc78d882c9
# ╟─a7df39f0-0e97-4fff-9202-cfc629b68f46
# ╟─d1e48204-79b8-4b0f-8dc7-eb69244068de
# ╟─ea12c669-5429-4bf3-af03-378843ca8838
# ╟─aeafbdbb-4aeb-452e-a21b-d2c8ec48c64e
# ╠═40f9fe4d-ddae-4bdb-aee2-7999e288931a
# ╠═f7425775-55aa-4e46-a11f-7d981a4cfacc
# ╠═91b6151d-284e-4f06-954c-ce648fec3327
# ╟─ddab6132-7d4d-41e8-81f3-ab0fc24cbeeb
# ╟─7174076d-5eba-4380-8d76-292935014d90
# ╟─0d76ea2f-18a9-46d1-8328-f077482d5d1f
# ╟─de95e033-932a-4de9-8e1b-36fcf22c7e20
# ╟─6efa4ee8-b477-4d47-8d42-5b87f3aa02d2
# ╟─f26e39cc-c175-4439-868a-0686250e8e29
# ╟─b16a228e-5056-44a0-ab57-0dea5082669d
# ╟─436c9fa2-b770-4dee-82a6-23e9baa551e4
# ╠═75c8f825-d988-4f9e-8038-6b4dd2e24181
# ╟─d92d55a3-8fbc-4178-81b4-7ddc379ef7c7
# ╟─089c9a6c-f4ef-4815-9a99-cb4023b42225
# ╟─4ea69625-0064-42da-a75a-a54fbd106f78
# ╟─13c0fbf3-08c6-4515-b710-f16b55165a2d
# ╟─574448b8-2ff1-4bff-8580-33bfcba860e8
# ╟─dd4855a0-0b7c-40a5-8565-94b40948f86d
# ╟─d31f0e84-dce9-4f81-8643-ef08684530d2
# ╟─676ac6ff-1b7e-4c88-b850-45f4375a8d58
# ╟─d43abe78-5a9d-4a22-999d-0ee85eb5ab7f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
