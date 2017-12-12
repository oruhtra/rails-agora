import $ from 'jquery';
import 'select2';

// use in index documents page to search for a tag/////
$('.select2').select2({
    multiple: true,
    width: '200px',
    placeholder: "",
});

$('.select2').on('select2:select', function (e) {
  document.getElementById('submittag').submit();
});


// use in new document//////////////////////////////////

$('.select2_new').select2({
    multiple: true,
    width: '100%',
    placeholder: "",
});

// add tag-s on
$('.select2_new').on('select2:select', function (e) {
  document.getElementById(e.params.data.text).classList.toggle("tag-s");
});



 ////////////////////////////////////////////

import 'select2/dist/css/select2.css';
