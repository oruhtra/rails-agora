import Dropzone from 'dropzone';
import 'dropzone/dist/dropzone.css';

function launchDropZone() {
  window.addEventListener("dragenter", function(e) {
      document.querySelector(".form-full-body").classList.remove('hidden');
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
    addinput_in_form(response);
    document.getElementById("btnsavedocs").disabled = false;
    });

}

// new Dropzone(document.body, { // Make the whole body a dropzone
//     url: "/upload/url", // Set the url
//     previewsContainer: "#previews", // Define the container to display the previews
//     clickable: "#clickable" // Define the element that should be used as click trigger to select files.
//   });

function addinput_in_form(response) {
  const doc_id = response.id;
  const form = document.querySelector(".batch-update-form");
  const html = `<input name="document_ids[]" type="hidden" value=${doc_id} />`;
  form.insertAdjacentHTML("afterbegin", html);
}

export { launchDropZone };
