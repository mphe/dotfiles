// ==UserScript==
// @name     Godot english docs redirect
// @version  1
// @grant    none
// @include  *docs.godotengine.org/de/*
// ==/UserScript==
var url = window.location.href.replace("godotengine.org/de/", "godotengine.org/en/")
window.location.replace(url)
