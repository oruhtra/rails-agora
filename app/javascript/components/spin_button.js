const spin = document.querySelector('.fa-refresh');

function spinButton() {
  spin.addEventListener("click", (event) => {
    spin.classList.toggle("fa-spin");

  });


}


spinButton();
