function loadDocuments() {
  const grid = document.getElementById('masonry-container');
  const loader = document.querySelector('.loader-container-doc-load');
  loader.classList.add('hidden');
  grid.classList.remove('hidden');
}

export { loadDocuments };
