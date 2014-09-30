<%@ Page Language="C#" %>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>OS Stats</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
select Comments as Name, decode(stat_name, 
  'PHYSICAL_MEMORY_BYTES', round(VALUE/1024/1024/1024,0) || 'GB',
  'LOAD', ROUND(VALUE, 0),
  VALUE) as Value from V$OSSTAT
where STAT_NAME IN ('NUM_CPUS', 'NUM_CPU_SOCKETS', 'LOAD', 'PHYSICAL_MEMORY_BYTES')
"></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No waits
                    </EmptyDataTemplate>
                </asp:GridView>            
    </form>
</body>    
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</html>
