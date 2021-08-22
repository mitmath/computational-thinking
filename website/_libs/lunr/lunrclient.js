// This file and its minified version is adapted from https://github.com/BLE-LTER/Lunr-Index-and-Search-for-Static-Sites which is unlicensed.
//

"use strict";

var LUNR_CONFIG = {
    "resultsElementId": "searchResults",  // Element to contain results
    "countElementId": "resultCount"       // Element showing number of results
};


// Get URL arguments
function getParameterByName(name) {
    var url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return "";
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}


// Parse search results into HTML
function parseLunrResults(results) {
    var html = [];
    for (var i = 0; i < results.length; i++) {
        var id = results[i]["ref"];
        var item = PREVIEW_LOOKUP[id]
        var title = item["t"];
        var preview = item["p"];
        var link = item["l"].replace("__site/", "");
        var result = ('<li><span class="result-title"><a href="' + link + '">'
                    + title + '</a></span>');
        html.push(result);
    }
    if (html.length) {
        html.join("");
        return '<ul>'+html+'</ul>'
    }
    else {
        return "";
    }
}


function escapeHtml(unsafe) {
    return unsafe
         .replace(/&/g, "&amp;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;")
         .replace(/'/g, "&#039;");
}


function showResultCount(total) {
    var element = document.getElementById(LUNR_CONFIG["countElementId"])
    if (element !== null) {
        element.innerHTML = total + ".";
    }
}


function searchLunr(query) {
    var idx = lunr.Index.load(LUNR_DATA);
    // Write results to page
    var results = idx.search(query);
    var resultHtml = parseLunrResults(results);
    var elementId = LUNR_CONFIG["resultsElementId"];
    document.getElementById(elementId).innerHTML = resultHtml;
    // Write the number of results
    showResultCount(results.length);
}


// When the window loads, read query parameters and perform search
window.onload = function() {
    var query = getParameterByName("q");
    if (query != "" && query != null) {
        document.forms.lunrSearchForm.q.value = query;
        searchLunr(query);
    } else {
        // empty query: show 0 results (no query)
        showResultCount("0 (empty query)");
    }
    document.getElementById("focus").focus();
};