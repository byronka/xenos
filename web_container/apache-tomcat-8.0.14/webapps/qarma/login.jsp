<%@ page import="com.renomad.qarma.Security" %>
<%@ page import="com.renomad.qarma.Localization" %>
<%
	//check if they are already logged in.  If so, just skip to dashboard.
	//it just checks the user cookie to see if we are good to go.  It doesn't use
	//username and password.
  int user_id = Security.check_if_allowed(request);
	if (user_id > 0) { response.sendRedirect("dashboard.jsp"); }

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
		if ((uid = Security.check_login(user, pass)) > 0) {
			String ip_address = request.getRemoteAddr();
			Security.register_user(uid, ip_address);
			response.addCookie(
				new Cookie("qarma_cookie", Integer.toString(uid)));
			response.sendRedirect("dashboard.jsp");
		} else {
			login_error_msg = loc.get(49,"Invalid username / password combination");
		}
	}

%>
<html>
	<head><title><%=loc.get(50,"Login page")%></title></head>
	<body>
		<form method="POST" action="login.jsp">
		<div><%=login_error_msg%></div>
		<p>
		<%=loc.get(51,"Username")%>: 
			<input type="text" autofocus="autofocus" name="username" value="<%=user%>"/>
			<span><%=user_error_msg%></span>
		</p>
		<p>
		<%=loc.get(52,"Password")%>: 
		<input type="password" name="password" value="<%=pass%>"/>
		<span><%=pass_error_msg%></span>
		</p>
		<button type="submit"><%=loc.get(42,"Login")%></button>
	</form>
	</body>
</html>
