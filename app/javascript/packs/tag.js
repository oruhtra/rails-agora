const urlstring = window.location.href;
const selectedtags = getParameterByName("query", urlstring);
const arraySelectedtags = getParameterByName("query", urlstring).split(" ");

// get selected tags from query in params
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

// adding class "tag-s" to all selected tags
function showSelectedTag() {
  arraySelectedtags.forEach(function(tag) {
    if (document.getElementById(tag) !== null) {
        document.getElementById(tag).classList.add("tag-s");
    }
  });
}

// Ajout de tagName si non inclut ou suppression tagname si inclut
function generateTagsName(tagName) {
  if (arraySelectedtags.includes(tagName)) {
    return arraySelectedtags.filter(word => word !== tagName);
  } else {
    return arraySelectedtags.push(tagName);
  }
}


function listentag() {
  //  get tags to listen to
  const tags = document.querySelectorAll(".listentag");
  // adding click listener to each tag
  tags.forEach(tag => tag.addEventListener("click", (event) => {
  event.preventDefault();
  // return the name of the tag
  const tagName = event.currentTarget.innerHTML;
  console.log(tagName);
  const allTagName = generateTagsName(tagName);
  console.log(allTagName);
  // submit the form with the tag name
  const searchInput = document.querySelector(".searchtag #query");

  searchInput.value = AllTagName.join(` `) ;
  event.currentTarget.classList.toggle("tag-s");

  const form = document.querySelector(".searchtag form");
  // form.submit();

}));
}

showSelectedTag();
listentag();



// 2. ajouter dsans searchinput les selected tag
// 3. si declick
