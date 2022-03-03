// ==UserScript==
// @name     youtube filter
// @version  1
// @grant    none
// @include  *youtube.com/feed/subscriptions*
// ==/UserScript==

blacklist = {
    "The Escapist": /(.*\| (Slightly Post-War.*|Post-3MR Stream|Today We Play|The Escapist Show|Slightly Civil War|Stream Archive|Livestream|The Big Picture|Escape to the Movies|Post-ZP Stream|The Joy of Gaming).*|Every .... Zero Punctuation with.*|Yahtzee and Kess play a thing|Today We Try.*)/,
    "tinseltown": /.*\| Tinseltalk/,
    "Robert Hofmann": /(Neu auf (Amazon Prime|Netflix).*|.* - (Kopfkino|FILM NEWS)|.*Verlosung$|^Q\s*&\s*A.*)/,
    //"Maxon": /(3D Motion Show .*|.*NAB.*|.*The 3D and Motion Design Show.*)/,
}

whitelist = {
    "tagesschau": /^tagesschau.*/,
    "gTV_DE": /.*FIRSTS.*/,
    "ZDFheute Nachrichten": /.*Inside PolitiX.*/,
}


const callback = function(mutationsList, observer) {
    for(var mutation of mutationsList)
        for (var node of mutation.addedNodes)
            filtervids(node)
};


function filtervids(root)
{
    var vids = root.getElementsByTagName("ytd-grid-video-renderer")
    for (var v of vids)
    {
        var title = v.querySelector("[id=video-title]").textContent
        var channel = v.querySelector("[id=channel-name]").getElementsByTagName("A")[0].textContent

        if ((channel in whitelist && title.match(whitelist[channel]) == null) || (channel in blacklist && title.match(blacklist[channel]) != null))
        {
            console.log("hide: " + title)
            v.style.display = "none"
        }
    }
}


function main(contents)
{
    const observer = new MutationObserver(callback);
    observer.observe(contents, { attributes: false, childList: true, subtree: true });
    filtervids(document)
}


// Wait until contents node exists, then run main()
var checkExist = setInterval(function() {
    // var contents = document.getElementsByTagName("ytd-section-list-renderer")[0].querySelector("[id=contents]")
    var contents = document.getElementById("contents")
    if (contents)
    {
        main(contents)
        clearInterval(checkExist);
    }
}, 100); // check every 100ms
