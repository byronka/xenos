package com.renomad.qarma.tests;

import org.junit.Test;
import org.junit.Ignore;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import static org.junit.Assert.*;

import com.renomad.qarma.Business_logic.Request;
import com.renomad.qarma.Database_access;

public class Request_tests {

	@Test
	public void testing_add_request_baduser() {
		//use a bad user id.  Should cause an exception, and should not enter into db.
		//arrange
		Request r1 = new Request(0, "2014-12-12 11:19:30.0", "desc", 100, 1, "title", 0, new Integer[]{1,2});

		//act
		int id = Database_access.add_request( r1.requesting_user_id, r1.description, r1.status, 
				r1.datetime, r1.points, r1.title, r1.categories);

		//assert
    Request r2 = Database_access.get_a_request(id);
		assertNull(r2);
	}


	@Test
	public void testing_add_request() {
		//set up a standard add_request() and use it.
		//arrange
		Request r1 = new Request(0, "2014-12-12 11:19:30.0", "desc", 100, 1, "title", 1, new Integer[]{1,2});

		//act
		int id = Database_access.add_request( r1.requesting_user_id, r1.description, r1.status, 
				r1.datetime, r1.points, r1.title, r1.categories);

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
