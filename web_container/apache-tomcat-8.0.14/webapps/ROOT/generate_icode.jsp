<%@include file="includes/init.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Security" %>
<%
   String icode = Security.generate_invite_code(user_id);
%>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(206,"Generate invitation code")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
    <%@include file="includes/header.jsp" %>
    <p><%=loc.get(207, "Here is an invitation code.  It is valid for 30 minutes from this time")%>
    <p><%=icode%></p>
  </body>
</html>
