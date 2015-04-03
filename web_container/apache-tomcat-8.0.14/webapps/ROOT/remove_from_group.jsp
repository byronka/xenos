<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%
    String qs = request.getQueryString();

    Integer gid = Utils.parse_int(Utils.parse_qs(qs).get("group_id"));
    if (gid == null) {
      gid = 0;
    }

    Integer uid = Utils.parse_int(Utils.parse_qs(qs).get("user_id"));
    if (gid == null) {
      uid = 0;
    }

    if (Group_utils.remove_from_group(logged_in_user_id, gid, uid)) {
      response.sendRedirect("group.jsp?group_id="+gid);
    } else {
      response.sendRedirect("general_error.jsp");
    }

%>
