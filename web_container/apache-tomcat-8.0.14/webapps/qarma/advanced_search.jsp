<%@include file="includes/init.jsp" %>
<html>                                 
  <head><title><%=loc.get(81, "Advanced search")%></title></head>

<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Utils" %>
<%

String category = "";
String statuses = "";
String title = "";
String points = "";
String first_date = "";
String last_date = "";
String users = "";

String stat_error_msg = "";
String cat_error_msg = "";
String fd_error_msg = ""; //first date
String ld_error_msg = ""; //last date
String user_error_msg = ""; 

boolean validation_error = false;

//these guys don't require validation.
title = request.getParameter("title");
points = request.getParameter("points");


//parse out the statuses from a string the client gave us
statuses = request.getParameter("statuses");

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
category = request.getParameter("categories");

Integer[] cat_array = 
	Request_utils.parse_categories_string(category, loc );

if (cat_array.length == 0 && category.length() > 0) {
	validation_error |= true;
	cat_error_msg = loc.get(8,"No categories found in string");
}


//parse out the first date
first_date = request.getParameter("first_date");

String converted_first_date = 
	Utils.convert_value_to_date(first_date);

if (converted_first_date.equals("")) {
	validation_error |= true;
	fd_error_msg = loc.get(83,"Invalid first date");
}



//parse out the last date
last_date = request.getParameter("last_date");

String converted_last_date = Utils.convert_value_to_date(last_date);

if (converted_last_date.equals("")) {
	validation_error |= true;
	ld_error_msg = loc.get(84,"Invalid last date");
}



//parse out the user
users = request.getParameter("users");

//split the users string on one or more whitespace or one 
//or more non-word chars.
String[] split_user_names = users.split("\\s+?|\\W+?"); 

Integer[] user_ids = User_utils
	.get_user_ids_by_names(split_user_names);

if ((user_ids == null || user_ids.length == 0) && 
		users.length() > 0) {
	validation_error |= true;
	user_error_msg = loc.get(85,"No users found in string");
}

if (!validation_error) {
	//first date, last date, title, points, category, users, statuses
	dashboard_string = 
		String.format(
			"dashboard.jsp?fd=%s&ld=%s&ti=%s&pts=%s&cat=%s&us=%s&sta=%s",
			 first_date,last_date,title,points,categories,users,statuses );
	response.sendRedirect(dashboard_string);
	return;
}
	
%>

  <body>
	<%@include file="includes/header.jsp" %>
    <form method="POST" action="advanced_search.jsp">
			<p><%=loc.get(12,"Title")%>: 
			<input type="text" name="title" value="<%=title%>"/> 
			</p>

		<p>
			<%=loc.get(25,"Date")%>: 
			<input type="text" name="first_date" value="<%=first_date%>" /> 
		</p>

		<p>
			<%=loc.get(25,"Date")%>: 
			<input type="text" name="last_date" value="<%=last_dat%>" /> 
		</p>

		<p>
			<%=loc.get(24,"Status")%>: 
			<input type="text" name="statuses" value="<%=statuses%>" /> 
		</p>

		<p>
		<%=loc.get(11,"Points")%>: 
		<input type="text" name="points" value="<%=points%>" />
		</p>

		<p>
		<%=loc.get(80,"User")%>: 
		<input type="text" name="users" value="<%=users%>" />
		</p>


		<p>
		<%=loc.get(13,"Categories")%>: 
		<input type="text" name="categories" value="<%=category%>" />
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

