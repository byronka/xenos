
<div>
	<style>

body {
	background-color:#526589;
}

.search {
	position: absolute;
	top: 5px;
	right: 10px;
}

form.search input {
	height:30px;
}

form.search button {
	height: 30px;
}

div.user-displayname {
	position: relative;
	clear: left;
	top: 10px;
	left: 20px;
}

div.spacer {
	height: 60px;
}

section.header {

	background-color: #5f2d1d;
	color: white;
	border: 1px solid grey;
	height: 60px;
	position: fixed;
	top:0px;
	left: 0px;
	right: 0px;
	width: 100%;
	z-index: 1;
}

div.trademark {
	text-shadow:6px 7px 4px rgba(34,87,73,0.5);
	font-weight:bold;
	color:white;
	letter-spacing:10pt;
	word-spacing:1pt;
	font-size:36px;
	text-align:left;
	line-height:1;
	position: absolute;
}

nav a {
	position: relative;
	display: inline-block;
	outline: none;
	color:white;
	text-decoration: none;
	text-shadow: 0 0 1px rgba(255,255,255,0.3);
	font-size: 1.35em;
}


nav a:hover,
nav a:focus {
	outline: none;
}

/* Effect 1: Brackets */
.cl-effect-1 a::before,
.cl-effect-1 a::after {
	display: inline-block;
	opacity: 0;
	-webkit-transition: -webkit-transform 0.3s, opacity 0.2s;
	-moz-transition: -moz-transform 0.3s, opacity 0.2s;
	transition: transform 0.3s, opacity 0.2s;
}

.cl-effect-1 a::before {
	margin-right: 10px;
	content: '[';
	-webkit-transform: translateX(20px);
	-moz-transform: translateX(20px);
	transform: translateX(20px);
}

.cl-effect-1 a::after {
	margin-left: 10px;
	content: ']';
	-webkit-transform: translateX(-20px);
	-moz-transform: translateX(-20px);
	transform: translateX(-20px);
}

.cl-effect-1 a:hover::before,
.cl-effect-1 a:hover::after,
.cl-effect-1 a:focus::before,
.cl-effect-1 a:focus::after {
	opacity: 1;
	-webkit-transform: translateX(0px);
	-moz-transform: translateX(0px);
	transform: translateX(0px);
}
</style>
<div class="spacer" />
<section class="header">
	<nav class="cl-effect-1">
		<a class="trademark" href="dashboard.jsp">Qarma</a>
		<a href="create_request.jsp" ><%=loc.get(2, "Create Request")%></a>
		<a href="logout.jsp" ><%=loc.get(3, "Logout")%></a>
	</nav>
	<form class="search" method="GET" action="dashboard.jsp" >
		<span><input type=text" name="search" maxlength="20" />
			<button><%=loc.get(1, "search")%></button></span>
	</form>
	<div class="user-displayname">
	<span><%=user.first_nameSafe()%></span>
	<span><%=user.last_nameSafe()%></span>
	<span>(<%=user.emailSafe()%>) </span>
	<span><%=user.points%> <%=loc.get(11, "points")%></span>
	</div>
</section>
</div>
