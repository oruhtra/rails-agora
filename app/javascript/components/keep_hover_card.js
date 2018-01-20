function keepHoverCardWhenHoverButton() {
  const cards = document.querySelectorAll('.card');
  cards.forEach(card => {
    card.querySelector('.selectionbox').addEventListener("mouseover", (e) => {
      console.log('enter');
      card.querySelector('.hover-card').classList.add('opacity-full');
    });
    card.querySelector('.selectionbox').addEventListener("mouseout", (e) => {
      setTimeout(function() {card.querySelector('.hover-card').classList.remove('opacity-full')}, 100);

    });
  });
}

export { keepHoverCardWhenHoverButton };
