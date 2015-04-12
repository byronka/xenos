<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/small_dialog.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <title><%=loc.get(22,"Requestoffer Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  Requestoffer r = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  if (request.getMethod().equals("POST")) {
    String msg = request.getParameter("message");
    Integer to_user = Utils.parse_int(request.getParameter("to_user"));

    if (!Utils.is_null_or_empty(msg)) {
      Requestoffer_utils.set_message(msg, r.requestoffer_id, logged_in_user_id, to_user);
      response.sendRedirect(
        "requestoffer.jsp?requestoffer="+r.requestoffer_id+"&service=true");
      return;
    }
  }

	request.setCharacterEncoding("UTF-8");

  boolean is_requestoffering_user = logged_in_user_id == r.requestoffering_user_id;
  boolean is_handling_user = logged_in_user_id == r.handling_user_id;
  boolean is_deleting = qs.indexOf("delete=true") > 0;
  boolean is_offering_to_service = 
    Requestoffer_utils.is_offering_to_service(logged_in_user_id, r.requestoffer_id);


  boolean show_handle_button = 
    (r.status == 76) && //'open'
    !is_requestoffering_user && 
    !User_utils.has_offered_to_service(r.requestoffer_id, logged_in_user_id) &&
    !is_deleting;
  boolean show_delete_info = 
      is_requestoffering_user && is_deleting;

  Requestoffer_utils.Service_request[] service_request =
    Requestoffer_utils.get_service_requests(r.requestoffering_user_id);

  boolean show_message_input = 
    !is_deleting &&
    (
      (is_requestoffering_user && (service_request.length > 0 && r.status == 76) || r.status == 78) ||
      (is_handling_user) ||
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
      <%if((is_requestoffering_user || is_handling_user) && (!Utils.is_null_or_empty(r.postcode) || !Utils.is_null_or_empty(r.details)) ) {%>
        <div class="row">
          <label for="location"><%=loc.get(15,"Location details")%>: </label>
          <span id="location"><%=r.details%> <%=r.postcode%></span>
        </div>
      <%}%>
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
    </div>

    <div class="table">
      <div class="row">
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
      </div>
      </div>


         <% String[] messages = 
            Requestoffer_utils.get_messages(r.requestoffer_id, logged_in_user_id);
           for (String m : messages) { %>

          <p><%=Utils.safe_render(m)%></p>

        <%} if (show_message_input) { %>

          <form method="POST" 
            action="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&service=true">

            <% 
              // if we are in OPEN status 
              if (r.status == 76) { 
            %>

              <% // if this user is the owner %>
              <% if (logged_in_user_id == r.requestoffering_user_id) { %>

                <% // if there is only one offerer %>
                <% if (service_request.length == 1) { %>
                  <input type="hidden" id="to_user" name="to_user" value="<%=service_request[0].user_id%>" />

                <% // if there are multiple offerers, show a dropdown %>
                <% } else { %>

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
                <input type="hidden" id="to_user" name="to_user" value="<%=r.requestoffering_user_id%>" />
              <% } %>

            <% } else if (r.status == 78) { // TAKEN status %>
              <% // if this user is the owner %>
              <% if (logged_in_user_id == r.requestoffering_user_id) { %>
                <input type="hidden" id="to_user" name="to_user" value="<%=r.handling_user_id%>" />
              <% // if this user is the handling user %>
              <% } else { %>
                <input type="hidden" id="to_user" name="to_user" value="<%=r.requestoffering_user_id%>" />
              <% } %>
            <% } %>

            <div class="table">
            <div class="row">
              <label for="message">
                <%=String.format(loc.get(38,"Message (up to %d characters)"), 200)%>
              </label>

              <textarea id="message" name="message" maxlength="200" ></textarea>


            <button class="button" type="submit">
              <%=loc.get(36,"Send message")%>
            </button>
            </div>
            </div>

          </form>

        <% } %>
        <div>
          <% if ( r.status == 78 && 
            (is_requestoffering_user || is_handling_user)) { %> 
            <a class="button" href="cancel_active_favor.jsp?requestoffer=<%=r.requestoffer_id%>" >
              <%=loc.get(130,"Cancel")%>
            </a>
          <% } %>

          <%if (is_requestoffering_user && r.status == 78) {%>
            <a class="button" href="check_transaction.jsp?requestoffer=<%=r.requestoffer_id%>"><%=loc.get(98,"Transaction is complete")%>
            </a>
          <%}%>
      </div>
    </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>
