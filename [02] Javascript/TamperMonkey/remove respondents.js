// ==UserScript==
// @name         Automate Respondent Removal
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Automate the respondent removal process
// @match        YOUR_TARGET_URL_HERE
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    const removeButton = document.createElement("button");
    removeButton.innerHTML = "Remove Respondents";
    removeButton.style.position = "fixed";
    removeButton.style.top = "10px";
    removeButton.style.right = "10px";
    removeButton.style.zIndex = "9999";
    document.body.appendChild(removeButton);

    const resetButton = document.createElement("button");
    resetButton.innerHTML = "Reset";
    resetButton.style.position = "fixed";
    resetButton.style.top = "10px";
    resetButton.style.right = "160px";
    resetButton.style.zIndex = "9999";
    document.body.appendChild(resetButton);

    const waitForElement = (selector, callback) => {
        const checkExist = setInterval(() => {
            const element = document.querySelector(selector);
            if (element) {
                clearInterval(checkExist);
                callback(element);
            }
        }, 100); // check every 100ms
    };

    const clearCache = () => {
        localStorage.removeItem('respondentNumbers');
        localStorage.removeItem('currentIndex');
    };

    const removeRespondent = () => {
        let numbers = JSON.parse(localStorage.getItem('respondentNumbers')) || [];
        let index = parseInt(localStorage.getItem('currentIndex'), 10) || 0;

        if (numbers.length === 0) {
            const input = prompt("Enter the respondent numbers separated by spaces:", "");
            numbers = input.split(' ').map(num => num.trim());
            localStorage.setItem('respondentNumbers', JSON.stringify(numbers));
            index = 0;
        }

        if (index >= numbers.length) {
            console.log("Removal process completed.");
            clearCache();
            return;
        }

        const searchBar = document.querySelector('input[name="grid-query"]');
        searchBar.value = `#${numbers[index]}`;
        waitForElement('.btn-sm[title="Search"]', (searchButton) => {
            searchButton.click();
            waitForElement('.table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(1) > input:nth-child(1)', (checkBox) => {
                checkBox.click();
                waitForElement('.btn-sm[title="Search"]', (clearButton) => {
                    clearButton.click();
                    localStorage.setItem('currentIndex', index + 1);
                    console.log(`Completed ID: ${numbers[index]}. Moving on to the next ID.`);
                    setTimeout(removeRespondent, 1000); // wait a bit before starting the next iteration
                });
            });
        });
    };

    removeButton.addEventListener("click", removeRespondent);
    resetButton.addEventListener("click", clearCache);

    if (localStorage.getItem('respondentNumbers')) {
        removeRespondent();
    }
})();