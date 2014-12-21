package com.renomad.qarma;

public final class Business_logic {


	private Business_logic () {
		//we don't want anyone instantiating this
		//do nothing.
	}


    /**
			* for now, there is no localization file, so we'll just include
			* the English here.
			*/
	public static String get_category_localized(int category_id) {

			switch(category_id) {
				case 1:
					return "math";
				case 2:
					return "physics";
				case 3:
					return "economics";
				case 4:
					return "history";
				case 5:
					return "english";
				default:
					return "ERROR";
			}
		}


	/**
		* for now, there is no localization file, so we'll just include
		* the English here.
		* 
		*/
	public static String get_request_status_localized(int status) {
		switch(status) {
			case 1:
				return "open";
			case 2:
				return "closed";
			case 3:
				return "taken";
			default:
				return "ERROR_STATUS_DEV_FIX_ME";
		}
	}

}
