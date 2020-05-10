
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
	
%>
