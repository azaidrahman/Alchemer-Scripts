// Placeholder for textbox
$(document).ready(function() {

    var placeholder = 'Placeholder';

    $('.textbox input[type=text]').val(placeholder).addClass('placeholder');

    $('.textbox input[type=text]').blur(function() {
        if ($(this).val().length == 0) {
            $(this).val(placeholder).addClass('placeholder');
        }
    });

    $('.textbox input[type=text]').focus(function() {
        if ($(this).val() == placeholder) {
            $(this).val('').removeClass('placeholder');
        }
    });
});
