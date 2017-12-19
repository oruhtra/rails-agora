import Typed from 'typed.js';

function loadDynamicBannerText() {
  new Typed('#banner-typed-text', {
    strings: ["dites adieux à la paperasse.", "fini les classeurs.", "on trie et vous trouvez."],
    typeSpeed: 50,
    loop: true
  });
}

export { loadDynamicBannerText };
