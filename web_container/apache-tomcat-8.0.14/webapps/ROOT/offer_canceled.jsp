<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
		<title><%=loc.get(127, "Offer canceled")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

    <body>
      <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
      <%@include file="includes/header.jsp" %>

      <div class="container">
        <h3><%=loc.get(127, "Offer canceled")%></h3>
        <p><%=loc.get(128,"Your transaction has been canceled.")%></p>
        <p><a class="button" href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
      </div>

  <%@include file="includes/footer.jsp" %>
</body>
</html>

