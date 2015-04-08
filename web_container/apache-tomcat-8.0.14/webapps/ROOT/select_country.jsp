<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%


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
    <form method="POST" action="select_country.jsp">
      <%
        com.renomad.xenos.Requestoffer_utils.Country[] countries = Requestoffer_utils.get_countries();
      %>
      <select>
        <% for (int i = 0; i < countries.length; i ++) { %>
          <option value="<%=countries[i].country_id%>">
            <%=countries[i].country_name%>
          </option>
        <% } %>
      </select>

    </form>
  </div>
  </div>
  <%@include file="includes/footer.jsp" %>
  </body>
</html>
