package com.renomad.qarma;

import com.renomad.qarma.User_utils;
import com.renomad.qarma.Text;

public class Localization {
	
	private final int user_id;
	
	public Localization(int user_id) {
		this.user_id = user_id;
	}

	/**
	*  this is our localization mechanism.  It gets the localized text
	* by id.
	* @param index index into the array of strings
	* @param reminder this is not used in the method, but is crucial for 
	* understanding the code in place.  Always include the reminder string
	* so a person reviewing the code will know the intended word or phrase
	* 	at that place.
	*/
	public String get(int index, String reminder) {
		int user_lang = User_utils.get_user_language(user_id);
		return Text.get(user_lang, index);
	}
}
