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


// use in new document//////////////////////////////////

$('.select2_new').select2({
    multiple: true,
    width: '100%',
    placeholder: "",
});

// add tag-s on
$('.select2_new').on('select2:select', function (e) {
  document.getElementById(e.params.data.text.replace(/\s/, "_")).classList.toggle("tag-s");
  document.getElementById(e.params.data.text.replace(/\s/, "_")).classList.toggle("hidden");
  const tags = document.querySelectorAll(".listenbatchtag");
  const selectedtags = generateParameters();
  const allTagsName = selectedtags.join(" ");
  document.querySelector(".batch_tags").value = allTagsName;
});

function generateParameters() {
  const selectedtags = [];
  document.querySelectorAll(".tag-s").forEach(tag => {
    selectedtags.push(tag.id);
  });
  return selectedtags;
}



$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip();
});
