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
    document.getElementById("load_new_elements").click();
    });

}

function addinput_in_form(response) {
  const doc_id = response.id;
  const html = `<input name="document_ids[]" type="hidden" value=${doc_id} />`;
  const formTag = document.querySelector(".batch-update-form");
  const formNewElements = document.getElementById("load_new_elements_form");
  formTag.insertAdjacentHTML("afterbegin", html);
  formNewElements.insertAdjacentHTML("afterbegin", html);
}


export { launchDropZone };
