<%@ page import="com.renomad.qarma.Localization" %>
<% 
  int user_id = com.renomad.qarma.Security.check_if_allowed(request);
  if (user_id <= 0) { response.sendRedirect("login.jsp"); }
  Localization loc  = new Localization(user_id);
%>
<a href="dashboard.jsp">Qarma</a>
<form method="GET" action="dashboard.jsp" >
	<span><input type=text" name="search" maxlength="20" />
		<button><%=loc.get(1, "search")%></button></span>
</form>
<a href="create_request.jsp" ><%=loc.get(2, "Create Request")%></a>
<a href="logout.jsp" ><%=loc.get(3, "Logout")%></a>
<span><%=com.renomad.qarma.User_utils.get_user_displayname(user_id)%></span>
