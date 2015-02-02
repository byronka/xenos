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
import com.renomad.xenos.Request_status;
import com.renomad.xenos.Database_access;

public class Request_tests {

  @Test
  public void testing_get_request_statuses() {
    //act and assert
    Request_status[] rs_actual = Request_utils.get_request_statuses();
    for (Request_status rs : rs_actual) {
      switch(rs.status_id) {
        case 76:
          assertEquals("OPEN", rs.status_value);
          break;
        case 77:
          assertEquals("CLOSED", rs.status_value);
          break;
        case 78:
          assertEquals("TAKEN", rs.status_value);
          break;
        default:
          fail("should not get this far");
          break;
      }
    }
  }


  @Test
  public void testing_put_request() {
    //set up a standard put_request() and use it.
    //arrange
    int user_id = 4;
    String desc = "desc";
    int points = 100; 
    String title = "title"; 
    Integer[] categories = {71,72};

    //act
    // this will cause user 4 to issue a 100 point request.  we will
    // need to clean up at the end of this test to refund those points.
    // deleting the request at the end includes a piece for refunding points
    Request_utils.Request_response response = Request_utils.put_request(
        user_id, desc, points, title, categories);

		//now we've put a request in.

    //assert
		//let's get back that request we just added and check it out.
		//make sure that what we get back is what we put in.
    Request r2 = Request_utils.get_a_request(response.id);
    assertNotNull(String.format("r2 was null after trying an id of %d", response.id), r2);
    assertTrue(r2.datetime.length() > 0);
    assertEquals(desc, r2.description);
    assertEquals(points, r2.points);
    assertEquals(76, r2.status); //always starts OPEN
    assertEquals(title, r2.title);
    assertEquals(user_id, r2.requesting_user_id);
    assertArrayEquals(categories, r2.get_categories());

    //cleanup
		//delete the request.  This will give our user back his 100 points
    Request_utils.delete_request(response.id, user_id);
    int refunded_points = User_utils.get_user_points(user_id);

    //we should have gotten refunded when deleting the request.
    assertEquals(100, refunded_points);
  }

}
