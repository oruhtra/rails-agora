function showModalAddTags() {
  var allTags = document.querySelectorAll('.tag-link');

  allTags.forEach(t => {
    t.addEventListener('click', (e) => {
      if (document.querySelectorAll('.opacity-full').length == 0 ) {
        $('#myModal_add_tags').modal('show');
      }
    })
  })
}


export { showModalAddTags }
