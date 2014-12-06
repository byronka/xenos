<%@include file="includes/check_auth.jsp" %>

<html>                                 
  <head><title>Create a request page</title></head>
  <body>
    <%@include file="includes/header.jsp" %>
    <h2>Create a Request!</h2>
    <form method="POST" action="handle_create_request.jsp">
      <p>Description: <input type="text" name="description" /> </p>
      <p>Status: <input type="text" name="status" /> </p>
			<p>Points: <input type="text" name="points" /> </p>
      <p>Title: <input type="text" name="title" /> </p>
      <button type="submit">Create Request</button>
    </form>
  </body>
</html>
