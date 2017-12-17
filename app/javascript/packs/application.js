import "bootstrap";
import { loadDynamicBannerText } from '../components/banner';
import { listentag } from "../components/tag";
import { listenbatchtag } from "../components/batch_tag";
import { newdropzone } from "../components/dropzone";
import { createMasonryGrid } from "../components/masonry";
import { showSelectButtonOnHover } from "../components/select_button_hover";
import { keepHoverCardWhenHoverButton } from "../components/keep_hover_card";
import { budgeaHandshake } from "../components/budgea_add_service";
import '../components/select2';

// call functions
if (document.querySelectorAll(".listenbatchtag")){
  listenbatchtag();
}

if (document.getElementById('banner-typed-text')){
  loadDynamicBannerText();
}

if (document.querySelectorAll('.service-form')) {
  budgeaHandshake();
}

if (document.getElementById("doc-dropzone")) {
  newdropzone();
}

if (document.querySelectorAll('.selectionbox')) {
  keepHoverCardWhenHoverButton()
}

if (document.getElementById('masonry-container')) {
  createMasonryGrid();
}


$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip();
});

if (document.querySelectorAll('.card')) {
  showSelectButtonOnHover()
}
