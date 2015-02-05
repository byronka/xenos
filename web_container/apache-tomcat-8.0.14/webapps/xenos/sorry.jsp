<%@ page import="com.renomad.xenos.Localization" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<!DOCTYPE html>
<html>                                 
	<head>
		<title><%=loc.get(67,"Security problem")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="sorry.css">
	</head>
<body>
  <div class="trademark">Xenos</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(68,"Your browser did not send us the proper credentials.")%></p>
    <p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
  </nav>
</body>
</html>
