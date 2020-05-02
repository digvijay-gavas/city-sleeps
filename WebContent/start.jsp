<%@page import="game.global.Storage"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String game_name = null;
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
	try {
		int no_of_mafia=Integer.parseInt(request.getParameter("no_of_mafia"));
		int no_of_detective=Integer.parseInt(request.getParameter("no_of_detective"));
		int no_of_doctor=Integer.parseInt(request.getParameter("no_of_doctor"));
		Storage.startGame(game_name,no_of_mafia,no_of_detective,no_of_doctor);
	} catch (NumberFormatException e) {}
	
	Storage.advanceGameState(game_name);
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
	<form action="start.jsp">
		<input type="submit" value="<%=Storage.getNextGameState(game_name)%>"/>
	</form>
</body>
</html>