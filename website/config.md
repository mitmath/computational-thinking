+++

# include("../tools/types.jl")
# include("../tools/book_model.jl")
include("../tools/sidebar.jl")

huhh2 = HTML(sidebar_code(book_model))
+++

<!--
The definitions here control the layout of the page: basic geometry, colors,
and elements. To avoid errors, do not remove definitions, rather, leave them
empty. Some definitions are only used if a toggle is set.

You can add your own rules if you so desire by either:
  - directly modifying `_css/custom.css`
  - adding rules to `_layout/style_tuning.fcss`
The latter allows you to plug in values that you would have defined here.
-->

<!-- META DEFINITIONS
  NOTE:
  - prepath: this is used to specify the base URLs; if your site should be
             available at `https://username.github.io/YourPackage.jl/` then the
             pre-path should be `YourPackage.jl`. If your site is meant to be
             hosted on a specific URL such as `https://awesomepkg.org` then set
             `prepath` to an empty string. Finally, adjust this if you want the
             deployed page to be in a subfolder e.g.: `YourPackage.jl/web/`.
-->
@def title       = "Introduction to Computational Thinking"
@def prepath     = "Spring21"
@def description = """
                   Introduction to Computational thinking. Online course website.
                   """
@def authors     = "MIT"

<!--  NAVBAR SPECS
  NOTE:
  - add_docs:  whether to add a pointer to your docs website
  - docs_url:  the url of the docs website (ignored if add_docs=false)
  - docs_name: how the link should be named in the navbar

  - add_nav_logo:  whether to add a logo left of the package name
  - nav_logo_path: where the logo is
-->
@def add_docs  = false
@def docs_url  = "https://franklinjl.org/"
@def docs_name = "Docs"

@def add_nav_logo   = true
@def nav_logo_path  = "/assets/logo.svg"
@def nav_logo_alt   = "Logo"
@def nav_logo_style = """
                      height:         25px;
                      padding-right:  10px;
                      """

<!-- HEADER SPECS
  NOTE:
  - use_header_img:     to use an image as background for the header
  - header_img_path:    either a path to an asset or a SVG like here. Note that
                        the path must be CSS-compatible.
  - header_img_style:   additional styling, for instance whether to repeat
                        or not. For a SVG pattern, use repeat, otherwise use
                        no-repeat.
  - header_margin_top:  vertical margin above the header, if <= 55px there will
                        be no white space, if >= 60 px, there will be white
                        space between the navbar and the header. (Ideally
                        don't pick a value between the two as the exact
                        look is browser dependent). When use_hero = true,
                        hero_margin_top is used instead.

  - use_hero:           if false, main bar stretches from left to right
                        otherwise boxed
  - hero_width:         width of the hero, for instance 80% will mean the
                        hero will stretch over 80% of the width of the page.
  - hero_margin_top     used instead of header_margin_top if use_hero is true

  - add_github_view:    whether to add a "View on GitHub" button in header
  - add_github_star:    whether to add a "Star this package" button in header
  - github_repo:        path to the GitHub repo for the GitHub button
-->
@def use_header_img     = true
@def use_hero           = false
@def hero_width         = "80%"
@def hero_margin_top    = "100px"

@def add_github_view  = true
@def add_github_star  = true
@def github_repo      = "mitmath/18S191"

<!-- SECTION LAYOUT
NOTE:
  - section_width:  integer number to control the default width of sections
                    you can also set it for individual sections by specifying
                    the width argument: `\begin{:section, ..., width=10}`.
-->
@def section_width = 10

<!-- COLOR PALETTE
You can use Hex, RGB or SVG color names; these tools are useful to choose:
  - color wheel: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Colors/Color_picker_tool
  - color names: https://developer.mozilla.org/en-US/docs/Web/CSS/color_value

NOTE:
  - header_color:      background color of the header
  - link_color:        color of links
  - link_hover_color:  color of links when hovered
  - section_bg_color:  background color of "secondary" sections to help
                       visually separate between sections.
  - footer_link_color: color of links in the footer
-->
@def header_color       = "#3f6388"
@def link_color         = "#2669DD"
@def link_hover_color   = "teal"
@def section_bg_color   = "#f6f8fa"
@def footer_link_color  = "cornflowerblue"

<!-- CODE LAYOUT
NOTE:
  - highlight_theme:    theme for the code, pick one from
                        https://highlightjs.org/static/demo/ for instance
                        "github" or "atom-one-dark"; use lower case and replace
                        spaces with `-`.
  - code_border_radius: how rounded the corners of code blocks should be
  - code_output_indent: how much left-identation to add for "output blocks"
                        (results of the evaluation of code blocks), use 0 if
                        you don't want indentation.
-->
@def highlight_theme    = "atom-one-dark"
@def code_border_radius = "10px"
@def code_output_indent = "15px"


<!-- YOUR DEFINITIONS
See franklinjl.org for more information on how to introduce your own
definitions and how they can be useful.
-->


<!-- INTERNAL DEFINITIONS =====================================================
===============================================================================
These definitions are important for the good functioning of some of the
commands that are defined and used in PkgPage.jl
-->
@def sections        = Pair{String,String}[]
@def section_counter = 1
@def showall         = true

\newcommand{\center}[1]{~~~<div style="text-align:center;">~~~#1~~~</div>~~~}
\newcommand{\out}[1]{@@code-output \show{#1} @@}

\newcommand{\blurb}[1]{~~~<p style="font-size: 1.15em; color: #333; line-height:1.5em">~~~#1~~~</p>~~~}
\newcommand{\youtube}[1]{~~~<iframe width="1020" height="574" src="https://www.youtube.com/embed/~~~#1~~~" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>~~~}

\newcommand{\card}[3]{
  @@column
  @@card
    @@card-container
      @@title #1 @@
      @@semester #2 @@
      @@feedback #3 @@
    @@
  @@
  @@
}