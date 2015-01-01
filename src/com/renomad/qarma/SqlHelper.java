package com.renomad.qarma;

	/**
		* A little program that makes it easier to write SQL code
		* in dynamic scenarios.  
		* <p>Details follow:</p>
		* <p>
		* First, there is an initial string given to us by the user.
		* This consists of a SQL string. 
		* </p>
		* <p>
		* for example,
		* </p>
		* <pre>
		* A) "SELECT * FROM user WHERE user_id = ?"
		* </pre>
		* <p>
		* Normally, we would need to pop this into a PreparedStatement
		* object, then use setInt, setString, etc to assign values
		* for each of the question marks seen in the SQL text.
		* </p>
		* <p>
		* The hassle really comes if we need to do something dynamic,
		* like adding searching / paging / sorting to the query.
		* </p>
		* <p>
		* What we would like to see is a mechanism where we hand in a 
		* string with informational tokens at the places where a 
		* parameter goes, sort of like this:
		* </p>
		* <pre>
		* B) "SELECT * FROM user WHERE user_id = :user_id:"
		* </pre>
		* <p>
		* Now, we can see that it should be straightforward to have
		* some code that, on the one hand, gives us a SQL string like
		* B above, and also runs the necessary setInt's, setString's, etc.
		* that are needed.  That is what we do here.
		* </p>
		*/
public class SqlHelper {




	/**
		* this will merely be the sql given to us at the onset, except
		* the tokens will be replaced with question marks, which is the
		* proper syntax for use with PreparedStatement
		*/
	public final String rendered_sql;




	/**
		* a class to hold the index, name, and value of things we
		* will tie to places within the SQL string.
		*/
	internal static class TokenValue {

  	public final Integer arg_index;
		public final String token_name;
		public final Object value;

		public TokenValue(Integer arg_index, String token_name, Object value) {
			this.arg_index = arg_index;
			this.token_name = token_name;
			this.value = value;
		}

	}

	/**
		* this property will contain the objects in the order necessary 
		* to tie to the SQL parameters - the question marks that appear
		* in the text.
		*/
	public final ArrayList<TokenValue> objects_in_param_order;



	/**
		* constructs an object that can be used to make SQL access
		* easier.
		* creates an immutable object. throws an exception if we couldn't
		* tie together the sql with the public fields perfectly.  Note that
		* we only care that the values we find in the SQL text are found
		* in the object, not the other way around.
		* @param sql a sql string which includes tokens for the parameters.
		* For example, you might write,
		* SELECT * FROM user WHERE user_id = :user_id: AND 
		* is_logged_in = :is_logged_in: 
		*
		* The format is as follows - first a colon, then the name of
		* a public field in the object passed-in, then a final colon.
		* @param object an object which we will query for its public fields
		* and types.  We will then use this to generate the boilerplate
		* SQL useable by PreparedStatement, and also will provide the ability
		* to run setInt, setString, etc. for its values.   Please note: the
		* object has to be an immutable object with public properties.  We'll
		* use reflection to get those values and the variable names to tie
		* everything together. Perhaps in the future we may get more sophisticated
		* but no promises.
		* So this means, for example, an object passed in needs to have properties
		* that look like this:
		*
		* public final String blah
		* public final int bleh
		*
		*<p>
		* Example: new SqlHelper("SELECT * FROM blah WHERE x = :what: AND y = :who: AND z = :whodat:", what, who, whodat);
	  *</p>
		*
		* also note that the object passed in must be Objects - no primitives allowed!
		*/
	public SqlHelper(String sql, Object... objects) { 
		objects_in_param_order = new ArrayList<TokenValue>();
		this.rendered_sql = generate(sql, objects);
	}
                                                                                             

	/**
		*get the public final objects from the object using reflection.
		* @param an object to search for public final objects.
		* @return a list of objects found, or an empty list if none found.
		*/
	private List<Object> get_public_final_objects(Object object) {

	 	ArrayList<Object> object_candidates = new ArrayList<Object>(); 
		Class class = object.getClass();               //get the object's class
		Field[] fields = class.getDeclaredFields();    //get its fields

		//for each of the fields, determine which ones are public and final
		for(Field f : fields) {                        
			int foundMods = f.getModifiers();      

			//get the modifiers for a field, things like "public" or "final"
			//notice, we're using bit comparisons here, not boolean logic.  
			//See the single ampersand operand.

			if (foundMods & Modifier.PUBLIC == Modifier.PUBLIC &&
				 	foundMods & Modifier.FINAL == Mofidier.FINAL)  { 
				//at this point, we know we're dealing with a public final field.		
				//so we add it to our bag o' objects.
				Object o = f.get(f)
				object_candidates.add(o);
			}
		}
		return object_candidates;
	}




	/**
		* Here we do two things: read the sql string given us by the 
		* user and tie that to the public fields in the object.
		* @param sql the sql string with named parameters given us by the user
		* @object an object having public immutable fields which we will use
		*  to tie to the tokens in the sql string.
		*/
	private String generate(String sql, Object[] objects) {

		//Initialize some stuff we'll use later.
		//we'll collect objects for potential matching here.
	 	Map<String, Object> object_candidates = new HashMap<String,Object>(); 

		//go through our objects and collect all the things we might tie to tokens.
		for (int i = 0; i < objects.length; i++) {
			//let's get an object on the lab table and see what it's made of.
			//If it's an Integer, Boolean, or String, add it to the object array.
			//Otherwise, we delve deeper to get inner public/final fields.
			Object o = objects[i];
			Class<?> c = o.getClass();
			var isIntBoolDoubleOrString = 
							c == Class<Integer> || 
							c == Class<Boolean> || 
							c == Class<Double> || 
							c == Class<String>;
			if (isIntBoolDoubleOrString)
				c.getType
       	object_candidates.put(o.getName, o);
			} else {
				List<Object> p_f_objects = get_public_final_objects(o)
      	object_candidates.addAll(p_f_objects);
			}
		}

		//by this point we have all the stuff we need from all the objects.
		//moving on...

		//regular expression details: 
		//find a string surrounded by single colons. If we find the string and
		//colons, we have a capture group allowing us to obtain that inner string.
		Pattern p = Pattern.compile(":(\\w+?):");
		Matcher m = p.matcher(sql);

		//Look for matches of this pattern, 
		//and get the text in the token.  We can start
		//incrementing our counter for parameters.
		int param_counter = 0;
		while(m.find()) {

			String next_token = m.group(1); //get the inner string if exists

			//let's be defensive.
			if (next_token == null) { 
				continue;
			}
      
			//look for the object with the name equal to the text we found.
			for (Object o : object_candidates) {
      	String name = field.getName();
				if (name == next_token) {
        	//if we get here it means we found a match between
					//a token in the sql text and one of the public fields.
					//the information we need to store is the index of the parameter,
					//and the field.
					fields_in_param_order.add(param_counter, field);
					matched_token = true;
				}
			}

			//increment the counter as we move to the next match
			param_counter++;

		} //while loop ends.


		//at this point we've done all our matching.  Let's do a 
		//quick search-and-replace to make all our tokens into question marks.
		//it's ok if we replace a question mark with a question mark, who cares.
		//this will allow simpler code, and we want the ability to send in a string
		//containing both special tokens and question marks.
		return m.replaceAll("?");
	}


	/**
		* This will return the kind of string that is valid for
		* giving to a PreparedStatement, with question marks in
		* parameter locations.
		*/
	public String get_sql_for_preparedStatement() {

		return "SELECT * FROM user WHERE user_id = ? AND is_logged_in = ?";
	}


	/**
		* This runs the necessary methods in the proper order to 
		* assign data to the parameters in the SQL string.
		*/
	public void run_data_injections(int params_counts) {
		for(int i = 0; i < params_counts; i++) {
			if (is_string) {
				pstmt.setString( param_index, so.first_date);
			} else if (is_nstring) {
				pstmt.setNString( param_index, so.first_date);
			} else if (is_int) {
				pstmt.setInt( param_index, so.first_date);
			} else if (is_boolean) {
				pstmt.setBoolean( param_index, so.first_date);
			}
		}
	}




}
