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

		<div class="nav">
			<ul>
				<li class="home"><a href="index.jsp">Heim</a></li>
				<li class="search"><a href="search.jsp">Leit</a></li>
				<li class="familytree"><a href="ft.jsp">Fjölskuldutré</a></li>
				<li class="facetrace"><a href="ftrace.jsp">Rekja saman facebook vini</a></li>
				<li class="top10"><a href="top10.jsp">Topp 10</a></li>
				<li class="logout"><a href="logout.jsp">Hætta</a></li>
			</ul>
		</div>

		</div>
		<script src="js/islendingabok.js"></script>
	</body>
</html>