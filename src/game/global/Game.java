package game.global;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class Game {

	private Map<String, Player> players=new HashMap<String, Player>();
	public final String uniqueID = UUID.randomUUID().toString();
	String name;
	private int state=0;

	final static int waiting = 0 ;
	final static int started = 1 ;
	final static int city_sleeps = 2 ;
	final static int Mafia_wake_up = 3 ;
	final static int Mafia_kill_someone = 4 ;
	final static int Mafia_sleeps = 5 ;
	final static int Detective_wake_up = 6 ;
	final static int Detective_dentify_someone = 7 ;
	final static int Detective_sleeps = 8 ;
	final static int Doctor_wake_up = 9 ;
	final static int Doctor_save_someone = 10 ;
	final static int Doctor_sleeps = 11 ;
	final static int city_wake_up = 12 ;
	final static int city_identify_Mafia = 13 ;
	
	public Game(String name) {

		this.name=name;
	}

	public String addPlayer(String name) {
		Player p=new Player(name);
		players.put(p.uniqueID, p);
		return p.uniqueID;
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

	public void setState(int state) {
		this.state = state;
	}
	
	public Player getPlayer(String player_uniqueID)
	{
		return players.get(player_uniqueID);
	}
	
}
