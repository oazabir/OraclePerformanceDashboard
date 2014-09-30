1. Create a IIS website. 
2. Copy and paste all the files to it. 
3. Open web.config and add connection strings to your Oracle instance. 
	Put a connection string with a user who has SYSDBA role.      
    Create connection string using EZCONNECT format     
    this format specifies the server and the Oracle     
    service name as the datasource     
    using the format: server/oracle service name     
    no tnsnames.ora or sqlnet.ora file is needed.            