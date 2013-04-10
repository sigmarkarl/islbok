<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<% 
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	String user = request.getParameter("username");
	String pw = request.getParameter("pw");
	Person currPerson = (Person) session.getAttribute("currPerson");

	if(currPerson == null)
	{
		if(user != null && pw != null)
		{
			String loginstring = fimp.login(user, pw);
			if(loginstring != null)
			{
				String[] values = null;
				values = loginstring.split(",");
				String person = fimp.islbok_get(values[0], values[1]);
				currPerson = fimp.parseIslbokPerson(person);
				currPerson.setSession(values[0]);
				session.setAttribute("currPerson", currPerson);
				
				//Person klasinn ætti mögulega að hafa method sem gerir þetta.
				String fatherJSON = fimp.islbok_get(currPerson.getSession(), currPerson.getFather().getIslbokid());
				currPerson.setFather(fimp.parseIslbokPerson(fatherJSON));
				String motherJSON = fimp.islbok_get(currPerson.getSession(), currPerson.getMother().getIslbokid());
				currPerson.setMother(fimp.parseIslbokPerson(motherJSON));
				
				//String siblingsJSON = fimp.islbok_siblings(currPerson.getSession(), currPerson.getIslbokid());
				//currPerson.setSiblings(fimp.parseIslbokPersonArray(siblingsJSON));
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
 %>

<%@ include file="top.jsp" %>
<div class="wrap">

	<div class="userinfo">
		<span class="img"><img src="images/profile.png" /></span>
		<h2><p><%=currPerson.getName()%></p></h2>
		<p><%=currPerson.isMale() ? "Fæddur" : "Fædd"%> <%=currPerson.getComment()%></p>
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
							<p class="text"><%= currPerson.getFather().getName()%> <br /><span>Fæddur <%= currPerson.getFather().getComment() %> <%= currPerson.getFather().getDateOfBirthHR()%></span></p>
						</li>
					</ul>
				</div>
				<div class="col2">
					<ul>
						<li>
							<h3>Móðir</h3>
							<span class="img"><img src="images/profile.png" /></span>
							<p class="text"><%= currPerson.getMother().getName()%> <br /><span>Fædd <%= currPerson.getMother().getComment() %> <%= currPerson.getMother().getDateOfBirthHR()%></span></p>
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
<div class="nav">
	<ul>
		<li class="home"><a href="index.html">Heim</a></li>
		<li class="search"><a href="leit.html">Leit</a></li>
		<li class="familytree"><a href="familytree.html">Fjölskuldutré</a></li>
		<li class="top10"><a href="ftrace.html">Topp 10</a></li>
		<li class="facetrace"><a href="top10.html">Rekja saman facebook vini</a></li>
		<li class="logout"><a href="login.html">Hætta</a></li>
	</ul>
</div>

<%@ include file="bottom.jsp" %>
