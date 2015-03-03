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
  <a href="change_password.jsp"><%=loc.get(113,"Change password")%></a>

  <h3><%=Utils.safe_render(user.username)%></h3>
  <ul>
    <li>Rank: <%=user.rank%></li>
    <li>Points: <%=user.points%></li>
  </ul>

  <h3><%=loc.get(79, "Rank")%></h3>

  <%
    Requestoffer_utils.Rank_detail[] rank_details = 
      Requestoffer_utils.get_rank_detail(user_id);
  %>

    <%if (rank_details.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
    <% } %> 

  <%	for (Requestoffer_utils.Rank_detail rd : rank_details) { %>

  <% if (rd.status_id == 2 || rd.status_id == 3) { 
      //don't even show a particular line unless status is 2 or 3
  %>

    <%
    //there's two parties here: the judging and the judged
    if (rd.judging_user_id == user_id) { // if we are the judge
    %>

      <div class="rank-detail">
        <%=rd.timestamp%>
        <%=loc.get(165,"You")%>

        <% if(rd.status_id == 3) {%>
          <% if (rd.meritorious) { %>
            <%=loc.get(166,"increased")%>
          <% } else { %>
            <%=loc.get(167,"decreased")%>
          <% } %>
        <% } %>
          
        <% if (rd.status_id == 2) { %>
        <a href="judge.jsp?urdp=<%=rd.urdp_id%>&requestoffer=<%=rd.ro_id%>">
            <%=loc.get(181,"have not yet determined")%>
          </a>
        <% }  %>


          <%=loc.get(168,"the reputation of")%>
        <a href="user.jsp?user_id=<%=rd.judged_user_id%>">
          <%=Utils.safe_render(rd.judged_username)%>
        </a>

        <%=loc.get(170,"for the favor")%>
        <a href="requestoffer.jsp?requestoffer=<%=rd.ro_id%>">
          <%=Utils.safe_render(rd.ro_desc)%>
        </a>

      </div>

    <%
    } else { //if we are the judged
    %>

      <div class="rank-detail">
        <%=rd.timestamp%>
        <a href="user.jsp?user_id=<%=rd.judging_user_id%>">
          <%=Utils.safe_render(rd.judging_username)%>
        </a>

        <% if(rd.status_id == 3) {%>
          <% if (rd.meritorious) { %>
            <%=loc.get(166,"increased")%>
          <% } else { %>
            <%=loc.get(167,"decreased")%>
          <% } %>
        <% } else { %>
          <%=loc.get(180,"has not yet determined")%>
        <% }  %>
        
        <%=loc.get(169,"your reputation")%>
        <%=loc.get(170,"for the favor")%>

        <a href="requestoffer.jsp?requestoffer=<%=rd.ro_id%>">
          <%=Utils.safe_render(rd.ro_desc)%>
        </a>

      </div>

    <% } %>

    <% } %>
  <% }  %>

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
        <a 
          href="requestoffer.jsp?requestoffer=<%=o.requestoffer_id%>">
          <%=Utils.get_trunc(Utils.safe_render(o.description), 15)%>
        </a>
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
        
        <a href="user.jsp?user_id=<%=sr.user_id%>">
          <%=Utils.safe_render(servicer.username)%> 
        </a>
        <%=loc.get(138,"wants to service")%>
        <a href="requestoffer.jsp?requestoffer=<%=sr.requestoffer_id%>">
          <%=Utils.get_trunc(Utils.safe_render(sr.desc),15)%>
        </a>
        <a href="choose_handler.jsp?requestoffer=<%=sr.requestoffer_id%>&user=<%=sr.user_id%>">
          <%=loc.get(137,"Choose")%>
        </a>
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
					<%=Utils.get_trunc(Utils.safe_render(r.description),15)%> 
        </a>
        <a href="cancel_active_favor.jsp?requestoffer=<%=r.requestoffer_id%>">
          <%=loc.get(130,"Cancel")%>
        </a>
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
        <a href="cancel_active_favor.jsp?requestoffer=<%=r.requestoffer_id%>">
          <%=loc.get(130,"Cancel")%>
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
            href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&delete=true">
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
            href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&delete=true">
            <%=loc.get(21,"Delete")%>
          </a>
          <a class="button" href="publish_requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
            <%=loc.get(6,"Publish")%>
          </a>
			</div>
		<% } %>
		</div>

	<h3><%=loc.get(96, "My conversations")%></h3>

  <table border="1">
    <thead>
      <tr>
        <th><%=loc.get(172,"Timestamp")%></th>
        <th><%=loc.get(32,"Favor")%></th>
        <th><%=loc.get(171,"Message")%></th>
      </tr>
    </thead>
    <tbody>
   <% Requestoffer_utils.MyMessages[] mms 
     = Requestoffer_utils.get_my_conversations(user_id);
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

	<h3><%=loc.get(146, "My system messages")%></h3>

  <table border="1">
    <thead>
      <tr>
        <th><%=loc.get(172,"Timestamp")%></th>
        <th><%=loc.get(32,"Favor")%></th>
        <th><%=loc.get(171,"Message")%></th>
      </tr>
    </thead>
    <tbody>
   <% Requestoffer_utils.MyMessages[] system_mms 
     = Requestoffer_utils.get_my_system_messages(user_id, loc);
   for (Requestoffer_utils.MyMessages mm : system_mms) {%>
    <tr>
      <td><%=mm.timestamp%> </td>
      <td><a href="requestoffer.jsp?requestoffer=<%=mm.requestoffer_id%>"><%=Utils.get_trunc(Utils.safe_render(mm.desc),15)%></a> </td>
      <td><%=Utils.safe_render(mm.message)%></td>
    </tr>
		<% } %>
    </tbody>
  </table>
    <% if (system_mms.length == 0) { %>
      <p>(<%=loc.get(103,"None")%>)</p>
    <% } %>

  <%@include file="includes/timeout.jsp" %>
	</body>
</html>
