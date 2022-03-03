// ==UserScript==
// @name     arch wiki non-mobile redirect
// @version  1
// @grant    none
// @include  *wiki.archlinux.org*
// ==/UserScript==
try {
    var url = document.location.toString();
    var updateUrl = updateQueryStringParameter(url, 'useskinversion', '1');
    if (url != updateUrl) {
        window.location = updateUrl;
    }
} catch (e) {}

function updateQueryStringParameter(uri, key, value) {
    var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
    var separator = uri.indexOf('?') !== -1 ? "&" : "?";
    if (uri.match(re)) {
        return uri.replace(re, '$1' + key + "=" + value + '$2');
    } else {
        return uri + separator + key + "=" + value;
    }
}
