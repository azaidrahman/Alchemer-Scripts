// ==UserScript==
// @name         Button Selector
// @namespace    http://tampermonkey.net/
// @version      1
// @description  Select buttons with specific IDs or classes
// @match        *.alchemer.com/*
// @grant        none
// ==/UserScript==

(function () {
    "use strict";
    document.addEventListener("keydown", function (e) {
        const nextButton = document.querySelector("#sg_NextButton");
        const saveButton = document.querySelector(".btn.btn-primary.js-save-quest");
        const saveQuota = document.querySelector("#quota-submit");
        const backButton = document.querySelector(".btn.btn-default");
        if (e.altKey && e.key === "w") {
            if (nextButton) {
                nextButton.click();
            }

            if (saveButton) {
                saveButton.click();
            }

            if (saveQuota) {
                saveQuota.click();
            }
        }
        if (e.altKey && e.key === "q") {
            if (backButton) {
                backButton.click();
            }
        }
    });
})();
