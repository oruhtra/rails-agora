import Typed from 'typed.js';

function loadDynamicBannerText() {
  new Typed('#banner-typed-text', {
    strings: ["fini la paperasse.", "dites adieux à vos classeurs."],
    typeSpeed: 50,
    loop: true
  });
}

loadDynamicBannerText();
