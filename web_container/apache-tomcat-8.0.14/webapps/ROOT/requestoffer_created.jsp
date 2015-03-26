<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
		<title><%=loc.get(183, "Favor created")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>


<%
  String qs = request.getQueryString();
  Integer requestoffer_id = Utils.parse_int(Utils.parse_qs(qs).get("requestoffer"));
%>
<body>
  <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>

  <div class="container">
    <h3><%=loc.get(183, "Favor created")%></h3>
    <p>
      <%=loc.get(184,"You have created a favor.  Right now, it is in draft mode, unviewable by other users. You may")%>
      <a class="button" href="publish_requestoffer.jsp?requestoffer=<%=requestoffer_id%>">
        <%=loc.get(6,"Publish")%>
      </a>
      <%=loc.get(185,"it now if you wish.  Until you publish, it will remain hidden.  You can also publish this favor from your profile page.")%>

    </p>
    <p><a href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>

