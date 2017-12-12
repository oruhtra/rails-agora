// remarqeu : mettre à jour avecle type de nom des tag ; attention espace non géré ici
// Pour le search bar : voir code dans select2.js

function generateParameters() {
  const selectedtags = [];
  document.querySelectorAll(".tag-s").forEach(tag => {
    selectedtags.push(tag.id);
  });
  return selectedtags;
}

function listenbatchtag() {
  const tags = document.querySelectorAll(".listenbatchtag");
  // adding click listener to each tag
  tags.forEach(tag => tag.addEventListener("click", (event) => {
    event.preventDefault();
    tag.classList.toggle("tag-s");
    tag.classList.toggle("hidden");
    const selectedtags = generateParameters();
    const allTagsName = selectedtags.join(" ");
    // submit the form with all the tag names including the latest
    document.querySelector(".batch_tags").value = allTagsName;
  }));
}

export {listenbatchtag} ;

