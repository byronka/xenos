<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
    <title>Edit my group description</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%
  if (request.getMethod().equals("POST")) {
    String the_user_desc = Utils.get_string_no_null(request.getParameter("user_description"));
    Integer the_group_id = Utils.parse_int(request.getParameter("group_id"));
    if (!Group_utils.edit_user_group_description(the_group_id, logged_in_user_id, the_user_desc)) {
      response.sendRedirect("general_error.jsp");
      return;
    } else {
      response.sendRedirect("group.jsp?group_id="+the_group_id);
      return;
    }
  }

  String qs = request.getQueryString();
  Integer the_group_id = Utils.parse_int(Utils.parse_qs(qs).get("group_id"));

%>
	<body>
  <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>

  <div class="container">

    <h3>Your description as seen by others in your group</h3>
        <form method="POST" action="edit_group_description.jsp">
          <input type="hidden" name="group_id" id="group_id" value="<%=the_group_id%>">
          <textarea 
            id="user_description" 
            name="user_description" 
            maxlength="500"
            ><%=Utils.safe_render(Group_utils.get_user_group_description(the_group_id, logged_in_user_id))%></textarea>
          <div class="row">
            <button class="button" type="submit" >Save description</button>
            <a class="button" href="group.jsp?group_id=<%=the_group_id%>" >
              Cancel
            </a>
          </div>
        </form>

  </div>
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
