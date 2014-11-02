<%@ page import="com.renomad.qarma.Tester" %>
<html>
<head><title>First JSP</title></head>
<body>
  <%
    String blah = Tester.cool();
  %>
<p>
  We are sooo, <%=blah%> today!

</p>
</body>
</html>
