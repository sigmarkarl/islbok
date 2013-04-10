<%@ page import="org.simmi.server.FrislbokServiceImpl" %>
<%@ page import="org.simmi.shared.Person" %>
<%@ page import="java.util.ArrayList" %>
<% 
	FrislbokServiceImpl fimp = new FrislbokServiceImpl();
	String id = request.getParameter("id");
	Person currPerson = (Person) session.getAttribute("currPerson");
	String traceJSON = fimp.islbok_trace(currPerson.getSession(), id);
	//ArrayList personlists = fimp.parseIslbokPersonArrayTrace(traceJSON); 
%>
<%@ include file="top.jsp" %>

<%= currPerson.getSession() %>
<%= traceJSON %>
		<div class="wrap top10">			
		</div>
<%@ include file="bottom.jsp" %>