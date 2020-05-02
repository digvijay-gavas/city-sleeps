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
	String game_name = null;

	if (request.getParameter("is_new") != null && request.getParameter("is_new").equalsIgnoreCase("new")) {
		Storage.addGame(request.getParameter("game_name"));
		game_name = request.getParameter("game_name");
		response.addCookie(new Cookie("game_name",
				new String(Base64.encodeBase64(request.getParameter("game_name").getBytes()))));
	} else {
		Cookie cookie = null;
		Cookie[] cookies = null;
		cookies = request.getCookies();
		if (cookies != null) {

			for (int i = 0; i < cookies.length; i++) {
				cookie = cookies[i];
				if (cookie.getName().equalsIgnoreCase("game_name")) {
					game_name = new String(Base64.decodeBase64(cookie.getValue()));
				}
			}
		}
	}

	if (!Storage.isGameExist(game_name)) {
%>sorry game expired on server<%
	Cookie to_delete = new Cookie("game_name", "");
		to_delete.setMaxAge(0);
		response.addCookie(to_delete);
		to_delete = new Cookie("player_name", "");
		to_delete.setMaxAge(0);
		response.addCookie(to_delete);
	}
%>
<title><%=game_name%></title>
<meta http-equiv="refresh" content="10">
</head>
<body>
	<jsp:include page="game_status_banner.jsp">
		<jsp:param name="game_name" value="<%=game_name%>" />
	</jsp:include>

	<jsp:include page="PlayersList.jsp">
		<jsp:param name="game_name" value="<%=game_name%>" />
	</jsp:include>


	<form action="start.jsp" method="POST">
	
		<%
		double no_of_players=Storage.getPlayers(game_name).size();
		long max_Mafia=Math.round(no_of_players*0.2+1);
		long max_Detective=Math.round(no_of_players*0.2+1);
		long max_Doctor=Math.round(no_of_players*0.2+1);
		%>
		Mafia:
		 <select name="no_of_mafia">
			<%			
				for (int i=1;i< max_Mafia; i++) {
					game_name = "";
			%><option value="<%=i%>"><%=i%></option>
			<%
				}
			%>
		</select> 
		Detective:
		 <select name="no_of_detective">
			<%			
				for (int i=1;i< max_Detective; i++) {
					game_name = "";
			%><option value="<%=i%>"><%=i%></option>
			<%
				}
			%>
		</select> 
		Doctor:
		 <select name="no_of_doctor">
			<%			
				for (int i=1;i< max_Doctor; i++) {
					game_name = "";
			%><option value="<%=i%>"><%=i%></option>
			<%
				}
			%>
		</select> 
		<input type="submit" value="Start"/>
		<br>
		<%
		if(no_of_players<=4)
		{
		%>Not enough players<%
		}%>
		
	</form>
</body>
</html>