<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(141, "You have selected a handler for your Favor!")%></title>
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<body>
  <img id='my_background' style="z-index:-1;top:0;left:0;width:100%;height:100%;opacity:0;position:fixed;" src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <div class="table">
      <h3><%=loc.get(141, "You have selected a handler for your Favor!")%></h3>
      <p><%=loc.get(142, "You have now selected someone to handle your favor.  That user will be informed, and we will also inform the other users (if any) that they have not been selected.")%></p>
      <p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
    </div>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>

