package com.renomad.qarma;

import com.renomad.qarma.Database_access;

public class Add_sample_data_to_db {

  public static void main(String[] args) {
		Database_access.run_multiple_statements(
				"db_scripts/add_sample_data.sql");
  }

}
