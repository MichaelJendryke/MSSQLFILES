SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NBT2](
	[idNearByTimeLine] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[SeasonID] [int] NULL,
	[FieldID] [int] NULL,
	[FieldGroupID] [int] NULL,
	[createdAT] [datetime2](0) NULL,
	[msgID] [bigint] UNIQUE NOT NULL,
	[msgmid] [bigint] NULL,
	[msgidstr] [bigint] NULL,
	[msgtext] [nvarchar](512) NULL,
	[msgin_reply_to_status_id] [bigint] NULL,
	[msgin_reply_to_user_id] [bigint] NULL,
	[msgin_reply_to_screen_name] [nvarchar](45) NULL,
	[msgfavorited] [smallint] NULL,
	[msgsource] [varbinary](128) NULL,
	[geoTYPE] [nvarchar](25) NULL,
	[geoLAT] [numeric](9, 6) NULL,
	[geoLOG] [numeric](9, 6) NULL,
	[distance] [int] NULL,
	[userID] [bigint] NULL,
	[userscreen_name] [nvarchar](256) NULL,
	[userprovince] [int] NULL,
	[usercity] [int] NULL,
	[userlocation] [nvarchar](45) NULL,
	[userdescription] [nvarchar](45) NULL,
	[userfollowers_count] [int] NULL,
	[userfriends_count] [int] NULL,
	[userstatuses_count] [int] NULL,
	[userfavourites_count] [int] NULL,
	[usercreated_at] [datetime2](0) NULL,
	[usergeo_enabled] [smallint] NULL,
	[userverified] [smallint] NULL,
	[userbi_followers_count] [int] NULL,
	[userlang] [nvarchar](45) NULL,
	[userclient_mblogid] [nvarchar](45) NULL,
	[nearbytimelinecol] [nvarchar](45) NULL,
	[RowADDEDtime] [datetime] NOT NULL)

GO

SET ANSI_PADDING OFF
GO

