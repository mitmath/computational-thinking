import Pkg
Pkg.activate("./pluto-deployment-environment")
Pkg.instantiate()
import Pluto
Pluto.run(notebook=joinpath(@__DIR__, "PlutoPages.jl"))