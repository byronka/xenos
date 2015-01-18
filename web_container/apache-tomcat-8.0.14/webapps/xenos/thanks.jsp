<%@ page import="com.renomad.xenos.Localization" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<html>
  <head><title><%=loc.get(69,"Thanks for registering!")%></title></head>
  <link rel="stylesheet" href="thanks.css">
<body>
  <div class="trademark">Xenos</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(70,"You are awesome! thanks so much for entering your name!")%></p>
    <p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
  </nav>
</body>
</html>
