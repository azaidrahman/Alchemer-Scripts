$SG(function () {
    function getSgElemById(qid, oid = "element", suppressError = false) {
        let surveyInfo = SGAPI.surveyData[Object.keys(SGAPI.surveyData)[0]];
        let id = "sgE-" + surveyInfo.id + "-" + surveyInfo.currentpage + "-" + qid + "-" + oid;
        let elem = document.getElementById(id);
        if (!elem && !suppressError) alert("Javascript error: can't find element with id = " + id);
        return elem;
    }

    let textboxList = getSgElemById(86, "box");
    let exclusive = getSgElemById(87, "box");

    const tbElems = textboxList.querySelector("td");
    const exElems = exclusive.querySelector("input[type=radio]");

    exElems.addEventListener("click", function () {
        if (this.checked) {
            this.checked = false;
            console.log("a");
        } else {
            this.checked = true;
            console.log("b");
        }
    });
});
