<%@include file="includes/check_auth.jsp" %>
<%@ page import="com.renomad.qarma.Business_logic" %>
<%@ page import="com.renomad.qarma.Utils" %>
  <% 
		//get the values straight from the client
		String de = "";
		String t = "";
		String p = "";
		String c = "";
		String p_error_msg = "";
		String cat_error_msg = "";

		if (request.getMethod().equals("POST")) {
			boolean validation_error = false;
			de = request.getParameter("description");
			t = request.getParameter("title");

			//extract useful information from what the client sent us
			p = request.getParameter("points");
			int points = Utils.parse_int(p);
			if (points == Integer.MIN_VALUE) { 
				validation_error |= true;
				p_error_msg = "couldn't parse points";
			}

			//parse out the categories from a string the client gave us
			c = request.getParameter("categories");
			
			Integer[] cat = Business_logic.parse_categories_string(c);
			
			if (cat.length == 0) {
				validation_error |= true;
				cat_error_msg = "No categories found in string";
			}

			if (!validation_error) {
				Business_logic.put_request(user_id, de, points, t, cat);
				response.sendRedirect("dashboard.jsp");
			}
		}
  %>

<html>                                 
  <head><title>Create a request page</title></head>
  <body>
    <%@include file="includes/header.jsp" %>
    <h2>Create a Request!</h2>
    <form method="POST" action="create_request.jsp">
			<p>Description: 
				<input 
					type="text" 
					name="description" 
					value="<%=de%>"/> 
			</p>
		<div><%=p_error_msg%></div>
			<p>Points: <input type="text" name="points" value="<%=p%>"/> </p>
      <p>Title: <input type="text" name="title" value="<%=t%>"/> </p>
		<div><%=cat_error_msg%></div>
			<p>Categories: <input type="text" name="categories" value="<%=c%>"/></p>
			<div id='available-categories'>
				<%
					String[] categories = Business_logic.get_all_categories();
					for(String category : categories) { %>
					<%=category%>,
				<%}%>
			</div>
      <button type="submit">Create Request</button>
    </form>
  </body>
</html>
