<%@ page import="com.renomad.qarma.Tester" %>
<html>
<head><title>First JSP</title></head>
<body>

  <% 
    String[] values = Tester.cool(); 
    String name = request.getParameter("nametext");
    Tester.add_user(name);
  %>
  <% for (String blah : values) { %>
    <div style="background-color: black;color: white;">
      <p>
        We are sooo, <%=blah%> today!
      </p>
    </div>
  <% } %>
  <form id="enter_name_form" action="thanks.jsp" method="post">
    <p>
      Enter your name:
      <input name="nametext" type="text" id="nametext" />
    </p>
    <button form="enter_name_form" >Click me!</button>
  </form>
</body>
</html>
