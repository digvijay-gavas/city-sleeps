<%
String game_uniqueID = request.getParameter("game_uniqueID");
String player_uniqueID = request.getParameter("player_uniqueID");
%>
<script	src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript">
	setInterval(function(){
  		$('#players_div').load('PlayersPlayboard.jsp #players_div',{game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>'});}, 2000) 
	function callMethod(name,arg1,arg2,arg3)
	{
		console.log(name);
		console.log(arg1);
		console.log(arg2);
		console.log(arg3);
		$('#status_div').load('callMethod.jsp',{game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>',name:name,arg1:arg1, arg2:arg2, arg3:arg3 });
		$('#players_div').load('PlayersPlayboard.jsp #players_div',{game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>'});
	}
</script>