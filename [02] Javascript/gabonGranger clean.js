var PRODUCT_CODE = 0
var BASE = "sgE-7174016";

var pages = [
    60,93,94,95,96,97
]
var questions = [
    [158,142,150,152,153,154,155],
    [213,214,215,216,217,218,219],
    [224,225,226,227,228,229,230],
    [234,235,236,237,238,239,240],
    [244,245,246,247,248,249,250],
    [254,255,256,257,258,259,260]
]

var yesno = [
    [10389,10375,10377,10381,10383,10385,10387],
    [10571,10573,10575,10577,10579,10581,10583],
    [10585,10587,10589,10591,10593,10595,10597],
    [10599,10601,10603,10605,10607,10609,10611],
    [10613,10615,10617,10619,10621,10623,10625],
    [10627,10629,10631,10633,10635,10637,10639]
]

var hiddens = [
    [143,144],
    [211,212],
    [222,223],
    [232,233],
    [242,243],
    [252,253]
]
var PAGE = `-${pages[PRODUCT_CODE]}-`;
var PRICES = [
    ["14.10","28.20","42.30","56.40","70.50","84.60","98.70","112.80","126.90","141.00"],
    ["9.40","18.80","28.30","37.70","47.10","56.50","65.90","75.40","84.80","94.20"],
    ["113.00","226.10","339.10","452.20","565.20","678.30","791.30","904.30","1,017.40","1,130.40"],
    ["10.80","21.60","32.40","43.25","54.10","64.90","75.70","86.50","97.30","108.10"],
    ["6.10","12.20","18.40","24.50","30.60","36.70","42.85","49.00","55.10","61.20"],
    ["73.50","146.90","220.40","293.80","367.30","440.75","514.20","587.70","661.10","734.60"]
]

var journey = document.getElementById(BASE+PAGE+ hiddens[PRODUCT_CODE][0] +"-element")
var finalPrice = document.getElementById(BASE+PAGE+ hiddens[PRODUCT_CODE][1] +"-element") 
var journeyText = ""
var curr
var timesAnswered = 0

function getRandomIntInclusive(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1) + min); // The maximum is inclusive and the minimum is inclusive
}
  

function init(prodType,n){
    curr = getRandomIntInclusive(4,6)
    // curr = 6;
    let currentQuesText = $(`#${BASE + PAGE + questions[prodType][n]}-box > .sg-question-title span#PLACEHOLDER`)
    let price = PRICES[prodType]
    // console.log("RM " + price[curr-1])
    currentQuesText.html("RM " + price[curr-1])
    journeyText += "RM "+ price[curr-1] + ", "
    $(`.sg-question#${BASE+PAGE+questions[prodType][n]}-box`).show()
}
  
function setPrice(prodType,n,isYes){
    // let prevQuestion = $(`.sg-question #${BASE+PAGE+questions[prodType][n]}-box`)
    let currQuestion = $(`.sg-question#${BASE+PAGE+questions[prodType][n]}-box`)
    let nextQuestion = $(`.sg-question#${BASE+PAGE+questions[prodType][n+1]}-box`)
    let nextQuesText = $(`#${BASE + PAGE + questions[prodType][n+1]}-box > .sg-question-title span#PLACEHOLDER`)
    let price = PRICES[prodType]    
    journeyText += price[curr-1] ?  "RM "+ price[curr-1] + ", " : ""
    curr = isYes ? curr + 1 : curr - 1
    timesAnswered += 1
    console.log(`current curr: ${curr}, times ans: ${timesAnswered}, `)
    if (n != 0)
    {
        let prevQuesYes = document.getElementById(BASE+PAGE+questions[prodType][n-1] + "-" + yesno[prodType][n-1])
        let prevQuesNo = document.getElementById(BASE+PAGE+questions[prodType][n-1] + "-" + (yesno[prodType][n-1]+1))

        // console.log(`isYes: ${isYes}, prevNo: ${prevQuesNo.checked}, prevYes: ${prevQuesYes.checked}`)

        if ( ((curr > 10) || (isYes && prevQuesNo.checked) || ((curr < 1) || !isYes && prevQuesYes.checked) ) || timesAnswered >= 6){
            console.log(curr)            
            journey.value = journeyText.slice(0,-2)
            finalPrice.value = curr > 10 ? price[price.length-1] : curr < 1 ? price[0] : price[curr-1]
            // finalPrice.value = timesAnswered < 6 ? price[curr-1].toString() : price[curr].toString()
            
            let selector = document.querySelector("#sg_NextButton") || document.querySelector("#sg_SubmitButton")
            // console.log('go next')
            selector.click();
            return
        }
    }

    console.log(timesAnswered)
    nextQuesText.html("RM "+ price[curr-1])
    nextQuestion.show()
}

$SG(function(){
    for (let i = 0; i < questions[PRODUCT_CODE].length; i++){
        $(`.sg-question#${BASE+PAGE+questions[PRODUCT_CODE][i]}-box`).hide()
        let yes = document.getElementById(BASE + PAGE + questions[PRODUCT_CODE][i] + "-" + yesno[PRODUCT_CODE][i])
        let no = document.getElementById(BASE + PAGE + questions[PRODUCT_CODE][i] + "-" + (yesno[PRODUCT_CODE][i]+1))
        yes.addEventListener("click", () => {setPrice(PRODUCT_CODE,i,true);},false);
        no.addEventListener("click", () => {setPrice(PRODUCT_CODE,i,false);},false);
    }
    init(PRODUCT_CODE,0)
    $("#sg_NextButton").hide()
    $("#sg_BackButton").hide()
    
} );
