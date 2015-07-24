<%@include file="includes/securepage.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%

// if they come in from a GET request, send them to the beginning
if (request.getMethod().equals("GET")) {
  response.sendRedirect("select_country.jsp");
  return;
}

// what's the usecase - creating a requestoffer or setting their current location?
Integer usecase = Utils.parse_int(request.getParameter("usecase"));

// get the country.  If it's garbage data, send them to the beginning.
Integer country_id = Utils.parse_int(request.getParameter("country"));
if (country_id == null || country_id < 0) {
  response.sendRedirect("select_country.jsp");
  return;
}

// if they came from this same page, they may have selected a postcode
// from the dropdown.
String postal_code = request.getParameter("postcode");
Integer postal_code_from_dropdown = 
  Utils.parse_int(request.getParameter("postal_code_id"));
boolean user_has_entered_postal_data = postal_code != null || postal_code_from_dropdown != null;

// if they gave us garbage data, this is the validation for that
boolean is_nothing_found = false;
  Requestoffer_utils.Postcode_and_detail[] pads = 
    new Requestoffer_utils.Postcode_and_detail[0];

if (user_has_entered_postal_data) {
  // search for all the possible locations based on what they typed in
  if (!Utils.is_null_or_empty(postal_code) ) {
    pads = Requestoffer_utils.get_locations_from_postcode(country_id, postal_code);
  }


  if (postal_code_from_dropdown == null && pads.length == 0) {
    // we got nothing from what they entered.  Indicate as much.
    is_nothing_found = true;
  } else if (postal_code_from_dropdown != null || pads.length == 1) {
              
    // either use the one valid entry, or if that's not 
    // available, the selected postal code from the dropdown
    Integer post_code_id = pads.length == 1 ? 
      pads[0].postcode_id 
      : postal_code_from_dropdown;

    // there is only one location - we need nothing more from the user,
    // move to the next page - confirmation
    response.sendRedirect(String.format("confirm_location.jsp?c=%d&p=%d&u=%d",country_id, post_code_id, usecase));

  } else {
    //there are 2 or more details to show the user.  Let them pick that
    // on this page.
  }
}

%>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title><%=loc.get(209,"Change current location")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>
  
  <div class="container">

    <h3><%=loc.get(156, "Postal code")%>:</h3>
      <% if (!user_has_entered_postal_data || is_nothing_found) { %>

        <form method="POST" action="enter_postcode.jsp">
          <input type="hidden" name="country" value="<%=country_id%>">
          <input type="hidden" name="usecase" value="<%=usecase%>">
          <div class="table">
            <div class="row">
              <label for="postcode"><%=loc.get(156,"Postal code")%></label>
              <input name="postcode" id="postcode" autofocus="true">
            </div>
          </div>
          <% if (is_nothing_found) { %>
            <span class="error">
              <%=loc.get(82,"No locations found in database for this country and postcode")%>
            </span>
          <% } %>

          <div class="table">
            <div class="row">
              <button class="button">
                <%=loc.get(75, "Done entering postal code")%>
              </button>
            </div>
          </div>

        </form>

      <% } else { %>

        <form method="POST" action="enter_postcode.jsp">
          <input type="hidden" name="country" value="<%=country_id%>">
          <input type="hidden" name="usecase" value="<%=usecase%>">
          <div class="table">
            <div class="row">
              <select autofocus="true" name="postal_code_id" id="postal_code_id">
                <% for (int i = 0; i < pads.length; i++) {  %>
                  <option value="<%=pads[i].postcode_id%>"><%=pads[i].postcode%> <%=pads[i].detail%></option>
                <% } %>
              </select>
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

      <% } %>


  </div>
  <%@include file="includes/footer.jsp" %>
  </body>
</html>
