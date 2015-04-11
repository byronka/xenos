<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<%
  
  request.setCharacterEncoding("UTF-8");

  boolean has_name_validation_error = false;
  String group_desc = "";
  String group_name = "";

  if (request.getMethod().equals("POST")) {
    group_desc = Utils.get_string_no_null(request.getParameter("group_desc"));
    group_name = Utils.get_string_no_null(request.getParameter("group_name"));
    if (group_name.equals("")) {
      has_name_validation_error = true;
    }

    if (!has_name_validation_error) {
      Group_utils.Create_group_result result = Group_utils.create_new_group(group_name, group_desc, logged_in_user_id);

      switch (result) {
        case GENERAL_ERR:
          response.sendRedirect("general_error.jsp");
          return;
        case EMPTY_NAME:
          has_name_validation_error = true;
          break;
        case OK:
        // fall through
        default:
          response.sendRedirect("user_groups.jsp");
          return;
      }
    }

  }

%>

<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <title>Create a Group</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

	<body>
    <%@include file="includes/header.jsp" %>


    <div class="container">

      <form method="POST" action="create_group.jsp">
        <div class="table">
          <div class="row">
            <label for="group_name">* <%=loc.get(53,"Group name")%></label>
            <input type="text" maxlength="50" id="group_name" name="group_name" >
            <% if (has_name_validation_error) { %>
            <div class="error"><%=loc.get(54,"A name is required for this group")%></div>
            <% } %>
          </div>
          <div class="row">
            <label for="group_desc" ><%=loc.get(10,"Description")%>:</label>
            <textarea id="group_desc" name="group_desc" ><%=Utils.safe_render(group_desc)%></textarea>
          </div>
        </div>
        <div class="table">
          <div class="row">
            <button type="submit" class="button"><%=loc.get(55,"Create my new group")%></button>
          </div>
        </div>
      </form>
    </div>

    <%@include file="includes/footer.jsp" %>
	</body>
</html>
