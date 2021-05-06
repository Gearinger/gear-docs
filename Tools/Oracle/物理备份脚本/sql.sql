conn / as sysdba;

spool filepath.txt

select file_name name from dba_data_files 
UNION
select member name from v$logfile 
UNION
select name name From v$controlfile;

spool off;

exit;