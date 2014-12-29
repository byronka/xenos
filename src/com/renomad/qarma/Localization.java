package com.renomad.qarma;

import com.renomad.qarma.User_utils;
import com.renomad.qarma.Text;
import java.util.Locale;

	/**
	* An object used to hold state so running localization requests
	* uses very little boilerplate code.
	* By creating an object at the beginning of the request, 
	* filled with information like the user_id and the accept-language string,
	* we provide the object with sufficient state to know which language
	* ought to be provided to the user.  That way, for any place where we
	* call some of these messages, we just have to call get() with the index
	* to the particular word or phrase.  
  *
	* See also the Text class which loads language data from the database
	* into an array and provides methods to access that array.  We call those
	* methods from here.
	*/
public class Localization {
	
	private final Integer language;
	
	/**
		* creates a localization object used to get local language values. 
		* @param client_locale the client's locale.  
		* We'll use this to get their preferred language.
		*/
	public Localization(Locale client_locale) {
		this(-1, client_locale);
	}

	/**
		* creates a localization object used to get local language values.
		* @param user_id the id of the logged-in user, to see if they have set
		* @param client_locale the client's locale.  
		* We'll use this to get their preferred language.
		* a language preference
		*/
	public Localization(int user_id, Locale client_locale) {
		Integer browser_language = null;
		Integer user_language = null;

		if (client_locale != null) {
    	browser_language = get_browser_language(client_locale);
		}

		//overwrite the value from the browser with the client's 
		//preferred choice, if it exists
		if (user_id > 0) {
			user_language = User_utils.get_user_language(user_id);
		}

		//use the user_language if one exists, 
		//otherwise the browser language, otherwise English
		if (user_language != null) {
			language = user_language;
		} else if (browser_language != null) {
			language = browser_language;
		} else {
			language = 0; //English
		}

	}

	/**
	*  This gets the localized text by id.
	* @param index index into the array of strings
	* @param reminder this is not used in the method, but is crucial for 
	* understanding the code in place.  Always include the reminder string
	* so a person reviewing the code will know the intended word or phrase
	* 	at that place.
	*/
	public String get(int index, String reminder) {
		return Text.get(language, index);
	}



	/**
		* This method gets the language to use from the locale
		* @param client_locale the localization info as sent by the browser.
		* @return an integer representing one of our languages we localize for,
		* or null if nothing found.
		*/
	private static Integer get_browser_language(Locale lo) {
		if (is_language(lo, "en")) { return 0; } //English
		if (is_language(lo, "fr")) { return 1; } //French
		if (is_language(lo, "es")) { return 2; } //Spanish
		return null;
	}

	/**
		* Helper method to avoid a lot of wordy boiler plate code.
		* @param client_locale the locale for a client
		* @param language a 2-letter language code, like en, fr, or es (English, French, Spanish)
		* @return true if the locale is the language indicated, false otherwise.
		*/
	private static boolean is_language(Locale client_locale, String language) {
		return client_locale.getLanguage().equals(new Locale(language).getLanguage());
	}



}
