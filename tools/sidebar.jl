
if VERSION < v"1.6.0-aaa"
    @error "Our website needs to be generated with Julia 1.6. Go to julialang.org/downloads to install it."
end


include("./types.jl")
include("./book_model.jl")

without_dotjl(path) = splitext(path)[1]

###
# SIDEBAR

function sidebar_line(section::Section)
    notebook_name = basename(without_dotjl(section.notebook_path))
    return """
    <a class="sidebar-nav-item {{ispage /$notebook_name/}}active{{end}}" href="/$notebook_name/"><b>$(section.chapter).$(section.section)</b> - <em>$(section.name)</em></a>
    """
end

function sidebar_line(ch::Chapter)
    return """
    <div class="course-section">Module $(ch.number): $(ch.name)</div>
    """
end


function sidebar_code(book_model)
    return """
    <div class="sidebar">
    <div class="container sidebar-sticky">
    <div class="sidebar-about">
    <br>
    <img src="/assets/MIT_logo.svg" style="width: 80px; height: auto; display: inline">
    <img src="/assets/julia-logo.svg" style="margin-left:1em; width: 80px; height: auto; display: inline">
    <div style="font-weight: bold; margin-bottom: 0.5em"><a href="/semesters/">Spring 2021</a> <span style="opacity: 0.6;">| MIT 18.S191/6.S083/22.S092</span></div>
    <h1><a href="/">Introduction to Computational Thinking</a></h1>
    <h2>Math from computation, math with computation</h2>
    <div style="line-height:18px; font-size: 15px; opacity: 0.85">by <a href="http://math.mit.edu/~edelman">Alan Edelman</a>, <a href="http://sistemas.fciencias.unam.mx/~dsanders/">David P. Sanders</a> &amp; <a href="https://people.csail.mit.edu/cel/">Charles E. Leiserson</a></div>
    </div>
    <br>
    <style>
    </style>
    <nav class="sidebar-nav" style="opacity: 0.9">
    <a class="sidebar-nav-item {{ispage /index.html}}active{{end}}" href="/"><b>Welcome</b></a>
    <a class="sidebar-nav-item {{ispage /reviews/}}active{{end}}" href="/reviews/">Class Reviews</a>
    <a class="sidebar-nav-item {{ispage /logistics/}}active{{end}}" href="/logistics/">Class Logistics</a>
    <a class="sidebar-nav-item {{ispage /homework/}}active{{end}}" href="/homework/">Homework</a>
    <a class="sidebar-nav-item {{ispage /syllabus/}}active{{end}}" href="/syllabus/">Syllabus and videos</a>
    <a class="sidebar-nav-item {{ispage /installation/}}active{{end}}" href="/installation/">Software installation</a>
    <a class="sidebar-nav-item {{ispage /cheatsheets/}}active{{end}}" href="/cheatsheets/">Cheatsheets</a>
    <a class="sidebar-nav-item {{ispage /semesters/}}active{{end}}" href="/semesters/">Previous semesters</a>
    <br>
    $(join(sidebar_line.(book_model)))

    <br>
    </nav>
    </div>
    </div>
    <div class="content container">"""
end

sidebar_result = sidebar_code(book_model)

