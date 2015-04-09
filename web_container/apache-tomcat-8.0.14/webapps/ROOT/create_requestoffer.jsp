<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<!DOCTYPE html>
<html>
	<head>
    <title><%=loc.get(2, "Request Favor")%></title>	
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	

  <% 

  String qs = request.getQueryString();

  request.setCharacterEncoding("UTF-8");
    //get the values straight from the client
    String de = "";
    Integer selected_cat = null;
    boolean has_desc_error = false;
    boolean has_size_error = false;
    boolean user_entered_a_location = false;
    boolean user_selected_a_location = false;

    //location values
    Integer postal_code_id      = null;
    Integer country_id          = null;
    String savedlocation_val = "";
    String save_loc_to_user_checked = "";

    if (request.getMethod().equals("POST")) {

    //get values so if they are in validation mode they don't lose info.

      postal_code_id = 
        Utils.parse_int(request.getParameter("postal"));

      country_id = 
        Utils.parse_int(request.getParameter("country"));

      savedlocation_val =
        Utils.get_string_no_null(request.getParameter("savedlocation"));

      if (request.getParameter("save_loc_to_user") != null) {
        save_loc_to_user_checked = "checked";
      }


      boolean validation_error = false;

      de = request.getParameter("description").trim();
      if (de.length() == 0) {
        has_desc_error = true;
        validation_error |= true;
      }

      selected_cat = Utils.parse_int(request.getParameter("categories"));
      
      user_entered_a_location = 
        postal_code_id || country_id;

      user_selected_a_location = 
        Utils.parse_int(savedlocation_val) != null;
      
      if (!validation_error) {

        Requestoffer_utils.Put_requestoffer_result prr = null;
        int new_ro_id = 0;

        //try adding the new requestoffer - if failed, go to error page
        if ((prr = Requestoffer_utils.put_requestoffer(
          logged_in_user_id, de, selected_cat)).pe == Requestoffer_utils.Pro_enum.GENERAL_ERROR) {
          response.sendRedirect("general_error.jsp");
          return;
        }
        new_ro_id = prr.id; //get the requestoffer id from the result.

        if (prr.pe == Requestoffer_utils.Pro_enum.DATA_TOO_LARGE) {
          has_size_error = true;
          return;
        }
       
        //if we got here, a requestoffer was successfully added.
        // we will prioritize getting text fields entered over the
        // user selecting an address.  that is why "user_entered_a_location"
        // comes first.
        if (user_entered_a_location ) {

          int uid = request.getParameter("save_loc_to_user") != null ? logged_in_user_id : 0;
          Requestoffer_utils.put_location(
            uid, new_ro_id,
            strt_addr_1_val, strt_addr_2_val, 
            city_val, state_val, postal_val, country_val);

        } else if (user_selected_a_location ) {
          Integer location_id = Utils.parse_int(savedlocation_val);
          Requestoffer_utils.assign_location_to_requestoffer(location_id, new_ro_id);
        }

        response.sendRedirect("requestoffer_created.jsp?requestoffer=" + new_ro_id);
        return;
      }
    }
  %>
	
	<body>
    <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
    <%@include file="includes/header.jsp" %>	
    <%@include file="create_requestoffer_html.jsp" %>	
    <%@include file="includes/footer.jsp" %>
	</body>
</html>
