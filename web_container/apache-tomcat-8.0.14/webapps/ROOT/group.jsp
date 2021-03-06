<%@include file="includes/securepage.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <style>

      .edit_desc span{
        display: none;
      }

      .edit_desc {
        background:
          rgba(0, 0, 0, 0) 
          url("static/img/combined.png") 
          repeat scroll 
          -20px 0;
        width: 18px;
        height: 18px;
        display: inline-block;
      }

      .remove_user span {
        display: none;
      }

      .remove_user {
        background:
          rgba(0, 0, 0, 0) 
          url("static/img/combined.png") 
          repeat scroll 
          0 -20px;
        width: 18px;
        height: 18px;
        display: inline-block;
      }
      
    </style>
    <title>Group</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%
  request.setCharacterEncoding("UTF-8");


  boolean username_validation_error = false;
  boolean duplicate_invite_error = false;
  boolean in_group_already_error = false;
  String the_username = "";
  Integer gid = null; // the group id
  Group_utils.Group the_group = null;

  // handle user invites and show validation if user doesn't exist.
  if (request.getMethod().equals("POST")) {
    the_username = request.getParameter("username");
    gid = Utils.parse_int(request.getParameter("group_id"));

    the_group = Group_utils.get_group(gid);
    if (the_group == null) {
      response.sendRedirect("general_error.jsp");
      return;
    }

    int their_user_id = User_utils.get_user_id_by_name(the_username);

    if (their_user_id < 0 ) {
      username_validation_error = true;
    }

    if (!username_validation_error 
          && logged_in_user_id == the_group.owner_id) {
      Group_utils.Send_invite_result sir = 
        Group_utils.send_group_invite_to_user(
        logged_in_user_id, gid, their_user_id);
        switch(sir) {
          case OK:
            response.sendRedirect(
              String.format("invite_sent.jsp?user_id=%d&group_id=%d",their_user_id, gid));
            return;
          case ALREADY_IN_GROUP:
            in_group_already_error = true;
            break;
          case DUPLICATE_INVITE:
            duplicate_invite_error = true;
            break;
          case GENERAL_ERR:
          //fall through
          default:
            response.sendRedirect("general_error.jsp");
            return;
        }
    } 

  } else {

    String qs = request.getQueryString();
    gid = Utils.parse_int(Utils.parse_qs(qs).get("group_id"));
    if (gid == null) {
      gid = -1;
    }

    the_group = Group_utils.get_group(gid);
    if (the_group == null) {
      response.sendRedirect("general_error.jsp");
      return;
    }

  }

  boolean is_invited = Group_utils.has_been_invited(logged_in_user_id, gid);
  boolean is_a_member = Group_utils.is_member_of_group(logged_in_user_id, gid);
  boolean is_the_group_owner = logged_in_user_id == the_group.owner_id;


  if (!(is_invited || is_a_member)) {
    response.sendRedirect("general_error.jsp");
    return;
  }

%>
	<body>
  <%@include file="includes/header.jsp" %>

  <div class="container">
    <h3><%=loc.get(56,"Details of the group")%>:</h3>

    <div class="table">
      <div class="row">
        <label><%=loc.get(53,"Group name")%>:</label>
        <span><%=the_group.group_name%></span>
      </div>

      <div class="row">
        <label><%=loc.get(10,"Description")%>:</label>
        <span><%=the_group.description%>
        <% if (logged_in_user_id == the_group.owner_id) { %>
          <a title="<%=loc.get(62,"Edit my group description")%>" 
            class="edit_desc" 
            href="edit_group_description.jsp?group_id=<%=gid%>&amp;edit_desc=true" >
            <span><%=loc.get(62,"Edit my group description")%></span>
          </a>
        <% } %>
       </span> 
      </div>

      <div class="row">
        <label><%=loc.get(59,"Owner")%>:</label>
            <span>
              <a href="user.jsp?user_id=<%=the_group.owner_id%>">
                <%=the_group.owner_username%>
              </a>
              <% if (logged_in_user_id == the_group.owner_id) { %>
                <a title="<%=loc.get(62,"Edit my group description")%>" 
                  class="edit_desc" 
                  href="edit_groupuser_description.jsp?group_id=<%=gid%>&amp;edit_desc=true" >
                  <span><%=loc.get(62,"Edit my group description")%></span>
                </a>
              <% } %>
              <div>
                <span>
                  <%=Group_utils.get_user_group_description(gid, the_group.owner_id)%>
                </span>
              </div>
            </span>
      </div>
    </div>

      
      <% if (is_a_member) { %>
        <div class="table">
            <h3><%=loc.get(60,"Members")%>:</h3>
            <% for (java.util.Map.Entry<Integer, String> member : 
                the_group.get_members().entrySet()) { %>
                  <% if (member.getKey() != the_group.owner_id) { %>
                    <div class="row">
                      <label>
                      <a href="user.jsp?user_id=<%=member.getKey()%>">
                        <%=Utils.safe_render(member.getValue())%>
                      </a>
                      <% if (member.getKey() == logged_in_user_id) { %>
                        <a title="<%=loc.get(62,"Edit my group description")%>" 
                          class="edit_desc" 
                          href="edit_groupuser_description.jsp?group_id=<%=gid%>&amp;edit_desc=true" >
                          <span><%=loc.get(62,"Edit my group description")%></span>
                        </a>
                      <% } %>
                      <% if (logged_in_user_id == the_group.owner_id) { %>
                        <a title="<%=loc.get(88,"Remove this user")%>" 
                          class="remove_user" 
                          href="remove_from_group.jsp?group_id=<%=gid%>&user_id=<%=member.getKey()%>" >
                          <span><%=loc.get(88,"Remove this user")%></span>
                        </a>
                      <% } %>
                      </label>
                      <div>
                        <%=Utils.safe_render(Group_utils.get_user_group_description(gid, member.getKey()))%>
                      </div>
                    </div>
                  <% } %>
              <% } %>
            </div>

            <%
              Group_utils.Invite_info[] sent_invites =  
                Group_utils.get_invites_for_group(gid);
            %>
            <% if (is_the_group_owner && sent_invites.length > 0) { %>
              <h3>Invites sent to users:</h3>
              <% for (Group_utils.Invite_info ii : sent_invites) {%>
                <p>
                  <a href="user.jsp?user_id=<%=ii.user_id%>">
                    <%=Utils.safe_render(ii.username)%>
                  </a>
                  <a class="button" href="retract_invitation.jsp?group_id=<%=gid%>&user_id=<%=ii.user_id%>">Retract invitation</a>
                </p>
              <% } %>
            <% } %>


      <% if (is_the_group_owner) { %>
        <form method="POST" id="invite_member" action="group.jsp">
          <div class="table">
            <div class="row">
              <input type="hidden" id="group_id" name="group_id" value="<%=gid%>">
              <input type="text" id="username" name="username" value="<%=Utils.safe_render(the_username)%>">
                  <% if (duplicate_invite_error) { %>
                    <div class="error">
                      An invitation has already been sent to this user.
                    </div>
                  <% } %>
                  <% if (in_group_already_error) { %>
                    <div class="error">
                      This user is already in the group
                    </div>
                  <% } %>
                  <% if (username_validation_error) { %>
                    <div class="error">
                      username was not found. 
                    </div>
                  <% } %>
            </div>
          </div>
          <div class="table">
            <div class="row">
              <button class="button" type="submit"><%=loc.get(61,"Send invite")%></button>
            </div>
          </div>
        </form>
      <% } %>


        <% if (!is_the_group_owner) { %>
          <a href="handle_leave_group.jsp?group_id=<%=gid%>" class="button">Leave group</a>
        <% } %>

      <% } %>

      <% if (is_invited) { %>
        <div>
          You have been invited to join this group.  Click on the button below to confirm joining
        </div>
        <div class="table">
        <div class="row">
          <a class="button" href="handle_group_invite.jsp?group_id=<%=gid%>&is_accepted=true">Join group</a>
          <a class="button" href="handle_group_invite.jsp?group_id=<%=gid%>&is_accepted=false">Reject offer</a>
        </div>
        </div>
      <% } %>


  </div>
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
