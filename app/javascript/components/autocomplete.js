function autocomplete() {
  document.addEventListener("DOMContentLoaded", function() {
    var tagName = document.getElementById('tag_autocomplete');

    if (tagName) {
      var autocomplete = @user_tags;
      ('.js-example-basic-single').select2({
  placeholder: 'Select an option'
});
      google.maps.event.addDomListener(tagName, 'keydown', function(e) {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });
    }
  });
}

export { autocomplete };
