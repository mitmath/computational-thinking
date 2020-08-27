# First time setup: _installing Julia & Pluto_



## Step 1: install Julia 1.5.1

Go to [https://julialang.org/downloads/platform/](https://julialang.org/downloads/platform/) follow the installation instructions for your system (Linux x86, Windows, etc). We recommend installing regular Julia 1.5.1, we don't need JuliaPro for this course.

After installing, **make sure that you can run Julia**. On some systems, this means searching for the "Julia 1.5.1" program isntalled on your computer, in others it means running the command `julia` in a terminal. Make sure that you can run `1+1`:

![image](https://user-images.githubusercontent.com/6933510/91439734-c573c780-e86d-11ea-8169-0c97a7013e8d.png)

_Make sure that you are able to launch Julia and calculate `1+1`_

## Step 2: installing Pluto

Open the _Julia REPL_, this is the command line interface to Julia, like in the previous screenshot.

Here you type _Julia commands_, and when you press ENTER, it runs, and you see the result.

To install Pluto, we want to run a _package manager command_. To switch from _Julia_ mode to _Pkg_ mode, type `]` in a Julia line:
```julia
julia> ]

(@v1.5) pkg>
```

The start of line turns blue, telling you that you are inside _package manager mode_. Inside this mode, run:
```julia
(@v1.5) pkg> add Pluto
```

This might take a couple of minutes, go get yourself a cup of tea!

![image](https://user-images.githubusercontent.com/6933510/91440380-ceb16400-e86e-11ea-9352-d164911774cf.png)

You can now close the terminal.

## Step 3: install Mozilla Firefox or Google Chrome
We need a modern browser to view Pluto notebooks with. Firefox and Chrome work best.

# Second time: _running Pluto, opening a notebook_
Repeat the following steps whenever you want to work on a homework assignment.

## Step 1: start Pluto

Start the Julia REPL, like you did during the setup. In the REPL, type:
```julia
julia> import Pluto; Pluto.run()
```

![image](https://user-images.githubusercontent.com/6933510/91441094-eb01d080-e86f-11ea-856f-e667fdd9b85c.png)

The terminal tells us to go to `http://localhost:1234/`. Let's open Firefox or Chrome and type that into the address bar.

![image](https://user-images.githubusercontent.com/6933510/91441391-6a8f9f80-e870-11ea-94d0-4ef91b4e2242.png)

> If you're curious about what a _Pluto notebook_ is, have a look at the **sample notebooks**. Samples 1, 2 and 6 are also useful to learn about some Julia programming basics.

## Step 2a: opening a notebook from the web

This is the main menu - here you can create new notebooks, or open existing ones. Our homework assignments will always be based on a _template notebook_, available in this github repository. To start from a template notebook on the web, you can _paste the URL into the blue box_ and press ENTER.

For example, homework 0 is available here: [/homework/homework00/hw0.jl](/homework/homework00/hw0.jl). Copy this link (right click -> Copy Link), and paste it into the box. Press ENTER, and select OK in the confirmation box.

![image](https://user-images.githubusercontent.com/6933510/91441968-6b750100-e871-11ea-974e-3a6dfd80234a.png)

**The first thing we want to do is to save the notebook somewhere on our computer.** 

## Step 2b: opening an existing notebook file
When you launch Pluto for the second time, your recent notebooks will appear in the main menu. You can click on them to continue where you left off.

If you want to run a local notebook file that you have not opened before, then you need to enter its _full path_ into the blue box in the main menu. More on finding full paths in step 3.

## Step 3: saving a notebook
We first need a folder to save our homework in. Open your file explorer and create one. 

Next, we need to know the _absolute path_ of that folder. Here's how you do that in [Windows](https://www.top-password.com/blog/copy-full-path-of-a-folder-file-in-windows/), [MacOS](https://www.josharcher.uk/code/find-path-to-folder-on-mac/) and [Ubuntu]().

For example, you might have:

`C:\Users\fonsi\Documents\18S191_assignments\` on Windows

`/Users/fonsi/Documents/18S191_assignments/` on MacOS

`/home/fonsi/Documents/18S191_assignments/` on Ubuntu

Now that we know the absolute path, go back to your Pluto notebook, and at the top of the page, click on _"Save notebook..."_. 

![image](https://user-images.githubusercontent.com/6933510/91444741-77fb5880-e875-11ea-8f6b-02c1c319e7f3.png)

This is where you type the **new path+filename for your notebook**:

![image](https://user-images.githubusercontent.com/6933510/91444565-366aad80-e875-11ea-8ed6-1265ded78f11.png)

Click _Choose_.

## Step 4: sharing a notebook

After working on your notebook (your code is autosaved when you run it), you will find your notebook file in the folder we created in step 3. This the file that you can share with other, or submit as your homework assignment to canvas.
