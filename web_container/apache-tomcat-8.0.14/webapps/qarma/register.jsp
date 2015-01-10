<%@ page import="com.renomad.qarma.Security" %>
<%@ page import="com.renomad.qarma.User_utils" %>
<%@ page import="com.renomad.qarma.Localization" %>
<%
	//check if they are already logged in.  If so, just skip to
	//dashboard.  it just checks the user cookie to see if we are good
	//to go.  It doesn't use username and password.
  int user_id = Security.check_if_allowed(request);
	if (user_id > 0) { response.sendRedirect("dashboard.jsp"); }

	//set up an object to localize text
  Localization loc  = new Localization(request.getLocale());

	//get the values straight from the client
	String first_name = "";
	String last_name = "";
	String username = "";
	String password = "";
	boolean validation_error = false;

	//we'll put error messages here if validation errors occur
	String first_name_error_msg = "";  //empty first name
	String last_name_error_msg = "";  //empty last name
	String username_error_msg = "";  //empty username
	String password_error_msg = "";  //empty password
	String user_creation_error_msg = ""; //couldn't register

	if (request.getMethod().equals("POST")) {

		//check the first name
    first_name = request.getParameter("first_name");
		if (first_name.length() == 0) {
			first_name_error_msg = loc.get(53,"Please enter a first name");
			validation_error |= true;
		}

		//check the last name
    last_name = request.getParameter("last_name");
		if (last_name.length() == 0) {
			last_name_error_msg = loc.get(54,"Please enter a last name");
			validation_error |= true;
		}

    username = request.getParameter("username");
		if (username.length() == 0) {
			username_error_msg = loc.get(55,"Please enter a username");
			validation_error |= true;
		}

    password = request.getParameter("password");
		if (password.length() == 0) {
			password_error_msg = loc.get(56,"Please enter a password");
			validation_error |= true;
		}

		if (!validation_error) {
		boolean succeed = User_utils.put_user(
			first_name, last_name, username, password);
			if (succeed) {
				response.sendRedirect("thanks.jsp");
			} else {
			  user_creation_error_msg = loc.get(57,"That user already exists");
			}
		}
	}
%>
<html>
	<head><title><%=loc.get(58,"Account Creation")%></title></head>
	<link rel="stylesheet" href="register.css">
<body>
	<div class="trademark cl-effect-1"><a href="index.jsp">Qarma</a></div>
	<div class="register">
		<form id="enter_name_form" action="register.jsp" method="post">

			<div class="error"><%=user_creation_error_msg%></div>

			<div class="first-name">
				<div class="label"><%=loc.get(60,"First Name")%>:</div>
				<input value="<%=first_name%>" name="first_name" type="text" />
				<span class="error"><%=first_name_error_msg %></span>
			</div>

			<div class="last-name">
			  <div class="label"><%=loc.get(61,"Last Name")%>:</div> 
				<input value="<%=last_name%>" name="last_name" type="text" />
				<span class="error"><%=last_name_error_msg %></span>
			</div>

			<div class="username">
				<div class="label"><%=loc.get(51 ,"username")%>:</div> 
				<input value="<%=username%>" name="username" type="text" />
				<span class="error"><%=username_error_msg %></span>
			</div>

			<div class="password">
				<div class="label"><%=loc.get(63,"Password")%>:</div> 
				<input value="<%=password%>" name="password" type="password" />
				<span class="error"><%=password_error_msg %></span>
			</div>

			<button form="enter_name_form" >
				<%=loc.get(64,"Create my new user!")%>
			</button>

		</form>

	</div>
</body>
</html>
