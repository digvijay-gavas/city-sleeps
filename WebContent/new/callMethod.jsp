
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
}
	
%>[ {"gameID":	"<%=return_value%>"}]
