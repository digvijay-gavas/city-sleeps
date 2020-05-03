<%@page import="java.util.Map"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="java.util.Iterator"%>
<%@page import="game.global.Storage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%!%>
<%
	String game_name = request.getParameter("game_name");
	String player_name = request.getParameter("player_name");
%>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript">
setInterval(function(){
	   $('#players_div').load('PlayersPlayboard.jsp #players_div',{game_name:'<%=game_name%>',player_name:'<%=player_name%>'});
	}, 2000) 
	function callMethod(name,arg1,arg2,arg3)
	{
		console.log(name);
		console.log(arg1);
		console.log(arg2);
		console.log(arg3);
		$('#status_div').load('callMethod.jsp',{game_name:'<%=game_name%>',player_name:'<%=player_name%>',name:name,arg1:arg1, arg2:arg2, arg3:arg3 });
		 $('#players_div').load('PlayersPlayboard.jsp #players_div',{game_name:'<%=game_name%>',player_name:'<%=player_name%>'});
	}
</script>
<div id="status_div"></div>
<div id="players_div">
	<%=System.currentTimeMillis()%>
	<%
		Map<String, String[]> players = Storage.getPlayers(game_name);
		if (players == null) {
	%>
	sorry game expired on server

	<%
		} else {
	%><table border="1"  >
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
						<button onclick="callMethod('votePlayer','<%=player.getKey()%>');">kill</button>
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
</div>