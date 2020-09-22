# Documentation on course website

This document is for course staff and anyone who would like to edit the course website that is available at [computationalthinking.mit.edut/Fall20](computationalthinking.mit.edut/Fall20).

The code for the website is in the `website/` directory in this repo. It is processed by [Franklin.jl](https://franklinjl.org/) to generate the website whenever any file in this repository is changed.

 cd to the `website/` and launch Julia. Then run the following to install Franklin
```julia
using Pkg
Pkg.add("Franklin")
```

Then run this in the Julia REPL to bring up the website server.

```julia
using Franklin
serve()
```

The website should start to get served on [`http://localhost:8000/`](http://localhost:8000/).


## Editing in brief

- any file in the website/ directory, such as `website/hw0.md` will be rendered as `http://localhost:8000/hw0/`
- you can open a page, and edit the corresponding `.md` file to immediately see the page live-update with your changes. This also works when you're editing stylesheets and HTML templates for the website.


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
