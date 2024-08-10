$(document).ready(function () {
    // Iterate through each table header
    $("th").each(function (index) {
        // Get the text content of the header
        var headerText = $(this).text().trim();

        // Check if the header is empty
        if (headerText === "") {
            // Hide the header
            $(this).hide();

            // Hide the corresponding table column
            $("table tr").each(function () {
                $(this)
                    .find("td:eq(" + index + ")")
                    .hide();
            });
        }
    });
});
