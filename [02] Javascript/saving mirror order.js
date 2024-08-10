/* Alchemer ver01

   Capture order of options of a randomized question

   Documentation and updates:  https://help.alchemer.com/help/mirror-the-order-of-randomized-option-in-later-questions
*/

/* ----------------------------------------------------
   DOM loaded
   ---------------------------------------------------- */
$SG(function () {
    // Checkbox or Radio button question ID with randomized option order
    const RANDOMIZED_QID = 75;

    // Hidden Value or Textbox question ID to save the order
    const SAVE_ORDER_QID = 78;

    // * * * * * * * * * * * * * *
    // * no changes needed below *
    // * * * * * * * * * * * * * *

    const LOG = true;

    if (LOG) console.log("saving...");

    /* ---------------------------------------
       Helper: Get a SurveyGizmo element on the page.
               Ex: In survey 1234567 on page ID 12 the call getSgId(123, "element")
                   returns HTML element for "sgE-1234567-12-123-element"
       --------------------------------------- */
    function getSgElemById(qid, oid = "element") {
        let surveyInfo = SGAPI.surveyData[Object.keys(SGAPI.surveyData)[0]];
        let id = "sgE-" + surveyInfo.id + "-" + surveyInfo.currentpage + "-" + qid + "-" + oid;
        let elem = document.getElementById(id);
        if (!elem) alert("Javascript error: can't find element with id = " + id);
        return elem;
    }

    /* ---------------
       getQuestionType() - returns 'radio-button', 'checkbox', 'grid', or null
       --------------- */
    let getQuestionType = (quesElem) => {
        if (quesElem.classList.contains("sg-type-radio")) return "radio-button";
        if (quesElem.classList.contains("sg-type-checkbox")) return "checkbox";
        if (quesElem.classList.contains("sg-type-table")) return "grid";
        if (quesElem.classList.contains("sg-type-continuous-sum")) return "sum";
        alert("Javascript error: unknown question type");
        return null;
    };

    /* ----------------------------------------------------
       saveOrder()
  
       Save a '|' delimited list of titles for each option in the randomized question
       ---------------------------------------------------- */
    let saveOrder = (randomizedQID, saveOrderQID) => {
        /* ---------------
         straightenQuotes() -- convert angled quotes to straigt
         --------------- */
        let straightenQuotes = (s) => {
            return s.replace(`“`, `"`).replace(`”`, `"`).replace(`‘`, `'`).replace(`’`, `'`);
        };

        /* ---------------
         getGridOrder() -- get string with order of Grid Question
         --------------- */
        let getGridOrder = (quesElem) => {
            let rowElems = quesElem.querySelectorAll(".sg-question-options tbody tr");
            for (let i = 0; i < rowElems.length; i++) {
                order += (order ? "|" : "") + straightenQuotes(rowElems[i].querySelector("th").innerText.trim());
            }
            return order;
        };

        /* ---------------
         getRbCbOrder() -- get string with order of radio button or checkbox question
         --------------- */
        let getRbCbOrder = (quesElem) => {
            let inputClassname = getQuestionType(quesElem) === "radio-button" ? "sg-input-radio" : "sg-input-checkbox";

            // carefully select only the radio buttons/checkboxes, not the Other Write-in Textbox
            let inputElems = quesElem.querySelectorAll(`.sg-question-options input.${inputClassname}`);
            for (let i = 0; i < inputElems.length; i++) {
                order += (order ? "|" : "") + straightenQuotes(inputElems[i].getAttribute("aria-label"));
            }
            return order;
        };

        let getSumOrder = (quesElem) => {
            let rowElems = quesElem.querySelectorAll(".sg-question-options tbody tr");
            console.log(rowElems);
            for (let i = 0; i < rowElems.length; i++) {
                order += (order ? "|" : "") + straightenQuotes(rowElems[i].querySelector("td:nth-child(1)").innerText.trim());
            }
            return order;
        };

        /* ---------------
         main()
         --------------- */

        let order = "";

        let quesElem = getSgElemById(randomizedQID, "box");

        // Get order from radio button, checkbox, or grid question type
        switch (getQuestionType(quesElem)) {
            case "radio-button":
            case "checkbox": {
                order = getRbCbOrder(quesElem);
                break;
            }
            case "grid":
                order = getGridOrder(quesElem);
                break;
            case "sum":
                order = getSumOrder(quesElem);
                break;
        }

        getSgElemById(saveOrderQID).value = order;
        if (LOG) console.log("saved value = ", getSgElemById(saveOrderQID).value);
    };

    /* ---------------
       main()
       --------------- */
    saveOrder(RANDOMIZED_QID, SAVE_ORDER_QID);
});
