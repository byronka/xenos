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
      Requestoffer[] offers = 
        Requestoffer_utils
        .get_requestoffers_I_offered_to_service(logged_in_user_id);

      Requestoffer_utils.Service_request[] service_requests = 
        Requestoffer_utils.get_service_requests(logged_in_user_id);

      Others_Requestoffer[] handling_requestoffers = 
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
      int sr_count = service_requests.length;
      int hr_count = handling_requestoffers.length;
      int mcr_count = my_closed_requestoffers.length;
      int mtr_count = my_taken_requestoffers.length;
      int mdr_count = my_draft_requestoffers.length;
      int mor_count = my_open_requestoffers.length;
    %>

      <div class="header-button">
        <a id="my-favors-button" 
            class="button" 
            href="my_requestoffers.jsp">
          <span>My Favors</span>
          <img src="static/img/call_bell.png"   />
          <span style="position: relative">
              <% if (o_count > 0) { %>
                <span class="favor-status offering"><%=o_count%></span>
              <% } %>
              <% if (sr_count > 0) { %>
                <span class="favor-status offers"><%=sr_count%></span>
              <% } %>
              <% if (hr_count > 0) { %>
                <span class="favor-status handling"><%=hr_count%></span>
              <% } %>
              <% if (mcr_count > 0) { %>
                <span class="favor-status closed"><%=mcr_count%></span>
              <% } %>
              <% if (mtr_count > 0) { %>
                <span class="favor-status taken"><%=mtr_count%></span>
              <% } %>
              <% if (mdr_count > 0) { %>
                <span class="favor-status draft"><%=mdr_count%></span>
              <% } %>
              <% if (mor_count > 0) { %>
                <span class="favor-status open"><%=mor_count%></span>
              <% } %>
          </span>
        </a>
            <div id="favor-statuses">
              <div id="hdr_offering_dtls">Offering: <%=o_count%></div>
              <div class="hdr-detail-section">
                you are offering for:
                <% for (Requestoffer r : offers) { %>
                  <div>
                    <em>
                      <%=Utils.safe_render(Utils.get_trunc(r.description,20))%>
                    </em>
                  </div>
                <% } %>
              </div>
              <div id="hdr_offers_dtls">Offers: <%=sr_count%></div>
              <div class="hdr-detail-section">
                Offers exist for:
                <% for (Requestoffer_utils.Service_request r : service_requests) { %>
                  <div>
                    <em>
                      <%=Utils.safe_render(Utils.get_trunc(r.desc,20))%>
                    </em>
                  </div>
                <% } %>
              </div>
              <div id="hdr_handling_dtls">Handling: <%=hr_count%></div>
              <div class="hdr-detail-section">
                You are working on these Favors:
                <% for (Requestoffer r : handling_requestoffers) { %>
                  <div>
                    <em>
                      <%=Utils.safe_render(Utils.get_trunc(r.description,20))%>
                    </em>
                  </div>
                <% } %>
              </div>
              <div id="hdr_closed_dtls">Closed: <%=mcr_count%></div>
              <div class="hdr-detail-section">
                Your most recent closed Favors:
                <% for (Requestoffer r : my_closed_requestoffers) { %>
                  <div>
                    <em>
                      <%=Utils.safe_render(Utils.get_trunc(r.description,20))%>
                    </em>
                  </div>
                <% } %>
              </div>
              <div id="hdr_taken_dtls">Taken: <%=mtr_count%></div>
              <div class="hdr-detail-section">
                These are taken (BK: TAKEN??)
                <% for (Requestoffer r : my_taken_requestoffers) { %>
                  <div>
                    <em>
                      <%=Utils.safe_render(Utils.get_trunc(r.description,20))%>
                    </em>
                  </div>
                <% } %>
              </div>
              <div id="hdr_draft_dtls">Draft: <%=mdr_count%></div>
              <div class="hdr-detail-section">
                These are your draft Favors:
                <% for (Requestoffer r : my_draft_requestoffers) { %>
                  <div>
                    <em>
                      <%=Utils.safe_render(Utils.get_trunc(r.description,20))%>
                    </em>
                  </div>
                <% } %>
              </div>
              <div id="hdr_open_dtls">Open: <%=mor_count%></div>
              <div class="hdr-detail-section">
                These are your open Favors:
                <% for (Requestoffer r : my_open_requestoffers) { %>
                  <div>
                    <em>
                      <%=Utils.safe_render(Utils.get_trunc(r.description,20))%>
                    </em>
                  </div>
                <% } %>
              </div>
            </div>
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
