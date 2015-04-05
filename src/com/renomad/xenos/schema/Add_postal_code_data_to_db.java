package com.renomad.xenos.schema;

import com.renomad.xenos.schema.Build_db_schema;

public final class Add_postal_code_data_to_db {

  private Add_postal_code_data_to_db () {
    //we don't want anyone instantiating this
    //do nothing.
  }

  public static void main(String[] args) {
  // truncate the postal codes table first.
    Build_db_schema.run_multiple_statements(
        "db_scripts/postal_code_truncate.sql");

    Build_db_schema.run_multiple_statements(
        "db_scripts/united_states_postal_code_data.sql");

    Build_db_schema.run_multiple_statements(
        "db_scripts/france_postal_code_data.sql");
  }

}
