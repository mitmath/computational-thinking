---
layout: "layout.jlhtml"
---

<link rel="stylesheet" href="$(root_url)/assets/styles/homepage.css" type="text/css" />

<div id="title" class="banner">
    <h1>FIXME <strong>HOME PAGE title</strong></h1>
</div>

<blockquote class="banner">
    <p>FIXME greeting text in banner</p>
</blockquote>

<main class="homepage">
    <div class="subjectscontainer wide">
        <h1>Highlights</h1>
        <div class="contain">
            <section>
                <div class="content">
                    <h2>FIXME: Highlight 1</h2>
                    <p>FIXME: highlight 1 description.</p>
                </div>
                <div class="preview">
                    <!-- FIXME: link to image for highlight 1 -->
                    <img src="https://user-images.githubusercontent.com/6933510/136199652-0a1275ad-8452-4c9b-ac68-d33ed22f1d17.gif">
                </div>
            </section>
            <section>
                <div class="content">
                    <h2>FIXME: Highlight 2</h2>
                    <p>FIXME: highlight 2 description.</p>
                </div>
                <div class="preview">
                    <!-- FIXME: link to image for highlight 2 -->
                    <img src="https://user-images.githubusercontent.com/6933510/136199652-0a1275ad-8452-4c9b-ac68-d33ed22f1d17.gif">
                </div>
            </section>
        </div>
    </div>
    <div class="wide subjectscontainer">
        <h1>Subjects</h1>
        <div class="subjects">$(
            let
                sidebar_data = Base.include(@__MODULE__, joinpath(@__DIR__, "..", "sidebar data.jl"))
                sections = sidebar_data["main"]
            
                [
                    @htl("""
                    $([
                        let
                            input = other_page.input
                            output = other_page.output
                            
                            name = get(output.frontmatter, "title", basename(input.relative_path))
                            desc = get(output.frontmatter, "description", nothing)
                            tags = get(output.frontmatter, "tags", String[])
                            
                            image = get(output.frontmatter, "image", nothing)
                            
                            class = [
                                "no-decoration",
                                ("tag_$(replace(x, " "=>"_"))" for x in tags)...,
                            ]
                            
                            image === nothing || isempty(image) ? nothing : @htl("""<a title=$(desc) class=$(class) href=$(root_url * "/" * other_page.url)>
                                <h3>$(name)</h3>
                                <img src=$(image)>
                            </a>""")
                        end for other_page in pages
                    ])
                    """)
                    for (section_name, pages) in sections
                ]
            end
            )</div>
    </div>
    <div>
        <h1>Details</h1>
        <blockquote>
            <p>See also the course repository <a href="#">FIXME: course repository link</a>.</p>
        </blockquote>
        <p></p>
        <h2 id="meet_our_staff">Meet our staff</h2>
        <p><strong>Lecturers:</strong> FIXME</p>
        <p><strong>Teaching Assistants:</strong> FIXME</p>
        <p><strong>Guest lecturers:</strong> FIXME</p>
    </div>
    <div class="page-foot">
        <div class="copyright">
            <a href=""><b>Edit this page on FIXME: repository link<img class="github-logo" src="https://unpkg.com/ionicons@5.1.2/dist/svg/logo-github.svg"></b></a><br>
            Website based on the MIT course <a href="computationalthinking.mit.edu"><em><b>Computational Thinking</b>, a live online Julia/Pluto textbook</em></a> and built with <a href="https://plutojl.org/">Pluto.jl</a> and the <a href="https://julialang.org">Julia programming language</a>.
        </div>
    </div>
</main>