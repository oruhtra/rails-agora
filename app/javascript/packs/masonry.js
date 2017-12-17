function createMasonryGrid() {
  var elem = document.getElementById('masonry-container');
  var msnry = new Masonry( elem, {
    // options
    itemSelector: '.box',
    columnWidth: 40,
    isFitWidth: true
  });

  tagsListen(msnry);
}

function tagsListen(msnry){
  const tags = document.querySelectorAll(".listentag");
  const cards = document.querySelectorAll(".box");
  tags.forEach(tag => tag.addEventListener("click", (event) => {
      event.preventDefault();
      const tagId = event.currentTarget.id;
      const tagClass = event.currentTarget.className.split(' ');
      filterMasonry(cards, tagId, tagClass, msnry);
    }));
}

function filterMasonry(cards, tagId, tagClass, msnry) {
  if (!tagClass.includes("tag-s")) {
        cards.forEach(card => {
          const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');

          if (!cardTags.includes(tagId)){
            msnry.remove(card);
            msnry.layout();
          }
        });
      } else {

        // cards.forEach(card => {
        //   // msnry.reloadItems();
        //   const cardTags = card.id.match(/(\S*)@(.+)/)[2].split(' ');

        //   if (!cardTags.includes(tagId)){
        //     msnry.addItems(card);
        //   }
        // });
      }
}








if (document.getElementById('masonry-container')) {
  createMasonryGrid();
}
