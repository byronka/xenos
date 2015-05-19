<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<!DOCTYPE html>
<html>
	<head>
    <title>Confirm location</title>	
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
  <body>
  <%
    // what's the usecase - creating a requestoffer or 
    // setting their current location?
    Integer usecase = Utils.parse_int(request.getParameter("usecase"));

    // if they come in from a GET request, send them to the beginning
    if (request.getMethod().equals("GET")) {
      response.sendRedirect("select_country.jsp?usecase=" + usecase);
      return;
    }

    // get the country id and postal code id.  If they are 
    // garbage data, send them to the beginning.
    Integer country_id = Utils.parse_int(request.getParameter("c"));
    Integer post_code_id = request.getParameter("p");
    if (country_id == null || country_id < 0 ||
        post_code_id == null || post_code_id < 0) {
      response.sendRedirect("select_country.jsp?usecase=" + usecase);
      return;
    }

    if (country_id != null && postal_code_id != null) { 
     String loc_det = Requestoffer_utils.
       get_location_detail(country_id, postal_code_id);
    }

    response.sendRedirect(
      String.format(
      "create_requestoffer.jsp?c=%d&p=%d",country_id, post_code_id));
    %>
  </body>
</html>
