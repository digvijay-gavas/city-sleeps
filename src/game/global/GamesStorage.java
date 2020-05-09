package game.global;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;

public class GamesStorage {
	private static Map<String, Game> games=new HashMap<String, Game>();
	
	public static String addGame(String name) {
		Game p=new Game(name);
		GamesStorage.games.put(p.uniqueID, p);
		return p.uniqueID;
	}
	
	public static Map<String, Game> getJoinableGames() {
		Map<String, Game> joinable_games=new HashMap<String, Game>();
		for ( Map.Entry<String, Game> game : games.entrySet())  {
			if(game.getValue().isWaiting())
			{
				joinable_games.put(game.getKey(), game.getValue());
			}

		}
		return joinable_games;
	}
	
	public static boolean isGameExist(String uniqueID)
	{
		return games.containsKey(uniqueID);
	}
	public static Game getGame(String uniqueID)
	{
		return games.get(uniqueID);
	}
}
