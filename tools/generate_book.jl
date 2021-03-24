if !isdir("pluto-deployment-environment")
    @error """
    Run me from the root of the repository directory, using:
    
    julia tools/generate_book.jl
    """
end

import Pkg
Pkg.activate("./pluto-deployment-environment")
Pkg.instantiate()


# Goals for this script:
# 1. Add Headers to each of the notebook with the correct styling and youtube video
# 2. Generate the md files for each notebook
# 3. Add all Chapters to sidebar
# Bonuses:
# - Hide markdown and html cell
# - Remove empty cells

using Pluto

# If we're running inside a github action, redirect Julia logs to the github UI

# using Logging: global_logger
# using GitHubActions: GitHubActionsLogger
# get(ENV, "GITHUB_ACTIONS", "false") == "true" && global_logger(GitHubActionsLogger())


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

without_dotjl(path) = splitext(path)[1]

"""
Generate the single-line .md file that embeds the static preview of the notebook. Franklin needs the .md file to exist to create a page.

This assumes that all path's are relative to the repo root and that we are writing to website/
"""
function write_md_page(path::String)
    file_name = basename(without_dotjl(path))
    outpath = "website/$file_name.md"
    write(outpath, "{{ plutonotebookpage  ../$path }}")
end

function html_header(section::Section)
    html_code = """\"\"\"
<div style="
position: absolute;
width: calc(100% - 30px);
border: 50vw solid #282936;
border-top: 500px solid #282936;
border-bottom: none;
box-sizing: content-box;
left: calc(-50vw + 15px);
top: -500px;
height: 500px;
pointer-events: none;
"></div>

<div style="
height: 500px;
width: 100%;
background: #282936;
color: #fff;
padding-top: 68px;
">
<span style="
font-family: Vollkorn, serif;
font-weight: 700;
font-feature-settings: 'lnum', 'pnum';
"> <p style="
font-size: 1.5rem;
opacity: .8;
"><em>Section $(section.chapter).$(section.section)</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> $(section.name) </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/$(section.video_id)" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>\"\"\""""
    return "html" * html_code
end


function process_book_item(section::Section)

    notebook  = Pluto.load_notebook_nobackup(section.notebook_path)
    ordered_cells = notebook.cells

    # First, add the header to each cell 
    first_cell = ordered_cells[1]
    new_cell_code = html_header(section)

    if startswith(first_cell.code, "html")
        # We can just overwrite this cell
        ordered_cells[1].code = new_cell_code
    else
        # We get to add a new cell
        insert!(ordered_cells, 1, Pluto.Cell(new_cell_code))
    end

    # Second hide all md, html cells
    for cell ∈ ordered_cells
        if startswith(cell.code, "html") || startswith(cell.code, "md")
            cell.code_folded = true
        end
    end
    
    Pluto.save_notebook(notebook)

    # Now we need to generate the approriate .md file for this notebook
    write_md_page(section.notebook_path)
end

function process_book_item(ch::Chapter)
    # This is not a notebook so we don't need to do anything
end


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
      <div class="course-section">Module 3</div>
      <em>Starting in week 7</em>
      <div class="course-section">Module 4</div>
      <em>Starting in week 10...</em>

      <br>
      </nav>
    </div>
  </div>
<div class="content container">"""
end

function write_sidebar(book_model)
    write("website/_layout/sidebar.html", sidebar_code(book_model))
end


include("./book_model.jl")

for section ∈ book_model
    process_book_item(section)
end
write_sidebar(book_model)
