import Pluto

s = Pluto.ServerSession()

# s.options.server.disable_writing_notebook_files = true
s.options.server.launch_browser = false

@info "PlutoPages: Starting..."
nb = Pluto.SessionActions.open(s, joinpath(@__DIR__, "PlutoPages.jl"); run_async=false)
@info "PlutoPages: Finished. Analyzing result..."

write("generation_report.html", Pluto.generate_html(nb))

failed = filter(c -> c.errored, nb.cells)

for c in failed
    println(stderr, "Cell errored: ", c.cell_id)
    println(stderr)
    show(stderr, MIME"text/plain"(), c.output.body)
    println(stderr)
    println(stderr)
end

Pluto.SessionActions.shutdown(s, nb)

if !isempty(failed)
    exit(1)
end
