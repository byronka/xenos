  var xenos_utils = {};

  xenos_utils.timeout_counter = function() {

    var halt = false;
    var alert_displayed = false;

    //this calls itself to countdown, once a second.
    var recurse_countdown = function(countdown) {
      if (countdown > 0 && !halt) {
        if (countdown == (60 * 5)) {
          var alert_div = document.createElement("div");
          alert_div.setAttribute('id','timeout_dialog');
          var style_values="width: 200px; height: 200px; top: 200px; left: 200px; background-color: gold; z-index: 200; position: fixed;";
          alert_div.setAttribute('style', style_values);
          alert_div.innerHTML = 'Hi Mom!  You have <span id="countdown_seconds" ></span> seconds left!<button>I\'m not done!</button>';
          document.body.appendChild(alert_div);
          document.getElementById('countdown_seconds').textContent = countdown;
          alert_displayed = true;
        }
        if (alert_displayed) {
          var alert_div = document.getElementById('timeout_dialog');
          document.getElementById('countdown_seconds').textContent = countdown;
        }
          
        countdown--;
        setTimeout(recurse_countdown, 1000, countdown);
      }
    };

    //init halt to false and kick off recursive countdown.
    var start_countdown = function(count) {
      halt = false;
      recurse_countdown(count);
    };

    //this is a public piece to allow halting the countdown
    var halt_countdown = function() {
      halt = true;
    };

    return {halt : halt_countdown, start : start_countdown};

  }

  //a helper method to run the command in the timeout_counter.
  xenos_utils.start_timer = function() {
    //get the number of seconds by looking at the value stored in "timeout_value"
    var seconds = Number(
        document.getElementById(
          'timeout_value').getAttribute('value')); 

    //kick off the countdown.
    xenos_utils.timeout_counter().start(seconds);
  };   

  xenos_utils.start_timer();


