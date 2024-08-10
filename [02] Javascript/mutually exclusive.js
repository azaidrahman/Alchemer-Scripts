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
  assert(
    SGAPI.survey.surveyObject.questions[_qid],
    "Can't find qid on this page: " + _qid
  );

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

function isChecked(nodeList, value) {
  for (let i = 0; i < nodeList.length; i++) {
    const checkbox = nodeList[i];
    if (checkbox.value === value && checkbox.checked) {
      return true;
    }
  }
  return false;
}

const valuesToDisable = [4, 7, 9];
const skuToDisable = [];
const mutExcValue = 11;

$SG(function () {
  const s = 77;

  const reportingValues = getReportingValuesByQid(s);
  // const reportingValues = Array.from(reportingValuesObject)
  const checkboxes = document.querySelectorAll("input[type='checkbox']");
  // const values = Array.from(checkboxes).map(checkbox => parseInt(checkbox.value, 10));
  let mutExcSKU;

  reportingValues.forEach((opt) => {
    if (valuesToDisable.includes(+opt.value)) {
      skuToDisable.push(opt.key);
    }
    if (+opt.value === mutExcValue) {
      mutExcSKU = opt.key;
    }
  });

  checkboxes.forEach((checkbox) => {
    checkbox.addEventListener("change", function () {
      if (isChecked(checkboxes, mutExcSKU)) {
        checkboxes.forEach((cb) => {
          if (skuToDisable.includes(cb.value)) {
            cb.checked = false;
            cb.disabled = true;
          }
        });
      } else {
        checkboxes.forEach((cb) => {
          if (skuToDisable.includes(cb.value)) {
            cb.disabled = false;
          }
        });
      }
    });
  });
});
