<%@ page import="com.renomad.xenos.Localization" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<!DOCTYPE html>
<html>
  <head>
		<title><%=loc.get(69,"Thanks for registering!")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="static/css/thanks.css" title="desktop">
    <link rel="stylesheet" href="static/css/default_background.css" >
	</head>
<body>
  <div class="trademark">SAYAYE</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(70,"You are awesome! Thanks so much for entering your name!")%></p>
    <p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
  </nav>
</body>
</html>
