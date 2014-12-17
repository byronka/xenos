<%@include file="includes/check_auth.jsp" %>
<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Utils" %>
  <% 
		//get the values straight from the client
		String de = "";
		String t = "";
		String p = "";
		String c = "";
		String p_error_msg = "";
		String cat_error_msg = "";
		String desc_error_msg = "";
		String not_enough_points_error_msg = "";
		String title_error_msg = "";

		if (request.getMethod().equals("POST")) {
			boolean validation_error = false;
			de = request.getParameter("description");
			if (de.length() == 0) {
      	desc_error_msg = "Please enter a description";
				validation_error |= true;
			}

			t = request.getParameter("title");
			if (t.length() == 0) {
      	title_error_msg = "Please enter a title";
				validation_error |= true;
			}

			//extract useful information from what the client sent us
			p = request.getParameter("points");
			int points = Utils.parse_int(p);
			if (points == Integer.MIN_VALUE) { 
				validation_error |= true;
				p_error_msg = "couldn't parse points";
			}

			//parse out the categories from a string the client gave us
			c = request.getParameter("categories");
			
			Integer[] cat = Request_utils.parse_categories_string(c);
			
			if (cat.length == 0) {
				validation_error |= true;
				cat_error_msg = "No categories found in string";
			}

			if (!validation_error) {
				Request_utils.Request_response result = 
					Request_utils.put_request(user_id, de, points, t, cat);
				if (result.s == Request_utils.Request_response.Stat.LACK_POINTS) {
					not_enough_points_error_msg = 
						"You don't have enough points to make this request!";
				} else {
					response.sendRedirect("dashboard.jsp");
				}
			}
		}
  %>

<html>                                 
  <head><title>Create a request page</title></head>
  <body>
    <%@include file="includes/header.jsp" %>
    <h2>Create a Request!</h2>
    <form method="POST" action="create_request.jsp">
			<div><%=not_enough_points_error_msg %></div>
			<p>Description: 
				<input 
					type="text" 
					name="description" 
					value="<%=de%>"/> 
			<span><%=desc_error_msg%></span>
			</p>

		<p>
			Points: 
			<input type="text" name="points" value="<%=p%>"/> 
			<span><%=p_error_msg%></span>
		</p>

		<p>
			Title: <input type="text" name="title" value="<%=t%>"/> 
			<span><%=title_error_msg%></span>
		</p>

		<p>
		Categories: 
		<input type="text" name="categories" value="<%=c%>"/>
		<span><%=cat_error_msg%></span>
		</p>

			<div id='available-categories'>
				<%
					String[] categories = Request_utils.get_str_array_categories();
					for(String category : categories) { %>
					<%=category%>,
				<%}%>
			</div>
      <button type="submit">Create Request</button>
    </form>
  </body>
</html>
