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
<link rel="stylesheet" href="styles/styles.css">
<style>
table {
  border-collapse: collapse;
}

th, td {
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {background-color: #f2f2f2;}
</style>
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
	<body style="font-family:Tahoma">
	
	<h4>http://<%=request.getHeader("host")%><%=request.getRequestURI().substring(0, request.getRequestURI().lastIndexOf("/"))%>/JoinGame.jsp?game_uniqueID=<%=game_uniqueID%></h4>
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
		<text style="font-size:40px;font-family:Tahoma"><%=game.getName()%></text><br> 
		<text style="color:#AAAAAA"><%="("+game.uniqueID+")"%></text>
		<div id="status_div">
		
			
		
		</div>
		<div id="players_div">
		<text class="label textred"><%=game.whoGetLastEliminated!=null?"<b>"+Constant.GAME_ROLES[game.whoGetLastEliminated.getRole()]+" "+game.whoGetLastEliminated.getName()+"</b> eliminated my city.<br>":"" %></text>
		<text class="label textred"><%=game.whoGetLastIdentified!=null?"<b>"+Constant.GAME_ROLES[game.whoGetLastIdentified.getRole()]+" "+game.whoGetLastIdentified.getName()+"</b> identified by Detective.<br>":"" %></text>
		<text class="label textred"><%=game.whoGetLastKilled!=null?"<b>"+Constant.GAME_ROLES[game.whoGetLastKilled.getRole()]+" "+game.whoGetLastKilled.getName()+"</b> is killed by Mafia.<br>":"" %></text><br>
		<%
		if(game.whoWonTheGame()!=Player.NoOneYet && game.whoWonTheGame()!=Player.EveryOneDies && game.whoWonTheGame()!=Player.Tie)
		{
			%><h2><%=Constant.GAME_ROLES[game.whoWonTheGame()]%> won the game</h2><%
		} else if(game.whoWonTheGame()==Player.EveryOneDies)
		{
			%><h2>Everyone Died</h2><%
		} else if(game.whoWonTheGame()==Player.Tie)
		{
			%><h2>Its a Tie !!!</h2><% 
		}
		%>
			<text style="font-size:15px;font-family:Tahoma;color:#AAAAAA">Game Time: <b><%=((System.currentTimeMillis()-game.getStartTime() ) / 1000 )%></b> sec </text>
			<%=Constant.getGameStateString(game.getState(),Player.NoOneYet)%><br>
			<text style="font-size:15px;font-family:Tahoma;color:#AAAA66"><%=game.getStatusMessage()%></text><%
				
				
				
				Map<String, Player> players = game.getPlayers();
				if (!GamesStorage.isGameExist(game.uniqueID)) {
					%>sorry game expired on server<%
				} else 
				{
					%><table border="1">
					<tr>
						<th>Last seen</th>
						<th>REMOVE/ADD</th>
						<th>count</th>
						<th>Player</th>
						<th>Role</th>
						<%
						if(game.getState()==Game.city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone) 
						{
							%>
							<th>kill</th>
							<th>Identify</th>
							<th>Save</th>
							<th>Can kill</th>
							<%
						} else  if(game.getState()==Game.city_wake_up_and_elimimate_someone) 
						{
							%><th>Eliminate Votes</th><%
							%><th>Votes to </th><%
						} 
						%>
		
					</tr><%
					int count=0;
					int notInGameCount=0;
					int killCount=0;
					for (Map.Entry<String, Player> player : players.entrySet()) 
					{
						count++;
						%>
						<tr 
						<%
						if(!player.getValue().isInGame())
						{
							%>style="background-color:#AAAAAA"<%
							notInGameCount++;
						}
						else if(player.getValue().isKilled())
						{
							%>style="background-color:#FFAAAA"<%
							killCount++;
						}
						%> 
						>
						<%
							long lastSeenSince=(System.currentTimeMillis()-player.getValue().lastSeen)/1000;
							if(lastSeenSince>20)
							{
								%><td><label class="label textred"><%=lastSeenSince%> sec ago</label></td><%
							}
							else
							{ 
								%><td><label class="label textgray"><%=lastSeenSince%> sec ago</label></td><%
							}
						%>
						
							
							<%
							if(player.getValue().isInGame())
							{
								%><td>
								<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','forceRemovePlayer','<%=player.getValue().uniqueID%>');">REMOVE</button>
								</td><%
							}
							else
							{
								%><td>
								<button onclick="callMethodAndRefresh('Superviser.jsp','#actions_div','forceAddPlayer','<%=player.getValue().uniqueID%>');">ADD</button>
								</td><%
							}
							%>
							<td><%=count %></td> 
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
							%><td><%=player.getValue().getWhoIEliminate()!=null?player.getValue().getWhoIEliminate().getName():""%></td><%
						} 
						%>
						
						</tr>
						<%
					}
					%></table>
					<h5> Total <%=count %></h5>
					<h5> Playing <%=count- notInGameCount-killCount%></h5>
					<h5> Active <%=count-notInGameCount%></h5>
					<h5> Killed <%=killCount %></h5>
					<%
				}
			%>

					
			</div> 
					<jsp:include page="Chat.jsp">
							<jsp:param name="game_uniqueID" value="<%=game_uniqueID%>" />
							<jsp:param name="player_typeID" value="<%=Player.Doctor%>" />
							<jsp:param name="player_type" value="<%=Constant.GAME_ROLES[Player.Doctor]%>" />
							<jsp:param name="is_superviser" value="true" />
							<jsp:param name="windowshift" value="600px" /> 
					</jsp:include>
					<jsp:include page="Chat.jsp">
							<jsp:param name="game_uniqueID" value="<%=game_uniqueID%>" />
							<jsp:param name="player_typeID" value="<%=Player.Detective%>" />
							<jsp:param name="player_type" value="<%=Constant.GAME_ROLES[Player.Detective]%>" />
							<jsp:param name="is_superviser" value="true" />
							<jsp:param name="windowshift" value="300px" /> 
					</jsp:include>

					<jsp:include page="Chat.jsp">
							<jsp:param name="game_uniqueID" value="<%=game_uniqueID%>" />
							<jsp:param name="player_typeID" value="<%=Player.Mafia%>" />
							<jsp:param name="player_type" value="<%=Constant.GAME_ROLES[Player.Mafia]%>" />
							<jsp:param name="is_superviser" value="true" />
					</jsp:include>
	
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
			<button onclick="callMethod('sendMessageToWhoNotVoted');">sendMessageToWhoNotVoted</button>
			
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
		<div id="proccessing_request_div" class="processing_gif" ><img alt="" src="image/wait.gif"></div> 
	<%} %>
	</body>
</html>