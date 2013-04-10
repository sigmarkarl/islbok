<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.simmi.shared.Person" %>
<%@ include file="top.jsp" %>
<%
	Person currPerson = (Person) session.getAttribute("currPerson");
	if(currPerson != null)
	{
		response.sendRedirect("index.jsp");
	}
 %>
	<body class="login">
		<div id="fb-root"></div>
		<!--script>
			var naut = function() {
			  FB.api('/me', function(user) {
	          if (user) {
	          	  var imgurl = 'https://graph.facebook.com/' + user.id + '/picture';
	          	  window.console.log('image found!'+imgurl);
	              //var image = document.getElementById('image');
	              //image.src = 'https://graph.facebook.com/' + user.id + '/picture';
	              //var name = document.getElementById('name');
	              //name.innerHTML = user.name
	            }
	          });
			}
		
			window.fbAsyncInit = function() {
		    	window.FB.init({appId: '161080420720868', status: true, cookie: true, xfbml: true});
		    	try {
					window.FB.getLoginStatus( function(response) {
						try {
							window.FB.XFBML.parse();
						    if (response.status === 'connected') {
						    	window.console.log( "connected" );
						    	var uid = response.authResponse.userID;
						    	window.console.log( "uid "+uid );
						        naut();
						    } else if (response.status === 'not_authorized') {
						       	window.FB.login(function(response) {
							        if (response.authResponse) {
							        	var uid = response.authResponse.userID;
							            naut();
							        } else {
							            // cancelled
							        }
							    });
						    } else {
						        window.FB.login(function(response) {
							        if (response.authResponse) {
							        	var uid = response.authResponse.userID;
							            naut();
							        } else {
							            // cancelled
							        }
							    });
						    }
						} catch( e ) {
							window.console.log( e );
						}
						window.console.log( "past login response" );
					});
				} catch( e ) {
					window.console.log( e );
				}
		  	};
	  	
		  	(function(d){
			     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
			     if (d.getElementById(id)) {return;}
			     js = d.createElement('script'); js.id = id; js.async = true;
			     js.src = "//connect.facebook.net/en_US/all.js";
			     ref.parentNode.insertBefore(js, ref);
			}(document));
		</script-->
		<div class="wrap">

			<form method="post" action="index.jsp">
				<label for="username">Notendanafn</label>
				<input type="text" name="username" />
				<label for="pw">Lykilorð</label>
				<input type="password" name="pw" />
				<input class="button" type="submit" value="Innskrá" />
				<a href="">Tengjast með facebook</a>
			</form>

		</div>
		<script src="js/islendingabok.js"></script>
	</body>
</html>
