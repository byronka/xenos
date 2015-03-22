package com.renomad.xenos;

import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;

import java.util.Arrays;
import java.util.Map;
import java.util.HashMap;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.renomad.xenos.Database_access;


/**
 * This class gets postal codes from the database and stores
 * that in an object that stays resident throughout the runtime of the app.
 * this way we can do fast calculations for distance from a user to
 * the location of any given requestoffer.  We don't have to pre-cook.
 * that is, this way, we won't have to store already-calculated values
 * from a user to something.  We just calculate on the fly.
 * @author Byron Katz
 *
 */
@WebListener
public class Postal_codes implements javax.servlet.ServletContextListener {


  public static class Latlong {

    public double latitude;
    public double longitude;

    public Latlong(double latitude, double longitude) {
      this.latitude = latitude;
      this.longitude = longitude;
    }
  }


  /**
    * This property will be filled with localization data during webapp
    * startup.  This means, it contains all the information for
    * translating to various languages for all the words in our site.
    */
  private static Map<String, Latlong> postal_codes;



  /**
   * This method gets called only once - when Xenos is started.  It
   * fills a hashmap with all the postal codes found in the database.
   * This way, we can calculate distances from user to requestoffers
   * fast, on the fly.
   */
  public void contextInitialized(ServletContextEvent context) {
    assemble_postal_codes_map();
  }


  /**
    * Carries out the function of getting the postal codes from the
    * database and storing it into the map variable in this class
    * for that purpose.
    */
  private void assemble_postal_codes_map() {

    String get_postal_codes_sql = 
      "SELECT postal_code, latitude, longitude "+
      "FROM postal_codes ";

    PreparedStatement pstmt_get_postal_codes = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt_get_postal_codes = 
        Database_access.prepare_statement(conn, get_postal_codes_sql);
      
      ResultSet resultSet_pcs = pstmt_get_postal_codes.executeQuery();
      if (Database_access.
          resultset_is_null_or_empty(resultSet_pcs)) {
        System.err.println(
            "Error (9): null resultset when pulling postal codes");
      }

      //intialize the map of postal codes
      postal_codes = new HashMap<String, Latlong>();

      while (resultSet_pcs.next()) {
        String pc = resultSet_pcs.getString("postal_code");
        double latitude = resultSet_pcs.getDouble("latitude");
        double longitude = resultSet_pcs.getDouble("longitude");
        Latlong ll = new Latlong(latitude, longitude);
        postal_codes.put(pc, ll);
      }

      resultSet_pcs.close();
      
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
    } finally {
      Database_access.close_statement(pstmt_get_postal_codes);
    }
  }


  public void contextDestroyed(ServletContextEvent sce) {
    //Nothing to do here.  Required to satisfy ServletContextListener
    //interface.  We *do* need contextInitialized() to load up the
    //localization object.
  }
  
  
  /**
    * given a postal code, get its latitude and longitude
    */
  public static Latlong get(String postal_code) {
    return postal_codes.get(postal_code);
  }

}
