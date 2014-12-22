<%@include file="includes/header.jsp" %>
<html>
<head><title><%=loc.get(31, "Request has been deleted")%></title></head>

<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%
	String qs = request.getQueryString();
	int request_id = 
		Integer.parseInt(Request_utils.parse_qs(qs).get("request"));
%>

<body>
<h2><%=loc.get(32, "Request")%> <%=request_id%> <%=loc.get(33, "deleted")%></h2>
<p>
	<%=loc.get(34, "Request has been deleted")%>
</p>
<p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
</body>
</html>

