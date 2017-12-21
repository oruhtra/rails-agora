import "bootstrap";
import { loadDynamicBannerText } from '../components/banner';
import { listentag } from "../components/tag";
import { listenbatchtag } from "../components/batch_tag";
import { newdropzone } from "../components/dropzone";
import { createMasonryGrid } from "../components/masonry";
import { showSelectButtonOnHover } from "../components/select_button_hover";
import { keepHoverCardWhenHoverButton } from "../components/keep_hover_card";
import { budgeaHandshake } from "../components/budgea_add_service";
import '../components/search_tag_from_select2';
import '../components/add_tag_from_select2';
import { addTagsToMultipleDocuments } from "../components/add_tags_to_multiple_documents";

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

if (document.getElementById('masonry-container')) {
  showSelectButtonOnHover()
}

if (document.getElementById('submit-batch-tag')) {
  addTagsToMultipleDocuments();
}
