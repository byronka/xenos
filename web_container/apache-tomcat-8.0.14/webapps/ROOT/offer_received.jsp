<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(104, "Offer received")%></title>
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h3><%=loc.get(104, "Offer received")%></h3>
    <p><%=loc.get(105,"We got your offer and will show it to that user shortly.")%></p>
    <p><a class="button" href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>

