<%@include file="includes/mobile_check.jsp" %>
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
    <link rel="<%=is_desktop%> stylesheet" href="thanks.css" title="desktop">
    <link rel="<%=is_mobile%> stylesheet" href="includes/common_alt.css" title="mobile">
	</head>
<body>
  <div class="trademark">Xenos</div>
  <nav class="cl-effect-1">
    <p><%=loc.get(70,"You are awesome! thanks so much for entering your name!")%></p>
    <p><a href="login.jsp"><%=loc.get(42,"Login")%></a></p>
  </nav>
</body>
</html>
