// ==UserScript==
// @name     youtube filter
// @version  1
// @grant    none
// @include  *youtube.com/feed/subscriptions*
// ==/UserScript==

// Config -------------

const blacklist = {
    "channel": /^.*something.*/,
}

const whitelist = {
    "channel": /^.*something.*/,
}

// End config -------------


const callback = function(mutationsList, _observer) {
    for(var mutation of mutationsList)
        for (var node of mutation.addedNodes)
            if (node.nodeType == Node.ELEMENT_NODE)
                filtervids(node)
};


function filtervids(root)
{
    // Grid structure (css excluded):
    // <ytd-rich-grid-row>
    //     <div id="contents">
    //		     <ytd-rich-item-renderer> ... </ytd-rich-item-renderer>
    //		 </div>
    // </ytd-rich-grid-row>
    // ...

    var vids = root.getElementsByTagName("ytd-rich-item-renderer")

    if (vids.length == 0) {
        if (root.tagName.toLowerCase() == "ytd-rich-item-renderer")
            vids = [ root ]
        else
            return
    }

    // Filter videos and collect their row elements
    for (var v of vids)
    {
        const title_node = v.querySelector("[id=video-title]")
        const channel_node = v.querySelector("[id=channel-name]")

        if (title_node === null || channel_node === null)
            continue

        const title = title_node.textContent
        const channel = channel_node.getElementsByTagName("A")[0].textContent

        if ((channel in whitelist && title.match(whitelist[channel]) == null) || (channel in blacklist && title.match(blacklist[channel]) != null))
        {
            console.log("hide: " + title)
            v.style.display = "none"  // remove() doesn't work correctly for some reason
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
    var contents = document.getElementById("contents")
    if (contents) {
        clearInterval(checkExist);
        main(contents)
    }
}, 500); // check every 500ms
