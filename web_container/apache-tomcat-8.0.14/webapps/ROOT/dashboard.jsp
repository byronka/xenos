<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Others_Requestoffer" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>

<html>                                 
  <head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="dashboard.css" >
    <link rel="stylesheet" href="includes/header.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=loc.get(16,"The dashboard")%></title>
  </head>

<body>
    <img id='my_background' style="z-index:-1;top:0;left:0;width:100%;height:100%;opacity:0;position:fixed;" src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
<%@include file="includes/header.jsp" %>
<div id="overall-container">


<div id="see-and-create-requestoffer">

<% // REQUESTOFFER ENTRIES START%>

  <div id="ro-container">
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
      String srch_postcode = params.get("postcode"); //postcode
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
            <div class="category c-<%=r.category%>" />
          </li>

          <li class="requestoffering-user-id">
            <label><%=loc.get(80, "User")%>:</label>
            <%
              User ru = User_utils.get_user(r.requestoffering_user_id);
            %>
            <span> <%=Utils.safe_render(ru.username)%></span>
          </li>

          <li class="categories">
            <label><%=loc.get(13, "Categories")%>:</label>
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
      <span><%=loc.get(93, "Page")%>: </span>
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

<% // ADVANCED SEARCH STARTS %>

<div id="search_section">

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

  boolean has_stat_error = false; // when status doesn't exist
  boolean has_st_da_error = false; //date
  boolean has_end_da_error = false; //date
  boolean has_user_error = false;  // when user cannot be found
  boolean has_distance_error = false; 
  %>
  <%@include file="advanced_search_html.jsp" %>
 
</div>


<% // ADVANCED SEARCH ENDS %>
<% // CREATE REQUESTOFFER STARTS %>

<div id="create-requestoffer-container">

  <%
  // have to initialize these for use in create_requestoffer_html 
  String de = "";
  Integer selected_cat = null;
  boolean has_cat_error = false;
  boolean has_desc_error = false;
  boolean has_size_error = false;

  //address values
  String strt_addr_1_val = "";
  String strt_addr_2_val = "";
  String city_val        = "";
  String state_val       = "";
  String postal_val      = "";
  String country_val     = "";
  String savedlocation_val = "";
  String save_loc_to_user_checked = ""; 
  %>
  <div>
      <h3><%=loc.get(2,"Request Favor")%></h3>
  </div>

  <%@include file="create_requestoffer_html.jsp" %>	
</div>

<% // CREATE REQUESTOFFER ENDS %>

</div>

<% // MY PROFILE STARTS %>

<div id="profile-container">
  <div>
      <h3><%=Utils.safe_render(logged_in_user.username)%></h3>
  </div>
    <div>
       <a href="change_current_location.jsp" >
      Current location: 
      <%
      String user_postcode = 
        Utils.is_null_or_empty(logged_in_user.postcode) ? "none" : logged_in_user.postcode; %>
      <%=user_postcode%></button>
    </div>
  <p>
    <a href="change_password.jsp"><%=loc.get(113,"Change password")%></a>
  </p>
  <p>
    <a href="generate_icode.jsp"><%=loc.get(206,"Generate invitation code")%></a>
  </p>

    <div>Rank average: <%=logged_in_user.rank_av * 100%>%</div>
    <%int l_step = Requestoffer_utils.get_ladder_step(logged_in_user.rank_ladder);%>
    <div>Rank ladder: <%=Utils.get_stars(l_step)%></div>
    <% if (logged_in_user.points < 0) { %>
      <div>
        <%=logged_in_user.username%> 
        <%=String.format(loc.get(27,"owes people %d points"),-logged_in_user.points)%>
      </div>
    <% } else { %>
      <div>
        <%=logged_in_user.username%> 
        <%=String.format(loc.get(9,"is owed %d points"),logged_in_user.points)%>
      </div>
    <% } %>


  <%
    Requestoffer_utils.Rank_detail[] rank_details = 
      Requestoffer_utils.get_rank_detail(logged_in_user_id);
  %>

  <%if (rank_details.length != 0) {%>
    <div><em><%=loc.get(79, "Rank")%></em></div>

    <%	for (Requestoffer_utils.Rank_detail rd : rank_details) { %>

    <% if (rd.status_id == 2 || rd.status_id == 3) { 
        //don't even show a particular line unless status is 2 or 3
    %>

      <%
      //there's two parties here: the judging and the judged
      if (rd.judging_user_id == logged_in_user_id) { // if we are the judge
      %>

        <div class="rank-detail">
          <%=loc.get(165,"You")%>

          <% if(rd.status_id == 3) {%>
            <% if (rd.meritorious) { %>
              <%=loc.get(166,"increased")%>
            <% } else { %>
              <%=loc.get(167,"decreased")%>
            <% } %>
          <% } %>
            
          <% if (rd.status_id == 2) { %>
          <a href="judge.jsp?urdp=<%=rd.urdp_id%>">
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
        <%if (rd.comment.length() > 0) {%>
          <%=loc.get(165,"You")%>
          commented: "<%=rd.comment%>"
        <%}%>

      <%
      } else { //if we are the judged
      %>

        <div class="rank-detail">
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

        <%if (rd.comment.length() > 0) {%>
          <a href="user.jsp?user_id=<%=rd.judging_user_id%>">
            <%=Utils.safe_render(rd.judging_username)%>
          </a>
          commented: "<%=rd.comment%>"
        <%}%>
      <% } %>

      <% } %>
    <% }  %>
    <% } %> 

		<%
			Requestoffer_utils.Offer_I_made[] offers = 
				Requestoffer_utils
        .get_requestoffers_I_offered_to_service(logged_in_user_id);
    %>

    <%if (offers.length != 0) {%>
      <div><em><%=loc.get(119, "Favors I have offered to service")%></em></div>
      <%	for (Requestoffer_utils.Offer_I_made o : offers) { %>
        <div class="requestoffer serviceoffered">
          <a 
            href="requestoffer.jsp?requestoffer=<%=o.requestoffer_id%>">
            <%=Utils.get_trunc(Utils.safe_render(o.description), 15)%>
          </a>
        </div>
      <% } %>
    <% } %> 


		<%
			Requestoffer_utils.Service_request[] service_requests = 
				Requestoffer_utils.get_service_requests(logged_in_user_id);
    %>

    <%if (service_requests.length != 0) {%>
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
          <a href="choose_handler.jsp?requestoffer=<%=sr.requestoffer_id%>&user=<%=sr.user_id%>">
            <%=loc.get(137,"Choose")%>
          </a>
        </div>
      <% } %>
    <% } %> 


		<%
			Requestoffer[] handling_requestoffers = 
				Requestoffer_utils.get_requestoffers_I_am_handling(logged_in_user_id);
    %>

    <%if (handling_requestoffers.length != 0) {%>
      <div><em><%=loc.get(102, "Favors I am handling")%>:</em></div>
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
            <a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
              <%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> 
            </a>
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
          <a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
            <%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> 
          </a>
          <a href="cancel_active_favor.jsp?requestoffer=<%=r.requestoffer_id%>">
            <%=loc.get(130,"Cancel")%>
          </a>
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
            <a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
              <%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> </a>
              <a class="button" 
                href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&delete=true">
                <%=loc.get(21,"Delete")%>
              </a>
              <a class="button" href="retract_requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                <%=loc.get(194,"Retract")%>
              </a>
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
    <% } %>


   <% Requestoffer_utils.MyMessages[] mms 
     = Requestoffer_utils.get_my_conversations(logged_in_user_id);
   %>
  <% if (mms.length != 0) { %>
    <div><em><%=loc.get(96, "My conversations")%></em></div>
    <table border="1">
      <thead>
        <tr>
          <th><%=loc.get(32,"Favor")%></th>
          <th><%=loc.get(171,"Message")%></th>
        </tr>
      </thead>
      <tbody>
        <% for (Requestoffer_utils.MyMessages mm : mms) {%>
          <tr>
            <td><a href="requestoffer.jsp?requestoffer=<%=mm.requestoffer_id%>"><%=Utils.get_trunc(Utils.safe_render(mm.desc),15)%></a> </td>
            <td><%=Utils.safe_render(mm.message)%></td>
          </tr>
        <% } %>
      </tbody>
    </table>
  <% } %>


    </div>


<% // MY PROFILE ENDS %>



</div>


  <%@include file="includes/footer.jsp" %>
</body>
</html>
