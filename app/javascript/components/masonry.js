import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import { myDatepicker } from "../components/air_datepicker";

function createMasonryGrid() {
  var grid = document.getElementById('masonry-container');
  var baseTags = document.querySelectorAll(".tag");
  var tagsBar = document.getElementById("tags-bar");
  var cards = document.querySelectorAll(".box");
  var selectedTags = [];
  var peripheralTags = [];

  var msnry = new Masonry( grid, {
    // options
    itemSelector: '.box',
    columnWidth: 30,
    isFitWidth: true
  });

  reloadGridAfterFileUpload();
  addTagsListener();
  searchListen ();
  getPeripheralTags(cards);
  filterDateTag();


  function reloadGridAfterFileUpload() {
      document.querySelector('.reload-masonry-grid').addEventListener('click', (e) => {
      cards = document.querySelectorAll(".box");
      grid = document.getElementById('masonry-container');
      msnry = new Masonry( grid, {
        // options
        itemSelector: '.box',
        columnWidth: 40,
        isFitWidth: true
      });
    })
  };

  function addTagsListener(){
    tagsBar.addEventListener("click", (event) => {

      if(event.target && event.target.nodeName == "I") {
      // List item found!
        const tagId = event.target.id;
        updateTagsAndCards(tagId)
      }

    });

  }

  function updateTagsAndCards(tagId) {
    if (!selectedTags.includes(tagId)) {

      selectedTags.push(tagId);
      removeCardsAndChangeTags(tagId);
      showClearAll();

    } else {

      selectedTags = selectedTags.filter(tag => tag !== tagId);

      if (typeof selectedTags[0] === 'undefined') {
        restoreTags();
        hideClearAll();
        getPeripheralTags(cards);
      }

      addCardsAndChangeTags(tagId);

    }
    clearSelect2Search();
    filterDateTag();
    console.log(peripheralTags);
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
      showClearAll()
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
      } else if (arrayContainsArray (cardTags, selectedTags)){
        remainingCards.appendChild(card.cloneNode(true));
      }
    });
    msnry.layout();
    displayTags(remainingCards);
  }

  function addCardsAndChangeTags(tagId) {
    var fragment = document.createDocumentFragment();
    var remainingCards = document.createDocumentFragment();
    var elems = [];
    cards.forEach(card => {
      const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');

      if (!cardTags.includes(tagId) && arrayContainsArray (cardTags, selectedTags)){
        // fragment.appendChild(card);
        // elems.push(card);
        // append elements to container
        grid.appendChild(card);
        // add and lay out newly appended elements
        msnry.appended(card);
        msnry.layout();
      }

      if (arrayContainsArray (cardTags, selectedTags)) {
        remainingCards.appendChild(card.cloneNode(true));
      }
    });
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
      // update peripheral tags
      getPeripheralTags(remainingCardsArray);
      // add peripheral tags next but remove DATE TAGS => tags that match the regexp \[A-Z][a-z]{2}_\d{4}\)
      peripheralTags.forEach(t => {
        if (!t.match(/[A-Z][a-z]{2}_\d{4}/)) {
          const tagClone = tag.cloneNode(true);
          tagClone.id = t;
          tagClone.innerHTML = t.replace(/_/gi, " ");
          fragment.appendChild(tagClone);
        }
      });
      // replace tagsBar HTML by fragment
      tagsBar.innerHTML = "";
      tagsBar.appendChild(fragment);
    }
  }

  function getPeripheralTags(remainingCardsArray) {
    peripheralTags.length = 0;
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

    let peripheralTagsArray = Object.keys(peripheralTagsObj).sort(function(a, b) {
      return peripheralTagsObj[b] - peripheralTagsObj[a]
    })

    selectedTags.forEach(t => {
      peripheralTagsArray = peripheralTagsArray.filter(tag => tag !== t);
    })

    peripheralTagsArray.forEach(t => {
      peripheralTags.push(t);
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

  function hideClearAll() {
    const clearTags = document.querySelector(".clear-tags");
    if (!clearTags.classList.contains("hidden")) {
      clearTags.classList.add("hidden");
    }
  }

  function showClearAll() {
    const clearTags = document.querySelector(".clear-tags");
    if (clearTags.classList.contains("hidden")) {
      clearTags.classList.remove("hidden");
    }
  }

  function arrayContainsArray(superset, subset) {
    return subset.every(function (value) {
      return (superset.indexOf(value) >= 0);
    });
  }

  function filterDateTag() {
    var onSelectFunction = function(formattedDate, date, dp) {
      // No action when clearing the date picker => clearing the date picker calls this function with a date = ''
      if (date !== '') {
        const d = new Date(date);
        const options = {month: "short", year: "numeric"};
        updateTagsAndCards(d.toLocaleDateString("en-US", options).replace(/\s/gi, "_"))
      }
    }
    var onRenderCellFunction = function(date, cellType) {
      const d = new Date(date);
      const options = {month: "short", year: "numeric"};
      return {disabled: !peripheralTags.includes(d.toLocaleDateString("en-US", options).replace(/\s/gi, "_"))}
    }
    myDatepicker(onSelectFunction, onRenderCellFunction);
  }

}


export { createMasonryGrid };
