<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <title><%=loc.get(2, "Request Favor")%></title>	
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
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
    Integer selected_cat = null;
    String cat_error_msg = "";
    String desc_error_msg = "";
    String addr_error_msg = "";

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
      selected_cat = Utils.parse_int(request.getParameter("categories"));
      
      if (selected_cat == null) {
        validation_error |= true;
        cat_error_msg = loc.get(197,"You must choose a category for this favor");
      }

      if ( // if they said they need a location, but haven't given us any location info at all, validation error
              need_loc &&
              Utils.parse_int(savedlocation_val) == null &&
              Utils.is_null_or_empty(strt_addr_1_val) &&
              Utils.is_null_or_empty(strt_addr_2_val) &&
              Utils.is_null_or_empty(city_val) &&
              Utils.is_null_or_empty(state_val) &&
              Utils.is_null_or_empty(postal_val) &&
              Utils.is_null_or_empty(country_val)
              ) {
              validation_error |= true;
              addr_error_msg = loc.get(193,"You indicated you wanted to save a location with this favor but you entered nothing. If this does not require a location, click ") + "<a href='create_requestoffer.jsp'>" + loc.get(2, "Request Favor") + "</a>";
      }      
      
      if (!validation_error) {

        int new_ro_id = 0;

        //try adding the new requestoffer - if failed, go to error page
        if ((new_ro_id = Requestoffer_utils.put_requestoffer(user_id, de, selected_cat)) == -1) {
          response.sendRedirect("general_error.jsp");
          return;
        }

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
        response.sendRedirect("dashboard.jsp");
        return;
      }
    }
  %>
	
	<body role="document" class="backstretch-light">
    <%@include file="includes/header.jsp" %>	
	  <div class="wrapper">
	    <div class="container theme-showcase" role="main">		   	   
	     
        <div class="page-header">
	          <h1><%=loc.get(2,"Request Favor")%></h1>
	      </div>
	         		             
				<form method="POST" action="create_requestoffer.jsp" class="form-horizontal">	
					<div class="panel panel-default">
						<div class="panel-heading">
							<div class="panel-title-advanced clearfix">
                <h3 class="panel-title">
                  <%=loc.get(22,"Favor Details")%>
                </h3>
							</div>
						</div>
						<div class="panel-body">
							<div class="form-group <%if(desc_error_msg.length() > 0){out.print("has-error has-feedback");}%>">
		            <label for="description" class="col-sm-2 control-label"><%=loc.get(10,"Description")%>:</label>
		            <div class="col-sm-7">
		              <input maxlength=200 type="text" name="description" placeholder="<%=loc.get(10,"Description")%>" class="form-control" value="<%=de%>">
                  <%if(desc_error_msg.length() > 0){%>  
                  <span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>
                  <%}%> 
		            </div> 
		            <div class="col-sm-3">
                  <span class="help-block"><%=desc_error_msg%></span>
                </div>		                     
						  </div>				  
              <div class="form-group <%if(cat_error_msg.length() > 0){out.print("has-error has-feedback");}%>">
		            <label for="categories" class="col-sm-2 control-label"><%=loc.get(13,"Categories")%>:</label>
								<div class="col-sm-7">
			            <select name="categories" class="form-control">
                    <option disabled selected> -- <%=loc.get(198,"Select a Category")%> -- </option>			            
					          <% for(Integer category : Requestoffer_utils.get_all_categories()){ %>
                      <% if (category.equals(selected_cat)) {%>
                        <option class="category c-<%=category%>" selected value="<%=category%>"><%=loc.get(category,"")%></option>    
                      <%} else {%>
                        <option class="category c-<%=category%>" value="<%=category%>"><%=loc.get(category,"")%></option>    
                      <% } %>			           		             
					          <% } %>			           		             
		              </select>
		            </div>
                <div class="col-sm-3">
                  <span class="help-block"><%=cat_error_msg%></span>
                </div>                
							</div>																	
							<% if (need_loc) { %>					
							
              <div class="form-group <%if(addr_error_msg.length() > 0){out.print("has-error has-feedback");}%>">            
                <div class="col-sm-10">
                  <span class="help-block"><%=addr_error_msg%></span>
                </div>                
              </div>        																          			         
							   <% 
							     User_location[] locations = 
							       Requestoffer_utils.get_my_saved_locations(user_id);
							     if (locations.length > 0) {
							   %>
							   
                 <div class="form-group">
							   <label for="savedlocation" class="col-sm-2 control-label"><%=loc.get(158,"Select one of your saved locations")%>:</label>
								<div class="col-sm-7">
                 <select class="form-control" name="savedlocation">
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
                   </div>
                 </div>
							   <%
							     }
							   %>
              
              <div class="form-group">
                <label class="col-sm-4"><%=loc.get(159,"Or enter a new address")%>:</label>            
              </div>                							
						  <div class="form-group">
						    <label class="col-sm-4 control-label">
						      <input id="save_loc_to_user" name="save_loc_to_user" <%=save_loc_to_user_checked%> type="checkbox"/>
						        <%=loc.get(160,"Save to my favorites")%>
						    </label>					
						  </div>								 
              <div class="form-group">
                <label for=strt_addr_1 class="col-sm-2 control-label"><%=loc.get(152,"Street Address 1")%>:</label>
                <div class="col-sm-7">
                  <input maxlength=100 type="text" name="strt_addr_1" placeholder="" class="form-control" value="<%=strt_addr_1_val%>">
                </div>                      
              </div>  				
              <div class="form-group">
                <label for=strt_addr_2 class="col-sm-2 control-label"><%=loc.get(153,"Street Address 2")%>:</label>
                <div class="col-sm-7">
                  <input maxlength=100 type="text" name="strt_addr_2" placeholder="" class="form-control" value="<%=strt_addr_2_val%>">
                </div>                      
              </div>         
              <div class="form-group">
                <label for=city class="col-sm-2 control-label"><%=loc.get(154,"City")%>:</label>
                <div class="col-sm-7">
                  <input maxlength=40 type="text" name="city" placeholder="" class="form-control" value="<%=city_val%>">
                </div>                      
              </div>     
              <div class="form-group">
                <label for=state class="col-sm-2 control-label"><%=loc.get(155,"State")%>:</label>
                <div class="col-sm-7">
                  <input maxlength=30 type="text" name="state" placeholder="" class="form-control" value="<%=state_val%>">
                </div>                      
              </div>   
              <div class="form-group">
                <label for=postal class="col-sm-2 control-label"><%=loc.get(156,"Postal code")%>:</label>
                <div class="col-sm-7">
                  <input maxlength=20 type="text" name="postal" placeholder="" class="form-control" value="<%=postal_val%>">
                </div>                      
              </div>   
              <div class="form-group">
                <label for=country class="col-sm-2 control-label"><%=loc.get(157,"Country")%>:</label>
                <div class="col-sm-7">
                  <input maxlength=40 type="text" name="country" placeholder="" class="form-control" value="<%=country_val%>">
                </div>                      
              </div>                                             

							
							 <%  }  %>							
							
							
							
														
						</div>
						<div class="panel-footer clearfix">
							<div class="btn-group pull-right">
                <button type="submit" class="btn btn-primary"><%=loc.get(2,"Request Favor")%></button>
							</div>
						</div>
					</div>			
				</form>	
      </div>
    </div>

	
		<script
			src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <%@include file="includes/timeout.jsp" %>
	</body>
</html>
