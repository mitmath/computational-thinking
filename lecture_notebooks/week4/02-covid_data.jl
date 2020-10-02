### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ db4c1f10-7c37-4513-887a-2467ce673458
begin
	using Pkg   
	Pkg.add.(["CSV", "DataFrames", "PlutoUI", "Shapefile", "ZipFile", "LsqFit", "Plots"])

	using CSV
	using DataFrames
	using PlutoUI
	using Shapefile
	using ZipFile
	using LsqFit
	using Plots
end

# ╔═╡ a26b8742-6a16-445a-ae77-25a4189c0f14


# ╔═╡ cbd9c1aa-fc37-11ea-29d9-e3361406796f
using Dates

# ╔═╡ 0f87cec6-fc31-11ea-23d2-395e61f38b6f
md"# Module 2: Epidemic propagation"

# ╔═╡ 19f4da16-fc31-11ea-0de9-1dbe668b862d
md"We are starting a new module on modelling epidemic propagation.

Let's start off by analysing some of the data that is now available on the current COVID-19 pandemic.
"

# ╔═╡ d3398953-afee-4989-932c-995c3ffc0c40
md"""
## Exploring COVID-19 data
"""

# ╔═╡ efa281da-cef9-41bc-923e-625140ce5a07
md"""
In this notebook we will explore and analyse data on the COVID-19 pandemic. The aim is to use Julia tools to analyse and visualise the data in different ways.

By the end of the notebook we will produce the following visualisation using Julia and Pluto:
"""

# ╔═╡ 7617d970-fce4-11ea-08ba-c7eba3e17f62
@bind day Clock(0.5)

# ╔═╡ e0493940-8aa7-4733-af72-cd6bc0e37d92
md"""
## Download and load data
"""

# ╔═╡ 64d9bcea-7c85-421d-8f1e-17ea8ee694da
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv";

# ╔═╡ c460b0c3-6d3b-439b-8cc7-1c58d6547f51
download(url, "covid_data.csv");

# ╔═╡ a7369222-fc20-11ea-314d-4d6b0f0f72eb
md"We will need a couple of new packages. The data is in CSV format, i.e. *C*omma-*S*eparated *V*alues. This is a common data format in which observations, i.e. data points, are separated on different lines. Within each line the different data for that observation are separated by commas or other punctuation (possibly spaces and tabs)."

# ╔═╡ 1620aa9d-7dcd-4686-b7e4-a72cebe315ed
md"""
We can load the data from a CSV using the `File` function from the `CSV.jl` package, and then convert it to a `DataFrame`:
"""

# ╔═╡ 38344160-fc27-11ea-220e-95aa00e4b083
begin
	csv_data = CSV.File("covid_data.csv");   
	data = DataFrame(csv_data)   # it is common to use `df` as a variable name
end

# ╔═╡ ad43cea2-fc28-11ea-2bc3-a9d81e3766f4
md"A `DataFrame` is a standard way of storing **heterogeneous data** in Julia, i.e. a table consisting of columns with different types. As you can see from the display of the `DataFrame` object above, each column has an associated type, but different columns have different types, reflecting the type of the data in that column.

In our case, country names are stored as `String`s, their latitude and longitude as `Float64`s and the (cumulative) case counts for each day as `Int64`s.
."

# ╔═╡ fab64d86-fc28-11ea-0ae1-3ba1b9a14759
md"## Using the data"

# ╔═╡ 3519cf96-fc26-11ea-3386-d97c61ea1b85
md"""Since we need to manipulate the columns, let's rename them to something shorter. We can do this either **in place**, i.e. modifying the original `DataFrame`, or **out of place**, creating a new `DataFrame`. The convention in Julia is that functions that modify their argument have a name ending with `!` (often pronounced "bang").

We can use the `head` function to see only the first few lines of the data.
"""

# ╔═╡ a054e048-4fea-487c-9d06-463723c7151c
begin
	data_2 = rename(data, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude")   
	head(data_2)
end

# ╔═╡ e9ad97b6-fdef-4f48-bd32-634cfd2ce0e6
begin
	rename!(data, 1 => "province", 2 => "country", 3 => "latitude", 4 => "longitude") 
	head(data)
end

# ╔═╡ aaa7c012-fc1f-11ea-3c6c-89630affb1db
md"## Extracting useful information"

# ╔═╡ b0eb3918-fc1f-11ea-238b-7f5d23e424bb
md"How can we extract the list of all the countries? The country names are in the second column.

For some purposes we can think of a `DataFrame`.as a matrix and use similar syntax. For example, we can extract the second column:
"

# ╔═╡ 68f76d3b-b398-459d-bf39-20bf300dcaa2
all_countries = data[:, "country"]

# ╔═╡ 20e144f2-fcfb-11ea-010c-97e21eb0d231
all_countries2 = data[:, :country]

# ╔═╡ 2ec98a16-fcfb-11ea-21ad-15f2f5e68248
all_countries3 = data[:, 2]

# ╔═╡ 382cfc62-fcfb-11ea-26aa-2984d0449dcc
data[5:8, 2]

# ╔═╡ 34440afc-fc2e-11ea-0484-5b47af235bad
md"It turns out that some countries are divided into provinces, so there are repetitions in the `country` column that we can eliminate with the `unique` function:"

# ╔═╡ 79ba0433-2a31-475a-87c9-14103ebbff16
countries = unique(all_countries)

# ╔═╡ 5c1ec9ae-fc2e-11ea-397d-937c7ab1edb2
@bind i Slider(1:length(countries), show_value=true)

# ╔═╡ a39589ee-20e3-4f22-bf81-167fd815f6f9
md"$(Text(countries[i]))"

# ╔═╡ 9484ea9e-fc2e-11ea-137c-6da8212da5bd
md"[Here we used **string interpolation** with `$` to put the text into a Markdown string.]"

# ╔═╡ bcc95a8a-fc2e-11ea-2ccd-3bece42a08e6
md"You can also use `Select` to get a dropdown instead:"

# ╔═╡ ada3ceb4-fc2e-11ea-2cbf-399430fa18b5
@bind country Select(countries)

# ╔═╡ 1633abe8-fc2f-11ea-2c7e-21b3348a3569
md"""How can we extract the data for a particular country? First we need to know the exact name of the country. E.g. is the US written as "USA", or "United States"?

We could scroll through to find out, or **filter** the data to only look at a sample of it, for example those countries that begin with the letter "U".

One way to do this is with an array comprehension:"""

# ╔═╡ ed383524-e0c0-4da2-9a98-ca75aadd2c9e
md"""
Array comprehension:
"""

# ╔═╡ 90810d7e-fcfb-11ea-396a-35543dcc1e06
startswith("david", "d")

# ╔═╡ 977e1a2c-fcfb-11ea-08e9-cd656a631778
startswith("hello", "d")

# ╔═╡ 9ee79840-30ff-4c92-97f4-e178caceceaf
U_countries = [startswith(country, "U") for country in all_countries]

# ╔═╡ 99d5a138-fc30-11ea-2977-71732ca3aead
length(U_countries)

# ╔═╡ 450b4902-fc30-11ea-321d-29faf6188ff5
md"Note that this returns an array of booleans of the same length as the vector `all_countries`. We can now use this to index into the `DataFrame`:"

# ╔═╡ 4f423a75-43da-486f-ac2a-7220032dac9f
data[U_countries, :]

# ╔═╡ a8b2db96-fc30-11ea-2eea-b938a3a430fb
md"""We see that the correct spelling is `"US"`. (And note how the different provinces of the UK are separated.)"""

# ╔═╡ c400ce4e-fc30-11ea-13b1-b54cf8f5630e
md"Now we would like to extract the data for the US alone. How can we access the correct row of the table? We can again filter on the country name. A nicer way to do this is to use the `filter` function.

This is a **higher-order function**: its first argument is itself a function, which must return `true` or `false`.  `filter` will return all the rows of the `DataFrame` that satisfy that **predicate**:
"

# ╔═╡ 7b2496b0-fc35-11ea-0e78-473e5e8eac44
filter(x -> x.country == "United Kingdom", data)

# ╔═╡ 8990f13a-fc35-11ea-338f-0955eeb23c3c
md"Here we have used an **anonymous function** with the syntax `x -> ⋯`. This is a function which takes the argument `x` and returns whatever is on the right of the arrow (`->`)."

# ╔═╡ a772eadc-fc35-11ea-3d38-4b121f88f1d7
md"To extract a single row we need the **index** of the row (i.e. which number row it is in the `DataFrame`). The `findfirst` function finds the first row that satisfies the given predicate:"

# ╔═╡ 16a79308-fc36-11ea-16e5-e1087d7ebbda
US_row = findfirst(==("US"), all_countries)

# ╔═╡ a41db8ea-f0e0-461f-a298-bdcea42a67f3
data[US_row, :]

# ╔═╡ f75e1992-fcfb-11ea-1123-b59bf888eac3
data[US_row:US_row, :]

# ╔═╡ 67eebb7e-fc36-11ea-03ef-bd6966487bb5
md"Now we can extract the data into a standard Julia `Vector`:"

# ╔═╡ 7b5db0f4-fc36-11ea-09a5-49def64f4c79
US_data = Vector(data[US_row, 5:end])

# ╔═╡ f099424c-0e22-42fb-894c-d8c2a65715fb
scatter(US_data, m=:o, alpha=0.5, ms=3, xlabel="day", ylabel="cumulative cases", leg=false)

# ╔═╡ 7e7d14a2-fc37-11ea-3f1a-870ca98c4b75
md"Note that we are only passing a single vector to the `scatter` function, so the $x$ coordinates are taken as the natural numbers $1$, $2$, etc.

Also note that the $y$-axis in this plot gives the *cumulative* case numbers, i.e. the *total* number of confirmed cases since the start of the epidemic up to the given date. 
"

# ╔═╡ 75d2dc66-fc47-11ea-0e35-05f9cf38e901
md"This is an example of a **time series**, i.e. a single quantity that changes over time."

# ╔═╡ b3880f40-fc36-11ea-074a-edc51adeb6f0
md"## Using dates"

# ╔═╡ 6de0800c-fc37-11ea-0d94-2b6f8f66964d
md"We would like to use actual dates instead of just the number of days since the start of the recorded data. The dates are given in the column names of the `DataFrame`:
"

# ╔═╡ bb6316b7-23fb-44a3-b64a-dfb71a7df011
column_names = names(data)

# ╔═╡ 0c098923-b016-4c65-9a37-6b7b56b13a0c
date_strings = names(data)[5:end]  # apply String function to each element

# ╔═╡ 546a40eb-7897-485d-a1b5-c4dfae0a4861
md"""
Now we need to **parse** the date strings, i.e. convert from a string representation into an actual Julia type provided by the `Dates.jl` standard library package:
"""

# ╔═╡ 9e23b0e2-ac13-4d19-a3f9-4a655a1e9f14
date_strings[1]

# ╔═╡ 25c79620-14f4-45a7-b120-05ec72cb77e9
date_format = Dates.DateFormat("m/d/Y")

# ╔═╡ 31dc4e46-4839-4f01-b383-1a1189aeb0e6
parse(Date, date_strings[1], date_format)

# ╔═╡ ee27bd98-fc37-11ea-163c-1365e194fc2e
md"Since the year was not correctly represented in the original data, we need to manually fix it:"

# ╔═╡ f5c29f0d-937f-4731-8f87-0405ebc966f5
dates = parse.(Date, date_strings, date_format) .+ Year(2000)

# ╔═╡ b0e7f1c6-fce3-11ea-10e5-9101d0f861a2
dates[day]

# ╔═╡ 36c37b4d-eb23-4deb-a593-e511eccd9204
begin
	plot(dates, US_data, xrotation=45, leg=:topleft, 
	    label="US data", m=:o, ms=3, alpha=0.5)
	
	xlabel!("date")
	ylabel!("cumulative US cases")
	title!("US cumulative confirmed COVID-19 cases")
end

# ╔═╡ 511eb51e-fc38-11ea-0492-19532da809de
md"## Exploratory data analysis"

# ╔═╡ d228e232-fc39-11ea-1569-a31b817118c4
md"
Working with *cumulative* data is often less intuitive. Let's look at the actual number of daily cases. Julia has a `diff` function to calculate the difference between successive entries of a vector:
"

# ╔═╡ dbaacbb6-fc3b-11ea-0a42-a9792e8a6c4c
begin
	daily_cases = diff(US_data)
	plot(dates[2:end], daily_cases, m=:o, leg=false, xlabel="days", ylabel="daily US cases", alpha=0.5)   # use "o"-shaped markers
end

# ╔═╡ 19bdf146-fc3c-11ea-3c60-bf7823c43a1d
begin
	using Statistics
	running_mean = [mean(daily_cases[i-6:i]) for i in 7:length(daily_cases)]
end

# ╔═╡ 12900562-fc3a-11ea-25e1-f7c91a6940e5
md"Note that discrete data should *always* be plotted with points. The lines are just to guide the eye. 

Cumulating data corresponds to taking the integral of a function and is a *smoothing* operation. Note that the cumulative data is indeed visually smoother than the daily data.

The oscillations in the daily data seem to be due to a lower incidence of reporting at weekends. We could try to smooth this out by taking a **moving average**, say over the past week:
"

# ╔═╡ be868a52-fc3b-11ea-0b60-7fea05ffe8e9
begin
	plot(daily_cases, label="raw daily cases")
	plot!(running_mean, m=:o, label="running weakly mean", leg=:topleft)
end

# ╔═╡ 0b01120c-fc3d-11ea-1381-8bab939e6214
md"## Exponential growth

Simple models of epidemic spread often predict a period with **exponential growth**. Do the data corroborate this?
"

# ╔═╡ 252eff18-fc3d-11ea-0c18-7b130ada882e
md"""A visual check for this is to plot the data with a **logarithmic scale** on the $y$ axis (but a standard scale on the $x$ axis).

If we observe a straight line on such a semi-logarithmic plot, then we know that

$$\log(y) \sim \alpha x + \beta,$$

where we are using $\sim$ to denote approximate equality.

Taking exponentials of both sides gives

$$y \sim \exp(\alpha x + \beta),$$

i.e.

$$y \sim c \, \mathrm{e}^{\alpha x},$$

where $c$ is a constant (sometimes called a "pre-factor") and $\alpha$ is the exponential growth rate, found from the slope of the straight line on the semi-log plot.
"""

# ╔═╡ 9626d74a-fc3d-11ea-2ab3-978dc46c0f1f
md"""Since the data contains some zeros, we need to replace those with `NaN`s ("Not a Number"), which `Plots.jl` interprets as a signal to break the line"""

# ╔═╡ 4358c348-91aa-4c76-a443-0a9cefce0e83
begin
	plot(replace(daily_cases, 0 => NaN), 
		yscale=:log10, 
		leg=false, m=:o)
	
	xlabel!("day")
	ylabel!("confirmed cases in US")
	title!("US confirmed COVID-19 cases")
end

# ╔═╡ 687409a2-fc43-11ea-03e0-d9a7a48165a8
md"Let's zoom in on the region of the graph where the growth looks linear on this semi-log plot:"

# ╔═╡ 4f23c8fc-fc43-11ea-0e73-e5f89d14155c
xlims!(0, 100)

# ╔═╡ 91f99062-fc43-11ea-1b0e-afe8aa8a1c3d
exp_period = 38:60

# ╔═╡ 07282688-fc3e-11ea-2f9e-5b0581061e65
md"We see that there is a period lasting from around day $(first(exp_period)) to around day $(last(exp_period)) when the curve looks straight on the semi-log plot. 
This corresponds to the following date range:"

# ╔═╡ 210cee94-fc3e-11ea-1a6e-7f88270354e1
dates[exp_period]

# ╔═╡ 2f254a9e-fc3e-11ea-2c02-75ed59f41903
md"i.e. the first 3 weeks of March. Fortunately the imposition of lockdown during the last 10 days of March (on different days in different US states) significantly reduced transmission."

# ╔═╡ 84f5c776-fce0-11ea-2d52-39c51d4ab6b5
md"## Data fitting"

# ╔═╡ 539c951c-fc48-11ea-2293-457b7717ea4d
md"""Let's try to fit an exponential function to our data in the relevant region. We will use the Julia package `LsqFit.jl` ("least-squares fit").

This package allows us to specify a model function that takes a vector of data and a vector of parameters, and it finds the best fit to the data.
"""

# ╔═╡ b33e97f2-fce0-11ea-2b4d-ffd7ed7000f8
model(x, (c, α)) = c .* exp.(α .* x)

# ╔═╡ d52fc8fe-fce0-11ea-0a04-b146ee2dbe80
begin
	p0 = [0.5, 0.5]  # initial guess for parameters

	x_data = exp_period
	y_data = daily_cases[exp_period]
	
	fit = curve_fit(model, x_data, y_data, p0)
end;

# ╔═╡ c50b5e42-fce1-11ea-1667-91c56ea80dcc
md"We are interested in the coefficients of the best-fitting model:"

# ╔═╡ 3060bfa8-fce1-11ea-1047-db0dc06485a2
parameters = coef(fit)

# ╔═╡ 62bdc04a-fce1-11ea-1724-bfc4bc4789d1
md"Now let's add this to the plot:"

# ╔═╡ 6bc8cc20-fce1-11ea-2180-0fa69e86741f
begin
	plot(replace(daily_cases, 0 => NaN), 
		yscale=:log10, 
		leg=false, m=:o,
		xlims=(1, 100), alpha=0.5)
	
	line_range = 30:70
	plot!(line_range, model(line_range, parameters), lw=3, ls=:dash, alpha=0.7)
	
	xlabel!("day")
	ylabel!("confirmed cases in US")
	title!("US confirmed COVID-19 cases")
end

# ╔═╡ 287f0fa8-fc44-11ea-2788-9f3ac4ee6d2b
md"## Geographical data"

# ╔═╡ 3edd2a22-fc4a-11ea-07e5-55ca6d7639e8
md"Our data set contains more information: the geographical locations (latitude and longitude) of each country (or, rather, of a particular point that was chosen as being representative of that country)."

# ╔═╡ c5ad4d40-fc57-11ea-23cb-e55487bc6f7a
filter(x -> startswith(x.country, "A"), data)

# ╔═╡ 57a9bb06-fc4a-11ea-2665-7f97026981dc
md"Let's extract and plot the geographical information. To reduce the visual noise a bit we will only use those "

# ╔═╡ 80138b30-fc4a-11ea-0e15-b54cf6b402df
province = data.province

# ╔═╡ 8709f208-fc4a-11ea-0203-e13eae5f0d93
md"If the `province` is missing we should use the country name instead:"

# ╔═╡ a29c8ad0-fc4a-11ea-14c7-71435769b73e
begin
	indices = ismissing.(province)
	province[indices] .= all_countries[indices]
end

# ╔═╡ 4e4cca22-fc4c-11ea-12ae-2b51545799ec
begin 
	
	scatter(data.longitude, data.latitude, leg=false, alpha=0.5, ms=2)

	for i in 1:length(province)	
		annotate!(data.longitude[i], data.latitude[i], text(province[i], :center, 5, color=RGBA{Float64}(0.0,0.0,0.0,0.3)))
	end
	
	plot!(axis=false)
end

# ╔═╡ 16981da0-fc4d-11ea-37a2-535aa014a298
data.latitude

# ╔═╡ a9c39dbe-fc4d-11ea-2e86-4992896e2abb
md"## Adding maps"

# ╔═╡ b93b88b0-fc4d-11ea-0c45-8f64983f8b5c
md"We would also like to see the outlines of each country. For this we can use, for example, the data from [Natural Earth](https://www.naturalearthdata.com/downloads/110m-cultural-vectors/110m-admin-0-countries), which comes in the form of **shape files**, giving the outlines in terms of latitude and longitude coordinates. 

These may be read in using the `Shapefile.jl` package.

The data is provided in a `.zip` file, so after downloading it we first need to decompress it.
"

# ╔═╡ 7ec28cd0-fc87-11ea-2de5-1959ea5dc37c
begin
	zipfile = download("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip")

	r = ZipFile.Reader(zipfile);
	for f in r.files
	    println("Filename: $(f.name)")
		open(f.name, "w") do io
	    	write(io, read(f))
		end
    end
	close(r)
end

# ╔═╡ ada44a56-fc56-11ea-2ab7-fb649be7e066
shp_countries = Shapefile.shapes(Shapefile.Table("./ne_110m_admin_0_countries.shp"))

# ╔═╡ d911edb6-fc87-11ea-2258-d34d61c02245


# ╔═╡ b3e1ebf8-fc56-11ea-05b8-ed0b9e50503d
plot!(shp_countries, alpha=0.2)

# ╔═╡ f8e754ee-fc73-11ea-0c7f-cdc760ab3e94
md"Now we would like to combine the geographical and temporal (time) aspects. One way to do so is to animate time:"

# ╔═╡ 39982810-fc76-11ea-01c3-3987cfc2fd3c
daily = max.(1, diff(Array(data[:, 5:end]), dims=2));

# ╔═╡ 0f329ece-fc74-11ea-1e02-bdbddf551ef3
@bind day2 Slider(1:size(daily, 2), show_value=true)

# @bind day Clock(0.5)

# ╔═╡ b406eec8-fc77-11ea-1a98-d36d6d3e2393
log10(maximum(daily[:, day]))

# ╔═╡ 1f30a1ac-fc74-11ea-2abf-abf437006bab
dates[day2]

# ╔═╡ 24934438-fc74-11ea-12e4-7f7e50f54029
world_plot = begin 
	plot(shp_countries, alpha=0.2)
	scatter!(data.longitude, data.latitude, leg=false, ms=2*log10.(daily[:, day2]), alpha=0.7)
	xlabel!("latitude")
	ylabel!("longitude")
	title!("daily cases per country")
end


# ╔═╡ f7a37706-fcdf-11ea-048a-236b8ed0f1f3
world_plot

# ╔═╡ 251c06e4-fc77-11ea-1a0f-73139ba11e83
md"However, we should always be wary about visualisations such as these. Perhaps we should be plotting cases per capita instead of absolute numbers of cases. Or should we divide by the area of the country? Some countries, such as China and Canada, are divided into states or regions in the original data set -- but others, such as the US, are not. You should always check exactly what is being plotted! 

Unfortunately, published visualisations often hide some of  this information. This emphasises the need to be able to get our hands on the data, create our own visualisations and draw our own conclusions."

# ╔═╡ Cell order:
# ╟─0f87cec6-fc31-11ea-23d2-395e61f38b6f
# ╟─19f4da16-fc31-11ea-0de9-1dbe668b862d
# ╟─d3398953-afee-4989-932c-995c3ffc0c40
# ╟─efa281da-cef9-41bc-923e-625140ce5a07
# ╠═7617d970-fce4-11ea-08ba-c7eba3e17f62
# ╠═b0e7f1c6-fce3-11ea-10e5-9101d0f861a2
# ╠═f7a37706-fcdf-11ea-048a-236b8ed0f1f3
# ╟─e0493940-8aa7-4733-af72-cd6bc0e37d92
# ╠═64d9bcea-7c85-421d-8f1e-17ea8ee694da
# ╠═c460b0c3-6d3b-439b-8cc7-1c58d6547f51
# ╟─a7369222-fc20-11ea-314d-4d6b0f0f72eb
# ╠═db4c1f10-7c37-4513-887a-2467ce673458
# ╟─1620aa9d-7dcd-4686-b7e4-a72cebe315ed
# ╠═38344160-fc27-11ea-220e-95aa00e4b083
# ╟─ad43cea2-fc28-11ea-2bc3-a9d81e3766f4
# ╟─fab64d86-fc28-11ea-0ae1-3ba1b9a14759
# ╟─3519cf96-fc26-11ea-3386-d97c61ea1b85
# ╠═a054e048-4fea-487c-9d06-463723c7151c
# ╠═e9ad97b6-fdef-4f48-bd32-634cfd2ce0e6
# ╟─aaa7c012-fc1f-11ea-3c6c-89630affb1db
# ╟─b0eb3918-fc1f-11ea-238b-7f5d23e424bb
# ╠═68f76d3b-b398-459d-bf39-20bf300dcaa2
# ╠═20e144f2-fcfb-11ea-010c-97e21eb0d231
# ╠═2ec98a16-fcfb-11ea-21ad-15f2f5e68248
# ╠═382cfc62-fcfb-11ea-26aa-2984d0449dcc
# ╟─34440afc-fc2e-11ea-0484-5b47af235bad
# ╠═79ba0433-2a31-475a-87c9-14103ebbff16
# ╠═5c1ec9ae-fc2e-11ea-397d-937c7ab1edb2
# ╟─a39589ee-20e3-4f22-bf81-167fd815f6f9
# ╟─9484ea9e-fc2e-11ea-137c-6da8212da5bd
# ╟─bcc95a8a-fc2e-11ea-2ccd-3bece42a08e6
# ╠═ada3ceb4-fc2e-11ea-2cbf-399430fa18b5
# ╟─1633abe8-fc2f-11ea-2c7e-21b3348a3569
# ╟─ed383524-e0c0-4da2-9a98-ca75aadd2c9e
# ╠═90810d7e-fcfb-11ea-396a-35543dcc1e06
# ╠═977e1a2c-fcfb-11ea-08e9-cd656a631778
# ╠═9ee79840-30ff-4c92-97f4-e178caceceaf
# ╠═99d5a138-fc30-11ea-2977-71732ca3aead
# ╟─450b4902-fc30-11ea-321d-29faf6188ff5
# ╠═4f423a75-43da-486f-ac2a-7220032dac9f
# ╟─a8b2db96-fc30-11ea-2eea-b938a3a430fb
# ╟─c400ce4e-fc30-11ea-13b1-b54cf8f5630e
# ╠═7b2496b0-fc35-11ea-0e78-473e5e8eac44
# ╟─8990f13a-fc35-11ea-338f-0955eeb23c3c
# ╟─a772eadc-fc35-11ea-3d38-4b121f88f1d7
# ╠═16a79308-fc36-11ea-16e5-e1087d7ebbda
# ╠═a41db8ea-f0e0-461f-a298-bdcea42a67f3
# ╠═f75e1992-fcfb-11ea-1123-b59bf888eac3
# ╟─67eebb7e-fc36-11ea-03ef-bd6966487bb5
# ╠═7b5db0f4-fc36-11ea-09a5-49def64f4c79
# ╠═a26b8742-6a16-445a-ae77-25a4189c0f14
# ╠═f099424c-0e22-42fb-894c-d8c2a65715fb
# ╟─7e7d14a2-fc37-11ea-3f1a-870ca98c4b75
# ╟─75d2dc66-fc47-11ea-0e35-05f9cf38e901
# ╟─b3880f40-fc36-11ea-074a-edc51adeb6f0
# ╟─6de0800c-fc37-11ea-0d94-2b6f8f66964d
# ╠═bb6316b7-23fb-44a3-b64a-dfb71a7df011
# ╠═0c098923-b016-4c65-9a37-6b7b56b13a0c
# ╟─546a40eb-7897-485d-a1b5-c4dfae0a4861
# ╠═cbd9c1aa-fc37-11ea-29d9-e3361406796f
# ╠═9e23b0e2-ac13-4d19-a3f9-4a655a1e9f14
# ╠═25c79620-14f4-45a7-b120-05ec72cb77e9
# ╠═31dc4e46-4839-4f01-b383-1a1189aeb0e6
# ╟─ee27bd98-fc37-11ea-163c-1365e194fc2e
# ╠═f5c29f0d-937f-4731-8f87-0405ebc966f5
# ╠═36c37b4d-eb23-4deb-a593-e511eccd9204
# ╟─511eb51e-fc38-11ea-0492-19532da809de
# ╟─d228e232-fc39-11ea-1569-a31b817118c4
# ╠═dbaacbb6-fc3b-11ea-0a42-a9792e8a6c4c
# ╟─12900562-fc3a-11ea-25e1-f7c91a6940e5
# ╠═19bdf146-fc3c-11ea-3c60-bf7823c43a1d
# ╠═be868a52-fc3b-11ea-0b60-7fea05ffe8e9
# ╟─0b01120c-fc3d-11ea-1381-8bab939e6214
# ╟─252eff18-fc3d-11ea-0c18-7b130ada882e
# ╟─9626d74a-fc3d-11ea-2ab3-978dc46c0f1f
# ╠═4358c348-91aa-4c76-a443-0a9cefce0e83
# ╟─687409a2-fc43-11ea-03e0-d9a7a48165a8
# ╠═4f23c8fc-fc43-11ea-0e73-e5f89d14155c
# ╟─07282688-fc3e-11ea-2f9e-5b0581061e65
# ╠═91f99062-fc43-11ea-1b0e-afe8aa8a1c3d
# ╠═210cee94-fc3e-11ea-1a6e-7f88270354e1
# ╟─2f254a9e-fc3e-11ea-2c02-75ed59f41903
# ╟─84f5c776-fce0-11ea-2d52-39c51d4ab6b5
# ╟─539c951c-fc48-11ea-2293-457b7717ea4d
# ╠═b33e97f2-fce0-11ea-2b4d-ffd7ed7000f8
# ╠═d52fc8fe-fce0-11ea-0a04-b146ee2dbe80
# ╟─c50b5e42-fce1-11ea-1667-91c56ea80dcc
# ╟─3060bfa8-fce1-11ea-1047-db0dc06485a2
# ╟─62bdc04a-fce1-11ea-1724-bfc4bc4789d1
# ╠═6bc8cc20-fce1-11ea-2180-0fa69e86741f
# ╟─287f0fa8-fc44-11ea-2788-9f3ac4ee6d2b
# ╟─3edd2a22-fc4a-11ea-07e5-55ca6d7639e8
# ╠═c5ad4d40-fc57-11ea-23cb-e55487bc6f7a
# ╟─57a9bb06-fc4a-11ea-2665-7f97026981dc
# ╠═80138b30-fc4a-11ea-0e15-b54cf6b402df
# ╟─8709f208-fc4a-11ea-0203-e13eae5f0d93
# ╠═a29c8ad0-fc4a-11ea-14c7-71435769b73e
# ╠═4e4cca22-fc4c-11ea-12ae-2b51545799ec
# ╠═16981da0-fc4d-11ea-37a2-535aa014a298
# ╟─a9c39dbe-fc4d-11ea-2e86-4992896e2abb
# ╟─b93b88b0-fc4d-11ea-0c45-8f64983f8b5c
# ╠═7ec28cd0-fc87-11ea-2de5-1959ea5dc37c
# ╟─ada44a56-fc56-11ea-2ab7-fb649be7e066
# ╠═d911edb6-fc87-11ea-2258-d34d61c02245
# ╠═b3e1ebf8-fc56-11ea-05b8-ed0b9e50503d
# ╟─f8e754ee-fc73-11ea-0c7f-cdc760ab3e94
# ╠═39982810-fc76-11ea-01c3-3987cfc2fd3c
# ╠═0f329ece-fc74-11ea-1e02-bdbddf551ef3
# ╠═b406eec8-fc77-11ea-1a98-d36d6d3e2393
# ╠═1f30a1ac-fc74-11ea-2abf-abf437006bab
# ╠═24934438-fc74-11ea-12e4-7f7e50f54029
# ╟─251c06e4-fc77-11ea-1a0f-73139ba11e83
