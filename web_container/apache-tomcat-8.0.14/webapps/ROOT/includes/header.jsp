<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="header-container">
	<div class="header">
		<a class="trademark" href="dashboard.jsp">Xenos</a>
		<a href="check_location.jsp" >
			<%=loc.get(2, "Request Favor")%>
    </a>
		<a href="logout.jsp" >
      <%=loc.get(3, "Logout")%>
    </a>
		<a href="my_profile.jsp" class="user-displayname">
			<%=Utils.safe_render(user.username)%>
      <%if (user.points > 0) {%>
        <%=String.format(loc.get(9, "is owed %d favors"),user.points)%>
      <% } else if (user.points == 0) {%>
        <%=loc.get(12, "owes, and is owed, nothing.")%>
      <% } else { %>
        <%=String.format(loc.get(27, "owes people %d favors"), -user.points)%>
      <% } %>
			<input 
				type="hidden" 
				id="timeout_value" 
				value="<%=user.timeout_seconds%>" >
		</a>
		<a class="advanced search" 
			href="advanced_search.jsp">
			<%=loc.get(81,"Advanced search")%>
		</a>
		<form class="search" method="GET" action="dashboard.jsp" >
			<span><input type="text" name="desc" maxlength="20" />
				<button type="submit"><%=loc.get(1, "search")%></button></span>
		</form>
	</div>
</div>
