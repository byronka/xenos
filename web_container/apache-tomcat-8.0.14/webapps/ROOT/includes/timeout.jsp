<script type="text/javascript">
  var xenos_timeout = {};

  xenos_timeout.timeout_counter = function() {

    var halt = false;
    var alert_displayed = false;
    var old_title = document.title;

    var alert_text =                                                
      "<div id='timeout_dialog'                               " +
      " style='font-size: 20px;                               " +
      "   width: 100%; height: 220px;                         " +
      "   top: 200px; background-color: gold;                 " +
      "   z-index: 1; position: fixed;'>                      " +
      " <div style='width: 250px;margin-left:auto;            " +
      "      margin-right:auto;margin-top:10px'>              " +
      "<%=loc.get(178,"Are you asleep? Wake up! You have")%>  " +
      " <span id='countdown_seconds'></span>                  " +
      "<%=loc.get(179,"seconds left before you are automatically logged out!")%>" +
      "   <button style='margin-top:10px;margin-bottom:10px;  " +
      "    margin-left:auto;margin-right:auto;width:130px;    " +
      "    display:block;padding-top:10px;                    " +
      "   padding-bottom:10px;font-size: 18px'                " +
      "    onclick='xenos_timeout.counter.halt();'>           " +
      "   I am not done!                                      " +
      "   </button>                                           " +
      " </div>                                                " +
      "</div>                                                 ";
    //this calls itself to countdown, once a second.

    var recurse_countdown = function(countdown) {
      if (halt) {
        //simply calls to a secured page that updates the 
        //last activity to now
        var request = new XMLHttpRequest(); 
        request.open("GET", "wake_up.jsp"); 
        request.send();
        //reset the countdown to what it started at
        message_hider();
        document.title = old_title;
        xenos_timeout.start_timer();
        return;
      }
      //if we hit countdown of 0, we are already logged out on the
      // server.  Just refresh the page to the login screen.
      if (countdown == 0) {
        document.location = 'login.jsp';
        return;
      }
      //HERE is where we set the point where the alert shows.
      if (countdown == (60 * 5)) { 
        document.body.insertAdjacentHTML('afterbegin', alert_text);
        document.getElementById('countdown_seconds').textContent = countdown;
        alert_displayed = true;
      }
      if (alert_displayed) {
        var alert_div = document.getElementById('timeout_dialog');
        document.getElementById('countdown_seconds')
          .textContent = countdown;
        document.title = 'timeout in ' + countdown + ' seconds';
      }
        
      countdown--;
      setTimeout(recurse_countdown, 1000, countdown);
    };

    //This fades out the dialog until invisible, then removes it from
    // the DOM
    var message_hider = function() {
      var dialog = document.getElementById('timeout_dialog');
      dialog.style.opacity = 1; 
      var fade = function() {
        if ((dialog.style.opacity-=.1) < 0) { 
          var dialog_kill = document.getElementById('timeout_dialog');
          document.body.removeChild(dialog_kill);
        } else {
          setTimeout(fade,40);
        }
      };
      fade(); //kick it off.
    }

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

  //a helper method to run the command in 
  //the timeout_counter.
  xenos_timeout.start_timer = function() {
    //get the number of seconds by looking at 
    //the value stored in "timeout_value"
    var seconds = Number(
        document.getElementById('timeout_value').getAttribute('value')); 

    // give a little wiggle room - the event fires every 5 seconds.
    var seconds = seconds + 5; 

    //kick off the countdown.
    xenos_timeout.counter = xenos_timeout.timeout_counter();
    xenos_timeout.counter.start(seconds);
  };   

  xenos_timeout.start_timer();

</script>
