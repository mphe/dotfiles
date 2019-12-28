// ==UserScript==
// @name     youtube filter
// @version  1
// @grant    none
// @include  *youtube.com/feed/subscriptions*
// ==/UserScript==

blacklist = {
    "Escapist": /(.*\| (The Big Picture|Review in 3 Minutes|Escape to the Movies|Post-ZP Stream).*|Every .... Zero Punctuation with.*)/,
    "tinseltown": /.*\| Tinseltalk/,
    "Robert Hofmann": /(Neu auf (Amazon Prime|Netflix).*|.* - (Kopfkino|FILM NEWS)|.* - .*Verlosung$)/,
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

        if (channel in blacklist && title.match(blacklist[channel]) != null)
        {
            console.log("hide: " + title)
            v.style.display = "none"
        }
    }
}

const observer = new MutationObserver(callback);
var contents = document.getElementsByTagName("ytd-section-list-renderer")[0].querySelector("[id=contents]")
observer.observe(contents, { attributes: false, childList: true, subtree: false });

//observer.disconnect();

filtervids(document)

