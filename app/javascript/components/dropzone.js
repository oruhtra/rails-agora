import Dropzone from 'dropzone';
import 'dropzone/dist/dropzone.css';

function launchDropZone() {
  var dropzone = document.querySelector('.form-full-body');
  window.addEventListener("dragenter", function(e) {
      dropzone.classList.remove('hidden');
      window.scrollTo(0, 0);
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

  // code found on internet to prevent issues with SAFARI and IE browsers
  myDropzone.handleFiles = function(files) {
    var _this5 = this;
    var files_array = [];

    for (var i = 0; i < files.length; i++) {
      files_array.push(files[i]);
    }

    return files_array.map(function(file) {
      return _this5.addFile(file);
    });
  };

  // when a document is dropped UNHIDE the loader animation
  document.querySelector('.dropzone').addEventListener('drop', (e) => {
    document.querySelector('.loader-container').classList.remove('hidden');
    document.querySelector('.dropdocs-title').classList.add('hidden');
  })

  myDropzone.on("success", function(file, response) {
    if (!document.querySelector('.form-full-body').classList.contains('hidden')) {
      document.querySelector('.dropdocs-title').classList.remove('hidden');
      document.querySelector('.form-full-body').classList.add('hidden');
      // HIDE the loader animation once the documents are loaded
      document.querySelector('.loader-container').classList.add('hidden');
    }
    // load the new elements and the 'add tags' button only if on the index page e.g., if it finds the batch-update form
    if (document.querySelector(".batch-update-form")) {
      addinput_in_form(response);
      document.getElementById("add-tags-to-documents").classList.remove('hidden');
      document.getElementById("load_new_elements").click();
    }
  });

}

function addinput_in_form(response) {
  // add the documents ids in the batch-update form and send them to the controller asking for JS
  // response that will reload the masonry grid with the new documents added
  const doc_id = response.id;
  const html = `<input type="hidden" name="document_ids[]" id="document_ids_" value=${doc_id} />`;
  const formTag = document.querySelector(".batch-update-form");
  const formNewElements = document.getElementById("load_new_elements_form");
  formTag.insertAdjacentHTML("afterbegin", html);
  formNewElements.insertAdjacentHTML("afterbegin", html);
}


export { launchDropZone };
