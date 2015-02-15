<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link 
        rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(97,"My Profile")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>
	<a href="change_password.jsp">Change password</a>

  <h3><%=loc.get(119, "Favors I have offered to service")%></h3>
		<%
			Requestoffer_utils.Offer_I_made[] offers = 
				Requestoffer_utils
        .get_requestoffers_I_offered_to_service(user_id);
    %>

    <%if (offers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
    <% } %> 

    <%	for (Requestoffer_utils.Offer_I_made o : offers) { %>
			<div class="requestoffer serviceoffered">
        favor: <%=o.requestoffer_id%>
        <a href="#">Cancel service offer</a>
			</div>
		<% } %>

  <h3><%=loc.get(120, "Offers to service my favors")%></h3>
		<%
			Requestoffer_utils.Service_request[] service_requests = 
				Requestoffer_utils.get_service_requests(user_id);
    %>

    <%if (service_requests.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
    <% } %> 

    <%for (Requestoffer_utils.Service_request sr : service_requests) { %>
			<div class="servicerequest">
        <%User servicer = User_utils.get_user(sr.user_id);%>
        
        <a href="#">
          <%=servicer.username%> 
        </a>
          wants to service 
        <a href="<%=sr.requestoffer_id%>">
          <%=Utils.get_trunc(sr.desc,15)%>
        </a>
        <a href="#">Choose</a>
			</div>
		<% } %>

  <h3><%=loc.get(102, "Favors I am handling")%>:</h3>
		<%
			Requestoffer[] handling_requestoffers = 
				Requestoffer_utils.get_requestoffers_I_am_handling(user_id);
    %>

    <%if (handling_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
    <% } %> 

    <%	for (Requestoffer r : handling_requestoffers) { %>
			<div class="requestoffer handling">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description),15)%> </a>
			</div>
		<% } %>

	<h3 class="my-requestoffers-header">
		<%=loc.get(124, "My closed Favors")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_closed_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(user_id,77);
        if (my_closed_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_closed_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> 
        </a>
			</div>
		<% } %>
		</div>

	<h3 class="my-requestoffers-header">
		<%=loc.get(123, "My Favors being serviced")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_taken_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(user_id,78);
        if (my_taken_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_taken_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> 
        </a>
			</div>
		<% } %>
		</div>

	<h3 class="my-requestoffers-header">
		<%=loc.get(122, "My open Favors")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_open_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(user_id,76);
        if (my_open_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_open_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> </a>
          <a class="button" 
            href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&amp;delete=true">
            <%=loc.get(21,"Delete")%>
          </a>
			</div>
		<% } %>
		</div>

	<h3 class="my-requestoffers-header">
		<%=loc.get(125, "My draft Favors")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_draft_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(user_id,109);
        if (my_draft_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_draft_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> </a>
          <a class="button" 
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
