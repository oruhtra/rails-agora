const urlstring = window.location.href;

// get selected tags from query in params
// function getParameterByName(name, url) {
//     if (!url) url = window.location.href;
//     name = name.replace(/[\[\]]/g, "\\$&");
//     var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
//         results = regex.exec(url);
//     if (!results) return null;
//     if (!results[2]) return '';
//     return decodeURIComponent(results[2].replace(/\+/g, " "));
// }

function generateParameters() {
  const selectedtags = [];
  document.querySelectorAll(".tag-s").forEach(tag => {
    selectedtags.push(tag.text);
  });
  console.log(selectedtags);
  return selectedtags;
}

// adding class "tag-s" to all selected tags
// function showSelectedTag() {
//   selectedtags.split(" ").forEach(function(tag) {
//     if (document.getElementById(tag) !== null) {
//         document.getElementById(tag).classList.add("tag-s");
//     }
//   });
// }

// Ajout de tagName si non inclut ou suppression tagname si inclut
function updateTagsArray(tagArray, tagName) {
  if (tagArray.includes(tagName)) {
    return tagArray.filter(word => word !== tagName);
  } else {
    tagArray.push(tagName);
    return tagArray;
  }
}

// click on a tag => add or delete in query params
function listentag() {
  const selectedtags = generateParameters();
  let allTagsName;
  // let allTagName ;
  //  get tags to listen to
  const tags = document.querySelectorAll(".listentag");
  // adding click listener to each tag
  tags.forEach(tag => tag.addEventListener("click", (event) => {
    event.preventDefault();
    // get the name of the tag & add to existing tag array
    allTagsName = updateTagsArray(selectedtags, event.currentTarget.innerHTML).join(" ");
    // submit the form with all the tag names including the latest
    document.querySelector(".searchtag #query").value = allTagsName;
    document.querySelector(".searchtag form").submit();
  }));
}

// if (selectedtags !== null) {
//     showSelectedTag();
// }

listentag();
