<%@page import="game.global.Constant"%>
<%@page import="game.global.Player"%>
<%@page import="game.global.Game"%>
<%@page import="game.global.GamesStorage"%>
<%@page import="java.util.Map"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="java.util.Iterator"%>
<%@page import="game.global.Storage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%!%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String game_uniqueID = null;
	String player_uniqueID = null; 

	Cookie cookie = null;
	Cookie[] cookies = null;
	cookies = request.getCookies();
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) {
			cookie = cookies[i];
			if (cookie.getName().equalsIgnoreCase("player_uniqueID")) {
				//player_uniqueID = new String(Base64.decodeBase64(cookie.getValue()));
				player_uniqueID = cookie.getValue();
			} else if (cookie.getName().equalsIgnoreCase("game_uniqueID")) {
				game_uniqueID = cookie.getValue();
			}
		}
	}
	Game game=GamesStorage.getGame(game_uniqueID);
	Player player=null;
	if(game!=null)
		player=GamesStorage.getGame(game_uniqueID).getPlayer(player_uniqueID);
	if (game!=null && player!=null ) 
	{	
%>

<title><%=player.getName() +"  - " + game.getName()%></title>
	<%} %>
<jsp:include page="clientJSFunctions.jsp">
		<jsp:param name="game_uniqueID" value="<%=game_uniqueID%>" />
		<jsp:param name="player_uniqueID" value="<%=player_uniqueID%>" />
		<jsp:param name="auto_refersh_page" value="Player.jsp" />
		<jsp:param name="auto_refersh_div" value="#players_div" />
</jsp:include>
	
</head>
<body>
	<%
	if (!GamesStorage.isGameExist(game_uniqueID)) 
	{
		%>sorry game expired on server<%
		Cookie to_delete = new Cookie("game_uniqueID", "");
		to_delete.setMaxAge(0);
		response.addCookie(to_delete);
		to_delete = new Cookie("player_uniqueID", "");
		to_delete.setMaxAge(0);
		response.addCookie(to_delete);
	}
	else
	{%>
	<div id="status_div">
		<%=game.getName() + "("+game.uniqueID+")"%>
	</div>
	
	<div id="players_div">
		<%=System.currentTimeMillis()%>
		<%
			Map<String, Player> players = game.getPlayers();
			if (!GamesStorage.isGameExist(game.uniqueID)) {
				%>sorry game expired on server<%
			} else 
			{
				%><table border="1">
				<tr>
					<th>Player</th>
					<th>Role</th>
					<th>Votes</th>
					<th>Voted to</th>
	
				</tr><%
				for (Map.Entry<String, Player> i_Player : players.entrySet()) 
				{
					%>
					<tr>
						<td><%=i_Player.getValue().getName()%></td> 
						<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian ?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
						<td><%=i_Player.getValue().getVotes()%></td>
						<td><%=players.get(i_Player.getValue().getVotedTo())%></td>
					</tr>
					<%
				}
				%></table><%
			}
		%>
	</div>
	
	<%
	}
	%>
</body>
</html>