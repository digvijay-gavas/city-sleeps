package game.global;

import java.util.UUID;

public class Player {
    //public enum roles {Civilian,Detective,Doctor};
    private int role;
    //private int votes = 0;
    //private Player votedTo;
    private int killVote = 0;
    private int identifyVote = 0;
    private int saveVote = 0;
    private int eliminateVote = 0;
    
    private boolean isKilled = false;
    private boolean isInGame = true;
    //Player whoKilledme=null;
    Player whoIKilled=null;
    Player whoIIdentified=null;
    Player whoISaved=null;
    Player whoIEliminate=null;
    public final String uniqueID = UUID.randomUUID().toString();
    String name;
    
    final public static int Civilian=0;
    final public static int Mafia=1;
    final public static int Detective=2;
    final public static int Doctor=3;
    
    public Player(String name) {
		this.name=name;
	}

	/*public void vote()
    {
    	if(votes>=0)
    		votes++;
    }
    
    public void devote()
    {
    	if(votes>0)
    		votes--;
    }*/
    
    public void setRole(int role)
    {
    	this.role=role;
    }
    
    public int getRole()
    {
    	return this.role;
    }

	/*public int getVotes() {
		return votes;
	}

	public void setVotes(int votes) {
		this.votes = votes;
	}

	public Player getVotedTo() {
		return votedTo;
	}

	public void setVotedTo(Player votedTo) {
		this.votedTo = votedTo;
	}*/

	public boolean isKilled() {
		return isKilled;
	}

	public void setKilled(boolean isKilled) {
		this.isKilled = isKilled;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Player getWhoIKilled() {
		return whoIKilled;
	}

	public void setWhoIKilled(Player whoIKilled) {
		this.whoIKilled = whoIKilled;
	}
	
	public Player getWhoIIdentified() {
		return whoIIdentified;
	}

	public void setWhoIIdentified(Player whoIIdentified) {
		this.whoIIdentified = whoIIdentified;
	}

	public Player getWhoISaved() {
		return whoISaved;
	}

	public void setWhoISaved(Player whoISaved) {
		this.whoISaved = whoISaved;
	}

	public Player getWhoIEliminate() {
		return whoIEliminate;
	}

	public void setWhoIEliminate(Player whoIEliminate) {
		this.whoIEliminate = whoIEliminate;
	}

	/*public void kill(Player whoKilledme) {
		if(whoKilledme==null)
		{
			isKilled=true;
			this.whoKilledme=whoKilledme;
			this.whoKilledme.setWhoIKilled(this);
		}
		else
		{
			this.whoKilledme.setWhoIKilled(this);
		}
	}*/
	// ---------------------------- Kill ---------------------
	public void killOtherPlayer(Player whom) {
		if(whoIKilled!=null)
			whoIKilled.removeKillVote();
		whom.killVote();
		whoIKilled=whom;
	}
	
	public void killVote()
	{
		killVote++;
	}
    
	public void removeKillVote()
	{
		if(killVote>0)
			killVote--;
	}
	
	public int getKillVote()
	{
		return killVote;
	}
	
	// ---------------------------- Identify ---------------------
	public void identifyOtherPlayer(Player whom) {
		if(whoIIdentified!=null)
			whoIIdentified.removeIdentifyVote();
		whom.identifyVote();
		whoIIdentified=whom;
	}
	
	public void identifyVote()
	{
		identifyVote++;
	}
    
	public void removeIdentifyVote()
	{
		if(identifyVote>0)
			identifyVote--;
	}
	
	public int getIdentifyVote()
	{
		return identifyVote;
	}
	
	// ---------------------------- Save ---------------------
	public void saveOtherPlayer(Player whom) {
		if(whoISaved!=null)
			whoISaved.removeSaveVote();
		whom.saveVote();
		whoISaved=whom;
	}
	
	public void saveVote()
	{
		saveVote++;
	}
    
	public void removeSaveVote()
	{
		if(saveVote>0)
			saveVote--;
	}
	
	public int getSaveVote()
	{
		return saveVote;
	}
	// ---------------------------- Eliminate ---------------------
	public void eliminateOtherPlayer(Player whom) {
		if(whoIEliminate!=null)
			whoIEliminate.removeEliminateVote();
		whom.eliminateVote();
		whoIEliminate=whom;
	}
	
	public void eliminateVote()
	{
		eliminateVote++;
	}
    
	public void removeEliminateVote()
	{
		if(eliminateVote>0)
			eliminateVote--;
	}
	
	public int getEliminateVote()
	{
		return eliminateVote;
	}
	//---------------------------------------------------------
	
	public boolean canKill()
	{
		if(role!=Mafia && killVote > 0 && saveVote == 0 )
			return true;
		else if(role==Mafia && identifyVote > 0)
			return true;
		return false;
	}
	
	
	public void kill()
	{
		isKilled=true;
	}

	public void addInGame()
	{
		isInGame=true;
	}
	public void removeFromGame()
	{
		isInGame=false;
	}
	
	public boolean isInGame()
	{
		return isInGame;
	}
	public void reset() {
	    this.killVote = 0;
	    this.identifyVote = 0;
	    this.saveVote = 0;
	    this.eliminateVote = 0;

	    this.whoIKilled=null;
	    this.whoIIdentified=null;
	    this.whoISaved=null;
	    this.whoIEliminate=null;
		
	}
	public void hardReset()
	{
		isKilled=false;
		this.reset();
	}
	
	
    
}
