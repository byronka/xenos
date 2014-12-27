package com.renomad.qarma;

import com.renomad.qarma.Request;

/**
	* a class used to display a succinct summary of other users' Requests
	* We add a few items here that will be necessary for display.
	* Immutable, because this is and so is Request.
	*/
public class Others_Request extends Request {

	/**
		* rank is the rank of the user who created the request.
		*/
	public int rank;

	public Others_Request(
			String title, String date, String desc, int status,
			int rank, int points, int request_id, int requesting_user_id,
		 	Integer[] categories) {
		super(request_id, date, desc, points,
				status, title, requesting_user_id, categories);
		this.rank = rank;
	}

}
