<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(22,"Requestoffer Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%
  String qs = request.getQueryString();
  Requestoffer r = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
  boolean is_requestoffering_user = user_id == r.requestoffering_user_id;
  boolean is_handling_user = user_id == r.handling_user_id;
  boolean is_deleting = qs.indexOf("delete=true") > 0;

  boolean show_handle_button = 
    (r.status == 76) && //'open'
    !is_requestoffering_user && 
    !is_deleting;
  boolean show_delete_info = 
      is_requestoffering_user && is_deleting;
  boolean show_message_input = 
      (is_requestoffering_user || is_handling_user) && r.status == 78 && !is_deleting;

  //handle bad scenarios
  if (!is_requestoffering_user && is_deleting) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  String msg = request.getParameter("message");

  if (!Utils.is_null_or_empty(msg)) {
    Requestoffer_utils.set_message(msg, r.requestoffer_id, user_id);
    response.sendRedirect(
      "requestoffer.jsp?requestoffer="+r.requestoffer_id+"&service=true");
    return;
  }

%>
<body>
  <%@include file="includes/header.jsp" %>
  <p>
    <%=loc.get(23,"Description")%>: <%=Utils.safe_render(r.description)%>
  </p>
  <p>
    <%=loc.get(24,"Status")%>: 
    <%=loc.get(r.status,"")%>
  </p>
  <p>
    <%=loc.get(25,"Date")%>: <%=r.datetime%>
  </p>
  <p>
    <%=loc.get(100,"Owning User")%>: 
    <%if(is_requestoffering_user) {%><em>You</em>, <%}%>
    <%=User_utils.get_user(r.requestoffering_user_id).username%>
  </p>
  <p>
    <%=loc.get(101,"Handling User")%>: 
    <%if(is_handling_user) {%><em>You</em>, <%}%>
    <% User handleuser = User_utils.get_user(r.handling_user_id); 
    if (handleuser != null) {%>
      <%=handleuser.username%>
    <%} else {%>
      none
    <%}%>
  </p>
  <p>
    <%=loc.get(26,"Points")%>: <%=r.points%>
  </p>
  <p>
    <%=loc.get(27,"Title")%>: <%=Utils.safe_render(r.title)%>
  </p>
  <p>
    <%=loc.get(28,"Categories")%>: 
      <%for (Integer c : r.get_categories()) {%>
        <span class="category"><%=loc.get(c,"")%> </span>
      <%}%>
  </p>
  <%
  if (show_delete_info) {%>

    <p>
      <%=loc.get(39,"Are you sure you want to delete this requestoffer?")%> <%=r.points%> <%=loc.get(39,"points will be refunded to you")%>
       
    </p>

    <p>
      <a href="delete_requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>"><%=loc.get(29, "Yes, delete!")%></a>
    </p>
    <p>
      <a href="dashboard.jsp">
        <%=loc.get(30,"Nevermind, do not delete it")%></a>
    </p>

    <%} if (show_handle_button) {%>
      <a href="handle.jsp?requestoffer=<%=r.requestoffer_id%>">
        <%=loc.get(37,"Handle")%>
      </a>
    <%}

      String[] messages = 
        Requestoffer_utils.get_messages(r.requestoffer_id, user_id);
       for (String m : messages) { %>

      <p><%=Utils.safe_render(m)%></p>

    <%} if (show_message_input || (is_requestoffering_user && r.status == 78)) { %>
      <form method="POST" 
        action="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&service=true">
        <p><%=String.format(loc.get(38,"Message (up to %d characters)"), 200)%></p>
        <input type="text" name="message" maxlength="200" />
        <button type="submit"><%=loc.get(36,"Send message")%></button>
      </form>
    <% } %>
    <%if (is_requestoffering_user && r.status == 78) {%>
      <a href="transaction_complete.jsp?requestoffer=<%=r.requestoffer_id%>"><%=loc.get(98,"Transaction is complete")%>
      </a>
    <%}%>

<script type="text/javascript" src="includes/timeout.js"></script>
</body>
</html>
