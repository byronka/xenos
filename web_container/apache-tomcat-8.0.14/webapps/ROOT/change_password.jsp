<%@include file="includes/securepage.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Security" %>
<%

  String old_pass = "";
  String new_pass = "";
  String confirm_pass = "";
  String error_msg = "";

  if (request.getMethod().equals("POST")) {

    old_pass = request.getParameter("old_password");
    new_pass = request.getParameter("new_password");
    confirm_pass = request.getParameter("confirm_new_password");

    int uid = 0;

    boolean old_empty = old_pass.length() == 0;
    boolean new_empty = new_pass.length() == 0;
    boolean confirm_empty = confirm_pass.length() == 0;
    boolean new_short = new_pass.length() < 8;

    if (old_empty && new_empty) {
      error_msg = loc.get(114, "You entered no old password or new password.  Try again.");
    } else if (old_empty && !new_empty) {
      error_msg = loc.get(115, "You provided a new password, but you need to give us your old password too.");
    } else if (!old_empty && new_empty) {
      error_msg = loc.get(116, "You forgot to give us your new password.  Try again.");
    } else if (!old_empty && new_short) {
      error_msg = loc.get(117, "Your new password is too short.  Try again.");
    } else if (!old_empty && !new_short && confirm_empty) {
      error_msg = loc.get(150, "You did not confirm your new password.  Try again.");
    }
    
    boolean success = false;
    if (error_msg.length() == 0) { // if no error
      String ip_address = Utils.get_remote_address(request);
      if ((uid = Security.check_login(logged_in_user.username, old_pass, ip_address)) > 0) {
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
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title><%=loc.get(113,"Change password")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h3><%=loc.get(113,"Change password")%></h3>
      <span><%=error_msg %></span>
      <form method="POST" action="change_password.jsp">
        <div class="table">
          <div class="row">
            <label for="password" ><%=loc.get(174,"Old password")%>: </label>
            <input id="password" autofocus="autofocus" type="password" name="old_password" />
          </div>
          <div class="row">
            <label for="new_password"><%=loc.get(175,"New password")%>: </label>
            <input id="new_password" type="password" name="new_password" />
          </div>
          <div class="row">
            <label for="confirm_new_password"><%=loc.get(89,"Confirm password")%>: </label>
            <input id="confirm_new_password" type="password" name="confirm_new_password" />
          </div>
        </div>
        <div class="table">
          <div class="row">
            <button class="button" type="submit">
              <%=loc.get(113,"Change password")%>
            </button>
            <a class="button" href="user.jsp?user_id=<%=logged_in_user_id%>"><%=loc.get(130,"Cancel")%></a>
          </div>
        </div>
      </form>
    </div>

    <%@include file="includes/footer.jsp" %>
  </body>
</html>
