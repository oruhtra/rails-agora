
function createMasonryGrid() {
  var grid = document.getElementById('masonry-container');
  var msnry = new Masonry( grid, {
    // options
    itemSelector: '.box',
    columnWidth: 40,
    isFitWidth: true
  });

  tagsListen(msnry, grid);
}

function tagsListen(msnry, grid){
  let selectedTags = [];
  const tagsBar = document.getElementById("tags-bar");
  const cards = document.querySelectorAll(".box");

  tagsBar.addEventListener("click", (event) => {

    if(event.target && event.target.nodeName == "I") {
    // List item found!  Output the ID!
      const tagId = event.target.id;
      if (!selectedTags.includes(tagId)) {
        selectedTags.push(tagId);
        console.log(selectedTags);
        removeCards(cards, tagId, msnry);
      } else {
        selectedTags = selectedTags.filter(tag => tag !== tagId);
        console.log(selectedTags);
        addCards(cards, tagId, msnry, grid, selectedTags);
      }
    }

  });

}

function removeCards(cards, tagId, msnry) {

        cards.forEach(card => {
          const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');

          if (!cardTags.includes(tagId)){
            msnry.remove(card);
            msnry.layout();
          }
        });
}

function addCards(cards, tagId, msnry, grid, selectedTags) {
        var fragment = document.createDocumentFragment();
        var elems = [];
        cards.forEach(card => {
          const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');
          if (!cardTags.includes(tagId) && arrayContainsArray (cardTags, selectedTags)){
            fragment.appendChild(card);
            elems.push(card);
          }
        });
        // append elements to container
        grid.appendChild(fragment);
        // add and lay out newly appended elements
        msnry.appended(elems);
        msnry.layout();
}

function arrayContainsArray(superset, subset) {
  return subset.every(function (value) {
    return (superset.indexOf(value) >= 0);
  });
}


if (document.getElementById('masonry-container')) {
  createMasonryGrid();
}
