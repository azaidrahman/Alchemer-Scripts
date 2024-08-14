const inputElement = document.getElementById('sgE-7544695-24-74-10091-other');

inputElement.addEventListener('keydown', function(e) {
    if (!/\d/.test(e.key) && e.keyCode !== 8) { // 8 is the keycode for Backspace
    e.preventDefault();
    }
});