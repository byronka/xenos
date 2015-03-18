<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(186,"Rank user")%></title>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  java.util.Map<String, String> qs_dict = Utils.parse_qs(qs);

  Integer urdp_id = Utils.parse_int(qs_dict.get("urdp"));

  Boolean is_satis = null;
  if (qs_dict.get("satisfied") != null) {
    is_satis = Boolean.parseBoolean(qs_dict.get("satisfied"));
  }

  if (is_satis != null) {
    if (Requestoffer_utils.rank_other_user(user_id, urdp_id, is_satis)) {
      response.sendRedirect("judging_confirmed.jsp");
      return;
    } else {
      response.sendRedirect("general_error.jsp");
      return;
    }
  }

  Requestoffer ro = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);

%>
<body>
  <%@include file="includes/header.jsp" %>
  <h3><%=loc.get(186,"Rank user")%></h3>
  <p>
    <%=loc.get(187,"Rank the other user for the following Favor")%>
  </p>
  <p>Favor <%=ro.requestoffer_id%>: <a href="requestoffer.jsp?requestoffer=<%=ro.requestoffer_id%>"><%=ro.description%></a></p>
  <p>
    <a href="judge.jsp?urdp=<%=urdp_id%>&amp;satisfied=true">
      <%=loc.get(95, "Confirm")%> <%=loc.get(188,"happy")%>
    </a>
  </p>
  <p>
    <a href="judge.jsp?urdp=<%=urdp_id%>&amp;satisfied=false">
      <%=loc.get(95, "Confirm")%> <%=loc.get(189,"unhappy")%>
    </a>
  </p>
</body>
