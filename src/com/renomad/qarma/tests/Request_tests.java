package com.renomad.qarma.tests;

import org.junit.Test;
import org.junit.Ignore;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import static org.junit.Assert.*;

import java.util.Arrays;

import com.renomad.qarma.Business_logic.Request;
import com.renomad.qarma.Business_logic.Request_status;
import com.renomad.qarma.Database_access;
import com.renomad.qarma.Business_logic;

public class Request_tests {

	@Test
	public void testing_get_request_statuses() {
		//act and assert
		Request_status[] rs_actual = Business_logic.get_request_statuses();
		for (Request_status rs : rs_actual) {
			switch(rs.status_id) {
      	case 1:
					assertEquals("OPEN", rs.status_value);
					break;
				case 2:
					assertEquals("CLOSED", rs.status_value);
					break;
				case 3:
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
		int user_id = 1;
		String desc = "desc";
		int points = 100; 
		String title = "title"; 
		Integer[] categories = {1,2};

		//act
		Business_logic.Request_response response = Business_logic.put_request(
				user_id, desc, points, title, categories);

		//assert
		System.out.println("response id is " + response.id);
    Request r2 = Business_logic.get_a_request(response.id);
    assertTrue(r2.datetime.length() > 0);
    assertEquals(desc, r2.description);
    assertEquals(points, r2.points);
    assertEquals(1, r2.status); //always starts OPEN
    assertEquals(title, r2.title);
    assertEquals(user_id, r2.requesting_user_id);
		assertArrayEquals(categories, r2.get_categories());

		//cleanup
		Business_logic.delete_request(response.id);
	}

}
