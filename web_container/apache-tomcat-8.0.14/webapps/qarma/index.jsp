<%@ page import="com.renomad.qarma.Localization" %>
<%
	//set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<html>
<head>
	<title><%=loc.get(44,"Welcome to Qarma!")%></title>
</head>
<body>
  <p>
	<a href="login.jsp"><%=loc.get(42,"Login")%></a>
  </p>
  <p>
	<a href="register.jsp"><%=loc.get(43,"Register")%></a>
  </p>
</body>
</html>
