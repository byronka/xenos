<%@ page import="com.renomad.xenos.Security" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Localization" %>
<%
  //check if they are already logged in.  If so, just skip to
  //dashboard.  it just checks the user cookie to see if we are good
  //to go.  It doesn't use username and password.
	request.setCharacterEncoding("UTF-8");
  int user_id = Security.check_if_allowed(request,true);
	if (user_id > 0) { 
    response.sendRedirect("dashboard.jsp"); 
	} else {
    // just in case, if they have a cookie for us at all, clear it.
    Cookie cookie = new Cookie("xenos_cookie", "");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
	}


  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());

  //get the values straight from the client
  String username = "";
  String password = "";
  boolean validation_error = false;

  //we'll put error messages here if validation errors occur
  String username_error_msg = "";  //empty username
  String password_error_msg = "";  //empty password
  String user_creation_error_msg = ""; //couldn't register
  String icode_error_msg = ""; // for invalid invite codes, though this really shouldn't 
                              //happen since we precheck

  // when coming in from the page that checks validity of invite
  // code, we'll first get that from a query string.
  String qs = request.getQueryString();
  String invite_code = Utils.parse_qs(qs).get("icode"); // get it from query string
  username = Utils.parse_qs(qs).get("user");
  if (!Utils.is_null_or_empty(username)) {
    username = java.net.URLDecoder.decode(username, "UTF-8"); // get it from query string
  }

  if (request.getMethod().equals("POST")) {

    // we will get invite code this way only when they 
    //are posting their username and password as well.
    invite_code = request.getParameter("icode"); // get it from POST

    username = request.getParameter("username");
    if (username.length() == 0) {
      username_error_msg = loc.get(48,"Please enter a username");
      validation_error |= true;
    }

    password = request.getParameter("password");
    if (password.length() == 0) {
      password_error_msg = loc.get(47,"Please enter a password");
      validation_error |= true;
    }

    if (!validation_error) {
      String ip_address = com.renomad.xenos.Utils.get_remote_address(request);
      User_utils.Put_user_result result = User_utils.put_user( username, password, ip_address, invite_code);
      switch (result) {
        case OK:
          response.sendRedirect("thanks.jsp");  // if everything is cool, only this runs.
          return;
        case EXISTING_USERNAME:
          user_creation_error_msg = loc.get(57,"That user already exists");
          break;
        case INVALID_INVITE_CODE:
          icode_error_msg = loc.get(201,"Invalid invite code");
          break;
        case GENERAL_ERR:
         // fall through.
        case INVALID_ENTRY:
         // fall through.
        default:
          response.sendRedirect("general_error.jsp"); // developer error if this happens, usually
          return;
      }
    }
  }
%>
<!DOCTYPE html>
<html>
  <head>
  <title><%=loc.get(58,"Account Creation")%></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="static/css/register.css" title="desktop">
  <link rel="stylesheet" href="static/css/default_background.css" >
  </head>
<body>
  <div class="trademark cl-effect-1"><a href="index.jsp">Favrcafe</a></div>
  <div class="register">
    <form id="enter_name_form" action="register_password.jsp" method="post">
      <div id="inputfields">
        <input type="hidden" name="icode" value="<%=invite_code%>" >
        <input type="hidden" name="username" value="<%=username%>" >

        <div class="error"><%=user_creation_error_msg%></div>
        <div class="error"><%=icode_error_msg%></div>

        <div class="username">
          <label for="usernameinput" class="label"><%=loc.get(51 ,"username")%>:</label> 
          <span id="usernamespan"><%=username%></span>
          <span class="error"><%=username_error_msg %></span>
        </div>



        <div id="password-container" class="password">
          <label for="passwordinput" class="label"><%=loc.get(63,"Password")%>:</label> 
          <input id="passwordinput"  name="password" type="password" />
          <span class="error"><%=password_error_msg %></span>
        </div>

      <script id="complexity_requirements_script" type="text/html">
        <div class="complexity-requirements">

          <div id="length">
            <span id="length-requirement">Password Length: 8 characters:</span>
            <img id="validlength" style="display: none" src="static/img/valid.png" width="25px" height="25px" title="valid" />
            <img id="invalidlength" style="display: auto" src="static/img/warning.png" width="25px" height="25px" title="invalid" />
          </div>

          <div id="confirmed">
            <span id="double_check">Confirmed:</span>
            <img id="validconfirmed" style="display: none" src="static/img/valid.png" width="25px" height="25px" title="valid" />
            <img id="invalidconfirmed" style="display: auto" src="static/img/warning.png" width="25px" height="25px" title="invalid" />
          </div>

        </div>
      </script>
      <script>
        var password_container = document.getElementById('password-container');
        var complexity_req_script = 
          document.getElementById('complexity_requirements_script')
        password_container.insertAdjacentHTML(
            'afterend', complexity_req_script.innerHTML);
      </script>

      </div>

      <div id="button-wrapper">
        <button id="submitbutton" type="submit">
          <%=loc.get(64,"Create my new user!")%>
        </button>
      </div>
      <script>
        var submit_button = document.getElementById('submitbutton');
        submit_button.disabled = true;
      </script>

    </form>

  </div>

  <script>

    // this listener checks that both passwords are the 
    // same - from second input point of view
    var both_passwords_the_same = function() { 
      var password = document.getElementById('passwordinput');
      var confirm_password = document.getElementById('password-verify');
      if (password && confirm_password) { // if both fields exist
        return password.value == confirm_password.value; // return whether they are the same
      }
    };

    var password_meets_complexity = function() {
      var password = document.getElementById('passwordinput');
      return password.value.length >= 8;
    }

    var enable_submit_button = function() {
      var submitbutton = document.getElementById('submitbutton');
      submitbutton.disabled = false;
    };

    var disable_submit_button = function() {
      var submitbutton = document.getElementById('submitbutton');
      submitbutton.disabled = true;
    };

    var check_password = function() {
      var validlength = document.getElementById('validlength');
      var invalidlength = document.getElementById('invalidlength');
      var validconfirmed = document.getElementById('validconfirmed');
      var invalidconfirmed = document.getElementById('invalidconfirmed');

      if (!password_meets_complexity()) {
        validlength.style.display = 'none';
        invalidlength.style.display = 'inline';
      } else {
        validlength.style.display = 'inline';
        invalidlength.style.display = 'none';
      }

      if (!both_passwords_the_same()) {
        validconfirmed.style.display = 'none';
        invalidconfirmed.style.display = 'inline';
      } else {
        validconfirmed.style.display = 'inline';
        invalidconfirmed.style.display = 'none';
      }

      if (both_passwords_the_same() && password_meets_complexity()) {
        enable_submit_button();
      } else {
        disable_submit_button();
      }

    };

    var password_text_field = document.getElementById('passwordinput');

    // this adds an event listener to the primary password input field, such that
    // when a user enters text there, it adds a new password field below it.
    // The new password field has an event listener added so that when the two
    // password fields have the same value, it allows "create new user" button
    // to be clicked.
    password_text_field.addEventListener( 'input',
      function(){
        var second_field_exists = document.getElementById('password-verify-container');
        var inputfields = document.getElementById('inputfields');
        if (this.value.length > 0 && !second_field_exists) { // if we need to add the second password field
          var validate_password_entry = 
            '<div id="password-verify-container" class="password">' +
            '<label for="password-verify" class="label"><%=loc.get(89,"Confirm password")%>:</label>' + 
            '<input id="password-verify" type="password" />' +
            '</div>'
          inputfields.insertAdjacentHTML('beforeend',validate_password_entry);
          var confirmation_input = document.getElementById('password-verify');
          confirmation_input.addEventListener('input', check_password);
        } else if (this.value.length == 0 && second_field_exists)  { // if we need to delete the second password field
          inputfields.removeChild(second_field_exists); 
        } else { // both input fields exist and we are comparing between them - first input point of view
          check_password();
        }
      }
    );

  </script>

</body>
</html>

