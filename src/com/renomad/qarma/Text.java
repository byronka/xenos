package com.renomad.qarma;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletContextEvent;
import javax.servlet.http.Cookie;
import com.renomad.qarma.Utils;
import java.util.ArrayList;

public class Text implements javax.servlet.ServletContextListener {

	/**
		* This property will be filled with localization data during webapp
		* startup.  This means, it contains all the information for
		* translating to various languages for all the words in our site.
		*/
	private static ArrayList<ArrayList<String>> words_array;

	public void contextInitialized(ServletContextEvent context) {
  	//add to dictionary here.
	}

	public void contextDestroyed(ServletContextEvent sce) {
		//do nothing for now
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
	public static void get(int user_id, int index, String reminder) {
		int user_lang = User_utils.get_user_language(user_id);

	}

}
