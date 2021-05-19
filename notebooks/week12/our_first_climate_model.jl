### A Pluto.jl notebook ###
# v0.14.5

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
    import Pkg
    Pkg.activate(mktempdir())
	
    Pkg.add([
        Pkg.PackageSpec(name="DifferentialEquations", version="6"),
        Pkg.PackageSpec(name="Plots", version="1"),
		Pkg.PackageSpec(name="PlutoUI", version="0.7"),
	    Pkg.PackageSpec(name="CSV", version="0.8"),
	    Pkg.PackageSpec(name="DataFrames", version="1")


         ])
	
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
f(y,(a,b,forcing(c)),t) = a - b*y + forcing(c)(t)

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
sol = solve(  ODEProblem( f, y₀, (0,10.0), (a,b,forcing(c)) ) );

# ╔═╡ 220420c1-e8cc-4ff6-8b79-ba2ec49c7695
y₀

# ╔═╡ bda41881-75c7-4732-9a66-d7947607b1b6
begin
	p = plot( sol , legend=false, background_color_inside=:black , ylims=(0,10), lw=3, c=:red)
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
 p1 = ODEProblem( (temp,p,t)-> (1/C) * absorbed_solar_radiation, temp₀,  (0.0,170) )

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
p2 = ODEProblem( (temp,p,t)-> (1/C) * B*(temp₀-temp), start_temp,  (0.0,170) )

# ╔═╡ eeaf3735-5139-4924-9fce-14df51a61042
begin
	plot(solve(p2),       legend = false, 
		 background_color_inside = :black,
		                  xlabel = "years from start",
	                      ylabel = "Temperature °C",
	                      ylim = (0,30))
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
	 #CO₂(t) = CO₂_PreIndust # no emissions
	 # CO₂(t) = CO₂_PreIndust * 1.01^t # test model
	 CO₂(t) = CO₂_PreIndust * (1+ (t/220)^3 ) 
end

# ╔═╡ 1a4d21bd-85ad-4935-913a-8992a8996db4
greenhouse_effect(CO₂(15))

# ╔═╡ 99629ec2-dc70-4253-b191-305bccc9f36b
p3 = ODEProblem( (temp,p,t)-> (1/C) * ( B*(temp₀-temp)  + greenhouse_effect(CO₂(t))    ) , start_temp,  (0.0,170) )

# ╔═╡ 6b2beeec-6383-42b3-b694-8d77b961c8a1
begin
	plot(solve(p3),       legend = false, 
		 background_color_inside = :black,
		                  xlabel = "years from 1850",
	                      ylabel = "Temperature °C",
	                      ylim = (10,20))
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
p4 = ODEProblem( (temp,p,t)-> (1/CC) * ( BB*(temp₀-temp)  + greenhouse_effect(CO₂(t))    ) , start_temp,  (0.0,170) )

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
    #T_df = T_df[:,[1,6]]
	
end

# ╔═╡ a62ca8d1-321a-435e-a9df-f63d000376c7
begin
	plot(years,solp4.(years.-1850),lw=2,label="Predicted Temperature from model", legend=:topleft)
	xlabel!("year")
	ylabel!("Temp °C")
	
	plot!( parse.(Float64, T_df[:,1]), parse.(Float64, T_df[:,2]) .+ 14.15, color=:black, label="NASA Observations", legend=:topleft)
end

# ╔═╡ Cell order:
# ╟─42085492-ac8c-11eb-0620-adcb307077f1
# ╟─c7d387fa-cd19-458c-a45d-7893e8c21bbf
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
