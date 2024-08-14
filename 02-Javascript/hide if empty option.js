$(document).ready(function () {
  // Find empty labels and hide the corresponding <li> elements
  $("label:empty").each(function () {
    $(this).closest("li").hide();
  });
});
