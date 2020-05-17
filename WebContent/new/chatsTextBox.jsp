<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="game.global.Constant"%>
<%@page import="game.global.GamesStorage"%>
<%
String game_uniqueID = request.getParameter("game_uniqueID");
String player_uniqueID = request.getParameter("player_uniqueID");

//Encode data on your side using BASE64
byte[] bytesEncoded = Base64.encodeBase64(GamesStorage.getGame(game_uniqueID).getChat(player_uniqueID).toString().getBytes());
//System.out.println("encoded value is " + new String(bytesEncoded));

//Decode data on other side, by processing encoded data
//byte[] valueDecoded = Base64.decodeBase64(bytesEncoded);
//System.out.println("Decoded value is " + new String(valueDecoded));
%>
 {
 "chats":	"<%=new String(bytesEncoded)%>" ,
 "player_type": "<%=Constant.GAME_ROLES[GamesStorage.getGame(game_uniqueID).getPlayer(player_uniqueID).getRole()]%>",
 "player_role": <%=GamesStorage.getGame(game_uniqueID).getPlayer(player_uniqueID).getRole()%>
 }
  