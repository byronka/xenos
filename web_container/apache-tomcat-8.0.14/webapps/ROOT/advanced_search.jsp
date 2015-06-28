<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>                                 
	<head>
		<title><%=loc.get(81, "Advanced search")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
    <script src="static/js/modernizr.js"></script>
    <script src="static/js/jquery.js"></script>
    <link rel="stylesheet" href="static/jqueryui/jquery-ui.min.css" >
    <script src="static/jqueryui/jquery-ui.min.js"></script>
	</head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%

request.setCharacterEncoding("UTF-8");

String[] statuses = new String[0];
String desc = "";
String startdate = "";
String enddate = "";
String users = "";
String postcode = "";
Double distance = null;
String[] categories = new String[0];
boolean validation_error = false;

// all these errors should only occur on plain text entry
boolean has_stat_error = false; // when status doesn't exist
boolean has_st_da_error = false; //date
boolean has_end_da_error = false; //date
boolean has_user_error = false;  // when user cannot be found
boolean has_distance_error = false; // if distance is not a double

if (request.getMethod().equals("POST")) {

  //these guys don't require validation.
  if ((desc = request.getParameter("desc")) == null) {
    desc = "";
  }

  if ((postcode = request.getParameter("postcode")) == null) {
    postcode = "";
  }


  //parse out the statuses from a string the client gave us
  if ((statuses = request.getParameterValues("statuses")) == null) {
    statuses = new String[0];
  }

  //parse out the date
  if ((startdate = request.getParameter("startdate")) == null) {
    startdate = "";
  }
  if ((enddate = request.getParameter("enddate")) == null) {
    enddate = "";
  }

  //a proper date will look like:
  // 2014-12-18
  // or 0000 to 9999, dash, 0 to 12, number varying between 1 
  // and 31 depending on month,space
  //, 0 to 23, colon, 0 to 59, colon, 0 to 59
  if(startdate.length() > 0 && !Utils.is_valid_date(startdate)) {
    validation_error |= true;
    has_st_da_error = true;
  }
  if(enddate.length() > 0 && !Utils.is_valid_date(enddate)) {
    validation_error |= true;
    has_end_da_error = true;
  }

  if (!Utils.is_null_or_empty(request.getParameter("distance")) && 
    (distance = Utils.parse_double(request.getParameter("distance"))) == null) {
    validation_error |= true;
    has_distance_error = true;
  }

  //parse out the user
  if ((users = request.getParameter("users")) == null) {
    users = "";
  }

  //split the users string on one or more whitespace or one 
  //or more non-word chars.
  String[] split_user_names = users.split("\\s+?|\\W+?"); 

  String user_ids = User_utils
    .get_user_ids_by_names(split_user_names);

  if ((user_ids == null || user_ids.equals("")) && 
      users.length() > 0) {
    validation_error |= true;
    has_user_error = true;
  }

  if ((categories = request.getParameterValues("categories")) == null) {
    categories = new String[0];
  }

  if(!validation_error) {
    String dashboard_string = String.format(
      "dashboard.jsp?da=%s,%s&cat=%s&us=%s&sta=%s&desc=%s&postcode=%s&distance=%.2f",
      startdate,
      enddate,
      Utils.string_array_to_string(categories),
      user_ids,
      Utils.string_array_to_string(statuses),
      desc,
      postcode,
      distance );
    response.sendRedirect(dashboard_string);
    return;
  }
}
  
%>

  <body>
    <%@include file="includes/header.jsp" %>
    <%@include file="advanced_search_html.jsp" %>
    <%@include file="includes/footer.jsp" %>
  </body>
</html>

