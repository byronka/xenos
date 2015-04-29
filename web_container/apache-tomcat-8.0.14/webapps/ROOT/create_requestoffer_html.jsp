<div class="container">

    <form method="POST" action="create_requestoffer.jsp">	
      <input type="hidden" name="country_id" id="country_id" value="<%=country_id%>">
      <input type="hidden" name="postal_code_id" id="postal_code_id" value="<%=postal_code_id%>">
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

      <div class="table">
        <div class="row">
            <button class="button" id="submitter" type="submit"><%=loc.get(2,"Request Favor")%></button>
        </div>
      </div>

        </div>
      </div>
    </form>	

  </div>
