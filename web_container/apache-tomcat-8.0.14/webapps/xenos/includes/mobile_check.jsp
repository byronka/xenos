<%
	// this is where we check what to set as primary css.
	// I found about WAP online - wireless application protocol
	boolean probably_mobile = false;
	java.util.Enumeration headerNames = request.getHeaderNames();
	while (headerNames.hasMoreElements()) {
		String key = (String) headerNames.nextElement();
		if (key.toLowerCase().contains("wap")) { //if it has wap as a header, maybe mobile.
    	probably_mobile |= true;
		}
	}
%>
