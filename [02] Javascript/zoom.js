// Zoom Function
// This function will show the image in the lightbox
var zoomImg = function () {
  // Create evil image clone
  var clone = this.cloneNode();
  clone.classList.remove("zoomD");
  // Put evil clone into lightbox
  var lb = document.getElementById("lb-img");
  lb.innerHTML = "";
  lb.appendChild(clone);
  // Show lightbox
  lb = document.getElementById("lb-back"); 
  lb.classList.add("show");
};
window.addEventListener("load", function(){
  // Attach on click events to all .zoomD images
  var images = document.getElementsByClassName("zoomD");
  if (images.length>0) {
    for (var img of images) {
      img.addEventListener("click", zoomImg);
    }
  }
  // Click event to hide the lightbox
  document.getElementById("lb-back").addEventListener("click", function(){
    this.classList.remove("show");
  })
});

