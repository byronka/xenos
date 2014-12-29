<%@include file="includes/init.jsp" %>
<html>                                 
  <head><title><%=loc.get(81, "Advanced search")%></title></head>

<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Utils" %>
  <body>
	<%@include file="includes/header.jsp" %>
    <form method="GET" action="dashboard.jsp">
			<p><%=loc.get(12,"Title")%>: 
				<input type="text" name="title" /> 
			</p>

		<p>
			<%=loc.get(25,"Date")%>: 
			<input type="text" name="first_date" /> 
		</p>

		<p>
			<%=loc.get(25,"Date")%>: 
			<input type="text" name="last_date" /> 
		</p>

		<p>
			<%=loc.get(24,"Status")%>: 
			<input type="text" name="statuses" /> 
		</p>

		<p>
		<%=loc.get(13,"Categories")%>: 
		<input type="text" name="categories" />
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

