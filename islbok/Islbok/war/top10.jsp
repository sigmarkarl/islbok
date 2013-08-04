<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<%@ page import="java.util.ArrayList" %>
<% 
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	//String id = request.getParameter("id");
	Person currPerson = (Person) session.getAttribute("currPerson");
	fimp.setCookieString( (String)session.getAttribute("jicookie") );
%>
<%@ include file="top.jsp" %>
		<div class="wrap top10">
				<ul class="tlist">
					<li class="text"><span>Topp 10</span><br />íslendingar sem flestir rekja ættir sínar við</li>
					<li class="m n1">
						<a href="trace.jsp?id=312636"><span>
						<img src="images/vigga.jpg">
						<p class="text">Vigdís Finnbogadóttir</p>
						</span></a>
					</li>
					<li class="f n2">
						<% String findJSON = fimp.islbok_find( currPerson.getSession(), "Sigmundur Davíð Gunnlaugsson", "12031975" );
						Person[] persons = fimp.parseIslbokPersonArray(findJSON);
						String id = persons[0].getIslbokid();
						%>
						<a href="trace.jsp?id=<%=id%>"><span>
						<img src="images/sigmundur.jpg">
						<p class="text">Sigmundur Davíð Gunnlaugsson</p>
						</span></a>
					</li>
					<li class="f n3">
						<img src="images/gillz.jpg">
						<p class="text">Egill 'Gillz' Einarsson</p>
					</li>
					<li class="m n4">
						<%findJSON = fimp.islbok_find( currPerson.getSession(), "Hildur Lilliendahl", null );
						Person[] hpersons = fimp.parseIslbokPersonArray(findJSON);
						String hid = hpersons[0].getIslbokid();
						%>
						<a href="trace.jsp?id=<%=hid%>"><span>
						<img src="images/hildur.jpg">
						<p class="text">Hildur Lillendahl Viggósdóttir</p>
						</span></a>
					</li>
					<li class="m n5">
						<%findJSON = fimp.islbok_find( currPerson.getSession(), "Hildur Lilliendahl", null );
						Person[] opersons = fimp.parseIslbokPersonArray(findJSON);
						String oid = opersons[0].getIslbokid();
						%>
						<a href="trace.jsp?id=<%=oid%>"><span>
						<img src="images/oligris.jpg">
						<p class="text">Ólafur Ragnar Grímsson</p>
						</span></a>
					</li>
					<li class="m n6">
						<img src="images/nanna.jpg">
						<p class="text">Nanna Bryndís Hilmarsdóttir</p>
					</li>
					<li class="m n7">
						<img src="images/profile.png">
						<p class="text">Nafn Millinafn Nafnason</p>
					</li>
					<li class="m n8">
						<img src="images/profile.png">
						<p class="text">Nafn Millinafn Nafnason</p>
					</li>
					<li class="m n9">
						<img src="images/profile.png">
						<p class="text">Nafn Millinafn Nafnason</p>
					</li>
					<li class="m n10">
						<img src="images/profile.png">
						<p class="text">Nafn Millinafn Nafnason</p>
					</li>
				</ul>
<%@ include file="bottom.jsp" %>