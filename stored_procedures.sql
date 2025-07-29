USE [SampleDB]
GO
/****** Object:  StoredProcedure [dbo].[USP_Login_Details]    Script Date: 29-07-2025 17:25:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_Login_Details]
	@User_Id INT,
	@First_Name VARCHAR(50),
	@Last_Name VARCHAR(50),
  @User_Name VARCHAR(100),
	@Email VARCHAR(100),
	@Password VARCHAR(255),
	@ReEnter_Password VARCHAR(255),
	@Message_Content NVARCHAR(MAX),
	@Extra_INT_Param INT,
	@Extra_INT_Param1 INT,
	@Mode VARCHAR(100)
  AS
BEGIN

	IF @Mode = 'INSERT_USER_DETAILS'
	BEGIN	
		INSERT INTO users ([first_name] , [last_name] , [username], [email],[password], [reenter_password])
		VALUES (@First_Name, @Last_Name,@User_Name,@Email,@Password,@ReEnter_Password)
	END
	ELSE IF @Mode = 'LIST_USER_DETAILS'
	BEGIN	
		SELECT [user_id] , [first_name] , [last_name] , [username] , [email] , [password] , [reenter_password]  
		FROM dbo.users WHERE email = @Email
	END
	ELSE IF @Mode = 'INSERT_POST_MESSAGE'
	BEGIN	
		INSERT INTO postmessage ([user_id] , [content] , [is_visibility_Public], [is_visibility_Private])
		VALUES (@User_Id,@Message_Content,@Extra_INT_Param,@Extra_INT_Param1)
	END
	ELSE IF @Mode = 'LIST_POST_MESSAGE'
	BEGIN	
		SELECT [user_id] , [content] , [is_visibility_public], [is_visibility_private] ,
		CASE WHEN CONVERT(VARCHAR(10),created_date,121) = '1900-01-01' THEN ''
		ELSE CONVERT(VARCHAR(10),created_date,101) END AS created_date
		FROM dbo.postmessage WHERE is_visibility_Public = 1 OR  [user_id] = @User_Id

	END
	
END;

