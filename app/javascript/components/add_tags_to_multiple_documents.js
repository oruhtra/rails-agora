import { myDatepicker } from "../components/air_datepicker";

function addTagsToMultipleDocuments() {
  var cards = document.querySelectorAll('.hover-card-add-tags');
  var postTagsForm = document.getElementById('post-tags-form');
  var deleteTagsForm = document.getElementById('delete-tags-form');
  var submitBatchTags = document.getElementById('submit-batch-tag');
  var deleteBatchTags = document.getElementById('delete-batch-tag');
  var addTagFormInput = document.getElementById('add_tagname');
  var deleteTagFormInput = document.getElementById('delete_tagname');
  var tagsWrapper = document.querySelector('.add-tags');
  var tagCreateForm = document.getElementById('new_tag');
  var selectedCards = [];
  var tagsFromSelectedCards = [];

  function selectCardIfOnlyOne() {
    if (cards.length == 0) {
      card.first.click();
    }
  }

  function toggleCardToAddTags() {
    cards.forEach(card => {
      card.addEventListener('click', (event) => {
          const docId = event.currentTarget.id;

          if (!selectedCards.includes(docId)) {
            selectedCards.push(docId);

            const html = `<input name="document_to_tag_ids[]" class = "hidden" id="form-${docId}" value=${docId} />`;
            postTagsForm.insertAdjacentHTML("afterbegin", html);
            deleteTagsForm.insertAdjacentHTML("afterbegin", html);
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
          if (getSelectedTagsOccurence(tagId) == selectedCards.length && tagsFromSelectedCards.includes(tagId)) {
            insertTagIDInDeleteForm(tagId);
          } else {
            insertTagIDInAddForm(tagId);
          }
        }
      }
    });
  }

  function insertTagIDInAddForm(tagId) {
    addTagFormInput.value = tagId;
    submitBatchTags.click();
  }

  function insertTagIDInDeleteForm(tagId) {
    deleteTagFormInput.value = tagId;
    deleteBatchTags.click();
  }

  function addDateTag() {
    var block = function(formattedDate, date, dp) {
      if (typeof selectedCards[0] !== 'undefined') {
        insertTagIDInAddForm(date);
      }
    }
    myDatepicker(block);
  }

  function getTagsFromSelectedCards() {
    tagsFromSelectedCards.length = 0;
    document.querySelectorAll(".opacity-full").forEach(c => {
      const tags = c.querySelectorAll(".tag-small");
      tags.forEach(t => {
        tagsFromSelectedCards.push(t.id);
      });
    });
  }

  function getSelectedTagsOccurence(tagId) {
    getTagsFromSelectedCards()
    let nbOcc = 0;
    for (var i = 0; i < tagsFromSelectedCards.length; i++) {
      if (tagsFromSelectedCards[i] == tagId) {
        nbOcc++;
      }
    }
    return nbOcc;
  }

  function revealDocTypeAndSupplierTags() {
    var macroCategoryTags = document.querySelectorAll(".macro_category");
    var docTypeTags = document.querySelectorAll(".doc_type");
    var supplierTags = document.querySelectorAll(".supplier");
    var allTags = document.querySelectorAll('.tag-link');

    function highlightSelectedTags(tag = false) {
      if (tag) {
        const tagId = tag.id;
        if (getSelectedTagsOccurence(tagId) == selectedCards.length && tagsFromSelectedCards.includes(tagId)) {
          tag.classList.remove('tag-s');
        } else if (!tag.classList.contains('tag-s')) {
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
      let i = 0;
      tags.forEach(t => {
        if (t.classList.contains('hidden')) {
          i += 1;
        }
      })
      return i === tags.length
    }

    function toggleTagsContainerTitle() {
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

          supplierTags.forEach(t => {
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

              supplierTags.forEach(t => {
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
  selectCardIfOnlyOne();
}

export { addTagsToMultipleDocuments };
