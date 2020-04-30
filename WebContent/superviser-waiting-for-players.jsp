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
	String game_name = null;
	Cookie cookie = null;
	Cookie[] cookies = null;
	cookies = request.getCookies();
	if (cookies != null) {

		for (int i = 0; i < cookies.length; i++) {
			cookie = cookies[i];
			if (cookie.getName().equalsIgnoreCase("game_name")) {
				game_name = new String(Base64.decodeBase64(cookie.getValue()));
			}
		}
	}
	if (game_name == null) {
		Storage.addGame(request.getParameter("game_name"));
		game_name=request.getParameter("game_name");
		response.addCookie(new Cookie("game_name",
				new String(Base64.encodeBase64(request.getParameter("game_name").getBytes()))));
	}
%>
<title><%=game_name%></title>
<meta http-equiv="refresh" content="10">
</head>
<body>
	<h1><%=game_name%></h1>
	waiting for playesrs to join..........
	<ol>
		<%
		
		for (Map.Entry<String, int[]> player : Storage.getPlayers(game_name).entrySet() ) {
						
			%><li><%=(String) player.getKey() +" -- "+ player.getValue()[0]%></li>
			<%
			// System.out.println(player.getKey() + "/" + player.getValue());
		}
			//for (Iterator iterator = Storage.getPlayers(game_name).iterator(); iterator
			//		.hasNext();) {

			//}
		%>
	</ol>

	<form action="start.jsp" method="POST">
		<tr>
			<td><input type="submit" value="Start"></input></td>
		</tr>
	</form>
</body>
</html>