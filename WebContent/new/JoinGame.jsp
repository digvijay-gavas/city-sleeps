<%@page import="game.global.Player"%>
<%@page import="org.apache.tomcat.util.codec.binary.Base64"%>
<%@page import="game.global.Game"%>
<%@page import="java.util.Map"%>
<%@page import="game.global.GamesStorage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>City-Sleeps</title>
	<jsp:include page="dasboardJSFunction.jsp"/>
	<link rel="stylesheet" href="styles/styles.css">
	</head>
	<body id="allbody">
		<div id="banner_div">
		</div>
		<div id="player_list_div">
		</div>
		
		<div id="create_game_div" style="text-align:center;">
		
				<%
				String game_uniqueID = null;
				String player_uniqueID = null; 
				String game_uniqueID_from_param = request.getParameter("game_uniqueID");
				Game game = null;
				Player player = null;
				
			
					Cookie cookie = null;
					Cookie[] cookies = null;
					cookies = request.getCookies();
					if (cookies != null) {
			
						for (int i = 0; i < cookies.length; i++) {
							cookie = cookies[i];
							if (cookie.getName().equalsIgnoreCase("player_uniqueID")) {
								//player_uniqueID = new String(Base64.decodeBase64(cookie.getValue()));
								player_uniqueID = cookie.getValue();
							} else if (cookie.getName().equalsIgnoreCase("game_uniqueID")) {
								//game_uniqueID = new String(Base64.decodeBase64(cookie.getValue()));
								game_uniqueID = cookie.getValue();
							}
						}
					}
					
					game = GamesStorage.getGame(game_uniqueID);
					if(game!=null)
						player = game.getPlayer(player_uniqueID);
					
					if (request.getParameter("end_game") != null && request.getParameter("end_game").equalsIgnoreCase("true"))
					{
		
						Cookie to_delete = new Cookie("game_uniqueID", "");
						to_delete.setMaxAge(0);
						to_delete.setPath("/");
						response.addCookie(to_delete);
						to_delete = new Cookie("player_uniqueID", "");
						to_delete.setMaxAge(0);
						to_delete.setPath("/");
						response.addCookie(to_delete);
						game_uniqueID = null;
						player_uniqueID = null; 
					}
					
				%>
				<%
				if (game != null && player != null) {
				
						if(game_uniqueID_from_param!=null && !game_uniqueID_from_param.equalsIgnoreCase(game_uniqueID) && GamesStorage.getGame(game_uniqueID_from_param)!=null)
						{	
							%>
							
							<text class="text"> 
							Your are trying to joint new Game named <b>'<%=GamesStorage.getGame(game_uniqueID_from_param).getName()%>'</b>.<br><br>
							But you have already joined Game named <b>'<%=game.getName()%>'</b> with <b>'<%=player.getName()%>'</b> name<br>
							choose what you want to do ..............
							</text>
							<br>
							<button onclick="quitAndJoin();" class="button red"  >
							Quit Game'<%=game.getName()%>' and join '<%=GamesStorage.getGame(game_uniqueID_from_param).getName()%>'
							</button>
							
							<form action="Player.jsp" method="POST">
								<input type="hidden" value="<%=game.uniqueID%>" name="game_uniqueID"></input>
								<input type="hidden" value="<%=player.uniqueID%>" name="player_uniqueID"></input>
								<input type="submit"
									value="Resume game '<%=game.getName()%>' as '<%=player.getName()%>'" class="button gray" ></input>
							</form>
							<%		
						}
						else if(game_uniqueID_from_param!=game_uniqueID)
						{
							%>
							<text class="text"> 
							Menu
							</text>
							
							<form action="Player.jsp" method="POST">
								<input type="hidden" value="<%=game.uniqueID%>" name="game_uniqueID"></input>
								<input type="hidden" value="<%=player.uniqueID%>" name="player_uniqueID"></input>
								<input type="submit"
									value="Resume game '<%=game.getName()%>' as '<%=player.getName()%>'" class="button" ></input>
							</form>
				
							<button onclick="quit();" class="button red" >
							Quit Game'<%=game.getName()%>'
							</button>
							<%		
						}
					} else {
				%>
			
			
			 
				 
				<br>
				<label class="label">Your Name:</label> 
				<input class="inputtext" required type="text" value="Digi<%=" "+(100+Math.round(Math.random()*900))%>" id="join_player_name" /> 
				<br>
				
				<% 
				if(game_uniqueID_from_param!=null && GamesStorage.getGame(game_uniqueID_from_param)!=null)
				{	
					%>
					<label class="label">Your are joining Game named '<%=GamesStorage.getGame(game_uniqueID_from_param).getName()%>'</label>
					<br>
					<button onclick="joinGame('<%=game_uniqueID_from_param%>' );" class="button">Join Game</button>
					<%
				} else
				{ 
					%>
					<select id="join_game_uniqueID">
						<%
						for ( Map.Entry<String, Game> gameEntry : GamesStorage.getJoinableGames().entrySet())  {
						
						%><option value="<%=gameEntry.getKey()%>"><%=gameEntry.getValue().getName() + "(" +gameEntry.getKey()+")"%></option>
						<%
							}
						%>
					</select> 
					<br>	
					<button onclick="joinGame();" class="button">Join Game</button>
					<%
				} 
				%>
			

		</div>
		<div id="status_div" style="color:red"></div>
		<%} %>
		<script type="text/javascript">
			// var status_label=document.getElementById('status_div');
			
			console.log('---------------'+window.location);
			$('#create_game_div').load(window.location+' #create_game_div',{game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>'});
			
			
			/*var isFirst=true;
			if(isFirst)
			{
			 	document.location = window.location;
			 	isFirst=false;
			}*/
			
			function trim(x) {
			  return x.replace(/^\s+|\s+$/gm,'');
			}

			function joinGame(game_uniqueID)
			{
				if(game_uniqueID==null)
				{
					var game_uniqueID_element=document.getElementById('join_game_uniqueID');
					var game_uniqueID=trim(game_uniqueID_element.options[game_uniqueID_element.selectedIndex].value)
				}
				
				
				var player_name=document.getElementById('join_player_name').value;
				//document.getElementById('join_game_uniqueID').options[document.getElementById('join_game_uniqueID').selectedIndex].value
				if( trim( player_name) == "" )
				{
					// alert('enter player name');
					document.getElementById('status_div').innerHTML='enter player name';
					return;	
				} else
				{
					setCookie('game_uniqueID',game_uniqueID,1);
					callMethodRedirect('joinGame','player_uniqueID','Player.jsp',game_uniqueID,player_name);
				}
				
			}
			
			function quit()
			{
				var r = confirm("Are you sure to quit the game");
				if (r == true) {
					setCookie('game_uniqueID','ssssssss',0);
					setCookie('player_uniqueID','ssssssss',0);
										
					$.ajax({
				        type: "POST",
				        url: 'callMethod.jsp',
				        data: ({game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>',name:'quitGame'}),
				        dataType: "html",    
				        success: function(data) { 
				        	document.location = 'JoinGame.jsp';
				        },
				        error: function() {
				            alert('Error occured');
				        }
				    });
				
					
					
				} else {
					
				}
				
			}
			
			function quitAndJoin()
			{
				var r = confirm("Are you sure to quit the game");
				if (r == true) {
					setCookie('game_uniqueID','ssssssss',0);
					setCookie('player_uniqueID','ssssssss',0);
					
					$.ajax({
				        type: "POST",
				        url: 'callMethod.jsp',
				        data: ({game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>',name:'quitGame'}),
				        dataType: "html",    
				        success: function(data) { 
				        	document.location = window.location;
				        },
				        error: function() {
				            alert('Error occured');
				        }
				    });
					
					
					
				} else {
					
				}
				
			}


			
		</script>
	</body>
</html>