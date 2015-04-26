<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title><%=loc.get(195, "Favor retracted")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h3><%=loc.get(195, "Favor retracted")%></h3>
    <p><%=loc.get(196,"Your favor is now hidden.  Any offers have been rejected.")%></p>
    <p><a class="button" href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>

