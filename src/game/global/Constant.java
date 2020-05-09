package game.global;

public class Constant {
	public static String[] GAME_STATES = new String[] { 
			"waiting",                         /*0*/
			"started",                        /*1*/
			"city sleeps",                   /*2*/
			"Mafia wake up",                /*3*/
			"Mafia kill someone",           /*4*/
			"Mafia sleeps",                 /*5*/
			"Detective wake up",            /*6*/
			"Detective identify someone",   /*7*/
			"Detective sleeps",             /*8*/
			"Doctor wake up",               /*9*/
			"Doctor save someone",          /*10*/
			"Doctor sleeps",                /*11*/
			"city wake up",                 /*12*/
			"city identify Mafia"           /*13*/ };        
	public static String[] GAME_ROLES = new String[] 
			{
				"Civilian",           /*0*/
				"Mafia",              /*1*/
				"Detective",          /*2*/
				"Doctor"              /*3*/
			} ;


}