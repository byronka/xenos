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
String points = "";
String date = "";
String users = "";

String stat_error_msg = "";
String cat_error_msg = "";
String da_error_msg = ""; //date
String user_error_msg = ""; 

if (request.getMethod().equals("POST")) {
  boolean validation_error = false;

  //these guys don't require validation.
  if ((title = request.getParameter("title")) == null) {
    title = "";
  }

  if ((points = request.getParameter("points")) == null) {
    points = "";
  }


  //parse out the statuses from a string the client gave us
  if ((statuses = request.getParameter("statuses")) == null) {
    statuses = "";
  }

  //split the statuses string on one or more whitespace or one 
  //or more non-word chars.
  String[] split_statuses = statuses.split("\\s+?|\\W+?"); 

  Integer[] status_array = Request_utils
    .parse_statuses_string(split_statuses, loc );

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
  if ((date = request.getParameter("date")) == null) {
    date = "";
  }

  //a proper date will look like:
  // 2014-12-18 21:22:42
  // or 0000 to 9999, dash, 0 to 12, number varying between 1 and 31 depending on month,space
  //, 0 to 23, colon, 0 to 59, colon, 0 to 59
  if(date.length() > 0 && !Utils.is_valid_date(date)) {
    validation_error |= true;
    da_error_msg = loc.get(83,"Invalid date");
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
        "dashboard.jsp?da=%s&ti=%s&pts=%s&cat=%s&us=%s&sta=%s",
         date,title,points,categories,user_ids,statuses );
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
        enter words to search in a title
      </div>
      <%=loc.get(12,"Title")%>: 
      <input type="text" name="title" value="<%=title%>"/> 
      </p>

    <p>
      <div class="help-text">
        To use date search: enter a date in one of the following
        formats:
        <p> A) date            (a single date) ex: 2014-12-18</p>
        <p>B) date-date       (a date range) ex:
        2014-12-18-2014-12-22</p>
        <p>C) date-           (a date range, starting at date, ending
        forever)</p>
        <p>D) -date           (a date range, starting in the past,
        </p>
      </div>
      <%=loc.get(25,"Date")%>: 
      <input type="text" name="date" value="<%=date%>" /> 
      <span><%=da_error_msg%></span>
    </p>

    <p>
      <%=loc.get(24,"Status")%>: 
      <input type="text" name="statuses" value="<%=statuses%>" /> 
      <span><%=stat_error_msg%></span>
    </p>

    <p>
    <div class="help-text">
      <p> case A) points            Just a single value, "points"</p>
      <p> case B) points-points     a range of values, "points" to "points" </p>
      <p> case C) -points           anything up to "points"</p>
      <p> case D) points-           from "points" up</p>
    </div>
    <%=loc.get(11,"Points")%>: 
    <input type="text" name="points" value="<%=points%>" />
    </p>

    <p>
    <div class="help-text">
      enter one or more usernames separated by spaces
    </div>
      <%=loc.get(80,"User")%>: 
      <input type="text" name="users" value="<%=users%>" />
      <span><%=user_error_msg%></span>
    </p>


    <p>
    <div class="help-text">
      enter one or more categories separated by spaces
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

