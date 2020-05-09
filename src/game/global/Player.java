package game.global;

import java.util.UUID;

public class Player {
    public enum roles {Civilian,Detective,Doctor};
    private int role;
    private int votes = 1;
    private Player votedTo;
    private boolean isKilled = false;
    public final String uniqueID = UUID.randomUUID().toString();
    String name;
    
    public Player(String name) {
		this.name=name;
	}

	public void vote()
    {
    	if(votes>=0)
    		votes++;
    }
    
    public void devote()
    {
    	if(votes>0)
    		votes--;
    }
    
    public void setRole(int role)
    {
    	this.role=role;
    }
    
    public int getRole()
    {
    	return this.role;
    }

	public int getVotes() {
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
	}

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
    
    
}
