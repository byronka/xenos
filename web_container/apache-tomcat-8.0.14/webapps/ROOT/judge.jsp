<%@include file="includes/securepage.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <style>

      label[for=happy] span  { display: none}

      label[for=happy]  {
        background:
          rgba(0, 0, 0, 0) 
          url("static/img/combined.png") 
          repeat scroll 
          -113px -47px;
        width: 45px;
        height: 45px;
        display: block;
      }

      label[for=sad] span  { display: none}

      label[for=sad]  {
        background:
          rgba(0, 0, 0, 0) 
          url("static/img/combined.png") 
          repeat scroll 
          -160px -49px;
        width: 45px;
        height: 45px;
        display: block;
      }

      .happysad {
        display: inline-block;
      }

    </style>
		<title><%=loc.get(186,"Rank user")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%

  String qs = request.getQueryString();
  java.util.Map<String, String> qs_dict = Utils.parse_qs(qs);
  Integer urdp_id = Utils.parse_int(qs_dict.get("urdp"));
  if (urdp_id == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
  Requestoffer_utils.Rank_detail rd = Requestoffer_utils.get_urdp_detail(urdp_id);
%>

<body>
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h3><%=loc.get(186,"Rank user")%></h3>
    <p>
    <%=loc.get(79,"Rank")%>
    <a href="user.jsp?user_id=<%=rd.judged_user_id%>">
      <%=Utils.safe_render(rd.judged_username)%>
    </a>
    <%=loc.get(187,"for the following Favor")%>
    </p>
    <p>Favor <%=rd.ro_id%>: 
      <a href="requestoffer.jsp?requestoffer=<%=rd.ro_id%>">
        <%=rd.ro_desc%>
      </a>
    </p>

    <div class="table">
    <form method="POST" action="judged.jsp" >
      <input type="hidden" name="urdp_id" value="<%=urdp_id%>" />

      <div class="row">
        <div class="happysad">
          <label for="happy" title="happy"><span>Happy</span>
          <input type="radio" name="is_satis" id="happy" value="true" />
        </div>
        <div class="happysad">
          <label for="sad" title="sad"><span>Sad</span>
          <input type="radio" name="is_satis" id="sad" value="false" />
        </div>
      </div>


        <div class="row">
          <label for="is_satis_comment">Comment</label>
          <textarea 
            id="is_satis_comment" 
            name="is_satis_comment" 
            placeholder="I really appreciate ..." ></textarea>
        </div>

        <button class="button" type="submit">submit</button>
    </form>
    </div>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
