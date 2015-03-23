<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <title><%=loc.get(2, "Request Favor")%></title>	
		<meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" title="desktop">
    <link rel="stylesheet" href="create_requestoffer.css" title="desktop">
    <script type="text/javascript" src="includes/utils.js"></script>
	</head>
	
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>

  <% 

  String qs = request.getQueryString();

  request.setCharacterEncoding("UTF-8");
    //get the values straight from the client
    String de = "";
    Integer selected_cat = null;
    boolean has_cat_error = false;
    boolean has_desc_error = false;
    boolean has_size_error = false;

    //address values
    String strt_addr_1_val = "";
    String strt_addr_2_val = "";
    String city_val        = "";
    String state_val       = "";
    String postal_val      = "";
    String country_val     = "";
    String savedlocation_val = "";
    String save_loc_to_user_checked = "";

    if (request.getMethod().equals("POST")) {

    //get values so if they are in validation mode they don't lose info.
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

      if (request.getParameter("save_loc_to_user") != null) {
        save_loc_to_user_checked = "checked";
      }


      boolean validation_error = false;

      de = request.getParameter("description").trim();
      if (de.length() == 0) {
        has_desc_error = true;
        validation_error |= true;
      }

      //parse out the categories from a string the client gave us
      selected_cat = Utils.parse_int(request.getParameter("categories"));
      
      if (selected_cat == null) {
        validation_error |= true;
        has_cat_error = true;
      }

      boolean user_entered_a_location = 
        Utils.parse_int(savedlocation_val) != null ||
        !Utils.is_null_or_empty(strt_addr_1_val) ||
        !Utils.is_null_or_empty(strt_addr_2_val) ||
        !Utils.is_null_or_empty(city_val) ||
        !Utils.is_null_or_empty(state_val) ||
        !Utils.is_null_or_empty(postal_val) ||
        !Utils.is_null_or_empty(country_val);
      
      if (!validation_error) {

        Requestoffer_utils.Put_requestoffer_result prr = null;
        int new_ro_id = 0;

        //try adding the new requestoffer - if failed, go to error page
        if ((prr = Requestoffer_utils.put_requestoffer(logged_in_user_id, de, selected_cat)).pe == Requestoffer_utils.Pro_enum.GENERAL_ERROR) {
          response.sendRedirect("general_error.jsp");
          return;
        }
        new_ro_id = prr.id; //get the requestoffer id from the result.

        if (prr.pe == Requestoffer_utils.Pro_enum.DATA_TOO_LARGE) {
          has_size_error = true;
          return;
        }
       
        //if we got here, a requestoffer was successfully added.
        if (user_entered_a_location) {

          Integer location_id = 0;
          if ((location_id = Utils.parse_int(savedlocation_val)) != null) {
            Requestoffer_utils.assign_location_to_requestoffer(location_id, new_ro_id);
          } else {
            int uid = request.getParameter("save_loc_to_user") != null ? logged_in_user_id : 0;
            Requestoffer_utils.put_location(
              uid, new_ro_id,
              strt_addr_1_val, strt_addr_2_val, 
              city_val, state_val, postal_val, country_val);
          }
        }

        response.sendRedirect("requestoffer_created.jsp?requestoffer=" + new_ro_id);
        return;
      }
    }
  %>
	
	<body>
    <img id='my_background' style="z-index:-1;top:0;left:0;width:100%;height:100%;opacity:0;position:fixed;" src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
    <%@include file="includes/header.jsp" %>	
    <%@include file="create_requestoffer_html.jsp" %>	

	     
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
