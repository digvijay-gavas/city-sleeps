package game.global;

public class Constant {
	public static String[] GAME_STATES = new String[] { 
			"waiting",                      /*0*/
			"Start",                        /*1*/
			"Assign Roles",                  /*2*/
			"City sleeps."
			+ "Mafia kill someone "
			+ "Detective identify someone"
			+ "and Doctor save someone",                  /*3*/
			"city_wake_up_and_elimimate_someone",                /*4*/
	};
	
	public static String[] GAME_STATES_CIVILIAN = new String[] { 
			"waiting",                       /*0*/
			"Start",                         /*1*/
			"Assign Roles",                  /*2*/
			"City Sleeps..",        /*3*/
			"Eliminate someone",             /*4*/
	};
	
	public static String[] GAME_STATES_MAFIA = new String[] { 
			"waiting",                       /*0*/
			"Start",                         /*1*/
			"Assign Roles",                  /*2*/
			"Mafias kill someone....",        /*3*/
			"Eliminate someone",             /*4*/
	};
	
	public static String[] GAME_STATES_DETECTIVE = new String[] { 
			"waiting",                         /*0*/
			"Start",                           /*1*/
			"Assign Roles",                    /*2*/
			"Detectives identify someone....", /*3*/
			"Eliminate someone",               /*4*/
	};
	
	public static String[] GAME_STATES_DOCTOR = new String[] { 
			"waiting",                         /*0*/
			"Start",                           /*1*/
			"Assign Roles",                    /*2*/
			"Doctor save someone....",         /*3*/
			"Eliminate someone",               /*4*/
	};
	
	public static String getGameStateString(int state, int role)
	{
		switch (role) {
		case Player.Civilian:
			return  GAME_STATES_CIVILIAN[state];
		case Player.Mafia:
			return  GAME_STATES_MAFIA[state];
		case Player.Detective:
			return  GAME_STATES_DETECTIVE[state];
		case Player.Doctor:
			return  GAME_STATES_DOCTOR[state];
		default:
			return  GAME_STATES[state];
		}
	}
	
	
	public static String[] GAME_STATES_old = new String[] { 
			"waiting",                      /*0*/
			"Start",                        /*1*/
			"Assign Roles",                  /*2*/
			"city sleeps",                  /*3*/
			"Mafia wake up",                /*4*/
			"Mafia kill someone",           /*5*/
			"Mafia sleeps",                 /*6*/
			"Detective wake up",            /*7*/
			"Detective identify someone",   /*8*/
			"Detective sleeps",             /*9*/
			"Doctor wake up",               /*10*/
			"Doctor save someone",          /*11*/
			"Doctor sleeps",                /*12*/
			"city wake up",                 /*13*/
			"city identify Mafia"           /*14*/ }; 
	
	public static String[] GAME_ROLES = new String[] 
			{
				"Civilian",           /*0*/
				"Mafia",              /*1*/
				"Detective",          /*2*/
				"Doctor"              /*3*/
			} ;


}