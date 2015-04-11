<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Others_Requestoffer" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>

<html>                                 
  <head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="dashboard.css" >
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css">
    <script type="text/javascript" src="includes/utils.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=loc.get(16,"The dashboard")%></title>
  </head>

<body>
  <img alt="background" 
    id='my_background' 
    src="img/galaxy_universe-normal.jpg" />
  <%@include file="includes/header.jsp" %>

  <div id="overall-container">


<div id="see-and-create-requestoffer">

<% // REQUESTOFFER ENTRIES START%>

  <div id="ro-container">
    <h3 style="color: white">Favors you can handle:</h3>
    <%

      String thequerystring = request.getQueryString();

      java.util.Map<String,String> params = Utils.parse_qs(thequerystring);

      //extract dates
      String srch_date = params.get("da"); 
      String srch_startdate = null;
      String srch_enddate = null;
      if (srch_date != null) {
        String[] srch_dates = srch_date.split(",");
        if (srch_dates.length > 0) {
          srch_startdate = srch_dates[0];
        }
        if (srch_dates.length > 1) {
          srch_enddate = srch_dates[1];
        }
      }

      String srch_cat = params.get("cat"); //categories
      String srch_desc = params.get("desc"); // description
      String srch_us = params.get("us"); //users
      String srch_sta = params.get("sta"); //status
      String srch_postcode = params.get("postcode"); //postal code id
      String srch_distance = params.get("distance"); 

      Integer which_page = Utils.parse_int(params.get("page"));
      if (which_page == null) {which_page = 0;}
    %>

    <%
      String decoded_srch_desc = "";
      if (srch_desc != null) {
        decoded_srch_desc = java.net.URLDecoder.decode(srch_desc, "UTF-8");
      }
      // if the user has not specifically asked to see closed and taken,
      // we will default to showing just "OPEN"
      if (Utils.is_null_or_empty(srch_sta)) {
        srch_sta = "76"; // "OPEN"
      }
      Requestoffer_utils.Search_Object so = 
        new Requestoffer_utils.Search_Object(  
                                          srch_startdate, 
                                          srch_enddate, 
                                          srch_cat, 
                                          decoded_srch_desc,
                                          srch_sta, 
                                          srch_us,
                                          srch_postcode,
                                          srch_distance
                                          );
      Requestoffer_utils.OR_Package or_package = 
        Requestoffer_utils.get_others_requestoffers(logged_in_user_id, 
                                          so , 
                                          which_page);
      for (Others_Requestoffer r : or_package.get_requestoffers()) { %>
      <%int l_step = Requestoffer_utils.get_ladder_step(r.rank_ladder);%>
      <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
        <ul>

          <li>
          <div class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                <%=Utils.safe_render(r.description)%>
                <div class="datetime">
                  <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                </div>
             </div> 
             <div class="category c-<%=r.category%>" >&nbsp;</div>
          </li>

          <li class="requestoffering-user-id">
            <div><%=loc.get(80, "User")%>:</div>
            <%
              User ru = User_utils.get_user(r.requestoffering_user_id);
            %>
            <span> <%=Utils.safe_render(ru.username)%></span>
          </li>

          <li class="categories">
            <div><%=loc.get(13, "Categories")%>:</div>
            <span >
              <%=loc.get(r.category,"")%> 
            </span>
          </li>

          <%if (r.distance != null ) {%>
            <li class="distance">
              about <%=String.format("%.1f",r.distance)%> miles
            </li>
          <% } %>

        </ul>
      </a>
    <% } %>

    <%if(or_package.page_count > 1) {%>
      <span style="color:white"><%=loc.get(93, "Page")%>: </span>
      <% 	
      String qs_without_page = "";
      if (!Utils.is_null_or_empty(thequerystring)) {
        qs_without_page = thequerystring.replaceAll("&{0,1}page=[0-9]+","");
      }
      for (int i = 0; i < or_package.page_count; i++) {
        if (which_page == i) {%>
        <a 
          href="dashboard.jsp?<%=qs_without_page%>&amp;page=<%=i%>" 
          class="page-link current-page"><%=i+1%></a>
        <% } else {%>
        <a class="page-link" href="dashboard.jsp?<%=qs_without_page%>&amp;page=<%=i%>"><%=i+1%></a>
        <%  }
      }%>
    <%}%>

  </div>

<% // REQUESTOFFER ENTRIES END %>

<% // MY PROFILE STARTS %>

<div id="profile-container">
  <div>
    <h3><%=loc.get(97,"My profile")%>: 
      <a href="user.jsp?user_id=<%=logged_in_user_id%>">
        <%=Utils.safe_render(logged_in_user.username)%>
      </a>
    </h3>
  </div>
    <div>
       <a class="button" href="change_current_location.jsp" >
         <%=loc.get(7, "Current location")%>: 
      <%
      String user_postcode = 
        Utils.is_null_or_empty(logged_in_user.postal_code) ? "none" : logged_in_user.postal_code; %>
      <%=Utils.safe_render(user_postcode)%></a>
    </div>
  <p>
    <a class="button" href="change_password.jsp">
      <%=loc.get(113,"Change password")%>
    </a>
  </p>
  <p>
    <a class="button" href="user_groups.jsp">
      <%=loc.get(8,"Your groups")%>
    </a>
  </p>
  <p>
    <a class="button" href="create_requestoffer.jsp"><%=loc.get(2,"Request Favor")%></a>
  </p>
  <p>
    <a class="button" href="select_country.jsp?usecase=1"><%=loc.get(14,"Request favor with location")%></a>
  </p>
  <%
   Group_utils.Invite_info[] iis = Group_utils.get_invites_for_user(logged_in_user_id);
  %>

  <% if (iis.length > 0) { %>
    <p>
      <em>
        Your invites to groups:
      </em>
    </p>

    <% for (Group_utils.Invite_info ii : iis ) { %>
    <a href="group.jsp?group_id=<%=ii.group_id%>"><%=Utils.safe_render(ii.groupname)%></a>
    <% } %>

  <% } %>

  <p>
    <a class="button" href="generate_icode.jsp">
      <%=loc.get(206,"Generate invitation code")%>
    </a>
  </p>

  <div class="table">
    <div class="row">
      <label><%=loc.get(11,"Rank average")%>:</label>
      <span><%=String.format("%.0f",logged_in_user.rank_av * 100)%>%</span>
    </div>
    <%int l_step = Requestoffer_utils.get_ladder_step(logged_in_user.rank_ladder);%>
    <div class="row">
      <label><%=loc.get(12,"Rank score")%>:</label>
      <span><%=Utils.get_stars(l_step)%></span>
    </div>
    <% if (logged_in_user.points < 0) { %>
      <div>
        <%=loc.get(165,"You")%> 
        <%=String.format(loc.get(27,"owe people %d points"),-logged_in_user.points)%>
      </div>
    <% } else { %>
      <div>
        <%=loc.get(165,"You")%> 
        <%=String.format(loc.get(9,"are owed %d points"),logged_in_user.points)%>
      </div>
    <% } %>
  </div>


  <%
    Requestoffer_utils.Rank_detail[] rank_details = 
      Requestoffer_utils.get_rank_detail(logged_in_user_id);
  %>

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
            <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
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
          <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
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
            <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
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
            <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
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
            <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
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
          <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
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
<% // MY PROFILE ENDS %>

</div>

<% // ADVANCED SEARCH STARTS %>

<div id="search-section">
  <div id="inner-search-section">
  <div>
      <h3><%=loc.get(81,"Advanced Search")%></h3>
  </div>

  <%
  // have to initialize these for use in advanced_search_html.jsp 
  String[] statuses = new String[0];
  String desc = "";
  String startdate = "";
  String enddate = "";
  String users = "";
  String postcode = "";
  String distance = "";
  String[] categories = new String[0];

  boolean validation_error = false; // when status doesn't exist
  boolean has_stat_error = false; // when status doesn't exist
  boolean has_st_da_error = false; //date
  boolean has_end_da_error = false; //date
  boolean has_user_error = false;  // when user cannot be found
  boolean has_distance_error = false; 
  %>
  <%@include file="advanced_search_html.jsp" %>
 
</div>


<% // ADVANCED SEARCH ENDS %>
  </div>
</div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>
