  var xenos_utils = {};

  xenos_utils.timeout_counter = function() {

    var halt = false;
    var alert_displayed = false;

		var alert_text = 
			"<div id='timeout_dialog'                                                " +                    
			"	style='font-size: 20px;width: 300px; height: 220px;                    " +                    
			"		top: 200px; left: 200px; background-color: gold;                     " + 
			"		z-index: 1; position: fixed;'>                                       " + 
			"	<div style='width: 250px;margin-left:auto;                             " +
			"      margin-right:auto;margin-top:10px'>                               " + 
			"		Are you asleep? Wake up! You                                         " + 
			"		have <span id='countdown_seconds'></span> seconds left before        " + 
			"		you are automatically logged out.                                    " + 
			"		<button style='margin-top:10px;margin-bottom:10px;margin-left:auto;  " + 
			"		margin-right:auto;width:130px;display:block;padding-top:10px;        " + 
			"		padding-bottom:10px;font-size: 18px' onclick='xenos_utils.counter.halt();'>" + 
			"		I am not done!                                                       " + 
			"		</button>                                                            " + 
			"	</div>                                                                 " + 
			"</div>                                                                  ";
    //this calls itself to countdown, once a second.

    var recurse_countdown = function(countdown) {
      if (countdown === 0) {
				//We hit the end of countown - logout.
				location = 'logout.jsp';
				return;
			}
			if (halt) {
				// the user stopped the countdown - reset the timeout.
				location.reload();
				return;
			}
			if (countdown == (60 * 5)) {  //HERE is where we set the point where the alert shows.
				document.body.insertAdjacentHTML('afterbegin', alert_text);
				document.getElementById('countdown_seconds').textContent = countdown;
				alert_displayed = true;
			}
			if (alert_displayed) {
				var alert_div = document.getElementById('timeout_dialog');
				document.getElementById('countdown_seconds').textContent = countdown;
			}
				
			countdown--;
			setTimeout(recurse_countdown, 1000, countdown);
		};

    var start_countdown = function(count) {
      halt = false;
      recurse_countdown(count);
    };

    var halt_countdown = function() {
      halt = true;
    };

		//return two public methods: halt, and start.
    return {halt : halt_countdown, start : start_countdown};

  }

  //a helper method to run the command in the timeout_counter.
  xenos_utils.start_timer = function() {
    //get the number of seconds by looking at the value stored in "timeout_value"
    var seconds = Number(
        document.getElementById('timeout_value').getAttribute('value')); 

    //kick off the countdown.
    xenos_utils.counter = xenos_utils.timeout_counter();
		xenos_utils.counter.start(seconds);
  };   

  xenos_utils.start_timer();


