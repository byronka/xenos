<%@ page import="com.renomad.qarma.Security" %>
<%
  int user_id = Security.check_if_allowed(request);
	if (user_id > 0) { response.sendRedirect("dashboard.jsp"); }
%>
<html>
<head><title>Account Creation</title></head>
<body>
<h2>
  Create a new account
</h2>
  <form id="enter_name_form" action="handle_register.jsp" method="post">
    <p>
      First Name:
      <input name="first_name" type="text" />
      Last Name:
      <input name="last_name" type="text" />
    </p>
    <p>
      Email:
      <input name="email" type="text" />
    </p>
    <p>
      Password:
      <input name="password" type="text" />
    </p>

    <button form="enter_name_form" >Done</button>
  </form>
</body>
</html>
