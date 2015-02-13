<%@include file="includes/init.jsp" %>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%
  String qs = request.getQueryString();
  int requestoffer_id = 
    Integer.parseInt(Utils.parse_qs(qs).get("requestoffer"));
  boolean success = 
    Requestoffer_utils.delete_requestoffer(requestoffer_id, user_id);
  if (!success) {
    response.sendRedirect("error_deleting.jsp");
    } else {
  response.sendRedirect(
    String.format(
    "requestoffer_deleted.jsp?requestoffer=%d",requestoffer_id));
    }
%>
