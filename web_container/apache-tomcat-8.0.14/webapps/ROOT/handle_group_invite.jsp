<%@include file="includes/securepage.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%
    String qs = request.getQueryString();

    Integer gid = Utils.parse_int(Utils.parse_qs(qs).get("group_id"));
    if (gid == null) {
      gid = 0;
    }

    boolean is_accepted = Boolean.parseBoolean(Utils.parse_qs(qs).get("is_accepted"));

    if (Group_utils.respond_to_group_invite(is_accepted, gid, logged_in_user_id)) {
      response.sendRedirect("group.jsp?group_id="+gid);
    } else {
      response.sendRedirect("general_error.jsp");
    }

%>
