
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="header-container">
  <link rel="stylesheet" type="text/css" href="includes/header.css">
  <div class="spacer" ></div>
<section class="header">
  <nav class="cl-effect-1">
    <a class="trademark" href="dashboard.jsp">Xenos</a>
    <a href="create_request.jsp" ><%=loc.get(2, "Create Request")%></a>
    <a href="logout.jsp" ><%=loc.get(3, "Logout")%></a>
  </nav>
  <form class="search" method="GET" action="dashboard.jsp" >
    <span><input type="text" name="search" maxlength="20" />
      <button><%=loc.get(1, "search")%></button></span>
  </form>
  <div class="user-displayname">
    <span id="username"><%=Utils.safe_render(user.username)%></span>
    <span id="points"><%=user.points%> <%=loc.get(11, "points")%></span>
  </div>
  <a class="advanced search" href="advanced_search.jsp"><%=loc.get(81,"Advanced search")%></a>
</section>
</div>
