<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>                                 
	<head>
		<title><%=loc.get(81, "Advanced search")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Request_utils" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%

String category = "";
String statuses = "";
String title = "";
String minpoints = "";
String maxpoints = "";
String startdate = "";
String enddate = "";
String users = "";

String stat_error_msg = "";
String cat_error_msg = "";
String st_da_error_msg = ""; //date
String end_da_error_msg = ""; //date
String user_error_msg = ""; 

if (request.getMethod().equals("POST")) {
  boolean validation_error = false;

  //these guys don't require validation.
  if ((title = request.getParameter("title")) == null) {
    title = "";
  }

  if ((minpoints = request.getParameter("minpoints")) == null) {
    minpoints = "";
  }
  if ((maxpoints = request.getParameter("maxpoints")) == null) {
    maxpoints = "";
  }


  //parse out the statuses from a string the client gave us
  if ((statuses = request.getParameter("statuses")) == null) {
    statuses = "";
  }

  Integer[] status_array = Request_utils.parse_statuses_string(statuses, loc );

  if (status_array.length == 0 && statuses.length() > 0) { 
    //if there were no statuses found, but they entered something...
    validation_error |= true;
    stat_error_msg = loc.get(82,"No statuses found in string");
  }



  //parse out the categories from a string the client gave us
  if ((category = request.getParameter("categories")) == null) {
    category = "";
  }

  Integer[] cat_array = 
    Request_utils.parse_categories_string(category, loc );
  String categories = Utils.int_array_to_string(cat_array);

  if (cat_array.length == 0 && category.length() > 0) {
    validation_error |= true;
    cat_error_msg = loc.get(8,"No categories found in string");
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
  // or 0000 to 9999, dash, 0 to 12, number varying between 1 and 31 depending on month,space
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

  if(!validation_error) {
    String dashboard_string = String.format(
        "dashboard.jsp?da=%s,%s&ti=%s&pts=%s,%s&cat=%s&us=%s&sta=%s",
         startdate,enddate,title,minpoints,maxpoints,categories,user_ids,Utils.int_array_to_string(status_array) );
    response.sendRedirect(dashboard_string);
    return;
  }
}
  
%>

  <body>
  <%@include file="includes/header.jsp" %>
    <form method="POST" action="advanced_search.jsp">
      <p>
      <div class="help-text">
        <%=loc.get(90,"Enter words to search in a title")%>
      </div>
      <%=loc.get(12,"Title")%>: 
      <input type="text" name="title" value="<%=title%>"/> 
      </p>

    <b><%=loc.get(25,"Date")%></b>
    <p>
      <%=loc.get(86,"Start date")%>: 
      <input type="text" name="startdate" value="<%=startdate%>" /> 
      <span><%=st_da_error_msg%></span>
    </p>
    <p>
      <%=loc.get(87,"End date")%>: 
      <input type="text" name="enddate" value="<%=enddate%>" /> 
      <span><%=end_da_error_msg%></span>
    </p>

    <p>
      <%=loc.get(24,"Status")%>: 
      <input type="text" name="statuses" value="<%=statuses%>" /> 
      <span><%=stat_error_msg%></span>
    </p>

    <b><%=loc.get(11,"Points")%></b>
    <p>
    <%=loc.get(88,"Minimum points")%>: 
    <input type="text" name="minpoints" value="<%=minpoints%>" />
    </p>

    <p>
    <%=loc.get(89,"Maximum points")%>: 
    <input type="text" name="maxpoints" value="<%=maxpoints%>" />
    </p>

    <p>
    <div class="help-text">
      <%=loc.get(91,"Enter one or more usernames separated by spaces")%>
    </div>
      <%=loc.get(80,"User")%>: 
      <input type="text" name="users" value="<%=users%>" />
      <span><%=user_error_msg%></span>
    </p>


    <p>
    <div class="help-text">
      <%=loc.get(92,"Enter one or more categories separated by spaces")%>
    </div>
      <%=loc.get(13,"Categories")%>: 
      <input type="text" name="categories" value="<%=category%>" />
      <span><%=cat_error_msg%></span>
    </p>



      <div id='available-categories'>
        <%
          Integer[] local_cat_values = Request_utils.get_category_local_values();
          for(Integer val : local_cat_values) { %>
          <%=loc.get(val,"")%>,
        <%}%>
      </div>
      <button type="submit"><%=loc.get(1,"Search")%></button>
    </form>
  </body>
</html>

