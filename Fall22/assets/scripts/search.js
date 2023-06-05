const root_href = document.head.querySelector("link[rel='root']").getAttribute("href")

const minby = (arr, fn) => arr.reduce((a, b) => (fn(a) < fn(b) ? a : b))
const maxby = (arr, fn) => arr.reduce((a, b) => (fn(a) > fn(b) ? a : b))
const range = (length) => [...Array(length).keys()]

const sortby = (arr, fn) => arr.sort((a, b) => fn(a) - fn(b))

const setup_search_index = async () => {
    const search_data_href = document.head.querySelector("link[rel='pp-search-data']").getAttribute("href")
    console.log(search_data_href)

    const search_data = await (await fetch(search_data_href)).json()
    window.search_data = search_data

    console.log(search_data)

    // create a search bar powered by lunr
    // const search_bar = document.createElement('div')
    // search_bar.id = 'search-bar'
    // search_bar.innerHTML = `
    //     <input type="text" id="search-input" placeholder="Search...">
    //     <div id="search-results"></div>
    // `
    // document.body.appendChild(search_bar)

    // create a search index
    const before = Date.now()
    const search_index = window.lunr(function () {
        this.ref("url")

        this.field("title", { boost: 10 })
        this.field("tags", { boost: 5 })
        this.field("text")
        this.metadataWhitelist = ["position"]
        search_data.forEach(function (doc) {
            this.add(doc)
        }, this)
    })
    const after = Date.now()
    console.info(`lunr: Indexing ${search_data.length} documents took ${after - before}ms`)
    window.search_index = search_index

    return { search_data, search_index }
}

const excerpt_length = 200
const excerpt_padding = 50

const init_search = async () => {
    const query = new URLSearchParams(window.location.search).get("q")
    console.warn({ query })

    document.querySelector(".search-bar.big input").value = query

    const { search_data, search_index } = await setup_search_index()

    if (query) {
        const results = search_index.search(query)
        console.log(results)

        const search_results = document.getElementById("search-results")

        if (results.length !== 0) {
            search_results.innerHTML = ""
            results.forEach((result) => {
                const { url, title, tags, text } = search_data.find((doc) => doc.url === result.ref)
                const result_div = document.createElement("a")
                result_div.classList.add("search-result")
                result_div.innerHTML = `
                    <h3 class="title"></h3>
                    <p class="snippet"></p>
                    <p class="tags"></p>
                `
                console.log(root_href)
                result_div.querySelector(".title").innerText = title
                result_div.href = new URL(url, new URL(root_href, window.location.href)).href
                result_div.querySelector(".tags").innerText = tags.join(", ")
                result_div.querySelector(".snippet").innerText = text.substring(0, excerpt_length) + "..."

                const text_match_positions = Object.values(result?.matchData?.metadata ?? {})
                    .flatMap((z) => z?.text?.position ?? [])
                    .sort(([a, _a], [b, _b]) => a - b)
                const title_match_positions = Object.values(result?.matchData?.metadata ?? {})
                    .flatMap((z) => z?.title?.position ?? [])
                    .sort(([a, _a], [b, _b]) => a - b)

                console.error(title_match_positions)
                if (title_match_positions.length > 0) {
                    const strong_el = document.createElement("strong")
                    strong_el.innerText = title
                    result_div.querySelector(".title").innerHTML = ``
                    result_div.querySelector(".title").appendChild(strong_el)
                }

                if (text_match_positions.length > 0) {
                    // console.log(text_match_positions)
                    // console.log(find_longest_run(text_match_positions, 50))
                    // console.log(find_longest_run(text_match_positions, 100))
                    // console.log(find_longest_run(text_match_positions, 200))
                    // console.log(find_longest_run(text_match_positions, 300))
                    // console.log(find_longest_run(text_match_positions, 400))

                    const [start_index, num_matches] = find_longest_run(text_match_positions, excerpt_length)

                    const excerpt_start = text_match_positions[start_index][0]
                    const excerpt_end = excerpt_start + excerpt_length

                    const highlighted_ranges = text_match_positions.slice(start_index, start_index + num_matches)

                    const elements = highlighted_ranges.flatMap(([h_start, h_length], i) => {
                        const h_end = h_start + h_length
                        const word = text.slice(h_start, h_end)
                        const filler = text.slice(h_end, highlighted_ranges[i + 1]?.[0] ?? excerpt_end)
                        const word_el = document.createElement("strong")
                        word_el.innerText = word
                        return [word_el, filler]
                    })

                    const snippet_p = result_div.querySelector(".snippet")
                    snippet_p.innerHTML = ``
                    ;["...", text.slice(excerpt_start - excerpt_padding, excerpt_start).trimStart(), ...elements, "..."].forEach((el) => snippet_p.append(el))
                }

                // text_match_positions.slice(start_index, start_index + num_matches).forEach(([start, length]) => {

                search_results.appendChild(result_div)
            })
        } else {
            search_results.innerText = `No results found for "${query}"`
        }
    }
}

const count = (arr, fn) => arr.reduce((a, b) => fn(a) + fn(b), 0)

const find_longest_run = (/** @type{Array<[number, number]>} */ positions, max_dist) => {
    const legal_run_size = (start_index) =>
        positions.slice(start_index).filter(([start, length]) => start + length < positions[start_index][0] + max_dist).length

    console.warn(range(positions.length).map(legal_run_size))

    const best_start = maxby(range(positions.length), legal_run_size)
    const best_length = legal_run_size(best_start)
    return [best_start, best_length]
}

window.init_search = init_search
