<%
  int user_id = com.renomad.xenos.Security.check_if_allowed(request, false);
  if (user_id <= 0) { 
    Cookie cookie = new Cookie("xenos_cookie", "");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
    response.sendError(SC_FORBIDDEN);
	}
%>
