<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%
  String qs = request.getQueryString();
  int requestoffer_id = 
    Integer.parseInt(Utils.parse_qs(qs).get("requestoffer"));
  boolean success = 
    Requestoffer_utils.publish_requestoffer(requestoffer_id, user_id);
  if (!success) {
    response.sendRedirect("general_error.jsp");
    } else {
    response.sendRedirect("published.jsp");
  }
%>
