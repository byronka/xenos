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
  <title>Favrcafe</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="static/css/index.css" >
  <link rel="stylesheet" href="static/css/default_background.css" >
</head>
<body>
	<div class="trademark cl-effect-1"><a href="index.jsp">Favrcafe</a></div>
  <div class="actions">
    <section>
    <nav class="cl-effect-1">
      <a href="login.jsp"><%=loc.get(42,"Login")%></a>

      <!-- this next line is turned off for beta.  Turn it back
           on for the final release.
      <a href="check_invite_code.jsp"><%=loc.get(43,"Register")%></a>
     -->

      <a href="register.jsp"><%=loc.get(43,"Register")%></a>
    </nav>
    </section>
  </div>
</body>
</html>
