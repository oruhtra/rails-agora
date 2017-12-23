import Dropzone from 'dropzone';
import 'dropzone/dist/dropzone.css';

function launchDropZone() {
  var dropzone = document.querySelector('.form-full-body');
  window.addEventListener("dragenter", function(e) {
      dropzone.classList.remove('hidden');
  });
  dropzone.addEventListener("dragleave", function(e) {
      dropzone.classList.add('hidden');
  });

  newdropzone();
}

function newdropzone() {
  Dropzone.autoDiscover = false;
  const myDropzone = new Dropzone("#doc-dropzone", {
    dictDefaultMessage: "",
    previewsContainer: "#previews",
    clickable: "#clickable"
    });

  myDropzone.on("success", function(file, response) {
    if (!document.querySelector('.form-full-body').classList.contains('hidden')) {
      document.querySelector('.form-full-body').classList.add('hidden');
    }
    addinput_in_form(response);
    document.getElementById("btnsavedocs").classList.remove('hidden');
    });

}

function addinput_in_form(response) {
  const doc_id = response.id;
  const form = document.querySelector(".batch-update-form");
  const html = `<input name="document_ids[]" type="hidden" value=${doc_id} />`;
  form.insertAdjacentHTML("afterbegin", html);
}

function loadNewElements() {

}

export { launchDropZone };
