import Dropzone from 'dropzone';
import 'dropzone/dist/dropzone.css';

function newdropzone() {
  // const myDropzone = new Dropzone("#doc-dropzone");
  const myDropzone = new Dropzone("#doc-dropzone" );

  // Dropzone.uploadMultiple.myDropzone = true;

}

export { newdropzone };



// var myDropzone = new Dropzone(document.getElementById('dropzone-area'), {
//   uploadMultiple: false,
//   acceptedFiles:'.jpg,.png,.jpeg,.gif',
//   parallelUploads: 6,
//   url: 'https://api.cloudinary.com/v1_1/cloud9/image/upload'
// });


// myDropzone.on('sending', function (file, xhr, formData) {
//   formData.append('api_key', 123456789123456);
//   formData.append('timestamp', Date.now() / 1000 | 0);
//   formData.append('upload_preset', 'presetname');
// });
// myDropzone.on('success', function (file, response) {
//   console.log('Success! Cloudinary public ID is', response.public_id);
// });
