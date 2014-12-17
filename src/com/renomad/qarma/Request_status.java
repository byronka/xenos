package com.renomad.qarma;



/**
	* Request_status is the enumeration of request statuses.  
	* It is an immutable object.
	* note that the fields are public, but final.  Once this object
	* gets constructed, there is no changing it.  You have to create a
	* new one.
	*/
public class Request_status {

	public final int status_id;
	public final String status_value;

	public Request_status ( int status_id, String status_value) {
		this.status_id       =  status_id;
		this.status_value    =  status_value;
	}

	public String get_status_value() {
		//for now, there is no localization file, so we'll just include
		//the English here.
		switch(status_id) {
			case 1:
				return "open";
			case 2:
				return "closed";
			case 3:
				return "taken";
			case 4:
				return "ERROR_STATUS_DEV_FIX_ME";
		}
		return "";
	}

}
