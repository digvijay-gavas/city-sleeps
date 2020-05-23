<%@page import="game.global.Player"%>
<%@page import="game.global.GamesStorage"%>
<%
String game_uniqueID = request.getParameter("game_uniqueID");
String player_uniqueID = request.getParameter("player_uniqueID");
String player_type = request.getParameter("player_type");
String player_typeID_STRING= request.getParameter("player_typeID");
String is_superviser= request.getParameter("is_superviser");
int player_typeID=Player.NoOneYet;
if(player_typeID_STRING == null)
	player_typeID=Player.NoOneYet ;
else 
	player_typeID=Integer.parseInt(player_typeID_STRING);

String windowshift= request.getParameter("windowshift");
%>



<style>
body {font-family: Arial, Helvetica, sans-serif;}
* {box-sizing: border-box;}

/* Button used to open the chat form - fixed at the bottom of the page */
.open-button_<%=player_type%> {
  background-color: #555;
  color: white;
  padding: 16px 20px;
  border: none;
  cursor: pointer;
  opacity: 0.8;
  position: fixed;
  bottom: 23px;
  <%=windowshift==null?"right: 28px":"right: "+windowshift%>; 
  width: 280px;
}

/* The popup chat - hidden by default */
.chat-popup_<%=player_type%> {
  display: none;
  position: fixed;
  bottom: 0;
  <%=windowshift==null?"right: 28px":"right: "+windowshift%>; 
  border: 3px solid #f1f1f1;
  z-index: 9;
}

/* Add styles to the form container */
.form-container {
  max-width: 300px;
  padding: 10px;
  background-color: white;
}

/* Full-width textarea */
.form-container .chats {
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  border: none;
  background: #f1f1f1;
  resize: none;
  min-height: 200px;
}

.newmsg {
  width: 100%;
  padding: 15px;
  margin: 5px 0 22px 0;
  border: none;
  background: #f1f1f1;
  resize: none;
  min-height: 10px;
}

/* When the textarea gets focus, do something */
.form-container textarea:focus {
  background-color: #ddd;
  outline: none;
}

/* Set a style for the submit/send button */
.form-container .btn {
  background-color: #4CAF50;
  color: white;
  padding: 16px 20px;
  border: none;
  cursor: pointer;
  width: 10%;
  margin-bottom:10px;
  opacity: 0.8;
}

/* Add a red background color to the cancel button */
.form-container .cancel {
  width: 100%;
  background-color: red;
}

/* Add some hover effects to buttons */
.form-container .btn:hover, .open-button:hover {
  opacity: 1;
}
</style>


<div class="chat-popup_<%=player_type%>" id="chat_div_<%=player_type%>" style="display:block">
 	<div id="chatwindow_<%=player_type%>" class="form-container">
	    <h1>Chat with other <text id="player_type_<%=player_type%>"><%=player_type%> </text></h1>
	    <label for="msg"><b>Message</b></label>
	    <%
	    if(is_superviser!=null && is_superviser.equalsIgnoreCase("true")) 
	    {
	    	%><textarea id="chats_<%=player_type%>" class="chats" placeholder="<%=GamesStorage.getGame(game_uniqueID).getChat(player_typeID)%>" name="msg" disabled></textarea><%
	    }
	    else
	    {
	    	%><textarea id="chats_<%=player_type%>" class="chats" placeholder="<%=GamesStorage.getGame(game_uniqueID).getChat(player_uniqueID)%>" name="msg" disabled></textarea><%
		}%>
	    	
	    <textarea id="newMsg_<%=player_type%>" type="text" class="newmsg" placeholder="Type message....." name="sentMsg" required onkeyup="send_<%=player_type%>();" > </textarea>
	    <button type="button" class="btn cancel" onclick="closeForm_<%=player_type%>()">Close</button>
    </div >
</div>



<script>

function decodeUnicode(str) {
	  // Going backwards: from bytestream, to percent-encoding, to original string.
	  return decodeURIComponent(atob(str).split('').map(function (c) {
	    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
	  }).join(''));
	}


document.getElementById("chatwindow_<%=player_type%>").style.display = "none";
function updateChats_<%=player_type%>(){		
	$.ajax({
        type: "POST",
        url: 'chatsTextBox.jsp', 
        //data: ({ name:name,arg1:arg1val, arg2:arg2val, arg3:arg3val}),
        <%
	    if(is_superviser!=null && is_superviser.equalsIgnoreCase("true")) 
	    {
	    	%>data: ({game_uniqueID:'<%=game_uniqueID%>',player_typeID:'<%=player_typeID%>',is_superviser:'true'}),<%
	    } 
	    else
	    {
	    	%>data: ({game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>'}),<%
		}%>
        
        dataType: "html",
        // contentType: "application/json; charset=utf-8",    
        success: function(data) {
        	data=JSON.parse(data);
        	previous_msg=document.getElementById("chats_<%=player_type%>").innerHTML
        	
        	//new_mag=atob(data.chats);
        	new_mag=decodeUnicode(data.chats);
        	
        	//console.log('previous_msg.length '+previous_msg.length);
        	//console.log('new_mag.length  '+new_mag.length);
        	
        	if(previous_msg.length!=new_mag.length )
       		{
       			document.getElementById("chatwindow_<%=player_type%>").style.display = "block";
       			document.getElementById("chats_<%=player_type%>").innerHTML=new_mag; 
       			$('#chats_<%=player_type%>').scrollTop($('#chats_<%=player_type%>')[0].scrollHeight);
       		}
        	 
        	
        	document.getElementById("player_type_<%=player_type%>").innerHTML=data.player_type;
        	document.getElementById("player_type1_<%=player_type%>").innerHTML=data.player_type;
        	if(data.player_role == <%=Player.Civilian%> )
        	{
        		document.getElementById("chatwindow_<%=player_type%>").style.display = "none"; 
        		document.getElementById("startchat_<%=player_type%>").style.display = "none";  
       		}
       		else
       		{
       			document.getElementById("startchat_<%=player_type%>").style.display = "block";  
       		}	
        		
        },
        error: function() {
            console.log('Error Cannot retrive chats');
        }
    }); 
}

setInterval(updateChats_<%=player_type%>, 2000);

function openForm_<%=player_type%>() {
  document.getElementById("chatwindow_<%=player_type%>").style.display = "block";
}
function closeForm_<%=player_type%>() {
  document.getElementById("chatwindow_<%=player_type%>").style.display = "none";
}

function send_<%=player_type%>()
{
	var inputMsg=document.getElementById('newMsg_<%=player_type%>')
	var msg=inputMsg.value;
	if(msg.charAt(msg.length - 1) === '\n')
	{
		// console.log('sending '+msg);
		document.getElementById("chats_<%=player_type%>").innerHTML=document.getElementById("chats_<%=player_type%>").innerHTML + '\n You : ' + msg; 
		 
		<% 
	    if(is_superviser!=null && is_superviser.equalsIgnoreCase("true")) 
	    {
	    	%>callMethod('addChatSuperviser',<%=player_typeID%>,msg);<%
	    } 
	    else
	    {
	    	%>callMethod('addChat',msg); <%
		}%>
		inputMsg.value=''; 
		inputMsg.focus();  
	} 
 
}

//Get the input field
/*var input = document.getElementById("newMsg");

// Execute a function when the user releases a key on the keyboard
input.addEventListener("keyup", function(event) {
  // Number 13 is the "Enter" key on the keyboard
  if (event.keyCode === 13) {
    // Cancel the default action, if needed
    // event.preventDefault();
    // Trigger the button element with a click
    // document.getElementById("sendBtn").click();
	callMethodAndRefresh('','','addMafiaChat',document.getElementById('newMsg'));
  }
});*/
</script>


<button id="startchat_<%=player_type%>" class="open-button_<%=player_type%>" onclick="openForm_<%=player_type%>()">Chat with other <text id="player_type1_<%=player_type%>"><%=player_type%> </text></button>


