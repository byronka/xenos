package com.renomad.qarma;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import com.renomad.qarma.Database_access;
import com.renomad.qarma.Utils;

import java.sql.Statement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;


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
	public String get_request_status_localized(int status) {
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
