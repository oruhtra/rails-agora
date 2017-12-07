import Dropzone from 'dropzone';

function newdropzone() {
  // const myDropzone = new Dropzone("#doc-dropzone");
  const myDropzone = new Dropzone("#doc-dropzone");

  Dropzone.uploadMultiple.myDropzone = false;


}

export { newdropzone };
