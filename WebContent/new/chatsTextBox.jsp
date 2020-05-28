<%@page import="game.global.Player"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="game.global.Constant"%>
<%@page import="game.global.GamesStorage"%>
<%
try{
	

	String game_uniqueID = request.getParameter("game_uniqueID");
	String player_uniqueID = request.getParameter("player_uniqueID");
	String player_typeID_STRING= request.getParameter("player_typeID");
	String is_superviser= request.getParameter("is_superviser");
	int player_typeID=Player.NoOneYet;
	if(player_typeID_STRING == null)
		player_typeID=Player.NoOneYet ;
	else 
		player_typeID=Integer.parseInt(player_typeID_STRING);
	
	 
	
	//Encode data on your side using BASE64
	
	//System.out.println("encoded value is " + new String(bytesEncoded));
	
	//Decode data on other side, by processing encoded data
	//byte[] valueDecoded = Base64.decodeBase64(bytesEncoded);
	//System.out.println("Decoded value is " + new String(valueDecoded));
	
	if(is_superviser!=null && is_superviser.equalsIgnoreCase("true")) 
	{
		byte[] bytesEncoded = Base64.encodeBase64(GamesStorage.getGame(game_uniqueID).getChat(player_typeID).toString().getBytes());
		%>{
		 "chats":	"<%=new String(bytesEncoded)%>" ,
		 "player_type": "<%=Constant.GAME_ROLES[player_typeID]%>",
		 "player_role": <%=player_typeID%>
		 }
	 	<%
	}
	else
	{
		byte[] bytesEncoded = Base64.encodeBase64(GamesStorage.getGame(game_uniqueID).getChat(player_uniqueID).toString().getBytes());
		%>{
		 "chats":	"<%=new String(bytesEncoded)%>" ,
		 "player_type": "<%=Constant.GAME_ROLES[GamesStorage.getGame(game_uniqueID).getPlayer(player_uniqueID).getRole()]%>",
		 "player_role": <%=GamesStorage.getGame(game_uniqueID).getPlayer(player_uniqueID).getRole()%>
		 }
		 <%
	}
}
catch (Exception e)
{
}
%>


 
  