<%@include file="includes/check_auth.jsp" %>
<%@ page import="com.renomad.qarma.Business_logic" %>
  <% 
    String de = request.getParameter("description");
    int s = 1; //always starts open
    String p = request.getParameter("points");
    String t = request.getParameter("title");
    Business_logic.add_request(user_id, de, s, p, t);
    response.sendRedirect("dashboard.jsp");
  %>
