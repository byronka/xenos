<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Others_Requestoffer" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header>
  <div class="header-table">
    <div class="header-row">

      <div class="header-button">
        <a class="trademark" href="dashboard.jsp">Zenia</a>
      </div>

      <div class="header-button">
        <a class="button" href="advanced_search.jsp">
          <span><%=loc.get(81,"Advanced search")%></span>
          <img src="static/img/search_advanced.png"  />
        </a>
      </div>

      <div class="header-button">
        <a class="button" href="check_location_needed.jsp">
          <span><%=loc.get(2,"Request Favor")%></span>
          <img src="static/img/call_bell.png"   />
        </a>
      </div>

    <%
      Requestoffer[] header_offers = 
        Requestoffer_utils
        .get_requestoffers_I_offered_to_service(logged_in_user_id);

      Requestoffer_utils.Service_request[] header_service_requests = 
        Requestoffer_utils.get_service_requests(logged_in_user_id);

      Others_Requestoffer[] header_handling_requestoffers = 
        Requestoffer_utils.get_requestoffers_I_am_handling(logged_in_user_id);

      Requestoffer[] header_my_closed_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,77);

      Requestoffer[] header_my_taken_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,78);

      Requestoffer[] header_my_draft_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,109);

      Requestoffer[] header_my_open_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,76);

      int ho_count = header_offers.length;
      int hsr_count = header_service_requests.length;
      int hhr_count = header_handling_requestoffers.length;
      int hmcr_count = header_my_closed_requestoffers.length;
      int hmtr_count = header_my_taken_requestoffers.length;
      int hmdr_count = header_my_draft_requestoffers.length;
      int hmor_count = header_my_open_requestoffers.length;
    %>

      <div class="header-button">
        <a class="button" href="my_requestoffers.jsp">
          <span>My Favors</span>
          <img src="static/img/call_bell.png"   />
          <span style="position: relative">
            <span id="status-container">
              <% if (ho_count > 0) { %>
                  <span class="favor-status"><%=ho_count%></span>
              <% } %>
              <% if (hsr_count > 0) { %>
                  <span class="favor-status"><%=hsr_count%></span>
              <% } %>
              <% if (hhr_count > 0) { %>
                  <span class="favor-status"><%=hhr_count%></span>
              <% } %>
              <% if (hmcr_count > 0) { %>
                  <span class="favor-status"><%=hmcr_count%></span>
              <% } %>
              <% if (hmtr_count > 0) { %>
                  <span class="favor-status"><%=hmtr_count%></span>
              <% } %>
              <% if (hmdr_count > 0) { %>
                  <span class="favor-status"><%=hmdr_count%></span>
              <% } %>
              <% if (hmor_count > 0) { %>
                  <span class="favor-status"><%=hmor_count%></span>
              <% } %>
            </span>
          </span>
        </a>
      </div>

      <div class="header-button">
        <a class="button" href="user.jsp?user_id=<%=logged_in_user_id%>">
          <span>
            <%=loc.get(97,"My profile")%>: 
            <%=Utils.safe_render(logged_in_user.username)%>
          </span>
          <img src="static/img/one_person.png"   />
        </a>
      </div>

      <div class="header-button">
        <a class="button" href="logout.jsp" >
          <span><%=loc.get(3, "Logout")%></span>
          <img src="static/img/exit.png"   />
        </a>
      </div>

    </div>
  </div>

</header>
