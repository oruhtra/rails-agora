import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';

// use in index documents page to search for a tag/////
$('.select2').select2({
    multiple: true,
    width: '200px',
    placeholder: "",
});

$('.select2').on('select2:select', function (e) {
  document.getElementById('submittag').submit();
});

