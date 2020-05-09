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

	if (request.getParameter("is_new") != null && request.getParameter("is_new").equalsIgnoreCase("true")) {
		Game game=GamesStorage.getGame(request.getParameter("game_name")/*game_uniqueID*/);
		game_uniqueID = game.uniqueID;
		player_uniqueID = game.addPlayer(request.getParameter("player_name"));
		response.addCookie(new Cookie("game_uniqueID",
				new String(Base64.encodeBase64(game_uniqueID.getBytes()))));		
		response.addCookie(new Cookie("player_uniqueID",
				new String(Base64.encodeBase64(player_uniqueID.getBytes()))));
	} else {
		Cookie cookie = null;
		Cookie[] cookies = null;
		cookies = request.getCookies();
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				cookie = cookies[i];
				if (cookie.getName().equalsIgnoreCase("player_uniqueID")) {
					player_uniqueID = new String(Base64.decodeBase64(cookie.getValue()));
				} else if (cookie.getName().equalsIgnoreCase("game_uniqueID")) {
					game_uniqueID = new String(Base64.decodeBase64(cookie.getValue()));
				}
			}
		}
	}
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
%>
<title><%=GamesStorage.getGame(game_uniqueID).getPlayer(player_uniqueID).getName() +"  - " + GamesStorage.getGame(game_uniqueID).getName()%></title>

<jsp:include page="clientJSFunctions.jsp">
		<jsp:param name="game_uniqueID" value="<%=game_uniqueID%>" />
		<jsp:param name="player_uniqueID" value="<%=player_uniqueID%>" />
</jsp:include>
	
</head>
<body>

</body>
</html>