function showModalTips() {
  $(window).on('load',function(){
      $('#myModal').modal('show');
  });
}

function hideModalTips() {
  $('.tips-box').on('click', function(){
    $('.modal.in').modal('hide');
  });
}

export { showModalTips, hideModalTips }
