  <div class="container">
  <div class="table">
    <form method="POST" action="advanced_search.jsp">
    <% if (validation_error) { %>
      <h3 class="error">Invalid input received - check and resubmit</h3>
    <% } %>

    <div class="row">
      <label for="desc_input"><%=loc.get(10,"Description")%>: </label>
      <input type="text" id="desc_input" name="desc" value="<%=Utils.safe_render(desc)%>"/> 
    </div>

    <div class="row">
      <label for="distance_input"><%=loc.get(212,"Distance")%>: </label>
      <input type="text" id="distance_input" name="distance" value="<%=distance == null ? "" : distance%>"/> 
    </div>
    <% if (has_distance_error) { %>
      <span class="error">
        <%=loc.get(213,"distance error - needs to be a number")%>
      </span>
    <% } %>

    <div class="row">
      <label for="postcode_input"><%=loc.get(156,"Postal code")%>: </label>
      <input type="text" id="postcode_input" 
        name="postcode" value="<%=Utils.safe_render(postcode)%>"/> 
    </div>

    <div class="row">
      <label for="startdate_input"><%=loc.get(86,"Start date")%>: </label>
      <input type="text" id="startdate_input" 
        name="startdate"  value="<%=startdate%>" /> 
    </div>
    <% if (has_st_da_error) { %>
      <span class="error">
        <%=loc.get(83,"Invalid date - try something like 2014-1-2 for January 2, 2014")%>
      </span>
    <% } %>

    <div class="row">
      <label for="enddate_input"><%=loc.get(87,"End date")%>: </label>
      <input type="text" id="enddate_input" 
        name="enddate" value="<%=enddate%>" /> 
    </div>
    <% if (has_end_da_error) { %>
      <span class="error">
        <%=loc.get(83,"Invalid date - try something like 2014-1-2 for January 2, 2014")%>
      </span>
    <% } %>

      <%for (int s : Requestoffer_utils.get_requestoffer_statuses()) {%>
        <div class="row">
          <label for="status_checkbox_<%=s%>"><%=loc.get(s,"")%></label>
          <% if(java.util.Arrays.asList(statuses).contains(Integer.toString(s))) { %>
            <input type="checkbox" id="status_checkbox_<%=s%>" checked name="statuses" value="<%=s%>" />
          <% } else { %>
            <input type="checkbox" id="status_checkbox_<%=s%>" name="statuses" value="<%=s%>" />
          <% } %>
        </div>
      <% } %>

    <div class="row">
      <label for="users_input"><%=loc.get(80,"User")%>: </label>
      <input type="text" id="users_input" name="users" value="<%=users%>" />
    </div>
    <% if (has_user_error) { %>
      <span class="error">
        <%=loc.get(85,"No users found in string")%>
      </span>
    <% } %>


      <%for(int c : Requestoffer_utils.get_all_categories()) {%>
      <div class="row"> 
        <label for="cat_checkbox_<%=c%>"><%=loc.get(c,"")%></label>
          <% if(java.util.Arrays.asList(categories).contains(Integer.toString(c))) { %>
            <input type="checkbox" id="cat_checkbox_<%=c%>" checked name="categories" value="<%=c%>" />
          <% } else { %>
            <input type="checkbox" id="cat_checkbox_<%=c%>" name="categories" value="<%=c%>" />
          <% } %>
        </div>
      <%}%>

      <button class="button" type="submit"><%=loc.get(1,"Search")%></button>
    </form>
  </div>
  </div>
