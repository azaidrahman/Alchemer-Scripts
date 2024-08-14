var BASE = "sgE-7174016";
var PAGE = "-60-";
var PROD

var hiddens = [
    [143,144,145,146,147,148,149]
]

var questions = [
    [158,142,150,152,153,154,155]
]

var yesno = [
    [10389,10375,10377,10381,10383,10385,10387]
]

var PRICES = [
    ["14.10","28.20","42.30","56.40","70.50","84.60","98.70","112.80","126.90","141.00"]
]

function init(version,prodType,n){
    let currentHidden = document.getElementById(BASE+PAGE+ hiddens[prodType][n]+"-element")
    let currentQuesText = document.getElementById(version+n)
    let randomNumber = currentHidden.value;
    let price = PRICES[prodType]
    currentQuesText.innerHTML = "RM "+price[randomNumber-1]; 
}
  
function setPrice(version,prodType,n,isYes){

    let currentHidden = document.getElementById(BASE+PAGE + hiddens[prodType][n]+"-element")
    let nextHidden = document.getElementById(BASE+PAGE+ hiddens[prodType][n+1]+"-element")
    let nextQuesText = document.getElementById(version+(n+1)) 
    
    let price = PRICES[prodType]    
    let randomNumber = isYes ? currentHidden.value*1 + 1 : currentHidden.value*1 - 1

    console.log("before:- " + "current: "+ currentHidden.value)
    console.log("current n: "+ n)
    console.log(randomNumber + "-" + price[randomNumber])
    if (n != 0 )
    {
        let prevQuesYes = document.getElementById(BASE+PAGE+questions[prodType][n-1] + "-" + yesno[prodType][n-1])
        let prevQuesNo = document.getElementById(BASE+PAGE+questions[prodType][n-1] + "-" + (yesno[prodType][n-1]+1))

        if (
            ((randomNumber > 10) || (isYes && (prevQuesYes.checked == true))) || ((randomNumber < 1) || (!isYes && (prevQuesNo.checked == true)))
        ){
            
            (document.querySelector("#sg_NextButton") || document.querySelector("#sg_SubmitButton")).click();
        }
        // console.log("not 0:" + randomNumber)
    }

    
    nextHidden.value = randomNumber;
    let nextRandom = nextHidden.value*1;
    nextQuesText.innerHTML = "RM "+ price[nextRandom-1];
    console.log("after:- " + "current: "+ currentHidden.value + " next: " + nextHidden.value)
}

$SG(function(){
    init("Pro_M2M",0,0)
    // console.log("a")
    for (let i = 0; i < questions[0].length; i++){
        let yes = document.getElementById(BASE + PAGE + questions[0][i] + "-" + yesno[0][i])
        let no = document.getElementById(BASE + PAGE + questions[0][i] + "-" + (yesno[0][i]+1))
        yes.addEventListener("click", () => {setPrice("Pro_M2M",0,i,true);},false);
        no.addEventListener("click", () => {setPrice("Pro_M2M",0,i,false);},false);
    }

} );
