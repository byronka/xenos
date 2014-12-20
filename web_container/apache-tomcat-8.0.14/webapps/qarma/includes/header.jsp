<% int user_id = com.renomad.qarma.Security.check_if_allowed(request);
  if (user_id <= 0) { response.sendRedirect("login.jsp"); }
%>
<a href="dashboard.jsp">Qarma</a>
<form method="GET" action="dashboard.jsp" >
	<span><input type=text" name="search" maxlength="20" />
<button>Search</button></span>
</form>
<a href="create_request.jsp" >Create Request</a>
<a href="logout.jsp" >Logout</a>
<span><%=com.renomad.qarma.User_utils.get_user_displayname(user_id)%></span>
