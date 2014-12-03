package com.renomad.qarma;

import com.renomad.qarma.Build_db_schema;

public class Add_sample_data_to_db {

  public static void main(String[] args) {
		Build_db_schema.run_multiple_statements(
				"db_scripts/add_sample_data.sql");
  }

}
