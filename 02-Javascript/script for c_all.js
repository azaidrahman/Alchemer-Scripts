javascript: (() => {
    var new_url = false;
    var append = "c=all";

    if (window.location.hash.length === 0 && window.location.search.length === 0) {
        new_url = window.location.href + "?" + append;
    } else {

        if (window.location.search.indexOf(append) != -1) {
            return false;
        }

        if (window.location.search.length && window.location.hash.length) {
            new_url = window.location.href.split('#')[0] + "&" + append + window.location.hash;
        } else if (window.location.search.length === 0 && window.location.hash.length) {
            new_url = window.location.href.split('#')[0] + "?" + append + window.location.hash;
        } else {
            new_url = window.location.href + "&" + append;
        }
    }
    if (new_url) {
        window.location = new_url;
    }
})();