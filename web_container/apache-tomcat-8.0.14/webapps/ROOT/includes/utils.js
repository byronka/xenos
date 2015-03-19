var xenos_utils = {};

// fade is a simple utility to fade an element to transparent.
// element_id is the id of an element we will fade
xenos_utils.fade = function(element_id) {
      var element = document.getElementById(element_id);
      element.style.opacity = 1; 
      var fade = function() {
        if ((element.style.opacity -=.1) > 0) { 
          setTimeout(fade,40);
        }
      };
      fade(); //kick it off.
};
