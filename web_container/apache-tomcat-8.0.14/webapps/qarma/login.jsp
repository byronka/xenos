<%@ page import="com.renomad.qarma.Security" %>
<%
  int user_id = Security.check_if_allowed(request);
	if (user_id > 0) { response.sendRedirect("dashboard.jsp"); }
%>
<html>
	<head><title>Login page</title></head>
	<body>
		<form method="POST" action="handle_login.jsp">
		<p>Username: <input type="text" name="username" /></p>
		<p>Password: <input type="text" name="password" /></p>
		<button type="submit">Login</button>
	</form>
	</body>
</html>
