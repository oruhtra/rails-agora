function createMasonryGrid() {
  var elem = document.getElementById('masonry-container');
  var msnry = new Masonry( elem, {
    // options
    itemSelector: '.box',
    columnWidth: 50,
    isFitWidth: true
  });
}

if (document.getElementById('masonry-container')) {
  createMasonryGrid();
}
