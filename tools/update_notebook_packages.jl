if !isdir("pluto-deployment-environment") || length(ARGS) != 1
    error("""
    Run me from the root of the repository directory, using:

    julia tools/update_notebook_packages.jl <level>
    
    Where <level> is one of: PATCH, MINOR, MAJOR
    """)
end

if VERSION < v"1.6.0-aaa"
    @error "Our website needs to be generated with Julia 1.6. Go to julialang.org/downloads to install it."
end

import Pkg
Pkg.activate("./pluto-deployment-environment")
Pkg.instantiate()

import Pluto

flatmap(args...) = vcat(map(args...)...)


all_files_recursive = flatmap(walkdir("src")) do (root, _dirs, files)
    joinpath.((root,), files)
end

all_notebooks = filter(Pluto.is_pluto_notebook, all_files_recursive)

level = getfield(Pkg, Symbol("UPLEVEL_$(ARGS[1])"))

for n in all_notebooks
    @info "Updating" n
    Pluto.update_notebook_environment(n; backup=false, level)
end
