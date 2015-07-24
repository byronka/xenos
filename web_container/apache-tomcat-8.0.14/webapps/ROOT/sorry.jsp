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
		<title><%=loc.get(67,"Security problem")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="static/css/sorry.css" >
    <link rel="stylesheet" href="static/css/default_background.css" >
	</head>
<body>
  <div class="trademark">Favrcafe</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(68,"Your browser did not send us the proper credentials.")%></p>
    <p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
    <p><a href="register.jsp"><%=loc.get(43,"Register")%></a></p>
    <p><a href="dashboard.jsp"><%=loc.get(35,"Dashboard")%></a></p>
  </nav>
</body>
</html>
