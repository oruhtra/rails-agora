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
          tagFormInput.value = tagId;
          submitBatchTags.click();
        }
      }
    });
  }

  toggleCardToAddTags();
  addTagToForm();
}

export { addTagsToMultipleDocuments };
