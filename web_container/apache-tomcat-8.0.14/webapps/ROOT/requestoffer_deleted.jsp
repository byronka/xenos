<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(31, "Requestoffer has been deleted")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%
  String qs = request.getQueryString();
  int requestoffer_id = 
    Integer.parseInt(Utils.parse_qs(qs).get("requestoffer"));
%>

<body>
<h2><%=loc.get(32, "Requestoffer")%> <%=requestoffer_id%> <%=loc.get(33, "deleted")%></h2>
<p>
  <%=loc.get(34, "Requestoffer has been deleted")%>
</p>
<p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
</body>
</html>
