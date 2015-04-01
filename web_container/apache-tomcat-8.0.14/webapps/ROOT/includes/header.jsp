<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header>
  <a class="trademark" href="dashboard.jsp">Zenia</a>
  <a href="logout.jsp" >
    <%=loc.get(3, "Logout")%>
  </a>
  <form class="search" method="GET" action="dashboard.jsp" >
    <input type="text" name="desc" maxlength="20" />
    <button type="submit"><%=loc.get(1, "search")%></button>
  </form>
</header>
