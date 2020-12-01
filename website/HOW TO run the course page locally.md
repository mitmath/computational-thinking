# 18S191 course website

The website was written in Franklin.jl - a static site generator with Julia as templating language.
 
Whenever you push to this folder of the repository, the website will automatically rebuild and update. To test your changes locally before pushing, follow these steps:

1. In a terminal, navigate to this folder using `cd`.
2. Run Julia with this folder as the active project, and `instantiate`:
```
$ julia --project
julia> ]
(website) pkg> instantiate
```
3. Import & run our buddy Franklin:
```
julia> using Franklin
# ignore some warnings
julia> serve()
```

Franklin will now launch a _live dev server_: whenever you change a file, your browser tab will automatically refresh.
