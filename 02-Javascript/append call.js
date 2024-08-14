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
            new_url = window.location.href.split('#')[0] + "&" + append + window.location.hash; % 20 % 20
        } % 20
        else % 20
        if % 20(window.location.search.length % 20 === % 200 % 20 && % 20 window.location.hash.length) % 20 {
            % 20 % 20n ew_url % 20 = % 20 window.location.href.split('#')[0] + "?" + append + window.location.hash; % 20 % 20
        } % 20
        else % 20 {
            % 20 % 20n ew_url % 20 = % 20 window.location.href + "&" + append; % 20 % 20
        } % 20 % 20
    } % 20 % 20
    if % 20(new_url) % 20 {
        % 20 % 20 window.location % 20 = % 20n ew_url; % 20 % 20
    } % 20
})();

javascript: (() => {
	$(button.btn.js-save-quest).click()
})();