<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Localization" %>
<%@ page import="com.renomad.xenos.Security" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
  int user_id = Security.check_if_allowed(request, true);
  if (user_id > 0) {
    response.sendRedirect("dashboard.jsp");return; 
  } else {
    Cookie cookie = new Cookie("xenos_cookie", "");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title><%=loc.get(44,"Welcome to Zenia!")%></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="static/css/index.css" title="desktop">
</head>
<body>
	<div class="trademark cl-effect-1"><a href="index.jsp">Zenia</a></div>
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
