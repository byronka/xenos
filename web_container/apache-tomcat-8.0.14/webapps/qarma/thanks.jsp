<%@ page import="com.renomad.qarma.Localization" %>
<%
	//set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<html>
	<head><title><%=loc.get(69,"Thanks for registering!")%></title></head>
<body>

	<h3><%=loc.get(70,"You are awesome! thanks so much for entering your name!")%></h3>
	<p><a href="login.jsp"><%=loc.get(42,"login")%></a></p>
</body>
</html>
