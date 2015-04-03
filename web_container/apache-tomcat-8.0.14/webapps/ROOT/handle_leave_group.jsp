<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%
    String qs = request.getQueryString();

    Integer gid = Utils.parse_int(Utils.parse_qs(qs).get("group_id"));
    if (gid == null) {
      gid = 0;
    }

    if (Group_utils.leave_group(0, gid, logged_in_user_id, false)) {
      response.sendRedirect("group.jsp?group_id="+gid);
    } else {
      response.sendRedirect("general_error.jsp");
    }

%>
