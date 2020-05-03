<%@page import="java.util.Map"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="game.global.Storage"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%!%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String player_name = null;
	String game_name = null;

	if (request.getParameter("is_new") != null && request.getParameter("is_new").equalsIgnoreCase("new")) {
		Storage.joinGame(request.getParameter("game_name"), request.getParameter("player_name"));
		game_name = request.getParameter("game_name");
		player_name = request.getParameter("player_name");
		response.addCookie(new Cookie("game_name",
				new String(Base64.encodeBase64(request.getParameter("game_name").getBytes()))));
		response.addCookie(new Cookie("player_name",
				new String(Base64.encodeBase64(request.getParameter("player_name").getBytes()))));
	} else {
		Cookie cookie = null;
		Cookie[] cookies = null;
		cookies = request.getCookies();
		if (cookies != null) {

			for (int i = 0; i < cookies.length; i++) {
				cookie = cookies[i];
				if (cookie.getName().equalsIgnoreCase("player_name")) {
					player_name = new String(Base64.decodeBase64(cookie.getValue()));
				} else if (cookie.getName().equalsIgnoreCase("game_name")) {
					game_name = new String(Base64.decodeBase64(cookie.getValue()));
				}
			}
		}

		/* voting for player name */
		String voted_player_name = request.getParameter("voted_player_name");
		if (voted_player_name != null) {
			Storage.votePlayer(game_name, player_name, voted_player_name);
		}
	}

	if (!Storage.isGameExist(game_name)) {
%>sorry game expired on server<%
	Cookie to_delete = new Cookie("game_name", "");
		to_delete.setMaxAge(0);
		response.addCookie(to_delete);
		to_delete = new Cookie("player_name", "");
		to_delete.setMaxAge(0);
		response.addCookie(to_delete);
	}
%>
<title><%=player_name%>(<%=game_name%>)</title>
<!-- meta http-equiv="refresh" content="30" -->
</head>
<body>
	<jsp:include page="game_status_banner.jsp">
		<jsp:param name="game_name" value="<%=game_name%>" />
		<jsp:param name="player_name" value="<%=player_name%>" />
	</jsp:include>
	<jsp:include page="PlayersPlayboard.jsp">
		<jsp:param name="game_name" value="<%=game_name%>" />
		<jsp:param name="player_name" value="<%=player_name%>" />
	</jsp:include>
</body>
</html>