<%@include file="includes/securepage.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <title><%=loc.get(2, "Request Favor")%></title>	
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	

	
	<body>
    <%@include file="includes/header.jsp" %>

    <div class="container">
      <h3>Does this Favor need a location?</h3>
      <a class="button" href="select_country.jsp?usecase=1">Yes</a>
      <a class="button" href="create_requestoffer.jsp">No</a>
    </div>
    <%@include file="includes/footer.jsp" %>
	</body>
</html>
