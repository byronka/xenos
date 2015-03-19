<%@include file="includes/mobile_check.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Localization" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<!DOCTYPE html>
<html>
<head>
  <script type="text/javascript" src="includes/utils.js"></script>
  <title><%=loc.get(65,"Logged out")%></title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="logged_out.css" title="desktop">
		<% } %>
</head>
<body>
  <div id="covering_screen"></div>
  <script>
    window.onload = xenos_utils.fade('covering_screen');
  </script>
  <div class="trademark">Xenos</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(66,"You have successfully logged out")%></p>
    <p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
  </nav>
</body>
</html>
