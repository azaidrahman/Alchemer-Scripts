// ==UserScript==
// @name         Alchemer Quota Redirection
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Automate the quota editing process
// @match        https://app.alchemer.com/projects/setup/id/*/tab/quotas
// @grant        none
// ==/UserScript==

(function () {
  "use strict";
  const QUOTA_URL =
    'www.surveygizmo.com/s3/5403169/updateStatus?bpid=[url("bpid")]&bcid=[url("bcid")]&brid=[url("brid")]';

  // Create and place the "Start Automation" button
  const startButton = document.createElement("button");
  startButton.innerHTML = "Start Automation";
  startButton.style.position = "fixed";
  startButton.style.top = "10px";
  startButton.style.right = "10px";
  startButton.style.zIndex = "9999";
  document.body.appendChild(startButton);

  // Create and place the "Stop Automation" button
  const stopButton = document.createElement("button");
  stopButton.innerHTML = "Stop Automation";
  stopButton.style.position = "fixed";
  stopButton.style.top = "10px";
  stopButton.style.right = "130px";
  stopButton.style.zIndex = "9999";
  document.body.appendChild(stopButton);

  const waitForElement = (selector, callback) => {
    const elements = document.querySelectorAll(selector);
    if (elements.length > 0) {
      callback(elements[0]);
      return;
    }
    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        const nodes = Array.from(mutation.addedNodes);
        for (const node of nodes) {
          if (node.querySelectorAll) {
            const elements = node.querySelectorAll(selector);
            if (elements.length > 0) {
              observer.disconnect();
              callback(elements[0]);
              return;
            }
          }
        }
      });
    });
    observer.observe(document.documentElement, {
      childList: true,
      subtree: true,
    });
  };

  const processRow = () => {
    const index = parseInt(localStorage.getItem("currentIndex"), 10) || 1; // Start from second row
    const table = document.getElementById("logic-quotas");

    if (index >= table.rows.length) {
      console.log("Automation completed.");
      localStorage.removeItem("currentIndex");
      return;
    }

    const anchor = table.rows[index].cells[0].querySelector("a");
    if (anchor) {
      anchor.click();
      waitForElement(
        'a[href="#quota-pane-complete-partial"]',
        (completeActions) => {
          completeActions.click();
          waitForElement("#disqualify-action-url", (disqualifyInput) => {
            const redirectInput = document.getElementById("quota-redirect-url");
            disqualifyInput.click();
            redirectInput.value = QUOTA_URL;

            waitForElement("#quota-submit", (saveButton) => {
              saveButton.click();
              localStorage.setItem("currentIndex", index + 1); // Update index for the next row
            });
          });
        }
      );
    } else {
      localStorage.setItem("currentIndex", index + 1); // Update index for the next row
    }
  };

  startButton.addEventListener("click", () => {
    localStorage.setItem("currentIndex", 1); // Initialize index at 1 (second row)
    processRow();
  });

  stopButton.addEventListener("click", () => {
    localStorage.removeItem("currentIndex"); // Remove index to stop automation
  });

  // If currentIndex exists in localStorage, continue the automation
  if (localStorage.getItem("currentIndex")) {
    processRow();
  }
})();
