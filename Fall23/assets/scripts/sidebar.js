const sidebar = document.querySelector("#pages-sidebar")
const layout = document.querySelector("#pages-layout")
const navtoggle = document.querySelector("#toggle-nav")

document.querySelector("#toggle-nav").addEventListener("click", function (e) {
    console.log(e)
    layout.classList.toggle("pages_show_sidebar")
    e.stopPropagation()
})

window.addEventListener("click", function (e) {
    if (!sidebar.contains(e.target) && !navtoggle.contains(e.target)) {
        layout.classList.remove("pages_show_sidebar")
    }
})

document.querySelectorAll(".track-chooser select").forEach((trackSelect) => {
    const ontrack = () => {
        let track = trackSelect.value

        localStorage.setItem("chosen track", track)

        let lectures_homeworks = Array.from(sidebar.querySelectorAll(".lecture,.homework"))

        lectures_homeworks.forEach((el) => {
            let intrack = track === "" || el.classList.contains(`tag_track_${track}`) || el.classList.contains(`tag_welcome`)
            el.classList.toggle("not_in_track", !intrack)
        })
    }

    trackSelect.value = localStorage.getItem("chosen track")
    ontrack()
    trackSelect.addEventListener("change", ontrack)
})
