const rows = $(".sg-table.sg-min-answers-per-row tbody tr");

rows.each(function () {
    const checkboxes = $(this).find('input[type="checkbox"]');
    const maxChecked = 3;
    console.log(checkboxes);

    checkboxes.on("blur", function () {
        const checkedCheckboxes = checkboxes.filter(":checked");

        if (checkedCheckboxes.length >= maxChecked) {
            checkboxes.not(":checked").prop("disabled", true);
            checkboxes.not(":checked").css("display", "none");
        } else {
            checkboxes.not(":checked").prop("disabled", false);
            checkboxes.not(":checked").next("label").css("filter", "none");
        }
    });
});
