<%@include file="includes/init.jsp" %>
<html>                                 
  <head><title><%=loc.get(15, "Create a request")%></title></head>

<%@ page import="com.renomad.xenos.Request_utils" %>
<%@ page import="com.renomad.xenos.Utils" %>
  <% 
    //get the values straight from the client
    String de = "";
    String t = "";
    String p = "";
    String c = "";
    String p_error_msg = "";
    String cat_error_msg = "";
    String desc_error_msg = "";
    String not_enough_points_error_msg = "";
    String title_error_msg = "";

    if (request.getMethod().equals("POST")) {
      boolean validation_error = false;
      de = request.getParameter("description");
      if (de.length() == 0) {
        desc_error_msg = loc.get(5, "Please enter a description");
        validation_error |= true;
      }

      t = request.getParameter("title");
      if (t.length() == 0) {
        title_error_msg = loc.get(6, "Please enter a title");
        validation_error |= true;
      }

      //extract useful information from what the client sent us
      p = request.getParameter("points");
      Integer points = Utils.parse_int(p);
      if (points == null) { 
        validation_error |= true;
        p_error_msg = loc.get(7,"Couldn't parse points");
      }

      //parse out the categories from a string the client gave us
      c = request.getParameter("categories");
      
      Integer[] cat = Request_utils.parse_categories_string(c, loc );
      
      if (cat.length == 0) {
        validation_error |= true;
        cat_error_msg = loc.get(8,"No categories found in string");
      }

      if (!validation_error) {
        Request_utils.Request_response result = 
          Request_utils.put_request(user_id, de, points, t, cat);
        if (result.status == Request_utils.Request_response.Stat.LACK_POINTS) {
          not_enough_points_error_msg = 
            loc.get(9,"You don't have enough points to make this request!");
        } else {
          response.sendRedirect("dashboard.jsp");
        }
      }
    }
  %>

  <body>
  <%@include file="includes/header.jsp" %>
    <form method="POST" action="create_request.jsp">
      <div><%=not_enough_points_error_msg %></div>
      <p><%=loc.get(10,"Description")%>: 
        <input 
          type="text" 
          name="description" 
          value="<%=de%>"/> 
      <span><%=desc_error_msg%></span>
      </p>

    <p>
      <%=loc.get(11,"Points")%>: 
      <input type="text" name="points" value="<%=p%>"/> 
      <span><%=p_error_msg%></span>
    </p>

    <p>
      <%=loc.get(12,"Title")%>: <input type="text" name="title" value="<%=t%>"/> 
      <span><%=title_error_msg%></span>
    </p>

    <p>
    <%=loc.get(13,"Categories")%>: 
    <input type="text" name="categories" value="<%=c%>"/>
    <span><%=cat_error_msg%></span>
    </p>

      <div id='available-categories'>
        <%
          Integer[] local_cat_values = Request_utils.get_category_local_values();
          for(Integer val : local_cat_values) { %>
          <%=loc.get(val,"")%>,
        <%}%>
      </div>
      <button type="submit"><%=loc.get(14,"Create Request")%></button>
    </form>
  </body>
</html>