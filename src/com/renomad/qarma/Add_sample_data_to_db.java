package com.renomad.qarma;

import com.renomad.qarma.Build_db_schema;

public final class Add_sample_data_to_db {

	private Add_sample_data_to_db () {
		//we don't want anyone instantiating this
		//do nothing.
	}

  public static void main(String[] args) {
		Build_db_schema.run_multiple_statements(
				"db_scripts/v1_add_sample_data.sql");
  }

}
