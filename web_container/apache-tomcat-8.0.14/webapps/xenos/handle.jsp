<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(94,"Handle request")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Request_utils" %>
<%@ page import="com.renomad.xenos.Request" %>
<%
  String qs = request.getQueryString();
  java.util.Map<String,String> params = Utils.parse_qs(qs);
  int r_id = Utils.parse_int(params.get("request")); 
  Request r = Request_utils.get_a_request(r_id);
  String is_confirmed = params.get("confirm");
  if (is_confirmed != null && is_confirmed.equals("true")) {
  if (Request_utils.take_request(user_id, r.request_id)) {
    response.sendRedirect(
      String.format("request.jsp?request=%d&service=true",r.request_id));
    return;
    } else {
      out.println("<script>console.log('help!')</script>");
    }
  }
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  //handle bad scenarios

  if (user_id == r.requesting_user_id) {
    response.sendRedirect("general_error.jsp");
    return;
  }

%>
<body>
  <%@include file="includes/header.jsp" %>
    <p>If you would like to take this request, click the confirm button below</p>
    <a href="handle.jsp?request=<%=r.request_id%>&confirm=true"><%=loc.get(95, "Confirm")%></a>
</body>
