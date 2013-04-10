<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<%
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	String name = request.getParameter("name");
	String dob = request.getParameter("dob");
	Person currPerson = (Person) session.getAttribute("currPerson");
	//Person p = (Person) session.getAttribute("currPerson");
	if(name == null && dob == null)
	{
%>
<form id="search" method="post" action="search.jsp" class="search">
	<label for="name">Nafn</label>
	<input type="text" name="name" />
	<label for="dob">Fæðingardagur</label>
	<input type="date" name="dob">
	<button type="submit">Leita</button>
</form>
<%
	}
	else //leitum
	{
		String findJSON = "";
		if(name != null && dob != null)
		{
			findJSON = fimp.islbok_find( currPerson.getSession(), name, dob );
		}
		else if(name != null) 
		{
			findJSON = fimp.islbok_find( currPerson.getSession(), name, "" );
		}
		else
		{
			findJSON = fimp.islbok_find( currPerson.getSession(), "", dob );
		}
		
		if(findJSON.charAt(0) == '{' || findJSON.charAt(0) == '[')
		{
			Person[] persons = fimp.parseIslbokPersonArray(findJSON);
%>
			<h2>Leitarniðurstöður</h2>
			<div class="content">
				<ul>
					<%
					for(int i = 0;i<persons.length;i++)
					{
					%>
					<li><a href="trace.jsp?id=<%=persons[i].getIslbokid()%>"><span><img src="images/profile.png" /></span><span class="name"><%=persons[i].getName()%></span><br /><span class="dob"><%=persons[i].getDateOfBirthHR()%></span></a></li>
					<%
					}
					%>
				</ul>
			</div>
<%
		}
		else
		{
		%>
			<h2>Leitarniðurstöður</h2>
			<div class="content">
			<p>Leitin skilaði ekki árangri, prufaðu að þrengja leitarskilyrðin.</p>
			</div>
		<%
		}
		
	}
%>