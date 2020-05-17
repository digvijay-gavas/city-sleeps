<%@page import="game.global.GamesStorage"%>
<%
String game_uniqueID = request.getParameter("game_uniqueID");
String player_uniqueID = request.getParameter("player_uniqueID");
%>
<%=GamesStorage.getGame(game_uniqueID).getChat(player_uniqueID)%>.........