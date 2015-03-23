<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>                                 
	<head>
		<title><%=loc.get(81, "Advanced search")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="advanced_search.css" >
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
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
String minrank = "";
String maxrank = "";
String postcode = "";
String[] categories = new String[0];

// all these errors should only occur on plain text entry
boolean has_stat_error = false; // when status doesn't exist
boolean has_st_da_error = false; //date
boolean has_end_da_error = false; //date
boolean has_user_error = false;  // when user cannot be found
boolean has_min_rank_error = false;  // when rank not between 0.0 and 1.0
boolean has_max_rank_error = false; 
boolean has_min_rank_greater_error = false; // when min rank is greater than max rank
boolean has_max_rank_lesser_error = false;

if (request.getMethod().equals("POST")) {
  boolean validation_error = false;

  //these guys don't require validation.
  if ((desc = request.getParameter("desc")) == null) {
    desc = "";
  }

  if ((postcode = request.getParameter("postcode")) == null) {
    postcode = "";
  }
  postcode = Utils.safe_render(postcode);


  Float minrankvalue = null;
  Float maxrankvalue = null;

  // rank has to be from 0.0 to 1.0
  minrank = request.getParameter("minrank");
  maxrank = request.getParameter("maxrank");

  // check that minrank is either empty or a valid number
  if (Utils.is_null_or_empty(minrank)) {
    minrank = "";
  } else {
    try {
      minrankvalue = Float.valueOf(minrank);
      if ( !(minrankvalue >= 0.0 && minrankvalue <= 1.0)) {
        has_min_rank_error = true;
        validation_error |= true;
      }
    } catch (Exception ex) {
      validation_error |= true;
      has_min_rank_error = true;
    }
  }

  // check that maxrank is either empty or a valid number
  if (Utils.is_null_or_empty(maxrank)) {
    maxrank = "";
  } else {
    try{
      maxrankvalue = Float.valueOf(maxrank);
      if ( !(maxrankvalue >= 0.0 && maxrankvalue <= 1.0)) {
        has_max_rank_error = true;
        validation_error |= true;
      }
    } catch (Exception ex) {
      validation_error |= true;
      has_max_rank_error = true;
    }
  }
  
  // make sure that minrank is less than maxrank
  if (maxrankvalue != null && minrankvalue != null && 
        (maxrankvalue - minrankvalue) < 0) {
      validation_error |= true;
      has_min_rank_greater_error = true;
      has_max_rank_lesser_error = true;
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
      "dashboard.jsp?da=%s,%s&cat=%s&us=%s&sta=%s&desc=%s&minrank=%f&maxrank=%f&postcode=%s",
      startdate,
      enddate,
      Utils.string_array_to_string(categories),
      user_ids,
      Utils.string_array_to_string(statuses),
      desc,
      minrankvalue,
      maxrankvalue,
      postcode );
    response.sendRedirect(dashboard_string);
    return;
  }
}
  
%>

  <body>
    <%@include file="includes/header.jsp" %>
    <h3 class="error">Invalid input received - check and resubmit</h3>
    <%@include file="advanced_search_html.jsp" %>
    <%@include file="includes/footer.jsp" %>
  </body>
</html>

