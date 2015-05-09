<%@ page import="com.renomad.xenos.Group_utils" %>
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
        <a class="button" href="select_country.jsp?usecase=2">
          <span><%=loc.get(7,"Current location")%>
          <%
          String user_postcode = 
            Utils.is_null_or_empty(logged_in_user.postal_code) ? "none" : logged_in_user.postal_code; %>
          <%=Utils.safe_render(user_postcode)%>
          </span>
          <img src="static/img/world_icon.png"   />
        </a>
      </div>
      <div class="header-button">
        <a class="button" href="change_password.jsp">
          <span><%=loc.get(113,"Change password")%></span>
          <img src="static/img/password.png"   />
        </a>
      </div>
      <%
       Group_utils.Invite_info[] iis = Group_utils.get_invites_for_user(logged_in_user_id);
      %>
      <div class="header-button">
        <a class="button" href="user_groups.jsp">
          <span><%=loc.get(8,"Your groups")%></span>
          <img src="static/img/group.png"   />
          <span style="position: relative">
          <% if (iis.length > 0) { %>
            <span id="count-of-invites"><%=iis.length%></span>
          <% } %>
          </span>
        </a>
      </div>
    </div>
    <div class="header-row">
      <div class="header-button">
        <a class="button" href="create_requestoffer.jsp">
          <span><%=loc.get(2,"Request Favor")%></span>
          <img src="static/img/call_bell.png"   />
        </a>
      </div>
      <div class="header-button">
        <a class="button" href="select_country.jsp?usecase=1">
          <span><%=loc.get(14,"Request Favor with location")%></span>
          <img src="static/img/request_with_location.png"   />
        </a>
      </div>
      <div class="header-button">
        <a class="button" href="generate_icode.jsp">
          <span><%=loc.get(206,"Generate invitation code")%></span>
          <img src="static/img/invitation.png"   />
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
