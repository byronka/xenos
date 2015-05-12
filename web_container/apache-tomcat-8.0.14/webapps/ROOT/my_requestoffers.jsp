<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/requestoffer.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <title>My Favors</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>

  <div class="container">

    <%
      Requestoffer[] offers = 
        Requestoffer_utils
        .get_requestoffers_I_offered_to_service(logged_in_user_id);
    %>

    <%if (offers.length != 0) {%>
      <div class="row">
        <div><em><%=loc.get(119, "Favors I have offered to service")%></em></div>
        <%	for (Requestoffer r : offers) { %>
          <div class="requestoffer serviceoffered">
              <% // requestoffer view starts HERE %>
              <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <span class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                        <%=Utils.safe_render(r.description)%>
                        <span class="datetime">
                          <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                        </span>
                     </span> 
                     <span class="category c-<%=r.category%>" >&nbsp;</span>
              </a>
              <% // requestoffer view ENDS HERE %>
          </div>
        <% } %>
      </div>
    <% } %> 


    <%
      Requestoffer_utils.Service_request[] service_requests = 
        Requestoffer_utils.get_service_requests(logged_in_user_id);
    %>

    <%if (service_requests.length != 0) {%>

    <div class="row">
      <div><em><%=loc.get(120, "Offers to service my favors")%></em></div>
        <%for (Requestoffer_utils.Service_request sr : service_requests) { %>
          <div class="servicerequest">
            <%User servicer = User_utils.get_user(sr.user_id);%>
            
            <a href="user.jsp?user_id=<%=sr.user_id%>">
              <%=Utils.safe_render(servicer.username)%> 
            </a>
            <%
              Group_utils.Group_id_and_name[] servicers_shared_groups = 
                Group_utils.get_shared_groups(logged_in_user_id,sr.user_id);
            %>

            <% if (servicers_shared_groups.length > 0) { %>
                <% for (Group_utils.Group_id_and_name gian : servicers_shared_groups) { %>
                  <a class="group-name" href="group.jsp?group_id=<%=gian.id%>"><%=gian.name%></a>
                <% } %>
            <% } %>

            <%=loc.get(138,"wants to handle")%>
            <a href="requestoffer.jsp?requestoffer=<%=sr.requestoffer_id%>">
              <%=Utils.get_trunc(Utils.safe_render(sr.desc),15)%>
            </a>
            <a class="button" href="choose_handler.jsp?requestoffer=<%=sr.requestoffer_id%>&user=<%=sr.user_id%>">
              <%=loc.get(137,"Choose")%>
            </a>
          </div>
        <% } %>
      </div>
    <% } %> 


    <%
      Others_Requestoffer[] handling_requestoffers = 
        Requestoffer_utils.get_requestoffers_I_am_handling(logged_in_user_id);
    %>
      <%if (handling_requestoffers.length != 0) {%>
      <div class="row">
        <div><em><%=loc.get(102, "Favors I am handling")%>:</em></div>


        <%	for (Others_Requestoffer r : handling_requestoffers) { %>

            <% // requestoffer view starts HERE %>
            <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                <span class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                      <%=Utils.safe_render(r.description)%>
                      <span class="datetime">
                        <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                      </span>
                   </span> 
                   <span class="category c-<%=r.category%>" >&nbsp;</span>

                <%if (r.distance != null ) {%>
                  <span class="distance">
                    about <%=String.format("%.1f",r.distance)%> miles
                  </span>
                <% } %>

            </a>
            <% // requestoffer view ENDS HERE %>
        <% } %>
      </div>
    <% } %> 


  <%
    Requestoffer[] my_closed_requestoffers = 
      Requestoffer_utils
      .get_requestoffers_for_user_by_status(logged_in_user_id,77);
      %>

   <% if (my_closed_requestoffers.length != 0) {%>

     <div class="row">
        <div><em class="my-requestoffers-header"><%=loc.get(124, "My closed Favors")%>:</em></div>
        <%	for (Requestoffer r : my_closed_requestoffers) { %>
          <div class="requestoffer mine">
            <% // requestoffer view starts HERE %>
            <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                <span class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                      <%=Utils.safe_render(r.description)%>
                      <span class="datetime">
                        <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                      </span>
                   </span> 
                   <span class="category c-<%=r.category%>" >&nbsp;</span>
            </a>
            <% // requestoffer view ENDS HERE %>
          </div>
        <% } %>
      </div>
    <% } %>


    <%
      Requestoffer[] my_taken_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,78);
    %>

    <% if (my_taken_requestoffers.length != 0) {%>
      <div class="row">
        <div><em><%=loc.get(123, "My Favors being serviced")%>:</em></div>
        <%for (Requestoffer r : my_taken_requestoffers) { %>
        <div class="requestoffer mine">
            <% // requestoffer view starts HERE %>
            <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                <span class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                      <%=Utils.safe_render(r.description)%>
                      <span class="datetime">
                        <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                      </span>
                   </span> 
                   <span class="category c-<%=r.category%>" >&nbsp;</span>
            </a>
            <% // requestoffer view ENDS HERE %>
        </div>
      <% } %>
      </div>
    <% } %>

    <%
      Requestoffer[] my_open_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,76);
    %>

      <% if (my_open_requestoffers.length != 0) {%>
        <div class="row">
          <div><em><%=loc.get(122, "My open Favors")%>:</em></div>
          <% for (Requestoffer r : my_open_requestoffers) { %>
          <div class="requestoffer mine">
            <% // requestoffer view starts HERE %>
            <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                <span class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                      <%=Utils.safe_render(r.description)%>
                      <span class="datetime">
                        <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                      </span>
                   </span> 
                   <span class="category c-<%=r.category%>" >&nbsp;</span>
            </a>
            <% // requestoffer view ENDS HERE %>
          </div>
        <% } %>
        </div>
      <% } %>

    <%
      Requestoffer[] my_draft_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,109);
    %>
    <% if (my_draft_requestoffers.length != 0) {%>
      <div class="row">
      <div><em><%=loc.get(125, "My draft Favors")%>:</em></div>
      <% for (Requestoffer r : my_draft_requestoffers) { %>
      <div class="requestoffer mine">
          <% // requestoffer view starts HERE %>
          <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
              <span class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                    <%=Utils.safe_render(r.description)%>
                    <span class="datetime">
                      <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                    </span>
                 </span> 
                 <span class="category c-<%=r.category%>" >&nbsp;</span>
          </a>
          <% // requestoffer view ENDS HERE %>
      </div>
      <% } %>
      </div>
    <% } %>


       <% Requestoffer_utils.MyMessages[] mms 
         = Requestoffer_utils.get_my_conversations(logged_in_user_id);
       %>
      <% if (mms.length != 0) { %>
      <div class="row">
        <div><em><%=loc.get(96, "My conversations")%></em></div>
          <table >
            <thead>
              <tr>
                <th style="text-align: left"><%=loc.get(32,"Favor")%></th>
                <th style="text-align: left"><%=loc.get(171,"Message")%></th>
              </tr>
            </thead>
            <tbody>
              <% for (Requestoffer_utils.MyMessages mm : mms) {%>
                <tr>
                  <td><a href="requestoffer.jsp?requestoffer=<%=mm.requestoffer_id%>"><%=Utils.get_trunc(Utils.safe_render(mm.desc),15)%></a> </td>
                  <td style="width: 250px"><%=Utils.safe_render(mm.message)%></td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
        <% } %>

    </div>
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
