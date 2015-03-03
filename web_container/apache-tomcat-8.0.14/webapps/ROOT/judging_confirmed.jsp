<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(190, "Ranking confirmed")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />

	</head>

<body>
<h2><%=loc.get(190, "Ranking confirmed")%></h2>
<p>
  <%=loc.get(191,"Thanks!  By providing a ranking for this user, you make the system a safer place for everyone.")%>
</p>
<p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
</body>
</html>

