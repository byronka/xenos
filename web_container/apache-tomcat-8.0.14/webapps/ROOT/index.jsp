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
  <title><%=loc.get(44,"Welcome to Xenos!")%></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="index.css" title="desktop">
		<% } %>
</head>
<body>
	<div class="trademark cl-effect-1"><a href="index.jsp">Xenos</a></div>
  <div class="actions">
    <section>
    <nav class="cl-effect-1">
      <a href="login.jsp"><%=loc.get(42,"Login")%></a>
      <a href="check_invite_code.jsp"><%=loc.get(43,"Register")%></a>
    </nav>
    </section>
  </div>
</body>
</html>
