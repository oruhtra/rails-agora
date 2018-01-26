import $ from 'jquery';

function scrollToAnchor(aName){
    var aTag = $("a[name='"+ aName +"']");
    $('html,body').animate({scrollTop: aTag.offset().top},'slow');
}

function activateAnchorLinks() {
  $(".link-to-anchor").click(function() {
    const linkName = event.target.id.match(/(link-to-)(.+)/)[2]
    scrollToAnchor(linkName);
  });
}

export { activateAnchorLinks }
