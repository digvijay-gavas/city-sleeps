
<%@page import="game.global.GamesStorage"%>
<%@page import="game.global.Storage"%>
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
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("identifyPlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).identifyPlayer(
			request.getParameter("player_uniqueID"),
			request.getParameter("arg1")
			);
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("savePlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).savePlayer(
			request.getParameter("player_uniqueID"),
			request.getParameter("arg1")
			);
	%><%=return_value%><%
}
else if(method_name.equalsIgnoreCase("eliminatePlayer"))
{
	return_value=GamesStorage.getGame(request.getParameter("game_uniqueID")).eliminatePlayer(
			request.getParameter("player_uniqueID"),
			request.getParameter("arg1")
			);
	%><%=return_value%><%
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
	
%>
