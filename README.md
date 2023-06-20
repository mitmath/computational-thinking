# 18.S191: Introduction to computational thinking for real-world problems

<p align="center"><a href="https://computationalthinking.mit.edu/"> <b>Go to course website</b> :balloon:</a></p>

This repository is a template to build a website like the [Computational thinking course](https://computationalthinking.mit.edu/) tought at MIT.

**Note**: This is an early experiment and very WIP, use at your own risk

## Instructions

### Clone the template


### Setup course basic informations

Open the files `src/_includes/layout.jlhtml` and `src/_includes/welcome.md` and fill them with your course information. You can search for the word `FIXME` to help you find what to fill and how.

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

#### Tags

For each notebook, include the following tags

- `"lecture"` or `"homework"`, depending on what the notebook is
- the module name, e.g. `"module1"`, this should be named as used in the `sidebar_data.jl` file
- The track name, prefixed with `track_` to associate the notebook to a given track, e.g. if you want the notebook in the track called `julia` add the tag `"track_julia"`.
- Any other keyword relevant for the notebook

#### Tracks

You can group your lecture material by tracks. When selecting a track, only the notebooks associated with that track will be highlighted (notebooks with the tag "welcome" are always highlighted, regardless of the track selection). To create tracks

1. In teh `layout.jlhtml` file, find the track sections

```html
<div class="track-chooser">
    <label>
    <h2>Choose your track:</h2>
    <select>
        <option value="">Choose...</option>
        <!-- FIXME: define your tracks -->
        <option value="julia">💻 Julia programming</option>
        <option value="math">🎨 Mathematics</option>
        <option value="example">Example track</option>
        <option value="data">📊 Data science</option>
    </select>
    </label>
</div>
```

For each track define a line

```html
<option value="trackid">Text displayed for the track in the menu</option>
```

To associate a notebook with a track with identifier `"trackid"`, add `"track_trackid"` (that is, the track identifier prefixed with `track_`) to the notebook tags.