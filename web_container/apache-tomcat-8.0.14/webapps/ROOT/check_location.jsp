<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>

  <head>
    <title><%=loc.get(22,"Favor Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <%if (probably_mobile) {%>
      <link rel="stylesheet" href="includes/common_alt.css" title="mobile">
    <% } else { %>
      <link rel="stylesheet" href="includes/common.css" title="desktop">
    <% } %>   
  </head>
  <body>
    <%@include file="includes/header.jsp" %>

    <div class="wrapper">
      <div class="container theme-showcase" role="main">           
        <div class="page-header">
          <h1><%=loc.get(149, "Does this Favor need a location?")%></h1>
        </div>
        <a href="create_requestoffer.jsp?create_loc=true" class="btn btn-primary">
          <%=loc.get(150, "Yes")%>
        </a>
        <a href="create_requestoffer.jsp" class="btn btn-default">
          <%=loc.get(151, "No")%>
        </a>            
      </div>
    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="includes/timeout.js"></script>
  </body>
</html>
