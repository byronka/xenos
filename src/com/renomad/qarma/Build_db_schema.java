package com.renomad.qarma;

import java.nio.file.Paths;
import java.nio.file.Path;
import com.renomad.qarma.Database_access;
import java.sql.SQLException;

public class Build_db_schema {

  static int CURRENT_VERSION = 0;

  public static void main(String[] args) {

    try {
      CURRENT_VERSION = Database_access.get_db_version();
    } catch (SQLException ex) {
      create_database();
    }
    run_and_update_db_version(1, "create_usertable.sql");
    run_and_update_db_version(2, "add_security_cols_to_usertable.sql"); 
    run_and_update_db_version(3, "create_guidtable.sql"); 
    run_and_update_db_version(4, "add_register_user_cookie_proc.sql");
    run_and_update_db_version(5, "create_request_table.sql");
  }


  /**
    * Each time this method is called, it will check if the db 
    * is up-to-date as of that script.  If not, it will run
    * the script.
    *
    * @param scriptname the script to be run
    * @param version the version of the db for this script
    */
  static void run_and_update_db_version(
      int version,
      String scriptname) {

    if (version <= CURRENT_VERSION) { return; } //do nothing

    run_script_from_file(scriptname);
    Database_access.set_db_version(version);
  }


  /**
    * Creates the database and adds the version table.
    *
    */
  static void create_database() {
    Database_access
      .run_sql_statement_before_db_exists(
          "CREATE DATABASE IF NOT EXISTS test;");
    Database_access
      .run_sql_statement(
          "CREATE TABLE config (config_item VARCHAR(200), " +
         "config_value VARCHAR(200));");
    Database_access.insert_version_config();
  }


  /**
    *This gets used for updating the schema of the database
    */
  static void run_script_from_file(String script_name) {
    String filepath = get_db_script_full_path(script_name);
    String sqlText = File_utilities.get_text_from_file(filepath);
    Database_access.run_sql_statement(sqlText);
  }

  /**
    *Converts the script names to full path names
    */
  static String get_db_script_full_path(String script_name) {
    Path db_scripts = Paths.get("db_scripts").toAbsolutePath();
    String resolved_name = db_scripts.resolve(script_name).toString();
    return resolved_name;
  }


}
