<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(127, "Offer canceled")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<body>
<h3><%=loc.get(127, "Offer canceled")%></h3>
<p><%=loc.get(128,"Your transaction has been canceled.")%></p>
<p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
</body>
</html>

