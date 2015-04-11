<%@include file="includes/init.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.renomad.xenos.Security" %>
<%
   String icode = Security.generate_invite_code(logged_in_user_id);
%>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <script type="text/javascript" src="static/js/utils.js"></script>
		<title><%=loc.get(206,"Generate invitation code")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
    <img id='my_background' src="static/img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
    <%@include file="includes/header.jsp" %>
    <div class="container">
      <h3><%=loc.get(207, "Here is an invitation code.  It is valid for a week")%></h3>
      <p>
        <em>
          <%=loc.get(20,"Copy the following text and send it to whoever you are inviting to the system")%>
        </em>
      </p>

      <p>
      
      <p><%=loc.get(23,"Hi! Join me and my friends on a system that encourages trading of favors, at")%></p>
      <p><code>https://zenia.co/register.jsp?icode=<%=icode%></code></p>
      
      
      </p>
    </div>
    <%@include file="includes/footer.jsp" %>
  </body>
</html>
