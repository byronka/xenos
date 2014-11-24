<%@ page import="com.renomad.qarma.Security" %>

  <% 
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    int user_id = 0;
    if ((user_id = Security.check_login(username, password)) > 0) {
      String ip_address = request.getRemoteAddr();
      Security.register_user(user_id, ip_address);
      response.addCookie(
        new Cookie("qarma_cookie", Integer.toString(user_id)));
      response.sendRedirect("dashboard.jsp");
    } else {
      response.sendRedirect("sorry.htm");
    }
  %>
