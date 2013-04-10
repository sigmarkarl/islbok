<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<%
	String name = request.getParameter("name");
	String dob = request.getParameter("dob");
	Person currPerson = (Person) session.getAttribute("currPerson");
	//Person[] persons;
	Person p = (Person) session.getAttribute("currPerson");
	if(name == null && dob == null)
	{
%>
<form method="post" action="search.jsp" class="search">
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
		if(name != null)
		{
			//err TODO: búa til method til þess að leita.
			
		}
%>		
		<h2>Leitarniðurstöður</h2>
		<div class="content">
			<ul>
				<%
				//for()
				//{
				%>
				<li><a href="trace.jsp?session=<%=currPerson.getSession()%>"&id=<%=p.getIslbokid()%>><span><img src="images/profile.png" /></span><span class="name"><%=p.getName()%></span><br /><span class="dob"><%=p.getDateOfBirthHR()%></span></a></li>
				<%
				//}
				%>
			</ul>
		</div>		
<%	
	}
%>