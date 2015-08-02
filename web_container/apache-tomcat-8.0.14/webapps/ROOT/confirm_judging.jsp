<%@include file="includes/securepage.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <title>Confirm Ranking</title>	
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
  <%
    boolean is_satisfied = 
      Boolean.parseBoolean(request.getParameter("is_satis"));
    int urdp_id = Utils.parse_int(request.getParameter("urdp_id"));
    String comment = request.getParameter("is_satis_comment");
  %>
  <body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
  <p>
  <%=is_satisfied ? "You indicated you were pleased" : "You were displeased"%>
  </p>

  <% if (Utils.is_null_or_empty(comment)) { %>
    <p><em>No comment entered</em></p>
  <% } else { %>
    <p>
      Your comment was: <%=comment%>
    </p>
  <% } %>
  <form method="POST" action="judged.jsp" >
    <input type="hidden" name="is_satis" value="<%=is_satisfied%>" />
    <input type="hidden" name="urdp_id" value="<%=urdp_id%>" />
    <input type="hidden" name="is_satis_comment" value="<%=comment%>" />
    <div class="table">
      <div class="row">
        <button id="submitbutton" class="button" type="submit">Click to continue</button>
        <a class="button" href="judge.jsp?urdp=<%=urdp_id%>">Redo</a>
      </div>
    </div>
    </div>
  </form>
  <%@include file="includes/footer.jsp" %>
  </body>
</html>
