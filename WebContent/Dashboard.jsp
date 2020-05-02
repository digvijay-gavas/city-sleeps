<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="game.global.Storage"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta http-equiv="refresh" content="10">
</head>
<body>

	<%
		String player_name = null;
		String game_name = null;

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
	%>
	<%
		if (game_name != null && player_name != null) {
	%>
	<form action="player-waiting-for-admin-to-start.jsp" method="POST">
		<input type="hidden" value="<%=game_name%>" name="game_name"></input>
		<input type="hidden" value="<%=player_name%>" name="player_name"></input>
		<input type="submit"
			value="Resume game '<%=game_name%>' as '<%=player_name%>'"></input>
	</form>
	<%
		} else if (game_name != null) {
	%>
	<form action="superviser-waiting-for-players.jsp" method="POST">
		<input type="hidden" value="<%=game_name%>" name="game_name"></input>
		<input type="submit" value="Resume game supervision '<%=game_name%>'"></input>
	</form>
	<%
		}
	%>
	<table>
		<tr>
			<th>Welcome to city sleeps</th>
		</tr>
		<form action="superviser-waiting-for-players.jsp" method="POST">
			<tr>
				<td><input type="text" value="We Are Civilian" name="game_name"></input></td>
				<td><input type="submit" value="CreateGame"></input></td>
			</tr>
		</form>
		<form action="player-waiting-for-admin-to-start.jsp" method="POST">
			<tr>
				<td><input type="text" value="Digi" name="player_name"></input></td>
				<td><select name="game_name">
						<%
							for (Iterator iterator = Storage.getGames().iterator(); iterator.hasNext();) {
								game_name = (String) iterator.next();
						%><option value="<%=game_name%>"><%=game_name%></option>
						<%
							}
						%>
				</select></td>
				<td><input type="submit" value="JoinGame"></input></td>
			</tr>
		</form>

	</table>

</body>
</html>