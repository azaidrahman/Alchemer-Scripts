function checkAndHideOption(qid, orv) {
    // Step 1: Find the SKU for the option with a reporting value of 3
    const sku = getSkuByValue(qid, orv);
    assert(sku, "No option with reporting value "+ orv +" found for qid: " + qid);

    // Step 2: Check this option
    setCheckedByQid(qid, sku);

    // Step 3: Hide this option
    const optionsContainer = getElemByQid(qid, "box");
    const optionToHide = optionsContainer.querySelector(`input[value="${sku}"]`);
    assert(optionToHide, "Option to hide not found for SKU: " + sku);
    optionToHide.parentElement.style.display = 'none';
}

const setCheckedByQid = (qid, _checkOptionIds) => {
    // convert param to an array if it was a single value
    let checkOptionIds = Array.isArray(_checkOptionIds) ? _checkOptionIds : [_checkOptionIds];

    // ensure array is all integers
    checkOptionIds = checkOptionIds.map((id) => parseInt(id));

    // go through all options and check or uncheck them
    getElemByQid(qid, "box")
        .querySelectorAll(".sg-question-options input")
        .forEach((inputElem) => (inputElem.checked = checkOptionIds.includes(parseInt(inputElem.value))));
};

const assert = (bool, msg) => {
    msg = "Javascript Assert Error: " + msg;
    if (!bool) {
        alert(msg);
        console.error(msg);
        const err = new Error(msg);
        console.error(err);
        throw err;
    }
};

const getReportingValuesByQid = (_qid) => {
    assert(SGAPI.survey.surveyObject.questions[_qid], "Can't find qid on this page: " + _qid);

    let qid = _qid;

    // if this is a grid question, get the reporting values from the first row
    if (SGAPI.survey.surveyObject.questions[qid].sub_question_skus)
        qid = SGAPI.survey.surveyObject.questions[qid].sub_question_skus[0];

    const optionsObj = SGAPI.survey.surveyObject.questions[qid].options;
    assert(optionsObj, "QID isn't a radio button or checkbox question: " + qid);

    return Object.keys(optionsObj).map((optionId) => ({
        key: optionId,
        value: optionsObj[optionId].value,
    }));
};

const getElemByQid = (qid, section = "element") => {
    const id = "sgE-" + SGAPI.survey.surveyObject.id + "-" + SGAPI.survey.pageId + "-" + qid + "-" + section;
    const elem = document.getElementById(id);
    assert(elem, "Javascript: can't find element with id = " + id);
    return elem;
};

function getSkuByValue(qid, v) {
    const RV = getReportingValuesByQid(qid);
    for (let i = 0; i < RV.length; i++) {
        if (+RV[i].value === v) {
            return RV[i].key;
        }
    }
}

$SG(function () {
    const qid = 58
    const options = [1,2,3]
    checkAndHideOption(qid,3)
    options.forEach(elem => checkAndHideOption(qid,elem))
});
