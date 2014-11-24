<%@include file="includes/check_auth.jsp" %>
<%@ page import="com.renomad.qarma.Business_logic" %>
  <% 
    String de = request.getParameter("description");
    String s = request.getParameter("status");
    String p = request.getParameter("points");
    String t = request.getParameter("title");
    Business_logic.add_request(user_id, de, s, p, t);
    response.sendRedirect("dashboard.jsp");
  %>
