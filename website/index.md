
# Introduction to Computational Thinking

Welcome to **MIT 18.S191 aka 6.S083 aka 22.S092**, **Spring 2021** edition!

~~~
<script type=module>
const span = document.querySelector("#yt-placeholder")
let announcer = "https://computational-thinking-youtube-link.netlify.app/"


const last = x => x[x.length-1]

const content = {current: ""}
const set_content = (x) => {
    if(x !== content.current){
        content.current = x
        span.innerHTML = x
    }
}

const update_content = async () => {

let data = await (await fetch(new URL("current_live_stream.json", announcer), {
    cache: "no-cache",
})).json()

if(data.show_livestream && data.url.trim().length > 0){

    let yt_url = new URL(data.url)
    let path = yt_url.pathname

    let video_id = ""
    if(path === "/watch") {
        video_id = yt_url.searchParams.get("v")
    } else if (yt_url.host === "youtu.be" || true) {
        video_id = last(yt_url.pathname.split("/"))
    }


    set_content(`
    
    <br>
    <br>
    <p class="live-label">Currently live</p>
    <br>
    <iframe width="100%" height="360" src="https://www.youtube.com/embed/${video_id}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
    
    <br>
    <br>
    `)



} else if(data.show_stay_tuned) {
    set_content(`<img style="display: block; width: 100%" src="assets/staytuned.png">
    
    <blockquote>The live stream is starting soon!</blockqoute>`)

    setTimeout(update_content, 3*1000)
} else {

    set_content(`<iframe width="100%" height="360" src="https://www.youtube.com/embed/videoseries?list=PLP8iPy9hna6T56GkMHEdSrjCCheNuEwI0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
    
    <blockquote>You can watch our previous live streams here 👆</blockqoute>`)

    setTimeout(update_content, 30*1000)
}




}

update_content()

</script>

<span id="yt-placeholder"></span>
    <hr>

~~~


\blurb{This is an introductory course on Computational Thinking. We use the [Julia programming language](http://www.julialang.org) to approach real-world problems in varied areas applying data analysis and computational and mathematical modeling.  In this class you will learn computer science, software, algorithms, applications, and mathematics as an integrated whole.}

We plan to include the following topics:

- Image analysis
- Machine learning
- Dynamics on networks
- Climate modeling


> See also the course repository [github.com/mitmath/18S191](https://github.com/mitmath/18S191).

> _**[What people are saying about the course!](/reviews/)**_

<!-- 

Please help edit the automatically-generated subtitles in the [lecture transcripts](https://drive.google.com/drive/folders/1ekXz8x78qnq3G-_MhOh6CYgFDbL2G6Vz)!
If you do so, please add punctuation, and please change the colour of the part you edited to a colour other than black, and different from the previous and next sections. -->

## Meet our staff
**Lecturers:** [Alan Edelman](http://math.mit.edu/~edelman), [David P. Sanders](http://sistemas.fciencias.unam.mx/~dsanders/), [Charles E. Leiserson](https://people.csail.mit.edu/cel/), [Henri F. Drake](https://hdrake.github.io/)

**Teaching assistants:** [Bola Malek]()

**Technical assistants:** [Fons van der Plas](), [Logan Kilpatrick](https://scholar.harvard.edu/logankilpatrick/home)

**Guest lecturers:** _to be announced_

## Introduction video from Fall 2020

{{youtube course-intro}}
