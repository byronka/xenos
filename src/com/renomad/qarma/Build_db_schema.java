package com.renomad.qarma;

import java.nio.file.Paths;
import java.nio.file.Path;
import com.renomad.qarma.Database_access;

public class Build_db_schema {
  public static void main(String[] args) {
    Database_access.registerSqlDriver(); //necessary boilerplate
    create_database();
    run_script_from_file("create_usertable.sql");
  }

  /**
    *This method gets used for a sole purpose - running 
    * the create database script
    */
  static void create_database() {
    String filepath = get_db_script_full_path("create_database.sql");
    String sqlText = File_utilities.get_text_from_file(filepath);
    Database_access.runSqlStatement(  
        sqlText,
        "jdbc:mysql://localhost/?user=qarmauser&password=hictstd!");
  }


  /**
    *This gets used for updating the schema of the database
    */
  static void run_script_from_file(String script_name) {
    String filepath = get_db_script_full_path(script_name);
    String sqlText = File_utilities.get_text_from_file(filepath);
    Database_access.runSqlStatement(
        sqlText,
        "jdbc:mysql://localhost/test?user=qarmauser&password=hictstd!");
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
