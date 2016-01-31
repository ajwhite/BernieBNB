$(document).ready(function () {

  $(".contact-button").on('click', function (e) {
    if ($(this).text() == "✔ Contacted") {
      e.preventDefault();
      $(this).blur();
    }
  });
});
