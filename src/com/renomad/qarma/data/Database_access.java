package com.renomad.qarma;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database_access {

  public static void main(String[] args) {

    try {
      // The newInstance() call is a work around for some
      // broken Java implementations
      Class.forName("com.mysql.jdbc.Driver").newInstance();
    } catch (Exception ex) {
      // handle the error
    }

    try {
      Connection conn =
         DriverManager.getConnection("jdbc:mysql://localhost/?" +
                                     "user=qarmauser&password=hictstd!");
      Statement stmt = conn.createStatement();
      stmt.execute("CREATE DATABASE IF NOT EXISTS byron;");
      conn.close();
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }

  }
}
