package game.global;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

public class Game {

	private Map<String, Player> players=new HashMap<String, Player>();
	public final String uniqueID = UUID.randomUUID().toString();
	String name;
	private String status_message="";
	private String status_message_for_Save="";
	private String status_message_for_Mafia="";
	private String status_message_for_Detective="";
	private String status_message_for_Doctor="";
	
	private StringBuffer mafia_chat=new StringBuffer();
	private StringBuffer detective_chat=new StringBuffer();
	private StringBuffer doctor_chat=new StringBuffer();
	private StringBuffer civilians_chat=new StringBuffer();
	public  int state=0;

	public Player whoGetLastIdentified=null;
	public Player whoGetLastKilled=null;
	public Player whoGetLastEliminated=null;
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
	long startTime=0;
	
	
	
	public long getStartTime() {
		return startTime;
	}

	public Game(String name) {

		startTime=System.currentTimeMillis();
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
		if (state!=START_STATE)
			return "Not permited in current game state ";
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
		if (state!=city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone)
			return "Not permited in current game state ";
		Player eliminated_player=null;
		players.get(player_uniqueID).killOtherPlayer(players.get(whom__uniqueID));
		return whom__uniqueID;
	}
	
	public String identifyPlayer(String player_uniqueID, String whom__uniqueID)
	{
		if (state!=city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone)
			return "Not permited in current game state ";
		players.get(player_uniqueID).identifyOtherPlayer(players.get(whom__uniqueID));
		return whom__uniqueID;
	}
	public String savePlayer(String player_uniqueID, String whom__uniqueID)
	{
		if (state!=city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone)
			return "Not permited in current game state ";
		players.get(player_uniqueID).saveOtherPlayer(players.get(whom__uniqueID));
		return whom__uniqueID;
	}
	public String eliminatePlayer(String player_uniqueID, String whom__uniqueID)
	{
		if (state!=city_wake_up_and_elimimate_someone)
			return "Not permited in current game state ";
		Player eliminated_player=null;
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
		//mafia_chat=new StringBuffer();
		//detective_chat=new StringBuffer();
		//doctor_chat=new StringBuffer();
		//civilians_chat=new StringBuffer(); 
		
		status_message="";
		status_message_for_Mafia=status_message;
		status_message_for_Detective=status_message;
		status_message_for_Doctor=status_message;
		status_message_for_Save=status_message;
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
		if (state!=city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone)
			return "Not permited in current game state ";
		
		status_message="";
		status_message_for_Save="";
		status_message_for_Mafia="";
		status_message_for_Detective="";
		status_message_for_Doctor="";
		
		Player kill_player=null;
		Player identify_player=null;
		List<Player> save_player=new ArrayList<Player>();
		boolean does_all_Mafia_voted=true;
		boolean does_all_Detective_voted=true;
		boolean does_all_Doctors_voted=true;
		for (Map.Entry<String, Player> player : players.entrySet()) 
		{
			if(player.getValue().isInGame() && !player.getValue().isKilled())
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
		}
		if(  does_all_Mafia_voted
		  && does_all_Detective_voted
		  && does_all_Doctors_voted)
		{
			int max_votes_Mafia=0;
			int max_votes_Detective=0;
			
			boolean isTieMafia=false;
			boolean isTieDetective=false;
			
			for (Map.Entry<String, Player> player : players.entrySet()) 
			{
				if(player.getValue().isInGame() && !player.getValue().isKilled())
				{
					if(player.getValue().getRole()!=Player.Mafia )
					{
						if(player.getValue().getKillVote() > max_votes_Mafia)
						{
							kill_player=player.getValue();
							max_votes_Mafia=player.getValue().getKillVote();
							isTieMafia=false;
						} else if(player.getValue().getKillVote() == max_votes_Mafia)
						{
							kill_player=player.getValue();
							max_votes_Mafia=player.getValue().getKillVote();
							isTieMafia=true;
						}
					}
					if(player.getValue().getRole()!=Player.Detective)
					{
						if(player.getValue().getIdentifyVote() > max_votes_Detective)
						{
							identify_player=player.getValue();
							max_votes_Detective=player.getValue().getIdentifyVote();
							isTieDetective=false;
						} else if(player.getValue().getIdentifyVote() == max_votes_Detective)
						{
							identify_player=player.getValue();
							max_votes_Detective=player.getValue().getIdentifyVote();
							isTieDetective=true;
						}
					} else  if(player.getValue().getRole()==Player.Doctor)
					{
						if(player.getValue().getWhoISaved()!=null)
							save_player.add(player.getValue().getWhoISaved());
					}
				}
			}
			if(max_votes_Detective<=0)
				isTieDetective=false;
			if(max_votes_Detective<=0)
				isTieMafia=false;
			
			if(isTieMafia || isTieDetective)
			{
				status_message="Cannot eliminate. Tie !!!";
				status_message_for_Save="Mafia and Detetive are struggling......";
				status_message_for_Mafia=isTieMafia?"Mafias resolve the Tie":"";
				status_message_for_Detective=isTieDetective?"Detective resolve the Tie":"";
				status_message_for_Doctor="Mafia and Detetive are struggling......";
			}
			else
			{
				for (Iterator savedplayer = save_player.iterator(); savedplayer.hasNext();) {
					Player player = (Player) savedplayer.next();
					if(kill_player==savedplayer)
						kill_player=null;
				}
				
				if(kill_player!=null)
				{
					kill_player.kill();
					whoGetLastEliminated=null;
					whoGetLastKilled=kill_player;
					status_message+="";
				}
				if(identify_player.getRole()==Player.Mafia)
				{
					identify_player.kill();
					whoGetLastEliminated=null;
					whoGetLastIdentified=identify_player;
					status_message+="";
				}
				this.goToNextState();
				this.resetPlayers();
				
				status_message_for_Save=status_message;
				status_message_for_Mafia=status_message;
				status_message_for_Detective=status_message;
				status_message_for_Doctor=status_message;
			}
				
			/*if(!isTie && eliminated_player!=null && max_votes >0)
			{
				eliminated_player.kill();
				this.goToNextState();
				this.resetPlayers();
			}
			else
			{
				
				status_message_for_Save=status_message;
				status_message_for_Mafia=status_message;
				status_message_for_Detective=status_message;
				status_message_for_Doctor=status_message;
				
				return "Cannot eliminate. Tie !!!";
			}
			
			
			
			for (Map.Entry<String, Player> player : players.entrySet()) 
				if(player.getValue().canKill())
					player.getValue().kill();
			this.goToNextState();
			this.resetPlayers();*/
		}
		else
		{
			status_message_for_Save="";
			status_message_for_Mafia=!does_all_Mafia_voted?"All Mafias not voted":"";
			status_message_for_Detective=!does_all_Detective_voted?"All Detectives not voted":"";
			status_message_for_Doctor=!does_all_Doctors_voted?"All Doctors not voted":"";
			status_message=status_message_for_Mafia+". "+status_message_for_Detective+". "+status_message_for_Doctor;
			
			return status_message;
		}
		return "";
	}
	
	public String calulateAndEliminate()
	{
		if (state!=city_wake_up_and_elimimate_someone)
			return "Not permited in current game state ";
		Player eliminated_player=null;
		int max_votes=0;
		boolean isTie=false;
		
		boolean does_all_Voted=true;
		for (Map.Entry<String, Player> player : players.entrySet()) 
		{
			if(player.getValue().isInGame() && !player.getValue().isKilled() && player.getValue().getWhoIEliminate()==null)
				does_all_Voted=false;
		}
		
		if(does_all_Voted)
		{
			for (Map.Entry<String, Player> player : players.entrySet()) 
			{
				if(player.getValue().isInGame() && !player.getValue().isKilled())
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
			}
			
			if(!isTie && eliminated_player!=null && max_votes >0)
			{
				eliminated_player.kill();
				whoGetLastEliminated=eliminated_player;
				whoGetLastIdentified=null;
				whoGetLastKilled=null;
				this.goToNextState();
				this.resetPlayers();
				
				status_message="City elimated '"+eliminated_player.name+"'";
				status_message_for_Save=status_message;
				status_message_for_Mafia=status_message;
				status_message_for_Detective=status_message;
				status_message_for_Doctor=status_message;
			}
			else
			{
				status_message="Cannot eliminate. Tie !!!";
				status_message_for_Save=status_message;
				status_message_for_Mafia=status_message;
				status_message_for_Detective=status_message;
				status_message_for_Doctor=status_message;
				
				return "Cannot eliminate. Tie !!!";
			}
		}else
		{
			status_message="Not all voted";
			status_message_for_Save=status_message;
			status_message_for_Mafia=status_message;
			status_message_for_Detective=status_message;
			status_message_for_Doctor=status_message;
			
			return "Not all voted ";
		}
		
		return "";
	}
	
	
	public void sendMessageToWhoNotVoted()
	{
		String Mafia_string="";
		String Detective_string="";
		String Doctors_string="";
		for (Map.Entry<String, Player> player : players.entrySet()) 
		{
			if(player.getValue().isInGame() && !player.getValue().isKilled() )
			{
				if( player.getValue().getRole()==Player.Mafia 	&& player.getValue().getWhoIKilled()==null)
					Mafia_string+=player.getValue().getName()+", ";
				else if( player.getValue().getRole()==Player.Detective 	&& player.getValue().getWhoIIdentified()==null)
					Detective_string+=player.getValue().getName()+", ";
				else if( player.getValue().getRole()==Player.Doctor 	&& player.getValue().getWhoISaved()==null)
					Doctors_string+=player.getValue().getName()+", ";
			}
					
		}
		
		if(!Mafia_string.equalsIgnoreCase(""))
			addChat(Player.Mafia, Mafia_string+"not voted.\n");
		if(!Detective_string.equalsIgnoreCase(""))
			addChat(Player.Detective, Detective_string+"not voted.\n");
		if(!Doctors_string.equalsIgnoreCase(""))
			addChat(Player.Doctor, Doctors_string+"not voted.\n"); 
	}
	
	public String getStatusMessage(Player forWhom) {
		switch (forWhom.getRole()) {
		case Player.Civilian:
			return  status_message_for_Save;
		case Player.Mafia:
			return  status_message_for_Mafia;
		case Player.Detective:
			return  status_message_for_Detective;
		case Player.Doctor:
			return  status_message_for_Doctor;
		default:
			return  status_message;
		}
	}
	
	public String getStatusMessage() {
			return  status_message+"<br>"
					+ "Civilians: "+status_message_for_Save+"<br>"
					+ "Mafia    : "+status_message_for_Mafia+"<br>"
					+ "Detective: "+status_message_for_Detective+"<br>"
					+ "Doctor   : "+status_message_for_Doctor+"<br>";
		
	}

	public int whoWonTheGame()
	{
		boolean does_Mafias_wins=true;
		boolean does_Civilians_wins=true;
		int no_of_Mafia=0;
		int no_of_Civilians=0;
		for (Map.Entry<String, Player> player : players.entrySet()) 
		{
			
			if( ( !player.getValue().isKilled() && player.getValue().isInGame() ) && player.getValue().getRole()==Player.Mafia)
			{
				does_Civilians_wins=false;
				no_of_Mafia++;
			}
			else if( ( !player.getValue().isKilled() && player.getValue().isInGame() ) && player.getValue().getRole()!=Player.Mafia)
			{
				does_Mafias_wins=false;
				no_of_Civilians++;
			}
		}
		
		if(no_of_Mafia==1 && no_of_Civilians==1 && state==Game.city_wake_up_and_elimimate_someone)
		{
			status_message="Its Tie !!!!!!!!";
			status_message_for_Save=status_message;
			status_message_for_Mafia=status_message;
			status_message_for_Detective=status_message;
			status_message_for_Doctor=status_message;
			return Player.Tie;
		}
		else if(no_of_Mafia==0 && no_of_Civilians==0 && ( state==Game.city_wake_up_and_elimimate_someone || state==Game.city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone ))
		{
			status_message="EveryOne dies !!!!!!!!";
			status_message_for_Save=status_message;
			status_message_for_Mafia=status_message;
			status_message_for_Detective=status_message;
			status_message_for_Doctor=status_message;
			return Player.EveryOneDies;
		}
		
		if(does_Civilians_wins && !does_Mafias_wins)
		{
			status_message="";
			status_message_for_Save=status_message;
			status_message_for_Mafia=status_message;
			status_message_for_Detective=status_message;
			status_message_for_Doctor=status_message;
			return Player.Civilian;
		}
		else if(!does_Civilians_wins && does_Mafias_wins)			
		{
			status_message="";
			status_message_for_Save=status_message;
			status_message_for_Mafia=status_message;
			status_message_for_Detective=status_message;
			status_message_for_Doctor=status_message;
			return Player.Mafia;	
		}
		else 
			return Player.NoOneYet;
		
	}

	// ----------------------------- TESTING -------------------------
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
		status_message="Game reseted";
		status_message_for_Mafia=status_message;
		status_message_for_Detective=status_message;
		status_message_for_Doctor=status_message;
		status_message_for_Save=status_message;
		mafia_chat=new StringBuffer();
		detective_chat=new StringBuffer();
		doctor_chat=new StringBuffer();
		civilians_chat=new StringBuffer();
		return "";
	}
	
	public String forceRemovePlayer(String player_uniqueID)
	{		
		players.get(player_uniqueID).removeFromGame();
		return "";
	}
	
	public String forceAddPlayer(String player_uniqueID)
	{		
		players.get(player_uniqueID).addInGame();
		return "";
	}
	
	
	// chat---------------------------------
	public StringBuffer  getChat(int role)
	{
		switch (role) {
		case Player.Mafia:
			return mafia_chat;
		case Player.Detective:
			return detective_chat;
		case Player.Doctor:
			return doctor_chat;
		default:
			return civilians_chat;
		}
	}
	
	public StringBuffer getChat(String player_uniqueID)
	{
		Player accessingPlayer=players.get(player_uniqueID) ;
		switch (accessingPlayer.getRole()) {
		case Player.Mafia:
			return mafia_chat;
		case Player.Detective:
			return detective_chat;
		case Player.Doctor:
			return doctor_chat;
		default:
			return civilians_chat;
		}
	}
	
	public void  addChat(String player_uniqueID, String chatMsg)
	{
		
		
		Player accessingPlayer=players.get(player_uniqueID) ;
		switch (accessingPlayer.getRole()) {
		case Player.Mafia:
			mafia_chat.append(accessingPlayer.getName()+" : "+chatMsg);
			break;
		case Player.Detective:
			detective_chat.append(accessingPlayer.getName()+" : "+chatMsg);
			break;
		case Player.Doctor:
			doctor_chat.append(accessingPlayer.getName()+" : "+chatMsg);
			break;
		default:
			civilians_chat.append(accessingPlayer.getName()+" : "+chatMsg);
			break;
		}
	}
	public void  addChat(int role, String chatMsg)
	{
		
		switch (role) {
		case Player.Mafia:
			mafia_chat.append("Superviser : "+chatMsg);
			break;
		case Player.Detective:
			detective_chat.append("Superviser : "+chatMsg);
			break;
		case Player.Doctor:
			doctor_chat.append("Superviser : "+chatMsg);
			break;
		default:
			civilians_chat.append("Superviser : "+chatMsg);
			break;
		}
	}
	
}
