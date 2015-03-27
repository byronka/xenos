<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="small_dialog.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
    <title><%=loc.get(22,"Requestoffer Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%
	request.setCharacterEncoding("UTF-8");
  String qs = request.getQueryString();
  Requestoffer r = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  User_location[] locations = Requestoffer_utils.get_locations_for_requestoffer(r.requestoffer_id);

  boolean is_requestoffering_user = logged_in_user_id == r.requestoffering_user_id;
  boolean is_handling_user = logged_in_user_id == r.handling_user_id;
  boolean is_deleting = qs.indexOf("delete=true") > 0;

  boolean show_handle_button = 
    (r.status == 76) && //'open'
    !is_requestoffering_user && 
    !User_utils.has_offered_to_service(r.requestoffer_id, logged_in_user_id) &&
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
    Requestoffer_utils.set_message(msg, r.requestoffer_id, logged_in_user_id);
    response.sendRedirect(
      "requestoffer.jsp?requestoffer="+r.requestoffer_id+"&service=true");
    return;
  }

%>
<body>
  <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h3> <%=Utils.safe_render(r.description)%> </h3>
    <div class="table">
      <div class="row">
        <label for="status_span"><%=loc.get(24,"Status")%>:</label>
        <span id="status_span"><%=loc.get(r.status,"")%></span>
      </div>
      <div class="row">
        <label for="datetime_span"><%=loc.get(25,"Date")%>: </label>
        <span id="datetime_span"><%=r.datetime%></span>
      </div>
      <div class="row">
        <label for="owning_span"><%=loc.get(100,"Owning User")%>: </label>
        <span id="owning_span">
          <%if(is_requestoffering_user) {%><em><%=loc.get(165,"You")%></em>, <%}%>
          <a href="user.jsp?user_id=<%=r.requestoffering_user_id%>">
            <%=Utils.safe_render(User_utils.get_user(r.requestoffering_user_id).username)%>
          </a>
        </span>
      </div>
      <div class="row">
        <label for=handling_span"><%=loc.get(101,"Handling User")%>: </label>
        <span id="handling_span">
        <%if(is_handling_user) {%>
          <em><%=loc.get(165,"You")%></em>, 
        <%}%>
          <% User handleuser = User_utils.get_user(r.handling_user_id); 
        if (handleuser != null) {%>
        <a href="user.jsp?user_id=<%=r.handling_user_id%>">
          <%=Utils.safe_render(handleuser.username)%>
        </a>
        <%} else {%>
          <%=loc.get(103,"None")%>
        <%}%>
        </span>
      </div>
      <div class="row">
        <label for="cat_span"><%=loc.get(28,"Categories")%>: </label>
        <span id="cat_span" class="category">
          <%=loc.get(r.category,"")%> 
        </span>
      </div>
      <% for (User_location lo : locations) { %>

        <%
          if (logged_in_user_id == r.handling_user_id || 
          logged_in_user_id == r.requestoffering_user_id) { 
        %>

          <%if (!Utils.is_null_or_empty(lo.str_addr_1)) {%>
            <div class="row">
              <label for="strt1_span"><%=loc.get(152,"Street address 1")%>: </label>
              <span id="strt1_span"><%=Utils.safe_render(lo.str_addr_1)%></span>
            </div>
          <%}%>

          <%if (!Utils.is_null_or_empty(lo.str_addr_2)) {%>
            <div class="row">
              <label for="strt2_span"><%=loc.get(153,"Street address 2")%>: </label>
              <span id="strt2_span"><%=Utils.safe_render(lo.str_addr_2)%></span>
            </div>
          <%}%>

          <%if (!Utils.is_null_or_empty(lo.state)) {%>
            <div class="row">
              <label for="state_span"><%=loc.get(155,"State")%>: </label>
              <span id="state_span"><%=Utils.safe_render(lo.state)%></span>
            </div>
          <%}%>

          <%if (!Utils.is_null_or_empty(lo.country)) {%>
            <div class="row">
              <label for="country_span"><%=loc.get(157,"Country")%>:</label>
              <span id="country_span"><%=Utils.safe_render(lo.country)%></span>
            </div>
          <%}%>

        <% } %>

        <%if (!Utils.is_null_or_empty(lo.city)) {%>
          <div class="row">
            <label for="city_span"><%=loc.get(154,"City")%>:</label>
            <span id="city_span"><%=Utils.safe_render(lo.city)%></span>
          </div>
        <%}%>

        <%if (!Utils.is_null_or_empty(lo.postcode)) {%>
          <div class="row">
            <label for="post_span"><%=loc.get(156,"Postal code")%>: </label>
            <span id="post_span"><%=Utils.safe_render(lo.postcode)%></span>
          </div>
        <%}%>

      <% } %>

      <% if (r.status == 109) { %>
        <a class="button" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&delete=true">
          <%=loc.get(21,"Delete")%>
        </a>
      <% } %>

      <% if (is_requestoffering_user && r.status == 76) { %>
        <a class="button" href="retract_requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
          <%=loc.get(194,"Retract")%>
        </a>
      <% } %>

      <% if (r.status == 109) { %>
        <a class="button" href="publish_requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>"><%=loc.get(6,"Publish")%></a>
      <% } %>

      <% if (show_delete_info) {%>

        <p>
          <%=loc.get(39,"Are you sure you want to delete this requestoffer?")%> 
        </p>

        <p>
          <a class="button" href="delete_requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>"><%=loc.get(29, "Yes, delete!")%></a>
        </p>
        <p>
          <a class="button" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
            <%=loc.get(30,"Nevermind, do not delete it")%></a>
        </p>

        <%} 
        
        if (show_handle_button) {%>
          <a class="button" href="handle.jsp?requestoffer=<%=r.requestoffer_id%>">
            <%=loc.get(37,"Handle")%>
          </a>

        <%}%>

        <% if ( r.status == 78 && (is_requestoffering_user || is_handling_user)) { %> 
          <a href="cancel_active_favor.jsp?requestoffer=<%=r.requestoffer_id%>" >
            <%=loc.get(130,"Cancel")%>
          </a>
        <% } %>

         <% String[] messages = 
            Requestoffer_utils.get_messages(r.requestoffer_id, logged_in_user_id);
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
          <a href="check_transaction.jsp?requestoffer=<%=r.requestoffer_id%>"><%=loc.get(98,"Transaction is complete")%>
          </a>
        <%}%>
      </div>
    </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>
