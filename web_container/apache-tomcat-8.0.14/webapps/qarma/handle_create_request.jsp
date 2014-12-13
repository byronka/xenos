<%@include file="includes/check_auth.jsp" %>
<%@ page import="com.renomad.qarma.Business_logic" %>
  <% 
    String de = request.getParameter("description");
    int s = 1; //always starts open
    String p = request.getParameter("points");
    String t = request.getParameter("title");
    String c = request.getParameter("categories");
    Business_logic.put_request(user_id, de, s, p, t, c);
    response.sendRedirect("dashboard.jsp");
  %>
