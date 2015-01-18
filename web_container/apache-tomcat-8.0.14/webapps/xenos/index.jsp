<%@ page import="com.renomad.xenos.Localization" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<html>
<head>
  <title><%=loc.get(44,"Welcome to Xenos!")%></title>
  <link rel="stylesheet" href="index.css" >
</head>
<body>
  <div class="trademark">Xenos</div>
  <div class="actions">
    <section>
    <nav class="cl-effect-1">
      <a href="login.jsp"><%=loc.get(42,"Login")%></a>
      <a href="register.jsp"><%=loc.get(43,"Register")%></a>
    </nav>
    </section>
  </div>
</body>
</html>
