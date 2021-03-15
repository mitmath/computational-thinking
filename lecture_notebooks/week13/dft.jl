### A Pluto.jl notebook ###
# v0.11.10

using Markdown
using InteractiveUtils

# ╔═╡ 5248e43c-3761-11eb-1d42-bd8f8b9f19a7
begin
	import Pkg
	Pkg.add("FFTW")
	Pkg.add("Plots")
	Pkg.add("DSP")
	Pkg.add("PlutoUI")
	Pkg.add("WAV")
	Pkg.add("FileIO")
	Pkg.add("WebIO")
	Pkg.add("OffsetArrays")
    using FFTW
    using Plots
    using DSP
    using PlutoUI
    using WAV
    using FileIO
    using WebIO
	using OffsetArrays
end

# ╔═╡ 49d931b2-3761-11eb-1bc2-25a1d3b38eba
md"# Fast Fourier Transforms"

# ╔═╡ 556bc8c6-3761-11eb-0609-059485893468
md"### Playing with sound"

# ╔═╡ de377bcc-3971-11eb-1920-01ae73829171
md"This downloads five simple two second clips.  The first four are individual notes being hummed, and the last is the result of overlaying these four tracks."

# ╔═╡ 6374807c-3761-11eb-03e6-0f45dd0fd4e4
begin
	files = download.([
		"https://www.dropbox.com/s/3zygy6n72prdv9x/Sound1.wav?dl=0",
		"https://www.dropbox.com/s/qxb79tw6jhillym/Sound2.wav?dl=0",
		"https://www.dropbox.com/s/evo14tvdujkcssc/Sound3.wav?dl=0",
		"https://www.dropbox.com/s/sfxpt3erqelc7jt/Sound4.wav?dl=0",
		"https://www.dropbox.com/s/xlavzvtoaxe0oe7/Sound1234.wav?dl=0",
	])
end

# ╔═╡ af9a9c96-3803-11eb-1ec1-6315d95b164a
sounds = wavread.(files)

# ╔═╡ ffd94950-3803-11eb-36f9-93f943d7af8f
signals = [sound[1][:, 1] for sound in sounds]

# ╔═╡ d26c7384-396b-11eb-03f1-59108a815886
md"When you zoom in on one of the first four sounds, it looks like a simple periodic pattern with some frequency."

# ╔═╡ c6bf9c00-3803-11eb-12f6-87afda3aea9f
plot(signals[1], x_lims=(20000, 22000))

# ╔═╡ 0d9bca86-396c-11eb-1b96-9987e8e188bc
md"The final sound is the sum of these first four, and gives a more complicated wave"

# ╔═╡ 1140ee78-3804-11eb-34b5-6354d4db9642
plot(signals[5], x_lims=(20000, 22000))

# ╔═╡ 2291650e-396c-11eb-26e4-b791a57b87e4
md"The FFT pulls out the frequency components of each sound, which for musical notes like these looks like a spike above the base frequency itself, with smaller spikes at whole number multiples of that frequency, which are the overtones.

In this case, when we say \"frequency\", unless we rescale the x-axis it won't be cycles per unit time, but instead cycles per T units of time where T is the duration of the clip.  The FFT just sees a list of sample values, it has no way of knowing how many samples per second there are, or that seconds are the unit of time we might care about, so the only cononical unit of time would be the clip's duration.
"

# ╔═╡ 605fc966-3804-11eb-2aef-f1f934d49e36
signal_ffts = fft.(signals)

# ╔═╡ a3aab82a-3804-11eb-3d2c-6f8e9eb9a12f
plot(
	[abs.(signal_ffts[i]) for i in 1:4],
	x_lims=(1, 1000)
)

# ╔═╡ a57789ae-3805-11eb-21fc-c7b776fa2627
plot(
	abs.(signal_ffts[5]),
	x_lims=(1, 1000)
)

# ╔═╡ 66a98e40-3761-11eb-1b60-c1a3af8a062d
md"### Writing our own DFT function"

# ╔═╡ f15076fe-396d-11eb-0de9-1380a93497b9
md"By reading off the mathematical definition directly, we can implement the discrete fourier transform ourselves fairly simply."

# ╔═╡ 2839a190-3808-11eb-2554-99897f4542ca
function dft(signal)
	N = length(signal)
	# Precompute all the roots of unity we'll need.
	# Zeta here refers to exp(-2π * im / N).
	# OffsetArray lets us treat this like a zero-indexed array,
	# so that zeta_powers[n] = zeta^n
	zeta_powers = OffsetArray(
		[exp(-2π * im * n / N) for n in 0:(N - 1)],
		0:(N-1)
	)
	return [
		sum(
			signal[n + 1] * zeta_powers[(n * f) % N]
			for n in 0:(N - 1)
		)
		for f in 0:(N - 1)
	]
end

# ╔═╡ 429fe2ba-396e-11eb-0e01-13a0db7f9f03
md"We can verify that this gives the same output as the fft function, however by noting the runtime displayed in the lower right of each julia cell, you can see that our implmentation is much slower.  Fundeamentally this is because our naieve implementation has O(N^2) complexity, whereas the FFT using a more clever algorithm which is O(N*log(N))"

# ╔═╡ 93caa8dc-396e-11eb-36ea-2fe87a5b7a16
N = 10000 # Change this and note the runtimes below

# ╔═╡ 114c966a-3809-11eb-2b84-f1323e9b720d
signal = signals[1][1:N]

# ╔═╡ ac0cb6e2-396e-11eb-1f46-1d8b2100bb44
signal_fft = fft(signal)

# ╔═╡ 156b7572-3809-11eb-0d63-c9be4201e6ba
signal_dft = dft(signal)

# ╔═╡ 41f22476-3809-11eb-305a-51caf3dde226
isapprox(signal_dft, signal_fft)

# ╔═╡ Cell order:
# ╟─49d931b2-3761-11eb-1bc2-25a1d3b38eba
# ╟─5248e43c-3761-11eb-1d42-bd8f8b9f19a7
# ╟─556bc8c6-3761-11eb-0609-059485893468
# ╟─de377bcc-3971-11eb-1920-01ae73829171
# ╠═6374807c-3761-11eb-03e6-0f45dd0fd4e4
# ╠═af9a9c96-3803-11eb-1ec1-6315d95b164a
# ╠═ffd94950-3803-11eb-36f9-93f943d7af8f
# ╟─d26c7384-396b-11eb-03f1-59108a815886
# ╠═c6bf9c00-3803-11eb-12f6-87afda3aea9f
# ╟─0d9bca86-396c-11eb-1b96-9987e8e188bc
# ╠═1140ee78-3804-11eb-34b5-6354d4db9642
# ╟─2291650e-396c-11eb-26e4-b791a57b87e4
# ╠═605fc966-3804-11eb-2aef-f1f934d49e36
# ╠═a3aab82a-3804-11eb-3d2c-6f8e9eb9a12f
# ╠═a57789ae-3805-11eb-21fc-c7b776fa2627
# ╟─66a98e40-3761-11eb-1b60-c1a3af8a062d
# ╟─f15076fe-396d-11eb-0de9-1380a93497b9
# ╠═2839a190-3808-11eb-2554-99897f4542ca
# ╟─429fe2ba-396e-11eb-0e01-13a0db7f9f03
# ╠═93caa8dc-396e-11eb-36ea-2fe87a5b7a16
# ╠═114c966a-3809-11eb-2b84-f1323e9b720d
# ╠═ac0cb6e2-396e-11eb-1f46-1d8b2100bb44
# ╠═156b7572-3809-11eb-0d63-c9be4201e6ba
# ╠═41f22476-3809-11eb-305a-51caf3dde226
