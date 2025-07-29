login/signup

Table structure

CREATE TABLE users (
[user_id] INT IDENTITY(1,1) PRIMARY KEY,
first_name varchar(50) not null default '',
last_name varchar(50) not null default '' ,
username varchar(100) not null default '',
email varchar(100) not null default '',
[password] varchar(255),
[reenter_password] varchar(255),
[Created_Date] DATETIME DEFAULT GETDATE()
)


CREATE TABLE postmessage (
  [post_message_id] INT IDENTITY (1,1) PRIMARY KEY,
  [user_id] INT DEFAULT 0,
  [content] NVARCHAR (max),
  [is_visibility_public] INT DEFAULT 0,
  [is_visibility_private] INT DEFAULT 0,
  [created_date] DATETIME DEFAULT GETDATE()
);

CREATE TABLE password_history (
  [password_history_id] INT IDENTITY(1,1) PRIMARY KEY,
  [user_id] INT,
  [old_password] VARCHAR(255),
  changed_at DATETIME DEFAULT GETDATE() --,
 
);

SELECT * FROM users



INSERT INTO users ([first_name] , [last_name] , [username], [email],[password])
		VALUES ('Sowmi', 'b','sowmi b ','tt@gmail.com','abc')


