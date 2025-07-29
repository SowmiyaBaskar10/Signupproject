<%@ page language="java" contentType="text/html; charset=ISO-8859-1" import="java.util.*,java.io.*,com.employee.Employeedetails"  pageEncoding="ISO-8859-1"%>
<jsp:useBean id="Empd" scope="request" class="com.employee.Employeedetails"/> 
<%
Integer UserId = (Integer)session.getAttribute("SessionUserId");
String oldPwd = request.getParameter("hidOldPwd");	
if(oldPwd == null) oldPwd = "";
String newPwd = request.getParameter("hidNewPwd");
if(newPwd == null) newPwd = "";

String resultMsg = "";

//System.out.println("oldPwd in ajax>>"+oldPwd);
//System.out.println("UserId in ajax>>"+UserId);
//System.out.println("newPwd in ajax>>"+newPwd);
try
{
	resultMsg = Empd.changePassword(UserId,oldPwd,newPwd);
	//System.out.println("resultMsg>>"+resultMsg);
	out.println(resultMsg);
	
}catch(Exception e)
{
	System.out.println("Exception while changing the password in ajax :: "+e);
}
%>
