<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%@ page import="com.renomad.qarma.Utils" %>
<%@ page import="com.renomad.qarma.Others_Request" %>
<%

	String qs = request.getQueryString();
	Map<String,String> params = Utils.parse_qs(qs);
	String search_term = params.get("search");

%>
<html>                                 
	<head>
		<link rel="stylesheet" href="dashboard.css" >
		<script src="dashboard.js"></script>
		<title><%=loc.get(16,"The dashboard")%></title>
	</head>


<body>
<%@include file="includes/header.jsp" %>
<h2 class="my-requests-header"><%=loc.get(18, "Your requests")%>:</h2>
<div class="my-requests">
<%
  Request[] my_requests = 
    Request_utils.get_requests_for_user(user_id);
  for (Request r : my_requests) {
%>
	<div class="request mine">
		<a href="request.jsp?request=<%=r.request_id %>"> 
			<%=r.titleSafe()%> </a>
		<a 
			class="button" 
			href="request.jsp?request=<%=r.request_id%>&delete=true">
			<%=loc.get(21,"Delete")%>
		</a>
	</div>
<% } %>
</div>
<h2 class="others-requests-header">
	<%=loc.get(19, "Other's requests")%>:
</h2>
<div class="others-requests">
<%
	Request_utils.Search_Object so = 
		new Request_utils.Search_Object(
			first_date,
			last_date,
			title_string,
			categories,
			statuses);
  Others_Request[] others_requests = 
		Request_utils
			.get_others_requests(user_id, so ,page,page_size);
  for (Others_Request r : others_requests) {
%>
	<div class="others request">
		<a href="request.jsp?request=<%=r.request_id %>">
			<%=r.titleSafe()%> 
		</a>
		<span class="handle-button-span">
			<a 
				class="button" 
				href="request.jsp?request=<%=r.request_id%>&service=true"> 
				<%=loc.get(20, "Handle")%> 
			</a>
		</span>
		<ul>
			<li class="points">
				<span class="label"><%=loc.get(4, "Points")%>:</span>
				<span class="value"><%=r.points%></span>
			</li>
			<li class="rank">
				<span class="label"><%=loc.get(79, "Rank")%>:</span>
				<span 
					class='rank value' 
					title="<%=r.rank%> percent">
						<%=r.rank%>
				</span>
			</li>
			<li class="description">
				<div class="desc container">
					<div class="label"><%=loc.get(10, "Description")%>:</div>
					<div class="value description"><%=r.descriptionSafe()%></div>
				</div>
			</li>
			<li class="status">
				<span class="label"><%=loc.get(24, "Status")%>:</span>
				<span 
					class="value">
					<%int status_val = Request_utils.
						get_status_localization_value(r.status %>);
					<%=loc.get(status_val,"")%></span>
			</li>
			<li class="datetime">
				<span class="label"><%=loc.get(25, "Date")%>:</span>
				<span class="value"><%=r.datetime%></span>
			</li>
			<li class="requesting-user-id">
				<span class="label"><%=loc.get(80, "User")%>:</span>
				<%
					User ru = User_utils.get_user(r.requesting_user_id);
				%>
				<span class="value">
					<%=ru.first_nameSafe()%> <%=ru.last_nameSafe()%></span>
			</li>
			<li>
				<span class="label"><%=loc.get(13, "Categories")%>:</span>

				<span class="value">
					<%for (Integer c : r.get_categories()) {%>
						<%=loc.get(c,"")%> 
					<%}%>               
				</span>
			</li>
		</ul>
	</div>
<% } %>
</div>
</body>
</html>
