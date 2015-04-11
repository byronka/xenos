<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <script type="text/javascript" src="static/js/utils.js"></script>
		<title><%=loc.get(99, "Requestoffer has been closed")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />

	</head>

<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%
  String qs = request.getQueryString();
  int requestoffer_id = 
    Integer.parseInt(Utils.parse_qs(qs).get("requestoffer"));
%>

<body>
  <img id='my_background' src="static/img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>

  <div class="container">
    <h2><%=loc.get(32, "Requestoffer")%> <%=requestoffer_id%> <%=loc.get(77, "closed")%></h2>
    <p>
      <%=loc.get(99, "Requestoffer has been closed")%>
    </p>
    <p><a class="button" href="dashboard.jsp"><%=loc.get(35, "Dashboard")%></a></p>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>

