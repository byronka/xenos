<%@include file="includes/init.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Security" %>
<%

  String old_pass = "";
  String new_pass = "";
  String error_msg = "";

  if (request.getMethod().equals("POST")) {

    old_pass = request.getParameter("old_password");
    new_pass = request.getParameter("new_password");

    int uid = 0;

    boolean old_empty = old_pass.length() == 0;
    boolean new_empty = new_pass.length() == 0;
    boolean new_short = new_pass.length() < 8;

    if (old_empty && new_empty) {
      error_msg = loc.get(114, "You entered no old password or new password.  Try again.");
    } else if (old_empty && !new_empty) {
      error_msg = loc.get(115, "You provided a new password, but you need to give us your old password too.");
    } else if (!old_empty && new_empty) {
      error_msg = loc.get(116, "You forgot to give us your new password.  Try again.");
    } else if (!old_empty && new_short) {
      error_msg = loc.get(117, "Your new password is too short.  Try again.");
    }
    
    boolean success = false;
    if (error_msg.length() == 0) { // if no error
      String ip_address = request.getRemoteAddr();
      if ((uid = Security.check_login(user.username, old_pass, ip_address)) > 0) {
        success = User_utils.change_password(uid, uid, new_pass);
      } else {
        error_msg = loc.get(118, "What you gave for your old password is not valid. Try again.");
      }
    }

    if (success) {
      response.sendRedirect("password_changed.jsp");
    }


  }
%>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(113,"Change password")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>
  <h3><%=loc.get(113,"Change password")%></h3>
    <span><%=error_msg %></span>
    <form method="POST" action="change_password.jsp">
      <div>
        <%=loc.get(174,"Old password")%>: 
        <input autofocus="autofocus" type="password" name="old_password" />
      </div>
      <div>
        <%=loc.get(175,"New password")%>: 
        <input type="password" name="new_password" />
      </div>
      <button type="submit">
        <%=loc.get(113,"Change password")%>
      </button>
    </form>
  </body>
</html>
