<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%

  String thequerystring = request.getQueryString();
  java.util.Map<String,String> params = Utils.parse_qs(thequerystring);
  Integer usecase = Utils.parse_int(params.get("usecase"));

%>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title><%=loc.get(209,"Change current location")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
  <%@include file="includes/header.jsp" %>
  
  <div class="container">

    <h3><%=loc.get(157, "Country")%>:</h3>
      <form method="POST" action="enter_postcode.jsp">
      <input type="hidden" name="usecase" id="usecase" value="<%=usecase%>">
      <div class="table">
        <div class="row">
          <%
            com.renomad.xenos.Requestoffer_utils.Country[] countries = Requestoffer_utils.get_countries();
          %>
          <select name="country" id="country" autofocus="true">
            <% for (int i = 0; i < countries.length; i ++) { %>
            <% if (countries[i].country_id == 244) { %>
              <option selected="selected" value="<%=countries[i].country_id%>">
            <% } else if (countries[i].country_id == 82) { %>
              <option value="<%=countries[i].country_id%>">
            <% } %>
                <%=countries[i].country_name%>
              </option>
            <% } %>
          </select>
          </div>
        </div>

        <div class="table">
          <div class="row">
            <button class="button">
              <%=loc.get(74, "Select country")%>
            </button>
          </div>
        </div>

      </form>


  </div>
  <%@include file="includes/footer.jsp" %>
  </body>
</html>
