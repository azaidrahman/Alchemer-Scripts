function getLang() {
  return document.getElementsByTagName("html")[0].lang;
}

lang = getLang();

if (lang == "en") {
  $(document).ready(function () {
    $("#sg_NextButton").val("Submit");
  });
} else if (lang == "bm") {
  $(document).ready(function () {
    $("#sg_NextButton").val("Hantar");
  });
} else if (lang == "th") {
  $(document).ready(function () {
    $("#sg_NextButton").val("ส่ง");
  });
}
