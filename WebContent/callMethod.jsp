
<%@page import="game.global.Storage"%>
<%=request.getParameter("game_name") %>
<%=request.getParameter("player_name") %>
<%=request.getParameter("name") %>
<%=request.getParameter("arg1") %>
<%=request.getParameter("arg2") %>
<%=request.getParameter("arg3") %>


<%
String method_name=request.getParameter("name");
if(method_name.equalsIgnoreCase("votePlayer"))
{
	Storage.votePlayer(request.getParameter("game_name"), request.getParameter("player_name"), request.getParameter("arg1"));
}
	
%>
