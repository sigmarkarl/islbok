<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<%@ page import="java.util.ArrayList" %>
<% 
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	String id = request.getParameter("id");
	Person currPerson = (Person) session.getAttribute("currPerson");
	String traceJSON = fimp.islbok_trace(currPerson.getSession(), id);

	if(traceJSON.charAt(0) == '{' || traceJSON.charAt(0) == '[')
	{
		ArrayList personlists = (ArrayList) fimp.parseIslbokPersonArrayTrace(traceJSON);
		ArrayList personLeft = (ArrayList) personlists.get(0);
		ArrayList personRight = (ArrayList) personlists.get(1);
%>
<%@ include file="top.jsp" %>
		<div class="wrap top10">			
				<div class="trace">
					<ul>
					<%
					Person c1 = (Person) personLeft.get(0);
					Person c2 = (Person) personLeft.get(1);
					if(c1.getIslbokid().equals(c2.getIslbokid()))
					{
						%> 
						<li class="single"><a href=""><img src="images/profile.png"><br /><%=c1.getName() %><br /><%=c1.getDateOfBirthHR() %></a></li>
						<%	
					}
					else
					{
						%>
						<li><a href=""><img src="images/profile.png"><br /><%=c1.getName() %><br /><%=c1.getDateOfBirthHR() %></a><a href=""><img src="images/profile.png"><br /><%=c2.getName() %><br /><%=c2.getDateOfBirthHR() %></a></li>
						<%
					}
					
					personLeft.remove(c1);
					personLeft.remove(c2);
					
					for(int i = 0; i < personLeft.size();i++)
					{
						Person t1 = (Person) personLeft.get(i);
						if(i < personRight.size())
						{
							Person t2 = (Person) personRight.get(i);
							%>
							<li><a href="get.jsp?id=<%=t1.getIslbokid()%>"><img src="images/profile.png"><br /><%=t1.getName() %><br /><%=t1.getDateOfBirthHR() %></a><a><img src="images/profile.png"><br /><%=t2.getName() %><br /><%=t2.getDateOfBirthHR() %></a></li>
							<%							
						}
						else
						{
							%>
							<li><a href=""><img src="images/profile.png"><br /><%=t1.getName() %><br /><%=t1.getDateOfBirthHR() %></a></li>
							<%
						}
											
					}
				 %>
					</ul>	
				</div>
	<%
	}//endif
	%>
				
<%@ include file="bottom.jsp" %>