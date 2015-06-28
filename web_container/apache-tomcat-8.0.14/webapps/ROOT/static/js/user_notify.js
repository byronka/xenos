var xenos_user_notify = {};


//Module 1: contains the text of the dialog element.
// returns an object with a property to call, display,
// which takes a string and displays it for 3 seconds
xenos_user_notify.message_displayer = function() {

  //This sets up the actual element, and puts it on the page.
  var display_dialog = function(text_to_show) {
    var notification_dialog = 
      "<div id='notification_dialog' >" + text_to_show + "</div>";

    document.body.insertAdjacentHTML('afterbegin', notification_dialog);
    var dialog = document.getElementById('notification_dialog');
    dialog.onclick = function() {
      document.body.removeChild(dialog);
    }
    setTimeout(message_hider, 3000);
  }    

  //This fades out the dialog until invisible, then removes it from
  // the DOM
  var message_hider = function() {
    var dialog = document.getElementById('notification_dialog');
    if (dialog != null) {
      dialog.style.opacity = 1; 
      var fade = function(iteration) {
        dialog.style.opacity-=.1; 
        if (iteration == 0) {
          document.body.removeChild(dialog);
        } else {
          setTimeout(fade,40, iteration - 1);
        }
      };
      fade(10); //kick it off.
    }
  }

  //This part is the interface
  return {
    display: display_dialog //accepts a string param for text to show
  };

}


//Module 2: a message queue.  Takes in new messages and 
//displays them in an even, timely manner.  The way it does
//this is it has a function that gets run every few seconds,
//and at that time it tries popping an element off the array
//to display.
xenos_user_notify.message_queue = function() {

  var the_queue = [];
  var displayer = xenos_user_notify.message_displayer();

  var add_new_msg = function(msg) {
    the_queue.push(msg);
  };

  //every five seconds, wake up.  If there is something
  //left on the array, display it.
  var process_queue = function() {
    if (the_queue.length > 0) {
      var mytext = the_queue.pop();
      displayer.display(mytext);
    }
    setTimeout(process_queue,5000);
  };

  process_queue(); //start up the processing

  return {
    add_msg: add_new_msg //takes a string param to add on the queue
  };

};


//Module 3: Has the responsibility to speak to the server.
// if it gets any messages from the server, it will send them
// to the message queue.
//returns an object with a method that can be run to call
// the server for more data.
xenos_user_notify.message_checker = function() {

  var request = new XMLHttpRequest(); 
  var mq = xenos_user_notify.message_queue();

  var response_handler = function() {
      if (request.readyState != 4 )  {
        return;  //if not the state we want, ignore.
      }
      if (request.status == 403) { //forbidden
        document.location = 'logout.jsp';
        return;
      }
      if (request.status != 200) {
        return;
      }
      //otherwise, success!
      var mydoc = request.responseXML;
      var text_messages = mydoc.getElementsByTagName('div');
      for (var index = 0; index < text_messages.length;index++) {
        var mytext = text_messages[index].innerHTML;
        mq.add_msg(mytext);
      }
  };


  var call_to_server = function() {
    request.open("GET", "temporary_messages.jsp", true); 
    request.responseType = "document";
    request.onreadystatechange = response_handler;
    request.send();
  };

  //This part is the interface
  return {
    call_server: call_to_server
  };

};

xenos_user_notify.mc = xenos_user_notify.message_checker();

xenos_user_notify.run_me = function() {
  xenos_user_notify.mc.call_server();
  //just run once per page load.
  //setTimeout(xenos_user_notify.run_me, 30 * 1000);
};

xenos_user_notify.run_me();


