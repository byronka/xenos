<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(22,"Favor Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  Requestoffer r = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
  if (r.status == 77) {// closed
  	response.sendRedirect("general_error.jsp");
  }
%>
<body>

<form method="POST" action="transaction_complete.jsp" >
  <fieldset>
    <input type="hidden" name="ro_id" value="<%=r.requestoffer_id%>" />
    <legend><%=loc.get(22,"Favor Details")%></legend>

    <input type="radio" name="is_satis" id="happy" value="true" />
    <label for="happy">Happy</label>

    <input type="radio" name="is_satis" id="sad" value="false" />
    <label for="sad">Sad</label>

    <label for="is_satis_comment">Comment</label>
    <textarea 
      id="is_satis_comment" 
      name="is_satis_comment" 
      placeholder="I really appreciate ..." >
    </textarea>

    <button type="submit">submit</button>
  </fieldset>
</form>

</body>
</html>
