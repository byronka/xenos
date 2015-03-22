    <form method="POST" action="advanced_search.jsp">

    <h3><%=loc.get(10,"Description")%></h3>
    <div class="help-text">
      <%=loc.get(90,"Enter words to search in a description")%>
    </div>
    <div class="form-row">
      <label for="desc_input"><%=loc.get(10,"Description")%>: </label>
      <input type="text" id="desc_input" name="desc" value="<%=desc%>"/> 
    </div>

    <h3><%=loc.get(156,"Postal code")%></h3>
    <div class="help-text">
      <%=loc.get(162,"Enter a postal code to search")%>
    </div>
    <div class="form-row">
      <label for="postcode_input"><%=loc.get(156,"Postal code")%>: </label>
      <input type="text" id="postcode_input" name="postcode" value="<%=postcode%>"/> 
    </div>

    <h3><%=loc.get(79,"Rank")%></h3>
    <div class="help-text">
      <%=loc.get(161,"Enter a ranking value between 0.0 and 1.0")%>
    </div>
    <div class="form-row">
      <label for="minrank_input"><%=loc.get(14,"Minimum Rank")%>: </label>
      <input type="text" id="minrank_input" name="minrank" value="<%=minrank%>"/> 
    </div>
    <% if (has_min_rank_error) { %>
      <span class="error">
        <%=loc.get(163,"invalid - must be a number between 0.0 and 1.0")%>
      </span>
    <% } %>
    <% if (has_min_rank_greater_error) { %>
      <span class="error">
        <%=loc.get(164,"invalid - maximum rank must be greater than minimum rank")%>
      </span>
    <% } %>

    <div class="help-text">
      <%=loc.get(161,"Enter a ranking value between 0.0 and 1.0")%>
    </div>
    <div class="form-row">
      <label for="maxrank_input"><%=loc.get(15,"Maximum Rank")%>: </label>
      <input type="text" id="maxrank_input" name="maxrank" value="<%=maxrank%>"/> 
    </div>
    
    <% if (has_max_rank_error) { %>
      <span class="error">
        <%=loc.get(163,"invalid - must be a number between 0.0 and 1.0")%>
      </span>
    <% } %>
    <% if (has_max_rank_lesser_error) { %>
      <span class="error">
        <%=loc.get(164,"invalid - maximum rank must be greater than minimum rank")%>
      </span>
    <% } %>

    <h3><%=loc.get(25,"Date")%></h3>
    <div class="form-row">
      <label for="startdate_input"><%=loc.get(86,"Start date")%>: </label>
      <input type="text" id="startdate_input" name="startdate" placeholder="2012-10-31" value="<%=startdate%>" /> 
    </div>
    <% if (has_st_da_error) { %>
      <span class="error">
        <%=loc.get(83,"Invalid date")%>
      </span>
    <% } %>

    <div class="form-row">
      <label for="enddate_input"><%=loc.get(87,"End date")%>: </label>
      <input type="text" id="enddate_input" name="enddate" placeholder="2012-10-31" value="<%=enddate%>" /> 
    </div>
    <% if (has_end_da_error) { %>
      <span class="error">
        <%=loc.get(83,"Invalid date")%>
      </span>
    <% } %>

		<h3><%=loc.get(24,"Status")%></h3>
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

		<h3><%=loc.get(80,"User")%></h3>
    <div class="help-text">
      <%=loc.get(91,"Enter one or more usernames separated by spaces")%>
    </div>
    <div class="form-row">
      <label for="users_input"><%=loc.get(80,"User")%>: </label>
      <input type="text" id="users_input" name="users" value="<%=users%>" />
    </div>
    <% if (has_user_error) { %>
      <span class="error">
        <%=loc.get(85,"No users found in string")%>
      </span>
    <% } %>


		<h3><%=loc.get(13,"Categories")%></h3>
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
