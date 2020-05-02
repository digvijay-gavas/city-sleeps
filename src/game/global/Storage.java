package game.global;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class Storage {
	static Map<String, Map<String, String[]>> games = new HashMap<String, Map<String, String[]>>();
	static Map<String,String[]> games_states=new HashMap<String, String[]>();
	static List<String> waiting_game_list=new ArrayList<String>();
	
	public static void addGame(String game_name) {
		if (!games.containsKey(game_name))
		{
			games.put(game_name, new HashMap<String, String[]>());
			games_states.put(game_name, new String[] {"waiting"});
			waiting_game_list.add(game_name);
		}
			

	}
	
	public static boolean isGameExist(String game_name) {
		return games.containsKey(game_name);
	}
	
	public static String getGameState(String game_name) {
		return games_states.get(game_name)[0];
	}

	public static void joinGame(String game_name, String player_name) {
		if (!games.get(game_name).containsKey((player_name)))
			games.get(game_name).put(player_name, new String[] { "NA", "NA" });

	}

	public static Map<String, String[]>  getPlayers(String game_name) {
		return games.get(game_name);
	}

	public static List<String> getGames() {
		return waiting_game_list;
		//return new ArrayList<String>(games.keySet());
	}

	public static void startGame(String game_name, int no_of_mafia, int no_of_detective, int no_of_doctor) {
		waiting_game_list.remove(game_name);
		if(!games_states.get(game_name)[0].equalsIgnoreCase("waiting")) return;
		games_states.get(game_name)[0]="started";
		Map<String, String[]> players = games.get(game_name);
		int size = players.size();
		Random random = new Random();
		int toss = 0;
		int[] players_role=new int[size]; 
		
		int assigned=0;
		while (assigned<no_of_mafia)
		{
			toss=random.nextInt(size);
			if(players_role[toss]==0)
			{
				players_role[toss]=1;
				assigned++;
			}
		}
		
		assigned=0;
		while (assigned<no_of_detective)
		{
			toss=random.nextInt(size);
			if(players_role[toss]==0)
			{
				players_role[toss]=2;
				assigned++;
			}
		}
		
		assigned=0;
		while (assigned<no_of_doctor)
		{
			toss=random.nextInt(size);
			if(players_role[toss]==0)
			{
				players_role[toss]=3;
				assigned++;
			}
		}
		assigned=0;
		for (Map.Entry<String, String[]> player : players.entrySet()) {
			switch (players_role[assigned]) {
			case 1:
				player.getValue()[0] = "Mafia";
				break;
			case 2:
				player.getValue()[0] = "Detective";
				break;
			case 3:
				player.getValue()[0] = "Doctor";
				break;		
			default:
				player.getValue()[0] = "Civilian";
				break;
			}
			assigned++;
				// System.out.println(player.getKey() + "/" + player.getValue());
		}
	}
}
