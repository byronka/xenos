package com.renomad.qarma;

import java.sql.SQLException;
import com.renomad.qarma.Database_access;

public class Build_db_schema {

  public static void main(String[] args) {
		int version = -1;
		try {
			version = Database_access.get_db_version();
		} catch (SQLException ex) {
			create_database(); //will create the db and set version to 0
			version = 0;
		}
		if (version == 0) { run("db_scripts/v1_setup.sql"); }
	}

	private static void run(String sql) {
			Database_access.run_multiple_statements(sql);
	}



  private static void create_database() {
		//create the database
    Database_access
      .run_sql_statement_before_db_exists(
          "CREATE DATABASE IF NOT EXISTS test;");

		//create the config table
		Database_access
			.run_sql_statement(
				"CREATE TABLE config (config_item VARCHAR(200), config_value VARCHAR(200));");

		//set the version to 0
		Database_access
			.run_sql_statement(
				"INSERT config (config_item, config_value) values ('db_version', '0');");
  }

}
