var xenos_user_notify = {};


//xenos_user_notify.user_message_handler = function() {


  //Module 1: simply shows and kills a dialog.
  //It takes some text that it will display to the user.
  var message_displayer = function(text_to_show) {

    //This sets up the actual element, and puts it on the page.
    var display_dialog = function() {
      var notification_dialog = 
        "<div id='notification_dialog' " +                    
        " style='font-size: 20px;width: 200px; height: 120px;" +
        "   top: 5px;right:10px; background-color: gold;" +
        "   z-index: 2; position: fixed;'>" +
        text_to_show +
        "</div>";

      document.body.insertAdjacentHTML('afterbegin', notification_dialog);
    }    

    //This fades out the dialog until invisible, then removes it from
    // the DOM
    var message_hider = function() {
      var dialog = document.getElementById('notification_dialog');
      dialog.style.opacity = 1; 
      var fade = function() {
        if ((dialog.style.opacity-=.1) < 0) { 
          var dialog_kill = document.getElementById('notification_dialog');
          document.body.removeChild(dialog_kill);
        } else {
          setTimeout(fade,40);
        }
      };
      fade(); //kick it off.
    }

    //This part is the interface
    return {
      display: display_dialog,
      hide: message_hider
    };

  }


  //Modele 1a: a message queue.  Takes in new messages and 
  //displays them in an even, timely manner.
  var message_queue = function() {

    var the_queue = [];

    var add_new_msg = function(msg) {
      the_queue.push(msg);
    };

    var process_queue = function() {
      while (the_queue.length > 0) {
        var mytext = the_queue.pop();
        var displayer = message_displayer(mytext);
        displayer.display();
        setTimeout(function(){displayer.hide()}, 3000);
      }
      setTimeout(process_queue,4000);
    };

    process_queue(); //start up the processing

    return {
      add_msg: add_new_msg
    };

  };


  //Module 2: calls periodically to the server to check
  // on new messages.  
  var message_checker = function() {

    var request = new XMLHttpRequest(); 
    var mq = message_queue();

    var response_handler = function() {
        if (request.readyState != 4 || request.status != 200) {
          return;  //if not the state we want, ignore.
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

  var mc = message_checker();

  var run_me = function() {
    mc.call_server();
    setTimeout(run_me, 30 * 1000);
  };

  run_me();

//}

