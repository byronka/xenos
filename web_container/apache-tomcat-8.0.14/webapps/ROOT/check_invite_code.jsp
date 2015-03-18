<%@include file="includes/mobile_check.jsp" %>
<%@ page import="com.renomad.xenos.Security" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Localization" %>
<%
  //check if they are already logged in.  If so, just skip to
  //dashboard.  it just checks the user cookie to see if we are good
  //to go.  It doesn't use username and password.
  int user_id = Security.check_if_allowed(request,true);
	if (user_id > 0) { 
    response.sendRedirect("dashboard.jsp"); 
	} else {
    // just in case, if they have a cookie for us at all, clear it.
    Cookie cookie = new Cookie("xenos_cookie", "");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
	}


  //set up an object to localize text
  Localization loc  = new Localization(request.getLocale());

  //get the values straight from the client
  String icode = "";
  boolean validation_error = false;

  //we'll put error messages here if validation errors occur
  String icode_error_msg = "";  //invalid or empty invite_code

  if (request.getMethod().equals("POST")) {

    icode = request.getParameter("icode"); // get the invite code
    if (Utils.is_null_or_empty(icode)) {
      validation_error = true;
      icode_error_msg = loc.get(205, "An invitation code is required for registration");
    }

    if (!validation_error) {
      // if we are given an invite code, check that it's good, otherwise error message
      if (Security.is_valid_invite_code(icode)) {
        response.sendRedirect("register.jsp?icode=" + icode);
        return;
      } else {
        icode_error_msg = loc.get(201, "Invalid invite code");
      }
    }

  }
%>
<!DOCTYPE html>
<html>
  <div id="covering_screen"></div>
  <head>
  <title><%=loc.get(202,"Check invite code")%></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="register.css" title="desktop">
		<% } %>
  </head>
<body>
  <div class="trademark cl-effect-1"><a href="index.jsp">Xenos</a></div>
  <div class="register">
    <form id="enter_name_form" action="check_invite_code.jsp" method="post">

      <div class="invite-code">
        <div class="label"><%=loc.get(203 ,"Invitation code")%>:</div> 
        <input type="text" name="icode" value="<%=icode%>" >
        <span class="error"><%=icode_error_msg%></span>
      </div>

			<div id="button-wrapper">
				<button type="submit">
					<%=loc.get(204,"Submit invitation code")%>
				</button>
			</div>

    </form>

  </div>
</body>
<script>
  window.onload = function() {
      var covering_screen = document.getElementById('covering_screen');
      covering_screen.style.opacity = 1; 
      var fade = function() {
        if ((covering_screen.style.opacity -=.1) > 0) { 
          setTimeout(fade,20);
        }
      };
      fade(); //kick it off.
    };
</script>
</html>
