
<%@page import="game.global.GamesStorage"%>
<%
response.setContentType("application/json");
response.setHeader("Content-Disposition", "inline");
String method_name=request.getParameter("name");
String return_value="";
if(method_name.equalsIgnoreCase("addGame"))
{
	return_value=GamesStorage.addGame(request.getParameter("arg1"));
	%>[ {"gameID":	"<%=return_value%>"}] <%
} else if(method_name.equalsIgnoreCase("joinGame"))
{
	return_value=GamesStorage.getGame(request.getParameter("arg1")).addPlayer(request.getParameter("arg2"));
	%>[ {"gameID":	"<%=return_value%>"}] <%
}
else if(method_name.equalsIgnoreCase("startGame"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).startGame();
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("assignRoles"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).assignRoles(
			Integer.parseInt(request.getParameter("arg1")),
			Integer.parseInt(request.getParameter("arg2")),
			Integer.parseInt(request.getParameter("arg3"))
			);
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("killPlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).killPlayer(
			request.getParameter("player_uniqueID"),
			request.getParameter("arg1")
			);
	%>You voted <b><%=GamesStorage.getGame(request.getParameter("game_uniqueID")).getPlayer(return_value).getName()%> </b><%
}
else if(method_name.equalsIgnoreCase("identifyPlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).identifyPlayer(
			request.getParameter("player_uniqueID"),
			request.getParameter("arg1")
			);
	%>You voted <b><%=GamesStorage.getGame(request.getParameter("game_uniqueID")).getPlayer(return_value).getName()%> </b><%
}
else if(method_name.equalsIgnoreCase("savePlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).savePlayer(
			request.getParameter("player_uniqueID"),
			request.getParameter("arg1")
			);
	%>You voted <b><%=GamesStorage.getGame(request.getParameter("game_uniqueID")).getPlayer(return_value).getName()%> </b><%
}
else if(method_name.equalsIgnoreCase("eliminatePlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).eliminatePlayer(
			request.getParameter("player_uniqueID"),
			request.getParameter("arg1")
			);
	%>You voted <b><%=GamesStorage.getGame(request.getParameter("game_uniqueID")).getPlayer(return_value).getName()%> </b><%
}
else if(method_name.equalsIgnoreCase("calulateAndKill"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).calulateAndKill();
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("calulateAndEliminate"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).calulateAndEliminate();
	%><%=return_value%><%
}


//-----------------------------TESTING ----------------------------------------------
else if(method_name.equalsIgnoreCase("resetGame"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).resetGame();
	%><%=return_value%><%
}

else if(method_name.equalsIgnoreCase("goToStep"))
{
	GamesStorage.getGame(request.getParameter("game_uniqueID")).state=Integer.parseInt(request.getParameter("arg1"));
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("forceRemovePlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).forceRemovePlayer(
			request.getParameter("arg1")
			);
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("forceAddPlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).forceAddPlayer(
			request.getParameter("arg1")
			);
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("quitGame"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).forceRemovePlayer(
			request.getParameter("player_uniqueID")
			);
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("changeName"))
{
	GamesStorage.getGame(request.getParameter("game_uniqueID")).getPlayer(request.getParameter("player_uniqueID")).setName(request.getParameter("arg1"));
	%><%=return_value%><%
}

// -------------------------------CHAT---------------------------------------------------


else if(method_name.equalsIgnoreCase("addChat"))
{
	GamesStorage.getGame(request.getParameter("game_uniqueID")).addChat(
			request.getParameter("player_uniqueID"),
			request.getParameter("arg1")
			); 
}
else if(method_name.equalsIgnoreCase("addChatSuperviser"))
{
	GamesStorage.getGame(request.getParameter("game_uniqueID")).addChat(
			Integer.parseInt(request.getParameter("arg1")),
			request.getParameter("arg2")
			); 
}
else if(method_name.equalsIgnoreCase("sendMessageToWhoNotVoted"))
{
	GamesStorage.getGame(request.getParameter("game_uniqueID")).sendMessageToWhoNotVoted(); 
}

	
%>
