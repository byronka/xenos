<%@include file="includes/mobile_check.jsp" %>
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
  String invite_code = "";
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
  invite_code = Utils.parse_qs(qs).get("icode"); // get it from query string

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
      String ip_address = request.getRemoteAddr();
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
  <script type="text/javascript" src="includes/utils.js"></script>
  <title><%=loc.get(58,"Account Creation")%></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="register.css" title="desktop">
		<% } %>
  </head>
<body>
  <div id="covering_screen"></div>
  <script>
    window.onload = xenos_utils.fade('covering_screen');
  </script>
  <div class="trademark cl-effect-1"><a href="index.jsp">Xenos</a></div>
  <div class="register">
    <form id="enter_name_form" action="register.jsp" method="post">
      <input type="hidden" name="icode" value="<%=invite_code%>" >

      <div class="error"><%=user_creation_error_msg%></div>
      <div class="error"><%=icode_error_msg%></div>

      <div class="username">
        <div class="label"><%=loc.get(51 ,"username")%>:</div> 
        <input value="<%=username%>" name="username" type="text" />
        <span class="error"><%=username_error_msg %></span>
      </div>

      <div class="password">
        <div class="label"><%=loc.get(63,"Password")%>:</div> 
        <input value="<%=password%>" name="password" type="password" />
        <span class="error"><%=password_error_msg %></span>
      </div>

			<div id="button-wrapper">
				<button type="submit">
					<%=loc.get(64,"Create my new user!")%>
				</button>
			</div>

    </form>

  </div>
</body>
</html>
