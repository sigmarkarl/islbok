<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.simmi.shared.Person" %>
<%@ include file="top.jsp" %>
<%
	Person currPerson = (Person) session.getAttribute("currPerson");
	if(currPerson != null)
	{
		response.sendRedirect("index.jsp");
	}
 %>
	<body class="login">
		<div class="wrap">

			<form method="post" action="index.jsp">
				<label for="username">Notendanafn</label>
				<input type="text" name="username" />
				<label for="pw">Lykilorð</label>
				<input type="password" name="pw" />
				<input class="button" type="submit">Innskrá</input>
				<a href="">Tengjast með facebook</a>
			</form>

<%@ include file="bottom.jsp" %>