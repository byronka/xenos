<%@ page import="com.renomad.qarma.Localization" %>
<%
	//set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<html>                                 
	<head><title><%=loc.get(67,"Security problem")%></title></head>
	<link rel="stylesheet" href="sorry.css">
<body>
	<div class="trademark">Qarma</div>
	<nav class="cl-effect-1">
		<p><%=loc.get(68,"Your browser did not send us the proper credentials.")%></p>
		<p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
	</nav>
</body>
</html>
