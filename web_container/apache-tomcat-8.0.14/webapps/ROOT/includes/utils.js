var xenos_utils = {};

// fade is a simple utility to fade an element to transparent.
// element_id is the id of an element we will fade
xenos_utils.fade = function(element_id) {
      var element = document.getElementById(element_id);
      element.style.opacity = 1; 

      var do_the_fade = function() {
        if ((element.style.opacity-=.1) < 0) { 
        //  var element_kill = document.getElementById('notification_dialog');
          document.body.removeChild(element);
        } else {
          setTimeout(do_the_fade,40);
        }
      };

      do_the_fade(); //kick it off.
};
