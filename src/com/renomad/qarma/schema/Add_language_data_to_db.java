package com.renomad.qarma.schema;

import com.renomad.qarma.schema.Build_db_schema;

public final class Add_language_data_to_db {

  private Add_language_data_to_db () {
    //we don't want anyone instantiating this
    //do nothing.
  }

  public static void main(String[] args) {
    Build_db_schema.run_multiple_statements(
        "db_scripts/v1_language_data.sql");
  }

}
