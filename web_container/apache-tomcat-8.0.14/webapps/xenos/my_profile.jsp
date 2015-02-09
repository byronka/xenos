<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(97,"My Profile")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>
	<button>Change password</button>
	<h3 class="my-requestoffers-header">
		<%=loc.get(18, "Your requestoffers")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_requestoffers = 
				Requestoffer_utils.get_requestoffers_for_user(user_id);
			for (Requestoffer r : my_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.safe_render(r.title)%> </a>
				<a 
					class="button" 
					href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&amp;delete=true">
					<%=loc.get(21,"Delete")%>
				</a>
			</div>
		<% } %>
		</div>
	<h3><%=loc.get(96, "My Messages")%></h3>
  <table border="1">
    <thead>
      <tr>
        <th>timestamp</th>
        <th>requestoffer</th>
        <th>from:</th>
        <th>to:</th>
        <th>message</th>
      </tr>
    </thead>
    <tbody>
  <% for (Requestoffer_utils.MyMessages mm : Requestoffer_utils.get_my_messages(user_id)) {%>
    <tr>
      <td><%=mm.timestamp%> </td>
      <td><%=mm.requestoffer_id%> </td>
      <td><%=Utils.safe_render(mm.fname)%> </td>
      <td><%=Utils.safe_render(mm.tname)%> </td>
      <td><%=Utils.safe_render(mm.message)%></td>
    </tr>
		<% } %>
    </tbody>
  </table>
	</body>
</html>
