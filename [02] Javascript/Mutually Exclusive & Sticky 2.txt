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

function isChecked(data, value) {
    for (let i = 0; i < data.length; i++) {
        const checkbox = data[i];
        if (checkbox.value === value && checkbox.checked) {
            return true;
        }
    }
    return false;
}

const findKeyByValue = (data, value) => {
    const element = data.find((item) => item.value === value + "");
    return element ? element.key : null;
};

const sticky = (data, first, second) => {
    let firstOption, secondOption;
    // console.log(`first : ${first}`,`second : ${second}`)
    for (let i = 0; i < data.length; i++) {
        const cb = data[i];
        if (cb.value === first) {
            firstOption = $(`li:has(input[value="${first}"])`);
        }
        if (cb.value === second) {
            secondOption = $(`li:has(input[value="${second}"])`);
        }
    }
    // console.log(firstOption.text(),secondOption.text())
    secondOption.detach();
    firstOption.after(secondOption);
};

$SG(function () {
    const SOURCE_ID = 106;
    const reportingValues = getReportingValuesByQid(SOURCE_ID);
    const mergeGroups = [
        [3, 4],
        [5, 6],
    ];

    const checkboxes = $("input[type='checkbox']");

    const mergeGroupsSKU = (function () {
        const rst = [];
        for (let i = 0; i < mergeGroups.length; i++) {
            for (let j = 0; j < mergeGroups[i].length; j++) {
                if (!rst[i]) {
                    rst[i] = [];
                }
                rst[i][j] = findKeyByValue(reportingValues, mergeGroups[i][j]);
            }
        }
        return rst;
    })();

    const mergeGroupsCheckboxes = mergeGroups.map((group) => {
        return group.map((value) => {
            let sku = findKeyByValue(reportingValues, value);
            return checkboxes.filter(`[value="${sku}"]`);
        });
    });

    mergeGroupsSKU.forEach((vals) => {
        let firstSKU, secondSKU;
        vals.forEach((sku) => {
            //   let sku = findKeyByValue(reportingValues, val);
            if (firstSKU === undefined) {
                firstSKU = sku;
            } else if (firstSKU !== undefined && secondSKU === undefined) {
                secondSKU = sku;
            }
        });

        sticky(checkboxes, firstSKU, secondSKU);
    });

    console.log(checkboxes);
    console.log(mergeGroupsCheckboxes);

    checkboxes.on("change", function () {
        const $this = $(this);
        const value = $this[0].value + "";
      
        for (let i = 0; i < mergeGroupsSKU.length; i++) {
          if (mergeGroupsSKU[i].includes(value)) {
            if ($this[0].checked) {
              for (let j = 0; j < mergeGroupsSKU[i].length; j++) {
                if (mergeGroupsSKU[i][j] != value) {
                  console.log(`${mergeGroupsSKU[i][j]} is disabled`);
                  $(`input[type="checkbox"][value="${mergeGroupsSKU[i][j]}"]`).prop("disabled", true);
                }
              }
            } else {
              let otherChecked = false;
              for (let j = 0; j < mergeGroupsSKU.length; j++) {
                if (j != i) {
                  for (let k = 0; k < mergeGroupsSKU[j].length; k++) {
                    let otherCheckbox = $(`input[type="checkbox"][value="${mergeGroupsSKU[j][k]}"]`);
                    if (otherCheckbox.prop("checked")) {
                      otherChecked = true;
                      break;
                    }
                  }
                }
                if (otherChecked) {
                  break;
                }
              }
              if (!otherChecked) {
                for (let j = 0; j < mergeGroupsSKU[i].length; j++) {
                  console.log(`${mergeGroupsSKU[i][j]} is enabled`);
                  let currentOption = $(`input[type="checkbox"][value="${mergeGroupsSKU[i][j]}"]`);
                  currentOption.prop("disabled", false);
                }
              }
            }
          }
        }
      });
});
