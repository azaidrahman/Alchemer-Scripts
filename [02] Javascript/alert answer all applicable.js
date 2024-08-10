$SG(function () {
    const nextButton = $("#sg_NextButton");
    const originalOnClick = nextButton.prop("onclick");
    var alertShown = false;

    nextButton.prop("onclick", null);

    nextButton.on("click", function (event) {
        var checkedCount = $('.sg-question-options input[type="checkbox"]:checked').length;

        if (checkedCount <= 1 && !alertShown) {
            alert("Please answer all applicable answers");
            alertShown = true;
            event.preventDefault();
        } else {
            nextButton.prop("onclick", originalOnClick);
            nextButton.click();
        }
    });
});
