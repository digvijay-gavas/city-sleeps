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

	<%
		Map<String, String[]> players = Storage.getPlayers(game_name);
		if (players == null) {
	%>
	sorry game expired on server

	<%
		} else {
	%><table>
		<%
			String who_am_i = players.get(player_name)[0]; /* Mafia/Detective/Doctor/Civilian */
				if (who_am_i.equalsIgnoreCase("Civilian")) {
					who_am_i = "";
				}
				for (Map.Entry<String, String[]> player : players.entrySet()) {
		%>
		<tr>
			<%
				if (player.getValue()[0].equalsIgnoreCase(who_am_i)) {
			%>
			<td><%=player.getKey()%></td>
			<td><%=player.getValue()[0]%></td>
			<%
				} else {
			%>
			<td><%=(String) player.getKey()%></td>			
			<%
					if (Storage.canMafiaKill(game_name,player_name)) 
					{
						String voted_player_name=Storage.whoIVoted(game_name, player_name);
						if(voted_player_name!=null && voted_player_name.equalsIgnoreCase(player.getKey()))
						{
							//if(voted_player_name.equalsIgnoreCase(player.getKey()))
							//{
								%>
								<td></td>
								<%
							//}
						}
						else
						{
						%><td>
						<form action="player-waiting-for-admin-to-start.jsp">
							<input type="hidden" value="<%=player.getKey()%>" name="voted_player_name">
							<input type="submit" value="kill"/>
						</form>
						</td>
						<%
						} %>
						
						<td><%=player.getValue()[1]!=null? (player.getValue()[1] + " votes"):""%></td><%
						
					}
				}
			%>
			</tr>
		<%
			}
		%>
	</table>
	<%
		}
	%>
</body>
</html>