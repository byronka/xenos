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
	public void do_stuff() {
		//arrange
		int user_id = 1;
		String desc = "a description";
		int status = 1; //open
		String date = "2014-12-12 11:19:30.0";
		int points = 100;
		String title = "a title";
		Integer[] categories = {1,2};

		//act
		int id = Database_access.add_request(user_id, desc, status, date, points, title, categories);

		//assert
    Request r = Database_access.get_a_request(id);
    assertEquals(date, r.datetime);
    assertEquals(desc, r.description);
    assertEquals(points, r.points);
    assertEquals(status, r.status);
    assertEquals(title, r.title);
    assertEquals(user_id, r.requesting_user_id);
		assertArrayEquals(categories, r.categories);
	}

}
