package game.global;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Storage {
	static Map<String, List<String>> games=new HashMap<String, List<String>>();
	public static void addGame(String game_name) {
		if (!games.containsKey(game_name))
			games.put(game_name,new  ArrayList<String>());
		

	}
	public static void joinGame(String game_name, String player_name) {
		if (!games.get(game_name).contains(player_name))
			games.get(game_name).add(player_name);

	}
	public static List<String> getPlayers(String game_name)
	{
		return games.get(game_name);
	}
	public static List<String> getGames()
	{
		return new ArrayList<String>(games.keySet());
	}
	
	public static void startGame(String game_name)
	{
		
	}
}
