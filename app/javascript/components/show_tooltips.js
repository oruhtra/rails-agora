import $ from 'jquery';
if ($(window).width() > 768) {
  $(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
  });
}
