<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(141, "You have selected a handler for your Favor!")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<body>
<h3><%=loc.get(141, "You have selected a handler for your Favor!")%></h3>
<p><%=loc.get(142, "You have now selected someone to handle your favor.  That user will be informed, and we will also inform the other users (if any) that they have not been selected.")%></p>
<p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
</body>
</html>

