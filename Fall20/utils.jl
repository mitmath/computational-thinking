# Thanks @tlienart

using Franklin, JSON

using Markdown, Dates

include("youtube_videos.jl")

const DATEFMT = dateformat"yyyy-mm-dd HH:MMp"
const TZ = "America/New_York"

function hfun_doc(params)
    fname = join(params[1:max(1, length(params)-2)], " ")
    head = params[end-1]
    type = params[end]
    doc = eval(Meta.parse("@doc $fname"))
    txt = Markdown.plain(doc)
    # possibly further processing here
    body = Franklin.fd2html(txt, internal=true)
    return """
      <div class="docstring">
          <h2 class="doc-header" id="$head">
            <a href="#$head">$head</a>
            <div class="doc-type">$type</div></h2>
          <div class="doc-content">$body</div>
      </div>
    """
end

function hfun_youtube(params)
    id = params[1]
    return """
    <iframe id="$id" width="100%" height="360"
    src="https://www.youtube.com/embed/$(get(videos, id, id))"
    frameborder="0"
    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen></iframe>
    """
end

function hfun_showtime(params)
    id = params[1]
    str = locvar(id)
    if isnothing(str)
        @warn "Unknown datetime variable $str"
        return ""
    end
    try
        DateTime(str, DATEFMT)
    catch err
        @warn "There was an error parsing date $str, the format is yyyy-mm-dd HH:MMp (see ?DateFormat)"
        rethrow(err)
    end
end


function parse_duration(str)
    str = replace(str, r"^PT"=>"")
    hrex, mrex, srex = Regex.(string.("^([0-9]+)", ["H","M","S"]))

    t = 0
    hmatch = match(hrex, str)
    if !isnothing(hmatch)
        h = parse(Int, hmatch[1])
        t += 60*60*h
        str = replace(str, hrex=>"")
    end

    mmatch = match(mrex, str)
    if !isnothing(mmatch)
        m = parse(Int, mmatch[1])
        t += 60*m
        str = replace(str, mrex=>"")
    end

    smatch = match(srex, str)
    if !isnothing(smatch)
        s = parse(Int, smatch[1])
        t += s
        str = replace(str, srex=>"")
    end

    t
end

function hfun_go_live()
    seq = locvar("sequence")
    airtime = locvar("airtime")

    if isnothing(seq)
        @warn "airtime set, but no `sequence` variable not defined." *
        "sequence is an array of video IDs to play in order on this page"
    end

    vid_ids = [get(videos, s, s) for s in seq]

    f = tempname()
    # Get the duration of each video
    download("https://www.googleapis.com/youtube/v3/videos?id=$(join(vid_ids, ","))&part=contentDetails&key=AIzaSyDZhbWHc2PTEFTx173MaTgddnWCGPqdbB8", f)
    dict = JSON.parse(String(read(f)))

    durations = [parse_duration(video["contentDetails"]["duration"])
                 for video in dict["items"]]


    jrepr(x) = sprint(io->JSON.print(io, x))
    """
    <script src="/assets/moment.min.js"></script>
    <script src="/assets/moment-timezone.js"></script>
    <script src="/assets/live-player.js"></script>
    <script>
    play_live($(jrepr(string(DateTime(airtime, DATEFMT)))), $(jrepr(TZ)), $(jrepr(seq)), $(jrepr(durations)))
    </script>
    """
end
