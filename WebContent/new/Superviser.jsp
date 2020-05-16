<%@page import="game.global.Game"%>
<%@page import="game.global.Constant"%>
<%@page import="game.global.Player"%>
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

	Cookie cookie = null;
	Cookie[] cookies = null;
	cookies = request.getCookies();
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) {
			cookie = cookies[i];
			if (cookie.getName().equalsIgnoreCase("game_uniqueID")) {
				//game_uniqueID = new String(Base64.decodeBase64(cookie.getValue()));
				game_uniqueID =cookie.getValue();
			}
		}
	}
	Game game=GamesStorage.getGame(game_uniqueID);
%>
<title><%=game!=null?game.getName():"" + "("+game_uniqueID+")"%></title>
<jsp:include page="clientJSFunctions.jsp">
		<jsp:param name="game_uniqueID" value="<%=game_uniqueID%>" />
		<jsp:param name="auto_refersh_page" value="Superviser.jsp" />
		<jsp:param name="auto_refersh_div" value="#players_div" />
</jsp:include>
</head>
	<body>
	<%
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
	else
	{
	%>
		<div id="status_div">
		<%=game.getName() + "("+game.uniqueID+")"%>
		
		</div>
		<div id="players_div">
			<%=System.currentTimeMillis()%>
			<%=Constant.GAME_STATES[game.getState()]%>
			<%
				Map<String, Player> players = game.getPlayers();
				if (!GamesStorage.isGameExist(game.uniqueID)) {
					%>sorry game expired on server<%
				} else 
				{
					%><table border="1">
					<tr>
						<th>Player</th>
						<th>Role</th>
						<%
						if(game.getState()==Game.city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone) 
						{
							%>
							<th>kill Vote</th>
							<th>Identify Vote</th>
							<th>Save Vote</th>
							<th>Can kill</th>
							<%
						} else  if(game.getState()==Game.city_wake_up_and_elimimate_someone) 
						{
							%><th>Eliminate Votes</th><%
						} 
						%>
		
					</tr><%
					for (Map.Entry<String, Player> player : players.entrySet()) 
					{
						%>
						<tr 
						<%
						if(!player.getValue().isInGame())
						{
							%>style="background-color:#AAAAAA"<%
						}
						else if(player.getValue().isKilled())
						{
							%>style="background-color:#FFAAAA"<%
						}
						%> 
						> 
							<td><%=player.getValue().getName()%></td> 
							<td><%=Constant.GAME_ROLES[player.getValue().getRole()]%></td>
							
							
							
							<%
						if(game.getState()==Game.city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone) 
						{
							%>
							<td><%=player.getValue().getKillVote()%></td>
							<td><%=player.getValue().getIdentifyVote()%></td>
							<td><%=player.getValue().getSaveVote()%></td>
							<td><%=player.getValue().canKill()?"Yes":""%></td>
							<%
						} else  if(game.getState()==Game.city_wake_up_and_elimimate_someone) 
						{
							%><td><%=player.getValue().getEliminateVote()%></td><%
						} 
						%>
						</tr>
						<%
					}
					%></table><%
				}
			%>
		</div>
	
	
		<div id="actions_div">
			
			<%
			switch(game.getState())
			{
			case Game.waiting:
				%>
				<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','startGame');"><%=Constant.GAME_STATES[game.getNextState()]%></button>
				<%
				break;
			case Game.START_STATE:
				%>
				<%
				double no_of_players=players.size();
				long max_Mafia=Math.round(no_of_players*0.2);
				long max_Detective=Math.round(no_of_players*0.2);
				long max_Doctor=Math.round(no_of_players*0.2);
				%>
				Mafia:<select id="no_of_mafia"><%for (int i=1;i<= max_Mafia+1; i++) {%><option value="<%=i%>"><%=i%></option><%}%></select> 
				Detective:<select id="no_of_detective"><%for (int i=1;i<= max_Detective; i++) {%><option value="<%=i%>"><%=i%></option><%}%></select>
				Doctor:<select id="no_of_doctor"><%for (int i=1;i<= max_Doctor; i++) {%><option value="<%=i%>"><%=i%></option><%}%></select>
				<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','assignRoles',
					document.getElementById('no_of_mafia').options[document.getElementById('no_of_mafia').selectedIndex].value,
					document.getElementById('no_of_detective').options[document.getElementById('no_of_detective').selectedIndex].value,
					document.getElementById('no_of_doctor').options[document.getElementById('no_of_doctor').selectedIndex].value
					);"><%=Constant.GAME_STATES[game.getNextState()]%></button>
						
				<br>
				<%
				break;
			case Game.assign_roles:
				%>
				<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','startGame');">Next: <%=Constant.GAME_STATES[game.getNextState()]%></button>
				<%
				break;
			case Game.city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone:
				
				%>
				<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','calulateAndKill');">Next: <%=Constant.GAME_STATES[game.getNextState()]%></button>
				<%
				break;
			case Game.city_wake_up_and_elimimate_someone:
				%>
				<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','calulateAndEliminate');">Next: <%=Constant.GAME_STATES[game.getNextState()]%></button>
				<%
				break;
			}
			%>
			<br>
			<br>
			<br>
			<br>
			<br>
			----------------TESTING----------------------------------------------------------------------------
			<br>
			<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','resetGame');">RESET</button>
			<br>
			_________________________________________________________________________________
			<br>
			<br>
			Force Goto Game state
			<select id="goto_step">
				<%
				for(int i=0;i<Constant.GAME_STATES.length;i++)
				{
					%>
					<option value="<%=i%>"><%=Constant.GAME_STATES[i]%></option>
					<%
				}
				%>
			</select>
			<br>
			<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','goToStep',document.getElementById('goto_step').options[document.getElementById('goto_step').selectedIndex].value);">GO</button>
			<br>
			_________________________________________________________________________________<br>
			Force Eliminate player
			
			<select id="remove_player">
			<% 
			for (Map.Entry<String, Player> player : players.entrySet()) 
			{
				if(player.getValue().isInGame())
				{
					%><option type="radio" value="<%=player.getValue().uniqueID%>"><%=player.getValue().getName()%></option><%
				}
			}
				
			%>
			</select>
			<br>
			<br> 
			<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','forceRemovePlayer',document.getElementById('remove_player').options[document.getElementById('remove_player').selectedIndex].value);">REMOVE</button>
			<br>
			_________________________________________________________________________________<br>
			Force Add player
			
			<select id="add_player">
			<% 
			for (Map.Entry<String, Player> player : players.entrySet()) 
			{
				if(!player.getValue().isInGame())
				{
					%><option type="radio" value="<%=player.getValue().uniqueID%>"><%=player.getValue().getName()%></option><%
				}
			}
				
			%>
			</select>
			<br>
			<br> 
			<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','forceAddPlayer',document.getElementById('add_player').options[document.getElementById('add_player').selectedIndex].value);">ADD</button>
		</div>
	<%} %>
	</body>
</html>