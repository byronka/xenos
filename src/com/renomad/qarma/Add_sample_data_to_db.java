package com.renomad.qarma;

import com.renomad.qarma.Database_access;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

public class Add_sample_data_to_db {

  public static void main(String[] args) throws FileNotFoundException{
  try (Scanner s = 
    new Scanner(new File("db_scripts/add_sample_data.sql"))) {
      s.useDelimiter("---DELIMITER---");
      while(s.hasNext()) {
        Database_access.run_sql_statement(s.next());
      }
    }
  }

}
