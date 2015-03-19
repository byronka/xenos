<%@include file="includes/mobile_check.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Security" %>
<%@ page import="com.renomad.xenos.Localization" %>
<%
  //check if they are already logged in.  If so, just skip to dashboard.
	//it just checks the user cookie to see if we are good to go.  
	//It doesn't use username and password.
	request.setCharacterEncoding("UTF-8");
  int user_id = Security.check_if_allowed(request, true);
  if (user_id > 0) {
    response.sendRedirect("dashboard.jsp");return; 
  } else {
    Cookie cookie = new Cookie("xenos_cookie", "");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
  }


  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());

  //get the values straight from the client
  String user = "";
  String pass = "";

  //we'll put error messages here if validation errors occur
  String user_error_msg = "";  //empty username
  String pass_error_msg = "";  //empty password
  String login_error_msg = ""; //failed login

  //this code handles validation and applying username and password.
  if (request.getMethod().equals("POST")) {

    user = request.getParameter("username");
    pass = request.getParameter("password");

    //validate the password field
    if (pass.length() == 0) {
        pass_error_msg = loc.get(47,"Please enter a password");
    }

    //validate the username field
    if (user.length() == 0) {
        user_error_msg = loc.get(48,"Please enter a username");
    }

    int uid = 0;
    String ip_address = request.getRemoteAddr();
    if ((uid = Security.check_login(user, pass, ip_address)) > 0) {
      String cookie = Security.register_user(uid, ip_address);
      response.addCookie(new Cookie("xenos_cookie", cookie));
      response.sendRedirect("dashboard.jsp");
    } else {
      login_error_msg = 
        loc.get(49,"Invalid username / password combination");
    }
  }

%>
<!DOCTYPE html>
<html>
	<head>
    <script type="text/javascript" src="includes/utils.js"></script>
		<title><%=loc.get(50,"Login page")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="login.css" title="desktop">
		<% } %>
	</head>
  <body>
    <div style="width: 100%; height: 100%; position: fixed; background-color: black" id="covering_screen"></div>  
    <script>
      window.onload = xenos_utils.fade('covering_screen');
    </script>
    <div class="trademark cl-effect-1"><a href="index.jsp">Xenos</a></div>
    <div class="signin">
      <form method="POST" action="login.jsp">
      <div><%=login_error_msg%></div>
      <div class="user-input">
        <div class="label"><%=loc.get(51,"Username")%>: </div>
        <input type="text" autofocus="autofocus" name="username" value="<%=user%>"/>
        <span><%=user_error_msg%></span>
      </div>
      <div class="password-input">
        <div class="label"><%=loc.get(52,"Password")%>: </div>
        <input type="password" name="password" value="<%=pass%>"/>
        <span><%=pass_error_msg%></span>
      </div>
      <button type="submit">
        <%=loc.get(42,"Login")%>
      </button>
      </form>
    </div>
  </body>
</html>
