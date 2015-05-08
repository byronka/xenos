<%@ page import="com.renomad.xenos.Group_utils" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header>
  <a style="float: left;" class="trademark" href="dashboard.jsp">Zenia</a>
  <div>
    <div class="header-row">
      <form class="search" method="GET" action="dashboard.jsp" >
        <input type="text" name="desc" maxlength="20" />
        <button class="button header-button" type="submit">
          <span><%=loc.get(1, "search")%></span>
          <img src="static/img/search.png"  />
        </button>
      </form>
      <a class="button header-button" href="advanced_search.jsp">
        <span><%=loc.get(81,"Advanced search")%></span>
        <img src="static/img/search_advanced.png"  />
      </a>
      <a class="button header-button" href="select_country.jsp?usecase=2">
        <span><%=loc.get(7,"Current location")%>
        <%
        String user_postcode = 
          Utils.is_null_or_empty(logged_in_user.postal_code) ? "none" : logged_in_user.postal_code; %>
        <%=Utils.safe_render(user_postcode)%>
        </span>
        <img src="static/img/world_icon.png"   />
      </a>
      <a class="button header-button" href="change_password.jsp">
        <span><%=loc.get(113,"Change password")%></span>
        <img src="static/img/password.png"   />
      </a>
      <%
       Group_utils.Invite_info[] iis = Group_utils.get_invites_for_user(logged_in_user_id);
      %>
      <a class="button header-button" href="user_groups.jsp">
        <span><%=loc.get(8,"Your groups")%></span>
        <img src="static/img/group.png"   />
        <span style="position: relative">
        <% if (iis.length > 0) { %>
          <span id="count-of-invites"><%=iis.length%></span>
        <% } %>
        </span>
      </a>
    </div>
    <div style="height: 20px;" class="header-row">
      &nbsp;
    </div>
    <div class="header-row">
      <a class="button header-button" href="create_requestoffer.jsp">
        <span><%=loc.get(2,"Request Favor")%></span>
        <img src="static/img/call_bell.png"   />
      </a>
      <a class="button header-button" href="select_country.jsp?usecase=1">
        <span><%=loc.get(14,"Request Favor with location")%></span>
        <img src="static/img/request_with_location.png"   />
      </a>
      <a class="button header-button" href="generate_icode.jsp">
        <span><%=loc.get(206,"Generate invitation code")%></span>
        <img src="static/img/invitation.png"   />
      </a>
      <a class="button header-button" href="user.jsp?user_id=<%=logged_in_user_id%>">
        <span>
          <%=loc.get(97,"My profile")%>: 
          <%=Utils.safe_render(logged_in_user.username)%>
        </span>
        <img src="static/img/one_person.png"   />
      </a>
      <a class="button header-button" href="logout.jsp" >
        <span><%=loc.get(3, "Logout")%></span>
        <img src="static/img/exit.png"   />
      </a>
    </div>
    <div style="height: 50px;" class="header-row">
      &nbsp;
    </div>
  </div>

</header>
