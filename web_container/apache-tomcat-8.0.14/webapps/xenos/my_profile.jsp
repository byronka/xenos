<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(97,"My Profile")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>
	<button>Change password</button>
	<h3><%=loc.get(96, "My Messages")%></h3>
		<% for (String s : Requestoffer_utils.get_my_messages(user_id)) {%>
			<p><%=Utils.safe_render(s)%></p>
		<% } %>
	</body>
</html>
