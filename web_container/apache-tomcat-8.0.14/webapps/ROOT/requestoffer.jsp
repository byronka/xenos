<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/small_dialog.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <title><%=loc.get(22,"Requestoffer Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  Requestoffer the_requestoffer = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (the_requestoffer == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  boolean has_user_selection_error = false;
  boolean has_validation_error = false;

  if (request.getMethod().equals("POST")) {
    String msg = request.getParameter("message");
    Integer to_user = Utils.parse_int(request.getParameter("to_user"));

    if (to_user == null) {
      has_user_selection_error = true;
      has_validation_error |= true;
    }

    if (!has_validation_error && !Utils.is_null_or_empty(msg)) {
      Requestoffer_utils.set_message(msg, the_requestoffer.requestoffer_id, logged_in_user_id, to_user);
      response.sendRedirect(
        "requestoffer.jsp?requestoffer="+the_requestoffer.requestoffer_id+"&service=true");
      return;
    }
  }

	request.setCharacterEncoding("UTF-8");

  boolean is_requestoffering_user = logged_in_user_id == the_requestoffer.requestoffering_user_id;
  boolean is_handling_user = logged_in_user_id == the_requestoffer.handling_user_id;
  boolean is_deleting = qs.indexOf("delete=true") > 0;
  boolean is_offering_to_service = 
    Requestoffer_utils.is_offering_to_service(logged_in_user_id, the_requestoffer.requestoffer_id);


  boolean show_handle_button = 
    (the_requestoffer.status == Const.Rs.OPEN) &&
    !is_requestoffering_user && 
    !User_utils.has_offered_to_service(the_requestoffer.requestoffer_id, logged_in_user_id) &&
    !is_deleting;
  boolean show_delete_info = 
      is_requestoffering_user && is_deleting;

  Requestoffer_utils.Service_request[] service_request =
    Requestoffer_utils.get_service_requests(the_requestoffer.requestoffering_user_id);

  boolean show_message_input = 
    !is_deleting &&
    (
      (is_requestoffering_user || is_handling_user) && 
        ((service_request.length > 0 && the_requestoffer.status == Const.Rs.OPEN) || the_requestoffer.status == Const.Rs.TAKEN) ||
      (is_offering_to_service)
    );

  //handle bad scenarios
  if (!is_requestoffering_user && is_deleting) {
    response.sendRedirect("general_error.jsp");
    return;
  }


%>
<body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h3> <%=Utils.safe_render(the_requestoffer.description)%> </h3>

    <% if (the_requestoffer.status == Const.Rs.DRAFT) { %>
      <a class="button" href="requestoffer.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>&delete=true">
        <%=loc.get(21,"Delete")%> 
      </a>
    <% } %>

    <% if (is_requestoffering_user && the_requestoffer.status == Const.Rs.OPEN) { %>
      <a class="button" href="retract_requestoffer.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>">
        <%=loc.get(194,"Retract")%>
      </a>
    <% } %>

    <% if (the_requestoffer.status == Const.Rs.DRAFT) { %>
      <a class="button" href="publish_requestoffer.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>"><%=loc.get(6,"Publish")%></a>
    <% } %>

    <% if (show_handle_button) { %>
        <a class="button" href="handle.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>">
          <%=loc.get(37,"Handle")%>
        </a>
    <% } %>

    <%for (Requestoffer_utils.Service_request sr : service_requests) { %>
      <div class="servicerequest">
        <%User servicer = User_utils.get_user(sr.user_id);%>
        
        <a href="user.jsp?user_id=<%=sr.user_id%>">
          <%=Utils.safe_render(servicer.username)%> 
        </a>
        <%
          Group_utils.Group_id_and_name[] servicers_shared_groups = 
            Group_utils.get_shared_groups(logged_in_user_id,sr.user_id);
        %>

        <% if (servicers_shared_groups.length > 0) { %>
            <% for (Group_utils.Group_id_and_name gian : servicers_shared_groups) { %>
              <a class="group-name" href="group.jsp?group_id=<%=gian.id%>"><%=gian.name%></a>
            <% } %>
        <% } %>

        <%=loc.get(138,"wants to handle")%>
        <a class="button" href="choose_handler.jsp?requestoffer=<%=sr.requestoffer_id%>&user=<%=sr.user_id%>">
          <%=loc.get(137,"Choose")%>
        </a>
      </div>
    <% } %>

    <div class="table">
      <div class="row">
        <label for="status_span"><%=loc.get(24,"Status")%>:</label>
        <span id="status_span"><%=loc.get(the_requestoffer.status,"")%></span>
      </div>
      <div class="row">
        <label for="datetime_span"><%=loc.get(25,"Date")%>: </label>
        <span id="datetime_span">
          <%=Utils.show_delta_to_now(Utils.parse_date(the_requestoffer.datetime),loc)%>
        </span>
      </div>
      <div class="row">
        <label for="owning_span"><%=loc.get(100,"Owning User")%>: </label>
        <span id="owning_span">
          <%if(is_requestoffering_user) {%><em><%=loc.get(165,"You")%></em>, <%}%>
          <a href="user.jsp?user_id=<%=the_requestoffer.requestoffering_user_id%>">
            <%=Utils.safe_render(User_utils.get_user(the_requestoffer.requestoffering_user_id).username)%>
          </a>
        </span>
      </div>
      <%if((is_requestoffering_user || is_handling_user) && (!Utils.is_null_or_empty(the_requestoffer.postcode) || !Utils.is_null_or_empty(the_requestoffer.details)) ) {%>
        <div class="row">
          <label for="location"><%=loc.get(15,"Location details")%>: </label>
          <span id="location"><%=the_requestoffer.details%> <%=the_requestoffer.postcode%></span>
        </div>
      <%}%>
      <div class="row">
        <label for=handling_span"><%=loc.get(101,"Handling User")%>: </label>
        <span id="handling_span">
        <%if(is_handling_user) {%>
          <em><%=loc.get(165,"You")%></em>, 
        <%}%>
          <% User handleuser = User_utils.get_user(the_requestoffer.handling_user_id); 
        if (handleuser != null) {%>
        <a href="user.jsp?user_id=<%=the_requestoffer.handling_user_id%>">
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
          <%=loc.get(the_requestoffer.category,"")%> 
        </span>
      </div>
    </div>

    <% if (show_delete_info) {%>
      <div class="table">
        <div class="row">
          <p>
            <%=loc.get(39,"Are you sure you want to delete this requestoffer?")%> 
          </p>

          <p>
            <a class="button" href="delete_requestoffer.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>"><%=loc.get(29, "Yes, delete!")%></a>
          </p>
          <p>
            <a class="button" href="requestoffer.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>">
              <%=loc.get(30,"Nevermind, do not delete it")%></a>
          </p>
        </div>
      </div>
    <% } %>


        <% Requestoffer_utils.MessageWithDate[] messages = 
          Requestoffer_utils.get_messages(the_requestoffer.requestoffer_id, logged_in_user_id);
        %>

        <% for (int i = 0; i < messages.length; i++) { %>
          <% if (i == 0) { %>
            <%=Utils.show_delta_to_now(Utils.parse_date(messages[i].date),loc)%>:
          <% } else { %>
            <%=Utils.show_date_delta_later(
              Utils.parse_date(messages[i].date),
              Utils.parse_date(messages[i-1].date),
              loc)%>
          <% } %>
          <p><%=Utils.safe_render(messages[i].message)%></p>
        <% } %>


        <% if (show_message_input) { %>

          <form method="POST" 
            action="requestoffer.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>&service=true">

            <% 
              // if we are in OPEN status 
              if (the_requestoffer.status == Const.Rs.OPEN) { 
            %>

              <% // if this user is the owner %>
              <% if (logged_in_user_id == the_requestoffer.requestoffering_user_id) { %>

                <% // if there is only one offerer %>
                <% if (service_request.length == 1) { %>
                  <input type="hidden" id="to_user" name="to_user" value="<%=service_request[0].user_id%>" />

                <% // if there are multiple offerers, show a dropdown %>
                <% } else { %>

                  <% if (has_user_selection_error) { %>
                    <span class="error">You must select a target user</span>
                  <% } %>

                  <select id="to_user" name="to_user" >
                    <option disabled selected> -- Select a user -- </option>			            
                    <%                                       
                      for(int i = 0; i < service_request.length; i++) { 
                    %>
                      <option value="<%=service_request[i].user_id%>"><%=service_request[i].username%></option>    
                    <% } %>			           		             
                  </select>

                <% } %>
              <% } else { %>
                <input type="hidden" id="to_user" name="to_user" value="<%=the_requestoffer.requestoffering_user_id%>" />
              <% } %>

            <% } else if (the_requestoffer.status == Const.Rs.TAKEN) { // TAKEN status %>
              <% // if this user is the owner %>
              <% if (logged_in_user_id == the_requestoffer.requestoffering_user_id) { %>
                <input type="hidden" id="to_user" name="to_user" value="<%=the_requestoffer.handling_user_id%>" />
              <% // if this user is the handling user %>
              <% } else { %>
                <input type="hidden" id="to_user" name="to_user" value="<%=the_requestoffer.requestoffering_user_id%>" />
              <% } %>
            <% } %>

              <label for="message">
                <%=String.format(loc.get(38,"Message (up to %d characters)"), 200)%>
              </label>
            <div class="table">
            <div class="row">

              <textarea id="message" name="message" maxlength="200" ></textarea>


            <button class="button" type="submit">
              <%=loc.get(36,"Send message")%>
            </button>
            </div>
            </div>

          </form>

        <% } %>
        <div>
          <% if ( the_requestoffer.status == Const.Rs.TAKEN && 
            (is_requestoffering_user || is_handling_user)) { %> 
            <a class="button" href="cancel_active_favor.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>" >
              <%=loc.get(130,"Cancel")%>
            </a>
          <% } %>

          <%if (is_requestoffering_user && the_requestoffer.status == Const.Rs.TAKEN) {%>
            <a class="button" href="check_transaction.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>"><%=loc.get(98,"Transaction is complete")%>
            </a>
          <%}%>
      </div>
    </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>
