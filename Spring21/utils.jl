# Thanks @tlienart

using Franklin, JSON

using Markdown, Dates

include("youtube_videos.jl")
include("../tools/sidebar.jl")

const DATEFMT = dateformat"yyyy-mm-dd HH:MMp"
const TZ = "America/New_York"

function hfun_sidebar(params)
    return sidebar_result
end

function hfun_plutonotebookpage(params)
    path = params[1]
    path_to_html = if endswith(path, ".jl")
        path[1:end-3] * ".html"
    else
        path * ".html"
    end

    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Feature-Policy#directives

    return """
    <style>

    .content {
        max-width: 100%;
        margin-right: 0px;
        padding: 0px;
        overflow-y: hidden;
        height: 100vh;
    }
    .franklin-content {
        padding: 0px;
    }
    .page-foot {
        display: none;
    }
    .plutopage {
        height: 100vh;
    }
    .smallscreenlink {
        display: none;
    }
    @media (max-width: 768px) {
        .franklin-content {
            padding: 0px;
        }
    }
    </style>

    <iframe width="100%" height="100%"
    src="$(path_to_html)"
    class="plutopage"
    frameborder="0"
    allow="accelerometer; ambient-light-sensor; autoplay; battery; camera; display-capture; document-domain; encrypted-media; execution-while-not-rendered; execution-while-out-of-viewport; fullscreen; geolocation; gyroscope; layout-animations; legacy-image-formats; magnetometer; microphone; midi; navigation-override; oversized-images; payment; picture-in-picture; publickey-credentials-get; sync-xhr; usb; wake-lock; screen-wake-lock; vr; web-share; xr-spatial-tracking"
    allowfullscreen></iframe>

    <a class="smallscreenlink" href="$(path_to_html)"></a>
    """
end

function hfun_doc(params)
    fname = join(params[1:max(1, length(params) - 2)], " ")
    head = params[end-1]
    type = params[end]
    doc = eval(Meta.parse("@doc $fname"))
    txt = Markdown.plain(doc)
    # possibly further processing here
    body = Franklin.fd2html(txt, internal = true)
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
    str = replace(str, r"^PT" => "")
    hrex, mrex, srex = Regex.(string.("^([0-9]+)", ["H", "M", "S"]))

    t = 0
    hmatch = match(hrex, str)
    if !isnothing(hmatch)
        h = parse(Int, hmatch[1])
        t += 60 * 60 * h
        str = replace(str, hrex => "")
    end

    mmatch = match(mrex, str)
    if !isnothing(mmatch)
        m = parse(Int, mmatch[1])
        t += 60 * m
        str = replace(str, mrex => "")
    end

    smatch = match(srex, str)
    if !isnothing(smatch)
        s = parse(Int, smatch[1])
        t += s
        str = replace(str, srex => "")
    end

    t
end
