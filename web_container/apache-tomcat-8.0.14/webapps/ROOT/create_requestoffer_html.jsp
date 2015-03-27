                       
<div class="container">
    <form method="POST" action="create_requestoffer.jsp">	
      <div class="table" id="basic-section">
        <div class="row">
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
        <div class="row">
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
      </div>


          <% 
            User_location[] locations = 
            Requestoffer_utils.get_my_saved_locations(logged_in_user_id);
          %>


      <% if (user_entered_a_location  || user_selected_a_location) {%>
        <div id="location-wrapper">
      <% } else { %>
        <div style="display:none" id="location-wrapper">
      <% } %>
          <div class="table" id="location-section" >
            <% if (locations.length > 0) { %>

              <div class="row">
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

              <div class="enternew"><em><%=loc.get(159,"Or enter a new address")%>:</em></div>

            <%}%>

          <div class="row">
            <label for="save_loc_to_user"><%=loc.get(160,"Save to my favorites")%></label>
            <input id="save_loc_to_user" name="save_loc_to_user" <%=save_loc_to_user_checked%> type="checkbox"/>
          </div>
            
          <div class="row">
            <label for="strt_addr_1"><%=loc.get(152,"Street Address 1")%>:</label>
            <input maxlength=100 type="text" id="strt_addr_1" name="strt_addr_1" value="<%=strt_addr_1_val%>">
          </div>
            
          <div class="row">
            <label for="strt_addr_2"><%=loc.get(153,"Street Address 2")%>:</label>
            <input maxlength=100 type="text" id="strt_addr_2" name="strt_addr_2" value="<%=strt_addr_2_val%>">
          </div>
            
          <div class="row">
            <label for="city"><%=loc.get(154,"City")%>:</label>
            <input maxlength=40 type="text" id="city" name="city" value="<%=city_val%>">
          </div>
            
          <div class="row">
            <label for="state"><%=loc.get(155,"State")%>:</label>
            <input maxlength=30 type="text" id="state" name="state" value="<%=state_val%>">
          </div>
            
          <div class="row">
            <label for="postal" ><%=loc.get(156,"Postal code")%>:</label>
            <input maxlength=20 type="text" id="postal" name="postal" value="<%=postal_val%>">
          </div>
            
          <div class="row">
            <label for="country"><%=loc.get(157,"Country")%>:</label>
            <input maxlength=40 type="text" id="country" name="country" value="<%=country_val%>">
          </div>
        </div>
      </div>

        <script>
          var expand_contract = function() {
            var lo_wrapper = document.getElementById('location-wrapper');
            var expander = document.getElementById('location-expander');
            if (lo_wrapper.style.display == 'none' || lo_wrapper.style.display == '') {
              lo_wrapper.style.opacity = 0;
              lo_wrapper.style.display = 'block';

              var do_the_fade = function() {
                var curr_opac = lo_wrapper.style.opacity;
                curr_opac = Number(curr_opac) + 0.1;
                lo_wrapper.style.opacity = curr_opac;
                if (curr_opac < 1) { 
                  setTimeout(do_the_fade,40);
                }
              };

              expander.textContent = "Forget it - I don't need a location";
              expander.style.height = "37px";
              do_the_fade(); //kick it off.
            } else {
              lo_wrapper.style.display = 'none';
              expander.textContent = "Add location";
              expander.style.height = "17px";
            }
          };
        </script>

    <table>
      <tbody>
        <tr>
          <td>
            <div id="location-expander" 
                style="width: 80px;" 
                class="button expander" 
                onclick="expand_contract()" >Add location</div>
          </td>
          <td>
            <button class="button" id="submitter" type="submit"><%=loc.get(2,"Request Favor")%></button>
          </td>
        </tr>
      </tbody>
    </table>
    </form>	
  </div>
