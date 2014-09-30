<%@ Page Language="C#" EnableViewState="false" %>
<%@ OutputCache NoStore="true" Location="None" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Top Buffer Gets</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
 <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
 select * from
(select 
rank() over ( order by (buffer_gets / executions) desc ) as rank,
to_char(100 * ratio_to_report(buffer_gets) over (), '999.99') pct_bufgets,
trunc(buffer_gets / executions, 0) &quot;Avg Buffer Gets&quot;,
executions,
USERS_EXECUTING &quot;Users Executing&quot;,
trunc(cpu_time / 1000000 / executions, 2) &quot;Avg CPU&quot;,
trunc(elapsed_time / 1000000 / executions, 2) &quot;Avg Elapsed&quot;,
sql_text,
round(parse_calls / executions, 1) &quot;Avg Parse&quot;,
trunc(disk_reads / executions, 0) &quot;Avg Disk Read&quot;,
trunc(direct_writes / executions, 0) &quot;Avg Direct write&quot;,
trunc(concurrency_wait_time / 1000000, 2) &quot;Concurrent Wait time&quot;,
trunc(USER_IO_WAIT_TIME / 1000000, 2) &quot;User IO wait time&quot;,
trunc(plsql_exec_time / 1000000, 2) &quot;PLSQL wait&quot;,
rows_processed &quot;Rows Processed&quot;,
OPTIMIZER_COST &quot;Optimizer Cost&quot;,
module 
from V$sql 
where executions > 0)
where                    
                    rank < 11
                                        "></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <Columns>
                        <asp:TemplateField>
                            
                        </asp:TemplateField>
                    </Columns>                    
                </asp:GridView>            
    </form>
    <script src="js/ScriptsForWidgets.js"></script>
        <script>
            //refreshEvery(15000);
            applyLargeCells('td:eq(8)');            
    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</body>
    
</html>
