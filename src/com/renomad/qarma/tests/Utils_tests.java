package com.renomad.qarma.tests;


import org.junit.Test;
import org.junit.Ignore;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import static org.junit.Assert.*;

import java.util.Arrays;

import com.renomad.qarma.Request;
import com.renomad.qarma.Request_utils;
import com.renomad.qarma.User_utils;
import com.renomad.qarma.Utils;
import com.renomad.qarma.Request_status;
import com.renomad.qarma.Database_access;

public class Utils_tests {

  @Test
  public void test_is_valid_date() {
    assertTrue(Utils.is_valid_date("2001-01-01 - 2002-01-02"));
    assertTrue(Utils.is_valid_date("2001-01-01"));
    assertTrue(Utils.is_valid_date("2001-01-01 - "));
    assertTrue(Utils.is_valid_date(" - 2002-01-02"));
  }

}
