<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Others_Requestoffer" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/requestoffer.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <title><%=loc.get(97,"My Profile")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%
  request.setCharacterEncoding("UTF-8");
  if (request.getMethod().equals("POST")) {
    String the_user_desc = Utils.get_string_no_null(request.getParameter("user_description"));
    if (!User_utils.edit_description(logged_in_user_id, the_user_desc)) {
      response.sendRedirect("general_error.jsp");
      return;
    } else {
      response.sendRedirect("user.jsp?user_id="+logged_in_user_id);
      return;
    }
  }

  String qs = request.getQueryString();
  Integer uid = Utils.parse_int(Utils.parse_qs(qs).get("user_id"));
  if (uid == null) {
    uid = -1;
  }
  Boolean edit_desc = Boolean.parseBoolean(Utils.parse_qs(qs).get("edit_desc"));

  User the_user = User_utils.get_user(uid);
  if (the_user == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

%>
	<body>
  <%@include file="includes/header.jsp" %>

  <div class="container">
      <h3><%=Utils.safe_render(the_user.username)%></h3>

      <p class="user-description">
      <%if (edit_desc) { %>

        <form method="POST" action="user.jsp">
          <textarea 
            id="user_description" 
            name="user_description" 
            maxlength="500"
            ><%=Utils.safe_render(User_utils.get_user_description(uid))%></textarea>
          <div class="table">
          <div class="row">
            <button class="button" type="submit" ><%=loc.get(72,"Save description")%></button>
            <a class="button" href="user.jsp?user_id=<%=uid%>" >
              <%=loc.get(130,"Cancel")%>
            </a>
          </div>
          </div>
        </form>

      <% } else { %>
        <em>
          <%=Utils.safe_render(User_utils.get_user_description(uid))%>
        </em>
      <% } %>
      <p>

      <div class="table">
      <% if (uid == logged_in_user_id && !edit_desc ) { %>

          <div class="row">
            <a 
              class="button" 
              href="user.jsp?user_id=<%=uid%>&amp;edit_desc=true">
                <%=loc.get(84,"Edit description")%>
            </a>
          </div>

      <% } %>



      <%if (the_user.urdp_count >= 30) {%>
        <div class="row">
          <label><%=loc.get(18,"Rank average")%>:</label>
          <span><%=the_user.rank_av%></span>
        </div>
      <%}%>

      <%int l_step = Requestoffer_utils.get_ladder_step(the_user.rank_ladder);%>

      <div class="row">
        <label><%=loc.get(19,"Rank ladder")%>:</label>
        <span><%=Utils.get_stars(l_step)%></span>
      </div>

      <%
        Group_utils.Group_id_and_name[] shared_groups = 
          Group_utils.get_shared_groups(logged_in_user_id,uid);
      %>

      <% if (shared_groups.length > 0) { %>
        <div class="row">
          <label>Shared groups:</label>
          <% for (Group_utils.Group_id_and_name gian : shared_groups) { %>
            <a href="group.jsp?group_id=<%=gian.id%>"><%=gian.name%></a>
          <% } %>
        </div>
      <% } %>

      <% if (the_user.points < 0) { %>
        <div class="row">
          <label>
            <%=the_user.username%> 
            <%=String.format(loc.get(27,"owes people %d points"),-the_user.points)%>
          </label>
        </div>
      <% } else { %>
        <div class="row">
          <label>
            <%=the_user.username%> 
            <%=String.format(loc.get(9,"is owed %d points"),the_user.points)%>
          </label>
        </div>
      <% } %>
    </div>

    <%
      Requestoffer_utils.Rank_detail[] rank_details = 
        Requestoffer_utils.get_rank_detail(uid);
    %>

    <%if (rank_details.length != 0) {%>

      <%	for (Requestoffer_utils.Rank_detail rd : rank_details) { %>


      <% if (rd.status_id == 3) { %>
      <%
      //there's two parties here: the judging and the judged
      if (rd.judging_user_id == uid) { // if this user is the judge
      %>

        <div class="rank-detail">

          <% if(rd.meritorious != null) {%>
            <% if (rd.meritorious) { %>
            +1 <%=loc.get(17,"to")%>
            <% } else { %>
              -1 <%=loc.get(17,"to")%> 
            <% } %>
          <% } %>

          <a href="user.jsp?user_id=<%=rd.judged_user_id%>">
            <%=Utils.safe_render(rd.judged_username)%>
          </a>


        <%if (rd.comment.length() > 0) {%>
          ("<%=rd.comment%>")
        <%}%>
        </div>

      <%
      } else { 
      %>

        <div class="rank-detail">

          <% if(rd.meritorious != null) {%>
            <% if (rd.meritorious) { %>
           +1 from
            <% } else { %>
           -1 from
            <% } %>
          <% } %>

          <a href="user.jsp?user_id=<%=rd.judging_user_id%>">
            <%=Utils.safe_render(rd.judging_username)%>
          </a>


        <%if (rd.comment.length() > 0) {%>
          ("<%=rd.comment%>")
        <%}%>
        </div>
      <% } %>

    <% } %>
    <% } %>
    <% } %> 



  <div id="profile-container">



    <%if (rank_details.length != 0) {%>
      <% for (Requestoffer_utils.Rank_detail rd : rank_details) { %>
        <% if (rd.status_id == 2 ) { %>
          <% if (rd.judging_user_id == logged_in_user_id) { %>

            <div class="rank-detail">
              <a class="button" href="judge.jsp?urdp=<%=rd.urdp_id%>">
                <%=loc.get(79, "Rank")%>
                <%=Utils.safe_render(rd.judged_username)%>
              </a>
            </div>

          <% } %> 
        <% } %> 
      <% } %> 
    <% } %> 

      <%
        Requestoffer[] offers = 
          Requestoffer_utils
          .get_requestoffers_I_offered_to_service(logged_in_user_id);
      %>

      <%if (offers.length != 0) {%>
        <div><em><%=loc.get(119, "Favors I have offered to service")%></em></div>
        <%	for (Requestoffer r : offers) { %>
          <div class="requestoffer serviceoffered">
              <% // requestoffer view starts HERE %>
              <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <div class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                        <%=Utils.safe_render(r.description)%>
                        <div class="datetime">
                          <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                        </div>
                     </div> 
                     <div class="category c-<%=r.category%>" >&nbsp;</div>
              </a>
              <% // requestoffer view ENDS HERE %>
          </div>
        <% } %>
      <% } %> 


      <%
        Requestoffer_utils.Service_request[] service_requests = 
          Requestoffer_utils.get_service_requests(logged_in_user_id);
      %>

      <%if (service_requests.length != 0) {%>

      <div style="padding-top: 20px; padding-bottom: 20px;">
        <div><em><%=loc.get(120, "Offers to service my favors")%></em></div>
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
        <div><em><%=loc.get(102, "Favors I am handling")%>:</em></div>


        <%	for (Others_Requestoffer r : handling_requestoffers) { %>

            <% // requestoffer view starts HERE %>
            <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                <div class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                      <%=Utils.safe_render(r.description)%>
                      <div class="datetime">
                        <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                      </div>
                   </div> 
                   <div class="category c-<%=r.category%>" >&nbsp;</div>

                <%if (r.distance != null ) {%>
                  <li class="distance">
                    about <%=String.format("%.1f",r.distance)%> miles
                  </li>
                <% } %>

            </a>
            <% // requestoffer view ENDS HERE %>

        <% } %>
      <% } %> 


      <%
        Requestoffer[] my_closed_requestoffers = 
          Requestoffer_utils
          .get_requestoffers_for_user_by_status(logged_in_user_id,77);
          %>

       <% if (my_closed_requestoffers.length != 0) {%>

          <div><em class="my-requestoffers-header"><%=loc.get(124, "My closed Favors")%>:</em></div>
          <%	for (Requestoffer r : my_closed_requestoffers) { %>
            <div class="requestoffer mine">
              <% // requestoffer view starts HERE %>
              <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <div class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                        <%=Utils.safe_render(r.description)%>
                        <div class="datetime">
                          <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                        </div>
                     </div> 
                     <div class="category c-<%=r.category%>" >&nbsp;</div>
              </a>
              <% // requestoffer view ENDS HERE %>
            </div>
          <% } %>

      <% } %>


      <%
        Requestoffer[] my_taken_requestoffers = 
          Requestoffer_utils
          .get_requestoffers_for_user_by_status(logged_in_user_id,78);
      %>

      <% if (my_taken_requestoffers.length != 0) {%>
          <div><em><%=loc.get(123, "My Favors being serviced")%>:</em></div>
          <%for (Requestoffer r : my_taken_requestoffers) { %>
          <div class="requestoffer mine">
              <% // requestoffer view starts HERE %>
              <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <div class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                        <%=Utils.safe_render(r.description)%>
                        <div class="datetime">
                          <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                        </div>
                     </div> 
                     <div class="category c-<%=r.category%>" >&nbsp;</div>
              </a>
              <% // requestoffer view ENDS HERE %>
          </div>
        <% } %>
      <% } %>

      <%
        Requestoffer[] my_open_requestoffers = 
          Requestoffer_utils
          .get_requestoffers_for_user_by_status(logged_in_user_id,76);
      %>

        <% if (my_open_requestoffers.length != 0) {%>
            <div><em><%=loc.get(122, "My open Favors")%>:</em></div>
            <% for (Requestoffer r : my_open_requestoffers) { %>
            <div class="requestoffer mine">
              <% // requestoffer view starts HERE %>
              <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <div class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                        <%=Utils.safe_render(r.description)%>
                        <div class="datetime">
                          <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                        </div>
                     </div> 
                     <div class="category c-<%=r.category%>" >&nbsp;</div>
              </a>
              <% // requestoffer view ENDS HERE %>
            </div>
          <% } %>
        <% } %>

      <%
        Requestoffer[] my_draft_requestoffers = 
          Requestoffer_utils
          .get_requestoffers_for_user_by_status(logged_in_user_id,109);
      %>
      <% if (my_draft_requestoffers.length != 0) {%>
        <div><em><%=loc.get(125, "My draft Favors")%>:</em></div>
        <% for (Requestoffer r : my_draft_requestoffers) { %>
        <div class="requestoffer mine">
            <% // requestoffer view starts HERE %>
            <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                <div class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                      <%=Utils.safe_render(r.description)%>
                      <div class="datetime">
                        <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                      </div>
                   </div> 
                   <div class="category c-<%=r.category%>" >&nbsp;</div>
            </a>
            <% // requestoffer view ENDS HERE %>
        </div>
        <% } %>
      <% } %>


         <% Requestoffer_utils.MyMessages[] mms 
           = Requestoffer_utils.get_my_conversations(logged_in_user_id);
         %>
        <% if (mms.length != 0) { %>
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
        <% } %>
      </div>
  </div>
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
