package com.renomad.qarma;

import java.sql.Connection;
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

    Connection conn = null;
    try {
      conn =
         DriverManager.getConnection("jdbc:mysql://localhost/test?" +
                                     "user=monty&password=greatsqldb");
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }

  }
}
