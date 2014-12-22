<%@ page import="com.renomad.qarma.Localization" %>
<%@ page import="com.renomad.qarma.User_utils" %>
<%@ page import="com.renomad.qarma.User" %>
<% 
  int user_id = com.renomad.qarma.Security.check_if_allowed(request);
  if (user_id <= 0) { 
  	response.sendRedirect("login.jsp"); 
  	return;
  }
  Localization loc  = new Localization(user_id);
  User user = User_utils.get_user_displayname(user_id);
%>
<a href="dashboard.jsp">Qarma</a>
<form method="GET" action="dashboard.jsp" >
	<span><input type=text" name="search" maxlength="20" />
		<button><%=loc.get(1, "search")%></button></span>
</form>
<a href="create_request.jsp" ><%=loc.get(2, "Create Request")%></a>
<a href="logout.jsp" ><%=loc.get(3, "Logout")%></a>
<span><%=user.first_nameSafe()%></span>
<span> <%=user.last_nameSafe()%></span>
<span> (<%=user.emailSafe()%>) </span>
<span><%=user.points%> <%=loc.get(11, "points")%></span>
