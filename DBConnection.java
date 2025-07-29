//connecting the java with sql server with return connection 

package com.employee;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	 String strDriver;
	 String strUrl;
	 String strUsr;
	 String strPwd;
	 
	 public  DBConnection()
	 {
		 strUrl = "jdbc:sqlserver://DESKTOP-K9GI2KA:1433;instanceName=SQLEXPRESS01;databaseName=SampleDB;encrypt=true;trustServerCertificate=true";
		 strUsr = "sa";
		 strPwd = "sowmi123";
	 }

	 public Connection getNewDBConnection()
	 {
	  Connection con = null; 
	   try 
	   {
            // Load driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // Connect
            con = DriverManager.getConnection(strUrl, strUsr, strPwd);

	    }catch (ClassNotFoundException | SQLException e) 
	    {
	         e.printStackTrace();
	    }
	        
	    return con;
	 }

}
