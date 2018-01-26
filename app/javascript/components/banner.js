import Typed from 'typed.js';

function loadDynamicBannerText() {
  new Typed('#banner-typed-text', {
    strings: ["l'administratif...", "la paperasse...", "leur mutuelle...", "la sécu...", "leur assurance..."],
    typeSpeed: 70,
    loop: true
  });
}

export { loadDynamicBannerText };
