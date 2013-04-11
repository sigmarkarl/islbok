<%@ include file="top.jsp" %>
<% 
	session.invalidate(); 
	response.sendRedirect("login.jsp");
%>
<%@ include file="bottom.jsp" %>