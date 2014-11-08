package com.renomad.qarma;

import java.nio.file.Paths;
import java.nio.file.Path;
import com.renomad.qarma.Database_access;

public class Build_db_schema {
  public static void main(String[] args) {
    create_database();
    run_script_from_file("create_usertable.sql");
    //tracking info on the users for security's sake.
    run_script_from_file("add_security_cols_to_usertable.sql"); 
    //relates cookie guid's to users
    run_script_from_file("create_guidtable.sql"); 
    //a script to clean out old cookies and add one for a user.
    run_script_from_file("add_register_user_cookie.sql");

  }

  /**
    *This method gets used for a sole purpose - running 
    * the create database script
    */
  static void create_database() {
    String filepath = get_db_script_full_path("create_database.sql");
    String sqlText = File_utilities.get_text_from_file(filepath);
    Database_access.run_sql_statement_before_db_exists(sqlText);
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
    //the following works because we are expected to run the 
    // program from one directory above "db_scripts"
    Path db_scripts = Paths.get("db_scripts").toAbsolutePath();
    String resolved_name = db_scripts.resolve(script_name).toString();
    return resolved_name;
  }
}
