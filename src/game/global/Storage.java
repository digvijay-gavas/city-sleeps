package game.global;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class Storage {
	static Map<String, Map<String, int[]>> games = new HashMap<String, Map<String, int[]>>();

	public static void addGame(String game_name) {
		if (!games.containsKey(game_name))
			games.put(game_name, new HashMap<String, int[]>());

	}

	public static void joinGame(String game_name, String player_name) {
		if (!games.get(game_name).containsKey((player_name)))
			games.get(game_name).put(player_name, new int[] { 0, 0 });

	}

	public static Map<String, int[]>  getPlayers(String game_name) {
		return games.get(game_name);
	}

	public static List<String> getGames() {
		return new ArrayList<String>(games.keySet());
	}

	public static void startGame(String game_name) {
		Map<String, int[]> players = games.get(game_name);
		int size = players.size();
		Random random = new Random();
		int toss = 0;

		for (Map.Entry<String, int[]> player : players.entrySet()) {
			toss = random.nextInt(size);
			if (toss >= size / 2) {
				player.getValue()[0] = 1;
			} else {

			}

			// System.out.println(player.getKey() + "/" + player.getValue());
		}
	}
}
