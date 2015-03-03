<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(183, "Favor created")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>


<%
  String qs = request.getQueryString();
  Integer requestoffer_id = Utils.parse_int(Utils.parse_qs(qs).get("requestoffer"));
%>
<body>
<h3><%=loc.get(183, "Favor created")%></h3>
<p>
  <%=loc.get(184,"You have created a favor.  Right now, it is in draft mode, unviewable by other users. You may")%>
  <a class="button" href="publish_requestoffer.jsp?requestoffer=<%=requestoffer_id%>">
    <%=loc.get(6,"Publish")%>
  </a>
  <%=loc.get(185,"it now if you wish.  Until you publish, it will remain hidden.  You can also publish this favor from your profile page.")%>

</p>
<p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
</body>
</html>

