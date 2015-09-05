insert into weibo.dbo.NBT2([msgID]) VALUES ('3154515476193867');

truncate table weibo.dbo.NBT2;

select count(*) from weibo.dbo.NBT2;

select count(*) from weibo.dbo.NBT;

drop table weibo.dbo.NBTold;

select top 1 [msgID] from weibo.dbo.NBT2;