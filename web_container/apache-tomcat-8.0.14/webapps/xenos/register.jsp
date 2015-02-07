<%@include file="includes/mobile_check.jsp" %>
<%@ page import="com.renomad.xenos.Security" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.Localization" %>
<%
  //check if they are already logged in.  If so, just skip to
  //dashboard.  it just checks the user cookie to see if we are good
  //to go.  It doesn't use username and password.
  int user_id = Security.check_if_allowed(request);
  if (user_id > 0) { response.sendRedirect("dashboard.jsp"); }

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

  if (request.getMethod().equals("POST")) {

    username = request.getParameter("username");
    if (username.length() == 0) {
      username_error_msg = loc.get(55,"Please enter a username");
      validation_error |= true;
    }

    password = request.getParameter("password");
    if (password.length() == 0) {
      password_error_msg = loc.get(56,"Please enter a password");
      validation_error |= true;
    }

    if (!validation_error) {
    boolean succeed = User_utils.put_user( username, password);
      if (succeed) {
        response.sendRedirect("thanks.jsp");
      } else {
        user_creation_error_msg = loc.get(57,"That user already exists");
      }
    }
  }
%>
<!DOCTYPE html>
<html>
  <head>
  <title><%=loc.get(58,"Account Creation")%></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="<%=is_desktop%> stylesheet" href="register.css" title="desktop">
	<link rel="<%=is_mobile%> stylesheet" href="includes/common_alt.css" title="mobile">
  </head>
<body>
  <div class="trademark cl-effect-1"><a href="index.jsp">Xenos</a></div>
  <div class="register">
    <form id="enter_name_form" action="register.jsp" method="post">

      <div class="error"><%=user_creation_error_msg%></div>

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
