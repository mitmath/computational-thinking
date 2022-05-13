import Pluto

s = Pluto.ServerSession()

# s.options.server.disable_writing_notebook_files = true
s.options.server.launch_browser = false

nb = Pluto.SessionActions.open(s, joinpath(@__DIR__, "PlutoPages.jl"); run_async=false)

write("generation_report.html", Pluto.generate_html(nb))

for c in nb.cells
    if c.errored == "code"
        println(stderr, "Cell errored: ", c.cell_id)
        println(stderr)
        show(stderr, MIME"text/plain"(), c.output.body)
        println(stderr)
        println(stderr)
    end
end

Pluto.SessionActions.shutdown(s, nb)

if any(c -> c.errored, nb.cells)
    exit(1)
end
