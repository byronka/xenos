    <form method="POST" action="advanced_search.jsp">

    <div class="form-row">
      <label for="desc_input"><%=loc.get(10,"Description")%>: </label>
      <input type="text" id="desc_input" name="desc" value="<%=Utils.safe_render(desc)%>"/> 
    </div>

    <div class="form-row">
      <label for="distance_input"><%=loc.get(212,"Distance")%>: </label>
      <input id="distance_input" name="distance" placeholder="3.5" value="<%=distance%>"/> 
    </div>

    <div class="form-row">
      <label for="postcode_input"><%=loc.get(156,"Postal code")%>: </label>
      <input type="text" id="postcode_input" placeholder="12345" name="postcode" value="<%=Utils.safe_render(postcode)%>"/> 
    </div>
    <% if (has_distance_error) { %>
      <span class="error">
        <%=loc.get(213,"distance error")%>
      </span>
    <% } %>

    <div class="form-row">
      <label for="startdate_input"><%=loc.get(86,"Start date")%>: </label>
      <input type="date" id="startdate_input" name="startdate" placeholder="2012-10-31" value="<%=startdate%>" /> 
    </div>
    <% if (has_st_da_error) { %>
      <span class="error">
        <%=loc.get(83,"Invalid date")%>
      </span>
    <% } %>

    <div class="form-row">
      <label for="enddate_input"><%=loc.get(87,"End date")%>: </label>
      <input type="date" id="enddate_input" name="enddate" placeholder="2012-10-31" value="<%=enddate%>" /> 
    </div>
    <% if (has_end_da_error) { %>
      <span class="error">
        <%=loc.get(83,"Invalid date")%>
      </span>
    <% } %>

      <%for (int s : Requestoffer_utils.get_requestoffer_statuses()) {%>
        <div class="form-row">
          <label for="status_checkbox_<%=s%>"><%=loc.get(s,"")%></label>
          <% if(java.util.Arrays.asList(statuses).contains(Integer.toString(s))) { %>
            <input type="checkbox" id="status_checkbox_<%=s%>" checked name="statuses" value="<%=s%>" />
          <% } else { %>
            <input type="checkbox" id="status_checkbox_<%=s%>" name="statuses" value="<%=s%>" />
          <% } %>
        </div>
      <% } %>

    <div class="form-row">
      <label for="users_input"><%=loc.get(80,"User")%>: </label>
      <input type="text" id="users_input" name="users" value="<%=users%>" />
    </div>
    <% if (has_user_error) { %>
      <span class="error">
        <%=loc.get(85,"No users found in string")%>
      </span>
    <% } %>


      <%for(int c : Requestoffer_utils.get_all_categories()) {%>
      <div class="form-row"> 
        <label for="cat_checkbox_<%=c%>"><%=loc.get(c,"")%></label>
          <% if(java.util.Arrays.asList(categories).contains(Integer.toString(c))) { %>
            <input type="checkbox" id="cat_checkbox_<%=c%>" checked name="categories" value="<%=c%>" />
          <% } else { %>
            <input type="checkbox" id="cat_checkbox_<%=c%>" name="categories" value="<%=c%>" />
          <% } %>
        </div>
      <%}%>

      <button type="submit"><%=loc.get(1,"Search")%></button>
    </form>
