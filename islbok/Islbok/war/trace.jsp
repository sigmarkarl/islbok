<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<% 
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	String id = request.getParameter("id");
	Person currPerson = (Person) session.getAttribute("currPerson");
	String traceJSON = fimp.islbok_trace(currPerson.getSession(), id);
%>

<%@ include file="top.jsp" %>
		<div class="wrap top10">			
				<div class="trace">
					<ul>
						<li><a href=""><img src="images/profile.png"><br />Nafn Millinafn Nafnason<br />1900-2000</a><a href=""><img src="images/profile.png"><br />Nafn Millinafn Nafnason<br />1900-2000</a></li>
						<li><a href=""><img src="images/profile.png">Nafn Millinafn Nafnason<br />1900-2000</a><a href=""><img src="images/profile.png"><br />Nafn Millinafn Nafnason<br />1900-2000</a></li>
						<li><a href=""><img src="images/profile.png">Nafn Millinafn Nafnason<br />1900-2000</a><a href=""><img src="images/profile.png"><br />Nafn Millinafn Nafnason<br />1900-2000</a></li>
						<li><a href=""><img src="images/profile.png">Nafn Millinafn Nafnason<br />1900-2000</a><a href=""><img src="images/profile.png"><br />Nafn Millinafn Nafnason<br />1900-2000</a></li>
					</ul>
				</div>
<%@ include file="bottom.jsp" %>