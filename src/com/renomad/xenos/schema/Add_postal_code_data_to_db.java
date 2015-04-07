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

    // Build the United states

    Build_db_schema.run_multiple_statements(
        "db_scripts/us_postal_codes.sql");
    Build_db_schema.run_multiple_statements(
        "db_scripts/us_latitudes.sql");
    Build_db_schema.run_multiple_statements(
        "db_scripts/us_longitudes.sql");
    Build_db_schema.run_multiple_statements(
        "db_scripts/us_postal_details.sql");

    // Build France
    Build_db_schema.run_multiple_statements(
        "db_scripts/france_postal_codes.sql");
    Build_db_schema.run_multiple_statements(
        "db_scripts/france_latitudes.sql");
    Build_db_schema.run_multiple_statements(
        "db_scripts/france_longitudes.sql");
    Build_db_schema.run_multiple_statements(
        "db_scripts/france_postal_details.sql");
  }

}
