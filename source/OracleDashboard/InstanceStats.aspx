<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Instance Statistics</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
with AASSTAT as (
  select
  decode(n.wait_class,'User I/O','User I/O',
  'Commit','Commit',
  'Wait') CLASS,
  sum(round(m.time_waited/m.INTSIZE_CSEC,3)) AAS,
  BEGIN_TIME ,
  END_TIME
  from v$waitclassmetric m,
  v$system_wait_class n
  where m.wait_class_id=n.wait_class_id
  and n.wait_class != 'Idle'
  group by decode(n.wait_class,'User I/O','User I/O', 'Commit','Commit', 'Wait'), BEGIN_TIME, END_TIME
  union
  select 'CPU_ORA_CONSUMED' CLASS,
  round(value/100,3) AAS,
  BEGIN_TIME ,
  END_TIME
  from v$sysmetric
  where metric_name='CPU Usage Per Sec'
  and group_id=2
  union
  select 'CPU_OS' CLASS ,
  round((prcnt.busy*parameter.cpu_count)/100,3) AAS,
  BEGIN_TIME ,
  END_TIME
  from
  ( select value busy, BEGIN_TIME,END_TIME from v$sysmetric where metric_name='Host CPU Utilization (%)' and group_id=2 ) prcnt,
  ( select value cpu_count from v$parameter where name='cpu_count' ) parameter
  union
  select
  'CPU_ORA_DEMAND' CLASS,
  nvl(round( sum(decode(session_state,'ON CPU',1,0))/60,2),0) AAS,
  cast(min(SAMPLE_TIME) as date) BEGIN_TIME ,
  cast(max(SAMPLE_TIME) as date) END_TIME
  from v$active_session_history ash
  where SAMPLE_TIME >= (select BEGIN_TIME from v$sysmetric where metric_name='CPU Usage Per Sec' and group_id=2 )
  and SAMPLE_TIME < (select END_TIME from v$sysmetric where metric_name='CPU Usage Per Sec' and group_id=2 )
)
select
  to_char(BEGIN_TIME,'HH:MI:SS') BEGIN_TIME,
  to_char(END_TIME,'HH:MI:SS') END_TIME,
  ( decode(sign(CPU_OS-CPU_ORA_CONSUMED), -1, 0, (CPU_OS - CPU_ORA_CONSUMED )) +
  CPU_ORA_CONSUMED +
  decode(sign(CPU_ORA_DEMAND-CPU_ORA_CONSUMED), -1, 0, (CPU_ORA_DEMAND - CPU_ORA_CONSUMED ))) CPU_TOTAL,
  decode(sign(CPU_OS-CPU_ORA_CONSUMED), -1, 0, (CPU_OS - CPU_ORA_CONSUMED )) CPU_OS,
  CPU_ORA_CONSUMED CPU_ORA,
  decode(sign(CPU_ORA_DEMAND-CPU_ORA_CONSUMED), -1, 0, (CPU_ORA_DEMAND - CPU_ORA_CONSUMED )) CPU_ORA_WAIT,
  COMMIT,
  READIO,
  WAIT
from (
select
  min(BEGIN_TIME) BEGIN_TIME,
  max(END_TIME) END_TIME,
  sum(decode(CLASS,'CPU_ORA_CONSUMED',AAS,0)) CPU_ORA_CONSUMED,
  sum(decode(CLASS,'CPU_ORA_DEMAND' ,AAS,0)) CPU_ORA_DEMAND,
  sum(decode(CLASS,'CPU_OS' ,AAS,0)) CPU_OS,
  sum(decode(CLASS,'Commit' ,AAS,0)) COMMIT,
  sum(decode(CLASS,'User I/O' ,AAS,0)) READIO,
  sum(decode(CLASS,'Wait' ,AAS,0)) WAIT
from AASSTAT)
                    "></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No Locks
                    </EmptyDataTemplate>               
                </asp:GridView>            
    </form>
</body>
    <script src="js/ScriptsForWidgets.js"></script>
    <script>
        refreshEvery(60000);
    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</html>
