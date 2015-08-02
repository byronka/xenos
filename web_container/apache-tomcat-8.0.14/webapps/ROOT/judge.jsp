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


      label[for="happy"] {
          background: 
            rgba(0, 0, 0, 0) 
            url("static/img/combined.png") 
            repeat scroll 
            -115px -52px;
          display: block;
          height: 40px;
          position: relative;
          width: 40px;
      }

      input#happy {
          visibility: collapse;
          /* the following just in case I want it to appear */
          right: -27px;
          position: absolute;
          top: 10px;
      }

      label[for=sad] span  { display: none}

      label[for="sad"] {
          background: 
            rgba(0, 0, 0, 0) 
            url("static/img/combined.png") 
            repeat scroll 
            -160px -49px;
          display: block;
          height: 45px;
          margin-left: 40px;
          position: relative;
          width: 45px;
      }

      input#sad {
          visibility: collapse;
          /* the following just in case I want it to appear */
          right: -25px;
          position: absolute;
          top: 15px;
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
	request.setCharacterEncoding("UTF-8");

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
    <form method="POST" action="confirm_judging.jsp" >
      <input type="hidden" name="urdp_id" value="<%=urdp_id%>" />

      <h3>Choose:</h3>
      <div class="row" id="happysadrow">
        <div class="happysad">
          <label id="happylabel" for="happy" title="happy"><span>Happy</span>
          <input type="radio" name="is_satis" id="happy" value="true"/>
        </div>
        <div class="happysad">
          <label id="sadlabel" for="sad" title="sad"><span>Sad</span>
          <input type="radio" name="is_satis" id="sad"  value="false"/>
        </div>
      </div>


      <div id="commentrow" class="row" style="visibility: collapse">
        <label for="is_satis_comment">Comment</label>
        <textarea 
          id="is_satis_comment" 
          name="is_satis_comment" 
          placeholder="I really appreciate ..." ></textarea>
      </div>

      <button id="submitbutton" style="visibility: collapse" class="button" type="submit">submit</button>

      <script>
        var firstchanged = false;
        var containingRow = document.getElementById('happysadrow');
        containingRow.addEventListener('change',function(event){
          document.getElementById('happylabel').style.backgroundColor="initial";
          document.getElementById('sadlabel').style.backgroundColor="initial";

          if (!firstchanged) {
            document.getElementById('commentrow')
              .style.visibility = "initial";
            document.getElementById('submitbutton')
              .style.visibility = "initial";
          }
          event.target.parentNode.style.backgroundColor="yellow";
        });

        
      </script>

    </form>
    </div>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
