<%@ page import="com.renomad.qarma.Localization" %>
<%
	//set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<html>                                 
	<head><title><%=loc.get(67,"Security problem")%></title></head>
<body>
	<h2><%=loc.get(68,"Your browser did not send us the proper credentials.")%></h2>
	<p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
</body>
</html>
