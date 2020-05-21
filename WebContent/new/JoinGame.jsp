<%@page import="game.global.Player"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="game.global.Game"%>
<%@page import="java.util.Map"%>
<%@page import="game.global.GamesStorage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>City-Sleeps</title>
	<jsp:include page="dasboardJSFunction.jsp"/>
	</head>
	<body>
		<div id="banner_div">
		</div>
		<div id="player_list_div">
		</div>
		
		<%
		String game_uniqueID = null;
		String player_uniqueID = null; 
		String game_uniqueID_from_param = request.getParameter("game_uniqueID");
		Game game = null;
		Player player = null;
		
	
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
						//game_uniqueID = new String(Base64.decodeBase64(cookie.getValue()));
						game_uniqueID = cookie.getValue();
					}
				}
			}
			
			game = GamesStorage.getGame(game_uniqueID);
			if(game!=null)
				player = game.getPlayer(player_uniqueID);
			
			if (request.getParameter("end_game") != null && request.getParameter("end_game").equalsIgnoreCase("true"))
			{

				Cookie to_delete = new Cookie("game_uniqueID", "");
				to_delete.setMaxAge(0);
				to_delete.setPath("/");
				response.addCookie(to_delete);
				to_delete = new Cookie("player_uniqueID", "");
				to_delete.setMaxAge(0);
				to_delete.setPath("/");
				response.addCookie(to_delete);
				game_uniqueID = null;
				player_uniqueID = null; 
			}
			
		%>
		<%
		if (game != null && player != null) {
		%>
		<form action="Player.jsp" method="POST">
			<input type="hidden" value="<%=game.uniqueID%>" name="game_uniqueID"></input>
			<input type="hidden" value="<%=player.uniqueID%>" name="player_uniqueID"></input>
			<input type="submit"
				value="Resume game '<%=game.getName()%>' as '<%=player.getName()%>'"></input>
		</form>
		
		<form action="JoinGame.jsp" method="POST">
			<input type="hidden" value="<%=game.uniqueID%>" name="game_name"></input>
			<input type="hidden" value="true" name="end_game"></input>
			<input type="submit" value="End Game'<%=game.getName()%>'"></input>
		</form>
		<%
			} else {
		%>
		
		<div id="create_game_div">
			<br>
			<input type="text" value="Digi<%=" "+(100+Math.round(Math.random()*900))%>" id="join_player_name" /> 
			<% 
			if(game_uniqueID_from_param!=null)
			{	
				%>
				<label><%=GamesStorage.getGame(game_uniqueID_from_param).getName()%></label>
				<button onclick="setCookie('game_uniqueID','<%=game_uniqueID_from_param%>',1);callMethodRedirect('joinGame','player_uniqueID','Player.jsp','<%=game_uniqueID_from_param%>', document.getElementById('join_player_name').value);">Join Game</button>
				<%
			} else
			{ 
				%>
				<select id="join_game_uniqueID">
					<%
					for ( Map.Entry<String, Game> gameEntry : GamesStorage.getJoinableGames().entrySet())  {
					
					%><option value="<%=gameEntry.getKey()%>"><%=gameEntry.getValue().getName() + "(" +gameEntry.getKey()+")"%></option>
					<%
						}
					%>
				</select> 
				<button onclick="setCookie('game_uniqueID',document.getElementById('join_game_uniqueID').options[document.getElementById('join_game_uniqueID').selectedIndex].value,1);callMethodRedirect('joinGame','player_uniqueID','Player.jsp',document.getElementById('join_game_uniqueID').options[document.getElementById('join_game_uniqueID').selectedIndex].value, document.getElementById('join_player_name').value);">Join Game</button>
				<%
			} 
			%>
			

		</div>
		<div id="status_div"></div>
		<%} %>
	</body>
</html>