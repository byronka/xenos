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
    String savedlocation_val = "";
    String save_loc_to_user_checked = "";

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
      request.getParameter("country")     != null ||
      request.getParameter("savedlocation") != null ||
      request.getParameter("save_loc_to_user") != null
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

      savedlocation_val =
        Utils.get_string_no_null(request.getParameter("savedlocation"));

      if (request.getParameter("save_loc_to_user") != null) {
        save_loc_to_user_checked = "checked";
      }


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

        //try adding the new requestoffer - if failed, go to error page
        if ((new_ro_id = Requestoffer_utils.put_requestoffer(user_id, de, cat)) == -1) {
          response.sendRedirect("general_error.jsp");
          return;
        }

        if (need_loc) {
          Integer location_id = 0;
          if ((location_id = Utils.parse_int(savedlocation_val)) != null) {
            Requestoffer_utils.assign_location_to_requestoffer(location_id, new_ro_id);
          } else {
            int uid = request.getParameter("save_loc_to_user") != null ? user_id : 0;
            Requestoffer_utils.put_location(
              uid, new_ro_id,
              strt_addr_1_val, strt_addr_2_val, 
              city_val, state_val, postal_val, country_val);
          }
        }

        response.sendRedirect("requestoffer_created.jsp?requestoffer=" + new_ro_id);
        return;
      }
    }
  %>

  <body>
  <%@include file="includes/header.jsp" %>
    <form method="POST" action="create_requestoffer.jsp">

      <p>
        <label for="description">
          <%=loc.get(10,"Description")%>: 
        </label>
        <input 
          type="text" 
          maxlength=200
          name="description" 
          value="<%=de%>"/> 
        <span><%=desc_error_msg%></span>
      </p>

      <p>
        <label for="categories">
          <%=loc.get(13,"Categories")%>: 
        </label>
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
        <p><%=loc.get(158,"Select one of your saved locations")%>:</p>
            <select name="savedlocation">
              <option><%=loc.get(192,"No address selected")%></option>
        <%
          for (User_location loca : locations) {
        %>
          <%if(Integer.toString(loca.id).equals(savedlocation_val)){%>
            <option selected value="<%=loca.id%>">
          <%} else { %>
            <option value="<%=loca.id%>">
          <% } %>
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
          <p><%=loc.get(159,"Or enter a new address")%>:</p>

        <%
          }
        %>

        <p>
          <input 
            id="save_loc_to_user" 
            name="save_loc_to_user" 
            <%=save_loc_to_user_checked%>
            type="checkbox" />
            <label for="save_loc_to_user">
              <%=loc.get(160,"Save to my favorites")%>
            </label>
        </p>
        <p>
          <label for="strt_addr_1">
            <%=loc.get(152,"Street Address 1")%>: 
          </label>
          <input 
            type="text" name="strt_addr_1" 
            maxlength="100" value="<%=strt_addr_1_val%>"/>
        </p>
              
        <p>
          <label for="strt_addr_2">
            <%=loc.get(153,"Street Address 2")%>:
          </label>
          <input 
            type="text" name="strt_addr_2" 
            maxlength="100" value="<%=strt_addr_2_val%>"/>
        </p>
              
        <p>
          <label for="city">
            <%=loc.get(154,"City")%>: 
          </label>
          <input 
            type="text" name="city" maxlength="40" 
            value="<%=city_val%>"/>
        </p>
              
        <p>
          <label for="state">
            <%=loc.get(155,"State")%>: 
          </label>
          <input 
            type="text" name="state" 
            maxlength="30" value="<%=state_val%>"/>
        </p>
              
        <p>
          <label for="postal">
            <%=loc.get(156,"Postal code")%>: 
          </label>
          <input 
            type="text" name="postal" 
            maxlength="20" value="<%=postal_val%>"/>
        </p>
              
        <p>
          <label for="country">
            <%=loc.get(157,"Country")%>: 
          </label>
          <input 
            type="text" name="country" 
            maxlength="40" value="<%=country_val%>"/>
        </p>

      <%  }  %>

      <button type="submit"><%=loc.get(2,"Request Favor")%></button>

    </form>
    <%@include file="includes/timeout.jsp" %>
  </body>
</html>
