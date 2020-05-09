<%@page import="game.global.Game"%>
<%@page import="game.global.Constant"%>
<%@page import="game.global.Player"%>
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

	/*if (request.getParameter("is_new") != null && request.getParameter("is_new").equalsIgnoreCase("true") ) {
		game_uniqueID=GamesStorage.addGame(request.getParameter("game_name"));
		response.addCookie(new Cookie("game_uniqueID",
				new String(Base64.encodeBase64(game_uniqueID.getBytes()))));
	} else {*/
		Cookie cookie = null;
		Cookie[] cookies = null;
		cookies = request.getCookies();
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				cookie = cookies[i];
				if (cookie.getName().equalsIgnoreCase("game_uniqueID")) {
					//game_uniqueID = new String(Base64.decodeBase64(cookie.getValue()));
					game_uniqueID =cookie.getValue();
				}
			}
		}
	//}
	

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
	Game game=GamesStorage.getGame(game_uniqueID);
%>
<title><%=game!=null?game.getName():"" + "("+game_uniqueID+")"%></title>
<jsp:include page="clientJSFunctions.jsp">
		<jsp:param name="game_uniqueID" value="<%=game_uniqueID%>" />
</jsp:include>
</head>
	<body>
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
					for (Map.Entry<String, Player> player : players.entrySet()) 
					{
						%>
						<tr>
							<td><%=player.getValue().getName()%></td> 
							<td><%=Constant.GAME_ROLES[player.getValue().getRole()]%></td>
							<td><%=player.getValue().getVotes()%></td>
							<td><%=players.get(player.getValue().getVotedTo())%></td>
						</tr>
						<%
					}
					%></table><%
				}
			%>
		</div>
	</body>
</html>