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
  <h3><%=loc.get(102, "Requests I am handling")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] handling_requestoffers = 
				Requestoffer_utils.get_requestoffers_I_am_handling(user_id);
        if (handling_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : handling_requestoffers) {
		%>
			<div class="requestoffer handling">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description),15)%> </a>
     
			</div>
		<% } %>

	<h3 class="my-requestoffers-header">
		<%=loc.get(18, "Your requestoffers")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_requestoffers = 
				Requestoffer_utils.get_requestoffers_for_user(user_id);
        if (my_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> </a>
        <%if(r.status == 76 || r.status == 109) {%>
          <a class="button" 
            href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&amp;delete=true">
            <%=loc.get(21,"Delete")%>
          </a>
          <%}%>
			</div>
		<% } %>
		</div>
	<h3><%=loc.get(96, "My Messages")%></h3>
  <table border="1">
    <thead>
      <tr>
        <th>timestamp</th>
        <th>requestoffer</th>
        <th>message</th>
      </tr>
    </thead>
    <tbody>
   <% Requestoffer_utils.MyMessages[] mms 
     = Requestoffer_utils.get_my_messages(user_id);
   for (Requestoffer_utils.MyMessages mm : mms) {%>
    <tr>
      <td><%=mm.timestamp%> </td>
      <td><a href="requestoffer.jsp?requestoffer=<%=mm.requestoffer_id%>"><%=Utils.get_trunc(Utils.safe_render(mm.desc),15)%></a> </td>
      <td><%=Utils.safe_render(mm.message)%></td>
    </tr>
		<% } %>
    </tbody>
  </table>
    <% if (mms.length == 0) { %>
      <p>(<%=loc.get(103,"None")%>)</p>
    <% } %>
  <script type="text/javascript" src="includes/timeout.js"></script>
	</body>
</html>
