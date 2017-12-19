import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';

function createMasonryGrid() {

  var grid = document.getElementById('masonry-container');
  var baseTags = document.querySelectorAll(".tag");
  var tagsBar = document.getElementById("tags-bar");
  var cards = document.querySelectorAll(".box");
  var selectedTags = [];

  var msnry = new Masonry( grid, {
    // options
    itemSelector: '.box',
    columnWidth: 40,
    isFitWidth: true
  });

  tagsListen();
  searchListen ();


  function tagsListen(){
    tagsBar.addEventListener("click", (event) => {

      if(event.target && event.target.nodeName == "I") {
      // List item found!
        const tagId = event.target.id;
        if (tagId === '') {

          restoreCards();
          selectedTags.length = 0 ;
          restoreTags();
          clearSelect2Search();

        } else if (!selectedTags.includes(tagId)) {

          selectedTags.push(tagId);
          removeCardsAndChangeTags(tagId);
          clearSelect2Search();

        } else {

          selectedTags = selectedTags.filter(tag => tag !== tagId);

          if (typeof selectedTags[0] === 'undefined') {
            restoreTags()
          }

          addCardsAndChangeTags(tagId);
          clearSelect2Search();

        }
      }
    });

  }

  function searchListen () {
    $('.select2').on('select2:select', function (e) {
      const data = $('#dropdowntag').select2('data');
      const tagId = data[0]["id"];
      restoreCards()
      selectedTags.length = 0 ;
      restoreTags();
      selectedTags.push(tagId);
      removeCardsAndChangeTags(tagId);
    });
  }

  function clearSelect2Search() {
    $('#dropdowntag').val(null).trigger('change');
  }

  function removeCardsAndChangeTags(tagId) {
    var remainingCards = document.createDocumentFragment();
    cards.forEach(card => {
      const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');
      if (!cardTags.includes(tagId)){
        msnry.remove(card);
        msnry.layout();
      } else if (arrayContainsArray (cardTags, selectedTags)){
        remainingCards.appendChild(card.cloneNode(true));
      }
    });
    displayTags(remainingCards);
  }

  function addCardsAndChangeTags(tagId) {
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
    displayTags(remainingCards);
  }

  function restoreCards() {
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

  function displayTags(remainingCards) {
    if (typeof selectedTags[0] !== 'undefined') {
      const remainingCardsArray = remainingCards.querySelectorAll(".box");
      const tagsBar = document.getElementById("tags-bar");
      const tags = document.querySelectorAll(".tag");
      // get first tag
      const tag = tags[0];
      // remove tag-s class from tag
      if (tag.classList.contains("tag-s")) {
        tag.classList.remove("tag-s")
      }
      // create fragment to put all tags in
      const fragment = document.createDocumentFragment();
      // add selected tags first
      selectedTags.forEach(t => {
        const tagClone = tag.cloneNode(true);
        tagClone.id = t;
        tagClone.innerHTML = t.replace(/_/gi, " ");
        tagClone.classList.add("tag-s");
        fragment.appendChild(tagClone);
      });
      // get peripheral tags
      const peripheralTags = getPeripheralTags(remainingCardsArray);
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

  function getPeripheralTags(remainingCardsArray) {
    let peripheralTagsObj = {};
    remainingCardsArray.forEach(card => {
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

  function restoreTags() {
    const fragment = document.createDocumentFragment();
    baseTags.forEach(t => {
      fragment.appendChild(t);
    });
    tagsBar.innerHTML = "";
    tagsBar.appendChild(fragment);
  }


  function arrayContainsArray(superset, subset) {
    return subset.every(function (value) {
      return (superset.indexOf(value) >= 0);
    });
  }

}


export { createMasonryGrid };
