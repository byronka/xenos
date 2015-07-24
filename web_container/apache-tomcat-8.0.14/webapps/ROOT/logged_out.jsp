<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Localization" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<!DOCTYPE html>
<html>
<head>
  <title><%=loc.get(65,"Logged out")%></title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="static/css/logged_out.css" >
  <link rel="stylesheet" href="static/css/default_background.css" >
</head>
<body>
  <div class="trademark">Favrcafe</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(66,"You have successfully logged out")%></p>
    <p><a href="dashboard.jsp"><%=loc.get(35,"Dashboard")%></a></p>
  </nav>
</body>
</html>
