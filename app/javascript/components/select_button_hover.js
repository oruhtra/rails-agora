function showSelectButtonOnHover() {
  const cardArray = document.querySelectorAll('.card');
  cardArray.forEach(card => {
    card.addEventListener("mouseenter", (event) => {
      const idComplete = event.currentTarget.id;
      const id = idComplete.match(/(\S*)@/)[1];
      const select_button = document.getElementById(`button-${id}`);
      select_button.classList.toggle("hidden");
    });
    card.addEventListener("mouseleave", (event) => {
      const idComplete = event.currentTarget.id;
      const id = idComplete.match(/(\S*)@/)[1];
      const select_button = document.getElementById(`button-${id}`);
      select_button.classList.toggle("hidden");
    });
  });
}

export { showSelectButtonOnHover };
