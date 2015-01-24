package com.renomad.xenos;

import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.renomad.xenos.Database_access;


/**
 * This class acts to get localization data from the database and store
 * that in an object that stays resident throughout the runtime of the app.
 * That is, it gets our text in various languages (French, English, etc.) 
 * like "welcome to Xenos" and puts that into a multi-dimensional array, 
 * called words_array.  That array is then available to the entire app through
 * some methods in this class.  It is non-writable, so no concern over
 * multi-threading issues.
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
  private static String[][] words_array;

  /**
   * This method gets called only once - when Xenos is started.  It fills an
   * array with all the localizations found in the database.  This way, localizing words
   * is damn fast.
   */
  public void contextInitialized(ServletContextEvent context) {
    String get_count_sql = "SELECT MAX(local_id) as maximum FROM localization_lookup";
    String get_words_sql = "SELECT local_id, English, French, Spanish FROM localization_lookup";
    PreparedStatement pstmt_get_words = null;
    PreparedStatement pstmt_get_count = null;
    
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt_get_words = Database_access.prepare_statement(conn, get_words_sql);
      pstmt_get_count = Database_access.prepare_statement(conn, get_count_sql);
      
      ResultSet resultSet_count = pstmt_get_count.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet_count)) {
        System.err.println(
            "Error (7): null resultset when getting count of "+
            "localized values");
      }
      resultSet_count.next(); // move to the first set of results.
      int max = resultSet_count.getInt("maximum");
      //create an array with a size equal to the value of 
      //the largest id, plus 1.  That way we can
      //fit all our words in by id.
      int languages_num = 3;
      words_array  = new String[max+1][languages_num];
      
      ResultSet resultSet_words = pstmt_get_words.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet_words)) {
        System.err.println(
            "Error (8): null resultset when pulling localized values");
      }

      while (resultSet_words.next()) {
        String[] words = new String[3];
        int id = resultSet_words.getInt("local_id");
        words[0] = resultSet_words.getString("English");
        words[1] = resultSet_words.getString("French");
        words[2] = resultSet_words.getString("Spanish");
        words_array[id] = words;
      }
      
      /*
       * This code will display all the localizations stored when Tomcat starts
      for (int i = 0; i < words_array.length; i++) {
        for (int j = 0; j < words_array[i].length; j++) {
          System.out.printf("words_array[%d][%d]: %s\n", i,j,words_array[i][j]);
        }
      }
      */
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
    } finally {
      Database_access.close_statement(pstmt_get_words);
    }
    
  }

  public void contextDestroyed(ServletContextEvent sce) {
    //Nothing to do here.  Required to satisfy ServletContextListener interface.
    //We *do* need contextInitialized() to load up the localization object.
  }
  
  
  /**
    * this is our localization mechanism.  It gets the localized text
    * by id.
    * @param user_lang the language set for a given user
    * @param index index into the array of strings
    * @return the localized string, or an error message indicating
    * out-of-index error with the values that are out-of-index.
    */
  public static String get(int user_lang, int index) {
    try {
    return words_array[index][user_lang];
    } catch (ArrayIndexOutOfBoundsException ex) {
      return "out_of_index: " + ex.getLocalizedMessage();
    }
  }

}
