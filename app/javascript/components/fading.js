const cards = document.querySelectorAll('.card')

cards.forEach(card => {
  card.addEventListener('scroll', event => {
    event.currentTarget.offsetParent()
  });
});
