
function createMasonryGrid() {
  var grid = document.getElementById('masonry-container');
  var baseTags = document.querySelectorAll(".tag");
  var msnry = new Masonry( grid, {
    // options
    itemSelector: '.box',
    columnWidth: 40,
    isFitWidth: true
  });

  tagsListen(msnry, grid, baseTags);
}

function tagsListen(msnry, grid, baseTags){
  let selectedTags = [];
  const tagsBar = document.getElementById("tags-bar");
  const cards = document.querySelectorAll(".box");

  tagsBar.addEventListener("click", (event) => {

    if(event.target && event.target.nodeName == "I") {
    // List item found!
      const tagId = event.target.id;
      if (tagId === '') {
        restoreCards(cards, msnry, grid, selectedTags)
        selectedTags = [];
        tagsBar.innerHTML = baseTags;
      } else if (!selectedTags.includes(tagId)) {
        selectedTags.push(tagId);
        removeCards(cards, tagId, msnry, selectedTags);
      } else {
        selectedTags = selectedTags.filter(tag => tag !== tagId);
        if (selectedTags[0] == null) {
          tagsBar.innerHTML = baseTags;
        }
        addCards(cards, tagId, msnry, grid, selectedTags);
      }
    }
    console.log(selectedTags);

  });

}

function removeCards(cards, tagId, msnry, selectedTags) {
  var remainingCards = document.createDocumentFragment();
  cards.forEach(card => {
    const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');
    if (!cardTags.includes(tagId)){
      msnry.remove(card);
      msnry.layout();
    } else {
      remainingCards.appendChild(card.cloneNode(true));
    }
  });
  displayTags(selectedTags, remainingCards);
}

function addCards(cards, tagId, msnry, grid, selectedTags) {
  var fragment = document.createDocumentFragment();
  var remainingCards = document.createDocumentFragment();
  var elems = [];
  cards.forEach(card => {
    const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');

    if (!cardTags.includes(tagId) && arrayContainsArray (cardTags, selectedTags)){
      fragment.appendChild(card);
      elems.push(card);
    }

    if (arrayContainsArray (cardTags, selectedTags)) {
      remainingCards.appendChild(card.cloneNode(true));
    }
  });
  // append elements to container
  grid.appendChild(fragment);
  // add and lay out newly appended elements
  msnry.appended(elems);
  msnry.layout();
  displayTags(selectedTags, remainingCards);
}

function restoreCards(cards, msnry, grid, selectedTags) {
  var fragment = document.createDocumentFragment();
  var elems = [];
  cards.forEach(card => {
    const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');
    if (!arrayContainsArray (cardTags, selectedTags)){
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

function displayTags(selectedTags, remainingCards) {
  if (!selectedTags[0] == null) {
    const cards = remainingCards.querySelectorAll(".box");
    const tagsBar = document.getElementById("tags-bar");
    const tags = document.querySelectorAll(".tag");
    // get first tag
    const tag = tags[0];
    // remove tag-s class from tag
    if (tag.classList.contains(".tag-s")) {
      tag.classList.remove(".tag-s")
    }
    // create fragment to put all tags in
    var fragment = document.createDocumentFragment();
    // add selected tags first
    selectedTags.forEach(t => {
      const tagClone = tag.cloneNode(true);
      tagClone.id = t;
      tagClone.innerHTML = t.replace(/_/gi, " ");
      tagClone.classList.add("tag-s");
      fragment.appendChild(tagClone);
    });
    // get peripheral tags
    const peripheralTags = getPeripheralTags(selectedTags, cards);
    // add peripheral tags next
    peripheralTags.forEach(t => {
      const tagClone = tag.cloneNode(true);
      tagClone.id = t;
      tagClone.innerHTML = t.replace(/_/gi, " ");
      fragment.appendChild(tagClone);
    });
    // replace tagsBar HTML by fragment
    tagsBar.innerHTML = "";
    tagsBar.appendChild(fragment);
  }
}

function getPeripheralTags(selectedTags, cards) {
  let peripheralTagsObj = {};
  cards.forEach(card => {
    const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ').filter(tag => tag !== '');
    cardTags.forEach(tag => {
      if (!peripheralTagsObj[tag]) {
        peripheralTagsObj[tag] = 1;
      } else {
        peripheralTagsObj[tag] += 1;
      }
    });
  });

  let peripheralTags = Object.keys(peripheralTagsObj).sort(function(a, b) {
    return peripheralTagsObj[b] - peripheralTagsObj[a]
  })

  selectedTags.forEach(t => {
    peripheralTags = peripheralTags.filter(tag => tag !== t);
  })

  return peripheralTags
}


function arrayContainsArray(superset, subset) {
  return subset.every(function (value) {
    return (superset.indexOf(value) >= 0);
  });
}

export { createMasonryGrid };
