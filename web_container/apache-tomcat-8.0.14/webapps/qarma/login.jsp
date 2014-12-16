<%@ page import="com.renomad.qarma.Security" %>
<%
	//check if they are already logged in.  If so, just skip to dashboard.
	//it just checks the user cookie to see if we are good to go.  It doesn't use
	//username and password.
  int user_id = Security.check_if_allowed(request);
	if (user_id > 0) { response.sendRedirect("dashboard.jsp"); }

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
				pass_error_msg = "Please enter a password";
		}

		//validate the username field
		if (user.length() == 0) {
				user_error_msg = "Please enter a username";
		}

		int uid = 0;
		if ((uid = Security.check_login(user, pass)) > 0) {
			String ip_address = request.getRemoteAddr();
			Security.register_user(uid, ip_address);
			response.addCookie(
				new Cookie("qarma_cookie", Integer.toString(uid)));
			response.sendRedirect("dashboard.jsp");
		} else {
			login_error_msg = "Invalid username / password combination";
		}
	}

%>
<html>
	<head><title>Login page</title></head>
	<body>
		<form method="POST" action="login.jsp">
		<div><%=login_error_msg%></div>
		<p>
		Username: 
			<input type="text" autofocus="autofocus" name="username" value="<%=user%>"/>
			<span><%=user_error_msg%></span>
		</p>
		<p>
		Password: 
		<input type="password" name="password" value="<%=pass%>"/>
		<span><%=pass_error_msg%></span>
		</p>
		<button type="submit">Login</button>
	</form>
	</body>
</html>
