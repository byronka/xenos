<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>                                 
	<head>
		<title><%=loc.get(81, "Advanced search")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/header_mobile.css" >
			<link rel="stylesheet" href="advanced_search_mobile.css" >
		<% } else { %>
			<link rel="stylesheet" href="includes/header.css" >
			<link rel="stylesheet" href="advanced_search.css" >
		<% } %>
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

String stat_error_msg = "";
String st_da_error_msg = ""; //date
String end_da_error_msg = ""; //date
String user_error_msg = ""; 
String min_rank_error_msg = ""; 
String max_rank_error_msg = ""; 

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
    try{
      minrankvalue = Float.valueOf(minrank);
      if ( !(minrankvalue >= 0.0 && minrankvalue <= 1.0)) {
        min_rank_error_msg = 
          loc.get(163,"invalid - must be a number between 0.0 and 1.0");
        validation_error |= true;
      }
    } catch (Exception ex) {
      validation_error |= true;
      min_rank_error_msg = 
        loc.get(163,"invalid - must be a number between 0.0 and 1.0");
    }
  }

  // check that maxrank is either empty or a valid number
  if (Utils.is_null_or_empty(maxrank)) {
    maxrank = "";
  } else {
    try{
      maxrankvalue = Float.valueOf(maxrank);
      if ( !(maxrankvalue >= 0.0 && maxrankvalue <= 1.0)) {
        max_rank_error_msg = 
          loc.get(163,"invalid - must be a number between 0.0 and 1.0");
        validation_error |= true;
      }
    } catch (Exception ex) {
      validation_error |= true;
      max_rank_error_msg = 
        loc.get(163,"invalid - must be a number between 0.0 and 1.0");
    }
  }
  
  // make sure that minrank is less than maxrank
  if (maxrankvalue != null && minrankvalue != null && 
        (maxrankvalue - minrankvalue) < 0) {
      validation_error |= true;
      min_rank_error_msg = 
        loc.get(164,"invalid - maximum rank must be greater than minimum rank");
      max_rank_error_msg = 
        loc.get(164,"invalid - maximum rank must be greater than minimum rank");
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
    st_da_error_msg = loc.get(83,"Invalid date");
  }
  if(enddate.length() > 0 && !Utils.is_valid_date(enddate)) {
    validation_error |= true;
    end_da_error_msg = loc.get(83,"Invalid date");
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
    user_error_msg = loc.get(85,"No users found in string");
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
    <form method="POST" action="advanced_search.jsp">

    <h3><%=loc.get(10,"Description")%></h3>
    <div class="help-text">
      <%=loc.get(90,"Enter words to search in a description")%>
    </div>
    <div class="form-row">
      <label for="desc_input"><%=loc.get(10,"Description")%>: </label>
      <input type="text" id="desc_input" name="desc" value="<%=desc%>"/> 
    </div>

    <h3><%=loc.get(156,"Postal code")%></h3>
    <div class="help-text">
      <%=loc.get(162,"Enter a postal code to search")%>
    </div>
    <div class="form-row">
      <label for="postcode_input"><%=loc.get(156,"Postal code")%>: </label>
      <input type="text" id="postcode_input" name="postcode" value="<%=postcode%>"/> 
    </div>

    <h3><%=loc.get(79,"Rank")%></h3>
    <div class="help-text">
      <%=loc.get(161,"Enter a ranking value between 0.0 and 1.0")%>
    </div>
    <div class="form-row">
      <label for="minrank_input"><%=loc.get(14,"Minimum Rank")%>: </label>
      <input type="text" id="minrank_input" name="minrank" value="<%=minrank%>"/> 
    </div>
    <span class="error"><%=min_rank_error_msg%></span>

    <div class="help-text">
      <%=loc.get(161,"Enter a ranking value between 0.0 and 1.0")%>
    </div>
    <div class="form-row">
      <label for="maxrank_input"><%=loc.get(15,"Maximum Rank")%>: </label>
      <input type="text" id="maxrank_input" name="maxrank" value="<%=maxrank%>"/> 
    </div>
    <span class="error"><%=max_rank_error_msg%></span>

    <h3><%=loc.get(25,"Date")%></h3>
    <div class="form-row">
      <label for="startdate_input"><%=loc.get(86,"Start date")%>: </label>
      <input type="text" id="startdate_input" name="startdate" placeholder="2012-10-31" value="<%=startdate%>" /> 
    </div>
    <span class="error"><%=st_da_error_msg%></span>

    <div class="form-row">
      <label for="enddate_input"><%=loc.get(87,"End date")%>: </label>
      <input type="text" id="enddate_input" name="enddate" placeholder="2012-10-31" value="<%=enddate%>" /> 
    </div>
    <span class="error"><%=end_da_error_msg%></span>

		<h3><%=loc.get(24,"Status")%></h3>
      <%for (int s : Requestoffer_utils.get_requestoffer_statuses()) {%>
        <div class="form-row">
          <label for="status_checkbox_<%=s%>"><%=loc.get(s,"")%></label>
          <% if(java.util.Arrays.asList(statuses).contains(Integer.toString(s))) { %>
            <input type="checkbox" id="status_checkbox_<%=s%>" checked name="statuses" value="<%=s%>" />
          <% } else { %>
            <input type="checkbox" id="status_checkbox_<%=s%>" name="statuses" value="<%=s%>" />
          <% } %>
        </div>
      <% } %>

		<h3><%=loc.get(80,"User")%></h3>
    <div class="help-text">
      <%=loc.get(91,"Enter one or more usernames separated by spaces")%>
    </div>
    <div class="form-row">
      <label for="users_input"><%=loc.get(80,"User")%>: </label>
      <input type="text" id="users_input" name="users" value="<%=users%>" />
    </div>
    <span class="error"><%=user_error_msg%></span>


		<h3><%=loc.get(13,"Categories")%></h3>
      <%for(int c : Requestoffer_utils.get_all_categories()) {%>
      <div class="form-row"> 
        <label for="cat_checkbox_<%=c%>"><%=loc.get(c,"")%></label>
          <% if(java.util.Arrays.asList(categories).contains(Integer.toString(c))) { %>
            <input type="checkbox" id="cat_checkbox_<%=c%>" checked name="categories" value="<%=c%>" />
          <% } else { %>
            <input type="checkbox" id="cat_checkbox_<%=c%>" name="categories" value="<%=c%>" />
          <% } %>
        </div>
      <%}%>

      <button type="submit"><%=loc.get(1,"Search")%></button>
    </form>
  </body>
</html>

