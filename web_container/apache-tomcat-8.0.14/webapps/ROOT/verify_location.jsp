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

String postal_code = request.getParameter("postcode");
boolean is_nothing_found = false;

Requestoffer_utils.Postcode_and_detail[] pads = 
  Requestoffer_utils.get_locations_from_postcode(country_id, postal_code);

if (pads.length == 0) {
  // we got nothing from what they entered.  Indicate as much.
  is_nothing_found = true;

} else if (pads.length == 1) {
  // there is only one place - we need nothing more from the user,
  // move to the next page

} else {
  //there are 2 or more details to show the user.  Let them pick that
  // on this page.
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
            <% if (!is_nothing_found) { %>
              <select autofocus="true" name="postal_code_id" id="postal_code_id">
                <% for (int i = 0; i < pads.length; i++) {  %>
                  <option value="<%=pads[i].postcode_id%>"><%=pads[i].postcode%> <%=pads[i].detail%></option>
                <% } %>
              </select>
            <% } else { %>
              <span class="error">no locations found</span>
            <% } %>
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
