FROM julia:1.6-rc

EXPOSE 1234
RUN apt-get update -y && apt-get upgrade -y
RUN useradd -ms /bin/bash pluto
WORKDIR /home/pluto
USER pluto
COPY --chown=pluto . ${HOME}

# Yes, let's do this better!
RUN ls ${HOME} &&\
    julia -e "download(\"https://raw.githubusercontent.com/pankgeorg/pluto-article/digitalocean/Manifest.toml\", \"/home/pluto/Manifest.toml\")" &&\ 
    julia -e "download(\"https://raw.githubusercontent.com/pankgeorg/pluto-article/digitalocean/Project.toml\", \"/home/pluto/Project.toml\")"

RUN julia --project=${HOME} -e "import Pkg; Pkg.activate(\".\"); Pkg.instantiate(); Pkg.precompile()"

CMD ["julia", "--project=/home/pluto", "-e", "import PlutoBindServer; PlutoBindServer.run_directory(\"lecture_notebooks\"; port=1234 , host=\"0.0.0.0\", workspace_use_distributed=true)"]