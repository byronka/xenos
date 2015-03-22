                       
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
