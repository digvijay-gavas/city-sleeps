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
	String game_name = request.getParameter("game_name");
	String player_name = request.getParameter("player_name");
%>
</head>
<body>

	<ol>
		<%
			Map<String, int[]> players = Storage.getPlayers(game_name);
			if (players == null) {
		%>
		sorry game expired on server<%
			} else
				for (Map.Entry<String, int[]> player : players.entrySet()) {

					if (player_name == null) {
						%><li><%=(String) player.getKey() + " -- " + player.getValue()[0]%></li>
						<%
					} else 
					{
						%><li><%=(String) player.getKey()%></li>
						<%
					}
				}
		%>
	</ol>
</body>
</html>