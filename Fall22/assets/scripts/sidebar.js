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

console.info("zzzz")
console.info(layout)
