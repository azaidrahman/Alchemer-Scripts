// Hide specific option table
$(document).ready(function(){
   
    let toHide1 = document.getElementById("sgE-5732943-46-170-10242")
    let toHide2 = document.getElementById("sgE-5732943-46-170-10243")
    toHide1.disabled = true
    toHide2.disabled = true
    //$('label[for="sgE-5732943-46-170-10242"]').hide()
    toHide1.nextElementSibling.style.display = "none"
    toHide2.nextElementSibling.style.display = "none"
    
  });
  