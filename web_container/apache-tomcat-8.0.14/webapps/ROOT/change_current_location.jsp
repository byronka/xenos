<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%


    //address values
    String strt_addr_1_val = "";
    String strt_addr_2_val = "";
    String city_val        = "";
    String state_val       = "";
    String postal_val      = "";
    String country_val     = "";
    String savedlocation_val = "";
    String save_loc_to_user_checked = "";

    // validation errors
    boolean has_posted_but_given_no_data = false;
    boolean has_not_given_postal_code = false;

  if (request.getMethod().equals("POST")) {
      boolean validation_error = false;

      strt_addr_1_val = 
        Utils.get_string_no_null(request.getParameter("strt_addr_1"));

      strt_addr_2_val = 
        Utils.get_string_no_null(request.getParameter("strt_addr_2"));
      
      city_val = 
        Utils.get_string_no_null(request.getParameter("city"));

      state_val =
        Utils.get_string_no_null(request.getParameter("state"));

      postal_val = 
        Utils.get_string_no_null(request.getParameter("postal"));

      country_val = 
        Utils.get_string_no_null(request.getParameter("country"));

      savedlocation_val =
        Utils.get_string_no_null(request.getParameter("savedlocation"));

      boolean user_entered_a_location = 
        Utils.parse_int(savedlocation_val) != null ||
        !Utils.is_null_or_empty(strt_addr_1_val) ||
        !Utils.is_null_or_empty(strt_addr_2_val) ||
        !Utils.is_null_or_empty(city_val) ||
        !Utils.is_null_or_empty(state_val) ||
        !Utils.is_null_or_empty(postal_val) ||
        !Utils.is_null_or_empty(country_val);

      //postal code is special - it is what we use to determine lat / long coords
      boolean postal_code_was_entered = 
        !Utils.is_null_or_empty(postal_val);

      // if a user is posting but isn't giving us anything, we 
      // wnat to know why.
      if (!user_entered_a_location) {
        validation_error |= true;
        has_posted_but_given_no_data = true;
      }

      // if a user is not selecting from the dropdown, and 
      // is not providing a postal code, we need
      // to inform them they aren't giving us what we need.
      if (Utils.parse_int(savedlocation_val) == null && 
        !postal_code_was_entered) {
        validation_error |= true;
        has_not_given_postal_code = true;
      }

      if (!validation_error) {

          int requestoffer_id = 0; //don't tie to any particular RO
          Integer location_id = 0;
          if ((location_id = Utils.parse_int(savedlocation_val)) != null) {
            Requestoffer_utils.assign_location_to_current(
              location_id, logged_in_user_id);
          } else {
            int new_loc_id = Requestoffer_utils.put_location(
              logged_in_user_id, requestoffer_id,
              strt_addr_1_val, strt_addr_2_val, 
              city_val, state_val, postal_val, country_val);
            Requestoffer_utils.assign_location_to_current(
              new_loc_id, logged_in_user_id);
          }
          response.sendRedirect("dashboard.jsp");
          return;
      }

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
    <form method="POST" action="change_current_location.jsp">
    <% if (has_posted_but_given_no_data) { %>
      <div class="error">
        <%=loc.get(210,"You have not provided any information on a current location.  There is a cancel button if you do not wish to add or change this")%>
      </div>
    <% } %>
    <% if (has_not_given_postal_code) { %>
      <div class="error">
        <%=loc.get(211,"At the very least, you must provide a postal code.  That's what we use to determine your distance to favors")%>
      </div>
    <% } %>
        <%
        User_location uloc = Requestoffer_utils
        .get_location_for_user(logged_in_user_id, logged_in_user.current_location); 
        %>
        <% if (uloc != null) { %>
          <p>Your current location is:</p>
          <p><em><%=uloc.str_addr_1%></em></p>
          <p><em><%=uloc.str_addr_2%></em></p>
          <p><em><%=uloc.city%></em></p>
          <p><em><%=uloc.state%></em></p>
          <p><em><%=uloc.postcode%></em></p>
          <p><em><%=uloc.country%></em></p>
        <% } %>



            <% 
            User_location[] locations = 
            Requestoffer_utils.get_my_saved_locations(logged_in_user_id);
            if (locations.length > 0) {
            %>

        <div class="table">
          <div class="row">
            <label for="savedlocation"><%=loc.get(158,"Select one of your saved locations")%>:</label>
            <select 
              id="savedlocation" 
              name="savedlocation">
              <option><%=loc.get(192,"No address selected")%></option>
              <%for (User_location loca : locations) {%>
                <%if(Integer.toString(loca.id).equals(savedlocation_val)){%>
                  <option selected value="<%=loca.id%>">
                <%} else { %>
                  <option value="<%=loca.id%>">
                <% } %>
                <%=loca.str_addr_1%>
                <%=loca.str_addr_2%>
                <%=loca.city%>
                <%=loca.state%>
                <%=loca.postcode%>
                <%=loca.country%>
                </option>
              <%}%>
            </select>                       
          </div>

            <h4 class="enternew"><%=loc.get(159,"Or enter a new address")%>:</h4>            

            <%}%>

          <div class="row">
            <label for="strt_addr_1"><%=loc.get(152,"Street Address 1")%>:</label>
            <input maxlength=100 type="text" id="strt_addr_1" name="strt_addr_1" value="<%=strt_addr_1_val%>">
          </div>
            
          <div class="row">
            <label for="strt_addr_2"><%=loc.get(153,"Street Address 2")%>:</label>
            <input maxlength=100 type="text" id="strt_addr_2" name="strt_addr_2" value="<%=strt_addr_2_val%>">
          </div>
            
          <div class="row">
            <label for="city"><%=loc.get(154,"City")%>:</label>
            <input maxlength=40 type="text" id="city" name="city" value="<%=city_val%>">
          </div>
            
          <div class="row">
            <label for="state"><%=loc.get(155,"State")%>:</label>
            <input maxlength=30 type="text" id="state" name="state" value="<%=state_val%>">
          </div>
            
          <div class="row">
            <label for="postal" >* <%=loc.get(156,"Postal code")%>:</label>
            <input maxlength=20 type="text" id="postal" name="postal" value="<%=postal_val%>">
          </div>
            
          <div class="row">
            <label for="country"><%=loc.get(157,"Country")%>:</label>
            <input maxlength=40 type="text" id="country" name="country" value="<%=country_val%>">
          </div>

          <div class="table">
            <div class="row">
              <button class="button" type="submit">Change</button>
              <a class="button" href="dashboard.jsp">Cancel</a>
            </div>
          </div>


    </form>
  </div>
  </div>
  <%@include file="includes/footer.jsp" %>
  </body>
</html>
