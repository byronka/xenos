<%@ page import="com.renomad.qarma.Localization" %>
<%
	//set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<html>
<head>
	<title><%=loc.get(65,"Logged out")%></title>
</head>
<body>
	<p><%=loc.get(66,"You have successfully logged out")%></p>
	<p><a href="index.jsp"><%=loc.get(42,"Login")%></a></p>
</body>
</html>
