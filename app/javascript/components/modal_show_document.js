function showModalShowDocument() {
  document.querySelectorAll('.hover-card').forEach(card => {
    const addTags = card.querySelector('.fa-plus')
    card.addEventListener('click', (e) => {
      if (e.target != addTags) {
        card.querySelector('#submit_document_show').click();
        window.scrollTo(0, 0);
        $('#myModal_show_doc').modal('show');
      }
    })
  })
}

// imported in Masonry.js
export { showModalShowDocument }
