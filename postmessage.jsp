<%@ page language="java" contentType="text/html; charset=ISO-8859-1" import="java.util.*,java.io.*,com.employee.Employeedetails"  pageEncoding="ISO-8859-1"%>
<jsp:useBean id="Empd" scope="request" class="com.employee.Employeedetails"/> 
<%
Integer UserId = (Integer)session.getAttribute("SessionUserId");
String SessionUserName = (String)session.getAttribute("SessionUserName");
if(SessionUserName == null) SessionUserName = "";
String SessionUserEmail = (String)session.getAttribute("SessionUserEmail");

//System.out.println("SessionUserId>>"+UserId);
//System.out.println("SessionUserName>>"+SessionUserName);
//System.out.println("SessionUserEmail>>"+SessionUserEmail);

String strHidmode = request.getParameter("hidmode");
if(strHidmode == null) strHidmode = "";
String messageVal = request.getParameter("hidMsgContent");	
if(messageVal == null) messageVal = "";
String hidPublicVal = request.getParameter("hidPublic");	
if(hidPublicVal == null) hidPublicVal = "";
String hidPrivateVal = request.getParameter("hidPrivate");	
if(hidPrivateVal == null) hidPrivateVal = "";
String resultMsg = "";
List lstPostMessage = new ArrayList();

int lstUserId = 0;
String lstContent = "";
String lstCreatedDate = "";
int lstIsVisibilityPublic = 0;
int lstIsVisibilityPrivate = 0;


	if(strHidmode.trim().equals("POST_MESSAGE")) 
	{
		try
		{
	    	resultMsg = Empd.insertPostMessage(UserId, messageVal, Integer.parseInt(hidPublicVal),Integer.parseInt(hidPrivateVal));
	    	//System.out.println("resultMsg>>"+resultMsg);
			
		}catch(Exception e)
		{
			System.out.println("Exception while logging into the signup page :: "+e);
		}
	}
	lstPostMessage = Empd.getPostMessageList(UserId);
	//System.out.println("lstPostMessage>>"+lstPostMessage.size());
	

%>

<!DOCTYPE html>
<html>
<head>
 <style>
 .mandatory
	{
	  color:#cc0000;
	  font-size:20px;
	  vertical-align: middle;
	}
 </style>
<title>Posts</title>
<script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
</head>
<body>
		<form name="frmPostMessage" id= "frmPostMessage"  method="post" autocomplete = "off">
			<div class = "container">
				<div style="margin-top:30px;"></div>
		
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 hidden-xs hidden-sm">
					        <div class="d-flex justify-content-between">
							  <h2>Post Message</h2>
							  <label><span class="badge badge-secondary" style="cursor:pointer;padding: 8px;" onclick="javascript:funLogout()">Logout</span></label>
							</div>
							
							 <div class="d-flex justify-content-between">
							 <h4><span class="badge badge-primary"><%=SessionUserName%></span></h4>
							  <label><span class="badge badge-warning" style="cursor:pointer;padding: 8px;" onclick="javascript:funChangePassword()">Change Password</span></label>
							</div>
			
					         
					        <div class="form-group">
							    <label for="message">Write your message:</label>
							      	<textarea class="form-control" id="message" rows="10" cols="90" style="resize: none;" placeholder="Enter your message here..." onkeyup= "javascript:funEnablePost();"></textarea>
							  </div>
							  <div class="form-group">
			                         <div data-toggle="buttons" class="btn-group">
				                             <label style="color: #212529;"><input type="radio" id="option1" name="options" checked  style="cursor: pointer" value="PU"> Public </label>&nbsp;&nbsp;&nbsp;
				                             <label style="color: #212529;"><input type="radio" id="option2" name="options"   style="cursor: pointer" value="PT"> Private </label>
				                         </div>
				                   </div>	
				                    <div class="form-group">
								    <button type="button" class="btn btn-success"  name="btnPost" id= "btnPost" disabled onclick="javascript:funPostMessage()">Post</button>
								    <button type="button" class="btn btn-secondary btn-md" name="btnCancel" id="btnCancel" onclick="javascript:funCancel()" data-toggle="tooltip" title = "Click to Cancel" data-placement="bottom">Cancel</button>
								    </div>
								</div>
				        	</div>
        				<%
						if (lstPostMessage.size() > 0)
						{
						%>
        				<div class="table-responsive">
							<table class="table table-striped table-bordered table-hover" data-paging="false" data-filter=#filter id="tablelist">
								<thead>
                             		<tr>
                                 		<th class="text-center">Message</th>
                                 		<th class="text-center">Created Date</th>                                        
                             		</tr>
                        			</thead>
								<tbody>
									<%
										for (int count = 0; count < lstPostMessage.size(); count++) 
										{
											Empd = (Employeedetails) lstPostMessage.get(count);
											lstUserId = Empd.getUser_id();
											lstContent = Empd.getContent();
											lstIsVisibilityPublic = Empd.getIs_visibility_public();
											lstIsVisibilityPrivate = Empd.getIs_visibility_private();
											lstCreatedDate = Empd.getCreated_date();
											
											//out.println("availableCount :: "+availableCount);
									  %>
									<tr class="gradeX">
				 						<td>&nbsp;&nbsp;
					 						<%=lstContent%>
				 						</td>
				 						<td align="center">&nbsp;&nbsp;
				 	 						<%=lstCreatedDate%>
			 	 						</td>
									</tr>
									<%
										}
									%>
								</tbody>
							</table>
						</div>
						<%} %>
						
					<div class="modal fade" id="modalPwd" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
							    <div class="modal-header">
							     	<h4 class="modal-title" id="myModalLabel">Change Password</h4>
							        <button type="button" title="Close (Esc)" onclick="javascript:funClosePwd();" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
							    </div>
							    <div class="modal-body">
							    	<div class="row">
										<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
											<div class="form-group">
												<label>Old Password&nbsp;<span class="mandatory">*</span></label>
												<input type="password" class="form-control" name="txtOldPwd" id="txtOldPwd" value="" maxlength="255" onkeyup= "javascript:funBtnEnablePassword();">
											</div>
											<div class="form-group">
												<label>New Password &nbsp;<span class="mandatory">*</span></label>
												<input type="password" class="form-control" name="txtNewPwd" id="txtNewPwd" value="" maxlength="255" onkeyup= "javascript:funBtnEnablePassword();">
											</div>
											<div class="form-group">
												<label>Re-Enter New Password &nbsp;<span class="mandatory">*</span></label>
												<input type="password" class="form-control" name="txtReEnterNewPwd" id="txtReEnterNewPwd" value="" maxlength="255" onkeyup= "javascript:funBtnEnablePassword();">
											</div>
										</div>
									</div>
							    </div>
							    <div class="modal-footer" style="margin-top:-15px;">
			        				<button type="button" class="btn btn-success" name= "btnPwdSave" id= "btnPwdSave" onclick="javascript:funSaveChangePassword();" disabled value="Save">Save</button>
			        				<button type="button" class="btn btn-secondary" data-dismiss="modal"  onclick="javascript:funClosePwd();">Close</button>
				  				</div>
						  </div>
						</div>
					 </div>
			</div>
					
        <input type="hidden" id="hidmode" name="hidmode">
        <input type="hidden" id="hidMsgContent" name="hidMsgContent" value="">
        <input type="hidden" id="hidPublic" name="hidPublic" value="0">
        <input type="hidden" id="hidPrivate" name="hidPrivate" value="0">
        
        <input type="hidden" id="hidOldPwd" name="hidOldPwd" value="">
        <input type="hidden" id="hidNewPwd" name="hidNewPwd" value="">
        <input type="hidden" id="hidReNewPwd" name="hidReNewPwd" value="">
            
    </form>
</body>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script> 
<script type="text/javascript">

$(document).ready(function() {
	
	$("#message").focus();
	
	var msgVal = '<%=resultMsg%>';
	
	if(msgVal!="")
	{
		alert(msgVal);	
	}
	
	$('#modalPwd').on('shown.bs.modal', function () 
   	{
   		$('#txtOldPwd').focus();
   		$("#txtOldPwd").val("");
   		$("#txtNewPwd").val("");
   		$("#txtReEnterNewPwd").val("");
    });
});

function funEnablePost()
{
	var messageVal = $.trim($("#message").val());
   	if(messageVal != "")
	{
		$("#btnPost").attr('disabled', false);
	}
	else
	{
		$("#btnPost").attr('disabled', true);
	}
}

function funPostMessage()
{
	var messageVal = $.trim($("#message").val());
	//alert("messageVal>>"+messageVal);
	$("#hidMsgContent").val(messageVal);
	var optionsVal = $.trim($('input[name="options"]:checked').val());
	//alert("optionsVal>>"+optionsVal);
	
	if(optionsVal=="PU")
 	{
		$("#hidPrivate").val("0");
		$("#hidPublic").val("1");
 	}
	else if(optionsVal=="PT")
	{
		$("#hidPublic").val("0");
		$("#hidPrivate").val("1");
	}
	else
	{
		$("#hidPublic").val("0");
		$("#hidPrivate").val("0");
	}
   	if(messageVal != "")
	{
		$("#hidmode").val("POST_MESSAGE");
		$("#frmPostMessage").attr("action","./postmessage.jsp");   	                
		$("#frmPostMessage").submit();
	}
}

function funCancel()
{
	$("#message").val("");
	$("#message").focus();
}

function funLogout()
{
	$("#frmPostMessage").attr("action","./login.jsp");   	                
	$("#frmPostMessage").submit();
}

function funChangePassword()
{
	$("#modalPwd").modal("show");
}

function funBtnEnablePassword()
{
	var txtOldPwdVal = $.trim($("#txtOldPwd").val()); 
   	var txtNewPwdVal = $.trim($("#txtNewPwd").val());
   	var txtReEnterNewPwdVal = $.trim($("#txtReEnterNewPwd").val());
	if(txtOldPwdVal != "" && txtNewPwdVal != "" && txtReEnterNewPwdVal !="")
	{
		$("#btnPwdSave").attr('disabled', false);
	}
	else
	{
		$("#btnPwdSave").attr('disabled', true);
	}
}

function funClosePwd()
{
	$("#txtOldPwd").val("");
	$("#txtNewPwd").val("");
	$("#txtReEnterNewPwd").val("");
}

function funSaveChangePassword()
{
	$("#modalPwd").modal("hide");
	var txtOldPwdVal = $.trim($("#txtOldPwd").val()); 
   	var txtNewPwdVal = $.trim($("#txtNewPwd").val());
   	var txtReEnterNewPwdVal = $.trim($("#txtReEnterNewPwd").val())

   	$("#hidOldPwd").val(txtOldPwdVal);
  	$("#hidNewPwd").val(txtNewPwdVal);
  	$("#hidReNewPwd").val(txtReEnterNewPwdVal);
   	
   	
		  $.ajax({
		   type			: "POST", 
		   url			: "changepasswordajax.jsp", 
		   data			:  $("form#frmPostMessage").serialize(),
		   async		:  false,
		   beforeSend	: function() {
		 	  //$('#screenload').show();
		   },
		   complete: function() {						
			  //$('#screenload').hide();
		   },
		   success: function(msg) 
		   {
			   if($.trim(msg != ""))
			   {
				   alert(msg);
			   } 
		   }
		});
}
</script>
</html>
