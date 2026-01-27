document.addEventListener("DOMContentLoaded", function() {
  
  /***
   * Check if this page is being shown because user clicked the Back button on the following page. 
   *
   * return (t/f) true if moving back
   */
  const isMovingBack = () => 
    SGAPI.surveyData[Object.keys(SGAPI.surveyData)[0]].page_direction === -2

  /***
   * Click Back or Next button
   */
  const back = () => document.querySelector("#sg_BackButton").click()
  const next = () => (document.querySelector("#sg_NextButton") || document.querySelector("#sg_SubmitButton")).click();
  
  /***
   * main()
   */

  // Moving back?
  if (isMovingBack()) {
    back()
    return
  }
    

  next()
})