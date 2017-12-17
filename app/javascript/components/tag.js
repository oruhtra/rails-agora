

// const urlstring = window.location.href;

// function generateParameters() {
//   const selectedtags = [];
//   document.querySelectorAll(".tag-s").forEach(tag => {
//     selectedtags.push(tag.id);
//   });
//   return selectedtags;
// }

// // Ajout de tagName si non inclut ou suppression tagname si inclut
// function updateTagsArray(tagArray, tagName) {
//   if (tagArray.includes(tagName)) {
//     return tagArray.filter(word => word !== tagName);
//   } else {
//     tagArray.push(tagName);
//     return tagArray;
//   }
// }

// // click on a tag => add or delete in query params
// function listentag() {
//   const selectedtags = generateParameters();
//   let allTagsName;
//   // let allTagName ;
//   //  get tags to listen to
//   const tags = document.querySelectorAll(".listentag");
//   // adding click listener to each tag

//   tags.forEach(tag => tag.addEventListener("click", (event) => {
//     event.preventDefault();
//     // get the name of the tag & add to existing tag array
//     allTagsName = updateTagsArray(selectedtags, event.currentTarget.id).join(" ");
//     // submit the form with all the tag names including the latest
//     document.querySelector(".searchtag #query").value = allTagsName;
//     document.querySelector(".searchtag form").submit();
//   }));

// }

// listentag();
