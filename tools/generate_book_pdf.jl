if !isdir("pluto-deployment-environment")
    error("""
    Run me from the root of the repository directory, using:

    julia tools/generate_book_pdf.jl
    """)
end

if VERSION < v"1.6.0-aaa"
    @error "Our website needs to be generated with Julia 1.6. Go to julialang.org/downloads to install it."
end


import Pkg
Pkg.activate(mktempdir())
Pkg.add([
    Pkg.PackageSpec(name="Pluto", rev="cd7c123"),
    # Pkg.PackageSpec(url="https://github.com/JuliaPluto/PlutoPDF.jl", rev="488d25f"),
])
import Pluto
import PlutoPDF

struct Section
    chapter::Int
    section::Int
    name::String
    notebook_path::String
    video_id::String
end

struct Chapter
    number::Int
    name::String
end

book_model = include("./book_model.jl")


outdir = tempname(;cleanup=false)
mkdir(outdir)

try
    # macos
    run(`open $(outdir)`)
catch
end

for (i, m) in enumerate(book_model)
    if m isa Section
        pdfname = string("section ", lpad(m.chapter, 2, '0'), ".", lpad(m.section, 2, '0'), " - ", m.name,".pdf")
        pdfpath = joinpath(outdir, pdfname)
        mkpath(dirname(pdfpath))
        PlutoPDF.pluto_to_pdf(m.notebook_path, pdfpath; open=false, options=(
            format ="A5",
            scale=0.67,
            margin=(
                top="10mm",
                right="12.5mm",
                bottom="10mm",
                left="0mm",
            ),
            printBackground=true,
            displayHeaderFooter=false,
        ))
    end
end

