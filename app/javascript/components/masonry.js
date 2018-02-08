import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import { myDatepicker } from "../components/air_datepicker";
import { showModalShowDocument } from "../components/modal_show_document";

function createMasonryGrid() {
  var grid = document.getElementById('masonry-container');
  var baseTags = document.querySelectorAll(".tag");
  var tagsBar = document.getElementById("tags-bar");
  var cards = document.querySelectorAll(".box");
  var selectedTags = [];
  var peripheralTags = [];
  var screenSize = $(window).width();

  if (screenSize < 768) {
    var masonryColumnWidth = 10;
  } else {
    var masonryColumnWidth = 40
  }

  var msnry = new Masonry( grid, {
    // options
    itemSelector: '.box',
    columnWidth: masonryColumnWidth,
    isFitWidth: true
  });

  reloadGridAfterFileUpload();
  addTagsListener();
  // searchListen ();
  getPeripheralTags(cards);
  filterDateTag();
  showModalShowDocument();

  function reloadGridAfterFileUpload() {
      document.querySelector('.reload-masonry-grid').addEventListener('click', (e) => {
        document.querySelectorAll('.document-new').forEach(card => {
          // When multiple docs are dropped at the same time the function is called multiple times
          // and the same documents are sent several times (ex. if 3 docs dropped : 1st call only 1st doc, then 2nd call 1st and 2nd doc etc.)
          // hence the need to make sure that elements are added only once to the grid
          // First we get all the element already added to the grid (those on which we added the class doc-new-prepended)
          const newCards = document.querySelectorAll('.document-new-prepended');
          const newCardsIds = [];
          // get all their Ids and store them in newCardsIds
          newCards.forEach(newCard =>{
            newCardsIds.push(newCard.id.match(/(\S*)@(.+)/)[1]);
          })
          // for each card sent by the server through AJAX check wether it has already been added to the grid
          // by checking its "id" vs the array of added Ids
          if (!newCardsIds.includes(card.id.match(/(\S*)@(.+)/)[1])) {
            // if document has not been added, duplicate it, delete it, and add the duplicate to the grid
            // and then to the masonry grid, and remove the hidden + document-new classes and add a document-new-prepended
            // to track it for the next iteration
            const c = card.cloneNode(true);
            card.remove();
            c.classList.remove('document-new');
            c.classList.add('document-new-prepended');
            // prepend the newly loaded card in the grid
            grid.prepend(c);
            // wait for the DOM to have calculated the image size before un-hidding it and adding it to the masonry grid
            setTimeout(function(){
              c.classList.remove('hidden');
              // add and lay out newly appended elements
              msnry.prepended(c);
              msnry.layout();
            }, 500)
          } else {
            // if document has already been added then just remove it
            card.remove();
          }

        });
        showModalShowDocument();
    })
  };

  function addTagsListener(){
    tagsBar.addEventListener("click", (event) => {

      if(event.target && event.target.nodeName == "I") {
      // List item found!
        const tagId = event.target.id;
        updateTagsAndCards(tagId)
        tagsBar.scrollTo(0, 0);
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
    // clearSelect2Search();
    filterDateTag();
    console.log(peripheralTags);
  }

  // REMOVED BECAUSE SEARCH BAR WAS REMOVED
  // function searchListen () {
  //   $('.select2').on('select2:select', function (e) {
  //     const data = $('#dropdowntag').select2('data');
  //     const tagId = data[0]["id"];
  //     restoreCards()
  //     selectedTags.length = 0 ;
  //     restoreTags();
  //     selectedTags.push(tagId);
  //     removeCardsAndChangeTags(tagId);
  //     showClearAll()
  //   });
  // }

  // function clearSelect2Search() {
  //   $('#dropdowntag').val(null).trigger('change');
  // }

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
