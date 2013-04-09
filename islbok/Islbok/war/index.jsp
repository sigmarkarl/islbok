<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<%
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	String user = request.getParameter("username");
	String pw = request.getParameter("pw");
	Person currPerson = (Person) session.getAttribute("currPerson");
	String[] values = null;
	if(currPerson == null)
	{
		if(user != null && pw != null)
		{
			String loginstring = fimp.login(user, pw);
			if(loginstring != null)
			{
				//create person object and store in session
				parse
				values = loginstring.split(",");
				
				String person = fimp.islbok_get(values[0], values[1]);
				currPerson = fimp.parseIslbokPerson(person);
				//session.setAttribute("currPerson", currPerson);
			}
			else
		 	{
				response.sendRedirect("login.jsp");
			}
		}
		else
	 	{
			response.sendRedirect("login.jsp");
		}
	}
	else
	{
		response.sendRedirect("login.jsp");
	}
 %>

<%@ include file="top.jsp" %>
<%= values[0] %>
<%= values[1] %>
	<div class="userinfo">
		<span class="img"><img src="images/profile.png" /></span>
		<h2><p>Nafn Nafnason</p></h2>
		<p>Fædd í Keflavík 24. janúar 1987 </p>
	</div>

	<div class="tabs">
		<ul>
			<li><a href="#tab1">Foreldrar</a></li>
			<li><a href="#tab2">Systkini</a></li>
			<li><a href="#tab3">Makar</a></li>
			<li><a href="#tab4">Börn</a></li>
		</ul>
		<div class="content">
			<div id="tab1" class="tab parents multi">
				<div class="col1">
					<ul>
						<li>
							<h3>Faðir</h3>
							<span class="img"><img src="images/profile.png" /></span>
							<p class="text">Þorbjörn Daníelsson <br /><span>Fæddur í Reykjavík 26. júní 1953</span></p>
						</li>
					</ul>
				</div>
				<div class="col2">
					<ul>
						<li>
							<h3>Móðir</h3>
							<span class="img"><img src="images/profile.png" /></span>
							<p class="text">Anna Jóna Guðjónsdóttir <br /><span>Fædd í Reykjavík 25. september 1954</span></p>
						</li>
					</ul>
				</div>
			</div>
			<div class="tab siblings multi" id="tab2">
				<div class="col1">
					<h3>Alsystkin</h3>
					<ul>
						<li>								
							<a href="#"><span class="img"><img src="images/profile.png" /></span>
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
						<li>
							<a href="#"><span class="img"><img src="images/profile.png" /></span>
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
						<li>
							<a href="#"><span class="img"><img src="images/profile.png" /></span>
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
						<li>
							<a href="#"><span class="img"><img src="images/profile.png" /></span>
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
					</ul>
				</div>
				<div class="col2">
					<h3>Hálfsystkin</h3>
					<ul>
						<li>
							<a href="#"><span class="img"><img src="images/profile.png" /></span>
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
					</ul>
				</div>
			</div>
			<div class="tab partners multi" id="tab3">
				<div class="col1">
					<h3>Eiginmaður</h3>
					<ul>
						<li>								
							<a href="#"><img src="images/profile.png" /><br />
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
					</ul>
				</div>
				<div class="col2">
					<h3>Fyrrum eiginmaður</h3>
					<ul>
						<li>
							<a href="#"><img src="images/profile.png" /><br />
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
						<li>
							<a href="#"><img src="images/profile.png" /><br />
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
					</ul>
				</div>
			</div>
			<div class="tab children" id="tab4">
				<ul>
					<li>
						<a href="#"><img src="images/profile.png" /><br />
						Nafn Nafnason<br /><span>1973</span></a>
					</li>
					<li>
						<a href="#"><img src="images/profile.png" /><br />
						Nafn Nafnason<br /><span>1973</span></a>
					</li>
					<li>
						<a href="#"><img src="images/profile.png" /><br />
						Nafn Nafnason<br /><span>1973</span></a>
					</li>
				</ul>
			</div>
		</div>
	</div>

</secton>
<nav>
	<ul>
		<li class="home"><a href="index.html">Heim</a></li>
		<li class="search"><a href="leit.html">Leit</a></li>
		<li class="familytree"><a href="familytree.html">Fjölskuldutré</a></li>
		<li class="top10"><a href="ftrace.html">Topp 10</a></li>
		<li class="facetrace"><a href="top10.html">Rekja saman facebook vini</a></li>
		<li class="logout"><a href="login.html">Hætta</a></li>
	</ul>
</nav>

<div class="popup">
	<h2>Leitarniðurstöður</h2>
	<div class="content">
		<ul>
			<li><a href=""><span><img src="images/profile.png" /></span><span class="name">Eva Lind Þorsteinsdóttir</span><br /><span class="dob">20. júlí 1987</span></a></li>
			<li><a href=""><span><img src="images/profile.png" /></span><span class="name">Eva Brá Þorsteinsdóttir</span><br /><span class="dob">1. febrúar 1990</span></a></li>
		</ul>
	</div>

	<form class="search">
		<label for="name">Nafn</label>
		<input type="text" name="name" />
		<label for="dob">Fæðingardagur</label>
		<input type="date" name="dob">
		<button type="submit">Leita</button>
	</form>
	<a class="close" href="#">loka</a>
</div>
<%@ include file="bottom.jsp" %>