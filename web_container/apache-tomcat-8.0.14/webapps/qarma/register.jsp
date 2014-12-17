<%@ page import="com.renomad.qarma.Security" %>
<%@ page import="com.renomad.qarma.User_utils" %>
<%
	//check if they are already logged in.  If so, just skip to
	//dashboard.  it just checks the user cookie to see if we are good
	//to go.  It doesn't use username and password.
  int user_id = Security.check_if_allowed(request);
	if (user_id > 0) { response.sendRedirect("dashboard.jsp"); }

	//get the values straight from the client
	String first_name = "";
	String last_name = "";
	String email = "";
	String password = "";
	boolean validation_error = false;

	//we'll put error messages here if validation errors occur
	String first_name_error_msg = "";  //empty first name
	String last_name_error_msg = "";  //empty last name
	String email_error_msg = "";  //empty email
	String password_error_msg = "";  //empty password
	String user_creation_error_msg = ""; //couldn't register

	if (request.getMethod().equals("POST")) {

		//check the first name
    first_name = request.getParameter("first_name");
		if (first_name.length() == 0) {
			first_name_error_msg = "Please enter a first name";
			validation_error |= true;
		}

		//check the last name
    last_name = request.getParameter("last_name");
		if (last_name.length() == 0) {
			last_name_error_msg = "Please enter a last name";
			validation_error |= true;
		}

    email = request.getParameter("email");
		if (email.length() == 0) {
			email_error_msg = "Please enter an email";
			validation_error |= true;
		}

    password = request.getParameter("password");
		if (password.length() == 0) {
			password_error_msg = "Please enter a password";
			validation_error |= true;
		}

		if (!validation_error) {
		boolean succeed = User_utils.put_user(
			first_name, last_name, email, password);
			if (succeed) {
				response.sendRedirect("thanks.htm");
			} else {
			  user_creation_error_msg = "That user already exists";
			}
		}
	}
%>
<html>
<head><title>Account Creation</title></head>
<body>
<h2>
  Create a new account
</h2>
  <form id="enter_name_form" action="register.jsp" method="post">
		<div><%=user_creation_error_msg%></div>
    <p>
      First Name:
			<input value="<%=first_name%>" name="first_name" type="text" />
			<span><%=first_name_error_msg %></span>
		</p>
		<p>
      Last Name:
			<input value="<%=last_name%>" name="last_name" type="text" />
			<span><%=last_name_error_msg %></span>
    </p>
    <p>
      Email:
			<input value="<%=email%>" name="email" type="text" />
			<span><%=email_error_msg %></span>
    </p>
    <p>
      Password:
			<input value="<%=password%>" name="password" type="password" />
			<span><%=password_error_msg %></span>
    </p>

    <button form="enter_name_form" >Create my new user!</button>
  </form>
</body>
</html>
