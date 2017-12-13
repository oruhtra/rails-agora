import Dropzone from 'dropzone';
import 'dropzone/dist/dropzone.css';

function newdropzone() {
  Dropzone.autoDiscover = false;
  // const myDropzone = new Dropzone("#doc-dropzone");
  const myDropzone = new Dropzone("#doc-dropzone", {
    dictDefaultMessage: "ici "
    });

  myDropzone.on("success", function(file, response) {
    addinput_in_form(response);
    document.getElementById("btnsavedocs").disabled = false;
    });

}

function addinput_in_form(response) {
  const doc_id = response.id;
  const form = document.querySelector(".batch-update-form");
  const html = `<input name="document_ids[]" type="hidden" value=${doc_id} />`;
  form.insertAdjacentHTML("afterbegin", html);
}

if (document.getElementById("doc-dropzone")) {
  newdropzone();
}
