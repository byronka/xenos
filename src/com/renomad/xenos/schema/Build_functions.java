package com.renomad.xenos.schema;

import com.renomad.xenos.schema.Build_db_schema;

public final class Build_functions {

  private Build_functions () {
    //we don't want anyone instantiating this
    //do nothing.
  }

  public static void main(String[] args) {
    Build_db_schema.run_multiple_statements(
        "db_scripts/v1_functions.sql");
  }

}
