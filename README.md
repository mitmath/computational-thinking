# 18.S191: Introduction to computational thinking for real-world problems

<p align="center"><a href="https://computationalthinking.mit.edu/"> <b>Go to course website</b> :balloon:</a></p>

This repository is a template to build a website like the [Computational thinking course](https://computationalthinking.mit.edu/) tought at MIT.

**Note**: This is an early experiment and very WIP, use at your own risk

## Instructions

### Clone the template


### Setup course basic informations

Open the file `src/_data/course_info.jl` and fill it with your course data.

### Fill notebooks metadata

For each notebook, include the following metadata

- `title`: notebook title
- `order`: in which order you want the notebook to appear on the side bar. **Pro tip**: You can use half-integers too, e.g. `order=1.5`, this can be handy to have e.g. a homework between the first and second lecture of the module without making the lectures numbering messy.
- (optional) `chapter` and `section`, if filled, the notebook will be numbered accordingly in the sidebar, e.g. if `chapter = 1` and `section = 3`, it will appear as `1.3` in the sidebar
- (optional) `youtube_id`: if you have an associated video lecture on youtube, add the youtube id to display the embed on top of the notebook
- `image` teasing image to display in the `subjects` section on the homepage. If left empty, the lecture will not be displayed in the `subjects` section.
- `layout = "layout.jlhtml"` (unless you want to use your personal layout)
- (optional) `description`: short description of hte notebook
- `homework_number`: for homeworks, the number of the homework
- `tags`: see below

### Sidebar

You can group your lectures in modules (e.g. weeks). To do so open `src/_data/sidebar.jl` and add a line

```julia
module_id => module_title
```

for each module. You can then include notebooks to this module by simply including `module_id` as tag.

For example, if your first module is about image processing, add

```julia
"module1" => "Module 1: Images, Transformations, Abstractions",
```

To include a notebook under this module in the sidebar, include "module1" among the notebook tags.

#### Tags

For each notebook, include the following tags

- `"lecture"` or `"homework"`, depending on what the notebook is
- the module name, e.g. `"module1"`, this should be named as used in the `sidebar_data.jl` file
- The track name, prefixed with `track_` to associate the notebook to a given track, e.g. if you want the notebook in the track called `julia` add the tag `"track_julia"`.
- Any other keyword relevant for the notebook

#### Tracks

You can group your lecture material by tracks. When selecting a track, only the notebooks associated with that track will be highlighted (notebooks with the tag "welcome" are always highlighted, regardless of the track selection). To create tracks

1. Open the file `src/_data/tracks.jl` and for each track add an entry like

```julia
track_id => track_name
```

To associate a notebook with a track with identifier `"trackid"`, add `"track_trackid"` (that is, the track identifier prefixed with `track_`) to the notebook tags.

For example, to create a track related to Julia, add the following line to `tracks.jl`.

```julia
"julia" => "💻 Julia programming"
```

You can now associate notebooks to this track by simply including "track_julia" among the notebooks track.