<%@include file="includes/securepage.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title><%=loc.get(127, "Offer canceled")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

    <body>
      <%@include file="includes/header.jsp" %>

      <div class="container">
        <h3><%=loc.get(127, "Offer canceled")%></h3>
        <p><%=loc.get(128,"Your transaction has been canceled.")%></p>
        <p><%=loc.get(147,"You should rank that user now.")%><a class="button" href="user.jsp?user_id=<%=logged_in_user_id%>#ranking"><%=loc.get(133,"to grade user")%></a></p>
        <p><a class="button" href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
      </div>

  <%@include file="includes/footer.jsp" %>
</body>
</html>

