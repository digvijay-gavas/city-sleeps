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

	// game_name = request.getParameter("game_name");

	if (cookies != null) {

		for (int i = 0; i < cookies.length; i++) {
			cookie = cookies[i];
			if (cookie.getName().equalsIgnoreCase("game_name")) {
				if (request.getParameter("game_name") != null
						&& !cookie.getValue().equalsIgnoreCase(request.getParameter("game_name"))) {
%>
<script>
	alert("you started new game..." +
<%=request.getParameter("game_name")%>
	);
</script>
<%
	}
				game_name = new String(Base64.decodeBase64(cookie.getValue()));
			}
		}
	}
	if (game_name == null) {
		Storage.addGame(request.getParameter("game_name"));
		game_name = request.getParameter("game_name");
		response.addCookie(new Cookie("game_name",
				new String(Base64.encodeBase64(request.getParameter("game_name").getBytes()))));
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
<title><%=game_name%></title>
<meta http-equiv="refresh" content="10">
</head>
<body>
	<h1><%=game_name%></h1>
	waiting for players to join..........
	<jsp:include page="PlayersList.jsp">
		<jsp:param name="game_name" value="<%=game_name%>" />
	</jsp:include>

	<form action="start.jsp" method="POST">
		<tr>
			<td><input type="submit" value="Start"></input></td>
		</tr>
	</form>
</body>
</html>