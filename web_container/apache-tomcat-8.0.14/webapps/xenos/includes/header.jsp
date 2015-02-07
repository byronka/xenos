<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="header-container">
	<div class="header">
		<nav>
			<a class="trademark" href="dashboard.jsp">Xenos</a>
			<a 
				href="create_requestoffer.jsp" >
				<%=loc.get(2, "Create Requestoffer")%></a>
			<a href="logout.jsp" ><%=loc.get(3, "Logout")%></a>
		</nav>
		<form class="search" method="GET" action="dashboard.jsp" >
			<span><input type="text" name="ti" maxlength="20" />
				<button type="submit"><%=loc.get(1, "search")%></button></span>
		</form>
		<div class="user-displayname">
			<span id="username"><%=Utils.safe_render(user.username)%></span>
			<span id="points"><%=user.points%> <%=loc.get(11, "points")%></span>
			<input 
				type="hidden" 
				id="timeout_value" 
				value="<%=user.timeout_seconds%>" >
		</div>
		<a 
			class="advanced search" 
			href="advanced_search.jsp">
			<%=loc.get(81,"Advanced search")%>
		</a>
	</div>
</div>
