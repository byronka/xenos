                       
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
          <div id="location-section" >
            <% if (locations.length > 0) { %>

            <div class="table">
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
                      <%=Utils.safe_render(loca.details)%>
                      <%=Utils.safe_render(loca.postcode)%>
                      <%=Utils.safe_render(loca.country)%>
                      </option>
                    <%}%>
                  </select>                       
                </div>
              </div>


            <%}%>

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

              expander.textContent = "<%=loc.get(15,"Forget it - I don't need a location")%>";
              expander.style.height = "37px";
              do_the_fade(); //kick it off.
            } else {
              lo_wrapper.style.display = 'none';
              expander.textContent = '<%=loc.get(14,"Add location")%>';
              expander.style.height = "17px";
            }
          };
        </script>

        <div class="row">
            <div id="location-expander" 
                class="button expander" 
                onclick="expand_contract()" ><%=loc.get(14,"Add location")%></div>
            <button class="button" id="submitter" type="submit"><%=loc.get(2,"Request Favor")%></button>
        </div>
    </form>	
  </div>
