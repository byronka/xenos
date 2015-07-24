<%@include file="includes/securepage.jsp" %>
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
  <%
    // what's the usecase - creating a requestoffer or 
    // setting their current location?
    Integer usecase = Utils.parse_int(request.getParameter("u"));

    // get the country id and postal code id.  If they are 
    // garbage data, send them to the beginning.
    Integer country_id = Utils.parse_int(request.getParameter("c"));
    Integer post_code_id = Utils.parse_int(request.getParameter("p"));
    if (country_id == null || country_id < 0 ||
        post_code_id == null || post_code_id < 0) {
      response.sendRedirect("select_country.jsp?usecase=" + usecase);
      return;
    }

    String loc_det = "";
    if (country_id != null && post_code_id != null) { 
     loc_det = Requestoffer_utils.
       get_location_detail(country_id, post_code_id);
    }

    %>
  <body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
  <p>
  You selected: <%=loc_det%>
  </p>
  <div class="table">
    <div class="row">
    <% if (usecase == 1) { %>
      <a class="button" href="<%=String.format("create_requestoffer.jsp?c=%d&p=%d",country_id, post_code_id)%>">Click to continue</a>
    <% } else { 
      User_utils.edit_user_current_location(logged_in_user_id, country_id, post_code_id); 
    %>
      <a class="button" href="user.jsp?user_id=<%=logged_in_user_id%>">Click to continue</a>
    <% } %>
    <a class="button" href="select_country.jsp?usecase=<%=usecase%>">Redo</a>
    
    </div>
  </div>
  </div>
  <%@include file="includes/footer.jsp" %>
  </body>
</html>
