<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title><%=loc.get(183, "Favor created")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>


<%
  String qs = request.getQueryString();
  Integer requestoffer_id = Utils.parse_int(Utils.parse_qs(qs).get("requestoffer"));
%>
<body>
  <%@include file="includes/header.jsp" %>

  <div class="container">
    <h3><%=loc.get(183, "Favor created")%></h3>
    <p>
      <%=loc.get(184,"You have created a favor.  Right now, it is in draft mode, unviewable by other users. You may")%>

      <div class="table">
        <div class="row">
          <a class="button" href="publish_requestoffer.jsp?requestoffer=<%=requestoffer_id%>">
            <%=loc.get(6,"Publish")%>
          </a>
        </div>
      </div>
      <%=loc.get(185,"it now if you wish.  Until you publish, it will remain hidden.")%>

    </p>
    <div class="table">
      <div class="row">
        <a class="button" href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a>
        <a class="button" href="requestoffer.jsp?requestoffer=<%=requestoffer_id%>">View the new favor</a>
      </div>
    </div>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>

