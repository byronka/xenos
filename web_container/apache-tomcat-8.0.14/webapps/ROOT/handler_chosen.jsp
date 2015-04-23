<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(141, "You have selected a handler for your Favor!")%></title>
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <div class="table">
      <h3><%=loc.get(141, "You have selected a handler for your Favor!")%></h3>
      <p><%=loc.get(142, "You have now selected someone to handle your favor.  That user will be informed, and we will also inform the other users (if any) that they have not been selected.")%></p>
      <p><a class="button" href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
    </div>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>

