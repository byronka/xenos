<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>                                 
	<head>
		<title><%=loc.get(2, "Request Favor")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
	</head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%@ page import="com.renomad.xenos.Utils" %>
  <% 

  String qs = request.getQueryString();

  boolean need_loc =  //does the user want to enter location info?
    Boolean.parseBoolean(Utils.parse_qs(qs).get("create_loc"));

	request.setCharacterEncoding("UTF-8");
    //get the values straight from the client
    String de = "";
    String c = "";
    String cat_error_msg = "";
    String desc_error_msg = "";

    //address values
    String strt_addr_1_val = "";
    String strt_addr_2_val = "";
    String city_val        = "";
    String state_val       = "";
    String postal_val      = "";
    String country_val     = "";

    if (request.getMethod().equals("POST")) {

    // If we have any one of the location values in the POST,
    // then they came from a page having location values, so 
    // need_loc would be true.
    if (
      request.getParameter("strt_addr_1") != null ||
      request.getParameter("strt_addr_2") != null ||
      request.getParameter("city")        != null ||
      request.getParameter("state")       != null ||
      request.getParameter("postal")      != null ||
      request.getParameter("country")     != null 
      ) {
      need_loc = true;
    }


    //get values so if they are in validation mode they don't lose info.
      strt_addr_1_val = 
        Utils.get_string_no_null(request.getParameter("strt_addr_1"));

      strt_addr_2_val = 
        Utils.get_string_no_null(request.getParameter("strt_addr_2"));
      
      city_val = 
        Utils.get_string_no_null(request.getParameter("city"));

      state_val =
        Utils.get_string_no_null(request.getParameter("state"));

      postal_val = 
        Utils.get_string_no_null(request.getParameter("postal"));

      country_val = 
        Utils.get_string_no_null(request.getParameter("country"));




      boolean validation_error = false;
      de = request.getParameter("description");
      if (de.length() == 0) {
        desc_error_msg = loc.get(5, "Please enter a description");
        validation_error |= true;
      }

      //parse out the categories from a string the client gave us
      c = request.getParameter("categories");
      
      Integer[] cat = Requestoffer_utils.parse_categories_string(c, loc );
      
      if (cat.length == 0) {
        validation_error |= true;
        cat_error_msg = loc.get(8,"No categories found in string");
      }

      if (!validation_error) {
        int new_ro_id = 0;
        if ((new_ro_id = Requestoffer_utils.put_requestoffer(user_id, de, cat)) == -1) {
          response.sendRedirect("general_error.jsp");
          return;
        }
        Requestoffer_utils.put_location(
          user_id, new_ro_id,
          strt_addr_1_val, strt_addr_2_val, 
          city_val, state_val, postal_val, country_val);
        response.sendRedirect("dashboard.jsp");
        return;
      }
    }
  %>

  <body>
  <%@include file="includes/header.jsp" %>
    <form method="POST" action="create_requestoffer.jsp">

      <p><%=loc.get(10,"Description")%>: 
        <input 
          type="text" 
          maxlength=200
          name="description" 
          value="<%=de%>"/> 
        <span><%=desc_error_msg%></span>
      </p>

      <p>
        <%=loc.get(13,"Categories")%>: 
        <input type="text" name="categories" value="<%=c%>"/>
        <span><%=cat_error_msg%></span>
      </p>

      <div id='available-categories'>
				<%=Requestoffer_utils.get_categories_string(loc)%>
      </div>

      <% if (need_loc) { %>
              
        <% 
          User_location[] locations = 
            Requestoffer_utils.get_my_saved_locations(user_id);
          if (locations.length > 0) {
        %>
            <p>Select one of your saved locations:</p>
            <select name="savedlocation">
        <%
          for (User_location loca : locations) {
        %>
        <option>
          <%=loca.id%>
          <%=loca.str_addr_1%>
          <%=loca.str_addr_2%>
          <%=loca.city%>
          <%=loca.state%>
          <%=loca.postcode%>
          <%=loca.country%>
        </option>
        <%
            }
        %>
            </select>
        <%
          }
        %>

        <p>
          <%=loc.get(152,"Street Address 1")%>: 
          <input 
            type="text" name="strt_addr_1" 
            maxlength="100" value="<%=strt_addr_1_val%>"/>
        </p>
              
        <p>
          <%=loc.get(153,"Street Address 2")%>: 
          <input 
            type="text" name="strt_addr_2" 
            maxlength="100" value="<%=strt_addr_2_val%>"/>
        </p>
              
        <p>
          <%=loc.get(154,"City")%>: 
          <input 
            type="text" name="city" maxlength="40" 
            value="<%=city_val%>"/>
        </p>
              
        <p>
          <%=loc.get(155,"State")%>: 
          <input 
            type="text" name="state" 
            maxlength="30" value="<%=state_val%>"/>
        </p>
              
        <p>
          <%=loc.get(156,"Postal code")%>: 
          <input 
            type="text" name="postal" 
            maxlength="20" value="<%=postal_val%>"/>
        </p>
              
        <p>
          <%=loc.get(157,"Country")%>: 
          <input 
            type="text" name="country" 
            maxlength="40" value="<%=country_val%>"/>
        </p>

      <%  }  %>

      <button type="submit"><%=loc.get(2,"Request Favor")%></button>

    </form>
    <script type="text/javascript" src="includes/timeout.js"></script>
  </body>
</html>
