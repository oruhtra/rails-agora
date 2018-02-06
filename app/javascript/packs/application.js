import "bootstrap";
import { applySelect2OnSearch } from "../components/search_tag_from_select2";
import { loadDynamicBannerText } from '../components/banner';
import { listentag } from "../components/tag";
import { listenbatchtag } from "../components/batch_tag";
import { launchDropZone } from "../components/dropzone";
import { createMasonryGrid } from "../components/masonry";
import { selectButton } from "../components/select_button_hover";
import { keepHoverCardWhenHoverButton } from "../components/keep_hover_card";
import { budgeaHandshake } from "../components/budgea_add_service";
import { addTagsToMultipleDocuments } from "../components/add_tags_to_multiple_documents";
import { showModalTips, hideModalTips } from "../components/modal_tips";
import { setUserPreference } from "../components/set_user_preference";
import { showModalAddTags } from "../components/modal_add_tag";
import { loadDocuments } from "../components/load_documents";
import { activateAnchorLinks } from "../components/scroll_to_anchor";
import { setFocusMailer } from "../components/set_focus_mailer";
import { showModalShowDocument } from "../components/modal_show_document";
import '../components/add_tag_from_select2';
import '../components/air_datepicker';
import '../components/show_tooltips';



// call functions
if (document.querySelectorAll(".select2")){
  applySelect2OnSearch();
}

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
  launchDropZone();
}

if (document.getElementById('masonry-container')) {
  if ($(window).width() > 768) {
    selectButton();
    keepHoverCardWhenHoverButton();
  }
}


if (document.getElementById('masonry-container')) {
    window.addEventListener("load", (e) => {
      loadDocuments();
      createMasonryGrid();
    })
}

if (document.getElementById('submit-batch-tag')) {
  addTagsToMultipleDocuments();
}

if (document.getElementById('myModal')) {
  showModalTips();
  hideModalTips();
}

if (document.getElementById('set_user_preference')) {
  setUserPreference();
}

if (document.getElementById('myModal_add_tags')) {
  showModalAddTags();
}

if (document.querySelectorAll('.link-to-anchor')) {
  activateAnchorLinks();
}

if (document.getElementById('masonry-container')) {
  if (document.getElementById('focusable-container')) {
    setTimeout(function(){setFocusMailer();},1000);
  }
}

if (document.getElementById('masonry-container')) {
  showModalShowDocument();
}
