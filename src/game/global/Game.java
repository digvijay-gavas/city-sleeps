package game.global;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

public class Game {

	private Map<String, Player> players=new HashMap<String, Player>();
	public final String uniqueID = UUID.randomUUID().toString();
	String name;
	public  int state=0;

	/*final public static int waiting = 0 ;
	final public static int assign_roles = 2 ;
	final public static int city_sleeps = 3 ;
	final public static int Mafia_wake_up = 4 ;
	final public static int Mafia_kill_someone = 5 ;
	final public static int Mafia_sleeps = 6 ;
	final public static int Detective_wake_up = 7 ;
	final public static int Detective_dentify_someone = 8 ;
	final public static int Detective_sleeps = 9 ;
	final public static int Doctor_wake_up = 10 ;
	final public static int Doctor_save_someone = 11 ;
	final public static int Doctor_sleeps = 12 ;
	final public static int city_wake_up = 13 ;
	final public static int city_identify_Mafia = 14 ;
	
	final public static int START_STATE = 1;
	final public static int END_STATE = 15;
	final public static int LOOP_BACK = 3;*/
	
	final public static int waiting = 0 ;
	final public static int assign_roles = 2 ;
	final public static int city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone = 3 ;
	final public static int city_wake_up_and_elimimate_someone = 4 ;
	
	final public static int START_STATE = 1;
	final public static int END_STATE = 5;
	final public static int LOOP_BACK = 3;
	
	final public static int min_no_of_players = 5;
	
	public Game(String name) {

		this.name=name;
	}

	public String addPlayer(String name) {
		if(state==waiting)
		{
			Player p=new Player(name);
			players.put(p.uniqueID, p);
			return p.uniqueID;
		}
		return "Game is already started.....You cannot Join the Game '"+name+"'";
	}
	
	public String startGame() {
		if(players.size()<min_no_of_players)
			return "Not enough players...minimum no of players reuired is " +min_no_of_players;
		this.goToNextState();
		return "";
	}
	
	public String assignRoles(int no_of_mafia, int no_of_detective, int no_of_doctor) {
		this.goToNextState();		
		int size = players.size();
		Random random = new Random();
		int toss = 0;
		int[] players_role = new int[size];

		int assigned = 0;
		while (assigned < no_of_mafia) {
			toss = random.nextInt(size);
			if (players_role[toss] == Player.Civilian) {
				players_role[toss] = Player.Mafia;
				assigned++;
			}
		}

		assigned = 0;
		while (assigned < no_of_detective) {
			toss = random.nextInt(size);
			if (players_role[toss] == Player.Civilian) {
				players_role[toss] = Player.Detective;
				assigned++;
			}
		}

		assigned = 0;
		while (assigned < no_of_doctor) {
			toss = random.nextInt(size);
			if (players_role[toss] == Player.Civilian) {
				players_role[toss] = Player.Doctor;
				assigned++;
			}
		}
		assigned = 0;
		
		for (Map.Entry<String, Player> player : players.entrySet()) {
			switch (players_role[assigned]) {
			case 1:
				player.getValue().setRole(Player.Mafia);
				break;
			case 2:
				player.getValue().setRole(Player.Detective);
				break;
			case 3:
				player.getValue().setRole(Player.Doctor);
				break;
			default:
				player.getValue().setRole(Player.Civilian);
				break;
			}
			assigned++;
		}
		return "";
	}

	public String killPlayer(String player_uniqueID, String whom__uniqueID)
	{
		players.get(player_uniqueID).killOtherPlayer(players.get(whom__uniqueID));
		return whom__uniqueID;
	}
	
	public String identifyPlayer(String player_uniqueID, String whom__uniqueID)
	{
		players.get(player_uniqueID).identifyOtherPlayer(players.get(whom__uniqueID));
		return whom__uniqueID;
	}
	public String savePlayer(String player_uniqueID, String whom__uniqueID)
	{
		players.get(player_uniqueID).saveOtherPlayer(players.get(whom__uniqueID));
		return whom__uniqueID;
	}
	public String eliminatePlayer(String player_uniqueID, String whom__uniqueID)
	{
		players.get(player_uniqueID).eliminateOtherPlayer(players.get(whom__uniqueID));
		return whom__uniqueID;
	}
	public boolean isWaiting() {
		if(this.state==Game.waiting)
			return true;
		return false;
	}

	public Map<String, Player> getPlayers() {
		return players;
	}

	public void setPlayers(Map<String, Player> players) {
		this.players = players;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getState() {
		return state;
	}

	public void goToNextState() {
		if(state>waiting)
		{
			state++;
			if(state>=END_STATE)
				state=LOOP_BACK;
		} else 
		{
			state=START_STATE;
		}
	}
	
	public int getNextState() {
		int next_state=state;
		if(next_state>waiting)
		{
			next_state++;
			if(next_state>=END_STATE)
				next_state=LOOP_BACK;
		} else 
		{
			next_state=START_STATE;
		}
		return next_state;
	}

	
	public Player getPlayer(String player_uniqueID)
	{
		return players.get(player_uniqueID);
	}
	
	public String calulateAndKill()
	{
		boolean does_all_Mafia_voted=true;
		boolean does_all_Detective_voted=true;
		boolean does_all_Doctors_voted=true;
		for (Map.Entry<String, Player> player : players.entrySet()) 
		{
			if(player.getValue().getRole()==Player.Mafia 
			   && player.getValue().getWhoIKilled()==null)
				does_all_Mafia_voted=false;
			if(player.getValue().getRole()==Player.Detective 
					   && player.getValue().getWhoIIdentified()==null)
						does_all_Detective_voted=false;
			if(player.getValue().getRole()==Player.Doctor 
					   && player.getValue().getWhoISaved()==null)
						does_all_Doctors_voted=false;
		}
		if(  does_all_Mafia_voted
		  && does_all_Detective_voted
		  && does_all_Doctors_voted)
		{
			for (Map.Entry<String, Player> player : players.entrySet()) 
				if(player.getValue().canKill())
					player.getValue().kill();
			this.goToNextState();
			this.resetPlayers();
		}	else
		{
			return "one of follwing check failed <br> "
					+ "does_all_Mafia_voted "+does_all_Mafia_voted
					+ "does_all_Detective_voted "+does_all_Detective_voted
					+ "does_all_Doctors_voted "+does_all_Doctors_voted;
		}
		return "";
	}
	
	public String calulateAndEliminate()
	{
		Player eliminated_player=null;
		int max_votes=0;
		boolean isTie=false;
		for (Map.Entry<String, Player> player : players.entrySet()) 
		{
			if(player.getValue().getEliminateVote() > max_votes)
			{
				eliminated_player=player.getValue();
				max_votes=player.getValue().getEliminateVote();
				isTie=false;
			} else if(player.getValue().getEliminateVote() == max_votes)
			{
				eliminated_player=player.getValue();
				max_votes=player.getValue().getEliminateVote();
				isTie=true;
			}
		}
		
		if(!isTie && eliminated_player!=null && max_votes >0)
		{
			eliminated_player.kill();
			this.goToNextState();
			this.resetPlayers();
		}
		else
			return "Cannot eliminate playet, Tie !!!";
		return "";
	}
	
	public void resetPlayers()
	{
		for (Map.Entry<String, Player> player : players.entrySet()) 
		{
			player.getValue().reset();
		}
	}
	
	public String resetGame()
	{
		state=START_STATE;
		for (Map.Entry<String, Player> player : players.entrySet()) 
		{
			player.getValue().hardReset();
		}
		return "";
	}
	
}
