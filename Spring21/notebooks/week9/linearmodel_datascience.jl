### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ d155ea12-9628-11eb-347f-7754a33fd403
using Plots, PlutoUI, DataFrames, CSV, GLM, Statistics, LinearAlgebra, Distributions

# ╔═╡ 4ea0ccfa-9622-11eb-1cf0-e9ae2f927dd2
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
"><em>Section 2.8</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Linear Model, Data Science, & Simulations </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/O6NTKsR8TjQ" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 01506de2-918a-11eb-2a4d-c554a6e54631
TableOfContents()

# ╔═╡ 877deb2c-702b-457b-a54b-f27c277928d4
md"""
# Julia concepts for data science
- Data Frames (`DataFrames.jl`)
- `CSVread`, `CSVwrite` (`CSV.jl`)
- `lm` (linear model) (`GLM.jl`)
- `@formula` (formula macro to specify variables to analyze) (`GLM.jl`)

- Underscore as digits separator (e.g. `1_000` for 1000)

- The value of fast simulations.
"""

# ╔═╡ 36ce167f-382c-4b9a-be34-83250b10c4e5
md"""
In this lecture we will simulate a real world statistical application
for the purpose of understanding what statistics is about.  It is very
	helpful in simulations to be able to run many examples fast.
"""

# ╔═╡ 83912943-a847-420a-bfdb-450027b631e8
md"""
# Fahrenheit and Celsius Data Set
"""

# ╔═╡ 280d112f-d34a-4cc4-9e3a-4ebbfcd5eb51
n = 10


# ╔═╡ b5031c96-db57-4baf-b271-6bb12e29de9b
x = sort((rand( -10:100, n)))

# ╔═╡ c2f77e8f-a8c0-4144-a8b4-b25dd98ed234
y = 5/9 .* x  .- 17.7777777 #  same as y =  5/9 .* (x .- 32)

# ╔═╡ ad161b98-f4a1-42ac-ad4f-8b71fabcfde9
begin	
	plot(x,y, m=:c, mc=:red,legend=false)
	xlabel!("°F")
	annotate!(-4,16,text("°C",11))
	# plot!( x, (x.-30)./2) Dave's cool approximation
end

# ╔═╡ 8e422886-74ef-4c0f-be1e-fda238c8db44
[x y]

# ╔═╡ ca21122a-2522-482a-b7ef-bd73e96cb5a9
md"""
## Julia: Data Frames
I like to think of a Data Frame as a matrix with labels.
"""

# ╔═╡ 41e05b1e-8b5e-45e3-91bb-01355ade9f3d
md"""
### Data Frame by Columns with labels
"""

# ╔═╡ 9d2e3861-ca36-406e-952d-831ca3947e44
data = DataFrame(°F=x,°C=y) # Label = data

# ╔═╡ e73854ed-3581-41c4-ada5-e48242033759
md"""
### Data Frame with a matrix
"""

# ╔═╡ 9873d944-b611-46f9-82a7-0cf714a3078c
begin
	data2 = DataFrame([x  y], :auto) # convert Matrix to DataFrame
    rename!(data2,["°F","°C"]) # add column labels
end

# ╔═╡ 2be44753-afee-4125-b6bc-8866d2293dc2
Matrix(data2) # Convert back to a matrix (lose label information)

# ╔═╡ 6e07e8fb-fe51-4b37-bfb2-d1466e768754
md"""
## Julia:Comment about types

Notice that [x y] converts all the data to floats, but columns of a data frame can have different types.
"""

# ╔═╡ a755e58a-b16c-4d3b-a85f-81ccf374793f
md"""
# Reading/Writing CSV (comma separated values) Files
"""

# ╔═╡ f1e10fb7-adac-4083-8977-616a505fd591
md"""
  ## Writing Data to a CSV  file 
readable by spreadsheet software.
"""

# ╔═╡ 2e42986c-2de3-49e6-9c29-a7313c0b1da8
CSV.write("testCSVwrite.csv", data)

# ╔═╡ 22758dd6-9d04-4616-ba99-1430f2dedf9a
md"""
 ## Reading Data from a CSV file to a DataFrame
"""

# ╔═╡ aff6a616-6d8b-4584-a6f2-195decef7774
data_again = CSV.read("testCSVwrite.csv", DataFrame ) 

# ╔═╡ 338da13a-3c26-4366-a669-ac3e24f31577
data_again[:,"°F" ] # or data_again[:,1]

# ╔═╡ 5a742546-1e4d-4aee-bed1-cb10c543e439
data_again[:,1]

# ╔═╡ 6a9c8c9a-fac7-42f7-976d-3168132cae48
md"""
# Noisy Data
## Add some random noise to the celsius readings
"""

# ╔═╡ 83c28c76-2eab-49f9-9999-05df85054520
md"""
# The noise slider (so I can find it easily)
"""

# ╔═╡ ba671804-dc6d-415c-89de-9cf6294907b3
md"""
noise = $(@bind noise Slider(0:.5:1000, show_value = true ))
"""

# ╔═╡ 3c038b68-8676-4877-9720-38da7c4e0e0e
begin
	noisy_data = copy(data)  # Noisy DataFrame
	noisy_data[:, "°C" ] .+= noise * randn(n)
	yy = noisy_data[:, "°C" ]
	noisy_data
end

# ╔═╡ e8683a71-5822-4491-9ccd-20e0fc3bf531
md"""
## Statistics Software Outputs Mysterious Tables
example output from the "linear model"  (`lm`) which we store in the variable `ols` for ordinary least squares (by contrast weighted least squares treats the vertical displacements with unequally with differing weights.)
"""

# ╔═╡ 0489e5d8-51ca-4955-83e1-95ea353d9cf2
ols = lm(@formula(°C ~ °F), noisy_data)

# ╔═╡ 9a65aee4-ab8e-4ab7-be6f-cc2a2e9d5127
noisy_data

# ╔═╡ c3539f42-6ca7-47fb-9707-4d11c9e76643
md"""
This lecture is about explaining the meaning and significance to every part of this table.
"""

# ╔═╡ 469d809f-424f-4595-ad43-a5b2cc055304
md"""
# Regression a few ways 
"""

# ╔═╡ 6128b8fd-9b85-4896-a0bf-934a0733fafb
md"""
## The "Coef." column in the table gives the slope and intercept of the best fit line
"""

# ╔═╡ 9eb7caaa-438d-4bcb-9c54-4a0fa72c61de
b, m = [ one.(x) x]\ yy  # The mysterious linear algebra solution using "least squares"

# ╔═╡ 5a877e40-a101-4f7d-b2a1-ef4cfe5d8807
begin
	
	scatter(x, yy,m=:c,mc=:red, label="noisy data", ylims=(-40, 40))
	for i=1 : length(data[:,2])
		plot!([x[i],x[i]], [m*x[i]+b,yy[i]], color=:gray, ls=:dash, label=false)
	end
	xlabel!("°F")
	annotate!(-15,16,text("°C",11))
	plot!(x, m.*x .+ b,  color=:blue, label="best fit line")
	plot!(x,y,alpha=.5, color=:red, label="theory") # theoretical 
	plot!(legend=:top)
end

# ╔═╡ 0e8fce45-f1c0-41d4-996a-d6093182afee
function linear_regression(x,y)   # a direct computation from the data
	n = length(x)
	x0  = x.-mean(x)
	y0 = y.-mean(y)
	
	mᵉ = sum( x0 .* y0 ) / sum(  x0.^2 ) # slope estimate
	bᵉ = mean(y) - mᵉ * mean(x) # intercept estimate
	
	s2ᵉ = sum(  (mᵉ.*x .+ bᵉ .- y).^2 ) /(n-2) # noise estimate
	bᵉ, mᵉ, s2ᵉ
end

# ╔═╡ 71590890-38b6-440e-b61b-ece6c49ac602
linear_regression(x,yy)

# ╔═╡ f7cc7146-9ee6-4d87-b024-2a91863f4b24
md"""
[So why is it called "Regression" anyway?](http://blog.minitab.com/blog/statistics-and-quality-data-analysis/so-why-is-it-called-regression-anyway) Dalton's original meaning not quite what it means today.
"""

# ╔═╡ f64815e2-44b8-4585-9269-9a62655c984c
md"""
# Demystifying the word "Model"

    Step I:  The Model is y = m*x + b + σ*randn() . 
    This means that out there in the real world are b, m, and σ.  You
    don't know them.  
    
    Step II: You do, however, have data points x and y which allow you
    to compute an bᵉ,  mᵉ, and σᵉ.  A statistician would call these estimates
    based on your data points. If you ran the experiment again, you would
    get different data points.
    
    The computer lets us run the experiment as many times as we want just to see what happens.
    
        In summary, there are three kinds of variables.  The model variables b, m, and σ which are unknown.  The predictor variable x which is considered fixed and known.  The response variable y which is considered noisy.
"""

# ╔═╡ feb3c45e-88f4-4ffc-a4a0-e89489187c8d
md"""
## Understanding the relationship `°C ~ 1 + °F`
"""

# ╔═╡ 99069dd7-e088-4626-aa29-e48d6f9a474e
ols

# ╔═╡ 051a9e38-9a84-4ead-96fa-24c86c2b9f2d
md"""
`°C ~ 1 + °F` means the celsius (y) is (Coef1)*1 + (Coef2)*(°F),

in general `y ~ 1 + x1 + x2 + x3` is shorthand for
``y = c_0 + c_1 x_1 + c_2 x_2 + c_3 x_3``, etc.
"""

# ╔═╡ 2f33ee51-0725-46c2-9f1b-a61cd68abab1
md"""
# Simulating the real world: running many noisy models
"""

# ╔═╡ e4acd97b-22f7-4812-9898-1a485887a5f2
function simulate(σ,howmany)
	[linear_regression(x,y .+ σ * randn(length(x)))   for i=1:howmany]
	# [linear_regression(x,y .+ (σ * sqrt(12)) * (-.5 .+ rand(length(x))))   for i=1:howmany]
	# [linear_regression(x,y .+ (σ ) * ( rand([-1,1],length(x))))   for i=1:howmany]
	
end

# ╔═╡ 4e413b40-81c4-4160-9d01-046c2d179a06
howmany = 100_000

# ╔═╡ 7b94db0d-f46b-4621-9413-1dc787ae9a39
md"""
## Julia: underscore as a digits separator
"""

# ╔═╡ c7455f7a-9c72-42f5-8238-1799cad96f6c
md"""
## Simulated intercepts ($howmany simulations)
"""

# ╔═╡ d2971801-2cdb-4b9f-8ec8-c74cbb2a0b31
md"""
σ = $(@bind σ Slider(0:.1:3, show_value=true, default=1))
"""

# ╔═╡ 51a28b67-ad64-4cf2-a0e6-a78fb101eb15
s = simulate(σ, howmany)

# ╔═╡ d451af49-3139-4329-a885-a210b1760f74
s[1] # first simulation,  intercept, slope, estimation of noise σ

# ╔═╡ e1e8c140-bc4e-400d-beb2-0986e071c3a3
begin	
	histogram( first.(s) , alpha=.6, bins=100, norm=true)
	vline!([-17.777777],color=:white)
	title!("intercept")
	xlims!(-17.7777-3,-17.7777+3)
	ylims!(0,1)
	plot!(legend=false)
	
end

# ╔═╡ 1429be09-a31f-415f-9c3d-f32b085ef68d
md"""
Experimental mean of the intercept
"""

# ╔═╡ da321202-0dc5-44ad-aac0-f3ea0d229243
mean(first.(s)), -17.777777

# ╔═╡ 2aceb366-a067-4271-9362-c320f4735ed1
md"""
Experimental std of the intercept
"""

# ╔═╡ 58f548fd-f6d0-479d-8469-bc886783f9a7
std( first.(s))

# ╔═╡ 07be9435-bc07-4a18-aad8-3ff19f5bcce4
md"""
Statisticians know an exact formula for the theoretical std of the intercept
"""

# ╔═╡ 1a6ad08d-c3bb-47e7-bdee-156bbff3aeda
    sb = σ * norm(x)  / norm(x.-mean(x)) / sqrt(n)
        

# ╔═╡ c55e4894-db71-4729-a1a1-5f68b45e3bf5
md"""
## Simulated slopes ($howmany simulations)
"""

# ╔═╡ f50d66eb-0357-4017-ac9b-99e63cd52dc0
begin
	histogram( getindex.(s, 2), alpha=.6, bins=100, norm=true, legend=false )
	title!("slope")
	vline!([5/9],color=:white)
	xlims!(5/9-.1, 5/9+.1)
	ylims!(0,100)
end

# ╔═╡ 5c7a7361-f0e7-473a-9e38-226828aa00ca
md"""
Sample mean of the slope
"""

# ╔═╡ acf0e90e-8f1f-451f-9f0f-70a0bcc7efca
mean(getindex.(s, 2)), .555555

# ╔═╡ c9f65e15-f222-4a88-98c2-9e1d8b5ec3eb
md"""
Sample std of the slope.
"""

# ╔═╡ 2589a369-8b21-406d-906d-71b18e4c7895
std( getindex.(s, 2))

# ╔═╡ ed6a0e6a-2d0c-4f77-9b08-1a5b5d56dd34
md"""
Statisticians know a formula for the theoretical std of the slope.
"""

# ╔═╡ 61d1c1f7-e070-413b-8a92-76f44d237206
 σ  / norm(x.-mean(x))

# ╔═╡ 94d80ad6-0403-4322-aa9f-647c291c19d7
md"""
## Simulated σ ($howmany simulations)
"""

# ╔═╡ ce89b805-39a2-49e6-8781-c557aa73ed27
begin	
	histogram( last.(s) ./ (σ^2/(n-2)) , alpha=.6, bins=100, norm=true,legend=false)
	vline!([1],color=:white)
	title!("residual")
	vline!([n-2],color=:white, lw=4)
	# xlims!(0,20)
	# ylims!(0,.13)
	plot!( x-> pdf(Chisq(n-2),x) , lw=4 , color=:red )
	plot!()
	
end

# ╔═╡ 75f9b5e9-775d-4767-9da6-222f977da686
mean( last.(s)  )

# ╔═╡ 797c9f2f-0b85-4435-b1c0-edc8cf67f738
σ^2

# ╔═╡ 6e0b2452-9f8b-4730-8072-a663704893c5
std(last.(s))

# ╔═╡ bf537a3a-b7c6-4c64-8b44-85511c3d492e
 (σ^2/ sqrt((n-2)/2))

# ╔═╡ 1340818c-3391-420b-aa94-acaea8a47d7d
md"""
# The Linear Model Table
"""

# ╔═╡ 829607ff-25e0-4585-9c5c-d132ecb86cc8
ols # = lm(@formula(°C ~ °F), noisy_data)

# ╔═╡ 3fc0a4a8-6719-4920-99c7-bd576225214e
-24.3784  / 19.0397

# ╔═╡ 24a7ad28-936c-47dc-bc53-d1ddbf39d05d
0.686156 / 0.330459

# ╔═╡ 9233dc6a-7578-4d72-b0c2-c3bb110a9fbe
md"""
## The Coef column is just the regression formula for the best line
"""

# ╔═╡ 07e02bb6-380d-40dd-86ad-19d713cd1657
mᵉ, bᵉ, σ²ᵉ =  linear_regression(x, yy)

# ╔═╡ b14593ba-cb8c-4f28-8fb0-2d2df479357b
md"""
## The Std. error column
"""

# ╔═╡ ac204681-b9df-471b-a22e-9d8f68679151
md"""
Above we saw that statisticians had formulas for the exact std of the slope and intercept:

 `std(intercept) = σ * norm(x)  / norm(x.-mean(x)) / sqrt(n)`

` std(slope) =  σ  / norm(x.-mean(x))`
"""

# ╔═╡ 08f43fff-fbd8-468f-8b3b-efd1829f4fc0
md"""
Let's replace σ with our estimate √σ²ᵉ
"""

# ╔═╡ 43ec6124-c3e5-4f34-b0d9-1a0b069aa3e0
sqrt(σ²ᵉ) * norm(x) / norm(x.-mean(x)) / sqrt(n)

# ╔═╡ 3fe71215-bbf2-40e9-bcfc-0bc9b3ac94c8
sqrt(σ²ᵉ) / norm(x.-mean(x))

# ╔═╡ a2b27841-256e-4898-aeca-04c4f44138fb
md"""
See those are the numbers in the magic table above.  I always love when I can reproduce the numbers myself.  It makes me feel I understand it.
"""

# ╔═╡ 8851dca3-e1a6-46b2-9745-f175ef0b0fae
md"""
## The t column
"""

# ╔═╡ ccfcb4d9-5a88-48fb-9568-1147a74f6eec
md"""
The t column, is simply the Coeff column divided by the Std. error column which we will use in a hypothesis test in the upcoming column.
"""

# ╔═╡ 13858c0a-3e7a-4742-a821-97dd9a45109d
md"""
### The t-distribution
"""

# ╔═╡ b2c3c1e5-e569-4c6f-bad9-055a25d73dce
md"""
In a statistics class you will likely see a random variable known as a t-distribution.
(with parameter k). It is the ratio of a standard normal to a χ distribution with parameter k. Let's just use `randn` to simulate. For the data sets of most of today's experiments, the normal distribution is close enough to t, that nobody needs to even use t much anymore.  In any event, with a t or a normal we are using this distribution because we are cognizant of the fact that the true σ is unknown and is merely being estimated.
"""

# ╔═╡ 305e4dfc-af7d-4667-8da8-a7ba5fd20fa6
rand_t(k) = sqrt(k)* randn() / norm( randn(k))

# ╔═╡ a648ba4f-fec4-4fa7-b328-1b52070224eb
md"""
k = $(@bind k Slider(3:100, show_value=true))
"""

# ╔═╡ d652df7d-7364-4da4-b51e-9fc88b978cda
begin

	histogram([rand_t(k) for i=1:100000], norm=true, bins=500, label=false)
	plot!( x-> pdf(TDist(k),x) , lw=4 , color=:red, label="t dist" )
	plot!( x->pdf(Normal(),x), color=:green, lw=2, label="normal dist")
	xlims!(-3, 3)
	ylims!(0, .4)
end

# ╔═╡ 2e530106-57a8-46a9-8f99-49a871d43255
md"""
## The Pr(>|t|)  column 
is the area of the curve outside of the interval [-t,t].
"""

# ╔═╡ a990b133-ce50-4edf-81e1-1e78aeff8cd6
md"""
In statistics we ask if the coefficient ought to be considered 0 (which means in this case the data has no intercept or does not depend on x) or whether the coefficients are signficant with some probability.  The Pr(>|t|) column gives us the probablity that we should accept the hypothesis that the coefficients might reasonably be just 0.

In a proper statistical test, you should decide at what level you might be willing to accept the hypothesis, example .99, .95, or .9  might be a reasonable level, and if the test gives a smaller probability, you will accept that the coefficients are signficant.  It is not proper to produce the able and then decide whether to use .99, say.
"""

# ╔═╡ 3d0ea801-d66b-4e4e-90da-3a7dce28140d
md"""
# Degrees of Freedom
"""

# ╔═╡ 6fb223bb-f193-414d-9144-df180d09bea1
md"""
It is interesting to see that the sum of squares of a demeaned Gaussian vector is the size -1.  This is the reason for the (n-1) in the sample mean for variance.
"""

# ╔═╡ fb495ba4-52e6-4e0d-bd9c-981700edfebc
md"""
How many degrees of freedom are in a "demeaned" vector of normals?
"""

# ╔═╡ cdc4b25d-d05f-40c8-9c79-265876f01523
   
mean([ (v = randn(17);v.-=mean(v);sum(v.^2)) for i=1:1_000_000])

# ╔═╡ 967c5e3e-ab4c-45de-953c-aff6d16229af
md"""
If you ever wondered why the sample variance always has you dividing by (n-1)
and not n, this is the crux of the reason.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
GLM = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
CSV = "~0.10.4"
DataFrames = "~1.3.4"
Distributions = "~0.25.58"
GLM = "~1.7.0"
Plots = "~1.29.0"
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

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "873fb188a4b9d76549b81465b1f75c82aaf59238"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.4"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "63d1e802de0c4882c00aee5cb16f9dd4d6d7c59c"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.1"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "daa21eb85147f72e41f6352a57fccea377e310a9"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.4"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "8a6b49396a4058771c5c072239b2e0a76e2e898c"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.58"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "129b104185df66e408edd6625d480b7f9e9823a0"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.18"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[GLM]]
deps = ["Distributions", "LinearAlgebra", "Printf", "Reexport", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "StatsModels"]
git-tree-sha1 = "92b8d38886445d6d06e5f13201e57d018c4ff880"
uuid = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
version = "1.7.0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "61feba885fac3a407465726d0c330b3055df897f"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

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

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "027185efff6be268abbaf30cfd53ca9b59e3c857"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.10"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d457f881ea56bbfa18222642de51e0abf67b9027"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.0"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "6a2f7d70512d205ca8c7ee31bfa9f142fe74310c"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.12"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[ShiftedArrays]]
git-tree-sha1 = "22395afdcf37d6709a5a0766cc4a5ca52cb85ea0"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "1.0.0"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[StatsFuns]]
deps = ["ChainRulesCore", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5950925ff997ed6fb3e985dcce8eb1ba42a0bbe7"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.18"

[[StatsModels]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Printf", "REPL", "ShiftedArrays", "SparseArrays", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "4352d5badd1bc8bf0a8c825e886fa1eda4f0f967"
uuid = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
version = "0.6.30"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "e75d82493681dfd884a357952bbd7ab0608e1dc3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.7"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─4ea0ccfa-9622-11eb-1cf0-e9ae2f927dd2
# ╠═d155ea12-9628-11eb-347f-7754a33fd403
# ╠═01506de2-918a-11eb-2a4d-c554a6e54631
# ╟─877deb2c-702b-457b-a54b-f27c277928d4
# ╟─36ce167f-382c-4b9a-be34-83250b10c4e5
# ╟─83912943-a847-420a-bfdb-450027b631e8
# ╠═280d112f-d34a-4cc4-9e3a-4ebbfcd5eb51
# ╠═b5031c96-db57-4baf-b271-6bb12e29de9b
# ╠═c2f77e8f-a8c0-4144-a8b4-b25dd98ed234
# ╟─ad161b98-f4a1-42ac-ad4f-8b71fabcfde9
# ╠═8e422886-74ef-4c0f-be1e-fda238c8db44
# ╟─ca21122a-2522-482a-b7ef-bd73e96cb5a9
# ╟─41e05b1e-8b5e-45e3-91bb-01355ade9f3d
# ╠═9d2e3861-ca36-406e-952d-831ca3947e44
# ╟─e73854ed-3581-41c4-ada5-e48242033759
# ╠═9873d944-b611-46f9-82a7-0cf714a3078c
# ╠═2be44753-afee-4125-b6bc-8866d2293dc2
# ╟─6e07e8fb-fe51-4b37-bfb2-d1466e768754
# ╟─a755e58a-b16c-4d3b-a85f-81ccf374793f
# ╟─f1e10fb7-adac-4083-8977-616a505fd591
# ╠═2e42986c-2de3-49e6-9c29-a7313c0b1da8
# ╟─22758dd6-9d04-4616-ba99-1430f2dedf9a
# ╠═aff6a616-6d8b-4584-a6f2-195decef7774
# ╠═338da13a-3c26-4366-a669-ac3e24f31577
# ╠═5a742546-1e4d-4aee-bed1-cb10c543e439
# ╟─6a9c8c9a-fac7-42f7-976d-3168132cae48
# ╟─3c038b68-8676-4877-9720-38da7c4e0e0e
# ╟─5a877e40-a101-4f7d-b2a1-ef4cfe5d8807
# ╟─83c28c76-2eab-49f9-9999-05df85054520
# ╟─ba671804-dc6d-415c-89de-9cf6294907b3
# ╟─e8683a71-5822-4491-9ccd-20e0fc3bf531
# ╠═0489e5d8-51ca-4955-83e1-95ea353d9cf2
# ╠═9a65aee4-ab8e-4ab7-be6f-cc2a2e9d5127
# ╟─c3539f42-6ca7-47fb-9707-4d11c9e76643
# ╟─469d809f-424f-4595-ad43-a5b2cc055304
# ╟─6128b8fd-9b85-4896-a0bf-934a0733fafb
# ╠═9eb7caaa-438d-4bcb-9c54-4a0fa72c61de
# ╠═0e8fce45-f1c0-41d4-996a-d6093182afee
# ╠═71590890-38b6-440e-b61b-ece6c49ac602
# ╟─f7cc7146-9ee6-4d87-b024-2a91863f4b24
# ╟─f64815e2-44b8-4585-9269-9a62655c984c
# ╟─feb3c45e-88f4-4ffc-a4a0-e89489187c8d
# ╠═99069dd7-e088-4626-aa29-e48d6f9a474e
# ╟─051a9e38-9a84-4ead-96fa-24c86c2b9f2d
# ╟─2f33ee51-0725-46c2-9f1b-a61cd68abab1
# ╠═e4acd97b-22f7-4812-9898-1a485887a5f2
# ╠═4e413b40-81c4-4160-9d01-046c2d179a06
# ╟─7b94db0d-f46b-4621-9413-1dc787ae9a39
# ╠═51a28b67-ad64-4cf2-a0e6-a78fb101eb15
# ╠═d451af49-3139-4329-a885-a210b1760f74
# ╟─c7455f7a-9c72-42f5-8238-1799cad96f6c
# ╟─d2971801-2cdb-4b9f-8ec8-c74cbb2a0b31
# ╠═e1e8c140-bc4e-400d-beb2-0986e071c3a3
# ╟─1429be09-a31f-415f-9c3d-f32b085ef68d
# ╠═da321202-0dc5-44ad-aac0-f3ea0d229243
# ╟─2aceb366-a067-4271-9362-c320f4735ed1
# ╠═58f548fd-f6d0-479d-8469-bc886783f9a7
# ╟─07be9435-bc07-4a18-aad8-3ff19f5bcce4
# ╠═1a6ad08d-c3bb-47e7-bdee-156bbff3aeda
# ╟─c55e4894-db71-4729-a1a1-5f68b45e3bf5
# ╠═f50d66eb-0357-4017-ac9b-99e63cd52dc0
# ╟─5c7a7361-f0e7-473a-9e38-226828aa00ca
# ╠═acf0e90e-8f1f-451f-9f0f-70a0bcc7efca
# ╟─c9f65e15-f222-4a88-98c2-9e1d8b5ec3eb
# ╠═2589a369-8b21-406d-906d-71b18e4c7895
# ╟─ed6a0e6a-2d0c-4f77-9b08-1a5b5d56dd34
# ╠═61d1c1f7-e070-413b-8a92-76f44d237206
# ╟─94d80ad6-0403-4322-aa9f-647c291c19d7
# ╠═ce89b805-39a2-49e6-8781-c557aa73ed27
# ╠═75f9b5e9-775d-4767-9da6-222f977da686
# ╠═797c9f2f-0b85-4435-b1c0-edc8cf67f738
# ╠═6e0b2452-9f8b-4730-8072-a663704893c5
# ╠═bf537a3a-b7c6-4c64-8b44-85511c3d492e
# ╟─1340818c-3391-420b-aa94-acaea8a47d7d
# ╠═829607ff-25e0-4585-9c5c-d132ecb86cc8
# ╠═3fc0a4a8-6719-4920-99c7-bd576225214e
# ╠═24a7ad28-936c-47dc-bc53-d1ddbf39d05d
# ╟─9233dc6a-7578-4d72-b0c2-c3bb110a9fbe
# ╠═07e02bb6-380d-40dd-86ad-19d713cd1657
# ╟─b14593ba-cb8c-4f28-8fb0-2d2df479357b
# ╟─ac204681-b9df-471b-a22e-9d8f68679151
# ╟─08f43fff-fbd8-468f-8b3b-efd1829f4fc0
# ╠═43ec6124-c3e5-4f34-b0d9-1a0b069aa3e0
# ╠═3fe71215-bbf2-40e9-bcfc-0bc9b3ac94c8
# ╟─a2b27841-256e-4898-aeca-04c4f44138fb
# ╟─8851dca3-e1a6-46b2-9745-f175ef0b0fae
# ╟─ccfcb4d9-5a88-48fb-9568-1147a74f6eec
# ╟─13858c0a-3e7a-4742-a821-97dd9a45109d
# ╟─b2c3c1e5-e569-4c6f-bad9-055a25d73dce
# ╠═305e4dfc-af7d-4667-8da8-a7ba5fd20fa6
# ╟─a648ba4f-fec4-4fa7-b328-1b52070224eb
# ╠═d652df7d-7364-4da4-b51e-9fc88b978cda
# ╟─2e530106-57a8-46a9-8f99-49a871d43255
# ╟─a990b133-ce50-4edf-81e1-1e78aeff8cd6
# ╟─3d0ea801-d66b-4e4e-90da-3a7dce28140d
# ╟─6fb223bb-f193-414d-9144-df180d09bea1
# ╟─fb495ba4-52e6-4e0d-bd9c-981700edfebc
# ╠═cdc4b25d-d05f-40c8-9c79-265876f01523
# ╟─967c5e3e-ab4c-45de-953c-aff6d16229af
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
