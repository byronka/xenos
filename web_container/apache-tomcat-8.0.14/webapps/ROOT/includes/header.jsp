<%@ page import="com.renomad.xenos.Group_utils" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header>
  <a class="trademark" href="dashboard.jsp">Zenia</a>
  <form class="search" method="GET" action="dashboard.jsp" >
    <input type="text" name="desc" maxlength="20" />
    <button class="button" type="submit">
      <%=loc.get(1, "search")%>
      <img src="static/img/search.png" width="12px" height="12px"/>
    </button>
  </form>
  <a class="button" href="advanced_search.jsp">
    <span><%=loc.get(81,"Advanced search")%></span>
    <img src="static/img/search.png" width="12px" height="12px"/>
  </a>
  <a class="button" href="select_country.jsp?usecase=2">
    <span><%=loc.get(7,"Current location")%>
    <%
    String user_postcode = 
      Utils.is_null_or_empty(logged_in_user.postal_code) ? "none" : logged_in_user.postal_code; %>
    <%=Utils.safe_render(user_postcode)%>
    </span>
    <img src="static/img/world_icon.png" height="12px" width="12px" />
  </a>
  <a class="button" href="change_password.jsp">
    <span><%=loc.get(113,"Change password")%></span>
    <img src="static/img/password.png" height="12px" width="12px" />
  </a>
  <a class="button" href="user_groups.jsp">
    <span><%=loc.get(8,"Your groups")%></span>
    <img src="static/img/group.png" height="12px" width="12px" />
  </a>
  <a class="button" href="create_requestoffer.jsp">
    <span><%=loc.get(2,"Request Favor")%></span>
    <img src="static/img/call_bell.png" height="12px" width="12px" />
  </a>
  <a class="button" href="select_country.jsp?usecase=1">
    <span><%=loc.get(14,"Request favor with location")%></span>
    <img src="static/img/call_bell.png" height="12px" width="12px" />
  </a>
  <%
   Group_utils.Invite_info[] iis = Group_utils.get_invites_for_user(logged_in_user_id);
  %>

  <% if (iis.length > 0) { %>
    <p>
      <em>
        Your invites to groups:
      </em>
    </p>

    <% for (Group_utils.Invite_info ii : iis ) { %>
    <a href="group.jsp?group_id=<%=ii.group_id%>"><%=Utils.safe_render(ii.groupname)%></a>
    <% } %>

  <% } %>

  <a class="button" href="generate_icode.jsp">
    <span><%=loc.get(206,"Generate invitation code")%></span>
    <img src="static/img/world_icon.png" height="12px" width="12px" />
  </a>
  <a class="button" href="user.jsp?user_id=<%=logged_in_user_id%>">
    <%=loc.get(97,"My profile")%>: 
    <%=Utils.safe_render(logged_in_user.username)%>
  </a>
  <a class="button" href="logout.jsp" >
    <span><%=loc.get(3, "Logout")%></span>
    <img src="static/img/exit.png" height="12px" width="12px" />
  </a>

</header>
