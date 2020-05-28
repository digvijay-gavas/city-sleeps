<%@page import="game.global.Constant"%>
<%@page import="game.global.Player"%>
<%@page import="game.global.Game"%>
<%@page import="game.global.GamesStorage"%>
<%@page import="java.util.Map"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="java.util.Iterator"%>
<%@page import="game.global.Storage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%!%> 
<%
	String game_uniqueID = request.getParameter("game_uniqueID");
	String player_uniqueID = request.getParameter("player_uniqueID"); 
	Game game=GamesStorage.getGame(game_uniqueID);
	Player player=null;
	if(game!=null)
		player=GamesStorage.getGame(game_uniqueID).getPlayer(player_uniqueID);
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
	else if (game!=null && game.getState()!=Game.waiting && player==null) 
	{
		%>Game is already stated you cannot join the game.....<% 
		Cookie to_delete = new Cookie("game_uniqueID", "");
		to_delete.setMaxAge(0);
		response.addCookie(to_delete);
		to_delete = new Cookie("player_uniqueID", "");
		to_delete.setMaxAge(0);
		response.addCookie(to_delete);
	}
	else
	{
	%><div id="players_div"><%
		player.lastSeen=System.currentTimeMillis();
	%>	<text class="label textred"><%=game.whoGetLastEliminated!=null?"<b>"+game.whoGetLastEliminated.getName()+"</b> eliminated my city.<br>":"" %></text>
		<text class="label textred"><%=game.whoGetLastIdentified!=null?"<b>"+game.whoGetLastIdentified.getName()+"</b>  Mafia identified by Detective.<br>":"" %></text>
		<text class="label textred"><%=game.whoGetLastKilled!=null?"<b>"+game.whoGetLastKilled.getName()+"</b> Civilian is killed by Mafia.<br>":"" %></text><br>
		<text class="label textgray">Game Time: <b><%=((System.currentTimeMillis()-game.getStartTime() ) / 1000 )%></b> sec</text><br>
	<%		
			Map<String, Player> players = game.getPlayers();					
				
					switch(game.getState())
					{
					case Game.waiting: 
					case Game.START_STATE:
						%>waiting for superviser to start game......<br><%
						break;
					case Game.assign_roles:
						%>roles are assigned.... You are <%=Constant.GAME_ROLES[player.getRole()]%><br><%
						break;
					case Game.city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone:
						%><text class="textgreen">You are <%=Constant.GAME_ROLES[player.getRole()]%></text><br><%
						break;
					case Game.city_wake_up_and_elimimate_someone:
						%><text class="textgreen">You are <%=Constant.GAME_ROLES[player.getRole()]%></text><br><%
						break;
					}
					
					%><br><%=Constant.getGameStateString(game.getState(), player.getRole())%><%
					%><br>
					<text style="font-size:15px;font-family:Tahoma;color:#AAAA66"><%=game.getStatusMessage(player)%></text><%
			
			if(game.whoWonTheGame()==Player.Civilian && (game.getState()!=Game.waiting && game.getState()!=Game.START_STATE ) )
			{
				%><h2 style="color:#33BB33">Civilians Wins !!!!</h2><%
				%><h3 style="color:#AA3333">Mafias Loose !!!!</h3> <%
				
				%>
				<table border="1">
					<tr>
						<th>Player</th>
						<th>Role</th>
					</tr><%
					
					for (Map.Entry<String, Player> i_Player : players.entrySet()) 
					{ 
						%>
						<tr 
						<%
						if(!i_Player.getValue().isInGame())
						{
							%>style="background-color:#AAAAAA"<%
						}
						else if(i_Player.getValue().isKilled())
						{
							%>style="background-color:#FFAAAA"<%
						}
						else
						{
							%>style="background-color:#AAFFAA"<%
						}
						%> 
						>
							<td><%=i_Player.getValue().getName()%></td>  
							<td><%=Constant.GAME_ROLES[i_Player.getValue().getRole()]%></td>
							<%
							if(i_Player.getValue()==player)
							{
								%><td> <---- you </td><%
							}
							%>
						</tr>
						<%
					}
					%>
					</table><%
			}
			else if(game.whoWonTheGame()==Player.Mafia)
			{				
				%><h3 style="color:#33BB33">Mafias Wins !!!!</h3> <%
				%><h2 style="color:#AA3333">Civilians Loose !!!!</h2><%
				%>
				<table border="1">
					<tr>
						<th>Player</th>
						<th>Role</th>
					</tr><%
					
					for (Map.Entry<String, Player> i_Player : players.entrySet()) 
					{ 
						%>
						<tr 
						<%
						if(!i_Player.getValue().isInGame())
						{
							%>style="background-color:#AAAAAA"<%
						}
						else if(i_Player.getValue().isKilled())
						{
							%>style="background-color:#FFAAAA"<%
						}
						else
						{
							%>style="background-color:#AAFFAA"<%
						}
						%> 
						>
							<td><%=i_Player.getValue().getName()%></td>  
							<td><%=Constant.GAME_ROLES[i_Player.getValue().getRole()]%></td>
							<%
							if(i_Player.getValue()==player)
							{
								%><td> <---- you </td><%
							}
							%>
						</tr>
						<%
					}
					%>
					</table><%
			}
			else if(game.whoWonTheGame()==Player.Tie)
			{
							
				%><h3 style="color:#33BB33">Its Tie !!!!!!</h3> <%
				%><h2 style="color:#AA3333">Its Tie !!!!!!</h2><%
				%>
				<table border="1">
					<tr>
						<th>Player</th>
						<th>Role</th>
					</tr><%
					
					for (Map.Entry<String, Player> i_Player : players.entrySet()) 
					{ 
						%>
						<tr 
						<%
						if(!i_Player.getValue().isInGame())
						{
							%>style="background-color:#AAAAAA"<%
						}
						else if(i_Player.getValue().isKilled())
						{
							%>style="background-color:#FFAAAA"<%
						}
						else
						{
							%>style="background-color:#AAFFAA"<%
						}
						%> 
						>
							<td><%=i_Player.getValue().getName()%></td>  
							<td><%=Constant.GAME_ROLES[i_Player.getValue().getRole()]%></td>
							<%
							if(i_Player.getValue()==player)
							{
								%><td> <---- you </td><%
							}
							%>
						</tr>
						<%
					}
					%>
					</table><%
			}
			else if(game.whoWonTheGame()==Player.EveryOneDies)
			{
							
				%><h3 style="color:#33BB33">EveryOne Died !!!!!!</h3> <%
				%><h2 style="color:#AA3333">EveryOne Died !!!!!!</h2><%
				%>
				<table border="1">
					<tr>
						<th>Player</th>
						<th>Role</th>
					</tr><%
					
					for (Map.Entry<String, Player> i_Player : players.entrySet()) 
					{ 
						%>
						<tr 
						<%
						if(!i_Player.getValue().isInGame())
						{
							%>style="background-color:#AAAAAA"<%
						}
						else if(i_Player.getValue().isKilled())
						{
							%>style="background-color:#FFAAAA"<%
						}
						else
						{
							%>style="background-color:#AAFFAA"<%
						}
						%> 
						>
							<td><%=i_Player.getValue().getName()%></td>  
							<td><%=Constant.GAME_ROLES[i_Player.getValue().getRole()]%></td>
							<%
							if(i_Player.getValue()==player)
							{
								%><td> <---- you </td><%
							}
							%>
						</tr>
						<%
					}
					%>
					</table><%
			}
			else if(player.isKilled())
			{
				%><br>You get killed !!!!<%
				%><br>You can still participate by strategically influencing others..<%
				%>
				<table border="1">
					<tr>
						<th>Player</th>
						
						<th>Elimination Votes</th>
						
					</tr><%
					
					for (Map.Entry<String, Player> i_Player : players.entrySet()) 
					{ 
						%>
						<tr 
						<%
						if(!i_Player.getValue().isInGame())
						{
							%>style="background-color:#AAAAAA"<%
						}
						else if(i_Player.getValue().isKilled())
						{
							%>style="background-color:#FFAAAA"<%
						}
						else
						{
							%>style="background-color:#AAFFAA"<%
						}
						%> 
						>
							<td><%=i_Player.getValue().getName()%></td>  
							
							<td><%=i_Player.getValue().getEliminateVote()%></td>
							<% 
							if(i_Player.getValue().getWhoIEliminate()!=null)
							{%>
								<td><%=i_Player.getValue().getWhoIEliminate().getName()%></td>
							<%
							}
							%>
														<%
							if(i_Player.getValue()==player)
							{
								%><td> <---- you </td><%
							}
							%>
						</tr>
						<%
					}
					%>
					</table><%
			}
			else
			{
			%>
				
					<%
							
					if (!GamesStorage.isGameExist(game.uniqueID)) {
						%>sorry game expired on server<%
					} else 
					{
						%><table border="1">
						<tr>
							<th>Player</th>
							<th>Role</th>
							<th>Votes</th>
							<th>Voted to</th>
			
						</tr><%
						
						switch(game.getState())
						{
						case Game.city_sleeps_mafia_kill_someone_detective_identify_someone_and_doctor_save_someone:
							for (Map.Entry<String, Player> i_Player : players.entrySet()) 
							{ 
								%>
								<tr 
								<%
								if(!i_Player.getValue().isInGame())
								{
									%>style="background-color:#AAAAAA"<%
								}
								else if(i_Player.getValue().isKilled())
								{
									%>style="background-color:#FFAAAA"<%
								}
								%> 
								>
									<%
		
									if(player.getRole()==Player.Mafia && !i_Player.getValue().isKilled())
									{
										if( player.getWhoIKilled() != i_Player.getValue() && i_Player.getValue().getRole() != Player.Mafia && i_Player.getValue().isInGame())
										{
											%>
											<td><button class="button gray short" onclick="callMethodAndRefresh('playerUpdateCall.jsp','#players_div','killPlayer','<%=i_Player.getValue().uniqueID%>');">kill '<%=i_Player.getValue().getName()%>'</button></td> 
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getKillVote()%></td>
											<td></td>
											<%
										} else if(i_Player.getValue().getWhoIKilled()!=null) 
										{
											%>
											<td><%=i_Player.getValue().getName()%></td>  
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getKillVote()%></td>
											<td><%=i_Player.getValue().getWhoIKilled().getName()%></td>
											<%
										} else
										{
											%>
											<td><%=i_Player.getValue().getName()%></td>  
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getKillVote()%></td>
											<td></td>
											<%
										}
												
									} else if(player.getRole()==Player.Detective && !i_Player.getValue().isKilled())
									{
										if( player.getWhoIIdentified() != i_Player.getValue() && i_Player.getValue().getRole() != Player.Detective && i_Player.getValue().isInGame())
										{
											%>
											<td><button class="button gray short" onclick="callMethodAndRefresh('playerUpdateCall.jsp','#players_div','identifyPlayer','<%=i_Player.getValue().uniqueID%>');">identify '<%=i_Player.getValue().getName()%>'</button></td> 
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getIdentifyVote()%></td>
											<td></td>
											<%
										} else if(i_Player.getValue().getWhoIIdentified()!=null) 
										{ 
											%>
											<td><%=i_Player.getValue().getName()%></td>  
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getIdentifyVote()%></td>
											<td><%=i_Player.getValue().getWhoIIdentified().getName()%></td>
											<%
										} else
										{
											%>
											<td><%=i_Player.getValue().getName()%></td>  
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getIdentifyVote()%></td>
											<td></td>
											<%
										}
												
									} else if(player.getRole()==Player.Doctor && !i_Player.getValue().isKilled() && i_Player.getValue().isInGame())
									{
										if( player.getWhoISaved() != i_Player.getValue() && i_Player.getValue().getRole() != Player.Doctor)
										{
											%>
											<td><button class="button gray short" onclick="callMethodAndRefresh('playerUpdateCall.jsp','#players_div','savePlayer','<%=i_Player.getValue().uniqueID%>');">save '<%=i_Player.getValue().getName()%>'</button></td> 
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getSaveVote()%></td>
											<td></td>
											<%
										} else if(i_Player.getValue().getWhoISaved()!=null) 
										{
											%>
											<td><%=i_Player.getValue().getName()%></td>  
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getSaveVote()%></td>
											<td><%=i_Player.getValue().getWhoISaved().getName()%></td>
											<%
										} else
										{
											%>
											<td><%=i_Player.getValue().getName()%></td>  
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getSaveVote()%></td>
											<td></td>
											<%
										}
												
									} else
									{
										%>
										<td><%=i_Player.getValue().getName()%></td>  
										<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
										<td></td> 
										<td></td>
										<%
									}
									%>
									
									<%
									if(i_Player.getValue()==player)
									{
										%><td> <---- you </td><%
									}
									%>
									
								</tr>
								<%
							}
							break;
						case Game.city_wake_up_and_elimimate_someone:
		
							for (Map.Entry<String, Player> i_Player : players.entrySet()) 
							{
								%>
								<tr 
								<%
								if(!i_Player.getValue().isInGame())
								{
									%>style="background-color:#AAAAAA"<%
								}
								else if(i_Player.getValue().isKilled())
								{
									%>style="background-color:#FFAAAA"<%
								}
								%> 
								>
								<%
									if(i_Player.getValue().isKilled() || !i_Player.getValue().isInGame())
									{
										%>
										<td><%=i_Player.getValue().getName()%></td> 
										<td></td>
										<td></td>
										<td></td>
										<%		
									}else 
									{
										//if(!player.isKilled()  && i_Player.getValue().getWhoIEliminate()!=null)
										if(player==i_Player.getValue()) 
										{
											%>
											<td><%=i_Player.getValue().getName()%></td>  
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getEliminateVote()%></td>
											<% 
											if(i_Player.getValue().getWhoIEliminate()==null)
											{
												%><td></td><% 
											}else
											{
												%><td><%=i_Player.getValue().getWhoIEliminate().getName()%></td><% 
											}
										}else if (!player.isKilled() &&  i_Player.getValue()!=player.getWhoIEliminate() )
										{
											%>
											<td><button class="button gray short" onclick="callMethodAndRefresh('playerUpdateCall.jsp','#players_div','eliminatePlayer','<%=i_Player.getValue().uniqueID%>');">eliminate '<%=i_Player.getValue().getName()%>'</button></td>   
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getEliminateVote()%></td> 
											<%
											if(i_Player.getValue().getWhoIEliminate()==null)
											{
												%><td></td><% 
											}else
											{
												%><td><%=i_Player.getValue().getWhoIEliminate().getName()%></td><% 
											}
										}else 
										{
											%>
											<td><%=i_Player.getValue().getName()%></td>   
											<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
											<td><%=i_Player.getValue().getEliminateVote()%></td>
											<%
											if(i_Player.getValue().getWhoIEliminate()==null)
											{
												%><td></td><% 
											}else
											{
												%><td><%=i_Player.getValue().getWhoIEliminate().getName()%></td><% 
											}
										}
									}
									if(i_Player.getValue()==player)
									{
										%><td> <---- you </td><%
									}
							%></tr><%
							}
							break;
						default:
							for (Map.Entry<String, Player> i_Player : players.entrySet()) 
							{
								%><tr<%
								if(!i_Player.getValue().isInGame())
								{
									%>style="background-color:#AAAAAA"<%
								}
								else if(i_Player.getValue().isKilled())
								{
									%>style="background-color:#FFAAAA"<%
								}
								%>>
									<td><%=i_Player.getValue().getName()%></td> 
									<td><%=i_Player.getValue().getRole()==player.getRole() && player.getRole()!=Player.Civilian ?Constant.GAME_ROLES[i_Player.getValue().getRole()]:""%></td>
									<td></td>
									<td></td>
									<%
									if(i_Player.getValue()==player)
									{
										%><td> <---- you </td><%
									}
							%></tr><%
							}
							break;
						}
						%></table><%
					}
				}
		%></div><%
		}
%>