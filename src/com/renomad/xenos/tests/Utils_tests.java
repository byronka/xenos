package com.renomad.xenos.tests;


import org.junit.Test;
import org.junit.Ignore;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import static org.junit.Assert.*;

import java.util.Arrays;

import com.renomad.xenos.Request;
import com.renomad.xenos.Request_utils;
import com.renomad.xenos.User_utils;
import com.renomad.xenos.Utils;
import com.renomad.xenos.Request_status;
import com.renomad.xenos.Database_access;

public class Utils_tests {

  @Test
  public void test_is_valid_date() {
    assertTrue(Utils.is_valid_date("2001-01-01-2002-01-02"));
    assertTrue(Utils.is_valid_date("2001-01-01"));
    assertTrue(Utils.is_valid_date("2001-01-01-"));
    assertTrue(Utils.is_valid_date("-2002-01-02"));
  }


}
