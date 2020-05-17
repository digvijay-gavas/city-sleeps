<%@page import="game.global.Player"%>
<%@page import="game.global.GamesStorage"%>
<%
String game_uniqueID = request.getParameter("game_uniqueID");
String player_uniqueID = request.getParameter("player_uniqueID");
String player_type = request.getParameter("player_type");
%>



<style>
body {font-family: Arial, Helvetica, sans-serif;}
* {box-sizing: border-box;}

/* Button used to open the chat form - fixed at the bottom of the page */
.open-button {
  background-color: #555;
  color: white;
  padding: 16px 20px;
  border: none;
  cursor: pointer;
  opacity: 0.8;
  position: fixed;
  bottom: 23px;
  right: 28px;
  width: 280px;
}

/* The popup chat - hidden by default */
.chat-popup {
  display: none;
  position: fixed;
  bottom: 0;
  right: 15px;
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


<div class="chat-popup" id="chat_div" style="display:block">
 	<div id="chatwindow" class="form-container">
	    <h1>Chat with other <text id="player_type"><%=player_type%> </text></h1>
	    <label for="msg"><b>Message</b></label>
	    <textarea id="chats" class="chats" placeholder="<%=GamesStorage.getGame(game_uniqueID).getChat(player_uniqueID)%>" name="msg" disabled></textarea>
	    <textarea id="newMsg" type="text" class="newmsg" placeholder="Type message....." name="sentMsg" required onkeyup="send();" autofocus> </textarea>
	    <button type="button" class="btn cancel" onclick="closeForm()">Close</button>
    </div >
</div>



<script>
document.getElementById("chatwindow").style.display = "none";
function updateChats(){		
	$.ajax({
        type: "POST",
        url: 'chatsTextBox.jsp',
        //data: ({ name:name,arg1:arg1val, arg2:arg2val, arg3:arg3val}),
        data: ({game_uniqueID:'<%=game_uniqueID%>',player_uniqueID:'<%=player_uniqueID%>'}),
        dataType: "html",
        // contentType: "application/json; charset=utf-8",    
        success: function(data) {
        	data=JSON.parse(data);
        	previous_msg=document.getElementById("chats").innerHTML
        	//console.log('previous_msg.length '+previous_msg.length);
        	//console.log('data.length  '+data.length);
        	new_mag=atob(data.chats);
        	if(previous_msg.length!=( new_mag.length-2 ) )
        		document.getElementById("chatwindow").style.display = "block";
        	document.getElementById("chats").innerHTML=new_mag; 
        	$('#chats').scrollTop($('#chats')[0].scrollHeight); 
        	
        	document.getElementById("player_type").innerHTML=data.player_type;
        	if(data.player_role == <%=Player.Civilian%> )
        	{
        		document.getElementById("chatwindow").style.display = "none"; 
        		document.getElementById("startchat").style.display = "none";  
       		}
        		
        },
        error: function() {
            console.log('Error Cannot retrive chats');
        }
    }); 
}

setInterval(updateChats, 2000);

function openForm() {
  document.getElementById("chatwindow").style.display = "block";
}
function closeForm() {
  document.getElementById("chatwindow").style.display = "none";
}

function send()
{
	var inputMsg=document.getElementById('newMsg')
	var msg=inputMsg.value;
	if(msg.charAt(msg.length - 1) === '\n')
	{
		// console.log('sending '+msg);
		document.getElementById("chats").innerHTML=document.getElementById("chats").innerHTML + '\n You : ' + msg; 
		callMethod('addChat',msg); 
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


<button id="startchat" class="open-button" onclick="openForm()">Chat with other <text id="player_type"><%=player_type%> </text></button>


