<%@ page import="com.renomad.qarma.Localization" %>
<%
	//set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<html>
<head>
	<title><%=loc.get(65,"Logged out")%></title>
	<link rel="stylesheet" href="logged_out.css">
</head>
<body>
	<div class="trademark">Qarma</div>
	<nav class="cl-effect-1">
		<p><%=loc.get(66,"You have successfully logged out")%></p>
		<p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
	</nav>
</body>
</html>
