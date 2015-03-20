var xenos_utils = {};

//this function serves one purpose - fading in a background
//once it is loaded.  The general concept is: there is an image
//element on the page that is display: none.  
//once it is done loading, this will be called to set it visible
// but totally transparent.  Then it gets faded in.
xenos_utils.fade_in_background = function() {
      var background = document.getElementById('my_background');
      background.style.opacity = 0;

      var do_the_fade = function() {
        var curr_opac = background.style.opacity;
        curr_opac = Number(curr_opac) + 0.1;
        background.style.opacity = curr_opac;
        if (curr_opac < 1) { 
          setTimeout(do_the_fade,40);
        }
      };

      do_the_fade(); //kick it off.
};
