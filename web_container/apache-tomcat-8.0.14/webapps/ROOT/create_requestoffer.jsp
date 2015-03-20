<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <title><%=loc.get(2, "Request Favor")%></title>	
		<meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="includes/reset.css">
   <link rel="stylesheet" href="includes/header.css" title="desktop">
   <link rel="stylesheet" href="create_requestoffer.css" title="desktop">
	</head>
	
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.User_location" %>
<%@ page import="com.renomad.xenos.Utils" %>

  <% 

  String qs = request.getQueryString();

  request.setCharacterEncoding("UTF-8");
    //get the values straight from the client
    String de = "";
    Integer selected_cat = null;
    boolean has_cat_error = false;
    boolean has_desc_error = false;
    boolean has_size_error = false;

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

      de = request.getParameter("description").trim();
      if (de.length() == 0) {
        has_desc_error = true;
        validation_error |= true;
      }

      //parse out the categories from a string the client gave us
      selected_cat = Utils.parse_int(request.getParameter("categories"));
      
      if (selected_cat == null) {
        validation_error |= true;
        has_cat_error = true;
      }

      boolean user_entered_a_location = 
        Utils.parse_int(savedlocation_val) != null ||
        !Utils.is_null_or_empty(strt_addr_1_val) ||
        !Utils.is_null_or_empty(strt_addr_2_val) ||
        !Utils.is_null_or_empty(city_val) ||
        !Utils.is_null_or_empty(state_val) ||
        !Utils.is_null_or_empty(postal_val) ||
        !Utils.is_null_or_empty(country_val);
      
      if (!validation_error) {

        Requestoffer_utils.Put_requestoffer_result prr = null;
        int new_ro_id = 0;

        //try adding the new requestoffer - if failed, go to error page
        if ((prr = Requestoffer_utils.put_requestoffer(user_id, de, selected_cat)).pe == Requestoffer_utils.Pro_enum.GENERAL_ERROR) {
          response.sendRedirect("general_error.jsp");
          return;
        }
        new_ro_id = prr.id; //get the requestoffer id from the result.

        if (prr.pe == Requestoffer_utils.Pro_enum.DATA_TOO_LARGE) {
          has_size_error = true;
          return;
        }
       
        //if we got here, a requestoffer was successfully added.
        if (user_entered_a_location) {

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
	     
    <div>
        <h1><%=loc.get(2,"Request Favor")%></h1>
    </div>
                       
    <form method="POST" action="create_requestoffer.jsp">	
      <fieldset>
      <legend><%=loc.get(22,"Favor Details")%></legend>
      <div>
        <label for="description">* <%=loc.get(10,"Description")%>:</label>
        <textarea 
          id="description"
          maxlength="200" 
          name="description" 
          placeholder="<%=loc.get(10,"Description")%>" ><%=de%></textarea>
        <%if(has_size_error){%>  
        <span class="error"><%=loc.get(208,"Description text too large - please stay within 200 characters")%></span>
        <%}%> 
        <%if(has_desc_error){%>  
        <span class="error"><%=loc.get(5, "Please enter a description")%></span>
        <%}%> 
      </div>
      <div>
        <label for="categories">* <%=loc.get(13,"Categories")%>:</label>
        <select 
          id="categories" 
          name="categories" >
              <option disabled selected> -- <%=loc.get(198,"Select a Category")%> -- </option>			            
          <% for(Integer category : Requestoffer_utils.get_all_categories()){ %>
            <% if (category.equals(selected_cat)) {%>
              <option selected value="<%=category%>"><%=loc.get(category,"")%></option>    
            <%} else {%>
              <option value="<%=category%>"><%=loc.get(category,"")%></option>    
            <% } %>			           		             
          <% } %>			           		             
        </select>
        <%if(has_cat_error){%>  
          <span class="error">
            <%=loc.get(197,"You must choose a category for this favor")%>
          </span>
        <%}%> 
      </div>
    </fieldset>
      <fieldset>
        <legend>Location</legend>
        </span>

          <% 
          User_location[] locations = 
          Requestoffer_utils.get_my_saved_locations(user_id);
          if (locations.length > 0) {
          %>

        <div>
          <label for="savedlocation"><%=loc.get(158,"Select one of your saved locations")%>:</label>
          <select 
            id="savedlocation" 
            name="savedlocation">
            <option><%=loc.get(192,"No address selected")%></option>
            <%for (User_location loca : locations) {%>
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
            <%}%>
          </select>                       
        </div>

          <h4 class="enternew"><%=loc.get(159,"Or enter a new address")%>:</h4>            

          <%}%>

        <div>
          <label for="save_loc_to_user"><%=loc.get(160,"Save to my favorites")%></label>
          <input id="save_loc_to_user" name="save_loc_to_user" <%=save_loc_to_user_checked%> type="checkbox"/>
        </div>
          
        <div>
          <label for="strt_addr_1"><%=loc.get(152,"Street Address 1")%>:</label>
          <input maxlength=100 type="text" id="strt_addr_1" name="strt_addr_1" value="<%=strt_addr_1_val%>">
        </div>
          
        <div>
          <label for="strt_addr_2"><%=loc.get(153,"Street Address 2")%>:</label>
          <input maxlength=100 type="text" id="strt_addr_2" name="strt_addr_2" value="<%=strt_addr_2_val%>">
        </div>
          
        <div>
          <label for="city"><%=loc.get(154,"City")%>:</label>
          <input maxlength=40 type="text" id="city" name="city" value="<%=city_val%>">
        </div>
          
        <div>
          <label for="state"><%=loc.get(155,"State")%>:</label>
          <input maxlength=30 type="text" id="state" name="state" value="<%=state_val%>">
        </div>
          
        <div>
          <label for="postal" ><%=loc.get(156,"Postal code")%>:</label>
          <input maxlength=20 type="text" id="postal" vname="postal" value="<%=postal_val%>">
        </div>
          
        <div>
          <label for="country"><%=loc.get(157,"Country")%>:</label>
          <input maxlength=40 type="text" id="country" vname="country" value="<%=country_val%>">
        </div>

      </fieldset>
      <button type="submit"><%=loc.get(2,"Request Favor")%></button>
    </form>	
	</body>
</html>
