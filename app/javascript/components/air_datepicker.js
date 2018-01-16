import $ from 'jquery';
import 'air-datepicker';
import 'air-datepicker/dist/css/datepicker.css';
import 'air-datepicker/dist/js/i18n/datepicker.fr.js';

function myDatepicker(onSelectFunction = null, onRenderCellFunction = null) {

let $btn = $('#datepicker-button')

var myDatepicker = $('.my-datepicker').datepicker({
    language: 'fr',
    minView:"months",
    view:"months",
    dateFormat:"MM yyyy",
    toggleSelected: true,
    autoClose: true,
    onSelect: onSelectFunction,
    onRenderCell: onRenderCellFunction,
    onHide: function(dp, animationCompleted){dp.clear()}
  }).data('datepicker');

$btn.on('click', function(){
    myDatepicker.show();
  });

}

export { myDatepicker };
