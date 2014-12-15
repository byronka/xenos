package com.renomad.qarma;

import com.renomad.qarma.Build_db_schema;

public final class Delete_db_schema {

	private Delete_db_schema () {
		//we don't want anyone instantiating this
		//do nothing.
	}
  public static void main(String[] args) {
    delete_database();
  }

  /**
    * Delete the database
    *
    */
  static void delete_database() {
    Build_db_schema
      .run_sql_statement_before_db_exists("DROP DATABASE test;");
  }

}
