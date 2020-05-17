<%
String game_uniqueID = request.getParameter("game_uniqueID");
String player_uniqueID = request.getParameter("player_uniqueID");
String auto_refersh_page = request.getParameter("auto_refersh_page");
String auto_refersh_div = request.getParameter("auto_refersh_div");
String auto_refersh=auto_refersh_page+" "+auto_refersh_div;
%>
<!--  script	src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script -->
<script	src="js/jquery.min.js"></script>
<script type="text/javascript">
	setInterval(function(){
  		$('<%=auto_refersh_div%>').load('<%=auto_refersh%>',{game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>'});}, 2000) 
	function callMethod(name,arg1,arg2,arg3)
	{
		console.log(name);
		console.log(arg1);
		console.log(arg2);
		console.log(arg3);
		$.ajax({
	        type: "POST",
	        url: 'callMethod.jsp',
	        data: ({game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>',name:name,arg1:arg1, arg2:arg2, arg3:arg3 }),
	        dataType: "html",    
	        success: function(data) { 
	        },
	        error: function() {
	            alert('Error occured');
	        }
	    });
	}
	
	function refreshDiv(source,div_id)
	{
		$(div_id).load(source +' '+ div_id);
	}
	
	function callMethodAndRefresh(refresh_page,refresh_div,name,arg1,arg2,arg3)
	{
		console.log(name);
		console.log(arg1);
		console.log(arg2);
		console.log(arg3);
		
		$.ajax({
	        type: "POST",
	        url: 'callMethod.jsp',
	        //data: ({ name:name,arg1:arg1val, arg2:arg2val, arg3:arg3val}),
	        data: ({game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>',name:name,arg1:arg1, arg2:arg2, arg3:arg3 }),
	        dataType: "html",
	        // contentType: "application/json; charset=utf-8",    
	        success: function(data) {
	        	//data=JSON.parse(data);
	        	//setCookie(cookie_name,data[0].gameID,1);
	        	$(refresh_div).load(refresh_page+' '+refresh_div,{game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>'});
	        	//console.log('-success');
	        	//console.log(data[0].gameID);
	        	document.getElementById('status_div').innerHTML=data
	            return data;
	        },
	        error: function() {
	            alert('Error occured');
	        }
	    });
	}
</script>