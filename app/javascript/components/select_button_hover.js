function showSelectButtonOnHover() {
  const cardArray = document.querySelectorAll('.card');
  cardArray.forEach(card => {
    card.addEventListener("mouseenter", (event) => {
      const id = event.currentTarget.id;
      const select_button = document.getElementById(`button-${id}`);
      select_button.classList.toggle("hidden");
    });
    card.addEventListener("mouseleave", (event) => {
      const id = event.currentTarget.id;
      const select_button = document.getElementById(`button-${id}`);
      select_button.classList.toggle("hidden");
    });
  });
}

if (document.querySelectorAll('.card')) {
  showSelectButtonOnHover()
}
