<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>                                 
  <head><title><%=loc.get(41, "Error deleting Request")%></title></head>

<%@ page import="com.renomad.xenos.Request_utils" %>
<%@ page import="com.renomad.xenos.Request" %>
<body>

  <h2><%=loc.get(41,"Error deleting request")%></h2>
  <p><a href="dashboard.jsp"><%=loc.get(35,"Dashboard")%></a></p>

</body>
</html>
