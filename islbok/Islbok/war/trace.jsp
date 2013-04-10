<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<%@ page import="java.util.ArrayList" %>
<% 
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	String id = request.getParameter("id");
	Person currPerson = (Person) session.getAttribute("currPerson");
	String traceJSON = fimp.islbok_trace(currPerson.getSession(), id);
	//ArrayList personlists = (ArrayList) fimp.parseIslbokPersonArrayTrace(traceJSON); 
%>
<%@ include file="top.jsp" %>
<%= id %>
		<div class="wrap top10">			
				<div class="trace">
					<ul>
					<% 
						if(personlists.get(0).get(0).getIslbokid().equals(personlists.get(0).get(1).getIslbokid()))
						{
							%> 
							<li><a href=""><img src="images/profile.png"><br /><%=personlists.get(0).get(0).getName() %><br /><%=personlists.get(0).get(0).getDateOfBirthHR() %></a></li>
							<%	
						}
						else
						{
							%>
							<li><a href=""><img src="images/profile.png"><br /><%=personlists.get(0).get(0).getName() %><br /><%=personlists.get(0).get(0).getDateOfBirthHR() %></a><a href=""><img src="images/profile.png"><br /><%=personlists.get(0).get(1).getName() %><br /><%=personlists.get(0).get(1).getDateOfBirthHR() %></a></li>
							<%
						}

					for(int i = 2; i<personlists.get(0).size();i++)
					{
						if(personlists.get(1).get(i) != null)
						{
							%>
							<li><a href=""><img src="images/profile.png"><br /><%=personlists.get(0).get(i).getName() %><br /><%=personlists.get(0).get(i).getDateOfBirthHR() %></a><a href=""><img src="images/profile.png"><br /><%=personlists.get(1).get(i).getName() %><br /><%=personlists.get(1).get(i).getDateOfBirthHR() %></a></li>
							<%							
						}
						else
						{
							%>
							<li><a href=""><img src="images/profile.png"><br /><%=personlists.get(0).get(i).getName() %><br /><%=personlists.get(0).get(i).getDateOfBirthHR() %></a></li>
							<%
						}
											
					}
				 %>
					</ul>
				</div>
<%@ include file="bottom.jsp" %>