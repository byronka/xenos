<%@include file="includes/securepage.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Security" %>
<%

  String email_address = "";
  String email_address_confirm = "";
  String error_msg = "";

  if (request.getMethod().equals("POST")) {

    email_address = request.getParameter("email_address");
    email_address_confirm = request.getParameter("email_address_confirm");

    int uid = 0;

    boolean email_empty = email_address.length() == 0;
    boolean confirm_empty = email_address_confirm.length() == 0;
    boolean same = email_address.equals(email_address_confirm);

    if (email_empty ^ confirm_empty) {
      error_msg = "You have to enter your email in both fields";
    } else if (!same && !email_empty && !confirm_empty) {
      error_msg = "the email addresses do not match.  Try again.";
    }
    
    if (error_msg.length() == 0) { // if no error
      User_utils.Set_email_result result = User_utils.set_email(logged_in_user_id, email_address);
      if (result == User_utils.Set_email_result.OK) {
        response.sendRedirect("email_set.jsp");
      } else if (result == User_utils.Set_email_result.EXISTING_EMAIL) {
        error_msg = "you have entered an email that someone else already entered";
      } else if (result == User_utils.Set_email_result.GENERAL_ERR) {
        response.sendRedirect("general_error.jsp");
      }
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
		<title><%=loc.get(91,"Set email address")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h3><%=loc.get(91,"Set email address")%></h3>
      <span><%=error_msg %></span>
      <form method="POST" action="set_email.jsp">
          <%
            String current_email = User_utils.get_current_email(logged_in_user_id);
          %>
          <div class="row">
            Your current email address is: <%=current_email%>
          </div>
        <div class="table">
          <div class="row">
            <label for="email_address" ><%=loc.get(92,"Email address")%>: </label>
            <input id="email_address" autofocus="autofocus" type="email" name="email_address" />
          </div>
          <div class="row">
            <label for="email_address_confirm"><%=loc.get(95,"Confirm")%>: </label>
            <input id="email_address_confirm" type="email" name="email_address_confirm" />
          </div>
        </div>
        <div class="table">
          <div class="row">
            <button class="button" type="submit">
              <%=loc.get(91,"Set email address")%>
            </button>
            <a class="button" href="user.jsp?user_id=<%=logged_in_user_id%>"><%=loc.get(130,"Cancel")%></a>
          </div>
        </div>
      </form>
    </div>

    <%@include file="includes/footer.jsp" %>
  </body>
</html>
