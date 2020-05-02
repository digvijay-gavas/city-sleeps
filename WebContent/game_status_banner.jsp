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
	String game_state = Storage.getGameState(game_name);
%>
</head>
<body>

	<%
		if (player_name != null) {
	%><h2><%=player_name + "  playing '" + game_name+"'"%></h2>
	<h3><%="" + game_state%></h3>
	<%
		} else {
			%><h2><%= game_name%></h2>
			<h2><%=game_state%></h2>
			<%
		}
	%>

</body>
</html>