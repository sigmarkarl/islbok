<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Collection" %>
<% 
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	Person currPerson = (Person) session.getAttribute("currPerson");
	String currCookie = (String) session.getAttribute("jicookie");

	if(currPerson == null)
	{
		if(request.getParameter("username") != null && request.getParameter("pw") != null)
		{
			String user = request.getParameter("username");
			String pw = request.getParameter("pw");
			String loginstring = fimp.login(user, pw);
			if(loginstring != null)
			{
				String[] values = null;
				values = loginstring.split(",");
				String person = fimp.islbok_get(values[0], values[1]);
				currPerson = fimp.parseIslbokPerson(person);
				currPerson.setSession(values[0]);
				session.setAttribute("currPerson", currPerson);
				session.setAttribute("jicookie", fimp.getCookieString());
				
				String fatherJSON = fimp.islbok_get(currPerson.getSession(), currPerson.getFather().getIslbokid());
				currPerson.setFather(fimp.parseIslbokPerson(fatherJSON));
				String motherJSON = fimp.islbok_get(currPerson.getSession(), currPerson.getMother().getIslbokid());
				currPerson.setMother(fimp.parseIslbokPerson(motherJSON));
				
				String childrenJSON = fimp.islbok_children(currPerson.getSession(), currPerson.getIslbokid());
				Person[] children = fimp.parseIslbokPersonArray( childrenJSON );
				currPerson.addChildren( Arrays.asList( children ) );
				
				String siblingsJSON = fimp.islbok_siblings(currPerson.getSession(), currPerson.getIslbokid());
				Person[] siblings = fimp.parseIslbokPersonArray( siblingsJSON );
				currPerson.addSiblings( Arrays.asList( siblings ) );
				
				String matesJSON = fimp.islbok_mates(currPerson.getSession(), currPerson.getIslbokid());
				Person[] mates = fimp.parseIslbokPersonArray( matesJSON );
				currPerson.addMates( Arrays.asList( mates ) );
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
	} else fimp.setCookieString( currCookie );

	if(currPerson != null) 
	{
 %>

<%@ include file="top.jsp" %>
<div class="wrap">

	<div class="userinfo">
		<span class="img"><img src="images/profile.png" /></span>
		<h2><p><%=currPerson.getName()%></p></h2>
		<p><%=currPerson.isMale() ? "Fæddur" : "Fædd"%> <%=currPerson.getComment()%> <br> <%=currPerson.getDateOfBirthHR()%></p>
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
								<%Collection<Person> siblings = currPerson != null ? currPerson.getSiblings() : null;
								  if( siblings != null ) for( Person sibling : siblings ) {%>
									<li>
										<a href="#"><span class="img"><img src="images/profile.png" /></span>
										<p class="text"><%=sibling.getName()%><br /><span><%=sibling.getDateOfBirthHR()%></span></p></a>
									</li>
								<%}%>
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
					<%if( currPerson != null ) {%>
						<h3><%=currPerson.isMale() ? "Eiginkona" : "Eiginmaður"%></h3>
						<ul>
						<%Collection<Person> mates = currPerson.getMates();
					  	if( mates != null ) for( Person mate : mates ) {%>
							<li>								
								<a href="#"><img src="images/profile.png" /><br />
								<%=mate.getName()%><br /><span><%=mate.getDateOfBirthHR()%></span></a>
							</li>
						<%}%>
					<%}%>
					</ul>
				</div>
				<div class="col2">
					<h3>Fyrrum eiginmaður</h3>
					<ul>
						<li>
							<a href="#"><img src="images/profile.png" /><br />
							Nafn Nafnason<br /><span>1973</span></a>
						</li>
					</ul>
				</div>
			</div>
			<div class="tab children" id="tab4">
				<ul>
				<%Collection<Person> children = currPerson != null ? currPerson.getChildren() : null;
				  if( children != null ) for( Person child : children ) {%>
					<li>
						<a href="#"><img src="images/profile.png" /><br />
						<%=child.getName()%><br /><span><%=child.getDateOfBirthHR()%></span></a>
					</li>
				<%}%>
				</ul>
			</div>
		</div>
	</div>
<% } %>
<%@ include file="bottom.jsp" %>

