import { myDatepicker } from "../components/air_datepicker";

function addTagsToMultipleDocuments() {
  var cards = document.querySelectorAll('.hover-card');
  var postTagsForm = document.getElementById('post-tags-form');
  var submitBatchTags = document.getElementById('submit-batch-tag');
  var tagFormInput = document.getElementById('tagname');
  var tagsWrapper = document.querySelector('.add-tags');
  var tagCreateForm = document.getElementById('new_tag');
  var selectedCards = [];

  function toggleCardToAddTags() {
    cards.forEach(card => {
      card.addEventListener('click', (event) => {
          const docId = event.currentTarget.id;

          if (!selectedCards.includes(docId)) {
            selectedCards.push(docId);

            const html = `<input name="document_to_tag_ids[]" class = "hidden" id="form-${docId}" value=${docId} />`;
            postTagsForm.insertAdjacentHTML("afterbegin", html);
            tagCreateForm.insertAdjacentHTML("afterbegin", html);

            card.classList.add('opacity-full');
          } else {
            selectedCards = selectedCards.filter(id => id !== docId);
            const html = document.querySelectorAll(`#form-${docId}`);
            html.forEach(node => {
              node.remove();
            })
            card.classList.remove('opacity-full');
          }

      })
    })
  }

  function addTagToForm() {
    tagsWrapper.addEventListener("click", (event) => {
      if(event.target && event.target.nodeName == "I") {
        if (typeof selectedCards[0] !== 'undefined') {
          const tagId = event.target.id;
          insertTagIDInForm(tagId);
        }
      }
    });
  }

  function insertTagIDInForm(tagId) {
    tagFormInput.value = tagId;
    submitBatchTags.click();
  }

  function addDateTag() {
    var block = function(formattedDate, date, dp) {
      if (typeof selectedCards[0] !== 'undefined') {
        insertTagIDInForm(date);
      }
    }
    myDatepicker(block);
  }

  function revealDocTypeAndSupplierTags() {
    var tagsFromSelectedCards = [];
    var macroCategoryTags = document.querySelectorAll(".macro_category");
    var docTypeTags = document.querySelectorAll(".doc_type");
    var supplierTags = document.querySelectorAll(".supplier");
    var allTags = document.querySelectorAll('.tag-link');

    function getTagsFromSelectedCards() {
      console.log('hy from getTagsFromSelectedCards');
      tagsFromSelectedCards.length = 0;
      document.querySelectorAll(".opacity-full").forEach(c => {
        const tags = c.querySelectorAll(".tag-small");
        tags.forEach(t => {
          tagsFromSelectedCards.push(t.id);
        });
      });
    }

    function highlightSelectedTags(tag = false) {
      console.log('hy from highlightSelectedTags');
      if (tag) {
        if (!tag.classList.contains('tag-s')) {
          tag.classList.add('tag-s');
        }
      } else {
        allTags.forEach(t => {
          if (tagsFromSelectedCards.includes(t.id)) {
            if (!t.classList.contains('tag-s')) {
              t.classList.add('tag-s');
            }
          } else {
            if (t.classList.contains('tag-s')) {
              t.classList.remove('tag-s');
            }
          }
        });
      }
    }

    function areAllTagsHidden(tags) {
      console.log('hy from areAllTagsHidden');
      let i = 0;
      tags.forEach(t => {
        if (t.classList.contains('hidden')) {
          i += 1;
        }
      })
      return i === tags.length
    }

    function toggleTagsContainerTitle() {
      console.log('hy from toggleTagsContainerTitle');
      const docTypeTitle = document.getElementById('tags-container-title-doc_type');
      const supplierTitle = document.getElementById('tags-container-title-supplier');
      if (areAllTagsHidden(docTypeTags)) {
        if (!docTypeTitle.classList.contains('hidden')) {
          docTypeTitle.classList.add('hidden');
        }
      } else {
        docTypeTitle.classList.remove('hidden')
      }
      if (areAllTagsHidden(supplierTags)) {
        if (!supplierTitle.classList.contains('hidden')) {
          supplierTitle.classList.add('hidden');
        }
      } else {
        supplierTitle.classList.remove('hidden')
      }
    }

    function verifyIfTagHasCategory(tagArray, cat = false) {
      console.log('hy from verifyIfTagHasCategory');
      let i = false
      if (cat) {
        i = tagArray.includes(cat)
      } else {
        tagsFromSelectedCards.forEach(t => {
          i = tagArray.includes(t) || i
        });
      }
      return i
    }

    function toggleTags() {
      console.log('hy from toggleTags');
      cards.forEach(card => {
        card.addEventListener('click', (event) => {
          getTagsFromSelectedCards();
          docTypeTags.forEach(t => {
            if (verifyIfTagHasCategory(t.parentElement.id.split(','))){
              t.classList.remove("hidden");
            } else {
              if (!t.classList.contains("hidden")) {
                t.classList.add("hidden");
              }
            }
          });
          highlightSelectedTags();
          toggleTagsContainerTitle()
        });
      });


        allTags.forEach(tag => {
          tag.addEventListener('click', (event) => {
            if (selectedCards.length > 0) {
              docTypeTags.forEach(t => {
                if (verifyIfTagHasCategory(t.parentElement.id.split(','), tag.id)){
                  t.classList.remove("hidden");
                }
              });
              highlightSelectedTags(tag);
              toggleTagsContainerTitle()
            }
          });
        });

    }

    toggleTags()
  }

  toggleCardToAddTags();
  addTagToForm();
  revealDocTypeAndSupplierTags();
  addDateTag();
}

export { addTagsToMultipleDocuments };
