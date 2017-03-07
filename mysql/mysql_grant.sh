#DBA
create user 'dba'@'%' identified by 'dba@OPS';
grant all on *.* to 'dba'@'%' with grant option;
