function keepHoverCardWhenHoverButton() {
  const buttonArray = document.querySelectorAll('.selectionbox');
  buttonArray.forEach(button => {
    button.addEventListener("mouseenter", (event) => {
      const select = document.querySelectorAll('.card-image');
      select.forEach(image => {
      if (image.parentElement.parentElement == button.parentElement.parentElement.parentElement.parentElement) {
      image.classList.toggle("card-hover");
      }
      });
    });
    });
    buttonArray.forEach(button => {
    button.addEventListener("mouseleave", (event) => {
      const select = document.querySelectorAll('.card-image');
      select.forEach(image => {
      if (image.parentElement.parentElement == button.parentElement.parentElement.parentElement.parentElement) {
      image.classList.toggle("card-hover");
      }
      });
    });
    });
  }

export { keepHoverCardWhenHoverButton };
