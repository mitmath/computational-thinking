cd(@__DIR__)
notebook_path = joinpath(@__DIR__, "PlutoPages.jl")

@assert VERSION >= v"1.6.0"

begin
    begin
        begin
            # copy paste from pluto source code
            function detectwsl()
                Sys.islinux() &&
                isfile("/proc/sys/kernel/osrelease") &&
                occursin(r"Microsoft|WSL"i, read("/proc/sys/kernel/osrelease", String))
            end
            
            function open_in_default_browser(url::AbstractString)::Bool
                try
                    if Sys.isapple()
                        Base.run(`open $url`)
                        true
                    elseif Sys.iswindows() || detectwsl()
                        Base.run(`powershell.exe Start "'$url'"`)
                        true
                    elseif Sys.islinux()
                        Base.run(`xdg-open $url`)
                        true
                    else
                        false
                    end
                catch ex
                    false
                end
            end
        end
    end
end



import Pkg
Pkg.activate("./pluto-deployment-environment")
Pkg.instantiate()
import Pluto
import Deno_jll


pluto_port_channel = Channel{UInt16}(1)
function on_event(e::Pluto.ServerStartEvent)
    put!(pluto_port_channel, e.port)
end
function on_event(e)
    # ignore
end

req_s = false

# We create a session:
sesh = Pluto.ServerSession(options=Pluto.Configuration.from_flat_kwargs(;
    # workspace_use_distributed=false,
    # disable_writing_notebook_files=true,
    auto_reload_from_file=true,
    launch_browser=false,
    on_event,
    require_secret_for_access=req_s,
    require_secret_for_open_links=req_s
))

notebook_launch_task = @async Pluto.SessionActions.open(sesh, notebook_path; run_async=true)

@info "Pluto app: Starting server..."

println("Ignore the message \"Go to ... in your browser\":")
pluto_server_task = @async Pluto.run(sesh)

pluto_port = take!(pluto_port_channel) # This waits for the server to get ready
@info "Pluto app: waiting for notebook to launch..."
notebook = fetch(notebook_launch_task) # This waits for the notebook to finish

output_dir = joinpath(@__DIR__, "_site")

dev_server_port = rand(40507:40999)


dev_server_task = @async run(`$(Deno_jll.deno()) run --allow-read --allow-net https://deno.land/std@0.102.0/http/file_server.ts --cors --port $(dev_server_port) $(output_dir)`) # <=v"0.102.0" because of https://github.com/denoland/deno_std/issues/2251

sleep(.5)

ccall(:jl_exit_on_sigint, Cvoid, (Cint,), 0)
@info "Press Ctrl+C multiple times to exit"

isolated_cell_ids = [
    "cf27b3d3-1689-4b3a-a8fe-3ad639eb2f82"
    "7f7f1981-978d-4861-b840-71ab611faf74"
    "7d9cb939-da6b-4961-9584-a905ad453b5d"
    "4e88cf07-8d85-4327-b310-6c71ba951bba"
    "079a6399-50eb-4dee-a36d-b3dcb81c8456"
    "b0006e61-b037-41ed-a3e4-9962d15584c4"
    "06edb2d7-325f-4f80-8c55-dc01c7783054"
    "e0a25f24-a7de-4eac-9f88-cb7632de09eb"
]

isolated_cell_query = join("&isolated_cell_id=$(i)" for i in isolated_cell_ids)

dev_server_url = "http://localhost:$(dev_server_port)/"
pluto_server_url = "http://localhost:$(pluto_port)/edit?id=$(notebook.notebook_id)$(isolated_cell_query)"

@info """

✅✅✅

Ready! To see the website, visit:
➡️ $(dev_server_url)

To inspect the generation process, go to:
➡️ $(pluto_server_url)

✅✅✅

"""



open_in_default_browser(dev_server_url)
open_in_default_browser(pluto_server_url)

wait(dev_server_task)
wait(pluto_server_task)