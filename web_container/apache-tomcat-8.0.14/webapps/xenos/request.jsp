<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
<head><title><%=loc.get(22,"Request Details")%></title></head>

<%@ page import="com.renomad.xenos.Request_utils" %>
<%@ page import="com.renomad.xenos.Request" %>
<%
  String qs = request.getQueryString();
  Request r = Request_utils.parse_querystring_and_get_request(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
  boolean is_requesting_user = user_id == r.requesting_user_id;
  boolean is_servicing = qs.indexOf("service=true") > 0;
  boolean is_deleting = qs.indexOf("delete=true") > 0;

  boolean show_handle_button = 
    !is_requesting_user && !is_servicing && !is_deleting;
  boolean show_delete_info = 
      is_requesting_user && is_deleting;
  boolean show_message_input = 
      !is_requesting_user && is_servicing && !is_deleting;

  //handle bad scenarios
  if (is_requesting_user && is_servicing ||
      !is_requesting_user && is_deleting) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  String msg = request.getParameter("message");

  if (msg != null && msg != "") {
    Request_utils.set_message(msg, r.request_id, user_id);
    response.sendRedirect(
      "request.jsp?request="+r.request_id+"&service=true");
    return;
  }

%>
<body>
  <%@include file="includes/header.jsp" %>
  <p><%=loc.get(23,"Description")%>: <%=Utils.safe_render(r.description)%>
  <p><%=loc.get(24,"Status")%>: 
    <%=loc.get(Request_utils.get_status_localization_value(r.status),"")%>
  <p><%=loc.get(25,"Date")%>: <%=r.datetime%>
  <p><%=loc.get(26,"Points")%>: <%=r.points%>
  <p><%=loc.get(27,"Title")%>: <%=Utils.safe_render(r.title)%>
  <p><%=loc.get(28,"Categories")%>: 
      <%for (Integer c : r.get_categories()) {%>
        <span class="category"><%=loc.get(c,"")%> </span>
      <%}%>
  </p>
  <%
  if (show_delete_info) {%>

    <p>
      <%=loc.get(39,"Are you sure you want to delete this request?")%> <%=r.points%> <%=loc.get(39,"points will be refunded to you")%>
       
    </p>

    <p>
      <a href="delete_request.jsp?request=<%=r.request_id%>"><%=loc.get(29, "Yes, delete!")%></a>
    </p>
    <p>
      <a href="dashboard.jsp"><%=loc.get(30,"Nevermind, do not delete it")%></a>
    </p>

    <%} if (show_handle_button) {%>

      <a href="request.jsp?request=<%=r.request_id%>&service=true">
        <%=loc.get(37,"Handle")%>
      </a>

      <%}
      String[] messages = Request_utils.get_messages(r.request_id);
       for (String m : messages) { %>

      <p><%=Utils.safe_render(m)%></p>

      <%} if (show_message_input) { %>
    <form method="POST" action="request.jsp?request=<%=r.request_id%>&service=true">
      <p><%=loc.get(38,"Message (up to 10,000 characters)")%></p>
      <input type="text" name="message" maxlength="10000" />
      <button type="submit"><%=loc.get(36,"Send message")%></button>
    </form>
  <% } %>

</body>
</html>
