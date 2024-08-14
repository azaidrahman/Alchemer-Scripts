$(document).ready(function () {
  var firstOption = $("li:contains('Keep this together 1')");
  var secondOption = $("li:contains('Keep this together 2')");
  secondOption.detach();
  firstOption.after(secondOption);
});
