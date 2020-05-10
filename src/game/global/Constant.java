package game.global;

public class Constant {
	public static String[] GAME_STATES = new String[] { 
			"waiting",                      /*0*/
			"Start",                        /*1*/
			"Assign Roles",                  /*2*/
			"city sleeps."
			+ "Mafia kill someone "
			+ "Detective identify someone"
			+ "and Doctor save someone",                  /*3*/
			"city_wake_up_and_elimimate_someone",                /*4*/
};
	
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