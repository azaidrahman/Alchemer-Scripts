// ==UserScript==
// @name         Fill Quota Redirect URLs
// @namespace    http://tampermonkey.net/
// @version      1
// @description  Fills in redirect URLs for each quota in a table using SurveyGizmo API
// @author       Your Name
// @match        *.alchemer.com/*
// @grant        GM_xmlhttpRequest
// ==/UserScript==

(function () {
    "use strict";

    const delay = (ms) => new Promise((res) => setTimeout(res, ms));
    // Get the current quota index from localStorage or initialize it to zero
    let currentQuotaIndex = parseInt(localStorage.getItem("currentQuotaIndex")) || 0;

    // Get the number of times the script has reloaded the page from localStorage or initialize it to zero
    let reloadCounter = parseInt(localStorage.getItem("reloadCounter")) || 0;

    async function fillQuotaRedirectUrls() {
        const quotasTable = document.querySelector("#logic-quotas");
        const editLinks = quotasTable.querySelectorAll(".edit-link");

        while (currentQuotaIndex < editLinks.length) {
            const editLink = editLinks[currentQuotaIndex];
            editLink.click();
            await delay(2000);

            const sectionLink = document.querySelector('a[href="#quota-pane-complete-partial"]');
            sectionLink.click();
            await delay(2000);

            const section = document.querySelector("#quota-pane-complete-partial");
            const disqualifyActionUrl = section.querySelector("#disqualify-action-url");
            disqualifyActionUrl.click();

            const quotaRedirectUrl = section.querySelector("#quota-redirect-url");
            const redirectUrl =
                'https://www.surveygizmo.com/s3/5403169/updateStatus?bpid=[url("bpid")]&bcid=[url("bcid")]&brid=[url("brid")]';
            quotaRedirectUrl.value = redirectUrl;

            const submitButton = document.querySelector("#quota-submit");
            submitButton.click();

            if (reloadCounter === 0) {
                await new Promise((resolve) => {
                    window.addEventListener("load", resolve);
                });
            }
            reloadCounter++;

            // If the page has reloaded more than once, reset the reload counter
            if (reloadCounter > 1) {
                reloadCounter = 0;
            }

            // If the current quota is still visible on the page, move on to the next one
            if (editLink.closest("tr").style.display !== "none") {
                currentQuotaIndex++;
            }

            window.addEventListener("beforeunload", () => {
                localStorage.setItem("currentQuotaIndex", currentQuotaIndex);
                localStorage.setItem("reloadCounter", reloadCounter);
            });
        }
    }

    function createButton() {
        const button = document.createElement("button");
        button.innerText = `Fill Quota Redirect URLs\n Idx: ${currentQuotaIndex}`;
        button.style.position = "fixed";
        button.style.top = "20px";
        button.style.right = "20px";
        button.style.zIndex = 9999;
        button.addEventListener("click", fillQuotaRedirectUrls);
        document.body.appendChild(button);
    }

    createButton();
})();
