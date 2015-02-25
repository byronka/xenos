var xenos_user_notify = {};

xenos_user_notify.message_displayer = function() {

  var md = {}; //an object to remind us where we are.

  md.display_dialog = function() {
    var notification_dialog = 
      "<div id='notification_dialog' " +                    
      " style='font-size: 20px;width: 200px; height: 120px;" +                    
      "   top: 5px;right:10px; background-color: gold;" + 
      "   z-index: 2; position: fixed;'>" + 
      " Hi mom! " +
      "</div>";

    document.body.insertAdjacentHTML('afterbegin', notification_dialog);
  }

  return {
    display: md.display_dialog,
    hide: function() {
      var dialog = document.getElementById('notification_dialog');
      document.body.removeChild(dialog)
    }
  };

}

