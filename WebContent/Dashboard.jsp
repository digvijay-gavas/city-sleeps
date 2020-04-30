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

	<table>
		<tr>
			<th>Welcome to city sleeps</th>
		</tr>
		<form action="superviser-waiting-for-players.jsp"  method="POST">
		<tr>
			<td><input type="text" value="We Are Civilian" name="game_name"></input></td>
			<td><input type="submit" value="CreateGame"></input></td>
		</tr>
		</form>
		<form action="player-waiting-for-admin-to-start.jsp"  method="POST">
		<tr>
			<td><input type="text" value="Digi" name="player_name"></input></td>
			<td><select name="game_name">
					<%
						for (Iterator iterator = Storage.getGames().iterator(); iterator.hasNext();) {
							String game_name = (String) iterator.next();
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