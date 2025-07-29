<%@ page language="java" contentType="text/html; charset=ISO-8859-1" import="java.util.*,java.io.*,java.lang.*,com.employee.Employeedetails"  pageEncoding="ISO-8859-1"%>
<jsp:useBean id="Empd" scope="request" class="com.employee.Employeedetails"/> 
<jsp:setProperty name="Empd" property="*" /> 
 <%
    String strAction = request.getParameter("pageaction");
    if(strAction == null) strAction = "";
    List lstPersonDetails = new ArrayList();	
  
    String strResult = "";
    String orgUserName = "";
	String orgPassword = "";
	String orgFirstName = "";
	String orgLastName = "";
	String orgEmail = "";
	String orgReEnterPassword = "";
	int userId;
    try
    {
 		String strFirstName = request.getParameter("txtFN");	
    	if(strFirstName == null) strFirstName = "";
    	String strLastName = request.getParameter("txtLN");
    	if(strLastName == null) strLastName = "";
    	String strEmail = request.getParameter("txtEmailId");
    	if(strEmail == null) strEmail = "";
    	String strPassword = request.getParameter("txtPwd"); 
    	if(strPassword== null) strPassword = "";
    	String strRePassword = request.getParameter("txtPwd1"); 
    	if(strRePassword== null) strRePassword = "";
    	
    	if(strAction.trim().equals("USER_LOGIN")) 
	    {
    		try
    		{
	    		String userEmail = request.getParameter("loginEmail");
				if(userEmail == null)userEmail = "";
				String userpass = request.getParameter("loginPassword");
				if(userpass == null)userpass = "";
				
				lstPersonDetails = Empd.getuserdetails(userEmail);
				if(lstPersonDetails.size() > 0)
				{
					 for(int i =0;i<=lstPersonDetails.size();i=i++)
					 {
						 Empd 			= (Employeedetails) lstPersonDetails.get(i);
						 userId 		= Empd.getUser_id();
						 orgFirstName 	= Empd.getFirst_name();
						 orgLastName 	= Empd.getLast_name();
						 orgUserName 	= Empd.getUsername();
						 orgEmail 		= Empd.getEmail();
						 orgPassword	= Empd.getPassword();
						 orgReEnterPassword = Empd.getReenter_password();
						 
						if(userpass.equals(orgPassword))
						{
							//System.out.println("orgFirstName : "+orgFirstName);
							//System.out.println("orgLastName : "+orgLastName);
							//System.out.println("orgUserName : "+orgUserName);
							
							session.setAttribute("SessionUserId", userId);
							session.setAttribute("SessionUserName", orgUserName);
							session.setAttribute("SessionUserEmail", orgEmail);
							response.sendRedirect("postmessage.jsp");
						}
					 }
				}
				else
				{
					strResult = "Please Enter Valid Email and Password.";
				}
				
    		}catch(Exception e)
    		{
    			System.out.println("Exception while logging into the signup page :: "+e);
    		}

	    }
    	else if(strAction.trim().equals("INSERT_RECORD")) 
	    {
	    	strResult = Empd.insertUserDetails(strFirstName, strLastName, strEmail, strPassword,strRePassword);
	   		//System.out.println("strResult in jsp >>"+strResult);
		}
    
	}catch (Exception exp)
    {
    	System.out.println("Exception in login.jsp page:::"+exp.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Signup Page</title>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <style>
        body { font-family: Arial; background: #f0f0f0; }
        form { width: 450px; margin: 100px auto; padding: 20px; background: white; border-radius: 8px; }
        input { width: 100%; margin: 10px 0; padding: 6px; }
        button { background: blue; color: white; padding: 10px; border: none; }
	.mandatory
	{
	  color:#cc0000;
	  font-size:20px;
	  vertical-align: middle;
	}

    </style>
</head>
<body>
    <form name="frmLoginIn" id= "frmLoginIn"  method="post" autocomplete = "off">
		<div class = "container">
		
		<div class="row" id="divLogin">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 hidden-xs hidden-sm">
		        <h2>Login</h2>
		        
		        <div class="form-group">
					<label for="loginEmail">Email&nbsp;<span class="mandatory">*</span></label>
					  	<input type="email" class="form-control" name="loginEmail" id="loginEmail" maxlength="100" placeholder="Enter Email" required onkeyup = "javascript:funButtonEnableLogin();">
					 <label for="loginPassword">Password&nbsp;<span class="mandatory">*</span></label>
					  	<input type="password" class="form-control" name="loginPassword" id="loginPassword" maxlength="255" placeholder="Enter Password" required onkeyup = "javascript:funButtonEnableLogin();" />
		       		 <div style="display: grid">
				        <button type="button" disabled class="btn btn-info btn-md" name="btnLogin" id="btnLogin" onclick="javascript:funLogin()" disabled value="Login">Log in</button>&nbsp;
				        <h6>Don't have an account? <a href="javascript:funOpenSignup()">Sign up</a></h6>
		        	</div>
				</div>
        	</div>
        </div>
        
        <div class="row" id="divSignup" style="display:none;">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 hidden-xs hidden-sm">
		        <h2>Signup</h2>
		        	 <div class="row">
							<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
								<div class="form-group">
									<label>First Name &nbsp;<span class="mandatory">*</span></label>
									<input type="text" class="form-control" name="txtFN" id="txtFN" maxlength="50" placeholder="Enter First Name" onkeyup= "javascript:funButtonEnable();">
								</div>
								<div class="form-group">
									<label>Last Name &nbsp;<span class="mandatory">*</span></label>
									<input type="text" class="form-control" name="txtLN"  id="txtLN"  maxlength="50"  placeholder="Enter Last Name" onkeyup= "javascript:funButtonEnable();">
								</div>
								<div class="form-group">
									<label>Email&nbsp;<span class="mandatory">*</span></label>
									<input type="text" class="form-control" name="txtEmailId" id="txtEmailId" maxlength="100"  placeholder="Enter Email" onkeyup= "javascript:funButtonEnable();">
								</div>
								<div class="form-group">
									<label>Password &nbsp;<span class="mandatory">*</span></label>
									<input type="password" class="form-control" name="txtPwd" id="txtPwd" maxlength="255"  placeholder="Enter Password" onkeyup= "javascript:funButtonEnable();">
								</div>
								<div class="form-group">
									<label>Re-Enter Password &nbsp;<span class="mandatory">*</span></label>
									<input type="password" class="form-control" name="txtPwd1" id="txtPwd1" maxlength="255"  placeholder="Re-Enter Password" onkeyup= "javascript:funButtonEnable();">
								</div>
							</div>
						</div>
		        	 	<div class = "row">
							<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style = "padding-top:5px;"> 
								<button type="button" class="btn btn-success btn-md" name="btnSave" id="btnSave" onclick="javascript:funSave()" disabled value="Save" data-toggle="tooltip" title = "Click to Save" data-placement="bottom">Save</button>
								<button type="button" class="btn btn-secondary btn-md" name="btnClose" id="btnClose" onclick="javascript:funOpenLogin()" data-toggle="tooltip" title = "Click to Close" data-placement="bottom">Close</button>
							</div>
							 <div class = "row">
							 	<div style="display: grid;padding-top: 20px;padding-left: 31px;">
									<h6>Already have an account? <a href="javascript:funOpenLogin()">Login</a></h6>
								</div>
							</div>
						</div>
					</div>
        		</div>
        		
         
       	 	</div>
        <input type="hidden" id="pageaction" name="pageaction">
    </form>
</body>

<script type="text/javascript">

$(document).ready(function() {
	
	$("#loginEmail").focus();
	
		var msgVal = '<%=strResult%>';
	
		if(msgVal!="")
		{
			alert(msgVal);	
		}
	
	$("#btnSave").click(function()
	{
		var email=$("#txtEmailId").val();
		//alert("email>>"+email);
		if (IsEmail(email)) 
		{
	     	//alert('Email is valid');
	    }else 
	    {
	         alert('Invalid Email Address');
	         e.preventDefault();
	    }
		var SaveValue =  $("#btnSave").val();
		if(SaveValue == "Save")
		{  
			$("#pageaction").val("INSERT_RECORD");
	 	}		
		$("#frmLoginIn").attr("action","./login.jsp");
		$("#frmLoginIn").submit(); 
	});
	
	$("#txtFN").keypress(function(event)
	 {
		var charcode=event.which;
		if ((charcode > 64 && charcode < 91) || (charcode > 96 && charcode < 123) || charcode == 8)
		{
			return true;
		}else
		{
			return false;	
		};
	}); 

	$("#txtLN").keypress(function(event)
	{
		var charcode=event.which;
		if ((charcode > 64 && charcode < 91) || (charcode > 96 && charcode < 123) || charcode == 8)
		{
			return true;
		}else
		{
			return false;	
		};
	});	 
	
});

function funOpenLogin()
{
	$("#divSignup").hide();
	$("#divLogin").show();
	$("#loginEmail").focus();
}

function funOpenSignup()
{
	$("#divLogin").hide();
	$("#divSignup").show();
	$("#txtFN").focus();
}
function IsEmail(email) 
{
	  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	  return regex.test(email);
}

function funButtonEnableLogin()
{
	var loginEmailVal = $.trim($("#loginEmail").val());
   	var txtPwdVal = $.trim($("#loginPassword").val());
   	if(loginEmailVal != "" && txtPwdVal != "")
	{
		$("#btnLogin").attr('disabled', false);
	}
	else
	{
		$("#btnLogin").attr('disabled', true);
	}
}
function funButtonEnable()
{
   	var txtFNVal = $.trim($("#txtFN").val()); 
   	var txtLNVal = $.trim($("#txtLN").val());
   	var txtEmailIdVal = $.trim($("#txtEmailId").val());
   	var txtPwdVal = $.trim($("#txtPwd").val());
   	var txtPwd1Val = $.trim($("#txtPwd1").val());
   	if(txtFNVal != "" && txtLNVal != "" && txtEmailIdVal !="" &&  txtPwdVal !="" && txtPwd1Val !="")
	{
		$("#btnSave").attr('disabled', false);
	}
	else
	{
		$("#btnSave").attr('disabled', true);
	}
}

function funLogin()
{
	var email=$.trim($("#loginEmail").val());
	var pwd = $.trim($("#loginPassword").val());
	//alert("email>>"+email);
	if (IsEmail(email)) 
	{
     	//alert('Email is valid');
    }else 
    {
         alert('Invalid Email Address');
         e.preventDefault();
    }
	
	$("#pageaction").val("USER_LOGIN");
	$("#frmLoginIn").attr("action","./login.jsp");   	                
	$("#frmLoginIn").submit();
}
</script>
</html>

