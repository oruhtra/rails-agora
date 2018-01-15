import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
// import 'masonry';

// use in index documents page to search for a tag/////
$('.select2').select2({
    multiple: false,
    width: '200px',
    placeholder: "Rechercher un tag",
});

