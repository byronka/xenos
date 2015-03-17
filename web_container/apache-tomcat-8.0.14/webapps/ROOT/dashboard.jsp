<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Others_Requestoffer" %>
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
  String srch_minrank = params.get("minrank"); //rank
  String srch_maxrank = params.get("maxrank"); //rank
  String srch_postcode = params.get("postcode"); //postcode

  Integer which_page = Utils.parse_int(params.get("page"));
  if (which_page == null) {which_page = 0;}

 
 

%>
<!DOCTYPE html>
<html>                                 
  <head>
     <link rel="stylesheet" href="includes/reset.css">
     <link rel="stylesheet" href="dashboard.css" >
    <%if (probably_mobile) {%>
     <link rel="stylesheet" href="includes/header_mobile.css" >
    <% } else { %>
     <link rel="stylesheet" href="includes/header.css" >
    <% } %>    
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=loc.get(16,"The dashboard")%></title>
  </head>

<body>
<%@include file="includes/header.jsp" %>
<div class="dashboard-container">
<%
  String decoded_srch_desc = "";
  if (srch_desc != null) {
    decoded_srch_desc = java.net.URLDecoder.decode(srch_desc, "UTF-8");
  }
  Requestoffer_utils.Search_Object so = 
    new Requestoffer_utils.Search_Object(  
                                      srch_startdate, 
                                      srch_enddate, 
                                      srch_cat, 
                                      decoded_srch_desc,
                                      srch_sta, 
                                      srch_us,
                                      srch_minrank,
                                      srch_maxrank,
                                      srch_postcode
                                      );
  Requestoffer_utils.OR_Package or_package = 
    Requestoffer_utils.get_others_requestoffers(user_id, 
                                      so , 
                                      which_page);
  for (Others_Requestoffer r : or_package.get_requestoffers()) {
%>
  <%int l_step = Requestoffer_utils.get_ladder_step(r.rank_ladder);%>
  <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
    <ul>
      <li class="description">
        <div class="desc container">
          <div class="value description">
            <%=Utils.safe_render(r.description)%></div>
            <div class="datetime">
              <span class="label"><%=loc.get(25, "Date")%>:</span>
              <span class="value"><%=r.datetime%></span>
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
<script type="text/javascript" src="includes/user_notify.js"></script>
</body>
</html>
