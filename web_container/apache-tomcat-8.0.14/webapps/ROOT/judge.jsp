<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
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
  <img id='my_background' style="z-index:-1;top:0;left:0;width:100%;height:100%;opacity:0;position:fixed;" src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
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

    <form method="POST" action="judged.jsp" >
      <fieldset>
        <input type="hidden" name="urdp_id" value="<%=urdp_id%>" />
        <legend><%=loc.get(22,"Favor Details")%></legend>

        <input type="radio" name="is_satis" id="happy" value="true" />
        <label for="happy">Happy</label>

        <input type="radio" name="is_satis" id="sad" value="false" />
        <label for="sad">Sad</label>

        <div>
          <label for="is_satis_comment">Comment</label>
          <textarea 
            id="is_satis_comment" 
            name="is_satis_comment" 
            placeholder="I really appreciate ..." ></textarea>
        </div>

        <button type="submit">submit</button>
      </fieldset>
    </form>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
