<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(104, "Offer received")%></title>
    <link rel="stylesheet" href="small_dialog.css" >
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<body>
  <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h3><%=loc.get(104, "Offer received")%></h3>
    <p><%=loc.get(105,"We got your offer and will show it to that user shortly.  You can track this on your profile page.")%></p>
    <p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>

