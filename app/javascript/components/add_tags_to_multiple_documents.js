function addTagsToMultipleDocuments() {
  var cards = document.querySelectorAll('.hover-card');
  var postTagsForm = document.getElementById('post-tags-form');
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

            const html = `<input name="document_ids[]" type="hidden" id="form-${docId}" value=${docId} />`;
            postTagsForm.insertAdjacentHTML("afterbegin", html);
            tagCreateForm.insertAdjacentHTML("afterbegin", html);

            card.classList.add('opacity-full');
          } else {
            selectedCards = selectedCards.filter(id => id !== docId);
            const html = document.getElementById(`form-${docId}`);
            html.remove();
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
          postTagsForm.submit();
        }
      }
    });
  }


  toggleCardToAddTags();
  addTagToForm();
}

export { addTagsToMultipleDocuments };
