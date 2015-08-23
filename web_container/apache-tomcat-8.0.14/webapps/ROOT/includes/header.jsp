<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Others_Requestoffer" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

    <%
      int o_count = 0;
      int sr_count = 0;
      int hr_count = 0;
      int mcr_count = 0;
      int mtr_count = 0;
      int mdr_count = 0;
      int mor_count = 0;
      Requestoffer[] offers = null;
      Requestoffer_utils.Service_request[] hdr_service_requests = null;
      Others_Requestoffer[] hdr_handling_requestoffers = null;
      Requestoffer[] my_closed_requestoffers = null;
      Requestoffer[] my_taken_requestoffers = null;
      Requestoffer[] my_draft_requestoffers = null;
      Requestoffer[] my_open_requestoffers = null;
      
      Group_utils.Invite_info[] group_invites = null;
      
      if (logged_in_user_id > 0) {
        offers = 
          Requestoffer_utils
          .get_requestoffers_I_offered_to_service(logged_in_user_id);

        hdr_service_requests = 
          Requestoffer_utils
            .combine_service_requests_by_requestoffer(
              Requestoffer_utils
              .get_service_requests(logged_in_user_id));

        hdr_handling_requestoffers = 
          Requestoffer_utils.get_requestoffers_I_am_handling(logged_in_user_id);

        my_closed_requestoffers = 
          Requestoffer_utils
          .get_requestoffers_for_user_by_status(logged_in_user_id,Const.Rs.CLOSED);

        my_taken_requestoffers = 
          Requestoffer_utils
          .get_requestoffers_for_user_by_status(logged_in_user_id,Const.Rs.TAKEN);

        my_draft_requestoffers = 
          Requestoffer_utils
          .get_requestoffers_for_user_by_status(logged_in_user_id,Const.Rs.DRAFT);

        my_open_requestoffers = 
          Requestoffer_utils
          .get_requestoffers_for_user_by_status(logged_in_user_id,Const.Rs.OPEN);

        o_count = offers.length;
        sr_count = hdr_service_requests.length;
        hr_count = hdr_handling_requestoffers.length;
        mcr_count = my_closed_requestoffers.length;
        mtr_count = my_taken_requestoffers.length;
        mdr_count = my_draft_requestoffers.length;
        mor_count = my_open_requestoffers.length;
        
        group_invites = Group_utils.get_invites_for_user(logged_in_user_id);
      }
    %>
<header>
  <div class="header-table">
    <div class="header-row">

        <a 
          id="trademark" 
          class="header-button button" href="dashboard.jsp">
          <span class="text_and_image_container">
            <span class="text">Favrcafe</span>
            <span class="image" />&nbsp;</span>
          </span>
        </a>

        <a 
          id="search" 
          class="header-button button" href="advanced_search.jsp">
          <span class="text_and_image_container">
            <span class="text"><%=loc.get(1,"Search")%></span>
            <span class="image" />&nbsp;</span>
          </span>
        </a>

        <% if (logged_in_user_id > 0) { %>

          <a 
            id="request_favor" 
            class="header-button button" href="check_location_needed.jsp">
            <span class="text_and_image_container">
              <span class="text"><%=loc.get(2,"Request Favor")%></span>
              <span class="image" />&nbsp;</span>
            </span>
          </a>


          <span id="my-favors-container">
            <a 
              class="header-button button" 
              id="my-favors-anchor" 
                href="my_requestoffers.jsp">
              <span class="text_and_image_container">
                <span class="text">My Favors</span>
                <span class="image" />&nbsp;</span>
              </span>
            </a>
          </span>
          
          <a 
            id="my_profile" 
            class="header-button button " 
            href="user.jsp?user_id=<%=logged_in_user_id%>"
            <%if(group_invites.length > 0){%>
              title="You have a group invite waiting" 
            <%}%> 
            >
            <span class="text">
              <%=loc.get(97,"My profile")%>: 
              <%=Utils.safe_render(logged_in_user.username)%>
            </span>
              <% if (group_invites.length > 0) { %>
                <span style="position: relative" >
                  <img 
                    style="position: absolute;
                        height: 25px;
                        width: 25px;
                        left: -10px;
                        position: absolute;
                        top: -10px;
                      "
                    alt="group invites pending" 
                    title="group invites"
                    src="static/img/warning.png">
                </span>
              <% } %>
            <span class="image" />&nbsp;</span>
          </a>

          <a 
            id="logout" 
            class="header-button button" 
            href="logout.jsp" >

            <span class="text_and_image_container">
              <span class="text"><%=loc.get(3, "Logout")%></span>
              <span class="image" />&nbsp;</span>
            </span>
          </a>

        <% } else { %>

        <a 
          id="login" 
          class="header-button button" href="login.jsp">
          <span class="text_and_image_container">
            <span class="text"><%=loc.get(42,"Login")%></span>
            <span class="image" />&nbsp;</span>
          </span>
        </a>

        <a 
          id="register" 
          class="header-button button" href="register.jsp">
          <span class="text_and_image_container">
            <span class="text"><%=loc.get(43,"Register")%></span>
            <span class="image" />&nbsp;</span>
          </span>
        </a>


        <% } %>

        <a 
          id="help" 
          class="" href="help.jsp">
          <span class="text_and_image_container">
            <span class="text"><%=loc.get(149,"Help")%></span>
            <span class="image" />&nbsp;</span>
          </span>
        </a>

    </div>
  </div>

</header>
<script id="favor_status_script" type="text/html">
      <div id="favor-statuses">
        <div id="hdr_offering_dtls" class="digest-line">
          <span class="text_and_image_container">
            <span class="label">Offering:</span>
            <span class="value"><%=o_count%></span>
          </span>
        </div>
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
          <span class="text_and_image_container">
            <span class="label">Offers:</span>
            <span class="value"><%=sr_count%></span>
          </span>
        </div>
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
          <span class="text_and_image_container">
            <span class="label">Handling:</span>
            <span class="value"><%=hr_count%></span>
          </span>
        </div>
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
          <span class="text_and_image_container">
            <span class="label">Closed:</span>
            <span class="value"><%=mcr_count%></span>
          </span>
        </div>
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
          <span class="text_and_image_container">
            <span class="label">Taken:</span>
            <span class="value"><%=mtr_count%></span>
          </span>
        </div>
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
          <span class="text_and_image_container">
            <span class="label">Draft:</span>
            <span class="value"><%=mdr_count%></span>
          </span>
        </div>
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
          <span class="text_and_image_container">
            <span class="label">Open:</span>
            <span class="value"><%=mor_count%></span>
          </span>
        </div>
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
      <% if (logged_in_user_id > 0) { %>
        var my_favors_anchor = document.getElementById('my-favors-anchor');
        var favor_status_script = document.getElementById('favor_status_script')
        my_favors_anchor.insertAdjacentHTML(
            'afterend', favor_status_script.innerHTML);
      <% } %>
    </script>
