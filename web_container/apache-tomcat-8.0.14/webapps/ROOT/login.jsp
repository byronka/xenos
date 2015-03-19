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
  boolean has_user_error = false;  //empty username
  boolean has_pass_error = false;  //empty password
  boolean has_login_error = false; //failed login

  //this code handles validation and applying username and password.
  if (request.getMethod().equals("POST")) {

    user = request.getParameter("username");
    pass = request.getParameter("password");

    //validate the password field
    if (pass.length() == 0) {
        has_pass_error = true;
    }

    //validate the username field
    if (user.length() == 0) {
        has_user_error = true;
    }

    int uid = 0;
    String ip_address = request.getRemoteAddr();
    if ((uid = Security.check_login(user, pass, ip_address)) > 0) {
      String cookie = Security.register_user(uid, ip_address);
      response.addCookie(new Cookie("xenos_cookie", cookie));
      response.sendRedirect("dashboard.jsp");
    } else {
      has_login_error = true;
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
			<link rel="stylesheet" href="login_mobile.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="login.css" title="desktop">
		<% } %>
	</head>
  <body>
		<%if (!probably_mobile) {%>
      <div style="top:0;left:0;width: 100%; height: 100%; position: fixed; background-color: black" id="covering_screen"></div>  
      <script>
        window.onload = xenos_utils.fade('covering_screen');
      </script>
    <% } %>
    <div class="trademark cl-effect-1"><a href="index.jsp">Xenos</a></div>
    <div class="signin">
      <form method="POST" action="login.jsp">
      <% if (has_login_error) { %>
        <div class="error">
          <%=loc.get(49,"Invalid username / password combination")%>
        </div>
      <% } %>
      <div class="user-input">
        <div class="label"><%=loc.get(51,"Username")%>: </div>
        <input type="text" autofocus="autofocus" name="username" value="<%=user%>"/>
        <% if (has_user_error) { %>
          <span class="error">
            <%=loc.get(48,"Please enter a username")%>
          </span>
        <% } %>
      </div>
      <div class="password-input">
        <div class="label"><%=loc.get(52,"Password")%>: </div>
        <input type="password" name="password" value="<%=pass%>"/>
        <% if (has_pass_error) { %>
          <span class="error">
            <%=loc.get(47,"Please enter a password")%>
          </span>
        <% } %>
      </div>
      <button type="submit">
        <%=loc.get(42,"Login")%>
      </button>
      </form>
    </div>
  </body>
</html>
