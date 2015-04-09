<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%

if (request.getMethod().equals("GET")) {
  response.sendRedirect("select_country.jsp");
  return;
}

Integer country_id = Utils.parse_int(request.getParameter("country"));
if (country_id == null || country_id < 0) {
  response.sendRedirect("select_country.jsp");
  return;
}

%>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
		<title><%=loc.get(209,"Change current location")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>
  
  <div class="container">

    <h3><%=loc.get(157, "Country")%>:</h3>
      <form method="POST" action="verify_location.jsp">
        <input type="hidden" name="country" value="<%=country_id%>">
        <div class="table">
          <div class="row">
            <label for="postcode"><%=loc.get(156,"Postal code")%></label>
            <input name="postcode" id="postcode" autofocus="true">
          </div>
        </div>

        <div class="table">
          <div class="row">
            <button class="button">
              <%=loc.get(75, "Done entering postal code")%>
            </button>
          </div>
        </div>

      </form>


  </div>
  <%@include file="includes/footer.jsp" %>
  </body>
</html>
