<%@include file="includes/securepage.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <title>Edit my group description</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%
  request.setCharacterEncoding("UTF-8");
  if (request.getMethod().equals("POST")) {
    String the_group_desc = Utils.get_string_no_null(request.getParameter("group_description"));
    Integer the_group_id = Utils.parse_int(request.getParameter("group_id"));
    if (!Group_utils.edit_group_description(the_group_id, the_group_desc)) {
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
  <%@include file="includes/header.jsp" %>

  <div class="container">

    <h3><%=loc.get(90,"Your group's description")%></h3>
        <form method="POST" action="edit_group_description.jsp">
          <input type="hidden" name="group_id" id="group_id" value="<%=the_group_id%>">
          <div class="table">
            <div class="row">
              <textarea 
                id="group_description" 
                name="group_description" 
                maxlength="500"
                ><%=Utils.safe_render(Group_utils.get_group_description(the_group_id))%></textarea>
            </div>
          </div>
          <div class="table">
            <div class="row">
              <button class="button" type="submit" ><%=loc.get(72,"Save description")%></button>
              <a class="button" href="group.jsp?group_id=<%=the_group_id%>" >
                <%=loc.get(130,"Cancel")%>
              </a>
            </div>
          </div>
        </form>

  </div>
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
