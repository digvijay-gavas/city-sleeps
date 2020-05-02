package game.global;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class Storage {
	static Map<String, Map<String, String[]>> games = new HashMap<String, Map<String, String[]>>();
	static Map<String, int[]> games_states = new HashMap<String, int[]>();
	static List<String> waiting_game_list = new ArrayList<String>();
	static String[] GAME_STATES = new String[] { "waiting", "started", "city sleeps", "Mafia wake up",
			"Mafia kill someone", "Mafia sleeps", "Detective wake up", "Detective identify someone", "Detective sleeps",
			"Doctor wake up", "Doctor save someone", "Doctor sleeps", "city wake up", "city identify Mafia" };

	public static void addGame(String game_name) {
		if (!games.containsKey(game_name)) {
			games.put(game_name, new HashMap<String, String[]>());
			games_states.put(game_name, new int[] { 0/* waiting */ });
			waiting_game_list.add(game_name);
		}

	}

	public static boolean isGameExist(String game_name) {
		return games.containsKey(game_name);
	}

	public static String getGameState(String game_name) {
		try {
			return GAME_STATES[games_states.get(game_name)[0]];
		} catch (Exception e) {
			return "Error";
		}
	}

	public static String getNextGameState(String game_name) {
		try {
			return GAME_STATES[Storage.getNextGameStateInt(game_name)];
		} catch (Exception e) {
			return "Error";
		}
	}

	private static int getNextGameStateInt(String game_name) {
		int next_game_state = 0;
		if (games_states.get(game_name)[0] < GAME_STATES.length -1) {
			next_game_state = games_states.get(game_name)[0] + 1;
		} else {
			next_game_state = 2/* city sleeps */;
		}
		return next_game_state;
	}

	public static boolean advanceGameState(String game_name) {
		if (games_states.get(game_name)[0] > 0/* waiting */) {
			games_states.get(game_name)[0]=Storage.getNextGameStateInt(game_name);
			return true;
		}
		return false;
	}

	public static void joinGame(String game_name, String player_name) {
		if (!games.get(game_name).containsKey((player_name)))
			games.get(game_name).put(player_name, new String[] { "NA", null,null });

	}

	public static Map<String, String[]> getPlayers(String game_name) {
		return games.get(game_name);
	}
	
	public static void votePlayer(String game_name,String player_name , String voted_player_name) {
		if(games.get(game_name).get(player_name)[2] == null /* whoIvoted */)
		{
			if(games.get(game_name).get(voted_player_name)[1]==null /* votes */ )
			{
				games.get(game_name).get(voted_player_name)[1]="1";
			} else 
			{
				games.get(game_name).get(voted_player_name)[1]=""+Integer.parseInt(games.get(game_name).get(voted_player_name)[1])+1;
			}
			games.get(game_name).get(player_name)[2] = voted_player_name /* whoIvoted */;
		}
	}
	
	public static String whoIVoted(String game_name,String player_name) {
		if(games.get(game_name).get(player_name)[2]!=null)
		{
			return games.get(game_name).get(player_name)[2];
		}
		return null;
	}

	public static List<String> getGames() {
		return waiting_game_list;
		// return new ArrayList<String>(games.keySet());
	}

	public static boolean canMafiaKill(String game_name,String player_name) {
		if (getNextGameStateInt(game_name)==4/*Mafia kill someone*/ && Storage.getPlayers(game_name).get(player_name)[0].equalsIgnoreCase("Mafia"))
			return true;
		return false;
	}
	
	public static void startGame(String game_name, int no_of_mafia, int no_of_detective, int no_of_doctor) {
		waiting_game_list.remove(game_name);
		if (games_states.get(game_name)[0] != 0/* waiting */)
			return;
		games_states.get(game_name)[0] = 1/* started */;
		Map<String, String[]> players = games.get(game_name);
		int size = players.size();
		Random random = new Random();
		int toss = 0;
		int[] players_role = new int[size];

		int assigned = 0;
		while (assigned < no_of_mafia) {
			toss = random.nextInt(size);
			if (players_role[toss] == 0) {
				players_role[toss] = 1;
				assigned++;
			}
		}

		assigned = 0;
		while (assigned < no_of_detective) {
			toss = random.nextInt(size);
			if (players_role[toss] == 0) {
				players_role[toss] = 2;
				assigned++;
			}
		}

		assigned = 0;
		while (assigned < no_of_doctor) {
			toss = random.nextInt(size);
			if (players_role[toss] == 0) {
				players_role[toss] = 3;
				assigned++;
			}
		}
		assigned = 0;
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
