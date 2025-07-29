package com.employee;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Employeedetails {
	
	public static Connection con = null; 
	CallableStatement Cs = null;
	ResultSet Rs = null;
	PreparedStatement Pst =null;
	
	public static Connection getConnection()
	 {
	  try
	  {
		  DBConnection db = new DBConnection();
		  con = db.getNewDBConnection();
		 // System.out.println("con in employee deta:::::::::>"+con);
	  }
	  catch(Exception exp)
	  {
	    System.out.println("Exception while getting connection"+exp.getMessage());
	  }
	 
	 return con;
	 }
	
	// INSERT USER DETAILS
	public String insertUserDetails(String firstName, String lastName , String email, String password,String rePassword) 
	{
		String result = "";
		try 
		{
			con = getConnection();
            if (con != null) 
            {
                Cs = con.prepareCall("{call USP_Login_Details(0, ?, ?, ?, ?, ?, ?, '' , 0 , 0 ,'INSERT_USER_DETAILS')}");
                Cs.setString(1, firstName);
                Cs.setString(2, lastName);
                Cs.setString(3, firstName+ " "+lastName);
                Cs.setString(4, email);
                Cs.setString(5, password);
                Cs.setString(6, rePassword);
                Cs.execute();
                result = "Your account was created successfully! Please sign in to continue.";
            } 
            else 
            {
                System.out.println(" Connection is null.");
            }
        } 
		catch (Exception e) 
		{
			System.out.println("Exception while inserting record in  insertUserDetails  >>> "+e.getMessage());
            e.printStackTrace();
        }
        return result;
    }
	
	// LISTING USER DETAILS AFTER SIGN UP
	public List getuserdetails(String userEmail)
	{
		String strResult = "";
		Employeedetails obj = null;
		List<Employeedetails> lstPerson = new ArrayList<Employeedetails>();
		
		try
		{
			con = getConnection();
			Cs = con.prepareCall("{call USP_Login_Details(0, '', '', '', ?,'', '', '' , 0 , 0, 'LIST_USER_DETAILS')}");
			Cs.setString(1, userEmail);
			Rs = Cs.executeQuery();
			while(Rs.next())
			{
				obj = new Employeedetails();
				obj.setUser_id(Rs.getInt("user_id"));
				obj.setFirst_name(Rs.getString("first_name"));
				obj.setLast_name(Rs.getString("last_name"));
				obj.setUsername(Rs.getString("username"));
				obj.setEmail(Rs.getString("email"));
				obj.setPassword(Rs.getString("password"));
				obj.setReenter_password(Rs.getString("reenter_password"));
				lstPerson.add(obj);
			}
		}
		catch(Exception e)
		{
			 System.out.println("Exception while getting getuserdetails >>> "+e.getMessage());
		}
		return lstPerson;
	}
	
	// INSERT POST MESSAGE DETAILS
	public String insertPostMessage(int userId, String messageContent, int isPublic, int isPrivate) 
	{
		String msg = "";
		
		try 
		{
			con = getConnection();
            Cs = con.prepareCall("{call USP_Login_Details(?, '', '', '', '','', '', ? , ? , ? ,'INSERT_POST_MESSAGE')}");
            Cs.setInt(1, userId);
            Cs.setString(2, messageContent);
            Cs.setInt(3, isPublic);
            Cs.setInt(4, isPrivate);
            Cs.execute();
            msg = "Post Message Saved Successfully";
           
        } catch (Exception e) 
		{
        	System.out.println("Exception while inserting record in insertPostMessage  >>> "+e.getMessage());
            e.printStackTrace();
        }
        return msg;
    }
	
		// LISTING POST MESSAGE LIST BASED ON USER ID
		public List getPostMessageList(int userId)
		{
			String strResult = "";
			Employeedetails obj = null;
			List<Employeedetails> lstPostMessage = new ArrayList<Employeedetails>();
			
			try
			{
				con = getConnection();
				Cs = con.prepareCall("{call USP_Login_Details(?, '', '', '', '','', '', '' , 0 , 0, 'LIST_POST_MESSAGE')}");
				Cs.setInt(1, userId);
				Rs = Cs.executeQuery();
				while(Rs.next())
				{
					obj = new Employeedetails();
					obj.setUser_id(Rs.getInt("user_id"));
					obj.setContent(Rs.getString("content"));
					obj.setIs_visibility_public(Rs.getInt("is_visibility_public"));
					obj.setIs_visibility_private(Rs.getInt("is_visibility_private"));
					obj.setCreated_date(Rs.getString("created_date"));
					lstPostMessage.add(obj);
				}
			}
			catch(Exception e)
			{
				 System.out.println("Exception while getting getPostMessageList >>> "+e.getMessage());
			}
			return lstPostMessage;
		}
	
		//Change Password
		public String changePassword(int userId, String oldPassword, String newPassword) 
		{
			String msg = "";
			int count = 0;
		
			try 
			{
				   con = getConnection();
			      // checking old password
			      PreparedStatement ps1 = con.prepareStatement("SELECT password FROM users WHERE user_id = ?");
			      ps1.setInt(1, userId);
			      ResultSet rs1 = ps1.executeQuery();

			      if (!rs1.next() || !rs1.getString("password").trim().equals(oldPassword.trim())) 
			      {
			    	  msg = "Old password is incorrect." ;
			      }

			      //System.out.println("newPassword in java "+newPassword);
			      
			      // Check if new password is among the last 3 used
			      PreparedStatement ps2 = con.prepareStatement("SELECT TOP 3 old_password FROM password_history WHERE user_id = ? ORDER BY changed_at DESC");
			      ps2.setInt(1, userId);
			      ResultSet rs2 = ps2.executeQuery();
			      while (rs2.next()) 
			      {
			    	  	//System.out.println("inside while" );
			    	   String oldUsedPassword  = rs2.getString("old_password").trim();
			    	    
			    	   // System.out.println("oldUsedPassword >>"+oldUsedPassword );
			    	   // System.out.println("newPassword >>"+newPassword );
			    	    if (oldUsedPassword != null && oldUsedPassword.trim().equals(newPassword.trim())) 
			    	    {
			    	    	// System.out.println("inside going >>"+newPassword );
			    	    	 msg = "New password must not match any of your last 3 passwords.";
			    	    	 count= 1;
			    	    }
				 } 		      
			     if(count == 0 )
			     {
			      //  Save current password to history
			     PreparedStatement ps3 = con.prepareStatement("INSERT INTO password_history (user_id, old_password) VALUES (?, ?)");
			      ps3.setInt(1, userId);
			      ps3.setString(2, oldPassword);
			      ps3.executeUpdate();
	
			      //  Update new password
			      PreparedStatement ps4 = con.prepareStatement("UPDATE users SET password = ? , reenter_password = ? WHERE user_id = ?");
			      ps4.setString(1, newPassword);
			      ps4.setString(2, newPassword);
			      ps4.setInt(3, userId);
			      ps4.executeUpdate();
			      msg = "Password Changed successfully";
			     }
		    } 
			catch (Exception e) 
			{
				 System.out.println("Exception while changing the password  >>> "+e.getMessage());
				 e.printStackTrace();
		    }
			return msg;
		 }
		
	private int user_id;
	private String first_name;
	private String last_name;
	private String username;
	private String email;
	private String password;
	private String reenter_password;
	private String content;
	private int is_visibility_public;
	private int is_visibility_private;
	private String created_date;

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public String getFirst_name() {
		return first_name;
	}

	public void setFirst_name(String first_name) {
		this.first_name = first_name;
	}

	public String getLast_name() {
		return last_name;
	}

	public void setLast_name(String last_name) {
		this.last_name = last_name;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getReenter_password() {
		return reenter_password;
	}

	public void setReenter_password(String reenter_password) {
		this.reenter_password = reenter_password;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getIs_visibility_public() {
		return is_visibility_public;
	}

	public void setIs_visibility_public(int is_visibility_public) {
		this.is_visibility_public = is_visibility_public;
	}

	public int getIs_visibility_private() {
		return is_visibility_private;
	}

	public void setIs_visibility_private(int is_visibility_private) {
		this.is_visibility_private = is_visibility_private;
	}

	public String getCreated_date() {
		return created_date;
	}

	public void setCreated_date(String created_date) {
		this.created_date = created_date;
	}
	
}
