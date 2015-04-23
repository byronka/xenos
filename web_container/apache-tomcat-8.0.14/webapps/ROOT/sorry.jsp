<%@ page import="com.renomad.xenos.Localization" %>
<%
  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());

  //clear their Xenos cookie
  Cookie cookie = new Cookie("xenos_cookie", "");
  cookie.setMaxAge(0);
  response.addCookie(cookie);
%>
<!DOCTYPE html>
<html>                                 
	<head>
    <script type="text/javascript" src="static/js/utils.js"></script>
		<title><%=loc.get(67,"Security problem")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="static/css/sorry.css" title="desktop">
	</head>
<body>
  <img id='my_background' src="static/img/bouncer.jpg" onload="xenos_utils.fade_in_background()"/>
  <div class="trademark">Xenos</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(68,"Your browser did not send us the proper credentials.")%></p>
    <p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
  </nav>
</body>
</html>
