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
  boolean validation_error = false;
  boolean has_username_error = false;

  //we'll put error messages here if validation errors occur
  String username_error_msg = "";  //empty username
  String user_creation_error_msg = ""; //couldn't register
  String icode_error_msg = ""; // for invalid invite codes, though this really shouldn't 
                              //happen since we precheck

  // when coming in from the page that checks validity of invite
  // code, we'll first get that from a query string.
  String qs = request.getQueryString();
  String invite_code = Utils.parse_qs(qs).get("icode"); // get it from query string

  if (request.getMethod().equals("POST")) {

    // we will get invite code this way only when they 
    //are posting their username and password as well.
    invite_code = request.getParameter("icode"); // get it from POST

    username = request.getParameter("username");
    if (username.length() == 0) {
      username_error_msg = loc.get(48,"Please enter a username");
      validation_error |= true;
    }

    if (!validation_error) {
      String ip_address = com.renomad.xenos.Utils.get_remote_address(request);
      User_utils.Put_user_result result = 
        User_utils.is_valid_username(username, invite_code);
      switch (result) {
        case OK:
          response.sendRedirect(
            "register_password.jsp?user=" + username + "&icode=" + invite_code);  // if everything is cool, only this runs.
          return;
        case EXISTING_USERNAME:
          user_creation_error_msg = loc.get(57,"That user already exists");
          break;
        case INVALID_INVITE_CODE:
          icode_error_msg = loc.get(201,"Invalid invite code");
          break;
        case INVALID_ENTRY:
          has_username_error = true;
          break;
        case GENERAL_ERR:
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
  </head>
<body>
  <div class="trademark cl-effect-1"><a href="index.jsp">Zenia</a></div>
  <div class="register">
    <form id="enter_name_form" action="register.jsp" method="post">
      <div id="inputfields">
        <input type="hidden" name="icode" value="<%=invite_code%>" >

        <div class="error"><%=user_creation_error_msg%></div>
        <div class="error"><%=icode_error_msg%></div>

        <div class="username">
          <label for="usernameinput" class="label"><%=loc.get(51 ,"username")%>:</label> 
          <input id="usernameinput" value="<%=username%>" name="username" type="text" />
          <span class="error"><%=username_error_msg %></span>
          <% if (has_username_error) {%>
            <span class="error">Username cannot contain spaces</span>
          <% } %>
        </div>

        <div id="button-wrapper">
          <button id="submitbutton" type="submit">
            Choose my user name!
          </button>
        </div>
    </form>
  </div>
</body>
</html>

