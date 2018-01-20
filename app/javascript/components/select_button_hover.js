function selectButton() {

  function showSelectButtonOnHover() {
    const cardArray = document.querySelectorAll('.card');
    cardArray.forEach(card => {
      card.addEventListener("mouseenter", (event) => {
        const idComplete = event.currentTarget.id;
        const id = idComplete.match(/(\S*)@/)[1];
        const select_button = document.getElementById(`button-${id}`);
        select_button.classList.remove("hidden");
      });
      card.addEventListener("mouseleave", (event) => {
        const idComplete = event.currentTarget.id;
        const id = idComplete.match(/(\S*)@/)[1];
        const select_button = document.getElementById(`button-${id}`);
        if (!select_button.classList.contains("hidden")) {
          select_button.classList.add("hidden");
        }
      });
    });
  }

  function reloadSelectButtonAfterFileUpload() {
    document.querySelector('.reload-masonry-grid').addEventListener('click', (e) => {
      showSelectButtonOnHover();
    });
  }

  showSelectButtonOnHover();
  reloadSelectButtonAfterFileUpload();

}

export { selectButton };
