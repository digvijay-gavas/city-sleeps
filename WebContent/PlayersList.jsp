<%@page import="java.util.Map"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="java.util.Iterator"%>
<%@page import="game.global.Storage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%!%>
<%
	String game_name = request.getParameter("game_name");
%>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript">
setInterval(function(){
	   $('#players_div').load('PlayersList.jsp #players_div',{game_name:'<%=game_name%>'});
	}, 2000) 
	function callMethod(name,arg1,arg2,arg3)
	{
		console.log(name);
		console.log(arg1);
		console.log(arg2);
		console.log(arg3);
		$('#status_div').load('callMethodSuperviser.jsp',{game_name:'<%=game_name%>',name:name,arg1:arg1, arg2:arg2, arg3:arg3 });
		$('#players_div').load('PlayersList.jsp #players_div',{game_name:'<%=game_name%>'});
	}
</script>
<div id="status_div"></div>
<div id="players_div">
	<%=System.currentTimeMillis()%>
	<%
		Map<String, String[]> players = Storage.getPlayers(game_name);
		if (players == null) {
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
			for (Map.Entry<String, String[]> player : players.entrySet()) 
			{
				%>
				<tr>
					<td><%=player.getKey()%></td> 
					<td><%=player.getValue()[0]!=null?player.getValue()[0]:""%></td>
					<td><%=player.getValue()[1]!=null?player.getValue()[1]:""%></td>
					<td><%=player.getValue()[2]!=null?player.getValue()[2]:""%></td>
				</tr>
				<%
			}
			%></table><%
		}
	%>
</div>