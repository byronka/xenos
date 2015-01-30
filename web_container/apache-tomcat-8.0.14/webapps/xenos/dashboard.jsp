<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Request_utils" %>
<%@ page import="com.renomad.xenos.Request" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Others_Request" %>
<%

  String qs = request.getQueryString();

  java.util.Map<String,String> params = Utils.parse_qs(qs);

  //extract dates
  String srch_date = params.get("da"); 
  String srch_startdate = "";
  String srch_enddate = "";
  if (srch_date != null) {
    String[] srch_dates = srch_date.split(",");
    if (srch_dates.length > 0) {
      srch_startdate = srch_dates[0];
    }
    if (srch_dates.length > 1) {
      srch_enddate = srch_dates[1];
    }
  }

  //extract points
  Integer srch_minpts = null;
  Integer srch_maxpts = null;
  String srch_pts = params.get("pts"); //points
  if (srch_pts != null) {
    String[] srch_pts_array = srch_pts.split(",");
    if (srch_pts_array.length > 0) {
      srch_minpts = Utils.parse_int(srch_pts_array[0]);
    }
    if (srch_pts_array.length > 1) {
      srch_maxpts = Utils.parse_int(srch_pts_array[1]);
    }
  }

  String srch_cat = params.get("cat"); //categories
  String srch_ti = params.get("ti"); //title
  String srch_us = params.get("us"); //users
  String srch_sta = params.get("sta"); //status

  Integer which_page = Utils.parse_int(params.get("page"));
  if (which_page == null) {which_page = 0;}

%>
<!DOCTYPE html>
<html>                                 
  <head>
    <link rel="stylesheet" href="dashboard.css" >
    <script src="dashboard.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=loc.get(16,"The dashboard")%></title>
  </head>


<body>
<%@include file="includes/header.jsp" %>
<div class="dashboard-container">
<h2 class="my-requests-header"><%=loc.get(18, "Your requests")%>:</h2>
<div class="requests mine">
<%
  Request[] my_requests = 
    Request_utils.get_requests_for_user(user_id);
  for (Request r : my_requests) {
%>
  <div class="request mine">
    <a href="request.jsp?request=<%=r.request_id %>"> 
      <%=Utils.safe_render(r.title)%> </a>
    <a 
      class="button" 
      href="request.jsp?request=<%=r.request_id%>&delete=true">
      <%=loc.get(21,"Delete")%>
    </a>
  </div>
<% } %>
</div>
<h2 class="others-requests-header">
  <%=loc.get(19, "Other's requests")%>:
</h2>
<div class="requests others">
<%
  Request_utils.Search_Object so = 
    new Request_utils.Search_Object(  
                                      srch_startdate, 
                                      srch_enddate, 
                                      srch_ti, 
                                      srch_cat, 
                                      srch_sta, 
                                      srch_minpts, 
                                      srch_maxpts, 
                                      srch_us);
  Others_Request[] others_requests = 
    Request_utils.get_others_requests(user_id, 
                                      so , 
                                      which_page);
  for (Others_Request r : others_requests) {
%>
  <div class="others request">
    <a href="request.jsp?request=<%=r.request_id %>">
      <%=Utils.safe_render(r.title)%> 
    </a>
    <span class="handle-button-span">
      <a 
        class="button" 
        href="handle.jsp?request=<%=r.request_id%>"> 
        <%=loc.get(20, "Handle")%> 
      </a>
    </span>
    <ul>
      <li class="points">
        <span class="label"><%=loc.get(4, "Points")%>:</span>
        <span class="value"><%=r.points%></span>
      </li>
      <li class="rank">
        <span class="label"><%=loc.get(79, "Rank")%>:</span>
        <span 
          class='rank value' 
          title="<%=r.rank%> percent">
            <%=r.rank%>
        </span>
      </li>
      <li class="description">
        <div class="desc container">
          <div class="label"><%=loc.get(10, "Description")%>:</div>
          <div class="value description"><%=Utils.safe_render(r.description)%></div>
        </div>
      </li>
      <li class="status">
        <span class="label"><%=loc.get(24, "Status")%>:</span>
        <span 
          class="value">
          <%=loc.get(r.status,"")%></span>
      </li>
      <li class="datetime">
        <span class="label"><%=loc.get(25, "Date")%>:</span>
        <span class="value"><%=r.datetime%></span>
      </li>
      <li class="requesting-user-id">
        <span class="label"><%=loc.get(80, "User")%>:</span>
        <%
          User ru = User_utils.get_user(r.requesting_user_id);
        %>
        <span class="value"> <%=Utils.safe_render(ru.username)%></span>
      </li>
      <li>
        <span class="label"><%=loc.get(13, "Categories")%>:</span>

        <span class="value">
          <%for (Integer c : r.get_categories()) {%>
            <%=loc.get(c,"")%> 
          <%}%>               
        </span>
      </li>
    </ul>
  </div>
<% } %>
</div>

<form method="GET" action="dashboard.jsp">
  <span><%=loc.get(93, "Page")%></span>
  <select name="page">
    <%for (int i = 0; i < 4; i++) {
    if (which_page == i) {%>
        <option value="<%=i%>" selected="true"><%=i+1%></option>
      <% } else {%>
        <option value="<%=i%>"><%=i+1%></option>
      <%  }
      }%>
  </select>
  <button><%=loc.get(1, "search")%></button></span>

</div>
</form>
</body>
</html>
