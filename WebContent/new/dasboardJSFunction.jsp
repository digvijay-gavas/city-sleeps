<%
%>
<!-- script	src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script -->
<script	src="js/jquery.min.js"></script>
<script type="text/javascript">
	function setCookie(cname, cvalue, exdays) {
	  var d = new Date();
	  d.setTime(d.getTime() + (exdays*24*60*60*1000));
	  var expires = "expires="+ d.toUTCString();
	  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
	}

	
	function callMethodRedirect(name,cookie_name,redirect,arg1,arg2,arg3)
	{
		/*var arg1val='';
		var arg2val='';
		var arg3val='';
		
		var ele1=document.getElementById(arg1);
		var ele2=document.getElementById(arg2);
		var ele3=document.getElementById(arg3);
		
		if(ele1!=null)
			arg1val=ele1.getAttribute('value');
		if(ele2!=null)
			arg2val=ele2.getAttribute('value');
		if(ele3!=null)
			arg3val=ele3.getAttribute('value');
		
		console.log(name);
		console.log(arg1val);
		console.log(arg2val);
		console.log(arg3val); */
		
		//$('#status_div').load('callMethod.jsp',{name:name,arg1:arg1val, arg2:arg2val, arg3:arg3val });
		//setCookie(cookie_name,document.getElementById('status_div'),1);
		
		$.ajax({
	        type: "POST",
	        url: 'callMethod.jsp',
	        //data: ({ name:name,arg1:arg1val, arg2:arg2val, arg3:arg3val}),
	        data: ({ name:name,arg1:arg1, arg2:arg2, arg3:arg3}),
	        dataType: "html",
	        // contentType: "application/json; charset=utf-8",    
	        success: function(data) {
	        	data=JSON.parse(data);
	        	setCookie(cookie_name,data[0].gameID,1);
	        	document.location = redirect;
	        	//console.log('-success');
	        	//console.log(data[0].gameID);
	            return data;
	        },
	        error: function() {
	            alert('Error occured');
	        }
	    });
	}
	
	
	function isSession(selector) {
	    $.ajax({
	        type: "POST",
	        url: '/order.html',
	        data: ({ issession : 1, selector: selector }),
	        dataType: "html",
	        success: function(data) {
	            // Run the code here that needs
	            //    to access the data returned
	            return data;
	        },
	        error: function() {
	            alert('Error occured');
	        }
	    });
	}
</script>