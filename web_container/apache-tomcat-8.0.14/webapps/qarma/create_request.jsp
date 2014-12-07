<%@include file="includes/check_auth.jsp" %>
<%@ page import="com.renomad.qarma.Business_logic" %>

<html>                                 
  <head><title>Create a request page</title></head>
  <body>
    <%@include file="includes/header.jsp" %>
    <h2>Create a Request!</h2>
    <form method="POST" action="handle_create_request.jsp">
      <p>Description: <input type="text" name="description" /> </p>
			<p>Points: <input type="text" name="points" /> </p>
      <p>Title: <input type="text" name="title" /> </p>
			<p>Categories: <input type="text" name="categories" /></p>
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
