<nav class="cl-effect-1">
	<a class="trademark" href="dashboard.jsp">Qarma</a>
</nav>
<form method="GET" action="dashboard.jsp" >
	<span><input type=text" name="search" maxlength="20" />
		<button><%=loc.get(1, "search")%></button></span>
</form>
<a href="create_request.jsp" ><%=loc.get(2, "Create Request")%></a>
<a href="logout.jsp" ><%=loc.get(3, "Logout")%></a>
<span><%=user.first_nameSafe()%></span>
<span> <%=user.last_nameSafe()%></span>
<span> (<%=user.emailSafe()%>) </span>
<span><%=user.points%> <%=loc.get(11, "points")%></span>
