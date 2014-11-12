package com.renomad.qarma;

import com.renomad.qarma.Database_access;

public class Delete_db_schema {

  public static void main(String[] args) {
    delete_database();
  }

  /**
    * Delete the database
    *
    */
  static void delete_database() {
    Database_access
      .run_sql_statement_before_db_exists("DROP DATABASE test;");
  }

}
