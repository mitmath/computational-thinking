# Documentation on course website

This document is for course staff and anyone who would like to edit the course website that is available at [computationalthinking.mit.edut/](computationalthinking.mit.edut/).

The code for the website is in the `website/` directory in this repo. It is processed by [Franklin.jl](https://franklinjl.org/) to generate the website whenever any file in this repository is changed.

cd to the `website/` and launch Julia. Then run the following to install Franklin

```julia
using Pkg
Pkg.add("Franklin")
```

Might give some warnings, but if the website works then you can ignore them :)

Then run this in the Julia REPL to bring up the website server.

```julia
using Franklin
serve()
```

The website should start to get served on [`http://localhost:8000/`](http://localhost:8000/).

## Editing in brief

-   any file in the website/ directory, such as `website/hw0.md` will be rendered as `http://localhost:8000/hw0/`
-   you can open a page, and edit the corresponding `.md` file to immediately see the page live-update with your changes. This also works when you're editing stylesheets and HTML templates for the website.

**Embedding a YouTube video**

You can give your youtube video a human friendly name by adding it's video ID to the dictionary in `website/youtube_videos.jl`.

The youtube video id is the `v=<ID>` part of the youtube URL. For exapmle, the video ID for the video https://www.youtube.com/watch?v=OOjKEgbt8AI is just `OOjKEgbt8AI`.

You can give it a nice name such as "my-video" and add it to `youtube_videos.jl`

```julia
    "my-video" => "OOjKEgbt8AI",
```

Once you have added this entry, you can embed the video into a markdown file with the syntax:

```
{{youtube my-video}}
```

# Pluto

## How do the notebooks end up on the website?

If you run the web page locally, you will see that the notebook pages (e.g. Week 1) give a 404 error. This is because **we have a GitHub Action that runs all the notebooks and converts them into HTML.**

## Are the notebooks interactive?

Yes! Besides the HTML export GH Action, we use two additional tricks:

1. Every notebook has a "Run on Binder" button. This is built into (an experimental branch of) Pluto, we don't need to do much on the 18S191 side.
2. We are running a "Pluto `@bind` server" on DigitalOcean, which makes sliders and buttons work directly on the website. The static HTML notebooks can make `@bind` requests to this server, which runs given bond values and returns changed cell outputs. You can't run _code_ on this server, which means that the server is 'stateless'. This server also redeploys on every commit. (Contact fons@mit.edu for more info)

If you would like to test these two features locally, ask fonsi!
