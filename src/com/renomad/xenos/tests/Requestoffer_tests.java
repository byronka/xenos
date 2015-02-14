package com.renomad.xenos.tests;

import org.junit.Test;
import org.junit.Ignore;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import static org.junit.Assert.*;

import java.util.Arrays;

import com.renomad.xenos.Requestoffer;
import com.renomad.xenos.Requestoffer_utils;
import com.renomad.xenos.User_utils;
import com.renomad.xenos.Requestoffer_status;
import com.renomad.xenos.Database_access;

public class Requestoffer_tests {


  @Test
  public void testing_put_requestoffer() {
    //set up a standard put_requestoffer() and use it.
    //arrange
    int user_id = 4;
    String desc = "desc";
    String title = "title"; 
    Integer[] categories = {71,72};

    //act
    // this will cause user 4 to issue a 100 point requestoffer.  we will
    // need to clean up at the end of this test to refund those points.
    // deleting the requestoffer at the end includes a piece for refunding points
    Requestoffer_utils.Requestoffer_response response = Requestoffer_utils.put_requestoffer(
        user_id, desc, categories);

		//now we've put a requestoffer in.

    //assert
		//let's get back that requestoffer we just added and check it out.
		//make sure that what we get back is what we put in.
    Requestoffer r2 = Requestoffer_utils.get_a_requestoffer(response.id);
    assertNotNull(String.format("r2 was null after trying an id of %d", response.id), r2);
    assertTrue(r2.datetime.length() > 0);
    assertEquals(desc, r2.description);
    assertEquals(1, r2.points);
    assertEquals(109, r2.status); //always starts DRAFT
    assertEquals(user_id, r2.requestoffering_user_id);
    assertArrayEquals(categories, r2.get_categories());

    //cleanup
		//delete the requestoffer.  This will give our user back his 100 points
    Requestoffer_utils.delete_requestoffer(response.id, user_id);
    int refunded_points = User_utils.get_user_points(user_id);

    //we should have gotten refunded when deleting the requestoffer.
    assertEquals(100, refunded_points);
  }

}
