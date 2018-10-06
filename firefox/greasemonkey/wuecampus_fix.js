// ==UserScript==
// @name     wuecampus fix
// @namespace   https://wuecampus2.uni-wuerzburg.de
// @include     *wuecampus2.uni-wuerzburg.de*
// @version  1
// @grant    none
// ==/UserScript==

function remove(elem, parent = null)
{
  var containers = (parent ? parent : document).getElementsByClassName(elem)
	while (containers.length > 0)
  	containers[0].parentNode.removeChild(containers[0])
}

function removeandmove(elem, parent = null)
{
  var containers = (parent ? parent : document).getElementsByClassName(elem)
	while (containers.length > 0)
  {
    c = containers[0]
    while (c.children.length > 0)
      c.parentNode.appendChild(c.children[0])
    c.parentNode.removeChild(c)
  }
}

// course list (front page, catalogue)
var parent = document.getElementById("category-course-list");
if (parent)
{
  remove("courseimagecontainer", parent)
  remove("course-summary4", parent)
  removeandmove("class-box4", parent)
  removeandmove("col-md-4", parent)
  removeandmove("row", parent)
}

// open links in new tab
for (var i of document.getElementsByClassName("resourceworkaround"))
  i.getElementsByTagName("a")[0]["onclick"] = ""
for (var i of document.getElementsByClassName("resource"))
{
  var a = i.getElementsByTagName("a")[0]
  if (a)
  {
    a["onclick"] = ""
    a["href"] += "&redirect=1"
  }
}

// dashboard / my courses
var parent = document.getElementById("myoverview_courses_view");
if (parent)
{
  for (var i of parent.getElementsByClassName("courses-view-course-item"))
    i.removeChild(i.getElementsByTagName("a")[0])

  for (var i of parent.getElementsByClassName("card-deck"))
    i.style["flex-direction"] = "column"

  remove("mr-2", parent)	// thumbnail
  remove("text-muted", parent)	// description
  //removeandmove("col-lg-6", parent)
  removeandmove("courses-view-course-item", parent)
  removeandmove("course-info-container", parent)
  removeandmove("media", parent)

  // remove paging
  var hidden = parent.getElementsByClassName("hidden")
  while (hidden.length > 0)
    hidden[0].classList.remove("hidden")

  for (var type of [ "in-progress", "past", "future" ])
  {
    var pager = document.getElementById("pb-for-" + type)
    if (pager)
      pager.parentNode.parentNode.removeChild(pager.parentNode)
  }
}
