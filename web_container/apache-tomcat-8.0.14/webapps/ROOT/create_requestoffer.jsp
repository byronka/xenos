<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<!DOCTYPE html>
<html>
	<head>
    <title><%=loc.get(2, "Request Favor")%></title>	
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	

  <% 

  Integer country_id = null;
  Integer postal_code_id = null;

  String qs = request.getQueryString();
  country_id = Utils.parse_int(Utils.parse_qs(qs).get("c"));
  postal_code_id = Utils.parse_int(Utils.parse_qs(qs).get("p"));

  request.setCharacterEncoding("UTF-8");
    //get the values straight from the client
    String de = "";
    Integer selected_cat = null;
    boolean has_desc_error = false;
    boolean has_size_error = false;
    boolean has_cat_error = false;

    if (request.getMethod().equals("POST")) {

    //get values so if they are in validation mode they don't lose info.

      postal_code_id = 
        Utils.parse_int(request.getParameter("postal_code_id"));

      country_id = 
        Utils.parse_int(request.getParameter("country_id"));


      boolean validation_error = false;

      de = request.getParameter("description").trim();
      if (de.length() == 0) {
        has_desc_error = true;
        validation_error |= true;
      }

      selected_cat = Utils.parse_int(request.getParameter("categories"));
      if (selected_cat == null) {
        has_cat_error = true;
        validation_error |= true;
      }
      
      if (!validation_error) {

        Requestoffer_utils.Put_requestoffer_result prr = null;
        int new_ro_id = 0;

        //try adding the new requestoffer - if failed, go to error page
        prr = Requestoffer_utils.put_requestoffer(logged_in_user_id, de, selected_cat, country_id, postal_code_id);
        if (prr.pe == Requestoffer_utils.Pro_enum.GENERAL_ERROR) {
          response.sendRedirect("general_error.jsp");
          return;
        }
        new_ro_id = prr.id; //get the requestoffer id from the result.

        if (prr.pe == Requestoffer_utils.Pro_enum.DATA_TOO_LARGE) {
          has_size_error = true;
          return;
        }
       
        response.sendRedirect("requestoffer_created.jsp?requestoffer=" + new_ro_id);
        return;
      }
    }
  %>
	
	<body>
    <%@include file="includes/header.jsp" %>	
    <%@include file="create_requestoffer_html.jsp" %>	
    <%@include file="includes/footer.jsp" %>
	</body>
</html>
