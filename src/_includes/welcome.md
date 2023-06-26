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
                sections = metadata["sidebar"]
            
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
                        end for other_page in collections[section_id].pages
                    ])
                    """)
                    for (section_id, section_name) in sections
                ]
            end
            )</div>
    </div>
    <div>
        <h1>Details</h1>
        <blockquote>
            <p>See also the course repository <a href="$(metadata["course_info"]["repo"])">$(metadata["course_info"]["repo"])</a>.</p>
        </blockquote>
        <p></p>
        <h2 id="meet_our_staff">Meet our staff</h2>
        <p><strong>Lecturers:</strong> ...</p>
        <p><strong>Teaching Assistants:</strong> ...</p>
        <p><strong>Guest lecturers:</strong> ...</p>
    </div>
    <div class="page-foot">
        <div class="copyright">
            <a href="$(metadata["course_info"]["repo"])"><b>Edit this page on <img class="github-logo" src="https://unpkg.com/ionicons@5.1.2/dist/svg/logo-github.svg"></b></a><br>
            Website based on the MIT course <a href="https://computationalthinking.mit.edu"><em><b>Computational Thinking</b>, a live online Julia/Pluto textbook</em></a> and built with <a href="https://plutojl.org/">Pluto.jl</a> and the <a href="https://julialang.org">Julia programming language</a>.
        </div>
    </div>
</main>