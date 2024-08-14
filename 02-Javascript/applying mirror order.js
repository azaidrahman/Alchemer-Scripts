/* Alchemer ver 01

   Mirror order of previously randomized question options

   Documentation and updates:  https://help.alchemer.com/help/mirror-the-order-of-randomized-option-in-later-questions
*/

/* ----------------------------------------------------
   DOM loaded
   ---------------------------------------------------- */
$SG(function () {
    function getSgElemById(qid, oid = "element", suppressError = false) {
        let surveyInfo = SGAPI.surveyData[Object.keys(SGAPI.surveyData)[0]];
        let id = "sgE-" + surveyInfo.id + "-" + surveyInfo.currentpage + "-" + qid + "-" + oid;
        let elem = document.getElementById(id);
        if (!elem && !suppressError) alert("Javascript error: can't find element with id = " + id);
        return elem;
    }

    /* ---------------------------------------
       Helper: get value of a textbox/hidden value QID or null if it doesn't exist
       --------------------------------------- */
    function getSgElemById_value(qid) {
        let elem = getSgElemById(qid, "element", true);
        return elem ? elem.value : null;
    }
    // the value from the the Hidden Value Action that stores the order of the randomized options
    let ORDER_STRING = getSgElemById_value(78) || '[question("value"), id="78"]';

    // the question id of the question to mirror the randomized question option order
    const MIRROR_QID = 76;

    // * * * * * * * * * * * * * *
    // * no changes needed below *
    // * * * * * * * * * * * * * *

    const LOG = true;

    if (LOG) console.log("mirroring... = ", ORDER_STRING);

    /* ---------------------------------------
       Helper: Get a SurveyGizmo element on the page.
               Ex: In survey 1234567 on page ID 12 the call getSgId(123, "element")
                   returns HTML element for "sgE-1234567-12-123-element"
       --------------------------------------- */

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
       pullElemsFromDOM()
       Return array of elems pulled out of the DOM for the mirrored question
       ---------------------------------------------------- */
    let pullElemsFromDOM = (mirrorElem) => {
        let unorderedElems = [];
        switch (getQuestionType(mirrorElem)) {
            case "radio-button":
            case "checkbox":
                let liElems = mirrorElem.querySelectorAll("li");
                for (let i = 0; i < liElems.length; i++) unorderedElems.push(liElems[i].parentElement.removeChild(liElems[i]));
                break;
            case "grid":
                let rowElems = mirrorElem.querySelectorAll(".sg-question-options tbody tr");
                for (let i = 0; i < rowElems.length; i++) {
                    unorderedElems.push(rowElems[i].parentElement.removeChild(rowElems[i]));
                }
                break;
            case "sum":
                let sumElems = mirrorElem.querySelectorAll(".sg-question-options tbody tr");
                for (let i = 0; i < sumElems.length; i++) {
                    unorderedElems.push(sumElems[i].parentElement.removeChild(sumElems[i]));
                }
                break;
        }
        return unorderedElems;
    };

    /* ---------------
       getContainer() - get the container to add the ordered elements into
       --------------- */
    let getContainer = (mirrorElem) => {
        switch (getQuestionType(mirrorElem)) {
            case "radio-button":
            case "checkbox":
                return mirrorElem.querySelector("ul");
                break;
            case "sum":
            case "grid":
                return mirrorElem.querySelector("tbody");
                break;
        }
        return null;
    };

    /* ---------------
       getOptionTitle() - get the option title from an element
       --------------- */
    let getOptionTitle = (questionType, elem) => {
        /* ---------------
         straightenQuotes() -- convert angled quotes to straigt
         --------------- */
        let straightenQuotes = (s) => {
            return s.replace(`“`, `"`).replace(`”`, `"`).replace(`‘`, `'`).replace(`’`, `'`);
        };

        /* ---------------
         main()
         --------------- */
        switch (questionType) {
            case "radio-button":
            case "checkbox":
                return straightenQuotes(elem.querySelector("input").getAttribute("aria-label"));
                break;
            case "grid":
                return straightenQuotes(elem.querySelector("th").innerText.trim());
                break;
            case "sum":
                return straightenQuotes(elem.querySelector("td:nth-child(1)").innerText.trim());
                break;
        }
        return null;
    };

    /* ---------------
       getUnorderedElem() - get unoirdered elem matching optionTitle
       --------------- */
    let getUnorderedElem = (questionType, unorderedElems, optionTitle) => {
        if (LOG) console.log("Search for: ", optionTitle);
        let elem = unorderedElems.find((testElem) => {
            if (LOG) console.log("-- testing: ", getOptionTitle(questionType, testElem));
            return optionTitle === getOptionTitle(questionType, testElem);
        });
        if (!elem) alert("Javascript error - missing option in mirrored list: " + optionTitle);
        return elem;
    };

    /* ---------------
       fixupDisplayDetails() - fix classes that affect appearance
       --------------- */
    let fixupDisplayDetails = (mirrorElem) => {
        /* -------------
         fixup radio button / checkbox to have the first/last classes in the correct spots
         ------------- */
        let fixupFirstLastClass = () => {
            let liElems = mirrorElem.querySelectorAll("li");
            for (let i = 0; i < liElems.length; i++) {
                liElems[i].classList.remove("sg-first-li");
                liElems[i].classList.remove("sg-last-li");
            }
            liElems[0].classList.add("sg-first-li");
            liElems[liElems.length - 1].classList.add("sg-last-li");
        };

        /* -------------
         fixup grid to alternate the gray shading for each row
         ------------- */
        let fixupAlternateRowGray = () => {
            let oddRow = true;
            mirrorElem.querySelectorAll("tbody tr").forEach((row) => {
                row.classList.remove("sg-odd-row");
                row.classList.remove("sg-even-row");
                // apply correct sg-odd-row or sg-even-row if not hidden
                if (!row.classList.contains("sg-hide")) {
                    row.classList.add(oddRow ? "sg-odd-row" : "sg-even-row");
                    oddRow = !oddRow;
                }
            });
        };

        /* -------------
         main
         ------------- */
        switch (getQuestionType(mirrorElem)) {
            case "radio-button":
            case "checkbox":
                fixupFirstLastClass();
                break;
            case "grid":
                fixupAlternateRowGray();
                break;
        }
    };

    /* ----------------------------------------------------
       mirrorOrder()
       Mirror order of previously randomized question
       ---------------------------------------------------- */
    let mirrorOrder = (mirrorQID, orderString) => {
        let mirrorElem = getSgElemById(mirrorQID, "box");
        let unorderedElems = pullElemsFromDOM(mirrorElem);
        let orderArray = ORDER_STRING.split("|");
        let container = getContainer(mirrorElem);
        if (LOG) console.log("ordering...");
        orderArray.forEach((optionTitle) => {
            let unorderedElem = getUnorderedElem(getQuestionType(mirrorElem), unorderedElems, optionTitle);
            container.appendChild(unorderedElem);
        });
        fixupDisplayDetails(mirrorElem);
    };

    /* ----------------------------------------------------
       main()
       ---------------------------------------------------- */
    mirrorOrder(MIRROR_QID, ORDER_STRING);
});
