# Thanks @tlienart

using Franklin, PkgPage

using Markdown

include("youtube_videos.jl")

function hfun_doc(params)
    fname = join(params[1:max(1, length(params)-2)], " ")
    head = params[end-1]
    type = params[end]
    doc = eval(Meta.parse("using FileTrees; @doc FileTrees.$fname"))
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
    <iframe width="800" height="474"
    src="https://www.youtube.com/embed/$(get(videos, id, id))"
    frameborder="0"
    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen></iframe>
    """
end
