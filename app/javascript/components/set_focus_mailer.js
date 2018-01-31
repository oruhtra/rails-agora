import 'focusable-element';

function setFocusMailer() {
  const options = {
    hideOnClick: true,
    hideOnESC: true,
    circle: true
  };
  if ($(window).width()>992) {
    Focusable.setFocus($('#focusable-container'), options);
    $('#myModalAddByMail').show();
    $('#myModalAddByMail')[0].classList.remove('fade');
    $('#myModalAddByMail')[0].classList.add('front-element');
    $('#add_by_email_user_preference')[0].classList.remove('hidden');
    $(window).on('click', function() {
      Focusable.hide();
      $('#add_by_email_user_preference')[0].classList.add('hidden');
      $('#myModalAddByMail').hide();
      $('#myModalAddByMail')[0].classList.add('fade');
      $('#myModalAddByMail')[0].classList.remove('front-element');
      $('#focusable-container').hide();
    })
  }
}


export { setFocusMailer }
