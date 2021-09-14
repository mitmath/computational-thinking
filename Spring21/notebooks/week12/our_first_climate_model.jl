### A Pluto.jl notebook ###
# v0.16.0

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

# ╔═╡ c7d387fa-cd19-458c-a45d-7893e8c21bbf
begin
    using DifferentialEquations, Plots, PlutoUI, LinearAlgebra, CSV, DataFrames
end

# ╔═╡ 42085492-ac8c-11eb-0620-adcb307077f1
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
"><em>Section 3.4</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> Our first climate model </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/J1UsMa1cTeE" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>"""

# ╔═╡ 14195fc4-40e1-4576-973a-69d649fddc02
TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)

# ╔═╡ 92883ed9-5572-41fd-96c7-190279f90804
md"""
This lecture is based on the fall 2020 "Introduction to Climate Modeling" lecture by Henri Drake. [Henri's video](https://computationalthinking.mit.edu/Fall20/lecture20/),
[Henri's original notebook](https://github.com/mitmath/18S191/blob/Fall20/lecture_notebooks/week11/01_energy_balance_model.jl) where he describes the Energy Balance Model.
"""

# ╔═╡ 340fc7c4-128f-4476-b445-65005ffa9f5a
md"""
### Pre - Computational Thinking
(traditional ode "analytic" solutions)
"""

# ╔═╡ 7673c7b7-0921-4a7e-ae4d-e785c6391a0c
md"""
Notation: 

``y=y(t)`` is a function of time $t$ 

Inititally $t=0$, $y(0)=y_0$

We write ``y'`` for ``dy/dt``.
"""

# ╔═╡ ebfeb0b0-d29e-4244-a0e3-a7185f3c8124
md"""
---
#### ``y'=`` constant:


``y' = a``
$(html"<br>") Solution: ``y(t) = at + y_0``

---
"""

# ╔═╡ 4bf60f27-8db5-42c1-83d8-750bec2060e5
md"""

#### ``y'=`` linear in y:



``y' = a - by``
$(html"<br>") Solution: ``y(t) =(- \frac{a}{b})(e^{-bt}-1) + y_0 e^{-bt}``

Comment:  Equilibrium obtained  (if $b\ne0$)  by solving y'=0 for y giving equilibrium $y=a/b$. Also
can be obtained by letting $t\rightarrow \infty$ in the solution killing the exponential terms.

---
"""

# ╔═╡ e2799d05-36a7-4547-8663-90708ce01ce8
md"""
#### ``y'=`` linear in y + "forcing term" in t:


``y' = a - by + f(t)``
$(html"<br>")
Solution: ``y(t) = e^{-bt} \left( y_0 + \int_0^t  e^{bu}(a+f(u)) du \right)``

---
"""

# ╔═╡ 4d58018b-752c-43f8-aafb-f11a95ca1874
md"""
### Computational Thinking
"""

# ╔═╡ 279b4748-829f-44a3-94da-da3abf32ff13
md"""
#### Review: Solving an ODE (y'=f(y)) in Julia:

0. Define f(y,p,t)
1. ODEProblem(  f, f(0), time_span, parameters)
2. solve
3. plot etc
"""

# ╔═╡ c1d87c42-e1e0-4e52-8023-6cc176266e86
f(y,(a, b, forcing(c)),t) = a - b*y + forcing(c)(t)

# ╔═╡ adb59adc-b30a-4dc4-bc3f-2804b7e02876
forcing(c)  =  t->c*t

# ╔═╡ 7bee45a5-fa62-455b-813a-3e5dcf430289
md"""
a = $(@bind a Slider(0:.01:10, show_value=true, default=0) )

b = $(@bind b Slider(0:.1:5, show_value=true, default=0) )

y₀ = $(@bind y₀ Slider(-5:.1:15, show_value=true, default=2.0) )

c = $(@bind c Slider(0:.1:5, show_value=true, default=0.0) )
"""

# ╔═╡ 578a80ad-fcf1-4d5c-81e5-205113bbf78d
sol = solve(  ODEProblem( f, y₀, (0, 10.0), (a, b, forcing(c)) ) );

# ╔═╡ 220420c1-e8cc-4ff6-8b79-ba2ec49c7695
y₀

# ╔═╡ bda41881-75c7-4732-9a66-d7947607b1b6
begin
	p = plot( sol , legend=false, background_color_inside=:black , ylims=(0, 10), lw=3, c=:red)
	# plot direction field:
		xs = Float64[]
		ys = Float64[]
		
	    lrx = LinRange( xlims(p)..., 30)
		for x in  lrx
			for y in LinRange( ylims(p)..., 30)
				v = [1, a - b*y + forcing(c)(x) ]
				v ./=  (20* (lrx[2]-lrx[1]))
				# plot!([x, x + v[1]], [y, y + v[2]], alpha=0.5, c=:gray)
				
				push!(xs, x - v[1], x + v[1], NaN)
				push!(ys, y - v[2], y + v[2], NaN)
			
			end
		end
		hline!( [b==0 ? 0 : a/b],c=:white,ls=:dash)
		plot!(xs, ys, alpha=0.7, c=:yellow)
	    ylabel!("y")
	    annotate!(-.5,y₀,text("y₀",color=:red))
	    title!("Solution to y'(t) = a - by + forcing(c)(t)")
end

# ╔═╡ aba7fc93-c0ac-4c9e-b975-18145f87707f
md"""#### 1) Background: climate physics

The simplest climate model can be conceptualized as:
\begin{align}
\text{\color{brown}{change in heat content}} = & + \text{\color{orange}{absorbed solar radiation (energy from the Sun's rays)}} \newline
& - \text{\color{blue}{outgoing thermal radiation (i.e. blackbody cooling to space)}}
\newline
& + \text{\color{grey}{human-caused greenhouse effect (trapped outgoing radiation)}}
\end{align}

where each of these is interpreted as an average over the entire globe (hence "zero-dimensional").
"""

# ╔═╡ b9eca29e-9028-4fd7-8c62-718a2dcf87d1
html"""<img src="https://raw.githubusercontent.com/hdrake/hdrake.github.io/master/figures/planetary_energy_balance.png" height=225>"""

# ╔═╡ dabca25c-e34b-4aed-8729-132d03c5bb45
md"""
### 1.1 Incoming 🌞: Absorbed solar radiation
(an example of $\mathrm{temp}$'=constant)
"""

# ╔═╡ 5123525a-3437-4b76-813c-8ad6b158f7f2
md"""
##### (Heating the earth nonstop)
"""

# ╔═╡ 087f47b2-8283-4205-88f2-4d5883a340c2
md"""


At Earth's orbital distance from the Sun, the power of the Sun's rays that intercept the Earth is equal to
"""

# ╔═╡ 9c89c4e9-65ee-4424-bd74-17168b211797
S = 1368; # solar insolation [W/m^2]  (energy per unit time per unit area)

# ╔═╡ ca5b41d2-b511-486a-91fe-cceb8f7282c3
md"A small fraction"

# ╔═╡ 13984c61-4c34-40db-9043-fcff2721522e
α = 0.3; # albedo, or planetary reflectivity [unitless]

# ╔═╡ d74936e9-b760-4add-b3e7-46d544064c16
md"""
In math we just write down a differential equation, but in the physical world there are physical variables to identify.

In our baking the earth example, we will identify the following quantities:

- Industrial Revolution Start: 1850
- Avg Temperature in 1850: 14.0 °C

- Solar Insolation $S=$1368 W/m^2:  energy from the sun

- Albedo or plentary reflectivity: α = 0.3

- atmosphere and upper-ocean heat capacity: C= 51  J/m^2/°C 

Earth Baking Formula:
$(html"<br>")
 `` C\  \mathrm{temp}'(t) = S(1-α)/4 = `` $(S*(1-α)/4)
"""

# ╔═╡ 868e19f4-d71e-4222-9bdd-470387991c67
md"""
of this incoming solar radiation is reflected back out to space (by reflective surfaces like white clouds, snow, and ice), with the remaining fraction $(1-\alpha)$ being absorbed.

Since the incoming solar rays are all approximately parallel this far from the Sun, the cross-sectional area of the Earth that intercepts them is just a disc of area $\pi R^{2}$. Since all of the other terms we will consider act on the entire surface area $4\pi R^{2}$ of the spherical Earth, the absorbed solar radiation *per unit surface area* (averaged over the entire globe) is reduced by a factor of 4.

![](https://www.open.edu/openlearn/ocw/pluginfile.php/101161/mod_oucontent/oucontent/890/639dcd57/ce3f1c3a/s250_3_002i.jpg)

The absorbed solar radiation per unit area is thus

$\textcolor{orange}{\text{absorbed solar radiation} \equiv \frac{S(1-\alpha)}{4}}$
"""

# ╔═╡ 0e4dedc5-0b1e-4e46-b943-284bfb2de57f
absorbed_solar_radiation = S*(1 - α)/4; # [W/m^2]

# ╔═╡ 91329865-f593-4388-a5d0-01af4be6e01d
begin
	C = 51.; # atmosphere and upper-ocean heat capacity [J/m^2/°C]
	temp₀ = 14.0 # preindustrial temperature [°C]
end

# ╔═╡ 7187ae25-239d-4752-898e-6674009b5de6
 p1 = ODEProblem( (temp, p, t)-> (1/C) * absorbed_solar_radiation, temp₀,  (0.0, 170) )

# ╔═╡ 2f19cbac-4f13-4c2b-9b11-fb92e8055527
begin
	plot(solve(p1),       legend = false, 
		 background_color_inside = :black,
		                  xlabel = "years from $(1850)",
	                      ylabel = "Temperature °C")
	hline!( [temp₀,temp₀] ,c=:white,ls=:dash)
	annotate!( 80, 25+temp₀, text("Preindustrial Temperature = $(temp₀)°C",color=:white))
	title!("Absorbing Solar Radiation (only)")
end

# ╔═╡ ad1e294e-ad8a-48f9-b924-2474cce16aaf
md"""The heat content $C temp$ is determined by the temperature $temp$ (in Kelvin) and the heat capacity of the climate system. While we are interested in the temperature of the atmosphere, which has a very small heat capacity, its heat is closely coupled with that of the upper ocean, which has a much larger heat capacity of 
"""

# ╔═╡ 2086e386-194b-4863-a9ee-178002925d42
md"""
The *change in heat content over time* is thus simply given by $\frac{d(CT)}{dt}$. Since the heat capacity of sea water hardly changes with temperature, we can rewrite this in terms of the change in temperature with time as:

$\color{brown}{\text{change in heat content } =\; C \frac{dtemp}{dt}}$
"""

# ╔═╡ 2b66ffaf-a9a3-4ca2-a6e9-732912c9d48e
md"""
### 1.2 Outgoing ♨ : thermal radiation
"""

# ╔═╡ b186d026-d02c-4f06-8097-aa54b363f4fb
md"""

The outgoing thermal radiation term $\mathcal{G}(T)$ (or "blackbody cooling to space") represents the combined effects of *negative feedbacks that dampen warming*, such as **blackbody radiation**, and *positive feedbacks that amplify warming*, such as the **water vapor feedback**.

Since these physics are too complicated to deal with here, we *linearize* the model
combining the incoming and the outgoing.  

We assume that the preindustrial world was in energy balance, and thus
the equilibrium temperature is the preindustrial temperature.


Thus we assume

 temp'($t$) = $B$(temp($0$)-temp($t$))  for some value of $B$.
The minus sign in front of temp(t) indicating it restores equilibrium.
"""

# ╔═╡ edafca88-dd4a-4fe4-8ffc-bb50f7bd561d
md"""
The value that has been chosen is
"""

# ╔═╡ 9b97e41b-76ff-4cc2-90c1-446d59c4ece7
B = 1.3; # climate feedback parameter [W/m^2/°C],

# ╔═╡ af893e1e-3bd7-4d05-83b6-f5f7e751b5e3
md"""
start\_temp = $(@bind start_temp Slider(0:28; show_value=true, default=14))
"""

# ╔═╡ 333290b0-0198-4306-b19b-6d30df79a280
p2 = ODEProblem( (temp, p, t)-> (1/C) * B*(temp₀-temp), start_temp,  (0.0, 170) )

# ╔═╡ eeaf3735-5139-4924-9fce-14df51a61042
begin
	plot(solve(p2),       legend = false, 
		 background_color_inside = :black,
		                  xlabel = "years from start",
	                      ylabel = "Temperature °C",
	                      ylim = (0, 30))
	hline!( [temp₀,temp₀] ,c=:white,ls=:dash)
	annotate!( 80, temp₀, text("Preindustrial Temperature = $(temp₀)°C",:bottom,color=:white))
	title!("Energy Balance Model (Healthy Earth)")
end

# ╔═╡ 20d6c513-2ca6-4dea-9092-156e2805d467
md"""
### 1.3 Greenhouse 🏭: Human-caused greenhouse effect

Empirically, the greenhouse effect is known to be a logarithmic function of gaseous carbon dioxide (CO₂) concentrations

$\color{grey}{\text{human-caused greenhouse effect}\; = {\mbox {(forcing\_coef)}} \ln \left( \frac{[\text{CO}₂]}{[\text{CO}₂]_{\text{PreIndust}}} \right),}$

How this depends on time into the future depends on human behavior!
Time is not modelled in the above equation.
"""

# ╔═╡ 692a6928-c7a2-4b61-a794-16bef5d4e919
md"where"

# ╔═╡ 6d1058bf-8a05-4b8e-835a-de9e95f567c4
forcing_coef = 5.0; # CO2 forcing coefficient [W/m^2]

# ╔═╡ 35184e6f-ac3e-480b-92e9-ed8baaaa833b
CO₂_PreIndust = 280.; # preindustrial CO2 concentration [parts per million; ppm];

# ╔═╡ 437faadd-0301-403a-bcd7-18ce279589d0
greenhouse_effect(CO₂) = forcing_coef * log(CO₂/CO₂_PreIndust)

# ╔═╡ ee6414b7-e92d-4055-af17-6b02f05c28cd
begin
	CO2_present = 420.
	CO2_range = 280*(2 .^(range(-1, stop=3,length=100)))
	plot(CO2_range, greenhouse_effect.(CO2_range), lw=2.5, label=nothing, color=:black)
	plot!([CO₂_PreIndust], [greenhouse_effect(CO₂_PreIndust)], marker=:., ms=6, linecolor=:white,
		color=:blue, lw=0, label="pre-industrial (PI)")
	plot!([CO2_present], [greenhouse_effect(CO2_present)], marker=:., ms=6, color=:red, linecolor=:white, lw=0, label="present day (2020)")
	plot!(xticks=[280, 280*2, 280*4, 280*8], legend=:bottomright, size=(400, 250))
	plot!(ylabel="Radiative forcing [W/m²]", xlabel="CO₂ concentration [ppm]")
end

# ╔═╡ fac5012a-960c-473c-bbf0-62c0be87f608
begin
	 # CO₂(t) = CO₂_PreIndust # no emissions
	 # CO₂(t) = CO₂_PreIndust * 1.01^t # test model
	 CO₂(t) = CO₂_PreIndust * (1+ (t/220)^3 ) 
end

# ╔═╡ 1a4d21bd-85ad-4935-913a-8992a8996db4
greenhouse_effect(CO₂(15))

# ╔═╡ 99629ec2-dc70-4253-b191-305bccc9f36b
p3 = ODEProblem( (temp, p, t)-> (1/C) * ( B*(temp₀-temp)  + greenhouse_effect(CO₂(t))    ) , start_temp,  (0.0, 170) )

# ╔═╡ 6b2beeec-6383-42b3-b694-8d77b961c8a1
begin
	plot(solve(p3),       legend = false, 
		 background_color_inside = :black,
		                  xlabel = "years from 1850",
	                      ylabel = "Temperature °C",
	                      ylim = (10, 20))
	hline!( [temp₀,temp₀] ,c=:white,ls=:dash)
	annotate!( 80, temp₀, text("Preindustrial Temperature = $(temp₀)°C",:bottom,color=:white))
	title!("Model with CO₂")
end

# ╔═╡ 0b24f105-0166-4a41-97aa-156417d7203a
begin
	years = 1850:2020
	plot( years, CO₂.(years.-1850), lw=3, legend=false)
end

# ╔═╡ c6f8dcf6-950d-48ff-b040-55bdd347d74b
md"""
### Observations from Mauna Loa Volcano ![Mauna Loa Volcano](https://i.pinimg.com/originals/df/1a/e7/df1ae72cfd5e6d0d535c0ec99e708f6f.jpg)
"""

# ╔═╡ cd1dcbc4-2273-4eda-85d9-9af4fd71b3c1
md"""
information is available at
[https://www.ncei.noaa.gov/pub/data/paleo/icecore/antarctica/law/law2006.txt]
(https://www.ncei.noaa.gov/pub/data/paleo/icecore/antarctica/law/law2006.txt).
"""

# ╔═╡ c3b0b7fc-19be-4f04-8787-6349ab9bff7f
begin
	CO2_historical_data_url = "https://scrippsco2.ucsd.edu/assets/data/atmospheric/stations/in_situ_co2/monthly/monthly_in_situ_co2_mlo.csv"
	
	CO2_historical_data = CSV.read(download(CO2_historical_data_url), DataFrame, header=4, datarow=7, );

	first(CO2_historical_data, 11)
end

# ╔═╡ f5c2d0de-f5d2-43f2-bfca-41bd727b3ca9
md"""
Data is in the fifth column CO₂
"""

# ╔═╡ ef9d9512-cb40-4641-9d6a-5a36f5a4b33d
md"""
Oh no, missing data (-99.99)
"""

# ╔═╡ 2bc4c596-b313-49f6-84b5-5d53f2baf0e9
validrowsmask = CO2_historical_data[:, "     CO2"] .> 0

# ╔═╡ 648dfce3-5363-4539-8f41-f5d27bae4c6f
begin
	begin
		plot( CO2_historical_data[validrowsmask, "      Date"] , CO2_historical_data[validrowsmask, "     CO2"], label="Mauna Loa CO₂ data (Keeling curve)")
		plot!( years, CO₂.(years.-1850), lw=3 , label="Cubic Fit", legend=:topleft)
		xlabel!("year")
		ylabel!("CO₂ (ppm)")
		title!("CO₂ observations and fit")
		
	end
end

# ╔═╡ 288bfc6b-6848-40d5-916b-95a8a4248a4f
md"""
We will use this fit to compare against historical temperatures.
"""

# ╔═╡ 3304174c-289d-47c5-b5ef-161b11e515eb
md"""
Climate feedback BB = $(@bind BB Slider(0:.1:4, show_value=true, default=B))

Ocean Heat Capacity CC =$(@bind CC Slider(10:.1:200, show_value=true, default=C))
"""

# ╔═╡ 13269c86-06a4-4354-b620-bdf3f6432294
p4 = ODEProblem( (temp, p, t)-> (1/CC) * ( BB*(temp₀-temp)  + greenhouse_effect(CO₂(t))    ) , start_temp,  (0.0, 170) )

# ╔═╡ 28acb5a4-2a5f-49c5-9c78-deb40fdeed36
md""" #####  Best- and worst-case projections of future global warming

"""

# ╔═╡ 13b003d2-1fd4-4a4a-960c-4a1d9b673dc6
md"""Consider two divergent hypothetical futures:
1. a **low-emissions** world in which emissions decrease such that CO2 concentrations stay below 500 ppm by 2100 (known in climate circles as "RCP8.5") and
2. a **high-emissions** world in which emissions continue increasing and CO2 concentrations soar upwards of 1200 ppm ("RCP2.6").
"""

# ╔═╡ a2288816-3621-4871-9faf-3e9c78674969
md"""
![](https://raw.githubusercontent.com/mitmath/18S191/Spring21/notebooks/week12/predictthefuture.svg)
"""

# ╔═╡ 2b9c3427-c3ec-41ba-b3c5-268cf3dddccf
md"""
In the low-emissions scenario, the temperature increase stays below $ΔT = 2$ °C by 2100, while in the high-emissions scenario temperatures soar upwards of 3.5ºC above pre-industrial levels.
"""

# ╔═╡ fef0a76b-98dc-42a0-975b-0fba8a32e5cc
md"Although the greenhouse effect due to human-caused CO₂ emissions is the dominant forcing behind historical and future-projected warming, modern climate modelling considers a fairly exhaustive list of other forcing factors (aerosols, other greenhouse gases, ozone, land-use changes, etc.). The video below shows a breakdown of these forcing factors in a state-of-the-art climate model simulation of the historical period."

# ╔═╡ 2368f16c-9805-4dd6-a130-d831211f6155
html"""
<iframe width="700" height="394" src="https://www.youtube-nocookie.com/embed/E7kMr2OYKSU" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""


# ╔═╡ 6800c94d-e7f3-43a8-a823-1c550cb8fc95
solp4 = solve(p4)

# ╔═╡ b38727a9-72ff-499f-9751-ddfeee21959c
begin
	T_url = "https://data.giss.nasa.gov/gistemp/graphs/graph_data/Global_Mean_Estimates_based_on_Land_and_Ocean_Data/graph.txt";
	T_df = CSV.read(download(T_url),DataFrame, header=false, datarow=6,delim="     ");
    # T_df = T_df[:,[1,6]]
	
end

# ╔═╡ a62ca8d1-321a-435e-a9df-f63d000376c7
begin
	plot(years,solp4.(years.-1850),lw=2,label="Predicted Temperature from model", legend=:topleft)
	xlabel!("year")
	ylabel!("Temp °C")
	
	plot!( parse.(Float64, T_df[:,1]), parse.(Float64, T_df[:,2]) .+ 14.15, color=:black, label="NASA Observations", legend=:topleft)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CSV = "~0.9.2"
DataFrames = "~1.2.2"
DifferentialEquations = "~6.19.0"
Plots = "~1.21.3"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[ArrayInterface]]
deps = ["IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "d84c956c4c0548b4caf0e4e96cf5b6494b5b1529"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.1.32"

[[ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "854b55021712979cb5fc6cba7be2ce358651bbea"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "0.7.4"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "ce68f8c2162062733f9b4c9e3700d5efc4a8ec47"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.16.11"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "652aab0fc0d6d4db4cc726425cadf700e9f473f1"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.0"

[[BoundaryValueDiffEq]]
deps = ["BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NLsolve", "Reexport", "SparseArrays"]
git-tree-sha1 = "fe34902ac0c3a35d016617ab7032742865756d7d"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "2.7.1"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[CPUSummary]]
deps = ["Hwloc", "IfElse", "Static"]
git-tree-sha1 = "ed720e2622820bf584d4ad90e6fcb93d95170b44"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.3"

[[CSTParser]]
deps = ["Tokenize"]
git-tree-sha1 = "b2667530e42347b10c10ba6623cfebc09ac5c7b6"
uuid = "00ebfdb7-1f24-5e51-bd34-a7502290713f"
version = "3.2.4"

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "b8ea652d5c3932a473cf984614e5d826b209df8c"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.9.2"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4ce9393e871aca86cc457d9f66976c3da6902ea7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.4.0"

[[CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "ce9c0d07ed6e1a4fecd2df6ace144cbd29ba6f37"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.2"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonMark]]
deps = ["Crayons", "JSON", "URIs"]
git-tree-sha1 = "1060c5023d2ac8210c73078cb7c0c567101d201c"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.2"

[[CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "4866e381721b30fac8dda4c8cb1d9db45c8d2994"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.37.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[CompositeTypes]]
git-tree-sha1 = "d5b014b216dc891e81fea299638e4c10c657b582"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.2"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DEDataArrays]]
deps = ["ArrayInterface", "DocStringExtensions", "LinearAlgebra", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "31186e61936fbbccb41d809ad4338c9f7addf7ae"
uuid = "754358af-613d-5f8d-9788-280bf1605d4c"
version = "0.2.0"

[[DataAPI]]
git-tree-sha1 = "bec2532f8adb82005476c141ec23e921fc20971b"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.8.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "UnPack"]
git-tree-sha1 = "6eba402e968317b834c28cd47499dd1b572dd093"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.31.1"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DiffEqBase]]
deps = ["ArrayInterface", "ChainRulesCore", "DEDataArrays", "DataStructures", "Distributions", "DocStringExtensions", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "IterativeSolvers", "LabelledArrays", "LinearAlgebra", "Logging", "MuladdMacro", "NonlinearSolve", "Parameters", "PreallocationTools", "Printf", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "StaticArrays", "Statistics", "SuiteSparse", "ZygoteRules"]
git-tree-sha1 = "420ad175d5e420e2c55a0ed8a9c18556e6735f80"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.73.2"

[[DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "LinearAlgebra", "NLsolve", "OrdinaryDiffEq", "Parameters", "RecipesBase", "RecursiveArrayTools", "StaticArrays"]
git-tree-sha1 = "35bc7f8be9dd2155336fe999b11a8f5e44c0d602"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.17.0"

[[DiffEqFinancial]]
deps = ["DiffEqBase", "DiffEqNoiseProcess", "LinearAlgebra", "Markdown", "RandomNumbers"]
git-tree-sha1 = "db08e0def560f204167c58fd0637298e13f58f73"
uuid = "5a0ffddc-d203-54b0-88ba-2c03c0fc2e67"
version = "2.4.0"

[[DiffEqJump]]
deps = ["ArrayInterface", "Compat", "DataStructures", "DiffEqBase", "FunctionWrappers", "LightGraphs", "LinearAlgebra", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "99a65172d95e5ccc016c9be0542fa3858cf97a18"
uuid = "c894b116-72e5-5b58-be3c-e6d8d4ac2b12"
version = "7.3.0"

[[DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "LinearAlgebra", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "Requires", "ResettableStacks", "SciMLBase", "StaticArrays", "Statistics"]
git-tree-sha1 = "d6839a44a268c69ef0ed927b22a6f43c8a4c2e73"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.9.0"

[[DiffEqPhysics]]
deps = ["DiffEqBase", "DiffEqCallbacks", "ForwardDiff", "LinearAlgebra", "Printf", "Random", "RecipesBase", "RecursiveArrayTools", "Reexport", "StaticArrays"]
git-tree-sha1 = "8f23c6f36f6a6eb2cbd6950e28ec7c4b99d0e4c9"
uuid = "055956cb-9e8b-5191-98cc-73ae4a59e68a"
version = "3.9.0"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "3ed8fa7178a10d1cd0f1ca524f249ba6937490c0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.0"

[[DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqFinancial", "DiffEqJump", "DiffEqNoiseProcess", "DiffEqPhysics", "DimensionalPlotRecipes", "LinearAlgebra", "MultiScaleArrays", "OrdinaryDiffEq", "ParameterizedFunctions", "Random", "RecursiveArrayTools", "Reexport", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "ff7138ae7fa684eb91753e772d4e4c2db83503ad"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "6.19.0"

[[DimensionalPlotRecipes]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "af883a26bbe6e3f5f778cb4e1b81578b534c32a6"
uuid = "c619ae07-58cd-5f6d-b883-8f17bd6a98f9"
version = "1.2.0"

[[Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "9f46deb4d4ee4494ffb5a40a27a2aced67bdd838"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.4"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["ChainRulesCore", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "f4efaa4b5157e0cdb8283ae0b5428bc9208436ed"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.16"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "StaticArrays", "Statistics"]
git-tree-sha1 = "2655d0dd8bec4e01cbe903e5faa4617de40be779"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.5.5"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[DynamicPolynomials]]
deps = ["DataStructures", "Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "05b68e727a192783be0b34bd8fee8f678505c0bf"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.3.20"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "8041575f021cba5a099a456b4163c9a08b566a02"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[ExponentialUtilities]]
deps = ["ArrayInterface", "LinearAlgebra", "Printf", "Requires", "SparseArrays"]
git-tree-sha1 = "7a541ee92e2f8b16356ed6066d0c44b85984b780"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.9.0"

[[ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

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

[[FastBroadcast]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "26be48918640ce002f5833e8fc537b2ba7ed0234"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.1.8"

[[FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[FilePathsBase]]
deps = ["Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "0f5e8d0cb91a6386ba47bd1527b240bd5725fbae"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.10"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "caf289224e622f518c9dbfe832cdafa17d7c80a6"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.4"

[[FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "8b3c09b56acaf3c0e581c66638b85c8650ee9dca"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.8.1"

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

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "NaNMath", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "b5e930ac60b613ef3406da6d4f42c35d8dc51419"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.19"

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

[[FunctionWrappers]]
git-tree-sha1 = "241552bc2209f0fa068b6415b1942cc0aa486bcc"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "ef49a187604f865f4708c90e3f431890724e9012"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.59.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

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
git-tree-sha1 = "60ed5f1643927479f845b0135bb369b031b541fa"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.14"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "8a954fed8ac097d5be04921d595f741115c1b2ad"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+0"

[[HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "3169c8b31863f9a409be1d17693751314241e3eb"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.4"

[[Hwloc]]
deps = ["Hwloc_jll"]
git-tree-sha1 = "92d99146066c5c6888d5a3abc871e6a214388b91"
uuid = "0e44f5e4-bd66-52a0-8798-143a42290a1d"
version = "2.0.0"

[[Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3395d4d4aeb3c9d31f5929d32760d8baeee88aaf"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.5.0+0"

[[IfElse]]
git-tree-sha1 = "28e837ff3e7a6c3cdb252ce49fb412c8eb3caeef"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.0"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1a8c6237e78b714e901e406c096fc8a65528af7d"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.1"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[JuliaFormatter]]
deps = ["CSTParser", "CommonMark", "DataStructures", "Pkg", "Tokenize"]
git-tree-sha1 = "10c95cebcfa37c1f510a726c90886db4745e1238"
uuid = "98e50ef6-434e-11e9-1051-2b60c6c9e899"
version = "0.15.11"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[LabelledArrays]]
deps = ["ArrayInterface", "LinearAlgebra", "MacroTools", "StaticArrays"]
git-tree-sha1 = "bdde43e002847c34c206735b1cf860bc3abd35e7"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.6.4"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "d2bda6aa0b03ce6f141a2dc73d0bcb7070131adc"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.3"

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
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

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
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LightGraphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "432428df5f360964040ed60418dd5601ecd240b6"
uuid = "093fc24a-ae57-5d10-9952-331d41423f4d"
version = "1.3.5"

[[LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "34dc30f868e368f8a17b728a1238f3fcda43931a"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.3"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "Requires", "SLEEFPirates", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "d469fcf148475a74c221f14d42ee75da7ccb3b4e"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.73"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[ManualMemory]]
git-tree-sha1 = "9cb207b18148b2199db259adfa923b45593fe08e"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.6"

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

[[ModelingToolkit]]
deps = ["AbstractTrees", "ArrayInterface", "ConstructionBase", "DataStructures", "DiffEqBase", "DiffEqCallbacks", "DiffEqJump", "DiffRules", "Distributed", "Distributions", "DocStringExtensions", "DomainSets", "IfElse", "InteractiveUtils", "JuliaFormatter", "LabelledArrays", "Latexify", "Libdl", "LightGraphs", "LinearAlgebra", "MacroTools", "NaNMath", "NonlinearSolve", "RecursiveArrayTools", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SafeTestsets", "SciMLBase", "Serialization", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "Symbolics", "UnPack", "Unitful"]
git-tree-sha1 = "dc7a9cb1ca34c058789c5c6de0ed378ce795cd26"
uuid = "961ee093-0014-501f-94e3-6117800e7a78"
version = "6.4.9"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MuladdMacro]]
git-tree-sha1 = "c6190f9a7fc5d9d5915ab29f2134421b12d24a68"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.2"

[[MultiScaleArrays]]
deps = ["DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "SparseDiffTools", "Statistics", "StochasticDiffEq", "TreeViews"]
git-tree-sha1 = "258f3be6770fe77be8870727ba9803e236c685b8"
uuid = "f9640e96-87f6-5992-9c3b-0743c6a49ffa"
version = "1.8.1"

[[MultivariatePolynomials]]
deps = ["DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "45c9940cec79dedcdccc73cc6dd09ea8b8ab142c"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.3.18"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "3927848ccebcc165952dc0d9ac9aa274a87bfe01"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.2.20"

[[NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "144bab5b1443545bc4e791536c9f1eacb4eed06a"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.1"

[[NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[NonlinearSolve]]
deps = ["ArrayInterface", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "35585534c0c79c161241f2e65e759a11a79d25d0"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.10"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "c870a0d713b51e4b49be6432eff0e26a4325afee"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.6"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Optim]]
deps = ["Compat", "FillArrays", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "7863df65dbb2a0fa8f85fcaf0a41167640d2ebed"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.4.1"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[OrdinaryDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastClosures", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "Polyester", "RecursiveArrayTools", "Reexport", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "1d4744d7f1af67394c90b338e573000cc76802a1"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "5.63.5"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4dd403333bcf0909341cfe57ec115152f937d7d8"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.1"

[[ParameterizedFunctions]]
deps = ["DataStructures", "DiffEqBase", "DocStringExtensions", "Latexify", "LinearAlgebra", "ModelingToolkit", "Reexport", "SciMLBase"]
git-tree-sha1 = "c2d9813bdcf47302a742a1f5956d7de274acec12"
uuid = "65888b18-ceab-5e60-b2b9-181511a3b968"
version = "5.12.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "2276ac65f1e236e0a6ea70baff3f62ad4c625345"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "2537ed3c0ed5e03896927187f5f2ee6a4ab342db"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.14"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "2dbafeadadcf7dadff20cd60046bba416b4912be"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.21.3"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[PoissonRandom]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "44d018211a56626288b5d3f8c6497d28c26dc850"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.0"

[[Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "21d8a7163d0f3972ade36ca2b5a0e8a27ac96842"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.4.4"

[[PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "371a19bb801c1b420b29141750f3a34d6c6634b9"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.0"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a193d6ad9c45ada72c14b731a318bedd3c2f00cf"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.3.0"

[[PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[PreallocationTools]]
deps = ["ArrayInterface", "ForwardDiff", "LabelledArrays"]
git-tree-sha1 = "9e917b108c4aaf47e8606542325bd2ccbcac7ca4"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.1.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "0d1245a357cc61c8cd61934c07447aa569ff22e6"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.1.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "12fbe86da16df6679be7521dfb39fbc861e1dc7b"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Random123]]
deps = ["Libdl", "Random", "RandomNumbers"]
git-tree-sha1 = "0e8b146557ad1c6deb1367655e052276690e71a3"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.4.2"

[[RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "d4491becdc53580c6dadb0f6249f90caae888554"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.0"

[[RecursiveArrayTools]]
deps = ["ArrayInterface", "ChainRulesCore", "DocStringExtensions", "LinearAlgebra", "RecipesBase", "Requires", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "00bede2eb099dcc1ddc3f9ec02180c326b420ee2"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.17.2"

[[RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "575c18c6b00ce409f75d96fefe33ebe01575457a"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.4"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

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

[[RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "cdc1e4278e91a6ad530770ebb327f9ed83cf10c4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "947491c30d4293bebb00781bcaf787ba09e7c20d"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.26"

[[SafeTestsets]]
deps = ["Test"]
git-tree-sha1 = "36ebc5622c82eb9324005cc75e7e2cc51181d181"
uuid = "1bc83da4-3b8d-516f-aca4-4fe02f6d838f"
version = "0.0.1"

[[SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "ff686e0c79dbe91767f4c1e44257621a5455b1c6"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.18.7"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "54f37736d8934a12a200edea2f9206b03bdf3159"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.7"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "fca29e68c5062722b5b4435594c3d1ba557072a3"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.7.1"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

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

[[SparseDiffTools]]
deps = ["Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "LightGraphs", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays", "VertexSafeGraphs"]
git-tree-sha1 = "aebcead0644d3b3396c205a09544590b5115e282"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "1.16.4"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "LogExpFunctions", "OpenSpecFun_jll"]
git-tree-sha1 = "a322a9493e49c5f3a10b50df3aedaf1cdb3244b7"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.6.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "a8f30abc7c64a39d389680b74e749cf33f872a70"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.3.3"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StatsFuns]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "46d7ccc7104860c38b11966dd1f72ff042f382e4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.10"

[[SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "3df66a4a9ba477bea5cb10a3ec732bb48a2fc27d"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.6.4"

[[StochasticDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqJump", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "d9e996e95ad3c601c24d81245a7550cebcfedf85"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.36.0"

[[StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "Requires", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "1258e25e171aec339866f283a11e7d75867e77d7"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.2.4"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "f41020e84127781af49fc12b7e92becd7f5dd0ba"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.2"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"

[[Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "Reexport", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "75412a0ce4cd7995d7445ba958dd11de03fd2ce5"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.5.3"

[[Sundials_jll]]
deps = ["CompilerSupportLibraries_jll", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "013ff4504fc1d475aa80c63b455b6b3a58767db2"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.0+1"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[SymbolicUtils]]
deps = ["AbstractTrees", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "TimerOutputs"]
git-tree-sha1 = "fa130d01c5dd144a6b65b020c3c69b1fe30170c2"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "0.13.5"

[[Symbolics]]
deps = ["ConstructionBase", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "IfElse", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "NaNMath", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TreeViews"]
git-tree-sha1 = "0ff0a04728a34497a3cc1f28f5c2d94328a86855"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "3.2.3"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "1162ce4a6c4b7e31e0e6b14486a6986951c73be9"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.2"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "03013c6ae7f1824131b2ae2fc1d49793b51e8394"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.4.6"

[[TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "209a8326c4f955e2442c07b56029e88bb48299c7"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.12"

[[Tokenize]]
git-tree-sha1 = "0952c9cee34988092d73a5708780b3917166a0dd"
uuid = "0796e94c-ce3b-5d07-9a54-7f471281c624"
version = "0.5.21"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "1eed054a58d9332adc731103fe47dad2ad1a0adf"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.5"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "a981a8ef8714cba2fd9780b22fd7a469e7aaf56d"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.9.0"

[[VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "Hwloc", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "43c605e008ac67adb672ef08721d4720dfe2ad41"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.7"

[[VertexSafeGraphs]]
deps = ["LightGraphs"]
git-tree-sha1 = "b9b450c99a3ca1cc1c6836f560d8d887bcbe356e"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.1.2"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[WeakRefStrings]]
deps = ["DataAPI", "Parsers"]
git-tree-sha1 = "4a4cfb1ae5f26202db4f0320ac9344b3372136b0"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.3.0"

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
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "9e7a1e8ca60b742e508a315c17eef5211e7fbfd7"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.1"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

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
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

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
# ╟─42085492-ac8c-11eb-0620-adcb307077f1
# ╠═c7d387fa-cd19-458c-a45d-7893e8c21bbf
# ╟─14195fc4-40e1-4576-973a-69d649fddc02
# ╟─92883ed9-5572-41fd-96c7-190279f90804
# ╟─340fc7c4-128f-4476-b445-65005ffa9f5a
# ╟─7673c7b7-0921-4a7e-ae4d-e785c6391a0c
# ╟─ebfeb0b0-d29e-4244-a0e3-a7185f3c8124
# ╟─4bf60f27-8db5-42c1-83d8-750bec2060e5
# ╟─e2799d05-36a7-4547-8663-90708ce01ce8
# ╟─4d58018b-752c-43f8-aafb-f11a95ca1874
# ╟─279b4748-829f-44a3-94da-da3abf32ff13
# ╠═578a80ad-fcf1-4d5c-81e5-205113bbf78d
# ╠═c1d87c42-e1e0-4e52-8023-6cc176266e86
# ╠═adb59adc-b30a-4dc4-bc3f-2804b7e02876
# ╠═220420c1-e8cc-4ff6-8b79-ba2ec49c7695
# ╟─7bee45a5-fa62-455b-813a-3e5dcf430289
# ╟─bda41881-75c7-4732-9a66-d7947607b1b6
# ╟─aba7fc93-c0ac-4c9e-b975-18145f87707f
# ╟─b9eca29e-9028-4fd7-8c62-718a2dcf87d1
# ╟─dabca25c-e34b-4aed-8729-132d03c5bb45
# ╟─d74936e9-b760-4add-b3e7-46d544064c16
# ╟─5123525a-3437-4b76-813c-8ad6b158f7f2
# ╠═2f19cbac-4f13-4c2b-9b11-fb92e8055527
# ╟─087f47b2-8283-4205-88f2-4d5883a340c2
# ╠═9c89c4e9-65ee-4424-bd74-17168b211797
# ╟─ca5b41d2-b511-486a-91fe-cceb8f7282c3
# ╠═13984c61-4c34-40db-9043-fcff2721522e
# ╟─868e19f4-d71e-4222-9bdd-470387991c67
# ╠═0e4dedc5-0b1e-4e46-b943-284bfb2de57f
# ╠═91329865-f593-4388-a5d0-01af4be6e01d
# ╠═7187ae25-239d-4752-898e-6674009b5de6
# ╟─ad1e294e-ad8a-48f9-b924-2474cce16aaf
# ╟─2086e386-194b-4863-a9ee-178002925d42
# ╟─2b66ffaf-a9a3-4ca2-a6e9-732912c9d48e
# ╟─b186d026-d02c-4f06-8097-aa54b363f4fb
# ╟─edafca88-dd4a-4fe4-8ffc-bb50f7bd561d
# ╠═9b97e41b-76ff-4cc2-90c1-446d59c4ece7
# ╟─af893e1e-3bd7-4d05-83b6-f5f7e751b5e3
# ╠═333290b0-0198-4306-b19b-6d30df79a280
# ╠═eeaf3735-5139-4924-9fce-14df51a61042
# ╟─20d6c513-2ca6-4dea-9092-156e2805d467
# ╟─692a6928-c7a2-4b61-a794-16bef5d4e919
# ╠═6d1058bf-8a05-4b8e-835a-de9e95f567c4
# ╠═35184e6f-ac3e-480b-92e9-ed8baaaa833b
# ╠═437faadd-0301-403a-bcd7-18ce279589d0
# ╠═1a4d21bd-85ad-4935-913a-8992a8996db4
# ╟─ee6414b7-e92d-4055-af17-6b02f05c28cd
# ╠═fac5012a-960c-473c-bbf0-62c0be87f608
# ╠═99629ec2-dc70-4253-b191-305bccc9f36b
# ╠═6b2beeec-6383-42b3-b694-8d77b961c8a1
# ╠═0b24f105-0166-4a41-97aa-156417d7203a
# ╟─c6f8dcf6-950d-48ff-b040-55bdd347d74b
# ╟─cd1dcbc4-2273-4eda-85d9-9af4fd71b3c1
# ╠═c3b0b7fc-19be-4f04-8787-6349ab9bff7f
# ╟─f5c2d0de-f5d2-43f2-bfca-41bd727b3ca9
# ╟─ef9d9512-cb40-4641-9d6a-5a36f5a4b33d
# ╠═2bc4c596-b313-49f6-84b5-5d53f2baf0e9
# ╟─648dfce3-5363-4539-8f41-f5d27bae4c6f
# ╟─288bfc6b-6848-40d5-916b-95a8a4248a4f
# ╠═a62ca8d1-321a-435e-a9df-f63d000376c7
# ╟─3304174c-289d-47c5-b5ef-161b11e515eb
# ╠═13269c86-06a4-4354-b620-bdf3f6432294
# ╟─28acb5a4-2a5f-49c5-9c78-deb40fdeed36
# ╟─13b003d2-1fd4-4a4a-960c-4a1d9b673dc6
# ╟─a2288816-3621-4871-9faf-3e9c78674969
# ╟─2b9c3427-c3ec-41ba-b3c5-268cf3dddccf
# ╟─fef0a76b-98dc-42a0-975b-0fba8a32e5cc
# ╟─2368f16c-9805-4dd6-a130-d831211f6155
# ╠═6800c94d-e7f3-43a8-a823-1c550cb8fc95
# ╠═b38727a9-72ff-499f-9751-ddfeee21959c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
