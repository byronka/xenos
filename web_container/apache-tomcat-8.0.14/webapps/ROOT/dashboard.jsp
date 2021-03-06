<%@include file="includes/publicpage.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Others_Requestoffer" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>

<html>                                 
  <head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/dashboard.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=loc.get(16,"The dashboard")%></title>
  </head>

<body>
  <%@include file="includes/header.jsp" %>

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
        srch_sta = (new Integer(Const.Rs.OPEN)).toString();
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
      %>
      <% if (or_package.get_requestoffers().length == 0) { %>
        <%=loc.get(103, "None")%>
      <% } else { %>                                          
        <% for (Others_Requestoffer r : or_package.get_requestoffers()) { %>
        <%int l_step = Requestoffer_utils.get_ladder_step(r.rank_ladder);%>
        <div>
          <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
            <span class="desc container <%if(r.status == Const.Rs.TAKEN ){%><%="taken"%><%}%>">
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
        </div>
      <% } %>
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
  <%@include file="includes/footer.jsp" %>
</body>
</html>
