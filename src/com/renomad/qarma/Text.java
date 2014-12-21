package com.renomad.qarma;

import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;

import java.util.ArrayList;

/**
 * Note that the annotation WebListener registers this class as a listener
 * so that Tomcat will call the method contextInitialized when the app starts
 * so we can load our localization object.
 * @author Byron Katz
 *
 */
@WebListener
public class Text implements javax.servlet.ServletContextListener {

	/**
		* This property will be filled with localization data during webapp
		* startup.  This means, it contains all the information for
		* translating to various languages for all the words in our site.
		*/
	private static ArrayList<ArrayList<String>> words_array = new ArrayList<ArrayList<String>>();

	public void contextInitialized(ServletContextEvent context) {
		ArrayList<String> words = new ArrayList<String>();
		words.add(0, "Search");
		words.add(1, "FrenchSearch");
		words.add(2, "SpanishSearch");
		words_array.add(0, words);
	}

	public void contextDestroyed(ServletContextEvent sce) {
		//Nothing to do here.  Required to satisfy ServletContextListener interface.
		//We *do* need contextInitialized to load up the localization object.
	}

	/**
		* this is our localization mechanism.  It gets the localized text
		* by id.
		* @param user_id the user's id - they can set their preferred language
		* @param index index into the array of strings
		* @param reminder this is not used in the method, but is crucial for 
		* understanding the code in place.  Always include the reminder string
		* so a person reviewing the code will know the intended word or phrase
		* 	at that place.
		* @return the localized string
		*/
	public static String get(int user_id, int index, String reminder) {
		int user_lang = User_utils.get_user_language(user_id);
		return words_array.get(index).get(user_lang);
	}

}
