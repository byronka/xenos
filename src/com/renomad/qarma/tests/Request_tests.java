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
		Request_status[] rs_actual = Database_access.get_request_statuses();
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
			}
		}
	}


	@Test
	public void testing_put_request() {
		//set up a standard put_request() and use it.
		//arrange
		Request r1 = new Request(0, "2014-12-12 11:19:30.0", "desc", 100, 1, "title", 1, new Integer[]{1,2});

		//act
		int id = Business_logic.put_request(r1);

		//assert
    Request r2 = Database_access.get_a_request(id);
    assertEquals(r1.datetime, r2.datetime);
    assertEquals(r1.description, r2.description);
    assertEquals(r2.points, r2.points);
    assertEquals(r2.status, r2.status);
    assertEquals(r2.title, r2.title);
    assertEquals(r2.requesting_user_id, r2.requesting_user_id);
		assertArrayEquals(r1.categories, r2.categories);
	}

}
