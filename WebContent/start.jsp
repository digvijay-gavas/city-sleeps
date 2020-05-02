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
	Storage.startGame(game_name);
%>
<title><%=game_name%></title>
<meta http-equiv="refresh" content="10">
</head>
<body>

	<jsp:include page="PlayersList.jsp">
		<jsp:param name="game_name" value="<%=game_name%>" />
	</jsp:include>
</body>
</html>