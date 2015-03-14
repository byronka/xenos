<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>                                 
	<head>
		<title><%=loc.get(81, "Advanced search")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%

request.setCharacterEncoding("UTF-8");
String statuses = "";
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
  if ((statuses = request.getParameter("statuses")) == null) {
    statuses = "";
  }

  Integer[] status_array = 
    Requestoffer_utils.parse_statuses_string(statuses, loc );

  if (status_array.length == 0 && statuses.length() > 0) { 
    //if there were no statuses found, but they entered something...
    validation_error |= true;
    stat_error_msg = loc.get(82,"No statuses found in string");
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

  //parse out the categories
  categories = request.getParameterValues("categories");

  if(!validation_error) {
    String dashboard_string = String.format(
      "dashboard.jsp?da=%s,%s&cat=%s&us=%s&sta=%s&desc=%s&minrank=%f&maxrank=%f&postcode=%s",
      startdate,
      enddate,
      categories,
      user_ids,
      Utils.int_array_to_string(status_array),
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
    <p>
      <div class="help-text">
        <%=loc.get(90,"Enter words to search in a description")%>
      </div>
      <%=loc.get(10,"Description")%>: 
      <input type="text" name="desc" value="<%=desc%>"/> 
    </p>

    <h3><%=loc.get(156,"Postal code")%></h3>
    <p>
      <div class="help-text">
        <%=loc.get(162,"Enter a postal code to search")%>
      </div>
      <%=loc.get(156,"Postal code")%>: 
      <input type="text" name="postcode" value="<%=postcode%>"/> 
    </p>

    <h3><%=loc.get(79,"Rank")%></h3>
    <p>
      <div class="help-text">
        <%=loc.get(161,"Enter a ranking value between 0.0 and 1.0")%>
      </div>
      <%=loc.get(14,"Minimum Rank")%>: 
      <input type="text" name="minrank" value="<%=minrank%>"/> 
      <span><%=min_rank_error_msg%></span>
    </p>

    <p>
      <div class="help-text">
        <%=loc.get(161,"Enter a ranking value between 0.0 and 1.0")%>
      </div>
      <%=loc.get(15,"Maximum Rank")%>: 
      <input type="text" name="maxrank" value="<%=maxrank%>"/> 
      <span><%=max_rank_error_msg%></span>
    </p>

    <h3><%=loc.get(25,"Date")%></h3>
    <p>
      <%=loc.get(86,"Start date")%>: 
      <input type="text" name="startdate" placeholder="2012-10-31" value="<%=startdate%>" /> 
      <span><%=st_da_error_msg%></span>
    </p>
    <p>
      <%=loc.get(87,"End date")%>: 
      <input type="text" name="enddate" placeholder="2012-10-31" value="<%=enddate%>" /> 
      <span><%=end_da_error_msg%></span>
    </p>

		<h3><%=loc.get(24,"Status")%></h3>
    <p>
      <%=loc.get(24,"Status")%>: 
			<input type="text" name="statuses" placeholder="<%=loc.get(76,"open")%>" value="<%=statuses%>" /> 
			<%=Requestoffer_utils.get_requestoffer_status_string(loc)%>
      <span><%=stat_error_msg%></span>
    </p>

		<h3><%=loc.get(80,"User")%></h3>
    <p>
    <div class="help-text">
      <%=loc.get(91,"Enter one or more usernames separated by spaces")%>
    </div>
      <%=loc.get(80,"User")%>: 
      <input type="text" name="users" value="<%=users%>" />
      <span><%=user_error_msg%></span>
    </p>


		<h3><%=loc.get(13,"Categories")%></h3>
    <p>
      <%for(int c : Requestoffer_utils.get_all_categories()) {%>
        <p>
          <%=loc.get(c,"")%>
          <% if(categories != null && java.util.Arrays.asList(categories).contains(Integer.toString(c))) { %>
            <input type="checkbox" checked name="categories" value="<%=c%>" />
          <% } else { %>
            <input type="checkbox" name="categories" value="<%=c%>" />
          <% } %>
        </p>
      <%}%>
    </p>

      <button type="submit"><%=loc.get(1,"Search")%></button>
    </form>

    <%@include file="includes/timeout.jsp" %>

  </body>
</html>

