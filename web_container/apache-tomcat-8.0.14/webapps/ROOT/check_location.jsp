<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(22,"Favor Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<body>
  <%@include file="includes/header.jsp" %>
<h3><%=loc.get(149, "Does this Favor need a location?")%></h3>

<p>
  <a href="create_requestoffer.jsp?create_loc=true" >
    <%=loc.get(150, "Yes")%>
  </a>
</p>
<p>
  <a href="create_requestoffer.jsp" >
    <%=loc.get(151, "No")%>
  </a>
</p>
</body>
</html>
