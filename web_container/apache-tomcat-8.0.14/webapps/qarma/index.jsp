<%@ page import="com.renomad.qarma.Tester" %>
<html>
<head><title>First JSP</title></head>
<body>
  <% String[] values = Tester.cool(); %>
  <% for (String blah : values) { %>
    <div style="background-color: black;color: white;">
      <p>
        We are sooo, <%=blah%> today!
      </p>
    </div>
  <% } %>
</body>
</html>
