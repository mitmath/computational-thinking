### A Pluto.jl notebook ###
# v0.14.1

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

# ╔═╡ d155ea12-9628-11eb-347f-7754a33fd403
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="DataFrames", version="0.22"),
        Pkg.PackageSpec(name="CSV", version="0.8"),
        Pkg.PackageSpec(name="GLM", version="1"),
        Pkg.PackageSpec(name="Distributions", version="0.24"),
    ])
    using Plots, PlutoUI, DataFrames, CSV, GLM, Statistics, LinearAlgebra, Distributions
end

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
"><em>Section 2.8 </em></p>
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
TableOfContents(title="📚 Table of Contents", aside=true)

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
	data2 = DataFrame([x  y]) # convert Matrix to DataFrame
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
data_again[:,"°F" ] #or data_again[:,1]

# ╔═╡ 5a742546-1e4d-4aee-bed1-cb10c543e439
data_again[:,1]

# ╔═╡ fd4d4503-d24b-48a3-adb1-e0421b2ffdb6


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
	
	scatter(x, yy,m=:c,mc=:red, label="noisy data", ylims=(-40,40))
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
	bᵉ,mᵉ,s2ᵉ
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
	#[linear_regression(x,y .+ (σ * sqrt(12)) * (-.5 .+ rand(length(x))))   for i=1:howmany]
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
	histogram( getindex.(s,2), alpha=.6, bins=100, norm=true, legend=false )
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
mean(getindex.(s,2)), .555555

# ╔═╡ c9f65e15-f222-4a88-98c2-9e1d8b5ec3eb
md"""
Sample std of the slope.
"""

# ╔═╡ 2589a369-8b21-406d-906d-71b18e4c7895
std( getindex.(s,2))

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
	#xlims!(0,20)
	#ylims!(0,.13)
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

# ╔═╡ 009dcdb3-4ab7-4c61-8246-df1e7d55efa5


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
# ╠═fd4d4503-d24b-48a3-adb1-e0421b2ffdb6
# ╟─6a9c8c9a-fac7-42f7-976d-3168132cae48
# ╟─3c038b68-8676-4877-9720-38da7c4e0e0e
# ╟─5a877e40-a101-4f7d-b2a1-ef4cfe5d8807
# ╟─83c28c76-2eab-49f9-9999-05df85054520
# ╠═ba671804-dc6d-415c-89de-9cf6294907b3
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
# ╠═a648ba4f-fec4-4fa7-b328-1b52070224eb
# ╠═d652df7d-7364-4da4-b51e-9fc88b978cda
# ╟─2e530106-57a8-46a9-8f99-49a871d43255
# ╟─a990b133-ce50-4edf-81e1-1e78aeff8cd6
# ╟─3d0ea801-d66b-4e4e-90da-3a7dce28140d
# ╠═009dcdb3-4ab7-4c61-8246-df1e7d55efa5
# ╟─6fb223bb-f193-414d-9144-df180d09bea1
# ╟─fb495ba4-52e6-4e0d-bd9c-981700edfebc
# ╠═cdc4b25d-d05f-40c8-9c79-265876f01523
# ╠═967c5e3e-ab4c-45de-953c-aff6d16229af
