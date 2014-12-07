<%@ page import="com.renomad.qarma.Business_logic" %>
  <% 
    String first_name = request.getParameter("first_name");
    String last_name = request.getParameter("last_name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    Business_logic.add_user(first_name, last_name, email, password);
    response.sendRedirect("thanks.htm");
  %>
