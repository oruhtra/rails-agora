import "bootstrap";
import { applySelect2OnSearch } from "../components/search_tag_from_select2";
import { loadDynamicBannerText } from '../components/banner';
import { listentag } from "../components/tag";
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
import { showActiveTab } from "../components/active_tab";
import '../components/add_tag_from_select2';
import '../components/air_datepicker';
import '../components/show_tooltips';



// call functions
if (document.getElementById('tab_name')) {
  showActiveTab();
}

if (document.querySelector(".select2")){
  applySelect2OnSearch();
}

if (document.getElementById('banner-typed-text')){
  loadDynamicBannerText();
}

if (document.querySelector('.service-form')) {
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

$('#launch-add_tags_to_multiple_documents_js').on('click', function(e) {
  addTagsToMultipleDocuments();
})

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

if (document.querySelector('.link-to-anchor')) {
  activateAnchorLinks();
}

if (document.getElementById('masonry-container')) {
  if (document.getElementById('focusable-container')) {
    setTimeout(function(){setFocusMailer();},1000);
  }
}


