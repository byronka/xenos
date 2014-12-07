<%@ page import="com.renomad.qarma.Business_logic" %>
<%@include file="includes/check_auth.jsp" %>

<html>
<head><title>The request page</title></head>
<body>
<%@include file="includes/header.jsp" %>
<h2>Here is a request in more detail!</h2>
<%
  Business_logic.Request r = Business_logic.parse_querystring_and_get_request(request.getQueryString());
%>
<form>
<p>Description: <%=r.description%>
<p>Status: <%=r.get_status()%>
<p>Date: <%=r.datetime%>
<p>Points: <%=r.points%>
<p>Title: <%=r.title%>
<p>Requesting user: <%=r.requesting_user_id%>
<p>Categories: 
	<%for(String category : r.categories) {%>
		<%=category%>
	<%}%>
</form>
</body>
</html>
