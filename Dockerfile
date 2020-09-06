FROM julia:latest

RUN apt-get update -y && apt-get install -y git

RUN useradd -m pluto
USER pluto
WORKDIR /home/pluto
RUN git clone https://github.com/mitmath/18S191.git

EXPOSE 1234
ENV JULIA_NUM_THREADS = 100
ENV JULIA_DEPOT_PATH=/home/pluto/.julia
RUN julia -e 'using Pkg; Pkg.update(); Pkg.add(["Pluto", "PlutoUI", "Plots"]); Pkg.precompile();'
RUN echo 'using Pluto; Pluto.run("0.0.0.0.0", 1234)' >> docker_main.jl
WORKDIR /home/pluto/18S191

CMD [ "julia", "/home/pluto/docker_main.jl" ]
