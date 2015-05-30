<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Others_Requestoffer" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%
      Requestoffer[] offers = 
        Requestoffer_utils
        .get_requestoffers_I_offered_to_service(logged_in_user_id);

      Requestoffer_utils.Service_request[] hdr_service_requests = 
        Requestoffer_utils.get_service_requests(logged_in_user_id);

      Others_Requestoffer[] hdr_handling_requestoffers = 
        Requestoffer_utils.get_requestoffers_I_am_handling(logged_in_user_id);

      Requestoffer[] my_closed_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,Const.Rs.CLOSED);

      Requestoffer[] my_taken_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,Const.Rs.TAKEN);

      Requestoffer[] my_draft_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,Const.Rs.DRAFT);

      Requestoffer[] my_open_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(logged_in_user_id,Const.Rs.OPEN);

      int o_count = offers.length;
      int sr_count = hdr_service_requests.length;
      int hr_count = hdr_handling_requestoffers.length;
      int mcr_count = my_closed_requestoffers.length;
      int mtr_count = my_taken_requestoffers.length;
      int mdr_count = my_draft_requestoffers.length;
      int mor_count = my_open_requestoffers.length;
    %>
<header>
  <div class="header-table">
    <div class="header-row">

        <a 
          id="trademark" 
          class="header-button" href="dashboard.jsp">
          <span class="text">sayaye</span>
          <span class="image" />
        </a>

        <a 
          id="search" 
          class="header-button button" href="advanced_search.jsp">
          <span class="text"><%=loc.get(1,"Search")%></span>
          <span class="image" />
        </a>

        <a 
          id="request_favor" 
          class="header-button button" href="check_location_needed.jsp">
          <span class="text"><%=loc.get(2,"Request Favor")%></span>
          <span class="image" />
        </a>


        <span id="my-favors-container">
          <a 
            class="header-button button" 
            id="my-favors-anchor" 
              href="my_requestoffers.jsp">
            <span class="text">My Favors</span>
            <span class="image" />
          </a>
        </span>
        
        <a 
          id="my_profile" 
          class="header-button button" 
          href="user.jsp?user_id=<%=logged_in_user_id%>">
          <span class="text">
            <%=loc.get(97,"My profile")%>: 
            <%=Utils.safe_render(logged_in_user.username)%>
          </span>
          <span class="image" />
        </a>

        <a 
          id="logout" 
          class="header-button button" 
          href="logout.jsp" >
          <span class="text"><%=loc.get(3, "Logout")%></span>
          <span class="image" />
        </a>

    </div>
  </div>

</header>
<script id="favor_status_script" type="text/html">
      <div id="favor-statuses">
        <div id="hdr_offering_dtls" class="digest-line">
          Offering: <%=o_count%></div>
        <div class="hdr-detail-section">
          you are offering for:
          <% if (o_count == 0) { %>None<% } else {%>
            <% for (Requestoffer r : offers) { %>
              <div>
                <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <span class="desc container" > 
                    <%=Utils.safe_render(r.description)%>
                   </span> 
                </a>
              </div>
            <% } %>
          <% } %>
        </div>
        <div id="hdr_offers_dtls" class="digest-line">
          Offers: <%=sr_count%></div>
        <div class="hdr-detail-section">
          Offers exist for:
          <% if (sr_count == 0) { %>None<% } else {%>
            <% for (Requestoffer_utils.Service_request r : hdr_service_requests) { %>
              <div>
                <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <span class="desc container" > 
                    <%=Utils.safe_render(r.desc)%>
                   </span> 
                </a>
              </div>
            <% } %>
          <% } %>
        </div>
        <div id="hdr_handling_dtls" class="digest-line">
          Handling: <%=hr_count%></div>
        <div class="hdr-detail-section">
          You are working on these Favors:
          <% if (hr_count == 0) { %>None<% } else {%>
            <% for (Requestoffer r : hdr_handling_requestoffers) { %>
              <div>
                <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <span class="desc container" > 
                    <%=Utils.safe_render(r.description)%>
                   </span> 
                </a>
              </div>
            <% } %>
          <% } %>
        </div>
        <div id="hdr_closed_dtls" class="digest-line">
          Closed: <%=mcr_count%></div>
        <div class="hdr-detail-section">
          Your most recent closed Favors:
          <% if (mcr_count == 0) { %>None<% } else {%>
            <% for (Requestoffer r : my_closed_requestoffers) { %>
              <div>
                <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <span class="desc container" > 
                    <%=Utils.safe_render(r.description)%>
                   </span> 
                </a>
              </div>
            <% } %>
          <% } %>
        </div>
        <div id="hdr_taken_dtls" class="digest-line">
          Taken: <%=mtr_count%></div>
        <div class="hdr-detail-section">
          Your Favors being handled:
          <% if (mtr_count == 0) { %>None<% } else {%>
            <% for (Requestoffer r : my_taken_requestoffers) { %>
              <div>
                <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <span class="desc container" > 
                    <%=Utils.safe_render(r.description)%>
                   </span> 
                </a>
              </div>
            <% } %>
          <% } %>
        </div>
        <div id="hdr_draft_dtls" class="digest-line">
          Draft: <%=mdr_count%></div>
        <div class="hdr-detail-section">
          These are your draft Favors:
          <% if (mdr_count == 0) { %>None<% } else {%>
            <% for (Requestoffer r : my_draft_requestoffers) { %>
              <div>
                <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <span class="desc container" > 
                    <%=Utils.safe_render(r.description)%>
                   </span> 
                </a>
              </div>
            <% } %>
          <% } %>
        </div>
        <div id="hdr_open_dtls" class="digest-line">
          Open: <%=mor_count%></div>
        <div class="hdr-detail-section">
          These are your open Favors:
          <% if (mor_count == 0) { %>None<% } else {%>
            <% for (Requestoffer r : my_open_requestoffers) { %>
              <div>
                <a class="requestoffer" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
                  <span class="desc container" > 
                    <%=Utils.safe_render(r.description)%>
                   </span> 
                </a>
              </div>
            <% } %>
          <% } %>
        </div>
      </div>
      <div id="status-digest" >
        <span class="favor-status offering"><%=o_count%></span>
        <span class="favor-status offers"><%=sr_count%></span>
        <span class="favor-status handling"><%=hr_count%></span>
        <span class="favor-status closed"><%=mcr_count%></span>
        <span class="favor-status taken"><%=mtr_count%></span>
        <span class="favor-status draft"><%=mdr_count%></span>
        <span class="favor-status open"><%=mor_count%></span>
      </div>
    </script>
    <script>
      var my_favors_anchor = document.getElementById('my-favors-anchor');
      var favor_status_script = document.getElementById('favor_status_script')
      my_favors_anchor.insertAdjacentHTML(
          'afterend', favor_status_script.innerHTML);
    </script>
