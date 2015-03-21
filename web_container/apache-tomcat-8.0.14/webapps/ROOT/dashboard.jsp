<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>                                 
  <head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="dashboard.css" >
    <link rel="stylesheet" href="includes/header.css" >
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=loc.get(16,"The dashboard")%></title>
  </head>

<body>
<%@include file="includes/header.jsp" %>
<div id="overall-container">

<% // ADVANCED SEARCH STARTS %>

<%

request.setCharacterEncoding("UTF-8");
String[] statuses = new String[0];
String desc = "";
String startdate = "";
String enddate = "";
String users = "";
String minrank = "";
String maxrank = "";
String postcode = "";
String[] categories = new String[0];

String stat_error_msg = "";
String st_da_error_msg = ""; //date
String end_da_error_msg = ""; //date
String user_error_msg = ""; 
String min_rank_error_msg = ""; 
String max_rank_error_msg = ""; 

if (request.getMethod().equals("POST")) {
  boolean validation_error = false;

  //these guys don't require validation.
  if ((desc = request.getParameter("desc")) == null) {
    desc = "";
  }

  if ((postcode = request.getParameter("postcode")) == null) {
    postcode = "";
  }
  postcode = Utils.safe_render(postcode);


  Float minrankvalue = null;
  Float maxrankvalue = null;

  // rank has to be from 0.0 to 1.0
  minrank = request.getParameter("minrank");
  maxrank = request.getParameter("maxrank");

  // check that minrank is either empty or a valid number
  if (Utils.is_null_or_empty(minrank)) {
    minrank = "";
  } else {
    try{
      minrankvalue = Float.valueOf(minrank);
      if ( !(minrankvalue >= 0.0 && minrankvalue <= 1.0)) {
        min_rank_error_msg = 
          loc.get(163,"invalid - must be a number between 0.0 and 1.0");
        validation_error |= true;
      }
    } catch (Exception ex) {
      validation_error |= true;
      min_rank_error_msg = 
        loc.get(163,"invalid - must be a number between 0.0 and 1.0");
    }
  }

  // check that maxrank is either empty or a valid number
  if (Utils.is_null_or_empty(maxrank)) {
    maxrank = "";
  } else {
    try{
      maxrankvalue = Float.valueOf(maxrank);
      if ( !(maxrankvalue >= 0.0 && maxrankvalue <= 1.0)) {
        max_rank_error_msg = 
          loc.get(163,"invalid - must be a number between 0.0 and 1.0");
        validation_error |= true;
      }
    } catch (Exception ex) {
      validation_error |= true;
      max_rank_error_msg = 
        loc.get(163,"invalid - must be a number between 0.0 and 1.0");
    }
  }
  
  // make sure that minrank is less than maxrank
  if (maxrankvalue != null && minrankvalue != null && 
        (maxrankvalue - minrankvalue) < 0) {
      validation_error |= true;
      min_rank_error_msg = 
        loc.get(164,"invalid - maximum rank must be greater than minimum rank");
      max_rank_error_msg = 
        loc.get(164,"invalid - maximum rank must be greater than minimum rank");
  }


  //parse out the statuses from a string the client gave us
  if ((statuses = request.getParameterValues("statuses")) == null) {
    statuses = new String[0];
  }

  //parse out the date
  if ((startdate = request.getParameter("startdate")) == null) {
    startdate = "";
  }
  if ((enddate = request.getParameter("enddate")) == null) {
    enddate = "";
  }

  //a proper date will look like:
  // 2014-12-18
  // or 0000 to 9999, dash, 0 to 12, number varying between 1 
  // and 31 depending on month,space
  //, 0 to 23, colon, 0 to 59, colon, 0 to 59
  if(startdate.length() > 0 && !Utils.is_valid_date(startdate)) {
    validation_error |= true;
    st_da_error_msg = loc.get(83,"Invalid date");
  }
  if(enddate.length() > 0 && !Utils.is_valid_date(enddate)) {
    validation_error |= true;
    end_da_error_msg = loc.get(83,"Invalid date");
  }

  //parse out the user
  if ((users = request.getParameter("users")) == null) {
    users = "";
  }

  //split the users string on one or more whitespace or one 
  //or more non-word chars.
  String[] split_user_names = users.split("\\s+?|\\W+?"); 

  String user_ids = User_utils
    .get_user_ids_by_names(split_user_names);

  if ((user_ids == null || user_ids.equals("")) && 
      users.length() > 0) {
    validation_error |= true;
    user_error_msg = loc.get(85,"No users found in string");
  }

  if ((categories = request.getParameterValues("categories")) == null) {
    categories = new String[0];
  }

  if(!validation_error) {
    String dashboard_string = String.format(
      "dashboard.jsp?da=%s,%s&cat=%s&us=%s&sta=%s&desc=%s&minrank=%f&maxrank=%f&postcode=%s",
      startdate,
      enddate,
      Utils.string_array_to_string(categories),
      user_ids,
      Utils.string_array_to_string(statuses),
      desc,
      minrankvalue,
      maxrankvalue,
      postcode );
    response.sendRedirect(dashboard_string);
    return;
  }
}
  
%>

<div id="search_section">
    <div>
        <h3><%=loc.get(81,"Advanced Search")%></h3>
    </div>
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
    <span class="error"><%=min_rank_error_msg%></span>

    <div class="help-text">
      <%=loc.get(161,"Enter a ranking value between 0.0 and 1.0")%>
    </div>
    <div class="form-row">
      <label for="maxrank_input"><%=loc.get(15,"Maximum Rank")%>: </label>
      <input type="text" id="maxrank_input" name="maxrank" value="<%=maxrank%>"/> 
    </div>
    <span class="error"><%=max_rank_error_msg%></span>

    <h3><%=loc.get(25,"Date")%></h3>
    <div class="form-row">
      <label for="startdate_input"><%=loc.get(86,"Start date")%>: </label>
      <input type="text" id="startdate_input" name="startdate" placeholder="2012-10-31" value="<%=startdate%>" /> 
    </div>
    <span class="error"><%=st_da_error_msg%></span>

    <div class="form-row">
      <label for="enddate_input"><%=loc.get(87,"End date")%>: </label>
      <input type="text" id="enddate_input" name="enddate" placeholder="2012-10-31" value="<%=enddate%>" /> 
    </div>
    <span class="error"><%=end_da_error_msg%></span>

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
    <span class="error"><%=user_error_msg%></span>


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
</div>


<% // ADVANCED SEARCH ENDS %>

<div id="see-and-create-requestoffer">

<% // REQUESTOFFER ENTRIES START%>

  <div id="ro-container">
    <%@ page import="com.renomad.xenos.Requestoffer_utils" %>
    <%@ page import="com.renomad.xenos.Requestoffer" %>
    <%@ page import="com.renomad.xenos.Utils" %>
    <%@ page import="com.renomad.xenos.Others_Requestoffer" %>
    <%

      String thequerystring = request.getQueryString();

      java.util.Map<String,String> params = Utils.parse_qs(thequerystring);

      //extract dates
      String srch_date = params.get("da"); 
      String srch_startdate = null;
      String srch_enddate = null;
      if (srch_date != null) {
        String[] srch_dates = srch_date.split(",");
        if (srch_dates.length > 0) {
          srch_startdate = srch_dates[0];
        }
        if (srch_dates.length > 1) {
          srch_enddate = srch_dates[1];
        }
      }

      String srch_cat = params.get("cat"); //categories
      String srch_desc = params.get("desc"); // description
      String srch_us = params.get("us"); //users
      String srch_sta = params.get("sta"); //status
      String srch_minrank = params.get("minrank"); //rank
      String srch_maxrank = params.get("maxrank"); //rank
      String srch_postcode = params.get("postcode"); //postcode

      Integer which_page = Utils.parse_int(params.get("page"));
      if (which_page == null) {which_page = 0;}
    %>

    <%
      String decoded_srch_desc = "";
      if (srch_desc != null) {
        decoded_srch_desc = java.net.URLDecoder.decode(srch_desc, "UTF-8");
      }
      // if the user has not specifically asked to see closed and taken,
      // we will default to showing just "OPEN"
      if (Utils.is_null_or_empty(srch_sta)) {
        srch_sta = "76"; // "OPEN"
      }
      Requestoffer_utils.Search_Object so = 
        new Requestoffer_utils.Search_Object(  
                                          srch_startdate, 
                                          srch_enddate, 
                                          srch_cat, 
                                          decoded_srch_desc,
                                          srch_sta, 
                                          srch_us,
                                          srch_minrank,
                                          srch_maxrank,
                                          srch_postcode
                                          );
      Requestoffer_utils.OR_Package or_package = 
        Requestoffer_utils.get_others_requestoffers(user_id, 
                                          so , 
                                          which_page);
      for (Others_Requestoffer r : or_package.get_requestoffers()) { %>
      <%int l_step = Requestoffer_utils.get_ladder_step(r.rank_ladder);%>
      <a class="requestoffer rank_<%=l_step%>" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
        <ul>
          <li>
          <div class="desc container <%if(r.status == 77 ){%><%="taken"%><%}%>">
                <%=Utils.safe_render(r.description)%>
                <div class="datetime">
                  <span><%=loc.get(25, "Date")%>: <%=r.datetime%></span>
                </div>
             </div> 
            <div class="category c-<%=r.category%>" />
          </li>
          <li class="requestoffering-user-id">
            <label><%=loc.get(80, "User")%>:</label>
            <%
              User ru = User_utils.get_user(r.requestoffering_user_id);
            %>
            <span> <%=Utils.safe_render(ru.username)%></span>
          </li>
          <li class="categories">
            <label><%=loc.get(13, "Categories")%>:</label>
            <span >
              <%=loc.get(r.category,"")%> 
            </span>
          </li>

        </ul>
      </a>
    <% } %>

    <%if(or_package.page_count > 1) {%>
      <span><%=loc.get(93, "Page")%>: </span>
      <% 	
      String qs_without_page = "";
      if (!Utils.is_null_or_empty(thequerystring)) {
        qs_without_page = thequerystring.replaceAll("&{0,1}page=[0-9]+","");
      }
      for (int i = 0; i < or_package.page_count; i++) {
        if (which_page == i) {%>
        <a 
          href="dashboard.jsp?<%=qs_without_page%>&amp;page=<%=i%>" 
          class="page-link current-page"><%=i+1%></a>
        <% } else {%>
        <a class="page-link" href="dashboard.jsp?<%=qs_without_page%>&amp;page=<%=i%>"><%=i+1%></a>
        <%  }
      }%>
    <%}%>

  </div>

<% // REQUESTOFFER ENTRIES END %>

<% // CREATE REQUESTOFFER STARTS %>

<div id="create-requestoffer-container">

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
	
    <div>
        <h3><%=loc.get(2,"Request Favor")%></h3>
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
  </div>
<% // CREATE REQUESTOFFER ENDS %>
</div>

<% // MY PROFILE STARTS %>

<div id="profile-container">
  <div>
      <h3><%=loc.get(97,"My Profile")%></h3>
  </div>
  <p>
    <a href="change_password.jsp"><%=loc.get(113,"Change password")%></a>
  </p>
  <p>
    <a href="generate_icode.jsp"><%=loc.get(206,"Generate invitation code")%></a>
  </p>

  <h3><%=Utils.safe_render(user.username)%></h3>
  <ul>
    <li>Rank average: <%=user.rank_av%></li>
    <%int l_step = Requestoffer_utils.get_ladder_step(user.rank_ladder);%>
    <li>Rank ladder: <%=l_step%></li>
    <li>Points: <%=user.points%></li>
  </ul>

  <h3><%=loc.get(79, "Rank")%></h3>

  <%
    Requestoffer_utils.Rank_detail[] rank_details = 
      Requestoffer_utils.get_rank_detail(user_id);
  %>

    <%if (rank_details.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
    <% } %> 

  <%	for (Requestoffer_utils.Rank_detail rd : rank_details) { %>

  <% if (rd.status_id == 2 || rd.status_id == 3) { 
      //don't even show a particular line unless status is 2 or 3
  %>

    <%
    //there's two parties here: the judging and the judged
    if (rd.judging_user_id == user_id) { // if we are the judge
    %>

      <div class="rank-detail">
        <%=rd.timestamp%>
        <%=loc.get(165,"You")%>

        <% if(rd.status_id == 3) {%>
          <% if (rd.meritorious) { %>
            <%=loc.get(166,"increased")%>
          <% } else { %>
            <%=loc.get(167,"decreased")%>
          <% } %>
        <% } %>
          
        <% if (rd.status_id == 2) { %>
        <a href="judge.jsp?urdp=<%=rd.urdp_id%>">
            <%=loc.get(181,"have not yet determined")%>
          </a>
        <% }  %>


          <%=loc.get(168,"the reputation of")%>
        <a href="user.jsp?user_id=<%=rd.judged_user_id%>">
          <%=Utils.safe_render(rd.judged_username)%>
        </a>

        <%=loc.get(170,"for the favor")%>
        <a href="requestoffer.jsp?requestoffer=<%=rd.ro_id%>">
          <%=Utils.safe_render(rd.ro_desc)%>
        </a>

      </div>
      <%if (rd.comment.length() > 0) {%>
        <%=loc.get(165,"You")%>
        commented: "<%=rd.comment%>"
      <%}%>

    <%
    } else { //if we are the judged
    %>

      <div class="rank-detail">
        <%=rd.timestamp%>
        <a href="user.jsp?user_id=<%=rd.judging_user_id%>">
          <%=Utils.safe_render(rd.judging_username)%>
        </a>

        <% if(rd.status_id == 3) {%>
          <% if (rd.meritorious) { %>
            <%=loc.get(166,"increased")%>
          <% } else { %>
            <%=loc.get(167,"decreased")%>
          <% } %>
        <% } else { %>
          <%=loc.get(180,"has not yet determined")%>
        <% }  %>
        
        <%=loc.get(169,"your reputation")%>
        <%=loc.get(170,"for the favor")%>

        <a href="requestoffer.jsp?requestoffer=<%=rd.ro_id%>">
          <%=Utils.safe_render(rd.ro_desc)%>
        </a>

      </div>

      <%if (rd.comment.length() > 0) {%>
        <a href="user.jsp?user_id=<%=rd.judging_user_id%>">
          <%=Utils.safe_render(rd.judging_username)%>
        </a>
        commented: "<%=rd.comment%>"
      <%}%>
    <% } %>

    <% } %>
  <% }  %>

  <h3><%=loc.get(119, "Favors I have offered to service")%></h3>
		<%
			Requestoffer_utils.Offer_I_made[] offers = 
				Requestoffer_utils
        .get_requestoffers_I_offered_to_service(user_id);
    %>

    <%if (offers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
    <% } %> 

    <%	for (Requestoffer_utils.Offer_I_made o : offers) { %>
			<div class="requestoffer serviceoffered">
        <a 
          href="requestoffer.jsp?requestoffer=<%=o.requestoffer_id%>">
          <%=Utils.get_trunc(Utils.safe_render(o.description), 15)%>
        </a>
			</div>
		<% } %>

  <h3><%=loc.get(120, "Offers to service my favors")%></h3>
		<%
			Requestoffer_utils.Service_request[] service_requests = 
				Requestoffer_utils.get_service_requests(user_id);
    %>

    <%if (service_requests.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
    <% } %> 

    <%for (Requestoffer_utils.Service_request sr : service_requests) { %>
			<div class="servicerequest">
        <%User servicer = User_utils.get_user(sr.user_id);%>
        
        <a href="user.jsp?user_id=<%=sr.user_id%>">
          <%=Utils.safe_render(servicer.username)%> 
        </a>
        <%=loc.get(138,"wants to service")%>
        <a href="requestoffer.jsp?requestoffer=<%=sr.requestoffer_id%>">
          <%=Utils.get_trunc(Utils.safe_render(sr.desc),15)%>
        </a>
        <a href="choose_handler.jsp?requestoffer=<%=sr.requestoffer_id%>&user=<%=sr.user_id%>">
          <%=loc.get(137,"Choose")%>
        </a>
			</div>
		<% } %>

  <h3><%=loc.get(102, "Favors I am handling")%>:</h3>
		<%
			Requestoffer[] handling_requestoffers = 
				Requestoffer_utils.get_requestoffers_I_am_handling(user_id);
    %>

    <%if (handling_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
    <% } %> 

    <%	for (Requestoffer r : handling_requestoffers) { %>
			<div class="requestoffer handling">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description),15)%> 
        </a>
        <a href="cancel_active_favor.jsp?requestoffer=<%=r.requestoffer_id%>">
          <%=loc.get(130,"Cancel")%>
        </a>
			</div>
		<% } %>

	<h3 class="my-requestoffers-header">
		<%=loc.get(124, "My closed Favors")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_closed_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(user_id,77);
        if (my_closed_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_closed_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> 
        </a>
			</div>
		<% } %>
		</div>

	<h3 class="my-requestoffers-header">
		<%=loc.get(123, "My Favors being serviced")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_taken_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(user_id,78);
        if (my_taken_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_taken_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> 
        </a>
        <a href="cancel_active_favor.jsp?requestoffer=<%=r.requestoffer_id%>">
          <%=loc.get(130,"Cancel")%>
        </a>
			</div>
		<% } %>
		</div>

	<h3 class="my-requestoffers-header">
		<%=loc.get(122, "My open Favors")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_open_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(user_id,76);
        if (my_open_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_open_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> </a>
          <a class="button" 
            href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&delete=true">
            <%=loc.get(21,"Delete")%>
          </a>
          <a class="button" href="retract_requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
            <%=loc.get(194,"Retract")%>
          </a>
			</div>
		<% } %>
		</div>

	<h3 class="my-requestoffers-header">
		<%=loc.get(125, "My draft Favors")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_draft_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(user_id,109);
        if (my_draft_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_draft_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 15) %> </a>
          <a class="button" 
            href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>&delete=true">
            <%=loc.get(21,"Delete")%>
          </a>
          <a class="button" href="publish_requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>">
            <%=loc.get(6,"Publish")%>
          </a>
			</div>
		<% } %>
		</div>

	<h3><%=loc.get(96, "My conversations")%></h3>

  <table border="1">
    <thead>
      <tr>
        <th><%=loc.get(172,"Timestamp")%></th>
        <th><%=loc.get(32,"Favor")%></th>
        <th><%=loc.get(171,"Message")%></th>
      </tr>
    </thead>
    <tbody>
   <% Requestoffer_utils.MyMessages[] mms 
     = Requestoffer_utils.get_my_conversations(user_id);
   for (Requestoffer_utils.MyMessages mm : mms) {%>
    <tr>
      <td><%=mm.timestamp%> </td>
      <td><a href="requestoffer.jsp?requestoffer=<%=mm.requestoffer_id%>"><%=Utils.get_trunc(Utils.safe_render(mm.desc),15)%></a> </td>
      <td><%=Utils.safe_render(mm.message)%></td>
    </tr>
		<% } %>
    </tbody>
  </table>
    <% if (mms.length == 0) { %>
      <p>(<%=loc.get(103,"None")%>)</p>
    <% } %>
  </div>


<% // MY PROFILE ENDS %>



</div>


  <%@include file="includes/footer.jsp" %>
</body>
</html>
