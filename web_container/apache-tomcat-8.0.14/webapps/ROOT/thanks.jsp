<%@ page import="com.renomad.xenos.Localization" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());
%>
<!DOCTYPE html>
<html>
  <head>
    <script type="text/javascript" src="includes/utils.js"></script>
		<title><%=loc.get(69,"Thanks for registering!")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="thanks.css" title="desktop">
	</head>
<body>
      background: url('img/thanks.jpeg') no-repeat center center fixed;
  <img id='my_background' style="top:0;left:0;width:100%;height:100%;opacity:0;position:fixed;" src="img/thanks.jpeg" onload="xenos_utils.fade_in_background()"/>
  <div class="trademark">Xenos</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(70,"You are awesome! thanks so much for entering your name!")%></p>
    <p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
  </nav>
</body>
</html>
