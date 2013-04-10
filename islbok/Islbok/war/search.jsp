<%
	String name = request.getParameter("name");
	String dob = request.getParameter("dob");
	
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
	
	}
%>