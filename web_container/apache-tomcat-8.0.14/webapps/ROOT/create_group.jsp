<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<%
  
  if (request.getMethod().equals("POST")) {
    String group_desc = Utils.get_string_no_null(request.getParameter("group_desc"));
    String group_name = Utils.get_string_no_null(request.getParameter("group_name"));
    if (!Group_utils.create_new_group(group_name, group_desc, user_id)) {
      response.sendRedirect("general_error.jsp");
      return;
    } else {
      response.sendRedirect("user_groups.jsp");
      return;
    }
  }

%>

<html>
	<head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
    <title>Create a Group</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

	<body>
    <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
    <%@include file="includes/header.jsp" %>


    <div class="container">
      <div class="row">
        <label for="group_name">Group name</label>
        <input type="text" maxlength="50" id="group_name" name="group_name" >
      </div>
      <div class="row">
        <label for="group_desc" >Description:</label>
        <textarea id="group_desc" name="group_desc"></textarea>
      </div>
      <button type="submit" class="button">Create my new group</button>
    </div>

    <%@include file="includes/footer.jsp" %>
	</body>
</html>
